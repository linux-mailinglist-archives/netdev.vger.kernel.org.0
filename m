Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E41B7F3D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgDXTpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:45:53 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728950AbgDXTpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nr3fRjSfx4aCJBf2MvDkbIZMo3TSX+gygbRp28SC1A+fx66x7Nq7OLGPLJB4Kif84vXhZLP0r6ak1vaf7IyUviEVJvUj8mpbR23+MLSZOqY9ozAmQSs42rOFQllgST8FTSRxfCd+hFYIxrErAB+/1sBDh/1uqc5VEqJIbCsdXH1AwVVExL9KGqGfmdFWXSStPBhBYmvI/Du4GTRAoAUdaqdwxI7c9bdujBO5RCTmVSwKZaYM1FUkAmF6GsaKB66LIYRWHbQSLl30ScrIQN3RglQmBpRoQsYWDm1Hoc68MgrDTUqfqx3CqW2HyQTNGAZmI6spK8FCXNlEnzBMbpohlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqUvvy5MWNmr29zJjHwXw8sd/ZteGvOkJmvs5glZtaY=;
 b=Oj+wEbcibUTyU52uNKRR14heOKmyTWhuEYeDfBRmiVkpzAPy6Hb9fks5VJ1XxMXWh8NQp8ap11yG6c7Qc+Al2E97g6tReIzEdUwPE/WAKdiiuvyOIS4v52M6ZUComBG+5pZJK4FzVYkwrIYoE77HaAf7ZGpnlTBT7sggX9575xTTMqidvLQ1tr7v1e5zAwOGhVDTNNCVb/nkSEmOkyDg2a5rhB7qF6KDuPCyeKyazjTHmTKr50kQzeCIuS2k/uElIen4KUT9nMOaDFsV+X+Q+2/kiVgJarabJY98Xn0+1XSYSTEu9G0p7BaBwOKDz0DKng4QYlCyitSmC5WwMeeh9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqUvvy5MWNmr29zJjHwXw8sd/ZteGvOkJmvs5glZtaY=;
 b=HsyywK38pmqbDlW8EvBN8hwT9Ol8SWB8wAZazRXJ46nfRLzr5/LJNBZUZUtv9qxDtJpE9j8wvLWyyUEMYEiWv5Z5CS1/KLbNe+2s4URgfDXzLMCtEl1L/rRMQU7pBissN59OC7FxraESHvUWgSxtwSgi+SVRCINaP642w6VUSjs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Huy Nguyen <huyn@mellanox.com>, Raed Salem <raeds@mellanox.com>
Subject: [PATCH mlx5-next 1/9] net/mlx5: Add support for COPY steering action
Date:   Fri, 24 Apr 2020 12:45:02 -0700
Message-Id: <20200424194510.11221-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:32 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f5a58f5-5cb9-4264-b456-08d7e8880e0e
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50728F16E56C5A91C8CE031DBED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8VIzas+y3ofKESrjRTIP4XHUmOUYM3/azKdO45p6u5ao02X8DDIfHwOtRi9LZIsz9GtK2Tg6HWHaWp9iYGeX49NLuKXSo2Xbw9nzCP3kLfFQv5EV/zRrrBGZRNSJP9p23jQImcboghUu2h/PNzihGFPYP514yURaK9Alj/j49Nfi02n2TCHuHhL+TrFnlX5iBnzP5HMw8Mr85SmPc7jIqXXMJmOuPaJ5QhJspJ5txCQ5mV2pjB/2QRjgFsVYHmxbxkjAwCQ+Rb10j1/xWG6EQNkrXBNW1L4tVlRp3tI/XlhefHEKjD7GPTijUD+y1F4LlpolvafWgNLoITv4LJJgTpsApJ0hzPqHYvbnvbXpwIZwlsuKaWVbZ73A+cahFg6bGOpcl0ObO3+zTCg059kRwibQinUMUmcen/ZYjaW+b3z9P2yblr6RYqeNhUSe5h3Zo+AGrvg0jp2+rQ1ex5l2eO83ibHGahyzKFiCbBrikEIi6o374TE3t5JUPdCpgQw
X-MS-Exchange-AntiSpam-MessageData: oI0oOmYsqidlBF0TF4n5JoUomKaMqimwJOGvAdiVwst6txK5uLp0ifzOHFdjWPJZqplH0E5SvyP5+tObvC/RM5D0la1aqdsNVI3wPg+OMVi4FjwmeLwuF6if8CVGeaAr37jni3aZ0iCwGXG5kGYH9w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5a58f5-5cb9-4264-b456-08d7e8880e0e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:34.7334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgVZ9hNc5gCO42RFdm16mw1ceeQrdH2jh1xc8WHar7FqbSbFzapUC2treEeM+YxA2iSZe4QOOt8l6WVOB0iKVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Add COPY type to modify_header action. IPsec feature is the first
feature that needs COPY steering action.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c                         | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c      | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c  | 2 +-
 include/linux/mlx5/mlx5_ifc.h                             | 8 ++++----
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 862b7bf3e646..69cb7e6e8955 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -427,7 +427,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
 
 	num_actions = uverbs_attr_ptr_get_array_size(
 		attrs, MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM,
-		MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto));
+		MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto));
 	if (num_actions < 0)
 		return num_actions;
 
