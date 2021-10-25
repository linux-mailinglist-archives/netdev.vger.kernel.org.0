Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811FA43A50C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhJYU46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231618AbhJYU45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 404A06101C;
        Mon, 25 Oct 2021 20:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195274;
        bh=DDTFhRSeoev1NOp/8TacfsqzL1VF6XeExbvXlgaaJc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXOPj/Y6lh+Jz6voYVUsO0aAExyDiiKrCPzHLdGyBZYbApWiDplPxETxR/TJmRJoe
         /MS7z9awswkPNdX9RX/T7p3ncSzooKjZclWoaaEggDJW8KIi2kzMPx95eyYjYmDbyS
         GzsDaUgBOOQYXhpJ5YKCaNqIdYGWeHkYVd4O3/D95DvuibDDzCs61bGzTIaCHY0guV
         aLXKgnPT032g6vHFjTGsCHxFk0oRr5BzyA+o5+3ztB4P9qHE8qVTF1GZbPStCfz5G4
         0ABXThAZCrJeSbb+j0LC67M5T76x/7p2dj4ocHW+n6hyyhO3ncfeGNbPqKz5c1D23e
         vBrFoIBH6R/AA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/14] net/mlx5: Remove unnecessary checks for slow path flag
Date:   Mon, 25 Oct 2021 13:54:19 -0700
Message-Id: <20211025205431.365080-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

After previous changes, caller (mlx5e_tc_offload_fdb_rules()) already
checks for the slow path flag, and if set won't call offload/unoffload
sample.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/sample.c  | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index d1d7e4b9f7ad..1046b7ea5c88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -509,13 +509,6 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	if (IS_ERR_OR_NULL(tc_psample))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/* If slow path flag is set, eg. when the neigh is invalid for encap,
-	 * don't offload sample action.
-	 */
-	esw = tc_psample->esw;
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
-		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
-
 	sample_flow = kzalloc(sizeof(*sample_flow), GFP_KERNEL);
 	if (!sample_flow)
 		return ERR_PTR(-ENOMEM);
@@ -527,6 +520,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	 * Only match the fte id instead of the same match in the
 	 * original flow table.
 	 */
+	esw = tc_psample->esw;
 	if (MLX5_CAP_GEN(esw->dev, reg_c_preserve) ||
 	    attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
 		struct mlx5_flow_table *ft;
@@ -634,15 +628,6 @@ mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
 	if (IS_ERR_OR_NULL(tc_psample))
 		return;
 
-	/* If slow path flag is set, sample action is not offloaded.
-	 * No need to delete sample rule.
-	 */
-	esw = tc_psample->esw;
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
-		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
-		return;
-	}
-
 	/* The following delete order can't be changed, otherwise,
 	 * will hit fw syndromes.
 	 */
-- 
2.31.1

