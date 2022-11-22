Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2143633434
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiKVDur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiKVDup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:50:45 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3332B187;
        Mon, 21 Nov 2022 19:50:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VVQOr8T_1669089041;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVQOr8T_1669089041)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 11:50:41 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        John Fastabend <john.fastabend@gmail.com>, toke@kernel.org
Subject: [PATCH 2/2] Revert "veth: Avoid drop packets when xdp_redirect performs"
Date:   Tue, 22 Nov 2022 11:50:15 +0800
Message-Id: <20221122035015.19296-3-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221122035015.19296-1-hengqi@linux.alibaba.com>
References: <20221122035015.19296-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2e0de6366ac16ab4d0abb2aaddbc8a1eba216d11.

Based on the issues reported by John and Paolo and their comments,
this patch and the corresponding fix 5e5dc33d5da are reverted, and
we'll remake it.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/veth.c | 88 +++++++---------------------------------------
 1 file changed, 12 insertions(+), 76 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b1ed5a93b6c5..ac7c0653695f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1119,14 +1119,10 @@ static void veth_disable_xdp_range(struct net_device *dev, int start, int end,
 
 static int veth_enable_xdp(struct net_device *dev)
 {
+	bool napi_already_on = veth_gro_requested(dev) && (dev->flags & IFF_UP);
 	struct veth_priv *priv = netdev_priv(dev);
-	bool napi_already_on;
-	struct veth_rq *rq;
 	int err, i;
 
-	rq = &priv->rq[0];
-	napi_already_on = (dev->flags & IFF_UP) && rcu_access_pointer(rq->napi);
-
 	if (!xdp_rxq_info_is_reg(&priv->rq[0].xdp_rxq)) {
 		err = veth_enable_xdp_range(dev, 0, dev->real_num_rx_queues, napi_already_on);
 		if (err)
@@ -1327,28 +1323,18 @@ static int veth_set_channels(struct net_device *dev,
 
 static int veth_open(struct net_device *dev)
 {
-	struct veth_priv *peer_priv, *priv = netdev_priv(dev);
+	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer = rtnl_dereference(priv->peer);
-	struct veth_rq *peer_rq;
 	int err;
 
 	if (!peer)
 		return -ENOTCONN;
 
-	peer_priv = netdev_priv(peer);
-	peer_rq = &peer_priv->rq[0];
-
 	if (priv->_xdp_prog) {
 		err = veth_enable_xdp(dev);
 		if (err)
 			return err;
-		/* refer to the logic in veth_xdp_set() */
-		if (!rtnl_dereference(peer_rq->napi)) {
-			err = veth_napi_enable(peer);
-			if (err)
-				return err;
-		}
-	} else if (veth_gro_requested(dev) || peer_priv->_xdp_prog) {
+	} else if (veth_gro_requested(dev)) {
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
@@ -1364,29 +1350,17 @@ static int veth_open(struct net_device *dev)
 
 static int veth_close(struct net_device *dev)
 {
-	struct veth_priv *peer_priv, *priv = netdev_priv(dev);
+	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer = rtnl_dereference(priv->peer);
-	struct veth_rq *peer_rq;
 
 	netif_carrier_off(dev);
-	if (peer) {
-		peer_priv = netdev_priv(peer);
-		peer_rq = &peer_priv->rq[0];
-	}
+	if (peer)
+		netif_carrier_off(peer);
 
-	if (priv->_xdp_prog) {
+	if (priv->_xdp_prog)
 		veth_disable_xdp(dev);
-		/* refer to the logic in veth_xdp_set */
-		if (peer && rtnl_dereference(peer_rq->napi)) {
-			if (!veth_gro_requested(peer) && !peer_priv->_xdp_prog)
-				veth_napi_del(peer);
-		}
-	} else if (veth_gro_requested(dev) || (peer && peer_priv->_xdp_prog)) {
+	else if (veth_gro_requested(dev))
 		veth_napi_del(dev);
-	}
-
-	if (peer)
-		netif_carrier_off(peer);
 
 	return 0;
 }
@@ -1496,21 +1470,17 @@ static int veth_set_features(struct net_device *dev,
 {
 	netdev_features_t changed = features ^ dev->features;
 	struct veth_priv *priv = netdev_priv(dev);
-	struct veth_rq *rq = &priv->rq[0];
 	int err;
 
 	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
 	if (features & NETIF_F_GRO) {
-		if (!rtnl_dereference(rq->napi)) {
-			err = veth_napi_enable(dev);
-			if (err)
-				return err;
-		}
+		err = veth_napi_enable(dev);
+		if (err)
+			return err;
 	} else {
-		if (rtnl_dereference(rq->napi))
-			veth_napi_del(dev);
+		veth_napi_del(dev);
 	}
 	return 0;
 }
@@ -1542,19 +1512,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-	struct veth_priv *peer_priv;
 	struct bpf_prog *old_prog;
-	struct veth_rq *peer_rq;
 	struct net_device *peer;
-	bool napi_already_off;
 	unsigned int max_mtu;
-	bool noreq_napi;
 	int err;
 
 	old_prog = priv->_xdp_prog;
 	priv->_xdp_prog = prog;
 	peer = rtnl_dereference(priv->peer);
-	peer_priv = netdev_priv(peer);
 
 	if (prog) {
 		if (!peer) {
@@ -1591,24 +1556,6 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (peer && (peer->flags & IFF_UP)) {
-			peer_rq = &peer_priv->rq[0];
-
-			/* If the peer hasn't enabled GRO and loaded xdp,
-			 * then we enable napi automatically if its napi
-			 * is not ready.
-			 */
-			napi_already_off = !rtnl_dereference(peer_rq->napi);
-			if (napi_already_off) {
-				err = veth_napi_enable(peer);
-				if (err) {
-					NL_SET_ERR_MSG_MOD(extack,
-							   "Failed to automatically enable napi of peer");
-					goto err;
-				}
-			}
-		}
-
 		if (!old_prog) {
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
 			peer->max_mtu = max_mtu;
@@ -1623,17 +1570,6 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			if (peer) {
 				peer->hw_features |= NETIF_F_GSO_SOFTWARE;
 				peer->max_mtu = ETH_MAX_MTU;
-				peer_rq = &peer_priv->rq[0];
-
-				/* If the peer doesn't has its xdp and enabled
-				 * GRO, then we disable napi if its napi is ready;
-				 */
-				if (rtnl_dereference(peer_rq->napi)) {
-					noreq_napi = !veth_gro_requested(peer) &&
-						     !peer_priv->_xdp_prog;
-					if (noreq_napi && (peer->flags & IFF_UP))
-						veth_napi_del(peer);
-				}
 			}
 		}
 		bpf_prog_put(old_prog);
-- 
2.19.1.6.gb485710b

