Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476E757A849
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiGSUfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiGSUfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77871474DF
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CB5B81D42
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F27C341D5;
        Tue, 19 Jul 2022 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262939;
        bh=64XcRbHJ8LfZEmp7er9AbrM32uuM5j+9/Dur/zvcTwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQRFhJFK5iGs+FQQ5ND1a/O0fDxNm2gg6olzeNomiq5XOS1IK1skGiYIYfYhFyoqS
         syvlpZwSxYsOtf6Z4CFLU1LHuzTOnHplXVxJ63pAJgxntcER6dnxpJHiFmPjPLuRme
         sPgk1IJQAFjrcDFDtf+E3JHVXHwffV8nLO0bdRE9MTyEFPGlWH+/1i266bKaQ+L/Bg
         h/u03UXlcqbKk8Wbwrsje4Yq1ASw6p1Bv3pFZx3H6TTDVXy5KlX9lDbVpnYj1PJDAN
         0oMsyXvEVf0geUr7nlxtFJJjz437TT0KjnVYu/hDTPDYNzW+Ac/0PWlFmRfJrX+5kf
         dRkAPXrxH5QRA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next V2 06/13] net/mlx5e: HTB, move stats and max_sqs to priv
Date:   Tue, 19 Jul 2022 13:35:22 -0700
Message-Id: <20220719203529.51151-7-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

Preparation for dynamic allocation of the HTB struct.
The statistics should be preserved even when the struct is de-allocated.

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 16 ++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c    |  6 +++---
 .../net/ethernet/mellanox/mlx5/core/en_stats.c   | 12 ++++++------
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 1222156e222b..d2ed27575097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -902,8 +902,6 @@ struct mlx5e_scratchpad {
 struct mlx5e_htb {
 	DECLARE_HASHTABLE(qos_tc2node, order_base_2(MLX5E_QOS_MAX_LEAF_NODES));
 	DECLARE_BITMAP(qos_used_qids, MLX5E_QOS_MAX_LEAF_NODES);
-	struct mlx5e_sq_stats **qos_sq_stats;
-	u16 max_qos_sqs;
 };
 
 struct mlx5e_trap;
@@ -944,6 +942,8 @@ struct mlx5e_priv {
 	struct mlx5e_channel_stats **channel_stats;
 	struct mlx5e_channel_stats trap_stats;
 	struct mlx5e_ptp_stats     ptp_stats;
+	struct mlx5e_sq_stats      **htb_qos_sq_stats;
+	u16                        htb_max_qos_sqs;
 	u16                        stats_nch;
 	u16                        max_nch;
 	u8                         max_opened_tc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 9a61c44e7f72..6136cad397dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -213,11 +213,11 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 
 	txq_ix = mlx5e_qid_from_qos(chs, node->qid);
 
-	WARN_ON(node->qid > priv->htb.max_qos_sqs);
-	if (node->qid == priv->htb.max_qos_sqs) {
+	WARN_ON(node->qid > priv->htb_max_qos_sqs);
+	if (node->qid == priv->htb_max_qos_sqs) {
 		struct mlx5e_sq_stats *stats, **stats_list = NULL;
 
-		if (priv->htb.max_qos_sqs == 0) {
+		if (priv->htb_max_qos_sqs == 0) {
 			stats_list = kvcalloc(mlx5e_qos_max_leaf_nodes(priv->mdev),
 					      sizeof(*stats_list),
 					      GFP_KERNEL);
@@ -230,12 +230,12 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 			return -ENOMEM;
 		}
 		if (stats_list)
-			WRITE_ONCE(priv->htb.qos_sq_stats, stats_list);
-		WRITE_ONCE(priv->htb.qos_sq_stats[node->qid], stats);
-		/* Order max_qos_sqs increment after writing the array pointer.
+			WRITE_ONCE(priv->htb_qos_sq_stats, stats_list);
+		WRITE_ONCE(priv->htb_qos_sq_stats[node->qid], stats);
+		/* Order htb_max_qos_sqs increment after writing the array pointer.
 		 * Pairs with smp_load_acquire in en_stats.c.
 		 */
-		smp_store_release(&priv->htb.max_qos_sqs, priv->htb.max_qos_sqs + 1);
+		smp_store_release(&priv->htb_max_qos_sqs, priv->htb_max_qos_sqs + 1);
 	}
 
 	ix = node->qid % params->num_channels;
@@ -259,7 +259,7 @@ static int mlx5e_open_qos_sq(struct mlx5e_priv *priv, struct mlx5e_channels *chs
 		goto err_free_sq;
 	err = mlx5e_open_txqsq(c, priv->tisn[c->lag_port][0], txq_ix, params,
 			       &param_sq, sq, 0, node->hw_id,
-			       priv->htb.qos_sq_stats[node->qid]);
+			       priv->htb_qos_sq_stats[node->qid]);
 	if (err)
 		goto err_close_cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 700bca033769..fed24b5a0bae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5372,9 +5372,9 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	mutex_unlock(&priv->state_lock);
 	free_cpumask_var(priv->scratchpad.cpumask);
 
-	for (i = 0; i < priv->htb.max_qos_sqs; i++)
-		kfree(priv->htb.qos_sq_stats[i]);
-	kvfree(priv->htb.qos_sq_stats);
+	for (i = 0; i < priv->htb_max_qos_sqs; i++)
+		kfree(priv->htb_qos_sq_stats[i]);
+	kvfree(priv->htb_qos_sq_stats);
 
 	memset(priv, 0, sizeof(*priv));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1e87bb2b7541..1a88406ee6d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -474,8 +474,8 @@ static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
 	int i;
 
 	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
-	max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
-	stats = READ_ONCE(priv->htb.qos_sq_stats);
+	max_qos_sqs = smp_load_acquire(&priv->htb_max_qos_sqs);
+	stats = READ_ONCE(priv->htb_qos_sq_stats);
 
 	for (i = 0; i < max_qos_sqs; i++) {
 		mlx5e_stats_grp_sw_update_stats_sq(s, READ_ONCE(stats[i]));
@@ -2184,13 +2184,13 @@ static const struct counter_desc qos_sq_stats_desc[] = {
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(qos)
 {
 	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
-	return NUM_QOS_SQ_STATS * smp_load_acquire(&priv->htb.max_qos_sqs);
+	return NUM_QOS_SQ_STATS * smp_load_acquire(&priv->htb_max_qos_sqs);
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(qos)
 {
 	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
-	u16 max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
+	u16 max_qos_sqs = smp_load_acquire(&priv->htb_max_qos_sqs);
 	int i, qid;
 
 	for (qid = 0; qid < max_qos_sqs; qid++)
@@ -2208,8 +2208,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(qos)
 	int i, qid;
 
 	/* Pairs with smp_store_release in mlx5e_open_qos_sq. */
-	max_qos_sqs = smp_load_acquire(&priv->htb.max_qos_sqs);
-	stats = READ_ONCE(priv->htb.qos_sq_stats);
+	max_qos_sqs = smp_load_acquire(&priv->htb_max_qos_sqs);
+	stats = READ_ONCE(priv->htb_qos_sq_stats);
 
 	for (qid = 0; qid < max_qos_sqs; qid++) {
 		struct mlx5e_sq_stats *s = READ_ONCE(stats[qid]);
-- 
2.36.1

