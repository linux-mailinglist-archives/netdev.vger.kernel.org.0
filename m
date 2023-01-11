Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712D76653CC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbjAKFjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbjAKFiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DE2E78
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45A4619F7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2919C433F0;
        Wed, 11 Jan 2023 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415057;
        bh=7DZS7GvlrNkQ8Gktsir+aLd6oYMiCIoBBr+Qe8mXFzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXfI0brxtaPqmgDstda6Jt/J5UKFnqvxeXC7vovAxpod7DVDhgnUoI/HXWq9yeCNj
         1GQ+m4NEByCxzjjcvy0ku32nyXMxFYMpvULPL8VEfutyf4pdgzsb+fc1UWROZT5yNl
         +XGaVzEPFGQCrpwekiJ6Vk4lpf4QAZJtQfiAn1rtHGpZzQdIifp18pfpvswgx33NVG
         eVpZNAy3yDBEzfGTRmxH4t8UavfKMyvbYX54AkyY/ER9pzoloE+tjnEybJ7QhxMzsA
         gjFyGasmXeXnte8ONQ/gFqWIZfTFoZMBynB13Cpr5RcTZpeKnQeYQah7XAcHtgCT75
         r0aMb5gYEncsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Date:   Tue, 10 Jan 2023 21:30:38 -0800
Message-Id: <20230111053045.413133-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

We refer to a TC NIC rule that involves forwarding as "hairpin".
Hairpin queues are mlx5 hardware specific implementation for hardware
forwarding of such packets.

For debug purposes, introduce debugfs files which:
* Expose the number of active hairpins
* Dump the hairpin table
* Allow control over the number and size of the hairpin queues instead
  of the hard-coded values.

This allows us to get visibility of the feature in order to improve it
for next generation hardware.

Add debugfs files:
  fs/tc/hairpin_num_active
  fs/tc/hairpin_num_queues
  fs/tc/hairpin_queue_size
  fs/tc/hairpin_table_dump

Note that the new values will only take effect on the next queues
creation, it does not affect existing queues.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 800442eaf9b4..99a7edb88661 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -100,6 +100,7 @@ struct mlx5e_tc_table {
 	struct mlx5_tc_ct_priv         *ct;
 	struct mapping_ctx             *mapping;
 	struct mlx5e_hairpin_params    hairpin_params;
+	struct dentry                  *dfs_root;
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
@@ -1023,6 +1024,118 @@ static int mlx5e_hairpin_get_prio(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int debugfs_hairpin_queues_set(void *data, u64 val)
+{
+	struct mlx5e_hairpin_params *hp = data;
+
+	if (!val) {
+		mlx5_core_err(hp->mdev,
+			      "Number of hairpin queues must be > 0\n");
+		return -EINVAL;
+	}
+
+	hp->num_queues = val;
+
+	return 0;
+}
+
+static int debugfs_hairpin_queues_get(void *data, u64 *val)
+{
+	struct mlx5e_hairpin_params *hp = data;
+
+	*val = hp->num_queues;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_hairpin_queues, debugfs_hairpin_queues_get,
+			 debugfs_hairpin_queues_set, "%llu\n");
+
+static int debugfs_hairpin_queue_size_set(void *data, u64 val)
+{
+	struct mlx5e_hairpin_params *hp = data;
+
+	if (val > BIT(MLX5_CAP_GEN(hp->mdev, log_max_hairpin_num_packets))) {
+		mlx5_core_err(hp->mdev,
+			      "Invalid hairpin queue size, must be <= %lu\n",
+			      BIT(MLX5_CAP_GEN(hp->mdev,
+					       log_max_hairpin_num_packets)));
+		return -EINVAL;
+	}
+
+	hp->queue_size = roundup_pow_of_two(val);
+
+	return 0;
+}
+
+static int debugfs_hairpin_queue_size_get(void *data, u64 *val)
+{
+	struct mlx5e_hairpin_params *hp = data;
+
+	*val = hp->queue_size;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_hairpin_queue_size,
+			 debugfs_hairpin_queue_size_get,
+			 debugfs_hairpin_queue_size_set, "%llu\n");
+
+static int debugfs_hairpin_num_active_get(void *data, u64 *val)
+{
+	struct mlx5e_tc_table *tc = data;
+	struct mlx5e_hairpin_entry *hpe;
+	u32 cnt = 0;
+	u32 bkt;
+
+	mutex_lock(&tc->hairpin_tbl_lock);
+	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
+		cnt++;
+	mutex_unlock(&tc->hairpin_tbl_lock);
+
+	*val = cnt;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_hairpin_num_active,
+			 debugfs_hairpin_num_active_get, NULL, "%llu\n");
+
+static int debugfs_hairpin_table_dump_show(struct seq_file *file, void *priv)
+
+{
+	struct mlx5e_tc_table *tc = file->private;
+	struct mlx5e_hairpin_entry *hpe;
+	u32 bkt;
+
+	mutex_lock(&tc->hairpin_tbl_lock);
+	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
+		seq_printf(file, "Hairpin peer_vhca_id %u prio %u refcnt %u\n",
+			   hpe->peer_vhca_id, hpe->prio,
+			   refcount_read(&hpe->refcnt));
+	mutex_unlock(&tc->hairpin_tbl_lock);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(debugfs_hairpin_table_dump);
+
+static void mlx5e_tc_debugfs_init(struct mlx5e_tc_table *tc,
+				  struct dentry *dfs_root)
+{
+	if (IS_ERR_OR_NULL(dfs_root))
+		return;
+
+	tc->dfs_root = debugfs_create_dir("tc", dfs_root);
+	if (!tc->dfs_root)
+		return;
+
+	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
+			    &tc->hairpin_params, &fops_hairpin_queues);
+	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
+			    &tc->hairpin_params, &fops_hairpin_queue_size);
+	debugfs_create_file("hairpin_num_active", 0444, tc->dfs_root, tc,
+			    &fops_hairpin_num_active);
+	debugfs_create_file("hairpin_table_dump", 0444, tc->dfs_root, tc,
+			    &debugfs_hairpin_table_dump_fops);
+}
+
 static void
 mlx5e_hairpin_params_init(struct mlx5e_hairpin_params *hairpin_params,
 			  struct mlx5_core_dev *mdev)
@@ -5249,6 +5362,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 		goto err_reg;
 	}
 
+	mlx5e_tc_debugfs_init(tc, mlx5e_fs_get_debugfs_root(priv->fs));
+
 	return 0;
 
 err_reg:
@@ -5277,6 +5392,8 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 
+	debugfs_remove_recursive(tc->dfs_root);
+
 	if (tc->netdevice_nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(priv->netdev,
 						      &tc->netdevice_nb,
-- 
2.39.0

