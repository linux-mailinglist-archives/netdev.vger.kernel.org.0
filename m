Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A69359C9A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhDILFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:05:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233564AbhDILFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617966295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FvNPydmyh8G4DhceoaOsMc1ahysTOqAc2X3r4CfzgrM=;
        b=N3B761+tcWxFLkpbjKq+TO4eGZmqmuSXbUslkF4n+tqhE4lriQyYu1KxhKSDvVBk8tKcfT
        AmzgMQWUc+ZxXgqwdjxJn5FPH6aFejEb5t5CAFCiKSwBQ/FrvsaIoSTQba7HwNHpH2K3ut
        UpXPQgmeQ7QqQaAs8q/Qg3MwP16Rye0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-hP0l3o-QMfmXpDwU-GUBaQ-1; Fri, 09 Apr 2021 07:04:54 -0400
X-MC-Unique: hP0l3o-QMfmXpDwU-GUBaQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAEC41868407;
        Fri,  9 Apr 2021 11:04:52 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77C6210023BE;
        Fri,  9 Apr 2021 11:04:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
Date:   Fri,  9 Apr 2021 13:04:38 +0200
Message-Id: <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
In-Reply-To: <cover.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the veth device has the GRO feature bit set, even if
no GRO aggregation is possible with the default configuration,
as the veth device does not hook into the GRO engine.

Flipping the GRO feature bit from user-space is a no-op, unless
XDP is enabled. In such scenario GRO could actually take place, but
TSO is forced to off on the peer device.

This change allow user-space to really control the GRO feature, with
no need for an XDP program.

The GRO feature bit is now cleared by default - so that there are no
user-visible behavior changes with the default configuration.

When the GRO bit is set, the per-queue NAPI instances are initialized
and registered. On xmit, when napi instances are available, we try
to use them.

Some additional checks are in place to ensure we initialize/delete NAPIs
only when needed in case of overlapping XDP and GRO configuration
changes.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 129 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 116 insertions(+), 13 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ad36e7ed16134..ca44e82d1edeb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -57,6 +57,7 @@ struct veth_rq_stats {
 
 struct veth_rq {
 	struct napi_struct	xdp_napi;
+	struct napi_struct __rcu *napi; /* points to xdp_napi when the latter is initialized */
 	struct net_device	*dev;
 	struct bpf_prog __rcu	*xdp_prog;
 	struct xdp_mem_info	xdp_mem;
@@ -287,7 +288,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct veth_rq *rq = NULL;
 	struct net_device *rcv;
 	int length = skb->len;
-	bool rcv_xdp = false;
+	bool use_napi = false;
 	int rxq;
 
 	rcu_read_lock();
@@ -301,20 +302,24 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	rxq = skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
-		rcv_xdp = rcu_access_pointer(rq->xdp_prog);
+
+		/* The napi pointer is available when an XDP program is
+		 * attached or when GRO is enabled
+		 */
+		use_napi = rcu_access_pointer(rq->napi);
 		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);
-	if (likely(veth_forward_skb(rcv, skb, rq, rcv_xdp) == NET_RX_SUCCESS)) {
-		if (!rcv_xdp)
+	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
+		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
 drop:
 		atomic64_inc(&priv->dropped);
 	}
 
-	if (rcv_xdp)
+	if (use_napi)
 		__veth_xdp_flush(rq);
 
 	rcu_read_unlock();
@@ -891,7 +896,7 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	return done;
 }
 
-static int veth_napi_add(struct net_device *dev)
+static int __veth_napi_enable(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
@@ -908,6 +913,7 @@ static int veth_napi_add(struct net_device *dev)
 		struct veth_rq *rq = &priv->rq[i];
 
 		napi_enable(&rq->xdp_napi);
+		rcu_assign_pointer(priv->rq[i].napi, &priv->rq[i].xdp_napi);
 	}
 
 	return 0;
@@ -926,6 +932,7 @@ static void veth_napi_del(struct net_device *dev)
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
+		rcu_assign_pointer(priv->rq[i].napi, NULL);
 		napi_disable(&rq->xdp_napi);
 		__netif_napi_del(&rq->xdp_napi);
 	}
@@ -939,8 +946,14 @@ static void veth_napi_del(struct net_device *dev)
 	}
 }
 
+static bool veth_gro_requested(const struct net_device *dev)
+{
+	return !!(dev->wanted_features & NETIF_F_GRO);
+}
+
 static int veth_enable_xdp(struct net_device *dev)
 {
+	bool napi_already_on = veth_gro_requested(dev) && (dev->flags & IFF_UP);
 	struct veth_priv *priv = netdev_priv(dev);
 	int err, i;
 
@@ -948,7 +961,8 @@ static int veth_enable_xdp(struct net_device *dev)
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
 			struct veth_rq *rq = &priv->rq[i];
 
-			netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
+			if (!napi_already_on)
+				netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
 			err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i, rq->xdp_napi.napi_id);
 			if (err < 0)
 				goto err_rxq_reg;
@@ -963,13 +977,25 @@ static int veth_enable_xdp(struct net_device *dev)
 			rq->xdp_mem = rq->xdp_rxq.mem;
 		}
 
-		err = veth_napi_add(dev);
-		if (err)
-			goto err_rxq_reg;
+		if (!napi_already_on) {
+			err = __veth_napi_enable(dev);
+			if (err)
+				goto err_rxq_reg;
+
+			if (!veth_gro_requested(dev)) {
+				/* user-space did not require GRO, but adding XDP
+				 * is supposed to get GRO working
+				 */
+				dev->features |= NETIF_F_GRO;
+				netdev_features_change(dev);
+			}
+		}
 	}
 
