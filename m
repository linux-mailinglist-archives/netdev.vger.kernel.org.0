Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BAC4F5C64
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiDFLhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiDFLgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:36:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7539B55EC28;
        Wed,  6 Apr 2022 01:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEA9AB8217A;
        Wed,  6 Apr 2022 08:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ECAC385A1;
        Wed,  6 Apr 2022 08:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649233566;
        bh=Ymk7QEwTWtxLtglZ/kVZ7oXbV1jngz0ne3LZXF3qN58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhuiVl2ozJ62KSuAu1eWt28SAUjl15znk0X4qLpeXGWTHFt9lib5FBguL+6N5UI1D
         kPrF5Q2k/7Bb0Jm2ztlzNwmEi73Y3IeOrjGfZxw4vgo+tV6EJWggM+2RtPURsYszZl
         g6Exytm9f2xuRajtiVlTHYqybPnJWQ8MBTLsvV6yyibyKMkiaMc1u2n31wS41k029h
         cyGweIQEoQHR4EGkoZW6ZsprjQ94hTyEQJ/l6WP0jwiv5A6DZShWb+OX10e+hwrNrn
         W0Kf1Z6FYnSibK1BULuLejBRXWvcN8NcErxpn6EnvECfSJQ62p47eanSL3HuxMeVNl
         m0vCk1U/4x97Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 02/17] net/mlx5: Delete metadata handling logic
Date:   Wed,  6 Apr 2022 11:25:37 +0300
Message-Id: <fe67a1de4fc6032a940e18c8a6461a1ccf902fc4.1649232994.git.leonro@nvidia.com>
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

Remove specific to FPGS IPsec metadata handling logic which is not
required for mlx5 NICs devices.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/accel/accel.h |  36 ----
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   6 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 199 ------------------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   3 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 5 files changed, 245 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
deleted file mode 100644
index 82b185121edb..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef __MLX5E_ACCEL_H__
-#define __MLX5E_ACCEL_H__
-
-#ifdef CONFIG_MLX5_ACCEL
-
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-
-static inline bool is_metadata_hdr_valid(struct sk_buff *skb)
-{
-	__be16 *ethtype;
-
-	if (unlikely(skb->len < ETH_HLEN + MLX5E_METADATA_ETHER_LEN))
-		return false;
-	ethtype = (__be16 *)(skb->data + ETH_ALEN * 2);
-	if (*ethtype != cpu_to_be16(MLX5E_METADATA_ETHER_TYPE))
-		return false;
-	return true;
-}
-
-static inline void remove_metadata_hdr(struct sk_buff *skb)
-{
-	struct ethhdr *old_eth;
-	struct ethhdr *new_eth;
-
-	/* Remove the metadata from the buffer */
-	old_eth = (struct ethhdr *)skb->data;
-	new_eth = (struct ethhdr *)(skb->data + MLX5E_METADATA_ETHER_LEN);
-	memmove(new_eth, old_eth, 2 * ETH_ALEN);
-	/* Ethertype is already in its new place */
-	skb_pull_inline(skb, MLX5E_METADATA_ETHER_LEN);
-}
-
-#endif /* CONFIG_MLX5_ACCEL */
-
-#endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 6164c7f59efb..282d3abab8c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -116,7 +116,6 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_rule ipsec_rule;
 };
 
-void mlx5e_ipsec_build_inverse_table(void);
 int mlx5e_ipsec_init(struct mlx5e_priv *priv);
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv);
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
@@ -125,11 +124,6 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
 					      unsigned int handle);
 
 #else
-
-static inline void mlx5e_ipsec_build_inverse_table(void)
-{
-}
-
 static inline int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index b56fea142c24..28e0500d4a48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -37,75 +37,13 @@
 #include "accel/ipsec_offload.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ipsec.h"
-#include "accel/accel.h"
 #include "en.h"
 
-enum {
-	MLX5E_IPSEC_RX_SYNDROME_DECRYPTED = 0x11,
-	MLX5E_IPSEC_RX_SYNDROME_AUTH_FAILED = 0x12,
-	MLX5E_IPSEC_RX_SYNDROME_BAD_PROTO = 0x17,
-};
-
-struct mlx5e_ipsec_rx_metadata {
-	unsigned char   nexthdr;
-	__be32		sa_handle;
-} __packed;
-
 enum {
 	MLX5E_IPSEC_TX_SYNDROME_OFFLOAD = 0x8,
 	MLX5E_IPSEC_TX_SYNDROME_OFFLOAD_WITH_LSO_TCP = 0x9,
 };
 
