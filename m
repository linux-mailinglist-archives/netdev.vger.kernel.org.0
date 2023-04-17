Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBE26E542B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjDQVy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjDQVyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:54:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283BC4216;
        Mon, 17 Apr 2023 14:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4693624FE;
        Mon, 17 Apr 2023 21:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93652C433D2;
        Mon, 17 Apr 2023 21:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681768459;
        bh=RGXFZxsBr5YwDZAtwupX3jthk7M6WYiJVtOOlntSZBs=;
        h=From:To:Cc:Subject:Date:From;
        b=pVNyeiD92W7ZMOtOIMMFGwZnJofxGHhxagrjdZ9kSKZEuGNVP/+MgY6Yacw05Ij2h
         hRCuww+KZNVn8mEbIY+HqADTBMfmMISxjikrZrB7Kp7X1rTZ2gDOw1TsvESi+OACFn
         tMCU9Ui9MBC/NNpdnsau6q/ZhcF/nyAmtaBcKLMF9Srcz3Bh9eJVix2UZqTlRx6kyO
         ED7i6HO28FAAK2CxEMhnpIctg3KL/2kNNXc6lOr5p2ALIT/IUT10Y9GmwXmL6cC+xO
         RbEuKobV3n8l5JCDiwe/djZ+0y2oONS9JcZasujyU0fV7+0sM+lQXqaJFQveJ82pqn
         P5mPWqkgZSG3w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, joamaki@gmail.com,
        hawk@kernel.org, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH net] veth: take into account peer device for NETDEV_XDP_ACT_NDO_XMIT xdp_features flag
Date:   Mon, 17 Apr 2023 23:53:22 +0200
Message-Id: <4f1ca6f6f6b42ae125bfdb5c7782217c83968b2e.1681767806.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For veth pairs, NETDEV_XDP_ACT_NDO_XMIT is supported by the current
device if the peer one is running a XDP program or if it has GRO enabled.
Fix the xdp_features flags reporting considering peer device and not
current one for NETDEV_XDP_ACT_NDO_XMIT.

Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e1b38fbf1dd9..4b3c6647edc6 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1262,11 +1262,12 @@ static void veth_set_xdp_features(struct net_device *dev)
 
 	peer = rtnl_dereference(priv->peer);
 	if (peer && peer->real_num_tx_queues <= dev->real_num_rx_queues) {
+		struct veth_priv *priv_peer = netdev_priv(peer);
 		xdp_features_t val = NETDEV_XDP_ACT_BASIC |
 				     NETDEV_XDP_ACT_REDIRECT |
 				     NETDEV_XDP_ACT_RX_SG;
 
-		if (priv->_xdp_prog || veth_gro_requested(dev))
+		if (priv_peer->_xdp_prog || veth_gro_requested(peer))
 			val |= NETDEV_XDP_ACT_NDO_XMIT |
 			       NETDEV_XDP_ACT_NDO_XMIT_SG;
 		xdp_set_features_flag(dev, val);
@@ -1504,19 +1505,23 @@ static int veth_set_features(struct net_device *dev,
 {
 	netdev_features_t changed = features ^ dev->features;
 	struct veth_priv *priv = netdev_priv(dev);
+	struct net_device *peer;
 	int err;
 
 	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
+	peer = rtnl_dereference(priv->peer);
 	if (features & NETIF_F_GRO) {
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
 
-		xdp_features_set_redirect_target(dev, true);
+		if (peer)
+			xdp_features_set_redirect_target(peer, true);
 	} else {
-		xdp_features_clear_redirect_target(dev);
+		if (peer)
+			xdp_features_clear_redirect_target(peer);
 		veth_napi_del(dev);
 	}
 	return 0;
@@ -1598,13 +1603,13 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			peer->max_mtu = max_mtu;
 		}
 
-		xdp_features_set_redirect_target(dev, true);
+		xdp_features_set_redirect_target(peer, true);
 	}
 
 	if (old_prog) {
 		if (!prog) {
-			if (!veth_gro_requested(dev))
-				xdp_features_clear_redirect_target(dev);
+			if (peer && !veth_gro_requested(dev))
+				xdp_features_clear_redirect_target(peer);
 
 			if (dev->flags & IFF_UP)
 				veth_disable_xdp(dev);
-- 
2.39.2