-	for (i = 0; i < dev->real_num_rx_queues; i++)
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
 		rcu_assign_pointer(priv->rq[i].xdp_prog, priv->_xdp_prog);
+		rcu_assign_pointer(priv->rq[i].napi, &priv->rq[i].xdp_napi);
+	}
 
 	return 0;
 err_reg_mem:
@@ -979,7 +1005,8 @@ static int veth_enable_xdp(struct net_device *dev)
 		struct veth_rq *rq = &priv->rq[i];
 
 		xdp_rxq_info_unreg(&rq->xdp_rxq);
-		netif_napi_del(&rq->xdp_napi);
+		if (!napi_already_on)
+			netif_napi_del(&rq->xdp_napi);
 	}
 
 	return err;
@@ -992,7 +1019,19 @@ static void veth_disable_xdp(struct net_device *dev)
 
 	for (i = 0; i < dev->real_num_rx_queues; i++)
 		rcu_assign_pointer(priv->rq[i].xdp_prog, NULL);
-	veth_napi_del(dev);
+
+	if (!netif_running(dev) || !veth_gro_requested(dev)) {
+		veth_napi_del(dev);
+
+		/* if user-space did not require GRO, since adding XDP
+		 * enabled it, clear it now
+		 */
+		if (!veth_gro_requested(dev) && netif_running(dev)) {
+			dev->features &= ~NETIF_F_GRO;
+			netdev_features_change(dev);
+		}
+	}
+
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
@@ -1001,6 +1040,29 @@ static void veth_disable_xdp(struct net_device *dev)
 	}
 }
 
+static int veth_napi_enable(struct net_device *dev)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	int err, i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		struct veth_rq *rq = &priv->rq[i];
+
+		netif_napi_add(dev, &rq->xdp_napi, veth_poll, NAPI_POLL_WEIGHT);
+	}
+
+	err = __veth_napi_enable(dev);
+	if (err) {
+		for (i = 0; i < dev->real_num_rx_queues; i++) {
+			struct veth_rq *rq = &priv->rq[i];
+
+			netif_napi_del(&rq->xdp_napi);
+		}
+		return err;
+	}
+	return err;
+}
+
 static int veth_open(struct net_device *dev)
 {
 	struct veth_priv *priv = netdev_priv(dev);
@@ -1014,6 +1076,10 @@ static int veth_open(struct net_device *dev)
 		err = veth_enable_xdp(dev);
 		if (err)
 			return err;
+	} else if (veth_gro_requested(dev)) {
+		err = veth_napi_enable(dev);
+		if (err)
+			return err;
 	}
 
 	if (peer->flags & IFF_UP) {
@@ -1035,6 +1101,8 @@ static int veth_close(struct net_device *dev)
 
 	if (priv->_xdp_prog)
 		veth_disable_xdp(dev);
+	else if (veth_gro_requested(dev))
+		veth_napi_del(dev);
 
 	return 0;
 }
@@ -1133,10 +1201,32 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 		if (peer_priv->_xdp_prog)
 			features &= ~NETIF_F_GSO_SOFTWARE;
 	}
+	if (priv->_xdp_prog)
+		features |= NETIF_F_GRO;
 
 	return features;
 }
 
+static int veth_set_features(struct net_device *dev,
+			     netdev_features_t features)
+{
+	netdev_features_t changed = features ^ dev->features;
+	struct veth_priv *priv = netdev_priv(dev);
+	int err;
+
+	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
+		return 0;
+
+	if (features & NETIF_F_GRO) {
+		err = veth_napi_enable(dev);
+		if (err)
+			return err;
+	} else {
+		veth_napi_del(dev);
+	}
+	return 0;
+}
+
 static void veth_set_rx_headroom(struct net_device *dev, int new_hr)
 {
 	struct veth_priv *peer_priv, *priv = netdev_priv(dev);
@@ -1255,6 +1345,7 @@ static const struct net_device_ops veth_netdev_ops = {
 #endif
 	.ndo_get_iflink		= veth_get_iflink,
 	.ndo_fix_features	= veth_fix_features,
+	.ndo_set_features	= veth_set_features,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_set_rx_headroom	= veth_set_rx_headroom,
 	.ndo_bpf		= veth_xdp,
@@ -1317,6 +1408,13 @@ static int veth_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static struct rtnl_link_ops veth_link_ops;
 
+static void veth_disable_gro(struct net_device *dev)
+{
+	dev->features &= ~NETIF_F_GRO;
+	dev->wanted_features &= ~NETIF_F_GRO;
+	netdev_update_features(dev);
+}
+
 static int veth_newlink(struct net *src_net, struct net_device *dev,
 			struct nlattr *tb[], struct nlattr *data[],
 			struct netlink_ext_ack *extack)
@@ -1389,6 +1487,10 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		goto err_register_peer;
 
+	/* keep GRO disabled by default to be consistent with the established
+	 * veth behavior
+	 */
+	veth_disable_gro(peer);
 	netif_carrier_off(peer);
 
 	err = rtnl_configure_link(peer, ifmp);
@@ -1426,6 +1528,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	priv = netdev_priv(peer);
 	rcu_assign_pointer(priv->peer, dev);
 
+	veth_disable_gro(dev);
 	return 0;
 
 err_register_dev:
-- 
2.26.2

