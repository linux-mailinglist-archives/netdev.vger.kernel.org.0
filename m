Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE96A084E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbjBWMMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjBWMMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:12:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AB955C0E;
        Thu, 23 Feb 2023 04:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EF64616CB;
        Thu, 23 Feb 2023 12:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A7FC433D2;
        Thu, 23 Feb 2023 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677154325;
        bh=MPOzIceSPCF0OISg626aioOdoacxJwPC0WsR5/DzAm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0HGt75BQbMFi4lSWF0Xs0xCWx7GTb+2HjCBAIL3mqivcL9X+9+TX4N8NPO3uH1S1
         C2PLudO5q7qd0nx622Sq4kU6r5N1M5BKseWRpT/WD67fxJN/XAQTwV+YZWRECCyR9j
         kUzzGAa0xPOcBhOMui+a9E6X7vCAmkI8HntIco9l5LXv2Ob0l17q3DCXav8Ca0JGW+
         O6CAJR0apdw4A5FkzXqlHIvRvDG881aLua6v3ekjAvisxyjAbNSIiT62MG0CdZC70F
         8FEHHxMP9bbQ0HZMQ3odqQDBb8fz97wf4JxxL59nmeQmml8y4pjBUcU8LS7skZg0C7
         WnqPP/OEz+Gqw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [RFC net-next 5/6] veth: take into account device reconfiguration for xdp_features flag
Date:   Thu, 23 Feb 2023 13:11:37 +0100
Message-Id: <3aec2828509462bc1ea99a6fdd1fc9684706e9de.1677153730.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677153730.git.lorenzo@kernel.org>
References: <cover.1677153730.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account tx/rx queues reconfiguration setting device
xdp_features flag. Moreover consider NETIF_F_GRO flag in order to enable
ndo_xdp_xmit callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1bb54de7124d..293dc3b2c84a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1257,6 +1257,26 @@ static int veth_enable_range_safe(struct net_device *dev, int start, int end)
 	return 0;
 }
 
+static void veth_set_xdp_features(struct net_device *dev)
+{
+	struct veth_priv *priv = netdev_priv(dev);
+	struct net_device *peer;
+
+	peer = rcu_dereference(priv->peer);
+	if (peer && peer->real_num_tx_queues <= dev->real_num_rx_queues) {
+		xdp_features_t val = NETDEV_XDP_ACT_BASIC |
+				     NETDEV_XDP_ACT_REDIRECT |
+				     NETDEV_XDP_ACT_RX_SG;
+
+		if (priv->_xdp_prog || veth_gro_requested(dev))
+			val |= NETDEV_XDP_ACT_NDO_XMIT |
+			       NETDEV_XDP_ACT_NDO_XMIT_SG;
+		xdp_set_features_flag(dev, val);
+	} else {
+		xdp_clear_features_flag(dev);
+	}
+}
+
 static int veth_set_channels(struct net_device *dev,
 			     struct ethtool_channels *ch)
 {
@@ -1323,6 +1343,12 @@ static int veth_set_channels(struct net_device *dev,
 		if (peer)
 			netif_carrier_on(peer);
 	}
+
+	/* update XDP supported features */
+	veth_set_xdp_features(dev);
+	if (peer)
+		veth_set_xdp_features(peer);
+
 	return err;
 
 revert:
@@ -1489,7 +1515,10 @@ static int veth_set_features(struct net_device *dev,
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
+
+		xdp_features_set_redirect_target(dev, true);
 	} else {
+		xdp_features_clear_redirect_target(dev);
 		veth_napi_del(dev);
 	}
 	return 0;
@@ -1570,10 +1599,15 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
 			peer->max_mtu = max_mtu;
 		}
+
+		xdp_features_set_redirect_target(dev, true);
 	}
 
 	if (old_prog) {
 		if (!prog) {
+			if (!veth_gro_requested(dev))
+				xdp_features_clear_redirect_target(dev);
+
 			if (dev->flags & IFF_UP)
 				veth_disable_xdp(dev);
 
@@ -1686,10 +1720,6 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_enc_features = VETH_FEATURES;
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
-
-	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			    NETDEV_XDP_ACT_NDO_XMIT | NETDEV_XDP_ACT_RX_SG |
-			    NETDEV_XDP_ACT_NDO_XMIT_SG;
 }
 
 /*
@@ -1857,6 +1887,10 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 		goto err_queues;
 
 	veth_disable_gro(dev);
+	/* update XDP supported features */
+	veth_set_xdp_features(dev);
+	veth_set_xdp_features(peer);
+
 	return 0;
 
 err_queues:
-- 
2.39.2

