Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684B92EC34B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbhAFSkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbhAFSkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:40:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F6723132;
        Wed,  6 Jan 2021 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609958414;
        bh=T9ZCTKpmGSnUw53mKVrZVPldMGN72kA4kpFQX1gW0GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTF1rS9ysaq72jZtolgUyGrJ7dkoTP9uTi4ZUNixWoE21DCR7FuSnunvuwsv09foL
         iuxAOLHvy6V2tRlc6Sb6sO8aNFyz9rQbrj+0bjJkpnuxQsoZRO58CU1I2fXK64Utun
         7GNzpG4iFUQJEXzai63qFSLfwzwoO8TB06CSBFmkSFryZ1hV5eESpBWq+1DCd/bAtb
         pxs4FqeJxV5Ei2iYI4GvOKjs0zpXGg3oS7uRAWXAOYV6GGh/ILl6YR1WukckMTWa4a
         rt4W2FvXcwjHUe7WK1+6R6Uv5280mBGs3XloePW2qpku6QmIsCVZx6GQAtI2pvg8nd
         lAuWrJZngEHTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com, xiyou.wangcong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] net: make free_netdev() more lenient with unregistering devices
Date:   Wed,  6 Jan 2021 10:40:06 -0800
Message-Id: <20210106184007.1821480-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106184007.1821480-1-kuba@kernel.org>
References: <20210106184007.1821480-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two flavors of handling netdev registration:
 - ones called without holding rtnl_lock: register_netdev() and
   unregister_netdev(); and
 - those called with rtnl_lock held: register_netdevice() and
   unregister_netdevice().

While the semantics of the former are pretty clear, the same can't
be said about the latter. The netdev_todo mechanism is utilized to
perform some of the device unregistering tasks and it hooks into
rtnl_unlock() so the locked variants can't actually finish the work.
In general free_netdev() does not mix well with locked calls. Most
drivers operating under rtnl_lock set dev->needs_free_netdev to true
and expect core to make the free_netdev() call some time later.

The part where this becomes most problematic is error paths. There is
no way to unwind the state cleanly after a call to register_netdevice(),
since unreg can't be performed fully without dropping locks.

Make free_netdev() more lenient, and defer the freeing if device
is being unregistered. This allows error paths to simply call
free_netdev() both after register_netdevice() failed, and after
a call to unregister_netdevice() but before dropping rtnl_lock.

Simplify the error paths which are currently doing gymnastics
around free_netdev() handling.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/8021q/vlan.c     |  4 +---
 net/core/dev.c       | 11 +++++++++++
 net/core/rtnetlink.c | 23 ++++++-----------------
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 15bbfaf943fd..8b644113715e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -284,9 +284,7 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
-	    new_dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(new_dev);
+	free_netdev(new_dev);
 	return err;
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..adde93cbca9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10631,6 +10631,17 @@ void free_netdev(struct net_device *dev)
 	struct napi_struct *p, *n;
 
 	might_sleep();
+
+	/* When called immediately after register_netdevice() failed the unwind
+	 * handling may still be dismantling the device. Handle that case by
+	 * deferring the free.
+	 */
+	if (dev->reg_state == NETREG_UNREGISTERING) {
+		ASSERT_RTNL();
+		dev->needs_free_netdev = true;
+		return;
+	}
+
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 79f514afb17d..3d6ab194d0f5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3439,26 +3439,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	dev->ifindex = ifm->ifi_index;
 
-	if (ops->newlink) {
+	if (ops->newlink)
 		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-		/* Drivers should set dev->needs_free_netdev
-		 * and unregister it on failure after registration
-		 * so that device could be finally freed in rtnl_unlock.
-		 */
-		if (err < 0) {
-			/* If device is not registered at all, free it now */
-			if (dev->reg_state == NETREG_UNINITIALIZED ||
-			    dev->reg_state == NETREG_UNREGISTERED)
-				free_netdev(dev);
-			goto out;
-		}
-	} else {
+	else
 		err = register_netdevice(dev);
-		if (err < 0) {
-			free_netdev(dev);
-			goto out;
-		}
+	if (err < 0) {
+		free_netdev(dev);
+		goto out;
 	}
+
 	err = rtnl_configure_link(dev, ifm);
 	if (err < 0)
 		goto out_unregister;
-- 
2.26.2