-struct mlx5e_ipsec_tx_metadata {
-	__be16 mss_inv;         /* 1/MSS in 16bit fixed point, only for LSO */
-	__be16 seq;             /* LSBs of the first TCP seq, only for LSO */
-	u8     esp_next_proto;  /* Next protocol of ESP */
-} __packed;
-
-struct mlx5e_ipsec_metadata {
-	unsigned char syndrome;
-	union {
-		unsigned char raw[5];
-		/* from FPGA to host, on successful decrypt */
-		struct mlx5e_ipsec_rx_metadata rx;
-		/* from host to FPGA */
-		struct mlx5e_ipsec_tx_metadata tx;
-	} __packed content;
-	/* packet type ID field	*/
-	__be16 ethertype;
-} __packed;
-
-#define MAX_LSO_MSS 2048
-
-/* Pre-calculated (Q0.16) fixed-point inverse 1/x function */
-static __be16 mlx5e_ipsec_inverse_table[MAX_LSO_MSS];
-
-static inline __be16 mlx5e_ipsec_mss_inv(struct sk_buff *skb)
-{
-	return mlx5e_ipsec_inverse_table[skb_shinfo(skb)->gso_size];
-}
-
-static struct mlx5e_ipsec_metadata *mlx5e_ipsec_add_metadata(struct sk_buff *skb)
-{
-	struct mlx5e_ipsec_metadata *mdata;
-	struct ethhdr *eth;
-
-	if (unlikely(skb_cow_head(skb, sizeof(*mdata))))
-		return ERR_PTR(-ENOMEM);
-
-	eth = (struct ethhdr *)skb_push(skb, sizeof(*mdata));
-	skb->mac_header -= sizeof(*mdata);
-	mdata = (struct mlx5e_ipsec_metadata *)(eth + 1);
-
-	memmove(skb->data, skb->data + sizeof(*mdata),
-		2 * ETH_ALEN);
-
-	eth->h_proto = cpu_to_be16(MLX5E_METADATA_ETHER_TYPE);
-
-	memset(mdata->content.raw, 0, sizeof(mdata->content.raw));
-	return mdata;
-}
-
 static int mlx5e_ipsec_remove_trailer(struct sk_buff *skb, struct xfrm_state *x)
 {
 	unsigned int alen = crypto_aead_authsize(x->data);
@@ -244,40 +182,6 @@ void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 	skb_store_bits(skb, iv_offset, &seqno, 8);
 }
 
-static void mlx5e_ipsec_set_metadata(struct sk_buff *skb,
-				     struct mlx5e_ipsec_metadata *mdata,
-				     struct xfrm_offload *xo)
-{
-	struct ip_esp_hdr *esph;
-	struct tcphdr *tcph;
-
-	if (skb_is_gso(skb)) {
-		/* Add LSO metadata indication */
-		esph = ip_esp_hdr(skb);
-		tcph = inner_tcp_hdr(skb);
-		netdev_dbg(skb->dev, "   Offloading GSO packet outer L3 %u; L4 %u; Inner L3 %u; L4 %u\n",
-			   skb->network_header,
-			   skb->transport_header,
-			   skb->inner_network_header,
-			   skb->inner_transport_header);
-		netdev_dbg(skb->dev, "   Offloading GSO packet of len %u; mss %u; TCP sp %u dp %u seq 0x%x ESP seq 0x%x\n",
-			   skb->len, skb_shinfo(skb)->gso_size,
-			   ntohs(tcph->source), ntohs(tcph->dest),
-			   ntohl(tcph->seq), ntohl(esph->seq_no));
-		mdata->syndrome = MLX5E_IPSEC_TX_SYNDROME_OFFLOAD_WITH_LSO_TCP;
-		mdata->content.tx.mss_inv = mlx5e_ipsec_mss_inv(skb);
-		mdata->content.tx.seq = htons(ntohl(tcph->seq) & 0xFFFF);
-	} else {
-		mdata->syndrome = MLX5E_IPSEC_TX_SYNDROME_OFFLOAD;
-	}
-	mdata->content.tx.esp_next_proto = xo->proto;
-
-	netdev_dbg(skb->dev, "   TX metadata syndrome %u proto %u mss_inv %04x seq %04x\n",
-		   mdata->syndrome, mdata->content.tx.esp_next_proto,
-		   ntohs(mdata->content.tx.mss_inv),
-		   ntohs(mdata->content.tx.seq));
-}
-
 void mlx5e_ipsec_handle_tx_wqe(struct mlx5e_tx_wqe *wqe,
 			       struct mlx5e_accel_tx_ipsec_state *ipsec_st,
 			       struct mlx5_wqe_inline_seg *inlseg)
@@ -363,7 +267,6 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct mlx5e_ipsec_sa_entry *sa_entry;
-	struct mlx5e_ipsec_metadata *mdata;
 	struct xfrm_state *x;
 	struct sec_path *sp;
 
@@ -392,19 +295,8 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 			goto drop;
 		}
 
