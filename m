Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0065E49C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjAEES5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjAEESf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818F03D1DD;
        Wed,  4 Jan 2023 20:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA31617F7;
        Thu,  5 Jan 2023 04:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77EC433D2;
        Thu,  5 Jan 2023 04:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892301;
        bh=kzIQ9Q/uKOjOgtTHsDqKdUNObVS5Pu9/69uqGxiXNhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRTvr+8sn1GNBYlJ/BCUXudpRlEpVAz8ARH2tCbNtMcfePYodjznTk604mk5jOvaE
         DUa1ilsG+Y7xN8s/8Opo5hr5LDXpJHVTQg/ts10k/lpfcQzsiTFMVLfjcg2ppPwOSa
         KGHlNaoD56R3iwNUO9Y3v9IJZgZgkvtltIVbFE5BArQmoCc0+dlzsmHOxQlcMdsR0l
         GCiMLtZwp7iu7UMUy5KeRWGDpT9T66USQBc5c0vSWi+32jDBoOrJ5rgfZXOGI9U/fe
         l3akakXx8q0kBBjPhv3GpBRajeAJboupj53fZfXqUMrtRvZByI6mksAlassPBU96Ov
         IEZXn8fGcM21Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 8/8] net/mlx5: Configure IPsec steering for egress RoCEv2 traffic
Date:   Wed,  4 Jan 2023 20:17:56 -0800
Message-Id: <20230105041756.677120-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
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

From: Mark Zhang <markzhang@nvidia.com>

Add steering table/rule in RDMA_TX domain, to forward all traffic
to IPsec crypto table in NIC domain.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  22 +++-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c    | 123 +++++++++++++++++-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.h    |   3 +
 3 files changed, 142 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 512d4f6e69bb..4de528687536 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -366,6 +366,14 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx)
 	return err;
 }
 
+static void tx_destroy(struct mlx5e_ipsec_tx *tx)
+{
+	mlx5_del_flow_rules(tx->pol.rule);
+	mlx5_destroy_flow_group(tx->pol.group);
+	mlx5_destroy_flow_table(tx->ft.pol);
+	mlx5_destroy_flow_table(tx->ft.sa);
+}
+
 static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
 					struct mlx5e_ipsec *ipsec)
 {
@@ -379,6 +387,13 @@ static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
 	err = tx_create(mdev, tx);
 	if (err)
 		goto out;
+
+	err = mlx5_ipsec_fs_roce_tx_create(ipsec->roce_ipsec, tx->ft.pol, ipsec->mdev);
+	if (err) {
+		tx_destroy(tx);
+		goto out;
+	}
+
 skip:
 	tx->ft.refcnt++;
 out:
@@ -397,10 +412,9 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	if (tx->ft.refcnt)
 		goto out;
 
-	mlx5_del_flow_rules(tx->pol.rule);
-	mlx5_destroy_flow_group(tx->pol.group);
-	mlx5_destroy_flow_table(tx->ft.pol);
-	mlx5_destroy_flow_table(tx->ft.sa);
+	mlx5_ipsec_fs_roce_tx_destroy(ipsec->roce_ipsec);
+
+	tx_destroy(tx);
 out:
 	mutex_unlock(&tx->ft.mutex);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
index efc67084f29a..2711892fd5cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -20,9 +20,17 @@ struct mlx5_ipsec_rx_roce {
 	struct mlx5_flow_namespace *ns_rdma;
 };
 
+struct mlx5_ipsec_tx_roce {
+	struct mlx5_flow_group *g;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_namespace *ns;
+};
+
 struct mlx5_ipsec_fs {
 	struct mlx5_ipsec_rx_roce ipv4_rx;
 	struct mlx5_ipsec_rx_roce ipv6_rx;
+	struct mlx5_ipsec_tx_roce tx;
 };
 
 static void ipsec_fs_roce_setup_udp_dport(struct mlx5_flow_spec *spec, u16 dport)
@@ -83,6 +91,103 @@ static int ipsec_fs_roce_rx_rule_setup(struct mlx5_flow_destination *default_dst
 	return err;
 }
 
+static int ipsec_fs_roce_tx_rule_setup(struct mlx5_core_dev *mdev, struct mlx5_ipsec_tx_roce *roce,
+				       struct mlx5_flow_table *pol_ft)
+{
+	struct mlx5_flow_destination dst = {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	int err = 0;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+	dst.ft = pol_ft;
+	rule = mlx5_add_flow_rules(roce->ft, NULL, &flow_act, &dst,
+				   1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add TX roce ipsec rule err=%d\n",
+			      err);
+		goto out;
+	}
+	roce->rule = rule;
+
+out:
+	return err;
+}
+
+void mlx5_ipsec_fs_roce_tx_destroy(struct mlx5_ipsec_fs *ipsec_roce)
+{
+	struct mlx5_ipsec_tx_roce *tx_roce;
+
+	if (!ipsec_roce)
+		return;
+
+	tx_roce = &ipsec_roce->tx;
+
+	mlx5_del_flow_rules(tx_roce->rule);
+	mlx5_destroy_flow_group(tx_roce->g);
+	mlx5_destroy_flow_table(tx_roce->ft);
+}
+
+#define MLX5_TX_ROCE_GROUP_SIZE BIT(0)
+
+int mlx5_ipsec_fs_roce_tx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_table *pol_ft,
+				 struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_ipsec_tx_roce *roce;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	int ix = 0;
+	int err;
+	u32 *in;
+
+	if (!ipsec_roce)
+		return 0;
+
+	roce = &ipsec_roce->tx;
+
+	in = kvzalloc(MLX5_ST_SZ_BYTES(create_flow_group_in), GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	ft_attr.max_fte = 1;
+	ft = mlx5_create_flow_table(roce->ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce ft err=%d\n", err);
+		return err;
+	}
+
+	roce->ft = ft;
+
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_TX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce group err=%d\n", err);
+		goto fail;
+	}
+	roce->g = g;
+
+	err = ipsec_fs_roce_tx_rule_setup(mdev, roce, pol_ft);
+	if (err) {
+		mlx5_core_err(mdev, "Fail to create ipsec tx roce rules err=%d\n", err);
+		goto rule_fail;
+	}
+
+	return 0;
+
+rule_fail:
+	mlx5_destroy_flow_group(roce->g);
+fail:
+	mlx5_destroy_flow_table(ft);
+	return err;
+}
+
 struct mlx5_flow_table *mlx5_ipsec_fs_roce_ft_get(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
 {
 	struct mlx5_ipsec_rx_roce *rx_roce;
@@ -222,6 +327,8 @@ void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce)
 	kfree(ipsec_roce);
 }
 
