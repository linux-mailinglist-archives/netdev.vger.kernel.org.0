Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF366268D0
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiKLKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiKLKWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534A522513
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D165CB80707
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6683BC433B5;
        Sat, 12 Nov 2022 10:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248519;
        bh=c3QyIdN8ABNMeehnuOh9ZYkx/7KqNaEIijQQk1r5Is8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8gpddtcf29qYaItuYbo8EM7FmZHOu5hsatM3GKyYJSUhcxeVVyM2vX/zWciJjtjc
         GbnozNryTjGQHoOsscNGTiNGcGgPKCNgUhXOHSl303x/XpcC5qryo+5UN9e39JcEXl
         3XWCrZ67h83ElUADLbPWgYejMMO8zfWMwNvyRmJottuIOcWBUNwFpm6ZW1ZQDaOcVk
         mF6NomlRd0AVGFHiJTPhTnmexcVtJ6pLYlTJw1apsNyr+5kliaOxdc9fKpbTwtlixK
         Dmr5Rj8AJE/b2y6YKZWXgpZkryyY71FIO/MhTTEpX+BricDeGOMlfLJJjCUecyXt3B
         GHJKqnpKWOROg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Ofer Levi <oferle@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Support enhanced CQE compression
Date:   Sat, 12 Nov 2022 02:21:39 -0800
Message-Id: <20221112102147.496378-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Ofer Levi <oferle@nvidia.com>

CQE compression feature improves performance by reducing PCI bandwidth
bottleneck on CQEs write.
Enhanced CQE compression introduced in ConnectX-6 and it aims to reduce
CPU utilization of SW side packets decompression by eliminating the
need to rewrite ownership bit, which is likely to cost a cache-miss, is
replaced by validity byte handled solely by HW.
Another advantage of the enhanced feature is that session packets are
available to SW as soon as a single CQE slot is filled, instead of
waiting for session to close, this improves packet latency from NIC to
host.

Performance:
Following are tested scenarios and reults comparing basic and enahnced
CQE compression.

setup: IXIA 100GbE connected directly to port 0 and port 1 of
ConnectX-6 Dx 100GbE dual port.

Case #1 RX only, single flow goes to single queue:
IRQ rate reduced by ~ 30%, CPU utilization improved by 2%.

Case #2 IP forwarding from port 1 to port 0 single flow goes to
single queue:
Avg latency improved from 60us to 21us, frame loss improved from 0.5% to 0.0%.

Case #3 IP forwarding from port 1 to port 0 Max Throughput IXIA sends
100%, 8192 UDP flows, goes to 24 queues:
Enhanced is equal or slightly better than basic.

Testing the basic compression feature with this patch shows there is
no perfrormance degradation of the basic compression feature.

Signed-off-by: Ofer Levi <oferle@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 150 +++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |  17 ++
 include/linux/mlx5/device.h                   |   6 +
 6 files changed, 170 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 26a23047f1f3..ff5b302531d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -344,6 +344,7 @@ enum {
 	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
 	MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, /* set when mini_cqe_resp_stride_index cap is used */
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
+	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
 };
 
 struct mlx5e_cq {
@@ -370,6 +371,7 @@ struct mlx5e_cq_decomp {
 	u8                         mini_arr_idx;
 	u16                        left;
 	u16                        wqe_counter;
+	bool                       last_cqe_title;
 } ____cacheline_aligned_in_smp;
 
 enum mlx5e_dma_map_type {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 29dd3a04c154..1a2de9bc6538 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -608,13 +608,15 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 		MLX5E_PARAMS_MINIMUM_LOG_RQ_SIZE :
 		MLX5E_PARAMS_DEFAULT_LOG_RQ_SIZE;
 
-	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d)\n",
+	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d %s)\n",
 		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
 		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
 		       BIT(mlx5e_mpwqe_get_log_rq_size(mdev, params, NULL)) :
 		       BIT(params->log_rq_mtu_frames),
 		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
-		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS));
+		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS),
+		       MLX5_CAP_GEN(mdev, enhanced_cqe_compression) ?
+				       "enhanced" : "basic");
 }
 
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
@@ -852,6 +854,10 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
 		MLX5_SET(cqc, cqc, mini_cqe_res_format, hw_stridx ?
 			 MLX5_CQE_FORMAT_CSUM_STRIDX : MLX5_CQE_FORMAT_CSUM);
+		MLX5_SET(cqc, cqc, cqe_compression_layout,
+			 MLX5_CAP_GEN(mdev, enhanced_cqe_compression) ?
+			 MLX5_CQE_COMPRESS_LAYOUT_ENHANCED :
+			 MLX5_CQE_COMPRESS_LAYOUT_BASIC);
 		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1669c7d7f285..c462b76743b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1205,6 +1205,13 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 	    MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index))
 		__set_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &rq->state);
 
