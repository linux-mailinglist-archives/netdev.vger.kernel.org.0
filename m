Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D66E2C4B
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDNWJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjDNWJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ACF40FD
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35DD964A98
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A2C4339B;
        Fri, 14 Apr 2023 22:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510186;
        bh=EiHIFOwmNz/xi/pe6WXyf97U8EJzZg+dOf3TxnkyDZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyBB0gNf0HPDQOdifLXl209nee1cgiztJJVx6YaZj/SSg01ddHF1CDxggMTykMnbl
         A7Raibp36nAsABaFFhTrZhPShErBGncuxqNTPWYb05VspqYF+dzWBgTthKHf8FYMVc
         wSjQ1oaU+OwRfXZv4e8y6fs3wX8t+5OlcBFJcDi5H4r0dDq5Lb2l2/18dWHh5Wq+bo
         OHxmWwVASdRxvL/6Q2mlRUzS9MEgQn2Au55UTOOm2evLHaJaAUTaUtKaB+zEreEQsA
         SKKsYbshiQWKtI7PH+sfEF28kGXBPrD9hmyenKMf5/IXeMOV7nmBdJQTlTEd3IxLMz
         O/2u4kRGCnjjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 06/15] net/mlx5: DR, Add support for writing modify header argument
Date:   Fri, 14 Apr 2023 15:09:30 -0700
Message-Id: <20230414220939.136865-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The accelerated modify header arguments are written in the HW area
with special WQE and specific data format.
New function was added to support writing of new argument type.
Note that GTA WQE is larger than READ and WRITE, so the queue
management logic was updated to support this.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c     | 167 +++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_types.h    |   3 +
 2 files changed, 150 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 78756840d263..d7c7363f9096 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -20,6 +20,7 @@ struct dr_data_seg {
 
 enum send_info_type {
 	WRITE_ICM = 0,
+	GTA_ARG   = 1,
 };
 
 struct postsend_info {
@@ -269,6 +270,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	dr_qp->rq.wqe_cnt = 4;
 	dr_qp->sq.pc = 0;
 	dr_qp->sq.cc = 0;
+	dr_qp->sq.head = 0;
 	dr_qp->sq.wqe_cnt = roundup_pow_of_two(attr->max_send_wr);
 
 	MLX5_SET(qpc, temp_qpc, log_rq_stride, ilog2(MLX5_SEND_WQE_DS) - 4);
@@ -367,39 +369,113 @@ static void dr_cmd_notify_hw(struct mlx5dr_qp *dr_qp, void *ctrl)
 	mlx5_write64(ctrl, dr_qp->uar->map + MLX5_BF_OFFSET);
 }
 
-static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
-			     u32 rkey, struct dr_data_seg *data_seg,
-			     u32 opcode, bool notify_hw)
+static void
+dr_rdma_handle_flow_access_arg_segments(struct mlx5_wqe_ctrl_seg *wq_ctrl,
+					u32 remote_addr,
+					struct dr_data_seg *data_seg,
+					int *size)
 {
-	struct mlx5_wqe_raddr_seg *wq_raddr;
-	struct mlx5_wqe_ctrl_seg *wq_ctrl;
-	struct mlx5_wqe_data_seg *wq_dseg;
-	unsigned int size;
-	unsigned int idx;
+	struct mlx5_wqe_header_modify_argument_update_seg *wq_arg_seg;
+	struct mlx5_wqe_flow_update_ctrl_seg *wq_flow_seg;
 
-	size = sizeof(*wq_ctrl) / 16 + sizeof(*wq_dseg) / 16 +
-		sizeof(*wq_raddr) / 16;
+	wq_ctrl->general_id = cpu_to_be32(remote_addr);
+	wq_flow_seg = (void *)(wq_ctrl + 1);
 
-	idx = dr_qp->sq.pc & (dr_qp->sq.wqe_cnt - 1);
+	/* mlx5_wqe_flow_update_ctrl_seg - all reserved */
+	memset(wq_flow_seg, 0, sizeof(*wq_flow_seg));
+	wq_arg_seg = (void *)(wq_flow_seg + 1);
+
+	memcpy(wq_arg_seg->argument_list,
+	       (void *)(uintptr_t)data_seg->addr,
+	       data_seg->length);
+
+	*size = (sizeof(*wq_ctrl) +      /* WQE ctrl segment */
+		 sizeof(*wq_flow_seg) +  /* WQE flow update ctrl seg - reserved */
+		 sizeof(*wq_arg_seg)) /  /* WQE hdr modify arg seg - data */
+		MLX5_SEND_WQE_DS;
+}
+
+static void
+dr_rdma_handle_icm_write_segments(struct mlx5_wqe_ctrl_seg *wq_ctrl,
+				  u64 remote_addr,
+				  u32 rkey,
+				  struct dr_data_seg *data_seg,
+				  unsigned int *size)
+{
+	struct mlx5_wqe_raddr_seg *wq_raddr;
+	struct mlx5_wqe_data_seg *wq_dseg;
 
-	wq_ctrl = mlx5_wq_cyc_get_wqe(&dr_qp->wq.sq, idx);
-	wq_ctrl->imm = 0;
-	wq_ctrl->fm_ce_se = (data_seg->send_flags) ?
-		MLX5_WQE_CTRL_CQ_UPDATE : 0;
-	wq_ctrl->opmod_idx_opcode = cpu_to_be32(((dr_qp->sq.pc & 0xffff) << 8) |
-						opcode);
-	wq_ctrl->qpn_ds = cpu_to_be32(size | dr_qp->qpn << 8);
 	wq_raddr = (void *)(wq_ctrl + 1);
+
 	wq_raddr->raddr = cpu_to_be64(remote_addr);
 	wq_raddr->rkey = cpu_to_be32(rkey);
 	wq_raddr->reserved = 0;
 
 	wq_dseg = (void *)(wq_raddr + 1);
+
 	wq_dseg->byte_count = cpu_to_be32(data_seg->length);
 	wq_dseg->lkey = cpu_to_be32(data_seg->lkey);
 	wq_dseg->addr = cpu_to_be64(data_seg->addr);
 
-	dr_qp->sq.wqe_head[idx] = dr_qp->sq.pc++;
+	*size = (sizeof(*wq_ctrl) +    /* WQE ctrl segment */
+		 sizeof(*wq_dseg) +    /* WQE data segment */
+		 sizeof(*wq_raddr)) /  /* WQE remote addr segment */
+		MLX5_SEND_WQE_DS;
+}
+
+static void dr_set_ctrl_seg(struct mlx5_wqe_ctrl_seg *wq_ctrl,
+			    struct dr_data_seg *data_seg)
+{
+	wq_ctrl->signature = 0;
+	wq_ctrl->rsvd[0] = 0;
+	wq_ctrl->rsvd[1] = 0;
+	wq_ctrl->fm_ce_se = data_seg->send_flags & IB_SEND_SIGNALED ?
+				MLX5_WQE_CTRL_CQ_UPDATE : 0;
+	wq_ctrl->imm = 0;
+}
+
+static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
+			     u32 rkey, struct dr_data_seg *data_seg,
+			     u32 opcode, bool notify_hw)
+{
+	struct mlx5_wqe_ctrl_seg *wq_ctrl;
+	int opcode_mod = 0;
+	unsigned int size;
+	unsigned int idx;
+
+	idx = dr_qp->sq.pc & (dr_qp->sq.wqe_cnt - 1);
+
+	wq_ctrl = mlx5_wq_cyc_get_wqe(&dr_qp->wq.sq, idx);
+	dr_set_ctrl_seg(wq_ctrl, data_seg);
+
+	switch (opcode) {
+	case MLX5_OPCODE_RDMA_READ:
+	case MLX5_OPCODE_RDMA_WRITE:
+		dr_rdma_handle_icm_write_segments(wq_ctrl, remote_addr,
+						  rkey, data_seg, &size);
+		break;
+	case MLX5_OPCODE_FLOW_TBL_ACCESS:
+		opcode_mod = MLX5_CMD_OP_MOD_UPDATE_HEADER_MODIFY_ARGUMENT;
+		dr_rdma_handle_flow_access_arg_segments(wq_ctrl, remote_addr,
+							data_seg, &size);
+		break;
+	default:
+		WARN(true, "illegal opcode %d", opcode);
+		return;
+	}
+
+	/* --------------------------------------------------------
+	 * |opcode_mod (8 bit)|wqe_index (16 bits)| opcod (8 bits)|
+	 * --------------------------------------------------------
+	 */
+	wq_ctrl->opmod_idx_opcode =
+		cpu_to_be32((opcode_mod << 24) |
+			    ((dr_qp->sq.pc & 0xffff) << 8) |
+			    opcode);
+	wq_ctrl->qpn_ds = cpu_to_be32(size | dr_qp->qpn << 8);
+
+	dr_qp->sq.pc += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
+	dr_qp->sq.wqe_head[idx] = dr_qp->sq.head++;
 
 	if (notify_hw)
 		dr_cmd_notify_hw(dr_qp, wq_ctrl);
@@ -412,7 +488,11 @@ static void dr_post_send(struct mlx5dr_qp *dr_qp, struct postsend_info *send_inf
 				 &send_info->write, MLX5_OPCODE_RDMA_WRITE, false);
 		dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
 				 &send_info->read, MLX5_OPCODE_RDMA_READ, true);
