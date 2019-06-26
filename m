Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7642F56C2D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfFZOgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60014 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727437AbfFZOgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:31 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:17 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGYD027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 15/16] net/mlx5e: Move queue param structs to en/params.h
Date:   Wed, 26 Jun 2019 17:35:37 +0300
Message-Id: <1561559738-4213-16-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

structs mlx5e_{rq,sq,cq,channel}_param are going to be used in the
upcoming XSK RX and TX patches. Move them to a header file to make
them accessible from other C files.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.h    | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 29 --------------------
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 7f29b82dd8c2..f83417b822bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -11,6 +11,37 @@ struct mlx5e_xsk_param {
 	u16 chunk_size;
 };
 
+struct mlx5e_rq_param {
+	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
+	struct mlx5_wq_param       wq;
+	struct mlx5e_rq_frags_info frags_info;
+};
+
+struct mlx5e_sq_param {
+	u32                        sqc[MLX5_ST_SZ_DW(sqc)];
+	struct mlx5_wq_param       wq;
+	bool                       is_mpw;
+};
+
+struct mlx5e_cq_param {
+	u32                        cqc[MLX5_ST_SZ_DW(cqc)];
+	struct mlx5_wq_param       wq;
+	u16                        eq_ix;
+	u8                         cq_period_mode;
+};
+
+struct mlx5e_channel_param {
+	struct mlx5e_rq_param      rq;
+	struct mlx5e_sq_param      sq;
+	struct mlx5e_sq_param      xdp_sq;
+	struct mlx5e_sq_param      icosq;
+	struct mlx5e_cq_param      rx_cq;
+	struct mlx5e_cq_param      tx_cq;
+	struct mlx5e_cq_param      icosq_cq;
+};
+
+/* Parameter calculations */
+
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c099f5a6124e..f6c603572bd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -57,35 +57,6 @@
 #include "en/reporter.h"
 #include "en/params.h"
 
-struct mlx5e_rq_param {
-	u32			rqc[MLX5_ST_SZ_DW(rqc)];
-	struct mlx5_wq_param	wq;
-	struct mlx5e_rq_frags_info frags_info;
-};
-
-struct mlx5e_sq_param {
-	u32                        sqc[MLX5_ST_SZ_DW(sqc)];
-	struct mlx5_wq_param       wq;
-	bool                       is_mpw;
-};
-
-struct mlx5e_cq_param {
-	u32                        cqc[MLX5_ST_SZ_DW(cqc)];
-	struct mlx5_wq_param       wq;
-	u16                        eq_ix;
-	u8                         cq_period_mode;
-};
-
-struct mlx5e_channel_param {
-	struct mlx5e_rq_param      rq;
-	struct mlx5e_sq_param      sq;
-	struct mlx5e_sq_param      xdp_sq;
-	struct mlx5e_sq_param      icosq;
-	struct mlx5e_cq_param      rx_cq;
-	struct mlx5e_cq_param      tx_cq;
-	struct mlx5e_cq_param      icosq_cq;
-};
-
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
 	bool striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) &&
-- 
1.8.3.1

