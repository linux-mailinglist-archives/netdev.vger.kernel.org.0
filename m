Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037713BCC3C
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhGFLSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232360AbhGFLSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8908961C22;
        Tue,  6 Jul 2021 11:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570123;
        bh=qwDOPYoWnDfuwo7d96yAIbMByB5OAY5HzokkWBqgC+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4K9FovNyZWFz9aoYze++dt8RTkctRKZvMvLo0IqwHs9MbcUbc6sDGdez+FWyYhp+
         832ac/w68VsJOaOumApmRBbmsSrw3WJ0+jDEP4rGpEKnnUw+D3Vtl7X165UwD4eDIH
         D6hTUTpKSyklQ50lW7O98JJDlgtD8UvhTOaY45QTvQxTjhX8/ZsvjChT1wKO799BtP
         aEP2mD45sEMxokkcxqsMw0ttJ7NPCgJ5FEu9TqFJQhHPKQAcLOb5REU7wVcjGoxYD3
         yNPQvaRY4L2Vi9AGYAC9El+iLyA1JN1m5w7P0gSqfBHky5rYLe5VT8H90CKCgSiZ5T
         LMFkWIdG9Y5Tw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 052/189] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
Date:   Tue,  6 Jul 2021 07:11:52 -0400
Message-Id: <20210706111409.2058071-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

[ Upstream commit c07274ab1ab2c38fb128e32643c22c89cb319384 ]

rep_tc copy REG_C1 to REG_B. IPsec crypto utilizes the whole REG_B
register with BIT31 as IPsec marker. rep_tc_update_skb drops
IPsec because it thought REG_B contains bad value.

In previous patch, BIT 31 of REG_C1 is reserved for IPsec.
Skip the rep_tc_update_skb if BIT31 of REG_B is set.

Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f90894eea9e0..5346271974f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1310,7 +1310,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto free_wqe;
 	}
@@ -1367,7 +1368,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
 	}
-- 
2.30.2

