Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A365E41BFDA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244651AbhI2H23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:29 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33062 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbhI2H22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:28 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 5521D20272; Wed, 29 Sep 2021 15:26:46 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 01/10] mctp: Allow MCTP on tun devices
Date:   Wed, 29 Sep 2021 15:26:05 +0800
Message-Id: <20210929072614.854015-2-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allowing TUN is useful for testing, to route packets to userspace or to
tunnel between machines.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c |  7 +++++--
 net/mctp/route.c  | 13 ++++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index b9f38e765f61..c34963974cc1 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -356,9 +356,12 @@ static int mctp_register(struct net_device *dev)
 	if (rtnl_dereference(dev->mctp_ptr))
 		return 0;
 
-	/* only register specific types; MCTP-specific and loopback for now */
-	if (dev->type != ARPHRD_MCTP && dev->type != ARPHRD_LOOPBACK)
+	/* only register specific types (inc. NONE for TUN devices) */
+	if (!(dev->type == ARPHRD_MCTP ||
+	      dev->type == ARPHRD_LOOPBACK ||
+	      dev->type == ARPHRD_NONE)) {
 		return 0;
+	}
 
 	mdev = mctp_add_dev(dev);
 	if (IS_ERR(mdev))
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 5ca186d53cb0..a953f83ed02b 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -821,13 +821,18 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 				struct net_device *orig_dev)
 {
 	struct net *net = dev_net(dev);
+	struct mctp_dev *mdev;
 	struct mctp_skb_cb *cb;
 	struct mctp_route *rt;
 	struct mctp_hdr *mh;
 
-	/* basic non-data sanity checks */
-	if (dev->type != ARPHRD_MCTP)
+	rcu_read_lock();
+	mdev = __mctp_dev_get(dev);
+	rcu_read_unlock();
+	if (!mdev) {
+		/* basic non-data sanity checks */
 		goto err_drop;
+	}
 
 	if (!pskb_may_pull(skb, sizeof(struct mctp_hdr)))
 		goto err_drop;
@@ -841,9 +846,7 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
 		goto err_drop;
 
 	cb = __mctp_cb(skb);
-	rcu_read_lock();
-	cb->net = READ_ONCE(__mctp_dev_get(dev)->net);
-	rcu_read_unlock();
+	cb->net = READ_ONCE(mdev->net);
 
 	rt = mctp_route_lookup(net, cb->net, mh->dest);
 	if (!rt)
-- 
2.30.2

