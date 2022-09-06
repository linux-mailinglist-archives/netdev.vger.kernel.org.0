Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826A25ADEF4
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbiIFFW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiIFFV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEA56D9D2
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8DECB81624
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C2EC433D7;
        Tue,  6 Sep 2022 05:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441711;
        bh=oIDAp4Ruqeup4I3GrSvLRHJwu+Kouxg+mylHZCgVuh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANvCLpuQf3swve6A33FDdmP3un1TMfb4lg4PRC8EgsP9PDbPxGmLlzPw+uIUMIyuJ
         C6H2VBUGRBkMUDbm6Jk+OqFX4mpRJ+R08F2Na0BZIWIE9zVOhfW5hK7a7oo16x7lwB
         sIw3MAkBNltPVm7Wl44HF2M18Y5qX8by9BIavm7j0MLgQ1ZrJHLtLkF2gGcV56mgn8
         ZMFstgliZlNAKdY1V/p50AHC7fRfiGKggBM5v21zN1kaTHcFV8Nk9QkDXHTmF0DHV6
         GtYRQtVJ07uuL7Nz1oXN2nkdpeo0i2U0ZHHEqTOILpVPXHxxa2aQ7VsNSH8pcB1i37
         1J9nYmgJfOMLA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 14/17] net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst
Date:   Mon,  5 Sep 2022 22:21:26 -0700
Message-Id: <20220906052129.104507-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

MACsec driver need to distinguish to which offload device the MACsec
is target to, in order to handle them correctly.
This can be done by attaching a metadata_dst to a SKB with a SCI,
when there is a match on MACsec rule.
To achieve that, there is a map between fs_id to SCI, so for each RX SC,
there is a unique fs_id allocated when creating RX SC.
fs_id passed to device driver as metadata for packets that passed Rx
MACsec offload to aid the driver to retrieve the matching SCI.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  4 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      | 46 ++++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/macsec.h      | 17 +++++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  4 ++
 4 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 0ae4e12ce528..c72b62f52574 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -39,9 +39,9 @@
 #include "en.h"
 #include "en/txrx.h"
 
-/* Bit31: IPsec marker, Bit30-24: IPsec syndrome, Bit23-0: IPsec obj id */
+/* Bit31: IPsec marker, Bit30: reserved, Bit29-24: IPsec syndrome, Bit23-0: IPsec obj id */
 #define MLX5_IPSEC_METADATA_MARKER(metadata)  (((metadata) >> 31) & 0x1)
-#define MLX5_IPSEC_METADATA_SYNDROM(metadata) (((metadata) >> 24) & GENMASK(6, 0))
+#define MLX5_IPSEC_METADATA_SYNDROM(metadata) (((metadata) >> 24) & GENMASK(5, 0))
 #define MLX5_IPSEC_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(23, 0))
 
 struct mlx5e_accel_tx_ipsec_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 299913377b22..d5559b4fce05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -39,6 +39,7 @@ struct mlx5e_macsec_rx_sc {
 	struct mlx5e_macsec_sa *rx_sa[MACSEC_NUM_AN];
 	struct list_head rx_sc_list_element;
 	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
+	struct metadata_dst *md_dst;
 	struct rcu_head rcu_head;
 };
 
@@ -455,16 +456,24 @@ static int mlx5e_macsec_add_rxsc(struct macsec_context *ctx)
 	if (err)
 		goto destroy_sc_xarray_elemenet;
 
+	rx_sc->md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
+	if (!rx_sc->md_dst) {
+		err = -ENOMEM;
+		goto erase_xa_alloc;
+	}
+
 	rx_sc->sci = ctx_rx_sc->sci;
 	rx_sc->active = ctx_rx_sc->active;
 	list_add_rcu(&rx_sc->rx_sc_list_element, &macsec->macsec_rx_sc_list_head);
 
 	rx_sc->sc_xarray_element = sc_xarray_element;
-
+	rx_sc->md_dst->u.macsec_info.sci = rx_sc->sci;
 	mutex_unlock(&macsec->lock);
 
 	return 0;
 
