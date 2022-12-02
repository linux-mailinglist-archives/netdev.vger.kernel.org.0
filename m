Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F756640F07
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiLBUQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiLBUQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:16:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D31F4657
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 293CCB82279
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F60C433C1;
        Fri,  2 Dec 2022 20:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012158;
        bh=toWihzUnrnY/xLkc3n8uTzFoTWu3zhqrleykrLnAAM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqmBdt2AwqiGh92OvyBe+5JJtkjL33pLetZZgjFLShGAGJaBn/uwG0OK6gp5D6fUm
         g/J65RSWf9dg0RamO3MqS60cc36pGmV1QoJXww9zx8gbIDC37ZlqfH7XNCG5EYsSci
         KvLanztH0zTWLH+1FslW8NL2JcH3f57ZebYxc2T2yk8dUUOpw5Pe+tIugrcCk1ZMWB
         0OPJYYAVf6YWpAXTm/rLBwzZfxmUB4QsXSRdRqcmgDGa2GZnPiFHyziufX+gHvbD5q
         6VjndDTg8dVtCCCuCRf/6R0YKeRUqz1xm/MyU3GN8ciuTR5SCO9XbKuLMaJgigof6J
         nnx68KlcD1OTQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 13/13] net/mlx5e: Open mlx5 driver to accept IPsec packet offload
Date:   Fri,  2 Dec 2022 22:14:57 +0200
Message-Id: <92123e9097808796a5f432e35eb22ec4a111fc22.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Enable configuration of IPsec packet offload through XFRM state add
interface together with moving specific to IPsec packet mode limitations
to specific switch-case section.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 41 ++++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f5f930ea3f0f..bb9023957f74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -191,11 +191,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Only IPv4/6 xfrm states may be offloaded\n");
 		return -EINVAL;
 	}
-	if (x->props.mode != XFRM_MODE_TRANSPORT &&
-	    x->props.mode != XFRM_MODE_TUNNEL) {
-		dev_info(&netdev->dev, "Only transport and tunnel xfrm states may be offloaded\n");
-		return -EINVAL;
-	}
 	if (x->id.proto != IPPROTO_ESP) {
 		netdev_info(netdev, "Only ESP xfrm state may be offloaded\n");
 		return -EINVAL;
@@ -229,11 +224,32 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
 		return -EINVAL;
 	}
-	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO) {
-		netdev_info(netdev, "Unsupported xfrm offload type\n");
-		return -EINVAL;
-	}
-	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (!(mlx5_ipsec_device_caps(priv->mdev) &
+		      MLX5_IPSEC_CAP_CRYPTO)) {
+			netdev_info(netdev, "Crypto offload is not supported\n");
+			return -EINVAL;
+		}
+
+		if (x->props.mode != XFRM_MODE_TRANSPORT &&
+		    x->props.mode != XFRM_MODE_TUNNEL) {
+			netdev_info(netdev, "Only transport and tunnel xfrm states may be offloaded\n");
+			return -EINVAL;
+		}
+		break;
+	case XFRM_DEV_OFFLOAD_PACKET:
+		if (!(mlx5_ipsec_device_caps(priv->mdev) &
+		      MLX5_IPSEC_CAP_PACKET_OFFLOAD)) {
+			netdev_info(netdev, "Packet offload is not supported\n");
+			return -EINVAL;
+		}
+
+		if (x->props.mode != XFRM_MODE_TRANSPORT) {
+			netdev_info(netdev, "Only transport xfrm states may be offloaded in packet mode\n");
+			return -EINVAL;
+		}
+
 		if (x->replay_esn && x->replay_esn->replay_window != 32 &&
 		    x->replay_esn->replay_window != 64 &&
 		    x->replay_esn->replay_window != 128 &&
@@ -263,6 +279,11 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 				    "Hard packet limit must be greater than soft one\n");
 			return -EINVAL;
 		}
+		break;
+	default:
+		netdev_info(netdev, "Unsupported xfrm offload type %d\n",
+			    x->xso.type);
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
2.38.1

