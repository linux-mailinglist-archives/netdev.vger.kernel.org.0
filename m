Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814065695A6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiGFXNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiGFXN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20762261
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2569B81F20
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88300C3411C;
        Wed,  6 Jul 2022 23:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149204;
        bh=ZnIccr7tj16bazkwSKGcWy17UnOOZ5zrR6+gdd7vwoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYUiBsauFRX3SadY/OlCYf9D4jTWm8hKRRs/Ww5y0E0RL6vJ7GupdL0JViwQSdmLG
         O+hHORyoNP5QqBR2AN/chbWvkytrhXKxwooXW6dyot952C+IszkqRhuwG73reknwcq
         b4p+ISgTw+q4gSxktMEJ38LWkfMfkLxMtrt4vYV9wrFSYhvQZmgSifeoPNIlzCkDdJ
         f9cePQpEfCPvZC6kDOyioXA+ofc8Cpa90pxPbP1KaExNMQ1UcoYVvsaOwsKjxnsUGU
         f2dQ9DXNfLZ1VJjGRLInGsc7nm/iyoAaxe6PE6apPWQMh8+G6METaI4ekWoCiYAk6W
         Pdf2c8lPkBJsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net 7/9] net/mlx5e: CT: Use own workqueue instead of mlx5e priv
Date:   Wed,  6 Jul 2022 16:13:07 -0700
Message-Id: <20220706231309.38579-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Allocate a ct priv workqueue instead of using mlx5e priv one
so flushing will only be of related CT entries.
Also move flushing of the workqueue before rhashtable destroy
otherwise entries won't be valid.

Fixes: b069e14fff46 ("net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 25f51f80a9b4..ba171c7f0a67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -76,6 +76,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_ct_fs *fs;
 	struct mlx5_ct_fs_ops *fs_ops;
 	spinlock_t ht_lock; /* protects ft entries */
+	struct workqueue_struct *wq;
 
 	struct mlx5_tc_ct_debugfs debugfs;
 };
@@ -941,14 +942,11 @@ static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
 static void
 __mlx5_tc_ct_entry_put(struct mlx5_ct_entry *entry)
 {
-	struct mlx5e_priv *priv;
-
 	if (!refcount_dec_and_test(&entry->refcnt))
 		return;
 
-	priv = netdev_priv(entry->ct_priv->netdev);
 	INIT_WORK(&entry->work, mlx5_tc_ct_entry_del_work);
-	queue_work(priv->wq, &entry->work);
+	queue_work(entry->ct_priv->wq, &entry->work);
 }
 
 static struct mlx5_ct_counter *
@@ -1759,19 +1757,16 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
-	struct mlx5e_priv *priv;
-
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
+	flush_workqueue(ct_priv->wq);
 	nf_flow_table_offload_del_cb(ft->nf_ft,
 				     mlx5_tc_ct_block_flow_offload, ft);
 	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
-	priv = netdev_priv(ct_priv->netdev);
-	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);
@@ -2176,6 +2171,12 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
 		goto err_ct_tuples_nat_ht;
 
+	ct_priv->wq = alloc_ordered_workqueue("mlx5e_ct_priv_wq", 0);
+	if (!ct_priv->wq) {
+		err = -ENOMEM;
+		goto err_wq;
+	}
+
 	err = mlx5_tc_ct_fs_init(ct_priv);
 	if (err)
 		goto err_init_fs;
@@ -2184,6 +2185,8 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	return ct_priv;
 
 err_init_fs:
+	destroy_workqueue(ct_priv->wq);
+err_wq:
 	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 err_ct_tuples_nat_ht:
 	rhashtable_destroy(&ct_priv->ct_tuples_ht);
@@ -2213,6 +2216,7 @@ mlx5_tc_ct_clean(struct mlx5_tc_ct_priv *ct_priv)
 	if (!ct_priv)
 		return;
 
+	destroy_workqueue(ct_priv->wq);
 	mlx5_ct_tc_remove_dbgfs(ct_priv);
 	chains = ct_priv->chains;
 
-- 
2.36.1