+	/* For enhanced CQE compression packet processing. decompress
+	 * session according to the enhanced layout.
+	 */
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS) &&
+	    MLX5_CAP_GEN(mdev, enhanced_cqe_compression))
+		__set_bit(MLX5E_RQ_STATE_MINI_CQE_ENHANCED, &rq->state);
+
 	return 0;
 
 err_destroy_rq:
@@ -1895,6 +1902,7 @@ static int mlx5e_alloc_cq_common(struct mlx5e_priv *priv,
 		struct mlx5_cqe64 *cqe = mlx5_cqwq_get_wqe(&cq->wq, i);
 
 		cqe->op_own = 0xf1;
+		cqe->validity_iteration_count = 0xff;
 	}
 
 	cq->mdev = mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a61a43fc8d5c..b1ea0b995d9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -89,6 +89,25 @@ static inline void mlx5e_read_cqe_slot(struct mlx5_cqwq *wq,
 	memcpy(data, mlx5_cqwq_get_wqe(wq, ci), sizeof(struct mlx5_cqe64));
 }
 
+static void mlx5e_read_enhanced_title_slot(struct mlx5e_rq *rq,
+					   struct mlx5_cqe64 *cqe)
+{
+	struct mlx5e_cq_decomp *cqd = &rq->cqd;
+	struct mlx5_cqe64 *title = &cqd->title;
+
+	memcpy(title, cqe, sizeof(struct mlx5_cqe64));
+
+	if (likely(test_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &rq->state)))
+		return;
+
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+		cqd->wqe_counter = mpwrq_get_cqe_stride_index(title) +
+			mpwrq_get_cqe_consumed_strides(title);
+	else
+		cqd->wqe_counter =
+			mlx5_wq_cyc_ctr2ix(&rq->wqe.wq, be16_to_cpu(title->wqe_counter) + 1);
+}
+
 static inline void mlx5e_read_title_slot(struct mlx5e_rq *rq,
 					 struct mlx5_cqwq *wq,
 					 u32 cqcc)
@@ -175,6 +194,38 @@ static inline void mlx5e_decompress_cqe_no_hash(struct mlx5e_rq *rq,
 	cqd->title.rss_hash_result = 0;
 }
 
+static u32 mlx5e_decompress_enhanced_cqe(struct mlx5e_rq *rq,
+					 struct mlx5_cqwq *wq,
+					 struct mlx5_cqe64 *cqe,
+					 int budget_rem)
+{
+	struct mlx5e_cq_decomp *cqd = &rq->cqd;
+	u32 cqcc, left;
+	u32 i;
+
+	left = get_cqe_enhanced_num_mini_cqes(cqe);
+	/* Here we avoid breaking the cqe compression session in the middle
+	 * in case budget is not sufficient to handle all of it. In this case
+	 * we return work_done == budget_rem to give 'busy' napi indication.
+	 */
+	if (unlikely(left > budget_rem))
+		return budget_rem;
+
+	cqcc = wq->cc;
+	cqd->mini_arr_idx = 0;
+	memcpy(cqd->mini_arr, cqe, sizeof(struct mlx5_cqe64));
+	for (i = 0; i < left; i++, cqd->mini_arr_idx++, cqcc++) {
+		mlx5e_decompress_cqe_no_hash(rq, wq, cqcc);
+		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq_shampo,
+				rq, &cqd->title);
+	}
+	wq->cc = cqcc;
+	rq->stats->cqe_compress_pkts += left;
+
+	return left;
+}
+
 static inline u32 mlx5e_decompress_cqes_cont(struct mlx5e_rq *rq,
 					     struct mlx5_cqwq *wq,
 					     int update_owner_only,
@@ -220,7 +271,7 @@ static inline u32 mlx5e_decompress_cqes_start(struct mlx5e_rq *rq,
 			rq, &cqd->title);
 	cqd->mini_arr_idx++;
 
-	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem) - 1;
+	return mlx5e_decompress_cqes_cont(rq, wq, 1, budget_rem);
 }
 
 static inline bool mlx5e_rx_cache_put(struct mlx5e_rq *rq, struct page *page)
@@ -2211,45 +2262,102 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
 
