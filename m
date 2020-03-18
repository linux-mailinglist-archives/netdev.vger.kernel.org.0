Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB44189420
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCRCsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:20 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRCsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTTOqQuJ9z9ojppyrGXVh99Tweh6xO08rGvchiPZjtdy9DMlEgCL8vBrwFsEI6u+N1BPmNIQI0H4yUWlESqzuoHLxYZPweXW6SjnX9tPSHNpUZ3jRvwaG1nuP1vJ99OFYeOHVr37NcQ2XZxBBGFo+xnVCsF96G7oSXaJU7/OQ3N3M0/axXneTWqvNdvocdgyaNBjk9DHDzoAkWRlBDXWMCjVs3H+H7H+7thE4+5+X2rTaQNjSJ/bRFUjdI/DR4Wmk8g9PmwjbwmeddGdI97ZiEIxSKJdjf2OdTXALYF4ZL5B/iHcjECpQGI2c5DRNYA9wZA41bmHcuTIKUW0dqHt1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZ19AO7uWN7LLS7nCPqO6rEJC505VNz1F6SikkE3a5k=;
 b=mh+TOzvjhun/Ulgu0sslyIw/sYrEugO3TkOEs0qAt6zBqDWMsK9qiZ5ygGSZzBC34w+L9gYpMuWIhoNVpXdNrGXT9FG0LF5vA+8v5nywC3ETqAJbgvr4vl+97GWmGetLKXDH0VqTsRO+j+MesDWCTXZoMTsxddGhY4nxowTk+rGWhlG2koPTVlNtNymLYgK0V+np+xfAyRdflTD2HfoWII9hc7bmpyN24sn8PYu1giebHFJQN4I8GgpR/RCuFzKfVyZUATazLyHoJtBIsROBX7srInfX7pXBYx9ardyA82lmrizkxJbJJ5dO6sEbi06YObO9pByt4EyXM3CGayqJjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZ19AO7uWN7LLS7nCPqO6rEJC505VNz1F6SikkE3a5k=;
 b=gzMFZQkGlzoVpqkS/+i6mr4fjdAsFIi6X1zdq9AyHP2AiUVi17YasIRZPBJh8291+UelfLyMcKeL+m3gXP7nLeUBEi1BGD02vn+ooCS0AMrvgOdZ8ZUnXhfvx2eILuE97R+KfojeJnVWwdLoThAiLMV+apUrX9zSMLUUFUSRJgQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: [net-next 06/14] net/mlx5e: CT: Fix stack usage compiler warning
Date:   Tue, 17 Mar 2020 19:47:14 -0700
Message-Id: <20200318024722.26580-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:09 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f86a1c7e-c221-4c0f-1896-08d7cae6cbef
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109D7B58F46ACD811B014F9BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ultFeetBdVWZKwdLGztO3GyWIXL+CF695uKC9iJfoMBFvJtUua8BniqegA8DFRTtnR3NesclckN5BeSOj1piyQQZGYpR1mQxisvRyXgPotiyT1PT9pRftuBZiIZ9zb00A66KXHOZhn4cDxqUWsSpz4tvF5n+AwoKEAgWHUe8giYx3Z8u2chEC8eHU78TJDQRxYq9Og9lW74aKu8E3/qlOYiV4uL2nh9j//snyXcqdwdiPgip6fNrsbONUjJxw3GboHaL1zxl+J3Ft3wUr2TE4983xvWp96Yhib1S3Nlm4ddS9FNdyCWT/U9ciNPw/BRfjjMtW5+LJ+B0g7foW00yhseanM1v5yxRBrp16b5keKhqWr6GUZYSTwfwNeXsN5Cnm6mT7hqXFbXYA0K5T4wniJaNoP65L3PLF/sbF9K1U5LJP0HQShI+AftMOY6FTZuVfsPyGTkZgv0MJ/hqo9mTsC4Nu+eeOKTit3FAqMywm+LcM9d2I1AU433fn3bf1bVltPSDeLSQnvVJzVG90CU4592XeMSp79Ftek+choYH474=
X-MS-Exchange-AntiSpam-MessageData: lKLMPZAEX+TiSP62aUFEiTCP+5IUqXv+ShBDoM49SAlIBuQIaEbd5y1daQ5i6KbG2/tuiUg5CtI81M/N0Thct1aATq7BZK2o7kCv7LP84vAS8bP5dJPWshZ1ZfqlvAHgHHjPdEeMvvFt6MtRtr3Nvg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86a1c7e-c221-4c0f-1896-08d7cae6cbef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:11.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1Luo4N6Wg0kG9j6CgUM9OpQc+NvO+pdR1pRwLQ6p+8xoRTaO8AlI5GwSIHxjSmsX71kw5zK2pl+CEZ2EICVBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following warnings: [-Werror=frame-larger-than=]

