Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3682740547B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356219AbhIIM67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352852AbhIIMvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5839163156;
        Thu,  9 Sep 2021 11:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188638;
        bh=7X5tW0vkiweF1UonXwW8M/dDVIrWkufNyhzFGEKT+iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETplFBBXrVnpoFmsodm6oqSHZb1FHhm9ShaaQOWPFCBh3FoBXrZrXrNLq00PAH+3v
         +QhM0BsOIAbniB5luxBupGvuPfM3J/M50xjgCQMucmJQ2oy6b9+WkUY37bD/0Ft3VO
         dbHUdlm+zfuVB+I3IG5ZilT7qyUiyVyqnMYSYdJgbslO3mhGrNd+zR8CRZ9D7MrSlK
         EWkEPi6/SobswNx6bj70I/3e1VxpMvmu+LRw9th5etBDB3Babytcccbo9nQJ2VdTHW
         0QtZJIFj8zjGhSC0G38BUhU4MdsWILUJNf8fPKQscbf36xg7T4sIwd+Kr7yHJ27Bix
         8uO6pmKX209fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 103/109] net/mlx5: DR, Enable QP retransmission
Date:   Thu,  9 Sep 2021 07:55:00 -0400
Message-Id: <20210909115507.147917-103-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit ec449ed8230cd30769de3cb70ee0fce293047372 ]

Under high stress, SW steering might get stuck on polling for completion
that never comes.
For such cases QP needs to have protocol retransmission mechanism enabled.
Currently the retransmission timeout is defined as 0 (unlimited). Fix this
by defining a real timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index f012aac83b10..401564b94eb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -603,6 +603,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, log_ack_req_freq, 0);
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RTR2RTS_QP, 0, qpc,
 				   &dr_qp->mqp);
-- 
2.30.2