-int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
+static int mlx5e_rx_cq_process_enhanced_cqe_comp(struct mlx5e_rq *rq,
+						 struct mlx5_cqwq *cqwq,
+						 int budget_rem)
 {
-	struct mlx5e_rq *rq = container_of(cq, struct mlx5e_rq, cq);
-	struct mlx5_cqwq *cqwq = &cq->wq;
-	struct mlx5_cqe64 *cqe;
+	struct mlx5_cqe64 *cqe, *title_cqe = NULL;
+	struct mlx5e_cq_decomp *cqd = &rq->cqd;
 	int work_done = 0;
 
-	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
-		return 0;
+	cqe = mlx5_cqwq_get_cqe_enahnced_comp(cqwq);
+	if (!cqe)
+		return work_done;
 
-	if (rq->cqd.left) {
-		work_done += mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
-		if (work_done >= budget)
-			goto out;
+	if (cqd->last_cqe_title &&
+	    (mlx5_get_cqe_format(cqe) == MLX5_COMPRESSED)) {
+		rq->stats->cqe_compress_blks++;
+		cqd->last_cqe_title = false;
 	}
 
-	cqe = mlx5_cqwq_get_cqe(cqwq);
-	if (!cqe) {
-		if (unlikely(work_done))
-			goto out;
-		return 0;
+	do {
+		if (mlx5_get_cqe_format(cqe) == MLX5_COMPRESSED) {
+			if (title_cqe) {
+				mlx5e_read_enhanced_title_slot(rq, title_cqe);
+				title_cqe = NULL;
+				rq->stats->cqe_compress_blks++;
+			}
+			work_done +=
+				mlx5e_decompress_enhanced_cqe(rq, cqwq, cqe,
+							      budget_rem - work_done);
+			continue;
+		}
+		title_cqe = cqe;
+		mlx5_cqwq_pop(cqwq);
+
+		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
+				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq_shampo,
+				rq, cqe);
+		work_done++;
+	} while (work_done < budget_rem &&
+		 (cqe = mlx5_cqwq_get_cqe_enahnced_comp(cqwq)));
+
+	/* last cqe might be title on next poll bulk */
+	if (title_cqe) {
+		mlx5e_read_enhanced_title_slot(rq, title_cqe);
+		cqd->last_cqe_title = true;
 	}
 
-	do {
+	return work_done;
+}
+
+static int mlx5e_rx_cq_process_basic_cqe_comp(struct mlx5e_rq *rq,
+					      struct mlx5_cqwq *cqwq,
+					      int budget_rem)
+{
+	struct mlx5_cqe64 *cqe;
+	int work_done = 0;
+
+	if (rq->cqd.left)
+		work_done += mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget_rem);
+
+	while (work_done < budget_rem && (cqe = mlx5_cqwq_get_cqe(cqwq))) {
 		if (mlx5_get_cqe_format(cqe) == MLX5_COMPRESSED) {
 			work_done +=
 				mlx5e_decompress_cqes_start(rq, cqwq,
-							    budget - work_done);
+							    budget_rem - work_done);
 			continue;
 		}
 
 		mlx5_cqwq_pop(cqwq);
-
 		INDIRECT_CALL_3(rq->handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq,
 				mlx5e_handle_rx_cqe, mlx5e_handle_rx_cqe_mpwrq_shampo,
 				rq, cqe);
-	} while ((++work_done < budget) && (cqe = mlx5_cqwq_get_cqe(cqwq)));
+		work_done++;
+	}
+
+	return work_done;
+}
+
+int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
+{
+	struct mlx5e_rq *rq = container_of(cq, struct mlx5e_rq, cq);
+	struct mlx5_cqwq *cqwq = &cq->wq;
+	int work_done;
+
+	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
+		return 0;
+
+	if (test_bit(MLX5E_RQ_STATE_MINI_CQE_ENHANCED, &rq->state))
+		work_done = mlx5e_rx_cq_process_enhanced_cqe_comp(rq, cqwq,
+								  budget);
+	else
+		work_done = mlx5e_rx_cq_process_basic_cqe_comp(rq, cqwq,
+							       budget);
+
+	if (work_done == 0)
+		return 0;
 
-out:
 	if (test_bit(MLX5E_RQ_STATE_SHAMPO, &rq->state) && rq->hw_gro_data->skb)
 		mlx5e_shampo_flush_skb(rq, NULL, false);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index 4d629e5ddbc7..e4ef1d24a3ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -243,6 +243,23 @@ static inline struct mlx5_cqe64 *mlx5_cqwq_get_cqe(struct mlx5_cqwq *wq)
 	return cqe;
 }
 
+static inline
+struct mlx5_cqe64 *mlx5_cqwq_get_cqe_enahnced_comp(struct mlx5_cqwq *wq)
+{
+	u8 sw_validity_iteration_count = mlx5_cqwq_get_wrap_cnt(wq) & 0xff;
+	u32 ci = mlx5_cqwq_get_ci(wq);
+	struct mlx5_cqe64 *cqe;
+
+	cqe = mlx5_cqwq_get_wqe(wq, ci);
+	if (cqe->validity_iteration_count != sw_validity_iteration_count)
+		return NULL;
+
+	/* ensure cqe content is read after cqe ownership bit/validity byte */
+	dma_rmb();
+
+	return cqe;
+}
+
 static inline u32 mlx5_wq_ll_get_size(struct mlx5_wq_ll *wq)
 {
 	return (u32)wq->fbc.sz_m1 + 1;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1ff91cb79ded..eb3fac30488b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -882,6 +882,12 @@ static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)
 	return cqe->op_own >> 4;
 }
 
+static inline u8 get_cqe_enhanced_num_mini_cqes(struct mlx5_cqe64 *cqe)
+{
+	/* num_of_mini_cqes is zero based */
+	return get_cqe_opcode(cqe) + 1;
+}
+
 static inline u8 get_cqe_lro_tcppsh(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->lro.tcppsh_abort_dupack >> 6) & 1;
-- 
2.38.1

