Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4542C6AE3CE
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjCGPDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjCGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63BC81CEA;
        Tue,  7 Mar 2023 06:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BA86137B;
        Tue,  7 Mar 2023 14:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E581C433A1;
        Tue,  7 Mar 2023 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200889;
        bh=nL/2Amr09lXzoYwBFFxKcHDRmo98fmoEefbY3k8izEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/3CVAaWN3hnJ+fvIJRmoD8YNFIbHEDWKqtGoX2u7Z5p5ZdCDnEsWmMLklY3c6QzB
         TToOAy6draWhuWWnvr/XO9xFIP4oeg0NeYIUhCnL9A63+aoRvzBdHvt0hgoTsT5chg
         lyDxfoZxEzDabB4aD2RBx4YEpaOyq4lrhkiVaUhU9qk6c9SKH7AI9Pfl+NFWl/pmWu
         VOfnWcHRRBFgxoX0UMnFr//DXSK4Gl25bgujFcuw9YrB6hZ+b2/1RqD2ROAYyFV5dG
         c/Xay41QXYDoVK6uzo628BvPfWKmzSJSFDOgpl6Vh+eDf7zg2qZDwYubt8U2SaTXWG
         UQiKKBiUp/gIQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 6/8] veth: take into account device reconfiguration for xdp_features flag
Date:   Tue,  7 Mar 2023 15:54:03 +0100
Message-Id: <c632ee1c7786e2a767ac12fd430fb32460f74366.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take into account tx/rx queues reconfiguration setting device
xdp_features flag. Moreover consider NETIF_F_GRO flag in order to enable
ndo_xdp_xmit callback.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
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

