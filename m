Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B90A6DEA30
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDLEIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDLEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880CA4C1B
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 695AD62DA5
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD39C433D2;
        Wed, 12 Apr 2023 04:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272492;
        bh=ypxZFrcT+gYp7fjTju/kCgC618tzHxZo5mFpe1G1ni0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOzEoqWUNhgnwBKqd2XU4RqVXEP4uS9fNOMXi8eYQ189NiYFeXZ/D87+zDolc0oe0
         P5xcDcyie1r4ubS4wqLSCc9DTpK0mN21UqCyPvVLi7KoA5MFmkncyhf+ZrGX/rpIos
         2cMVXXameAK8riK8i7kr/x3ORbFR/KpR2ADkz8l7636qb7jhEcgY3lfIBm0wr+FSdo
         9JZkOnAh2MDcquU2cJ0Tu8iq9GWu5wKpD7YiBTN/T9ta7CWq64oIn9Yvcv4SSHvS/2
         Ktb1K77/yylZX1cHI+S8gAD9ppuyUSqC6Np6dgPuiDGMFyygWeHurB/Bx8kshXtWu+
         XLaO4wbSOG7gg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 14/15] net/mlx5: DR, Prepare sending new WQE type
Date:   Tue, 11 Apr 2023 21:07:51 -0700
Message-Id: <20230412040752.14220-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The send engine should be ready to handle more opcodes
in addition to RDMA_WRITE/RDMA_READ.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c     | 60 ++++++++++++-------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index fd2d31cdbcf9..00bb65613300 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -18,7 +18,12 @@ struct dr_data_seg {
 	unsigned int send_flags;
 };
 
+enum send_info_type {
+	WRITE_ICM = 0,
+};
+
 struct postsend_info {
+	enum send_info_type type;
 	struct dr_data_seg write;
 	struct dr_data_seg read;
 	u64 remote_addr;
@@ -402,10 +407,12 @@ static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
 
 static void dr_post_send(struct mlx5dr_qp *dr_qp, struct postsend_info *send_info)
 {
-	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
-			 &send_info->write, MLX5_OPCODE_RDMA_WRITE, false);
-	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
-			 &send_info->read, MLX5_OPCODE_RDMA_READ, true);
+	if (send_info->type == WRITE_ICM) {
+		dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
+				 &send_info->write, MLX5_OPCODE_RDMA_WRITE, false);
+		dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
+				 &send_info->read, MLX5_OPCODE_RDMA_READ, true);
+	}
 }
 
 /**
@@ -476,9 +483,26 @@ static int dr_handle_pending_wc(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
-static void dr_fill_data_segs(struct mlx5dr_send_ring *send_ring,
-			      struct postsend_info *send_info)
+static void dr_fill_write_icm_segs(struct mlx5dr_domain *dmn,
+				   struct mlx5dr_send_ring *send_ring,
+				   struct postsend_info *send_info)
 {
+	u32 buff_offset;
+
+	if (send_info->write.length > dmn->info.max_inline_size) {
+		buff_offset = (send_ring->tx_head &
+			       (dmn->send_ring->signal_th - 1)) *
+			      send_ring->max_post_send_size;
+		/* Copy to ring mr */
+		memcpy(send_ring->buf + buff_offset,
+		       (void *)(uintptr_t)send_info->write.addr,
+		       send_info->write.length);
+		send_info->write.addr = (uintptr_t)send_ring->mr->dma_addr + buff_offset;
+		send_info->write.lkey = send_ring->mr->mkey;
+
+		send_ring->tx_head++;
+	}
+
 	send_ring->pending_wqe++;
 
 	if (send_ring->pending_wqe % send_ring->signal_th == 0)
@@ -496,11 +520,18 @@ static void dr_fill_data_segs(struct mlx5dr_send_ring *send_ring,
 		send_info->read.send_flags = 0;
 }
 
+static void dr_fill_data_segs(struct mlx5dr_domain *dmn,
+			      struct mlx5dr_send_ring *send_ring,
+			      struct postsend_info *send_info)
+{
+	if (send_info->type == WRITE_ICM)
+		dr_fill_write_icm_segs(dmn, send_ring, send_info);
+}
+
 static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 				struct postsend_info *send_info)
 {
 	struct mlx5dr_send_ring *send_ring = dmn->send_ring;
-	u32 buff_offset;
 	int ret;
 
 	if (unlikely(dmn->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR ||
@@ -517,20 +548,7 @@ static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
 	if (ret)
 		goto out_unlock;
 
-	if (send_info->write.length > dmn->info.max_inline_size) {
-		buff_offset = (send_ring->tx_head &
-			       (dmn->send_ring->signal_th - 1)) *
-			send_ring->max_post_send_size;
-		/* Copy to ring mr */
-		memcpy(send_ring->buf + buff_offset,
-		       (void *)(uintptr_t)send_info->write.addr,
-		       send_info->write.length);
-		send_info->write.addr = (uintptr_t)send_ring->mr->dma_addr + buff_offset;
-		send_info->write.lkey = send_ring->mr->mkey;
-	}
-
-	send_ring->tx_head++;
-	dr_fill_data_segs(send_ring, send_info);
+	dr_fill_data_segs(dmn, send_ring, send_info);
 	dr_post_send(send_ring->qp, send_info);
 
 out_unlock:
-- 
2.39.2

