Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30D3C21B5
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGIJnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:43:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhGIJnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 05:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625823657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZfZHL5fbmr8yT35waIQmfNtXY4S5S/FXv6+ho9UwyGk=;
        b=RHysZCMhrlXObOb63d60lNz5/Hx6IODPPfS9LS90sFlrou951VhoBVL3urtpT5cZqv8AmY
        eX7eljY3pKpjwgDGuvQJajnuFBIp1Xh5ZIwJLvnlP0PPNNPkmICMyBqVw3xQZEOUZg1mOy
        VNKl5xpLCCJfX/hJyD2THouA55/uD8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-mE5vf8anPUKI2hSYhjYPIA-1; Fri, 09 Jul 2021 05:40:55 -0400
X-MC-Unique: mE5vf8anPUKI2hSYhjYPIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA7B980006E;
        Fri,  9 Jul 2021 09:40:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-68.ams2.redhat.com [10.36.113.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 242FC369A;
        Fri,  9 Jul 2021 09:40:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, toke@redhat.com
Subject: [RFC PATCH 1/3] veth: implement support for set_channel ethtool op
Date:   Fri,  9 Jul 2021 11:39:48 +0200
Message-Id: <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
In-Reply-To: <cover.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change implements the set_channel() ethtool operation,
preserving the current defaults values and allowing up set
the number of queues in the range set ad device creation
time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 62 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bdb7ce3cb054..10360228a06a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -72,6 +72,8 @@ struct veth_priv {
 	atomic64_t		dropped;
 	struct bpf_prog		*_xdp_prog;
 	struct veth_rq		*rq;
+	unsigned int		num_tx_queues;
+	unsigned int		num_rx_queues;
 	unsigned int		requested_headroom;
 };
 
@@ -224,10 +226,49 @@ static void veth_get_channels(struct net_device *dev,
 {
 	channels->tx_count = dev->real_num_tx_queues;
 	channels->rx_count = dev->real_num_rx_queues;
-	channels->max_tx = dev->real_num_tx_queues;
-	channels->max_rx = dev->real_num_rx_queues;
+	channels->max_tx = dev->num_tx_queues;
+	channels->max_rx = dev->num_rx_queues;
 	channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
-	channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
+	channels->max_combined = min(dev->num_rx_queues, dev->num_tx_queues);
+}
+
+static int veth_close(struct net_device *dev);
+static int veth_open(struct net_device *dev);
+
+static int veth_set_channels(struct net_device *dev,
+			     struct ethtool_channels *ch)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	struct veth_priv *peer_priv;
+
+	/* accept changes only on rx/tx */
+	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
+		return -EINVAL;
+
+	/* respect contraint posed at device creation time */
+	if (ch->rx_count > dev->num_rx_queues || ch->tx_count > dev->num_tx_queues)
+		return -EINVAL;
+
+	if (!ch->rx_count || !ch->tx_count)
+		return -EINVAL;
+
+	/* avoid braking XDP, if that is enabled */
+	if (priv->_xdp_prog && ch->rx_count < priv->peer->real_num_tx_queues)
+		return -EINVAL;
+
+	peer_priv = netdev_priv(priv->peer);
+	if (peer_priv->_xdp_prog && ch->tx_count > priv->peer->real_num_rx_queues)
+		return -EINVAL;
+
+	if (netif_running(dev))
+		veth_close(dev);
+
+	priv->num_tx_queues = ch->tx_count;
+	priv->num_rx_queues = ch->rx_count;
+
+	if (netif_running(dev))
+		veth_open(dev);
+	return 0;
 }
 
 static const struct ethtool_ops veth_ethtool_ops = {
@@ -239,6 +280,7 @@ static const struct ethtool_ops veth_ethtool_ops = {
 	.get_link_ksettings	= veth_get_link_ksettings,
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_channels		= veth_get_channels,
+	.set_channels		= veth_set_channels,
 };
 
 /* general routines */
@@ -1104,6 +1146,14 @@ static int veth_open(struct net_device *dev)
 	if (!peer)
 		return -ENOTCONN;
 
+	err = netif_set_real_num_rx_queues(dev, priv->num_rx_queues);
+	if (err)
+		return err;
+
+	err = netif_set_real_num_tx_queues(dev, priv->num_tx_queues);
+	if (err)
+		return err;
+
 	if (priv->_xdp_prog) {
 		err = veth_enable_xdp(dev);
 		if (err)
@@ -1551,14 +1601,18 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	netif_carrier_off(dev);
 
 	/*
-	 * tie the deviced together
+	 * tie the deviced together and init the default queue nr
 	 */
 
 	priv = netdev_priv(dev);
 	rcu_assign_pointer(priv->peer, peer);
+	priv->num_tx_queues = dev->num_tx_queues;
+	priv->num_rx_queues = dev->num_rx_queues;
 
 	priv = netdev_priv(peer);
 	rcu_assign_pointer(priv->peer, dev);
+	priv->num_tx_queues = peer->num_tx_queues;
+	priv->num_rx_queues = peer->num_rx_queues;
 
 	veth_disable_gro(dev);
 	return 0;
-- 
2.26.3