In function ‘mlx5_tc_ct_entry_add_rule’:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:541:1:
error: the frame size of 1136 bytes is larger than 1024 bytes

In function ‘__mlx5_tc_ct_flow_offload’:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:1049:1:
error: the frame size of 1168 bytes is larger than 1024 bytes

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 31 +++++++++++++------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9fe150957d65..a22ad6b90847 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -484,19 +484,23 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
-	struct mlx5_flow_spec spec = {};
+	struct mlx5_flow_spec *spec = NULL;
 	u32 tupleid = 1;
 	int err;
 
 	zone_rule->nat = nat;
 
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
 	/* Get tuple unique id */
 	err = idr_alloc_u32(&ct_priv->tuple_ids, zone_rule, &tupleid,
 			    TUPLE_ID_MAX, GFP_KERNEL);
 	if (err) {
 		netdev_warn(ct_priv->netdev,
 			    "Failed to allocate tuple id, err: %d\n", err);
-		return err;
+		goto err_idr_alloc;
 	}
 	zone_rule->tupleid = tupleid;
 
@@ -517,18 +521,19 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->counter = entry->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
 
-	mlx5_tc_ct_set_tuple_match(&spec, flow_rule);
-	mlx5e_tc_match_to_reg_match(&spec, ZONE_TO_REG,
+	mlx5_tc_ct_set_tuple_match(spec, flow_rule);
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
 				    entry->zone & MLX5_CT_ZONE_MASK,
 				    MLX5_CT_ZONE_MASK);
 
-	zone_rule->rule = mlx5_eswitch_add_offloaded_rule(esw, &spec, attr);
+	zone_rule->rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	if (IS_ERR(zone_rule->rule)) {
 		err = PTR_ERR(zone_rule->rule);
 		ct_dbg("Failed to add ct entry rule, nat: %d", nat);
 		goto err_rule;
 	}
 
+	kfree(spec);
 	ct_dbg("Offloaded ct entry rule in zone %d", entry->zone);
 
 	return 0;
@@ -537,6 +542,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
 err_mod_hdr:
 	idr_remove(&ct_priv->tuple_ids, zone_rule->tupleid);
+err_idr_alloc:
+	kfree(spec);
 	return err;
 }
 
@@ -884,8 +891,8 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
 	struct mlx5e_tc_mod_hdr_acts pre_mod_acts = {};
+	struct mlx5_flow_spec *post_ct_spec = NULL;
 	struct mlx5_eswitch *esw = ct_priv->esw;
-	struct mlx5_flow_spec post_ct_spec = {};
 	struct mlx5_esw_flow_attr *pre_ct_attr;
 	struct  mlx5_modify_hdr *mod_hdr;
 	struct mlx5_flow_handle *rule;
@@ -894,9 +901,13 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	struct mlx5_ct_ft *ft;
 	u32 fte_id = 1;
 
+	post_ct_spec = kzalloc(sizeof(*post_ct_spec), GFP_KERNEL);
 	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
-	if (!ct_flow)
+	if (!post_ct_spec || !ct_flow) {
+		kfree(post_ct_spec);
+		kfree(ct_flow);
 		return -ENOMEM;
+	}
 
 	/* Register for CT established events */
 	ft = mlx5_tc_ct_add_ft_cb(ct_priv, attr->ct_attr.zone,
@@ -991,7 +1002,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	/* Post ct rule matches on fte_id and executes original rule's
 	 * tc rule action
 	 */
-	mlx5e_tc_match_to_reg_match(&post_ct_spec, FTEID_TO_REG,
+	mlx5e_tc_match_to_reg_match(post_ct_spec, FTEID_TO_REG,
 				    fte_id, MLX5_FTE_ID_MASK);
 
 	/* Put post_ct rule on post_ct fdb */
@@ -1002,7 +1013,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	ct_flow->post_ct_attr.inner_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr.outer_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr.action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
-	rule = mlx5_eswitch_add_offloaded_rule(esw, &post_ct_spec,
+	rule = mlx5_eswitch_add_offloaded_rule(esw, post_ct_spec,
 					       &ct_flow->post_ct_attr);
 	ct_flow->post_ct_rule = rule;
 	if (IS_ERR(ct_flow->post_ct_rule)) {
@@ -1026,6 +1037,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	attr->ct_attr.ct_flow = ct_flow;
 	*flow_rule = ct_flow->post_ct_rule;
 	dealloc_mod_hdr_actions(&pre_mod_acts);
+	kfree(post_ct_spec);
 
 	return 0;
 
@@ -1042,6 +1054,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 err_idr:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
 err_ft:
+	kfree(post_ct_spec);
 	kfree(ct_flow);
 	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
 	return err;
-- 
2.24.1