-	if (MLX5_CAP_GEN(priv->mdev, fpga)) {
-		mdata = mlx5e_ipsec_add_metadata(skb);
-		if (IS_ERR(mdata)) {
-			atomic64_inc(&priv->ipsec->sw_stats.ipsec_tx_drop_metadata);
-			goto drop;
-		}
-	}
-
 	sa_entry = (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 	sa_entry->set_iv_op(skb, x, xo);
-	if (MLX5_CAP_GEN(priv->mdev, fpga))
-		mlx5e_ipsec_set_metadata(skb, mdata, xo);
-
 	mlx5e_ipsec_set_state(priv, skb, x, xo, ipsec_st);
 
 	return true;
@@ -414,79 +306,6 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 	return false;
 }
 
-static inline struct xfrm_state *
-mlx5e_ipsec_build_sp(struct net_device *netdev, struct sk_buff *skb,
-		     struct mlx5e_ipsec_metadata *mdata)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct xfrm_offload *xo;
-	struct xfrm_state *xs;
-	struct sec_path *sp;
-	u32 sa_handle;
-
-	sp = secpath_set(skb);
-	if (unlikely(!sp)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
-		return NULL;
-	}
-
-	sa_handle = be32_to_cpu(mdata->content.rx.sa_handle);
-	xs = mlx5e_ipsec_sadb_rx_lookup(priv->ipsec, sa_handle);
-	if (unlikely(!xs)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
-		return NULL;
-	}
-
-	sp = skb_sec_path(skb);
-	sp->xvec[sp->len++] = xs;
-	sp->olen++;
-
-	xo = xfrm_offload(skb);
-	xo->flags = CRYPTO_DONE;
-	switch (mdata->syndrome) {
-	case MLX5E_IPSEC_RX_SYNDROME_DECRYPTED:
-		xo->status = CRYPTO_SUCCESS;
-		if (likely(priv->ipsec->no_trailer)) {
-			xo->flags |= XFRM_ESP_NO_TRAILER;
-			xo->proto = mdata->content.rx.nexthdr;
-		}
-		break;
-	case MLX5E_IPSEC_RX_SYNDROME_AUTH_FAILED:
-		xo->status = CRYPTO_TUNNEL_ESP_AUTH_FAILED;
-		break;
-	case MLX5E_IPSEC_RX_SYNDROME_BAD_PROTO:
-		xo->status = CRYPTO_INVALID_PROTOCOL;
-		break;
-	default:
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_syndrome);
-		return NULL;
-	}
-	return xs;
-}
-
-struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
-					  struct sk_buff *skb, u32 *cqe_bcnt)
-{
-	struct mlx5e_ipsec_metadata *mdata;
-	struct xfrm_state *xs;
-
-	if (!is_metadata_hdr_valid(skb))
-		return skb;
-
-	/* Use the metadata */
-	mdata = (struct mlx5e_ipsec_metadata *)(skb->data + ETH_HLEN);
-	xs = mlx5e_ipsec_build_sp(netdev, skb, mdata);
-	if (unlikely(!xs)) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
-	remove_metadata_hdr(skb);
-	*cqe_bcnt -= MLX5E_METADATA_ETHER_LEN;
-
-	return skb;
-}
-
 enum {
 	MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_DECRYPTED,
 	MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_AUTH_FAILED,
@@ -541,21 +360,3 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_syndrome);
 	}
 }
-
-void mlx5e_ipsec_build_inverse_table(void)
-{
-	u16 mss_inv;
-	u32 mss;
-
-	/* Calculate 1/x inverse table for use in GSO data path.
-	 * Using this table, we provide the IPSec accelerator with the value of
-	 * 1/gso_size so that it can infer the position of each segment inside
-	 * the GSO, and increment the ESP sequence number, and generate the IV.
-	 * The HW needs this value in Q0.16 fixed-point number format
-	 */
-	mlx5e_ipsec_inverse_table[1] = htons(0xFFFF);
-	for (mss = 2; mss < MAX_LSO_MSS; mss++) {
-		mss_inv = div_u64(1ULL << 32, mss) >> 16;
-		mlx5e_ipsec_inverse_table[mss] = htons(mss_inv);
-	}
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 428881e0adcb..0ae4e12ce528 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -53,9 +53,6 @@ struct mlx5e_accel_tx_ipsec_state {
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 
-struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
-					  struct sk_buff *skb, u32 *cqe_bcnt);
-
 void mlx5e_ipsec_inverse_table_init(void);
 void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
 			    struct xfrm_offload *xo);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0a303879d0f4..83365d04050b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5693,7 +5693,6 @@ int mlx5e_init(void)
 {
 	int ret;
 
-	mlx5e_ipsec_build_inverse_table();
 	mlx5e_build_ptys2ethtool_map();
 	ret = auxiliary_driver_register(&mlx5e_driver);
 	if (ret)
-- 
2.35.1

