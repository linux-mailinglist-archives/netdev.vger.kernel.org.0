Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5762D4B6390
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiBOGdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbiBOGcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2C4B0E8C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3ACBB817EF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED9EC34101;
        Tue, 15 Feb 2022 06:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906757;
        bh=UWWCDdvsYt5hxlhFrybKoLyYEay5BmTjXuWAV/eKxBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oJ7R1VD9kRZT4tQ/jK3ch87XzHfhFe2T7EDBuynxuF4fW+6pC6e3MewX9iOpHZCw3
         tYqmL3wguDEo9kDCn2IGZ9kZtHt3vTagC16K7R0CkSi1oAOYKcpPUfjP/X2iZ77faG
         OYCnWIX30BIf9IG31dcc1Svs4eMXObsLsVexsmTUJ0Plx9IY+EFxdMEtEMTsJ+a1L1
         GUyhiccSNSPkdmcHnMwyFZ/Ce3yN6WRCAMwryhpwovLsGUwnKi2kiLD2Boe0ATX8LK
         mvIgMpYS6RZrealrosMrlK9Omwu1DMQo0KbqKvrYMCRnuoWubsyAm9ciDK+O1iHhVn
         qmVisOWvfR/RQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Use FW limitation for max MPW WQEBBs
Date:   Mon, 14 Feb 2022 22:32:17 -0800
Message-Id: <20220215063229.737960-4-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Calculate maximal count of MPW WQEBBs on SQ's creation and store it
there. Remove MLX5E_TX_MPW_MAX_NUM_DS and MLX5E_TX_MPW_MAX_WQEBBS.
Update mlx5e_tx_mpwqe_is_full() and mlx5e_xdp_mpqwe_is_full() .

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 23 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 17 ++------------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  7 +++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  4 ++--
 8 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a51814d9ffa9..99529e238fc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -172,8 +172,9 @@ struct page_pool;
 #define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
 	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
 
-#define MLX5E_MAX_KLM_PER_WQE \
-	MLX5E_KLM_ENTRIES_PER_WQE(MLX5E_TX_MPW_MAX_NUM_DS << MLX5_MKEY_BSF_OCTO_SIZE)
+#define MLX5E_MAX_KLM_PER_WQE(mdev) \
+	MLX5E_KLM_ENTRIES_PER_WQE(mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)) \
+				   << MLX5_MKEY_BSF_OCTO_SIZE)
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
@@ -231,6 +232,22 @@ static inline u16 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
 		     MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
 }
 