+#define NIC_RDMA_BOTH_DIRS_CAPS (MLX5_FT_NIC_RX_2_NIC_RX_RDMA | MLX5_FT_NIC_TX_RDMA_2_NIC_TX)
+
 struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ipsec_fs *roce_ipsec;
@@ -230,8 +337,8 @@ struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev)
 	if (!mlx5_get_roce_state(mdev))
 		return NULL;
 
-	if (!(MLX5_CAP_GEN_2(mdev, flow_table_type_2_type) &
-	      MLX5_FT_NIC_RX_2_NIC_RX_RDMA)) {
+	if ((MLX5_CAP_GEN_2(mdev, flow_table_type_2_type) &
+	     NIC_RDMA_BOTH_DIRS_CAPS) != NIC_RDMA_BOTH_DIRS_CAPS) {
 		mlx5_core_dbg(mdev, "Failed to init roce ipsec flow steering, capabilities not supported\n");
 		return NULL;
 	}
@@ -249,5 +356,17 @@ struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev)
 	roce_ipsec->ipv4_rx.ns_rdma = ns;
 	roce_ipsec->ipv6_rx.ns_rdma = ns;
 
+	ns = mlx5_get_flow_namespace(mdev, MLX5_FLOW_NAMESPACE_RDMA_TX_IPSEC);
+	if (!ns) {
+		mlx5_core_err(mdev, "Failed to get roce tx ns\n");
+		goto err_tx;
+	}
+
+	roce_ipsec->tx.ns = ns;
+
 	return roce_ipsec;
+
+err_tx:
+	kfree(roce_ipsec);
+	return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
index 75ca8f3df4f5..4b69d4e34234 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
@@ -11,6 +11,9 @@ void mlx5_ipsec_fs_roce_rx_destroy(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
 int mlx5_ipsec_fs_roce_rx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_namespace *ns,
 				 struct mlx5_flow_destination *default_dst, u32 family, u32 level,
 				 u32 prio, struct mlx5_core_dev *mdev);
+void mlx5_ipsec_fs_roce_tx_destroy(struct mlx5_ipsec_fs *ipsec_roce);
+int mlx5_ipsec_fs_roce_tx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_table *pol_ft,
+				 struct mlx5_core_dev *mdev);
 void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce);
 struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev);
 
-- 
2.38.1

