Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D38D3BCEFE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhGFL1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234983AbhGFLZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17AE861D4D;
        Tue,  6 Jul 2021 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570363;
        bh=WE3iQ4QdE2iVQ6Yk+6vTFUR7rdHzH9Eo/9dk/CYwD0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px7DgwSwRA//7+rD6B6IKUL8pqM1jpbEIz85/YjZd89Oe2DfdRFIRYQU/wxfch0m7
         XfEfHgMjPy5TGEbyR7Vne1HyTM+cpVFjai8dhJbujgF2z+mCR4RVU6xdhxsj1Q0R0h
         70g0DNKskNuh9WFcxmn75q0XFpFSqBOfAbdcGNImF63w6zV+meftqoIwXmr+2r8nnn
         SphQ5FUmP7xuACJMnLAW8XSfmSqnQ2YzlZdM5W9fy/1UJHPC+RlHngu2c085TT5Tzh
         B3j0PLJe+zJcuevhBziziEMTHXVVSXJAKcx8LCUz9X+0nc7feLn8ExDIaQONJ2vaCP
         VQhK3QTz0nI+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 042/160] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
Date:   Tue,  6 Jul 2021 07:16:28 -0400
Message-Id: <20210706111827.2060499-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 249d8905e644..e7528fa7e187 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1308,7 +1308,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto free_wqe;
 	}
@@ -1365,7 +1366,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
 	}
-- 
2.30.2

