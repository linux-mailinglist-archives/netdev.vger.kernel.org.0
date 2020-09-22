Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526252738D8
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgIVCrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgIVCrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:41 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575CD23A62;
        Tue, 22 Sep 2020 02:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742860;
        bh=Pxkwrzi6HAPLOvxhKx6AcXNQxunRN1ywd0gQpEnvhi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neDFsQ97xuJoss7A19CmGUUmtCNX0VTWFtVf7/tqedRNiZLfNzYDMcAboNGtHVnHP
         1tBahOTWMCfkL1qX2KSatOMqZNYDr3ygZffRjp0p1kSTCD6QHCtpNRa79U9wVnDYnu
         3fC9GUTub7lKq0Jn9qLq9yzUAuAdANCzCQIxtI2U=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 02/12] net/mlx5e: Use struct assignment to initialize mlx5e_tx_wqe_info
Date:   Mon, 21 Sep 2020 19:46:54 -0700
Message-Id: <20200922024704.544482-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Struct assignment guarantees that all fields of the structure are
initialized (those that are not mentioned are zeroed). It makes code
mode robust and reduces chances for unpredictable behavior when one
forgets to reset some field and it holds an old value from previous
iterations of using the structure.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index e15aa53ff83e..c064657dde13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -241,10 +241,12 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	bool send_doorbell;
 
-	wi->num_bytes = num_bytes;
-	wi->num_dma = num_dma;
-	wi->num_wqebbs = num_wqebbs;
-	wi->skb = skb;
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.skb = skb,
+		.num_bytes = num_bytes,
+		.num_dma = num_dma,
+		.num_wqebbs = num_wqebbs,
+	};
 
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | opcode);
 	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
-- 
2.26.2