+erase_xa_alloc:
+	xa_erase(&macsec->sc_xarray, sc_xarray_element->fs_id);
 destroy_sc_xarray_elemenet:
 	kfree(sc_xarray_element);
 destroy_rx_sc:
@@ -558,8 +567,15 @@ static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
 		rx_sc->rx_sa[i] = NULL;
 	}
 
+/*
+ * At this point the relevant MACsec offload Rx rule already removed at
+ * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
+ * Rx related data propagating using xa_erase which uses rcu to sync,
+ * once fs_id is erased then this rx_sc is hidden from datapath.
+ */
 	list_del_rcu(&rx_sc->rx_sc_list_element);
 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
+	metadata_dst_free(rx_sc->md_dst);
 	kfree(rx_sc->sc_xarray_element);
 
 	kfree_rcu(rx_sc);
@@ -821,6 +837,34 @@ void mlx5e_macsec_tx_build_eseg(struct mlx5e_macsec *macsec,
 	eseg->flow_table_metadata = cpu_to_be32(MLX5_ETH_WQE_FT_META_MACSEC | fs_id << 2);
 }
 
+void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
+					struct sk_buff *skb,
+					struct mlx5_cqe64 *cqe)
+{
+	struct mlx5e_macsec_rx_sc_xarray_element *sc_xarray_element;
+	u32 macsec_meta_data = be32_to_cpu(cqe->ft_metadata);
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_macsec_rx_sc *rx_sc;
+	struct mlx5e_macsec *macsec;
+	u32  fs_id;
+
+	macsec = priv->macsec;
+	if (!macsec)
+		return;
+
+	fs_id = MLX5_MACSEC_METADATA_HANDLE(macsec_meta_data);
+
+	rcu_read_lock();
+	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
+	rx_sc = sc_xarray_element->rx_sc;
+	if (rx_sc) {
+		dst_hold(&rx_sc->md_dst->dst);
+		skb_dst_set(skb, &rx_sc->md_dst->dst);
+	}
+
+	rcu_read_unlock();
+}
+
 void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
index 262dddfdd92a..548047d90315 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
@@ -10,6 +10,10 @@
 #include <net/macsec.h>
 #include <net/dst_metadata.h>
 
+/* Bit31 - 30: MACsec marker, Bit3-0: MACsec id */
+#define MLX5_MACSEC_METADATA_MARKER(metadata)  ((((metadata) >> 30) & 0x3)  == 0x1)
+#define MLX5_MACSEC_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(3, 0))
+
 struct mlx5e_priv;
 struct mlx5e_macsec;
 
@@ -28,12 +32,25 @@ static inline bool mlx5e_macsec_skb_is_offload(struct sk_buff *skb)
 	return md_dst && (md_dst->type == METADATA_MACSEC);
 }
 
+static inline bool mlx5e_macsec_is_rx_flow(struct mlx5_cqe64 *cqe)
+{
+	return MLX5_MACSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
+}
+
+void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+					struct mlx5_cqe64 *cqe);
+
 #else
 
 static inline void mlx5e_macsec_build_netdev(struct mlx5e_priv *priv) {}
 static inline int mlx5e_macsec_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_macsec_cleanup(struct mlx5e_priv *priv) {}
 static inline bool mlx5e_macsec_skb_is_offload(struct sk_buff *skb) { return false; }
+static inline bool mlx5e_macsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
+static inline void mlx5e_macsec_offload_handle_rx_skb(struct net_device *netdev,
+						      struct sk_buff *skb,
+						      struct mlx5_cqe64 *cqe)
+{}
 
 #endif  /* CONFIG_MLX5_EN_MACSEC */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 24de37b79f5a..4d3e7897b51b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -49,6 +49,7 @@
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/ipsec.h"
+#include "en_accel/macsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
 #include "en/xdp.h"
@@ -1421,6 +1422,9 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
 		mlx5e_ipsec_offload_handle_rx_skb(netdev, skb, cqe);
 
+	if (unlikely(mlx5e_macsec_is_rx_flow(cqe)))
+		mlx5e_macsec_offload_handle_rx_skb(netdev, skb, cqe);
+
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt, lro_num_seg);
-- 
2.37.2

