Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882514DE2ED
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240889AbiCRUyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiCRUyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55474DF34
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 070CAB82580
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71772C340F4;
        Fri, 18 Mar 2022 20:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636793;
        bh=DyNKCwiBmYfrebQN2lwtu/b5agGK2JOsbVPEn5P1uxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWx8fplj3iY3z+w6bXrWGADQxQeS3polSBS+gZUV2yHASK7FMmpImo1Ozu6oKiFK9
         /onLKHjPP1sRkSoUwOWJQrsH4M9Y1lRsybZVOTNlxkpeRuaWof6ARHbNCfCF/hNLYv
         RZEAp+qeNBbYBGc/djRFrmKJ3MbSSct8Q+UFUOBTmyxoNgC5TSlViC3gzQzatG41h5
         IUw3298GluYIjsssGhsqBQQPgqBEVr6V+XCkkVGTNHQbiw23sS+ni3PIRxcYVjXhNu
         TXab8+mQsBL5TQDZ2yHGq3MPAVdLjoTzrHJDjdz74+T0Pss5jfLsqchMq2++Gv7y9m
         dRUux6BL48Yag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode
Date:   Fri, 18 Mar 2022 13:52:41 -0700
Message-Id: <20220318205248.33367-9-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

When MPWQE is disabled, mlx5e_open_xdpsq() prefills the common fields of
WQEs in the XDP SQ to save time when sending packets.
mlx5e_xmit_xdp_frame() runs on the prefilled fields, however, sending
multi buffer XDP frames would require changing some of these fields on a
per-packet basis. Besides that, mlx5e_xmit_xdp_frame() will be used as a
fallback to send multi buffer XDP frames when MPWQE is enabled (MPWQE
can only handle linear packets).

In order to prepare for XDP multi buffer support, this commit introduces
a mode for mlx5e_xmit_xdp_frame() that fills all the fields itself.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/params.c   |  4 ++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 32 +++++++++++++++++--
 .../mellanox/mlx5/core/en/xsk/setup.c         |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-
 6 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d084f930bb37..cf935a7bf387 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -405,6 +405,7 @@ enum {
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
+	MLX5E_SQ_STATE_XDP_MULTIBUF,
 };
 
 struct mlx5e_tx_mpwqe {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 9646867872c1..08fd1370a8b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -843,6 +843,7 @@ static void mlx5e_build_async_icosq_param(struct mlx5_core_dev *mdev,
 
 void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk,
 			     struct mlx5e_sq_param *param)
 {
 	void *sqc = param->sqc;
@@ -851,6 +852,7 @@ void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 	mlx5e_build_sq_param_common(mdev, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
+	param->is_xdp_mb = !mlx5e_rx_is_linear_skb(params, xsk);
 	mlx5e_build_tx_cq_param(mdev, params, &param->cqp);
 }
 
@@ -870,7 +872,7 @@ int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(mdev);
 
 	mlx5e_build_sq_param(mdev, params, &cparam->txq_sq);
-	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
+	mlx5e_build_xdpsq_param(mdev, params, NULL, &cparam->xdp_sq);
 	mlx5e_build_icosq_param(mdev, icosq_log_wq_sz, &cparam->icosq);
 	mlx5e_build_async_icosq_param(mdev, async_icosq_log_wq_sz, &cparam->async_icosq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 47a368112e31..f5c46e78eebc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -31,6 +31,7 @@ struct mlx5e_sq_param {
 	struct mlx5_wq_param       wq;
 	bool                       is_mpw;
 	bool                       is_tls;
+	bool                       is_xdp_mb;
 	u16                        stop_room;
 };
 
@@ -155,6 +156,7 @@ void mlx5e_build_tx_cq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_cq_param *param);
 void mlx5e_build_xdpsq_param(struct mlx5_core_dev *mdev,
 			     struct mlx5e_params *params,
+			     struct mlx5e_xsk_param *xsk,
 			     struct mlx5e_sq_param *param);
 int mlx5e_build_channel_param(struct mlx5_core_dev *mdev,
 			      struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 9478df6c87bc..b220e613d102 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -323,6 +323,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	dma_addr_t dma_addr = xdptxd->dma_addr;
 	u32 dma_len = xdptxd->len;
+	u16 ds_cnt, inline_hdr_sz;
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
@@ -338,7 +339,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 	if (unlikely(check_result < 0))
 		return false;
 
-	cseg->fm_ce_se = 0;
+	ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT + 1;
+	inline_hdr_sz = 0;
 
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
@@ -347,7 +349,9 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		       MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
 		dma_addr += MLX5E_XDP_MIN_INLINE;
+		inline_hdr_sz = MLX5E_XDP_MIN_INLINE;
 		dseg++;
+		ds_cnt++;
 	}
 
 	/* write the dma part */
@@ -356,7 +360,31 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_SEND);
 
-	sq->pc++;
+	if (unlikely(test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state))) {
+		u8 num_pkts = 1;
+		u8 num_wqebbs;
+
+		memset(&cseg->signature, 0, sizeof(*cseg) -
+		       sizeof(cseg->opmod_idx_opcode) - sizeof(cseg->qpn_ds));
+		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
+
+		eseg->inline_hdr.sz = cpu_to_be16(inline_hdr_sz);
+		dseg->lkey = sq->mkey_be;
+
+		cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_cnt);
+
+		num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
+		sq->db.wqe_info[pi] = (struct mlx5e_xdp_wqe_info) {
+			.num_wqebbs = num_wqebbs,
+			.num_pkts = num_pkts,
+		};
+
+		sq->pc += num_wqebbs;
+	} else {
+		cseg->fm_ce_se = 0;
+
+		sq->pc++;
+	}
 
 	sq->doorbell_cseg = cseg;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 25eac9e20342..3ad7f1301fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -43,7 +43,7 @@ static void mlx5e_build_xsk_cparam(struct mlx5_core_dev *mdev,
 				   struct mlx5e_channel_param *cparam)
 {
 	mlx5e_build_rq_param(mdev, params, xsk, q_counter, &cparam->rq);
-	mlx5e_build_xdpsq_param(mdev, params, &cparam->xdp_sq);
+	mlx5e_build_xdpsq_param(mdev, params, xsk, &cparam->xdp_sq);
 }
 
 static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f21cae712ce5..95cec2848685 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1666,13 +1666,21 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	csp.wq_ctrl         = &sq->wq_ctrl;
 	csp.min_inline_mode = sq->min_inline_mode;
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+
+	/* Don't enable multi buffer on XDP_REDIRECT SQ, as it's not yet
+	 * supported by upstream, and there is no defined trigger to allow
+	 * transmitting redirected multi-buffer frames.
+	 */
+	if (param->is_xdp_mb && !is_redirect)
+		set_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state);
+
 	err = mlx5e_create_sq_rdy(c->mdev, param, &csp, 0, &sq->sqn);
 	if (err)
 		goto err_free_xdpsq;
 
 	mlx5e_set_xmit_fp(sq, param->is_mpw);
 
-	if (!param->is_mpw) {
+	if (!param->is_mpw && !test_bit(MLX5E_SQ_STATE_XDP_MULTIBUF, &sq->state)) {
 		unsigned int ds_cnt = MLX5E_XDP_TX_DS_COUNT;
 		unsigned int inline_hdr_sz = 0;
 		int i;
-- 
2.35.1

