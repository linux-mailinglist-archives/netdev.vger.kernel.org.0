Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099D54F5C3C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbiDFLh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiDFLhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:37:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2042F26AE10;
        Wed,  6 Apr 2022 01:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0883B8217D;
        Wed,  6 Apr 2022 08:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A69BC385A5;
        Wed,  6 Apr 2022 08:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233593;
        bh=2lsxnvVgrfilxs1Y136lilhCkFBbV9zKEaHZGUAmUPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAFLmM4LMBTrRM2PBLSqt25kx+KphA6+mlXDFf6lvQIa79XeF3oWTfNtRD++oGhfw
         13vQqy1t8C6PtKrMkq+8ZNv8AUPFEH+QvhUibAp5EOKjvkiXzFXSoM+od8r8TvRKMU
         15WuBbP6hv9htrFPbdQt2OYT+662oZX/UqXDvvwidYIbauf3gDXsx7fvMT6juVOC3d
         z+7LSD45jIye+7uxRXtYv/Jr71mqqLtPPo50qqiGPtzL7tnWwL6sao81Z9yw4HhC3/
         Fxq/620idpnOBEa5IZmiC51f5Fmx+wrDPkYPu9DYoi/uq6RGv9phKyYfpZN2+Ddcij
         uLDiyw4dCHG3A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 10/17] net/mlx5: Remove useless IPsec device checks
Date:   Wed,  6 Apr 2022 11:25:45 +0300
Message-Id: <e45362abfcabe18e8af20ec8d1acdc99355978f3.1649232994.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5_is_ipsec_device() check was to distinguish ConnectX device
related ops from FPGA, so post removing FPGA IPsec code this check
can be removed as no other device implements it.

It is safe to do it as there is already embedded check of IPsec device
in mlx5_accel_ipsec_device_caps().

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  3 --
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 42 +++++++++----------
 3 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f6e3b549424f..1391a0c84f16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -286,9 +286,6 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 static int mlx5e_xfrm_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	if (!mlx5_is_ipsec_device(priv->mdev))
-		return 0;
-
 	return mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->xfrm->attrs,
 					     sa_entry->ipsec_obj_id,
 					     &sa_entry->ipsec_rule);
@@ -297,9 +294,6 @@ static int mlx5e_xfrm_fs_add_rule(struct mlx5e_priv *priv,
 static void mlx5e_xfrm_fs_del_rule(struct mlx5e_priv *priv,
 				   struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	if (!mlx5_is_ipsec_device(priv->mdev))
-		return;
-
 	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
 				      &sa_entry->ipsec_rule);
 }
@@ -550,9 +544,7 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 		return;
 	}
 
-	if (mlx5_is_ipsec_device(mdev))
-		netdev->gso_partial_features |= NETIF_F_GSO_ESP;
-
+	netdev->gso_partial_features |= NETIF_F_GSO_ESP;
 	mlx5_core_dbg(mdev, "mlx5e: ESP GSO capability turned on\n");
 	netdev->features |= NETIF_F_GSO_ESP;
 	netdev->hw_features |= NETIF_F_GSO_ESP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 17da23dff0ed..32093497292f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -700,9 +700,6 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
 {
 	int err;
 
-	if (!mlx5_is_ipsec_device(priv->mdev) || !priv->ipsec)
-		return -EOPNOTSUPP;
-
 	err = fs_init_tx(priv);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 8e0cf5e65100..08a6dd4b7662 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -202,16 +202,14 @@ static int mlx5e_ipsec_set_state(struct mlx5e_priv *priv,
 
 	ipsec_st->x = x;
 	ipsec_st->xo = xo;
-	if (mlx5_is_ipsec_device(priv->mdev)) {
-		aead = x->data;
-		alen = crypto_aead_authsize(aead);
-		blksize = ALIGN(crypto_aead_blocksize(aead), 4);
-		clen = ALIGN(skb->len + 2, blksize);
-		plen = max_t(u32, clen - skb->len, 4);
-		tailen = plen + alen;
-		ipsec_st->plen = plen;
-		ipsec_st->tailen = tailen;
-	}
+	aead = x->data;
+	alen = crypto_aead_authsize(aead);
+	blksize = ALIGN(crypto_aead_blocksize(aead), 4);
+	clen = ALIGN(skb->len + 2, blksize);
+	plen = max_t(u32, clen - skb->len, 4);
+	tailen = plen + alen;
+	ipsec_st->plen = plen;
+	ipsec_st->tailen = tailen;
 
 	return 0;
 }
@@ -244,19 +242,17 @@ void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 		   ((struct iphdr *)skb_network_header(skb))->protocol :
 		   ((struct ipv6hdr *)skb_network_header(skb))->nexthdr;
 
-	if (mlx5_is_ipsec_device(priv->mdev)) {
-		eseg->flow_table_metadata |= cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
-		eseg->trailer |= cpu_to_be32(MLX5_ETH_WQE_INSERT_TRAILER);
-		encap = x->encap;
-		if (!encap) {
-			eseg->trailer |= (l3_proto == IPPROTO_ESP) ?
-				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_IP_ASSOC) :
-				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_L4_ASSOC);
-		} else if (encap->encap_type == UDP_ENCAP_ESPINUDP) {
-			eseg->trailer |= (l3_proto == IPPROTO_ESP) ?
-				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_IP_ASSOC) :
-				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_L4_ASSOC);
-		}
+	eseg->flow_table_metadata |= cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
+	eseg->trailer |= cpu_to_be32(MLX5_ETH_WQE_INSERT_TRAILER);
+	encap = x->encap;
+	if (!encap) {
+		eseg->trailer |= (l3_proto == IPPROTO_ESP) ?
+			cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_IP_ASSOC) :
+			cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_L4_ASSOC);
+	} else if (encap->encap_type == UDP_ENCAP_ESPINUDP) {
+		eseg->trailer |= (l3_proto == IPPROTO_ESP) ?
+			cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_IP_ASSOC) :
+			cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_L4_ASSOC);
 	}
 }
 
-- 
2.35.1