+static inline u16 mlx5e_get_sw_max_sq_mpw_wqebbs(u16 max_sq_wqebbs)
+{
+/* The return value will be multiplied by MLX5_SEND_WQEBB_NUM_DS.
+ * Since max_sq_wqebbs may be up to MLX5_SEND_WQE_MAX_WQEBBS == 16,
+ * see mlx5e_get_max_sq_wqebbs(), the multiplication (16 * 4 == 64)
+ * overflows the 6-bit DS field of Ctrl Segment. Use a bound lower
+ * than MLX5_SEND_WQE_MAX_WQEBBS to let a full-session WQE be
+ * cache-aligned.
+ */
+#if L1_CACHE_BYTES < 128
+	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
+#else
+	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 2);
+#endif
+}
+
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
@@ -437,6 +454,7 @@ struct mlx5e_txqsq {
 	struct netdev_queue       *txq;
 	u32                        sqn;
 	u16                        stop_room;
+	u16                        max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
@@ -551,6 +569,7 @@ struct mlx5e_xdpsq {
 	struct device             *pdev;
 	__be32                     mkey_be;
 	u16                        stop_room;
+	u16                        max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	unsigned long              state;
 	unsigned int               hw_mtu;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 4ce720da1865..d41936d65483 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -717,7 +717,7 @@ static u32 mlx5e_shampo_icosq_sz(struct mlx5_core_dev *mdev,
 	int wq_size = BIT(MLX5_GET(wq, wqc, log_wq_sz));
 	u32 wqebbs;
 
-	max_klm_per_umr = MLX5E_MAX_KLM_PER_WQE;
+	max_klm_per_umr = MLX5E_MAX_KLM_PER_WQE(mdev);
 	max_hd_per_wqe = mlx5e_shampo_hd_per_wqe(mdev, params, rq_param);
 	max_num_of_umr_per_wqe = max_hd_per_wqe / max_klm_per_umr;
 	rest = max_hd_per_wqe % max_klm_per_umr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 67dd4f415b7a..1c48cfad9dd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -9,19 +9,6 @@
 
 #define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 
-/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
- * (16 * 4 == 64) does not fit in the 6-bit DS field of Ctrl Segment.
- * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
- * full-session WQE be cache-aligned.
- */
-#if L1_CACHE_BYTES < 128
-#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
-#else
-#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
-#endif
-
-#define MLX5E_TX_MPW_MAX_NUM_DS (MLX5E_TX_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS)
-
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
@@ -308,9 +295,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq);
 
-static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
+static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session, u8 max_sq_mpw_wqebbs)
 {
-	return session->ds_count == MLX5E_TX_MPW_MAX_NUM_DS;
+	return session->ds_count == max_sq_mpw_wqebbs * MLX5_SEND_WQEBB_NUM_DS;
 }
 
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index a5e71e60e981..a7f020399370 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -199,7 +199,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
 
-	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
+	pi = mlx5e_xdpsq_get_next_pi(sq, sq->max_sq_mpw_wqebbs);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(wqe->data);
 
@@ -286,7 +286,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 
 	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
 
-	if (unlikely(mlx5e_xdp_mpqwe_is_full(session)))
+	if (unlikely(mlx5e_xdp_mpqwe_is_full(session, sq->max_sq_mpw_wqebbs)))
 		mlx5e_xdp_mpwqe_complete(sq);
 
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 8d991c3b7a50..c62f11d7ef6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -123,12 +123,13 @@ static inline bool mlx5e_xdp_get_inline_state(struct mlx5e_xdpsq *sq, bool cur)
 	return cur;
 }
 
-static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_tx_mpwqe *session)
+static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_tx_mpwqe *session, u8 max_sq_mpw_wqebbs)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
-		       MLX5E_TX_MPW_MAX_NUM_DS;
-	return mlx5e_tx_mpwqe_is_full(session);
+		       max_sq_mpw_wqebbs * MLX5_SEND_WQEBB_NUM_DS;
+
+	return mlx5e_tx_mpwqe_is_full(session, max_sq_mpw_wqebbs);
 }
 
 struct mlx5e_xdp_wqe_info {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0a0e5bd77384..59427c5f5622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1167,6 +1167,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
 	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
 	sq->stop_room = MLX5E_STOP_ROOM(sq->max_sq_wqebbs);
+	sq->max_sq_mpw_wqebbs = mlx5e_get_sw_max_sq_mpw_wqebbs(sq->max_sq_wqebbs);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1328,6 +1329,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
+	sq->max_sq_mpw_wqebbs = mlx5e_get_sw_max_sq_mpw_wqebbs(sq->max_sq_wqebbs);
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ee0a8f5206e3..91fdf957cd7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -620,7 +620,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	struct mlx5e_icosq *sq = rq->icosq;
 	int i, err, max_klm_entries, len;
 
-	max_klm_entries = MLX5E_MAX_KLM_PER_WQE;
+	max_klm_entries = MLX5E_MAX_KLM_PER_WQE(rq->mdev);
 	klm_entries = bitmap_find_window(shampo->bitmap,
 					 shampo->hd_per_wqe,
 					 shampo->hd_per_wq, shampo->pi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index ee7ecb88adc1..9c91ef0e1ed2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -544,7 +544,7 @@ static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
 
-	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
+	pi = mlx5e_txqsq_get_next_pi(sq, sq->max_sq_mpw_wqebbs);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(wqe->data);
 
@@ -645,7 +645,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	mlx5e_tx_skb_update_hwts_flags(skb);
 
-	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe))) {
+	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe, sq->max_sq_mpw_wqebbs))) {
 		/* Might stop the queue and affect the retval of __netdev_tx_sent_queue. */
 		cseg = mlx5e_tx_mpwqe_session_complete(sq);
 
-- 
2.34.1

