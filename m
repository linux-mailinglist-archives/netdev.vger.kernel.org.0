Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0308248104E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbhL2GZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbhL2GZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10E7DB81823
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E556C36AEE;
        Wed, 29 Dec 2021 06:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759105;
        bh=sW4vLbuXWJ7nLfxXxUYnz5Qzo8U1aSw+b46JR31J1vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIXRujPySD2sBtxnyWru5Pdsh5x1tbJGJZcBYivDZz4pgn9ZI/xo/4+fCexMzCPMY
         kGVxBOAYwW0dxxzhsFYuYI4SPcyGh0kVEd16FJdN3GnuBHgQjB9eWP9MR6YGLHbUDu
         Cwo+zuVX+6boqLpQOYBDGHIEhJZi8t1J4t7sJWqTDr5OI+/2vrdgqvBBosR3yjUqef
         gHXk+8WZ6hcmzNNspNkFpyJbZfIew2sBx0bJAMatpOPU7YvkEUdOs5aiwzfO3fykbO
         jxkY9lVYtZMlPhqT2D8PpOc8GhBYjFxKW3zc7liiZ8KRPHXpOdrNS1pzFSAGU/ThXv
         30WII+ib7GdPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  01/16] net/mlx5: DR, Fix error flow in creating matcher
Date:   Tue, 28 Dec 2021 22:24:47 -0800
Message-Id: <20211229062502.24111-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The error code of nic matcher init functions wasn't checked.
This patch improves the matcher init function and fix error flow bug:
the handling of match parameter is moved into a separate function
and error flow is simplified.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 53 +++++++++++--------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 793365242e85..3d0cdc36a91a 100644
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
2.33.1

