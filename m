Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E9F3D36BA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhGWHtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:49:40 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34016 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbhGWHtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:49:18 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 19D3821497; Fri, 23 Jul 2021 16:29:51 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v3 15/16] mctp: Allow MCTP on tun devices
Date:   Fri, 23 Jul 2021 16:29:31 +0800
Message-Id: <20210723082932.3570396-16-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723082932.3570396-1-jk@codeconstruct.com.au>
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

Allowing TUN is useful for testing, to route packets to userspace or to
tunnel between machines.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c |  7 +++++--
 net/mctp/route.c  | 13 ++++++++-----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index f82288157d62..95a95b41cc89 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -357,9 +357,12 @@ static int mctp_register(struct net_device *dev)
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
index 1265373552da..e161516c5266 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -806,13 +806,18 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
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
@@ -826,9 +831,7 @@ static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
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

