Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D44917C3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiARCm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345576AbiARCbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9694C0612E7;
        Mon, 17 Jan 2022 18:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77BF3B81256;
        Tue, 18 Jan 2022 02:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB30C36AE3;
        Tue, 18 Jan 2022 02:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472987;
        bh=Olda3xnyzFmTBKB+lZPphr0MT+lJCGKeeR1LSDGOpVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYrjW6LkrndfNG2CDIZthdIS6etGCsiZ/5rynyG2nxAiz3o9Uy6jJuOw2DbI92o0x
         MXWGx85Dq6HXhKHG7ggLp0nfxTpU7d9rMjs1oEfFMtMSQsb2BK3Ff14PYNmZskLSsq
         B1hK1EDA0LjsYmzYzG5J1RcuL5GqHQoWbE0wA8b8bOC8B9FMkMnaDyQER7+PPGgDX8
         kasUoGrgbTUWdNRWM0DgF+3BTM3OAHgKphjFRuQZkqdN/plRLanCFQBhRoPNAoALPX
         d1k7mB+kqWjLjGLLD3LfrBEk/TXGAy6EoWMIxXc8SYRMMWpdVWjSvUyLHFffKp/nYj
         s4Pk08nO8yZtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, saeedm@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, muhammads@nvidia.com,
        valex@nvidia.com, paulb@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 191/217] net/mlx5: DR, Fix error flow in creating matcher
Date:   Mon, 17 Jan 2022 21:19:14 -0500
Message-Id: <20220118021940.1942199-191-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 84dfac39c61fde04126e23723138128b50cd036f ]

The error code of nic matcher init functions wasn't checked.
This patch improves the matcher init function and fix error flow bug:
the handling of match parameter is moved into a separate function
and error flow is simplified.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 53 +++++++++++--------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 793365242e852..3d0cdc36a91ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -872,13 +872,12 @@ static int dr_matcher_init_fdb(struct mlx5dr_matcher *matcher)
 	return ret;
 }
 
-static int dr_matcher_init(struct mlx5dr_matcher *matcher,
-			   struct mlx5dr_match_parameters *mask)
+static int dr_matcher_copy_param(struct mlx5dr_matcher *matcher,
+				 struct mlx5dr_match_parameters *mask)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_match_parameters consumed_mask;
-	struct mlx5dr_table *tbl = matcher->tbl;
-	struct mlx5dr_domain *dmn = tbl->dmn;
-	int i, ret;
+	int i, ret = 0;
 
 	if (matcher->match_criteria >= DR_MATCHER_CRITERIA_MAX) {
 		mlx5dr_err(dmn, "Invalid match criteria attribute\n");
@@ -898,10 +897,36 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 		consumed_mask.match_sz = mask->match_sz;
 		memcpy(consumed_mask.match_buf, mask->match_buf, mask->match_sz);
 		mlx5dr_ste_copy_param(matcher->match_criteria,
-				      &matcher->mask, &consumed_mask,
-				      true);
+				      &matcher->mask, &consumed_mask, true);
+
+		/* Check that all mask data was consumed */
+		for (i = 0; i < consumed_mask.match_sz; i++) {
+			if (!((u8 *)consumed_mask.match_buf)[i])
+				continue;
+
+			mlx5dr_dbg(dmn,
+				   "Match param mask contains unsupported parameters\n");
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		kfree(consumed_mask.match_buf);
 	}
 
+	return ret;
+}
+
+static int dr_matcher_init(struct mlx5dr_matcher *matcher,
+			   struct mlx5dr_match_parameters *mask)
+{
+	struct mlx5dr_table *tbl = matcher->tbl;
+	struct mlx5dr_domain *dmn = tbl->dmn;
+	int ret;
+
+	ret = dr_matcher_copy_param(matcher, mask);
+	if (ret)
+		return ret;
+
 	switch (dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
 		matcher->rx.nic_tbl = &tbl->rx;
@@ -919,22 +944,8 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 	default:
 		WARN_ON(true);
 		ret = -EINVAL;
-		goto free_consumed_mask;
-	}
-
-	/* Check that all mask data was consumed */
-	for (i = 0; i < consumed_mask.match_sz; i++) {
-		if (!((u8 *)consumed_mask.match_buf)[i])
-			continue;
-
-		mlx5dr_dbg(dmn, "Match param mask contains unsupported parameters\n");
-		ret = -EOPNOTSUPP;
-		goto free_consumed_mask;
 	}
 
-	ret =  0;
-free_consumed_mask:
-	kfree(consumed_mask.match_buf);
 	return ret;
 }
 
-- 
2.34.1

