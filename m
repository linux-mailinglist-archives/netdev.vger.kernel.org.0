Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC210659E
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfKVFvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbfKVFvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6DC120726;
        Fri, 22 Nov 2019 05:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401869;
        bh=EHE3Ew+coMhAAVPChOkrPQ2lLCcUeXZQLgaU2uMCdrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW0OG3R+loxyWXsPaGpgzCYu/ULCZ5fQNpxQZ5w6dH5mmBnUoWj9v2N9lb4/T/vzc
         J17a/USVxA0pq6WEVorlobi0wHP53EdIzm6N06x1CNhH1+tMuqo5ceHWx564jXIWS3
         gK1FEI0uq+FnjHVvQSaYROKoCJX8dRQduY5P4jF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 105/219] vxlan: Fix error path in __vxlan_dev_create()
Date:   Fri, 22 Nov 2019 00:47:17 -0500
Message-Id: <20191122054911.1750-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 6db9246871394b3a136cd52001a0763676563840 ]

When a failure occurs in rtnl_configure_link(), the current code
calls unregister_netdevice() to roll back the earlier call to
register_netdevice(), and jumps to errout, which calls
vxlan_fdb_destroy().

However unregister_netdevice() calls transitively ndo_uninit, which is
vxlan_uninit(), and that already takes care of deleting the default FDB
entry by calling vxlan_fdb_delete_default(). Since the entry added
earlier in __vxlan_dev_create() is exactly the default entry, the
cleanup code in the errout block always leads to double free and thus a
panic.

Besides, since vxlan_fdb_delete_default() always destroys the FDB entry
with notification enabled, the deletion of the default entry is notified
even before the addition was notified.

Instead, move the unregister_netdevice() call after the manual destroy,
which solves both problems.

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 2a536f84d5f69..d8a56df3933f0 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3213,6 +3213,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f = NULL;
+	bool unregister = false;
 	int err;
 
 	err = vxlan_dev_configure(net, dev, conf, false, extack);
@@ -3238,12 +3239,11 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	err = register_netdevice(dev);
 	if (err)
 		goto errout;
+	unregister = true;
 
 	err = rtnl_configure_link(dev, NULL);
-	if (err) {
-		unregister_netdevice(dev);
+	if (err)
 		goto errout;
-	}
 
 	/* notify default fdb entry */
 	if (f)
@@ -3251,9 +3251,16 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 
 	list_add(&vxlan->next, &vn->vxlan_list);
 	return 0;
+
 errout:
+	/* unregister_netdevice() destroys the default FDB entry with deletion
+	 * notification. But the addition notification was not sent yet, so
+	 * destroy the entry by hand here.
+	 */
 	if (f)
 		vxlan_fdb_destroy(vxlan, f, false);
+	if (unregister)
+		unregister_netdevice(dev);
 	return err;
 }
 
-- 
2.20.1

