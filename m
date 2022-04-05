Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB32F4F29E0
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiDEIZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbiDEIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:20:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10D19134D;
        Tue,  5 Apr 2022 01:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EB4860AFB;
        Tue,  5 Apr 2022 08:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0A5C385A0;
        Tue,  5 Apr 2022 08:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649146379;
        bh=8ZfVpo+T+zB1Jff7bEpeQLqr0rfo/B9DOwfJO07sE8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfdpkgikpczjgHPvBhpaSS25WJWDxEs2NXgyVaWWNd3tsjj7isaR/B5Q2N3B7sRlc
         fKDilVKu+zLaqN/T5XPcmnBDZUtVGmR5EiFJCmtMm3nwuK3za9lEy2SVAPhV4KYyqk
         +5xTc+grwSDruwCH1D2QzgEowBIlZeoItbljEDTL5Aa3viw5SNMRflP4QJICoouBlg
         mKpA4MfAjCFEwS4cRpwFNs+zca9tkP4verlfgZuVj+8hzFWa2uAM/WdBCWswPKqExW
         x2sILZySup9SJcMGneJccBAMGPLf6ARIV/aLfIVGy6LLp1X3LM/0uofa65z/2uZwuT
         v4hagviLJGoxg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Nullify eq->dbg and qp->dbg pointers post destruction
Date:   Tue,  5 Apr 2022 11:12:40 +0300
Message-Id: <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649139915.git.leonro@nvidia.com>
References: <cover.1649139915.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

Prior to this patch in the case that destroy_unmap_eq()
failed and was called again, it triggered an additional call of
mlx5_debug_eq_remove() which causes a kernel crash, since
eq->dbg was not nullified in previous call.

Fix it by nullifying eq->dbg pointer after removal.

As for the qp->dbg the change is a preparation for the next patches
from the series in which mlx5_core_destroy_qp() could actually fail,
and have the same outcome.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 19 +++++++++++++------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 3d3e55a5cb11..9b96a1ca0779 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -486,11 +486,11 @@ EXPORT_SYMBOL(mlx5_debug_qp_add);
 
 void mlx5_debug_qp_remove(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 {
-	if (!mlx5_debugfs_root)
+	if (!mlx5_debugfs_root || !qp->dbg)
 		return;
 
-	if (qp->dbg)
-		rem_res_tree(qp->dbg);
+	rem_res_tree(qp->dbg);
+	qp->dbg = NULL;
 }
 EXPORT_SYMBOL(mlx5_debug_qp_remove);
 
@@ -512,11 +512,11 @@ int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 
 void mlx5_debug_eq_remove(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
-	if (!mlx5_debugfs_root)
+	if (!mlx5_debugfs_root || !eq->dbg)
 		return;
 
-	if (eq->dbg)
-		rem_res_tree(eq->dbg);
+	rem_res_tree(eq->dbg);
+	eq->dbg = NULL;
 }
 
 int mlx5_debug_cq_add(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 229728c80233..3c61f355cdac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -386,16 +386,20 @@ void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 }
 EXPORT_SYMBOL(mlx5_eq_disable);
 
-static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
+			    bool reentry)
 {
 	int err;
 
 	mlx5_debug_eq_remove(dev, eq);
 
 	err = mlx5_cmd_destroy_eq(dev, eq->eqn);
-	if (err)
+	if (err) {
 		mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
 			       eq->eqn);
+		if (reentry)
+			return err;
+	}
 
 	mlx5_frag_buf_free(dev, &eq->frag_buf);
 	return err;
@@ -481,7 +485,7 @@ static int destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 	int err;
 
 	mutex_lock(&eq_table->lock);
-	err = destroy_unmap_eq(dev, eq);
+	err = destroy_unmap_eq(dev, eq, false);
 	mutex_unlock(&eq_table->lock);
 	return err;
 }
@@ -748,12 +752,15 @@ EXPORT_SYMBOL(mlx5_eq_create_generic);
 
 int mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	int err;
 
 	if (IS_ERR(eq))
 		return -EINVAL;
 
-	err = destroy_async_eq(dev, eq);
+	mutex_lock(&eq_table->lock);
+	err = destroy_unmap_eq(dev, eq, true);
+	mutex_unlock(&eq_table->lock);
 	if (err)
 		goto out;
 
@@ -851,7 +858,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		list_del(&eq->list);
 		mlx5_eq_disable(dev, &eq->core, &eq->irq_nb);
-		if (destroy_unmap_eq(dev, &eq->core))
+		if (destroy_unmap_eq(dev, &eq->core, false))
 			mlx5_core_warn(dev, "failed to destroy comp EQ 0x%x\n",
 				       eq->core.eqn);
 		tasklet_disable(&eq->tasklet_ctx.task);
@@ -915,7 +922,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 			goto clean_eq;
 		err = mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
 		if (err) {
-			destroy_unmap_eq(dev, &eq->core);
+			destroy_unmap_eq(dev, &eq->core, false);
 			goto clean_eq;
 		}
 
-- 
2.35.1