@@ -648,7 +648,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 			UA_MANDATORY),
 	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_CREATE_MODIFY_HEADER_ACTIONS_PRM,
 			   UVERBS_ATTR_MIN_SIZE(MLX5_UN_SZ_BYTES(
-				   set_action_in_add_action_in_auto)),
+				   set_add_copy_action_in_auto)),
 			   UA_MANDATORY,
 			   UA_ALLOC_AND_COPY),
 	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_CREATE_MODIFY_HEADER_FT_TYPE,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ad3e3a65d403..91464f70a3fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -385,7 +385,7 @@ mlx5_tc_ct_entry_create_nat(struct mlx5_tc_ct_priv *ct_priv,
 	char *modact;
 	int err, i;
 
-	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
+	action_size = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 88c0e460e995..12c5ca5b93ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -61,7 +61,7 @@
 #include "lib/geneve.h"
 #include "diag/en_tc_tracepoint.h"
 
-#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
+#define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
 
 struct mlx5_nic_flow_attr {
 	u32 action;
@@ -2660,7 +2660,7 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 	set_vals = &hdrs[0].vals;
 	add_vals = &hdrs[1].vals;
 
-	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
+	action_size = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
 
 	for (i = 0; i < ARRAY_SIZE(fields); i++) {
 		bool skip;
@@ -2793,7 +2793,7 @@ int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 	if (mod_hdr_acts->num_actions < mod_hdr_acts->max_actions)
 		return 0;
 
-	action_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto);
+	action_size = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
 
 	max_hw_actions = mlx5e_flow_namespace_max_modify_action(mdev,
 								namespace);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
index 029001040737..d5bf908dfecd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
@@ -274,7 +274,7 @@ mlx5_esw_chains_destroy_fdb_table(struct mlx5_eswitch *esw,
 static int
 create_fdb_chain_restore(struct fdb_chain *fdb_chain)
 {
-	char modact[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)];
+	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
 	struct mlx5_eswitch *esw = fdb_chain->esw;
 	struct mlx5_modify_hdr *mod_hdr;
 	u32 index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index dc098bb58973..703f307c5967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1490,7 +1490,7 @@ static void esw_destroy_restore_table(struct mlx5_eswitch *esw)
 
 static int esw_create_restore_table(struct mlx5_eswitch *esw)
 {
-	u8 modact[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)] = {};
+	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -1900,7 +1900,7 @@ static int esw_vport_ingress_prio_tag_config(struct mlx5_eswitch *esw,
 static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 						     struct mlx5_vport *vport)
 {
-	u8 action[MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)] = {};
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_flow_act flow_act = {};
 	int err = 0;
 	u32 key;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 304d1e4f0541..1a8e826ac86b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -791,7 +791,7 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		return -EOPNOTSUPP;
 	}
 
-	actions_size = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto) * num_actions;
+	actions_size = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
 	inlen = MLX5_ST_SZ_BYTES(alloc_modify_header_context_in) + actions_size;
 
 	in = kzalloc(inlen, GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 3b3f5b9d4f95..8887b2440c7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -576,7 +576,7 @@ static int mlx5_cmd_dr_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	struct mlx5dr_action *action;
 	size_t actions_sz;
 
-	actions_sz = MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto) *
+	actions_sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) *
 		num_actions;
 	action = mlx5dr_action_create_modify_header(dr_domain, 0,
 						    actions_sz,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6fa24918eade..3ad2c51ccde9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5670,9 +5670,9 @@ struct mlx5_ifc_copy_action_in_bits {
 	u8         reserved_at_38[0x8];
 };
 
-union mlx5_ifc_set_action_in_add_action_in_auto_bits {
-	struct mlx5_ifc_set_action_in_bits set_action_in;
-	struct mlx5_ifc_add_action_in_bits add_action_in;
+union mlx5_ifc_set_add_copy_action_in_auto_bits {
+	struct mlx5_ifc_set_action_in_bits  set_action_in;
+	struct mlx5_ifc_add_action_in_bits  add_action_in;
 	struct mlx5_ifc_copy_action_in_bits copy_action_in;
 	u8         reserved_at_0[0x40];
 };
@@ -5746,7 +5746,7 @@ struct mlx5_ifc_alloc_modify_header_context_in_bits {
 	u8         reserved_at_68[0x10];
 	u8         num_of_actions[0x8];
 
-	union mlx5_ifc_set_action_in_add_action_in_auto_bits actions[0];
+	union mlx5_ifc_set_add_copy_action_in_auto_bits actions[0];
 };
 
 struct mlx5_ifc_dealloc_modify_header_context_out_bits {
-- 
2.25.3

