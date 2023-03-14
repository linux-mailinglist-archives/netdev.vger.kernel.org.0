Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7926B8DF9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCNJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjCNI7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF4294A6E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9A2615FE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C7C433EF;
        Tue, 14 Mar 2023 08:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784376;
        bh=R5icHxomPovLt0zvHMU4g1fm2xMRoBHnkx/e1Jp1gow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTui2lI6+gF8QqMZpI3WdZZyEbn1x6Nm/KHLuwq50fMzymHq9RREhMXvsbgPpCKB+
         we/77/LUJ5Zhh20Q8fTU3d1LZEoeadc2VfuKdlU+HJpjDc4p+DHmPdwq2t9plEZNQP
         hMEn1mS1YapuMotWAHa/CLgvoFr5guzBXYd1FYf+B28GCX65TixmdHi4ErNWSKE1w1
         3Y043hZCCyKuxphq6si63GaIvUNkLVkB7IpEzp5m/SzAYy4fmOiqQizlacOD4DfPtR
         Q8oeGXSDpYATScHNC/NADP5wmDEkxHfm8Rn2LWryonqAIhoMGz4m3fIZAZkco89MSh
         xo3gGcAwVvb5A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 8/9] net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
Date:   Tue, 14 Mar 2023 10:58:43 +0200
Message-Id: <09b9119d1deb6e482fd2d17e1f5760d7c5be1e48.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Currently one counter is shared between all IPsec Tx offloaded
rules to count the total amount of packets/bytes that was IPsec
Tx offloaded, replace this scheme by adding a new flow table (ft)
with one rule that counts all flows that passes through this
table (like Rx status ft), this ft is pointed by all IPsec Tx
offloaded rules. The above allows to have a counter per tx flow
rule in while keeping a separate global counter that store the
aggregation outcome of all these per flow counters.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 58 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  2 +-
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9f694a8e21fd..d1e4fd1e21d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -41,6 +41,7 @@ struct mlx5e_ipsec_rx {
 struct mlx5e_ipsec_tx {
 	struct mlx5e_ipsec_ft ft;
 	struct mlx5e_ipsec_miss pol;
+	struct mlx5e_ipsec_rule status;
 	struct mlx5_flow_namespace *ns;
 	struct mlx5e_ipsec_fc *fc;
 	struct mlx5_fs_chains *chains;
@@ -455,6 +456,39 @@ static void rx_ft_put_policy(struct mlx5e_ipsec *ipsec, u32 family, u32 prio)
 	mutex_unlock(&rx->ft.mutex);
 }
 
+static int ipsec_counter_rule_tx(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
+{
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *fte;
+	struct mlx5_flow_spec *spec;
+	int err;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	/* create fte */
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
+			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest.counter_id = mlx5_fc_id(tx->fc->cnt);
+	fte = mlx5_add_flow_rules(tx->ft.status, spec, &flow_act, &dest, 1);
+	if (IS_ERR(fte)) {
+		err = PTR_ERR(fte);
+		mlx5_core_err(mdev, "Fail to add ipsec tx counter rule err=%d\n", err);
+		goto err_rule;
+	}
+
+	kvfree(spec);
+	tx->status.rule = fte;
+	return 0;
+
+err_rule:
+	kvfree(spec);
+	return err;
+}
+
 /* IPsec TX flow steering */
 static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
 {
@@ -468,6 +502,8 @@ static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
 	}
 
 	mlx5_destroy_flow_table(tx->ft.sa);
+	mlx5_del_flow_rules(tx->status.rule);
+	mlx5_destroy_flow_table(tx->ft.status);
 }
 
 static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
@@ -477,10 +513,20 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 	struct mlx5_flow_table *ft;
 	int err;
 
-	ft = ipsec_ft_create(tx->ns, 1, 0, 4);
+	ft = ipsec_ft_create(tx->ns, 2, 0, 1);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
+	tx->ft.status = ft;
 
+	err = ipsec_counter_rule_tx(mdev, tx);
+	if (err)
+		goto err_status_rule;
+
+	ft = ipsec_ft_create(tx->ns, 1, 0, 4);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_sa_ft;
+	}
 	tx->ft.sa = ft;
 
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PRIO) {
@@ -525,6 +571,10 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 	}
 err_pol_ft:
 	mlx5_destroy_flow_table(tx->ft.sa);
+err_sa_ft:
+	mlx5_del_flow_rules(tx->status.rule);
+err_status_rule:
+	mlx5_destroy_flow_table(tx->ft.status);
 	return err;
 }
 
@@ -949,11 +999,11 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW |
+	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
 			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest.counter_id = mlx5_fc_id(tx->fc->cnt);
+	dest.ft = tx->ft.status;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3ade166073fa..8e3da9d4fe1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -137,7 +137,7 @@
 #define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + KERNEL_RX_MACSEC_MIN_LEVEL + 1)
 
 #define KERNEL_TX_IPSEC_NUM_PRIOS  1
-#define KERNEL_TX_IPSEC_NUM_LEVELS 2
+#define KERNEL_TX_IPSEC_NUM_LEVELS 3
 #define KERNEL_TX_IPSEC_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
 
 #define KERNEL_TX_MACSEC_NUM_PRIOS  1
-- 
2.39.2

