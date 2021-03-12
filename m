Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7856A339A10
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhCLXja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235818AbhCLXi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6899464F8E;
        Fri, 12 Mar 2021 23:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592339;
        bh=sfnEsH3EiRSwzRNvitNEuVou9ghvckBI3hT+dg5tyeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+86uZRbEmi4bQi9rMRPodJrFKfVZKTaL4SrhXLa2wrazXLeW8/HRqGo8UG8nFHO6
         PmPkD6XPl4s693GADx7ejTct2fwJIyOSW+pKxOyDTvW133YCqo64w+LuI5AFN+aye2
         CG//JhXXRFZaavOe7Um6H3UToz0gQ/uk97ijCJVYfM5spS/bUybMnpBaEFGKH7uuXt
         QlXpfNqjBPybRtUjof85012IvdqBSKyT+egYPPs9ND4LO45GRfdSzCsWikBq2KBo/b
         cfzU1Crx5j7Mq7O3w6z/phD6big4wE8tRI2nruo59TtUhtmDSv3gv0OV2pnGOe3tjl
         bd6VrFDwooY2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/13] net/mlx5e: Dump ICOSQ WQE descriptor on CQE with error events
Date:   Fri, 12 Mar 2021 15:38:47 -0800
Message-Id: <20210312233851.494832-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Dump the ICOSQ's WQE descriptor when a completion with error is received.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1b6ad94ebb10..1f15c6183dc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -669,6 +669,7 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 						 get_cqe_opcode(cqe));
 				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
 						     (struct mlx5_err_cqe *)cqe);
+				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
 				if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 					queue_work(cq->priv->wq, &sq->recover_work);
 				break;
-- 
2.29.2

