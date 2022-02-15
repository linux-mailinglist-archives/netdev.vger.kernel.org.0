Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135C44B638C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiBOGdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:33:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiBOGct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4345AEF28
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69310B817EC
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B813CC340F4;
        Tue, 15 Feb 2022 06:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906757;
        bh=vrCHRt+OUBIrGGVJjsTFXauFdktYVnbyaSTWb/+3zyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIX9n6mUEHWLNq6X71mSLmeE9C1LDZwtVDalrOz6ZvwI6An34PNI2ftOZUZdg3oph
         +CoaL2HxP1jKfnKXDkyB/lWxjx5Gd58oiuCSpS5M8qbwFr1FnA6PiKUbJWzeAZZlh3
         MM8wwLdV8B0dhPcLUgv6Pyca/OAuW0/YBczayO/bT+jxAQYcqi6J+mf8XXYaf3Cs1l
         GFEENKeE8MbpZ5+elTD36Jjbxac1PB4yu9W++0kEei83wvUqP7O6oCMqOU2pizqCCT
         oTMe9JamaOZYZFzpYCOfIVgi/1eqaFN8KSMvvPs4gAdtSZvQFHh5jeBBrm3cj3KESQ
         IQ+yWhtAR61DQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Read max WQEBBs on the SQ from firmware
Date:   Mon, 14 Feb 2022 22:32:16 -0800
Message-Id: <20220215063229.737960-3-saeed@kernel.org>
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

Prior to this patch the maximal value for max WQEBBs (WQE Basic Blocks,
where WQE is a Work Queue Element) on the TX side was assumed to be 16
(fixed value). All firmware versions till today comply to this. In order
to be more flexible and resilient, read from FW the corresponding:
max_wqe_sz_sq. This value describes the maximum WQE size given in bytes,
thus max WQEBBs is given by the division in WQEBB's byte size. The
driver uses the top between 16 and the division result. This ensures
synchronization between driver and firmware and avoids unexpected
behavior. Store this value on the different SQs (Send Queues) for easy
access.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 14 ++++++++++
 .../ethernet/mellanox/mlx5/core/en/params.c   |  8 +++---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 28 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 +--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  6 ++--
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 15 ++++++----
 8 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 1389fd91321b..a51814d9ffa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -221,6 +221,16 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 		min_t(int, mlx5_comp_vectors_count(mdev), MLX5E_MAX_NUM_CHANNELS);
 }
 