+	} else { /* GTA_ARG */
+		dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
+				 &send_info->write, MLX5_OPCODE_FLOW_TBL_ACCESS, true);
 	}
+
 }
 
 /**
@@ -478,11 +558,23 @@ static int dr_handle_pending_wc(struct mlx5dr_domain *dmn,
 		} else if (ne == 1) {
 			send_ring->pending_wqe -= send_ring->signal_th;
 		}
-	} while (is_drain && send_ring->pending_wqe);
+	} while (ne == 1 ||
+		 (is_drain && send_ring->pending_wqe  >= send_ring->signal_th));
 
 	return 0;
 }
 
+static void dr_fill_write_args_segs(struct mlx5dr_send_ring *send_ring,
+				    struct postsend_info *send_info)
+{
+	send_ring->pending_wqe++;
+
+	if (send_ring->pending_wqe % send_ring->signal_th == 0)
+		send_info->write.send_flags |= IB_SEND_SIGNALED;
+	else
+		send_info->write.send_flags = 0;
+}
+
 static void dr_fill_write_icm_segs(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_send_ring *send_ring,
 				   struct postsend_info *send_info)
@@ -526,6 +618,8 @@ static void dr_fill_data_segs(struct mlx5dr_domain *dmn,
 {
 	if (send_info->type == WRITE_ICM)
 		dr_fill_write_icm_segs(dmn, send_ring, send_info);
+	else /* args */
+		dr_fill_write_args_segs(send_ring, send_info);
 }
 
 static int dr_postsend_icm_data(struct mlx5dr_domain *dmn,
@@ -774,6 +868,39 @@ int mlx5dr_send_postsend_pattern(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+int mlx5dr_send_postsend_args(struct mlx5dr_domain *dmn, u64 arg_id,
+			      u16 num_of_actions, u8 *actions_data)
+{
+	int data_len, iter = 0, cur_sent;
+	u64 addr;
+	int ret;
+
+	addr = (uintptr_t)actions_data;
+	data_len = num_of_actions * DR_MODIFY_ACTION_SIZE;
+
+	do {
+		struct postsend_info send_info = {};
+
+		send_info.type = GTA_ARG;
+		send_info.write.addr = addr;
+		cur_sent = min_t(u32, data_len, DR_ACTION_CACHE_LINE_SIZE);
+		send_info.write.length = cur_sent;
+		send_info.write.lkey = 0;
+		send_info.remote_addr = arg_id + iter;
+
+		ret = dr_postsend_icm_data(dmn, &send_info);
+		if (ret)
+			goto out;
+
+		iter++;
+		addr += cur_sent;
+		data_len -= cur_sent;
+	} while (data_len > 0);
+
+out:
+	return ret;
+}
+
 static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
 				 struct mlx5dr_qp *dr_qp,
 				 int port)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 0075e2c7a441..7b35f78a84a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1397,6 +1397,7 @@ struct mlx5dr_qp {
 	struct mlx5_wq_ctrl wq_ctrl;
 	u32 qpn;
 	struct {
+		unsigned int head;
 		unsigned int pc;
 		unsigned int cc;
 		unsigned int size;
@@ -1473,6 +1474,8 @@ int mlx5dr_send_postsend_pattern(struct mlx5dr_domain *dmn,
 				 struct mlx5dr_icm_chunk *chunk,
 				 u16 num_of_actions,
 				 u8 *data);
+int mlx5dr_send_postsend_args(struct mlx5dr_domain *dmn, u64 arg_id,
+			      u16 num_of_actions, u8 *actions_data);
 
 int mlx5dr_send_info_pool_create(struct mlx5dr_domain *dmn);
 void mlx5dr_send_info_pool_destroy(struct mlx5dr_domain *dmn);
-- 
2.39.2

