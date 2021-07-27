Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFE93D83CE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhG0XU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhG0XUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA02F60FBF;
        Tue, 27 Jul 2021 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428053;
        bh=qnT15SY73TQydhPksqwf7u3werwrt19rTB5yCzqLbUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDoEskEntQEUpplShagQh3drgdqVL4wgxHarsy2CMmilOZaJ6zinG+82UGIU8k1RP
         1GVzXY6K9eUN6WjjR2hHBGhNQUd1A+D36UUEAW1ewHKgiKY+UK8oqVQ5J3wAZTE0Il
         CoitcoRqdYbO4ybNGjna/j+rxs4siFmk95wkqQ5QHrNlzRahZFQcGEqkikaxqP5xtM
         AxrNjv+nGKduy7rjlnSCSIgDOohcF1G/+DxZgH8s6ONcUeAC/1TcCpgFXw861KEaN8
         FOeh9jjW9vaYYR0Y87xMf+crPTNtnd2uGzUSg2lAxRAlzfLAMujpXEAFKslqVdBuoo
         OJoc6uxpxB2sg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/12] net/mlx5: Fix flow table chaining
Date:   Tue, 27 Jul 2021 16:20:39 -0700
Message-Id: <20210727232050.606896-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Fix a bug when flow table is created in priority that already
has other flow tables as shown in the below diagram.
If the new flow table (FT-B) has the lowest level in the priority,
we need to connect the flow tables from the previous priority (p0)
to this new table. In addition when this flow table is destroyed
(FT-B), we need to connect the flow tables from the previous
priority (p0) to the next level flow table (FT-C) in the same
priority of the destroyed table (if exists).

                       ---------
                       |root_ns|
                       ---------
                            |
            --------------------------------
            |               |              |
       ----------      ----------      ---------
       |p(prio)-x|     |   p-y  |      |   p-n |
       ----------      ----------      ---------
            |               |
     ----------------  ------------------
     |ns(e.g bypass)|  |ns(e.g. kernel) |
     ----------------  ------------------
            |            |           |
	-------	       ------       ----
        |  p0 |        | p1 |       |p2|
        -------        ------       ----
           |             |    \
        --------       ------- ------
        | FT-A |       |FT-B | |FT-C|
        --------       ------- ------

Fixes: f90edfd279f3 ("net/mlx5_core: Connect flow tables")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d7bf0a3e4a52..c0697e1b7118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1024,17 +1024,19 @@ static int connect_fwd_rules(struct mlx5_core_dev *dev,
 static int connect_flow_table(struct mlx5_core_dev *dev, struct mlx5_flow_table *ft,
 			      struct fs_prio *prio)
 {
-	struct mlx5_flow_table *next_ft;
+	struct mlx5_flow_table *next_ft, *first_ft;
 	int err = 0;
 
 	/* Connect_prev_fts and update_root_ft_create are mutually exclusive */
 
-	if (list_empty(&prio->node.children)) {
+	first_ft = list_first_entry_or_null(&prio->node.children,
+					    struct mlx5_flow_table, node.list);
+	if (!first_ft || first_ft->level > ft->level) {
 		err = connect_prev_fts(dev, ft, prio);
 		if (err)
 			return err;
 
-		next_ft = find_next_chained_ft(prio);
+		next_ft = first_ft ? first_ft : find_next_chained_ft(prio);
 		err = connect_fwd_rules(dev, ft, next_ft);
 		if (err)
 			return err;
@@ -2120,7 +2122,7 @@ static int disconnect_flow_table(struct mlx5_flow_table *ft)
 				node.list) == ft))
 		return 0;
 
-	next_ft = find_next_chained_ft(prio);
+	next_ft = find_next_ft(ft);
 	err = connect_fwd_rules(dev, next_ft, ft);
 	if (err)
 		return err;
-- 
2.31.1