+/* The maximum WQE size can be retrieved by max_wqe_sz_sq in
+ * bytes units. Driver hardens the limitation to 1KB (16
+ * WQEBBs), unless firmware capability is stricter.
+ */
+static inline u16 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
+{
+	return min_t(u16, MLX5_SEND_WQE_MAX_WQEBBS,
+		     MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
+}
+
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
@@ -445,6 +455,7 @@ struct mlx5e_txqsq {
 	struct work_struct         recover_work;
 	struct mlx5e_ptpsq        *ptpsq;
 	cqe_ts_to_ns               ptp_cyc2time;
+	u16                        max_sq_wqebbs;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_dma_info {
@@ -539,6 +550,7 @@ struct mlx5e_xdpsq {
 	u32                        sqn;
 	struct device             *pdev;
 	__be32                     mkey_be;
+	u16                        stop_room;
 	u8                         min_inline_mode;
 	unsigned long              state;
 	unsigned int               hw_mtu;
@@ -546,6 +558,7 @@ struct mlx5e_xdpsq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+	u16                        max_sq_wqebbs;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_ktls_resync_resp;
@@ -574,6 +587,7 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+	u16                        max_sq_wqebbs;
 
 	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 66180ffb4606..4ce720da1865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -196,13 +196,13 @@ u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 	u16 stop_room;
 
 	stop_room  = mlx5e_tls_get_stop_room(mdev, params);
-	stop_room += mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	stop_room += mlx5e_stop_room_for_max_wqe(mdev);
 	if (is_mpwqe)
 		/* A MPWQE can take up to the maximum-sized WQE + all the normal
 		 * stop room can be taken if a new packet breaks the active
 		 * MPWQE session and allocates its WQEs right away.
 		 */
-		stop_room += mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+		stop_room += mlx5e_stop_room_for_max_wqe(mdev);
 
 	return stop_room;
 }
@@ -774,10 +774,10 @@ static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
 	mlx5e_build_sq_param_common(mdev, param);
-	param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
+	param->stop_room = mlx5e_stop_room_for_wqe(mdev, 1); /* for XSK NOP */
 	param->is_tls = mlx5e_accel_is_ktls_rx(mdev);
 	if (param->is_tls)
-		param->stop_room += mlx5e_stop_room_for_wqe(1); /* for TLS RX resync NOP */
+		param->stop_room += mlx5e_stop_room_for_wqe(mdev, 1); /* for TLS RX resync NOP */
 	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(mdev, reg_umr_sq));
 	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
 	mlx5e_build_ico_cq_param(mdev, log_wq_size, &param->cqp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index ad4e5e759426..335b20b6383b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -448,7 +448,7 @@ static void mlx5e_ptp_build_sq_param(struct mlx5_core_dev *mdev,
 
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
-	param->stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	param->stop_room = mlx5e_stop_room_for_max_wqe(mdev);
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index b789af07829c..67dd4f415b7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -431,10 +431,10 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	}
 }
 
-static inline u16 mlx5e_stop_room_for_wqe(u16 wqe_size)
-{
-	BUILD_BUG_ON(PAGE_SIZE / MLX5_SEND_WQE_BB < MLX5_SEND_WQE_MAX_WQEBBS);
+#define MLX5E_STOP_ROOM(wqebbs) ((wqebbs) * 2 - 1)
 
+static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_size)
+{
 	/* A WQE must not cross the page boundary, hence two conditions:
 	 * 1. Its size must not exceed the page size.
 	 * 2. If the WQE size is X, and the space remaining in a page is less
@@ -443,18 +443,28 @@ static inline u16 mlx5e_stop_room_for_wqe(u16 wqe_size)
 	 *    stop room of X-1 + X.
 	 * WQE size is also limited by the hardware limit.
 	 */
+	WARN_ONCE(wqe_size > mlx5e_get_max_sq_wqebbs(mdev),
+		  "wqe_size %u is greater than max SQ WQEBBs %u",
+		  wqe_size, mlx5e_get_max_sq_wqebbs(mdev));
 
-	if (__builtin_constant_p(wqe_size))
-		BUILD_BUG_ON(wqe_size > MLX5_SEND_WQE_MAX_WQEBBS);
-	else
-		WARN_ON_ONCE(wqe_size > MLX5_SEND_WQE_MAX_WQEBBS);
 
-	return wqe_size * 2 - 1;
+	return MLX5E_STOP_ROOM(wqe_size);
+}
+
+static inline u16 mlx5e_stop_room_for_max_wqe(struct mlx5_core_dev *mdev)
+{
+	return MLX5E_STOP_ROOM(mlx5e_get_max_sq_wqebbs(mdev));
 }
 
 static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size)
 {
-	u16 room = sq->reserved_room + mlx5e_stop_room_for_wqe(wqe_size);
+	u16 room = sq->reserved_room;
+
+	WARN_ONCE(wqe_size > sq->max_sq_wqebbs,
+		  "wqe_size %u is greater than max SQ WQEBBs %u",
+		  wqe_size, sq->max_sq_wqebbs);
+
+	room += MLX5E_STOP_ROOM(wqe_size);
 
 	return mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 56e10c84a706..a5e71e60e981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -245,10 +245,8 @@ enum {
 INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!sq->mpwqe.wqe)) {
-		const u16 stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
-
 		if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-						     stop_room))) {
+						     sq->stop_room))) {
 			/* SQ is full, ring doorbell */
 			mlx5e_xmit_xdp_doorbell(sq);
 			sq->stats->full++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9ad3459fb63a..aaf11c66bf4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -32,9 +32,9 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 
 	num_dumps = mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PAYLOAD_SIZE);
 
-	stop_room += mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
-	stop_room += mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
-	stop_room += num_dumps * mlx5e_stop_room_for_wqe(MLX5E_KTLS_DUMP_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
+	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
+	stop_room += num_dumps * mlx5e_stop_room_for_wqe(mdev, MLX5E_KTLS_DUMP_WQEBBS);
 
 	return stop_room;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 7a700f913582..a05580cea481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -386,5 +386,5 @@ u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 
 	/* FPGA */
 	/* Resync SKB. */
-	return mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	return mlx5e_stop_room_for_max_wqe(mdev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 31eab1ef14b4..0a0e5bd77384 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -72,12 +72,13 @@
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
-	bool striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) &&
-		MLX5_CAP_GEN(mdev, umr_ptr_rlky) &&
-		MLX5_CAP_ETH(mdev, reg_umr_sq);
-	u16 max_wqe_sz_cap = MLX5_CAP_GEN(mdev, max_wqe_sz_sq);
-	bool inline_umr = MLX5E_UMR_WQE_INLINE_SZ <= max_wqe_sz_cap;
+	bool striding_rq_umr, inline_umr;
+	u16 max_wqe_sz_cap;
 
+	striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) && MLX5_CAP_GEN(mdev, umr_ptr_rlky) &&
+			  MLX5_CAP_ETH(mdev, reg_umr_sq);
+	max_wqe_sz_cap = mlx5e_get_max_sq_wqebbs(mdev) * MLX5_SEND_WQE_BB;
+	inline_umr = max_wqe_sz_cap >= MLX5E_UMR_WQE_INLINE_SZ;
 	if (!striding_rq_umr)
 		return false;
 	if (!inline_umr) {
@@ -1164,6 +1165,8 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 		is_redirect ?
 			&c->priv->channel_stats[c->ix]->xdpsq :
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
+	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
+	sq->stop_room = MLX5E_STOP_ROOM(sq->max_sq_wqebbs);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1238,6 +1241,7 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->reserved_room = param->stop_room;
+	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1323,6 +1327,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
-- 
2.34.1

