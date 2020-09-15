Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85D26AF37
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgIOVK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgIOU1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:27:43 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF783221E7;
        Tue, 15 Sep 2020 20:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201562;
        bh=fvWSxNm0lJCp/4k9z5U/5ySAw3alA5D82FxUeCeGzw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8wslCqqvwvQS+mzIibksMuhpcZtzzx/jB3BUH91yDuU1OJwZy4psovKdgndZvQDN
         EKvlzsmh1yBRz0CsOaps4NZDkqvYs4K+Gw48VImtalO9LG4GMlfFnoPw9MuA8VR6/7
         qnNDC6aMnb6i37o38FGSW7AMMPp+6dn/ruVrG91A=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ofer Levi <oferle@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5e: Add CQE compression support for multi-strides packets
Date:   Tue, 15 Sep 2020 13:25:33 -0700
Message-Id: <20200915202533.64389-17-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ofer Levi <oferle@mellanox.com>

Add CQE compression support for completions of packets that span
multiple strides in a Striding RQ, per the HW capability.
In our memory model, we use small strides (256B as of today) for the
non-linear SKB mode. This feature allows CQE compression to work also
for multiple strides packets. In this case decompressing the mini CQE
array will use stride index provided by HW as part of the mini CQE.
Before this feature, compression was possible only for single-strided
packets, i.e. for packets of size up to 256 bytes when in non-linear
mode, and the index was maintained by SW.
This feature is supported for ConnectX-5 and above.

Feature performance test:
This was whitebox-tested, we reduced the PCI speed from 125Gb/s to
62.5Gb/s to overload pci and manipulated mlx5 driver to drop incoming
packets before building the SKB to achieve low cpu utilization.
Outcome is low cpu utilization and bottleneck on pci only.
Test setup:
Server: Intel(R) Xeon(R) Silver 4108 CPU @ 1.80GHz server, 32 cores
NIC: ConnectX-6 DX.
Sender side generates 300 byte packets at full pci bandwidth.
Receiver side configuration:
Single channel, one cpu processing with one ring allocated. Cpu utilization
is ~20% while pci bandwidth is fully utilized.
For the generated traffic and interface MTU of 4500B (to activate the
non-linear SKB mode), packet rate improvement is about 19% from ~17.6Mpps
to ~21Mpps.
Without this feature, counters show no CQE compression blocks for
this setup, while with the feature, counters show ~20.7Mpps compressed CQEs
in ~500K compression blocks.

Signed-off-by: Ofer Levi <oferle@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 11 ++++++++++-
 include/linux/mlx5/device.h                       |  3 ++-
 4 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4f33658da25a..95aab8b429cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -265,6 +265,7 @@ enum {
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
 	MLX5E_RQ_STATE_FPGA_TLS, /* FPGA TLS enabled */
+	MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX /* set when mini_cqe_resp_stride_index cap is used */
 };
 
 struct mlx5e_cq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 26834625556d..b057a6c3a6d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -848,6 +848,13 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_NO_CSUM_COMPLETE) || c->xdp)
 		__set_bit(MLX5E_RQ_STATE_NO_CSUM_COMPLETE, &c->rq.state);
 
+	/* For CQE compression on striding RQ, use stride index provided by
+	 * HW if capability is supported.
+	 */
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) &&
+	    MLX5_CAP_GEN(c->mdev, mini_cqe_resp_stride_index))
+		__set_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &c->rq.state);
+
 	return 0;
 
 err_destroy_rq:
@@ -2182,6 +2189,7 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_cq_param *param)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	bool hw_stridx = false;
 	void *cqc = param->cqc;
 	u8 log_cq_size;
 
@@ -2189,6 +2197,7 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
 			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
+		hw_stridx = MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index);
 		break;
 	default: /* MLX5_WQ_TYPE_CYCLIC */
 		log_cq_size = params->log_rq_mtu_frames;
@@ -2196,7 +2205,8 @@ void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
 
 	MLX5_SET(cqc, cqc, log_cq_size, log_cq_size);
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		MLX5_SET(cqc, cqc, mini_cqe_res_format, MLX5_CQE_FORMAT_CSUM);
+		MLX5_SET(cqc, cqc, mini_cqe_res_format, hw_stridx ?
+			 MLX5_CQE_FORMAT_CSUM_STRIDX : MLX5_CQE_FORMAT_CSUM);
 		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7aab69e991a5..c9c82b14060a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -137,8 +137,17 @@ static inline void mlx5e_decompress_cqe(struct mlx5e_rq *rq,
 	title->check_sum    = mini_cqe->checksum;
 	title->op_own      &= 0xf0;
 	title->op_own      |= 0x01 & (cqcc >> wq->fbc.log_sz);
-	title->wqe_counter  = cpu_to_be16(cqd->wqe_counter);
 
+	/* state bit set implies linked-list striding RQ wq type and
+	 * HW stride index capability supported
+	 */
+	if (test_bit(MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, &rq->state)) {
+		title->wqe_counter = mini_cqe->stridx;
+		return;
+	}
+
+	/* HW stride index capability not supported */
+	title->wqe_counter = cpu_to_be16(cqd->wqe_counter);
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
 		cqd->wqe_counter += mpwrq_get_cqe_consumed_strides(title);
 	else
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 4d3376e20f5e..81ca5989009b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -816,7 +816,7 @@ struct mlx5_mini_cqe8 {
 		__be32 rx_hash_result;
 		struct {
 			__be16 checksum;
-			__be16 rsvd;
+			__be16 stridx;
 		};
 		struct {
 			__be16 wqe_counter;
@@ -836,6 +836,7 @@ enum {
 
 enum {
 	MLX5_CQE_FORMAT_CSUM = 0x1,
+	MLX5_CQE_FORMAT_CSUM_STRIDX = 0x3,
 };
 
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
-- 
2.26.2

