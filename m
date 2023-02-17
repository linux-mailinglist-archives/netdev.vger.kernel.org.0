Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EEC69B59E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBQWhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBQWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:37:32 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0112769A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:37:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEIKG5cotUG/tr2cDKjvi/NwmJFk99QZ0Zd5axeKrko5SQ7gFrGYFcz02Tz18ot3XR2+m/KYVtubtPyUAOycZkrOMhqDi1Qcc1voqVCn20ISaEWCDKplOP6OmbXffjri5bEMVTFWj9iTuQeeUBqgr5cOqRcIe2LMhuPYhUtqhMubnsApqIx1SCx4ssjFHo6LjgRQf0wVr5uI++obqOCTWXnnIMitVflzTCzUsBdJ5IMY8zi4WsJic4bilrOfrB3oJj2yKMYK1cMVa0B4d1lI2Rqw/XY99/uY0gIi6uVgkLiOjB7IjS6riC/pOvTDS9lBYy6+J/ObG57BOZEfsS8J+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d35If1AnqMqDOhggZ4UUcg+S/9hsAsHsuZoODD16If8=;
 b=LJU5ZJEPkvEQNw1X7muKqSVgT++1GL7bl5JrOxnlFufbEF8wKibJEGde9/pR1o9ib3gI7CmOMgLTku+Mn3i63Tu2xTzhhnNoMJzqKZQuFVGxJbOZ64Kjkvm+dgBQ9Zma06oAz56rdrHyms4Z86uVwtrqua+3jdBC1ZHTTFpaTq+mtd4h8Glk4SY/y8y/ihij/62jsDDRP6xjB5UwQ9Y8KIHi2A+hk+23ou3Ac8ixu+wp/xwaC9brFkk2CntdfbsvzIhmHeZT55taj9RaxIeqXntVNigIKq3xFOcZda4sdAd/GSrmRBBCMVT+GDLio6AEtEHhj3Ub+VnMJPbS2uOjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d35If1AnqMqDOhggZ4UUcg+S/9hsAsHsuZoODD16If8=;
 b=t1Mmr5eAVaStQF3/DAR2XGdubUJ/2rgy8yZTQvHHz0/0GENmUaI/3RPs9fb2RINLIVq/pWGrJh7ItQr5ZcNegY9EmGsz59ihQ5S6w9Umyz0wnnEelUKPKV8EdLCx8cHYmjL7ZraevysBPwqensfUcj5WAdhf/pRE92+YxX4m0puxAjZWBJQiJqfo4aQNtkobuUXLPmIzmVmE79fZxAb6yz0IxRUMsWwdx5O+O535yiwZtfNXAjyqoY/D+9v7PD9kbKlKmEyaIstyVj8Sd/c3bc+x81Mk4n5cvYa+a6DpZ4Ai44AgVqKDE1mdhnqDXzt3I2szZzs++DPf9K8y+bPRrw==
Received: from MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22) by
 SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13; Fri, 17 Feb 2023 22:37:14 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::a7) by MN2PR01CA0053.outlook.office365.com
 (2603:10b6:208:23f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 22:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:37:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:59 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:58 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:54 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v13 7/8] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
Date:   Sat, 18 Feb 2023 00:36:19 +0200
Message-ID: <20230217223620.28508-8-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|SA0PR12MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: f53600e3-0dbf-4c53-93bf-08db11378407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueVWtq32eju5TeVGXuZ62A+l6DPKtRV/TKVv/Ak+vjo0npZcJDszXibFh8wvSbL4dp1dZFzAg6hPagiSDcVVv0+fqiKydLykIgQSpB3IGh0ZV/6bBvCJ4G5LaFFUqUEY6bW6/fXgopOWioBMCAunHV3D/o5455NIlOrnmy0NPteoWydN1Ekog+HGS8KXdE+xTzjWyAtsYKBnsObqclFJfeVJKAgUxO9HfQBkO13F8VO0IU4AYlRafJWf/lST7URRXo7IH2AmoiIox4tRnzz20U2QNNMnY1qNRsp//KfBZj4SvpHLcLm8GTbvU8vtK384xACmudpF9lCQK/EelW82yqymN529fiFs1+hzqLP08cdLoGvdyG7YfPgfD7V51B7a6JLC7t3Ch/oFd34/SoNpVWc9bKlg/cuWqLShss+LIH6j41iPLfN3WnHMYTX6RTWgUmEX1uf2nKfaa5xk7SvtxpUP3eZkY86/4TykB39D1DDQpHYvoV0hThGZJ7RBm/4d8nl7apKOud7b7K+0KXEliYtwmPvrjLEiOzL1vWLhxvQvLfDZdG1oo225uG+1bg6Vwge+eEZhSLh+EwZz8Cind5bt1+inbRfEkHBR6R2jGhXGKqZ/+FHp684M9gJEG2UWFeyYWCssT5Ui1nCQQtE1fzPEK3Xgi0lfJbD3OK8up5AtjNbqiER9TxJiyxzgNRs6Dad9Hnb1pyNuN7Az9tEwg2fbEezl96VhHTA3aSauKgA=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(83380400001)(82740400003)(7636003)(36860700001)(82310400005)(356005)(5660300002)(86362001)(921005)(36756003)(8936002)(2906002)(186003)(40480700001)(40460700003)(1076003)(426003)(336012)(6666004)(107886003)(47076005)(70586007)(2616005)(26005)(316002)(8676002)(110136005)(70206006)(4326008)(54906003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:37:13.6207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f53600e3-0dbf-4c53-93bf-08db11378407
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reg usage is always a mapped object, not necessarily
containing chain info.

