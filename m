Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052D140536D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355068AbhIIMwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355098AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 497C961BA9;
        Thu,  9 Sep 2021 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188494;
        bh=uDb6O9YEaltjgRU4uukfRp0mRS5qa6nxUwPccZ5ji1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE0kbFYUgCFmxHfFDlGUqnSiexTi5QPV6B+3CmGQNu2tli7g6dNfjn5I6ON/SNaXV
         nEAb0lKUV+++qfq68U7YzNmc7jKr6wmoQy4U47vbFvYNNAgQcas+VbLV9SiZpVOctI
         o9m74M/Axnq6cQtwOxM0UcVCoHYvoYhS697E8VmHkVNpuWFzrCWb2ujN5FUmtvb8hT
         tsrqBB9WF4/GPnTX8Od22+QT6uMW3B7q4FJkY58qaK/abLdH/C4bvTzYxyDNbGZIFZ
         sCOqHQvC/JxIrGiex27rtPWvhbGYlNLpHW8c6Vu6aT5coVt+m1i8r2HfhRuiU7BKHp
         w+mKPg3ku4XhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 167/176] net/mlx5: DR, Enable QP retransmission
Date:   Thu,  9 Sep 2021 07:51:09 -0400
Message-Id: <20210909115118.146181-167-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index ea3c6cf27db4..eb6677f737a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -605,6 +605,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
-- 
2.30.2

