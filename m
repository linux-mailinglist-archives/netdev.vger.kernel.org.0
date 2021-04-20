Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C5A3650C6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhDTDVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhDTDVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D6C613AF;
        Tue, 20 Apr 2021 03:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888835;
        bh=SRKMIILRpqBT9SxeNstuE32E9FhKFbQOysu0eGjqqro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BN95FldLqHriDNhrFWVKSmijTvB+W/12FtP64tCpKBaqfIe86Jg3fllnFK7P/68ad
         noAOYc+ZeJs3Don4yWLkIYo3H6i1tWraRd3yecNhQ04eYn/TH0pQiRNGufh42vuRgd
         5gYJ5yXuUb9dM9i47vzMfb3cAGqsCEGmUshGy5JuZZvab/8SBQKC935XjcyU413e66
         O3eT/jo5dfne49R2RlBdRSvI6XYQZWg1po34aPI/jORQ7d6V9FrPhaCxLnnsfSNtx8
         FkR9JOUESfGDLlg1Utk7Gu1T6AdmerNQYAoElo33TKAscQMPFdLw6Ksw0g0Hqj4XWY
         QM77BDasH+Lcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Rename an argument in dr_rdma_segments
Date:   Mon, 19 Apr 2021 20:20:07 -0700
Message-Id: <20210420032018.58639-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Rename the argument to better reflect that the meaning is
not number of records, but wheather or not we should
ring the dorbell.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index c1926d927008..1f2e9fee96bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -223,7 +223,7 @@ static void dr_cmd_notify_hw(struct mlx5dr_qp *dr_qp, void *ctrl)
 
 static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
 			     u32 rkey, struct dr_data_seg *data_seg,
-			     u32 opcode, int nreq)
+			     u32 opcode, bool notify_hw)
 {
 	struct mlx5_wqe_raddr_seg *wq_raddr;
 	struct mlx5_wqe_ctrl_seg *wq_ctrl;
@@ -255,16 +255,16 @@ static void dr_rdma_segments(struct mlx5dr_qp *dr_qp, u64 remote_addr,
 
 	dr_qp->sq.wqe_head[idx] = dr_qp->sq.pc++;
 
-	if (nreq)
+	if (notify_hw)
 		dr_cmd_notify_hw(dr_qp, wq_ctrl);
 }
 
 static void dr_post_send(struct mlx5dr_qp *dr_qp, struct postsend_info *send_info)
 {
 	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
-			 &send_info->write, MLX5_OPCODE_RDMA_WRITE, 0);
+			 &send_info->write, MLX5_OPCODE_RDMA_WRITE, false);
 	dr_rdma_segments(dr_qp, send_info->remote_addr, send_info->rkey,
-			 &send_info->read, MLX5_OPCODE_RDMA_READ, 1);
+			 &send_info->read, MLX5_OPCODE_RDMA_READ, true);
 }
 
 /**
-- 
2.30.2

