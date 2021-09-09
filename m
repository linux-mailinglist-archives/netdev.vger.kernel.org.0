Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22C404DCC
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242496AbhIIMGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242042AbhIIMA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 001CE6139D;
        Thu,  9 Sep 2021 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187975;
        bh=20N7xoLr4PRRg/0ghZb/xVzS0Tot4rz49UzpNxcUcFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkDm0y1R27GgzYhDVI73PagX4SE2HY7ONgOsDVqucw3MEMcdVf5nf8F7uuLlbYl3r
         WQ7P5cYvbSNF+YgQ1FjfVCEwVjmwVqAt0mtpDhHLdLpi2c5mG5/LWCuuuvpDi7FsvT
         fGu/2qdL0Rz2yirfcDnQ6f2wk0uRSI5Mg3vvXKrp7si4zjthVGLIl4rp8Bey0azBKw
         3id3Vq0PnsZz1mPvjox52PsTSiLdeWl3j9nPNjdMFMXnUP+RZeeE200RjVslNYPD4+
         aBnzNrWp36bfEzX7n1ZfmatfeGWdZph3JXyaRiPOgITBVBplN75dK9nLxYArgd6qSx
         9feSEHJxubdsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 238/252] net/mlx5: DR, Enable QP retransmission
Date:   Thu,  9 Sep 2021 07:40:52 -0400
Message-Id: <20210909114106.141462-238-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 9df0e73d1c35..69b49deb66b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -620,6 +620,7 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
 
 	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->qpn);
-- 
2.30.2