Rename to properly convey what it stores.
This patch doesn't change any functionality.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  4 ++--
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 14 +++++++-------
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index f2c2c752bd1c..558a776359af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -237,7 +237,7 @@ sample_modify_hdr_get(struct mlx5_core_dev *mdev, u32 obj_id,
 	int err;
 
 	err = mlx5e_tc_match_to_reg_set(mdev, mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, obj_id);
+					MAPPED_OBJ_TO_REG, obj_id);
 	if (err)
 		goto err_set_regc0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 2251f33c3865..de751d084770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1875,7 +1875,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	ct_flow->chain_mapping = chain_mapping;
 
 	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err) {
 		ct_dbg("Failed to set chain register mapping");
 		goto err_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3819d2bee6c2..2dd0bd54c3cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -109,7 +109,7 @@ struct mlx5e_tc_table {
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
-	[CHAIN_TO_REG] = {
+	[MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
 		.moffset = 0,
 		.mlen = 16,
@@ -136,7 +136,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	 * into reg_b that is passed to SW since we don't
 	 * jump between steering domains.
 	 */
-	[NIC_CHAIN_TO_REG] = {
+	[NIC_MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,
 		.moffset = 0,
 		.mlen = 16,
@@ -1605,7 +1605,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 		goto err_get_chain;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err)
 		goto err_reg_set;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 6388444925cf..a46a74eb354d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -227,7 +227,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
-	CHAIN_TO_REG,
+	MAPPED_OBJ_TO_REG,
 	VPORT_TO_REG,
 	TUNNEL_TO_REG,
 	CTSTATE_TO_REG,
@@ -236,7 +236,7 @@ enum mlx5e_tc_attr_to_reg {
 	MARK_TO_REG,
 	LABELS_TO_REG,
 	FTEID_TO_REG,
-	NIC_CHAIN_TO_REG,
+	NIC_MAPPED_OBJ_TO_REG,
 	NIC_ZONE_RESTORE_TO_REG,
 	PACKET_COLOR_TO_REG,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index df58cba37930..81ed91fee59b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -214,7 +214,7 @@ create_chain_restore(struct fs_chain *chain)
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
 	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
-	enum mlx5e_tc_attr_to_reg chain_to_reg;
+	enum mlx5e_tc_attr_to_reg mapped_obj_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;
 	u32 index;
 	int err;
@@ -242,7 +242,7 @@ create_chain_restore(struct fs_chain *chain)
 	chain->id = index;
 
 	if (chains->ns == MLX5_FLOW_NAMESPACE_FDB) {
-		chain_to_reg = CHAIN_TO_REG;
+		mapped_obj_to_reg = MAPPED_OBJ_TO_REG;
 		chain->restore_rule = esw_add_restore_rule(esw, chain->id);
 		if (IS_ERR(chain->restore_rule)) {
 			err = PTR_ERR(chain->restore_rule);
@@ -253,7 +253,7 @@ create_chain_restore(struct fs_chain *chain)
 		 * since we write the metadata to reg_b
 		 * that is passed to SW directly.
 		 */
-		chain_to_reg = NIC_CHAIN_TO_REG;
+		mapped_obj_to_reg = NIC_MAPPED_OBJ_TO_REG;
 	} else {
 		err = -EINVAL;
 		goto err_rule;
@@ -261,12 +261,12 @@ create_chain_restore(struct fs_chain *chain)
 
 	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, modact, field,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mfield);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mfield);
 	MLX5_SET(set_action_in, modact, offset,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].moffset);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].moffset);
 	MLX5_SET(set_action_in, modact, length,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen == 32 ?
-		 0 : mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mlen == 32 ?
+		 0 : mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mlen);
 	MLX5_SET(set_action_in, modact, data, chain->id);
 	mod_hdr = mlx5_modify_header_alloc(chains->dev, chains->ns,
 					   1, modact);
-- 
2.30.1

