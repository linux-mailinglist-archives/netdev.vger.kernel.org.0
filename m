Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE683BD3B5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhGFLhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234304AbhGFLd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC6161E02;
        Tue,  6 Jul 2021 11:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570571;
        bh=Q7YHZ8lgypYxsJA0zloefrl5aRgHOuk5uYKn2bWJ8pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7+jb07kX+1e9kMrSm/MM+ulraWGrzV4XA2aOskldJSCHs3kvhlVOFA7ndjYBe2fB
         SJv58vsDXjixi3/FHA4ozX5CqgpbDr+wehFshNQiXHsXk5KAhzKQDVA1catriHUmUh
         J3WT9vIHs257yJgPVkzaDApLoflwMtXlzUMFtYbtBoTKfpkZJAtrldhtaUGfmRDqK9
         +SZwfy1b+Uf51mefB/8jUney+XSgToipBc0avKvOuPu4KP49eOInZ4zJpnwzKZM/8L
         D3WMkrWu3EQ2WjSvJMgf6t8TN/Tr6C11ln35s6BmdKxViw8fujTCUZcTRfHXX33NTO
         5BtyLTyPGYWWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 037/137] net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
Date:   Tue,  6 Jul 2021 07:20:23 -0400
Message-Id: <20210706112203.2062605-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 7e1f8660dfec..f327b78261ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1318,7 +1318,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto free_wqe;
 	}
@@ -1375,7 +1376,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv)) {
+	if (unlikely(!mlx5_ipsec_is_rx_flow(cqe) &&
+		     !mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))) {
 		dev_kfree_skb_any(skb);
 		goto mpwrq_cqe_out;
 	}
-- 
2.30.2

