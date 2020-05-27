Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EC71E34FC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgE0BuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:15 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:6191
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgE0BuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6XlTI/mqOu0iMmFbnPLz871SOQWCGSNlsV2UPOVWk7cT9Mbb/Mc3dlhfdCuftSpWeA9y5l1SIofte0HHKO/QU7pC5etlpj+nrP8ZUuK4JR54CBd2RYi7pAGtrlGFZu7/Tg/nhJ9ZemAxN2LpP8bn2+XBhzf76tpL2NxzqMZgAun70U0FDjplapskPKnQKQlIPU6XYv1H/w4WVIEVFm6ddIynbqDRaIxh0/xHSMqQvE3z05dBByESP5y4H97tLbsGLnuV3dgH2RX48K1uF998kWcAcqAqKNw5eUfMXT3VRBBOKQ0upX2ZbhRUOQdXUgqrpzp7QtybGlN8Ob39YGawQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvNTHPGnSFfI0Ypm3p8/aI+V7zF5jeo1GFtkyVNqwT0=;
 b=IvQ+HKCpa6Xd1rtDhcP4T7V/xhkKhYl53ahlc6bb1w450WVXWU/W7giHzsq2cc43rOxwhdkVpiqILLHIXirH2Ykl7MA/BR4TD+wfB11oNBckLP3SLlNb3zGVd+i0kxRFNjIcl9heCXHPQcnuLpXdNZKTA6CJOgrRLeSt/+CnzbO9Czr0wocDWFIUDDekrggP33UzuA0pdfEhTCnud+uk7PmD1/MdY2sKxZfJCjR/jVeuUulDdbpbBrLHsol1SA5Lvi6AoQ7sAi//kDk8HFkZAXTI5yr0iZtzjVZOwi4aJQouMKIXc0V3It6d9TGWxAJytyGAzMnUTJRC5WOvjETSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvNTHPGnSFfI0Ypm3p8/aI+V7zF5jeo1GFtkyVNqwT0=;
 b=TBveh2cs4unxN0QGkd3/K8qhbPrHmoYOKGkzCaQ4BlE/wtzUG+KaSq53G06MWEwZu8AlSK0Mk9Kki9wXWRS4JxLO5kaxN3PCAGpdGOxXAEzxMHt7uJFLK8PZI/TsPRo0fsdNSPUgM7jUrKCyDBupwhUbSs23NwSV7jab2wKxi+0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:49:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:49:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/16] net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule
Date:   Tue, 26 May 2020 18:49:11 -0700
Message-Id: <20200527014924.278327-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:49:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b9e2761-6fcd-430a-f7b5-08d801e043bc
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6637412A37EB87ADF4CC21DDBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IKDlHDEMak+5+ULngWNWgQonGJgnibVnbVOIHLYaUsf0V+c303I030VtiNkU+Zrpq9zfYt3funuuCyNqVuJgoNJVzSSM3KkxKbo/2x3tw7nYi6rWFGlgQHKtui+gutMCTz8z2rP1TOhBHDKywm4DGJiTx4tFmLC/vJKHGfJkIaMkyjc2eOCMxfRCN3f4cvfwmG3dEsqe7Ta6e17crvMJ8O8DTqHzmfeLJFzqYaMLGOqg3+NWnIa8RB1xf3JWt8DiNQ0BIdW3USMgnWIkiEivJLojVjxRpogzd/8IhQ+KAcR5n4I/QdXAc8j9S4FA+2goiAIwN44fJu/QhCOZ+lSlA7S8VyLYsn3xxRrnSg+18FZQUAmU+6Ikb75CRPtzZMGY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(30864003)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EZ7szMxMSuKy28PK3WfqmBaR47UeQABQq8i+FysjAi+PqlmUhGAeAp2gKtYPAAXk8pc2SJcnEcGzXpRFgaB9lBYxewwI00dAJm3SFFUAcn+wndUDhtYRsMfe2KrWfGDvJpe7a08Hd8+wmmYkvk77ih2mb/bPgCFWeo9SJWQvfnK5rdKRwxln0ajoKmC2dZykeyFizbUERBpCqfACJQcZpMXm+D4BjE+sGiLVib15o//GiMGUIFcrxFYO7HmpTgsV5AE1OHWiKd1aHnrxHGbSubUVvTtbpVIYEQXPUXgTdSfaCJMGTEDD+kQoUx7ME9V63g5EV7mcm76+LY3wQ3FtGx8E0QHUDa1vSrXYUi5+0WvVoF7x/DZKzH5Kkw5eeWQ2FBD1shwaIVgRSLXsr5jXdH7fmszZA5MGptwKe1uzith9p0Y2EN3DQu3HHC4lpAU1BQGXnpyfT+E5taKqIG0D8vNWjCod0cp2K8jEZ/0r2cI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9e2761-6fcd-430a-f7b5-08d801e043bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:49:59.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0P4974/e3aAPac5p4ZyuwvU8mvnZR2syhJayuRWOslgL7sXSd557d6hpkpXAAm4dof7f/MUVlqk5Mtem/PDgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

By default, e-switch vport's egress acl just forward packets to its
counterpart NIC vport using existing egress acl table.

During port failover in bonding scenario where two VFs representors
are bonded, the egress acl forward-to-vport rule will be added to
the existing egress acl table of e-switch vport of passive/inactive
slave representor to forward packets to other NIC vport ie. the active
slave representor's NIC vport to handle egress "failover" traffic.

Enable egress acl and have APIs to create and destroy egress acl
forward-to-vport rule and group.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  | 185 ++++++++++++++++--
 .../mellanox/mlx5/core/esw/acl/ofld.h         |  10 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  16 +-
 3 files changed, 187 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 49a53ebf56dd..07b2acd7e6b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -6,55 +6,165 @@
 #include "helper.h"
 #include "ofld.h"
 
+static void esw_acl_egress_ofld_fwd2vport_destroy(struct mlx5_vport *vport)
+{
+	if (!vport->egress.offloads.fwd_rule)
+		return;
+
+	mlx5_del_flow_rules(vport->egress.offloads.fwd_rule);
+	vport->egress.offloads.fwd_rule = NULL;
+}
+
+static int esw_acl_egress_ofld_fwd2vport_create(struct mlx5_eswitch *esw,
+						struct mlx5_vport *vport,
+						struct mlx5_flow_destination *fwd_dest)
+{
+	struct mlx5_flow_act flow_act = {};
+	int err = 0;
+
+	esw_debug(esw->dev, "vport(%d) configure egress acl rule fwd2vport(%d)\n",
+		  vport->vport, fwd_dest->vport.num);
+
+	/* Delete the old egress forward-to-vport rule if any */
+	esw_acl_egress_ofld_fwd2vport_destroy(vport);
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
+	vport->egress.offloads.fwd_rule =
+		mlx5_add_flow_rules(vport->egress.acl, NULL,
+				    &flow_act, fwd_dest, 1);
+	if (IS_ERR(vport->egress.offloads.fwd_rule)) {
+		err = PTR_ERR(vport->egress.offloads.fwd_rule);
+		esw_warn(esw->dev,
+			 "vport(%d) failed to add fwd2vport acl rule err(%d)\n",
+			 vport->vport, err);
+		vport->egress.offloads.fwd_rule = NULL;
+	}
+
+	return err;
+}
+
 static int esw_acl_egress_ofld_rules_create(struct mlx5_eswitch *esw,
-					    struct mlx5_vport *vport)
+					    struct mlx5_vport *vport,
+					    struct mlx5_flow_destination *fwd_dest)
 {
-	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
-		return 0;
+	int err = 0;
+	int action;
+
+	if (MLX5_CAP_GEN(esw->dev, prio_tag_required)) {
+		/* For prio tag mode, there is only 1 FTEs:
+		 * 1) prio tag packets - pop the prio tag VLAN, allow
+		 * Unmatched traffic is allowed by default
+		 */
+		esw_debug(esw->dev,
+			  "vport[%d] configure prio tag egress rules\n", vport->vport);
+
+		action = MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+		action |= fwd_dest ? MLX5_FLOW_CONTEXT_ACTION_FWD_DEST :
+			  MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+		/* prio tag vlan rule - pop it so vport receives untagged packets */
+		err = esw_egress_acl_vlan_create(esw, vport, fwd_dest, 0, action);
+		if (err)
+			goto prio_err;
+	}
 
-	/* For prio tag mode, there is only 1 FTEs:
-	 * 1) prio tag packets - pop the prio tag VLAN, allow
-	 * Unmatched traffic is allowed by default
-	 */
-	esw_debug(esw->dev,
-		  "vport[%d] configure prio tag egress rules\n", vport->vport);
+	if (fwd_dest) {
+		err = esw_acl_egress_ofld_fwd2vport_create(esw, vport, fwd_dest);
+		if (err)
+			goto fwd_err;
+	}
 
-	/* prio tag vlan rule - pop it so vport receives untagged packets */
-	return esw_egress_acl_vlan_create(esw, vport, NULL, 0,
-					  MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
-					  MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+	return 0;
+
+fwd_err:
+	esw_acl_egress_vlan_destroy(vport);
+prio_err:
+	return err;
 }
 
 static void esw_acl_egress_ofld_rules_destroy(struct mlx5_vport *vport)
 {
 	esw_acl_egress_vlan_destroy(vport);
+	esw_acl_egress_ofld_fwd2vport_destroy(vport);
 }
 
 static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
 					     struct mlx5_vport *vport)
 {
-	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
-		return 0;
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fwd_grp;
+	u32 *flow_group_in;
+	u32 flow_index = 0;
+	int ret = 0;
+
+	if (MLX5_CAP_GEN(esw->dev, prio_tag_required)) {
+		ret = esw_acl_egress_vlan_grp_create(esw, vport);
+		if (ret)
+			return ret;
+
+		flow_index++;
+	}
+
+	if (!mlx5_esw_acl_egress_fwd2vport_supported(esw))
+		goto out;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in) {
+		ret = -ENOMEM;
+		goto fwd_grp_err;
+	}
+
+	/* This group holds 1 FTE to forward all packets to other vport
+	 * when bond vports is supported.
+	 */
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
+	fwd_grp = mlx5_create_flow_group(vport->egress.acl, flow_group_in);
+	if (IS_ERR(fwd_grp)) {
+		ret = PTR_ERR(fwd_grp);
+		esw_warn(esw->dev,
+			 "Failed to create vport[%d] egress fwd2vport flow group, err(%d)\n",
+			 vport->vport, ret);
+		kvfree(flow_group_in);
+		goto fwd_grp_err;
+	}
+	vport->egress.offloads.fwd_grp = fwd_grp;
+	kvfree(flow_group_in);
+	return 0;
 
-	return esw_acl_egress_vlan_grp_create(esw, vport);
+fwd_grp_err:
+	esw_acl_egress_vlan_grp_destroy(vport);
+out:
+	return ret;
 }
 
 static void esw_acl_egress_ofld_groups_destroy(struct mlx5_vport *vport)
 {
+	if (!IS_ERR_OR_NULL(vport->egress.offloads.fwd_grp)) {
+		mlx5_destroy_flow_group(vport->egress.offloads.fwd_grp);
+		vport->egress.offloads.fwd_grp = NULL;
+	}
 	esw_acl_egress_vlan_grp_destroy(vport);
 }
 
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	int table_size = 0;
 	int err;
 
-	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
+	if (!mlx5_esw_acl_egress_fwd2vport_supported(esw) &&
+	    !MLX5_CAP_GEN(esw->dev, prio_tag_required))
 		return 0;
 
 	esw_acl_egress_ofld_rules_destroy(vport);
 
+	if (mlx5_esw_acl_egress_fwd2vport_supported(esw))
+		table_size++;
+	if (MLX5_CAP_GEN(esw->dev, prio_tag_required))
+		table_size++;
 	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
-						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, 0);
+						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, table_size);
 	if (IS_ERR_OR_NULL(vport->egress.acl)) {
 		err = PTR_ERR(vport->egress.acl);
 		vport->egress.acl = NULL;
@@ -67,7 +177,7 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 
 	esw_debug(esw->dev, "vport[%d] configure egress rules\n", vport->vport);
 
-	err = esw_acl_egress_ofld_rules_create(esw, vport);
+	err = esw_acl_egress_ofld_rules_create(esw, vport, NULL);
 	if (err)
 		goto rules_err;
 
@@ -86,3 +196,40 @@ void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport)
 	esw_acl_egress_ofld_groups_destroy(vport);
 	esw_acl_egress_table_destroy(vport);
 }
+
+int mlx5_esw_acl_egress_vport_bond(struct mlx5_eswitch *esw, u16 active_vport_num,
+				   u16 passive_vport_num)
+{
+	struct mlx5_vport *passive_vport = mlx5_eswitch_get_vport(esw, passive_vport_num);
+	struct mlx5_vport *active_vport = mlx5_eswitch_get_vport(esw, active_vport_num);
+	struct mlx5_flow_destination fwd_dest = {};
+
+	if (IS_ERR(active_vport))
+		return PTR_ERR(active_vport);
+	if (IS_ERR(passive_vport))
+		return PTR_ERR(passive_vport);
+
+	/* Cleanup and recreate rules WITHOUT fwd2vport of active vport */
+	esw_acl_egress_ofld_rules_destroy(active_vport);
+	esw_acl_egress_ofld_rules_create(esw, active_vport, NULL);
+
+	/* Cleanup and recreate all rules + fwd2vport rule of passive vport to forward */
+	esw_acl_egress_ofld_rules_destroy(passive_vport);
+	fwd_dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
+	fwd_dest.vport.num = active_vport_num;
+	fwd_dest.vport.vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	fwd_dest.vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
+
+	return esw_acl_egress_ofld_rules_create(esw, passive_vport, &fwd_dest);
+}
+
+int mlx5_esw_acl_egress_vport_unbond(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	esw_acl_egress_ofld_rules_destroy(vport);
+	return esw_acl_egress_ofld_rules_create(esw, vport, NULL);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index 9e5e0fac29ef..90ddc5d7da46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -9,6 +9,16 @@
 /* Eswitch acl egress external APIs */
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport);
+int mlx5_esw_acl_egress_vport_bond(struct mlx5_eswitch *esw, u16 active_vport_num,
+				   u16 passive_vport_num);
+int mlx5_esw_acl_egress_vport_unbond(struct mlx5_eswitch *esw, u16 vport_num);
+
+static inline bool mlx5_esw_acl_egress_fwd2vport_supported(struct mlx5_eswitch *esw)
+{
+	return esw && esw->mode == MLX5_ESWITCH_OFFLOADS &&
+		mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+		MLX5_CAP_ESW_FLOWTABLE(esw->dev, egress_acl_forward_to_vport);
+}
 
 /* Eswitch acl ingress external APIs */
 int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ca7b7961c295..7b6b3686b666 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -101,11 +101,17 @@ struct vport_egress {
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_handle  *allowed_vlan;
 	struct mlx5_flow_group *vlan_grp;
-	struct {
-		struct mlx5_flow_group *drop_grp;
-		struct mlx5_flow_handle *drop_rule;
-		struct mlx5_fc *drop_counter;
-	} legacy;
+	union {
+		struct {
+			struct mlx5_flow_group *drop_grp;
+			struct mlx5_flow_handle *drop_rule;
+			struct mlx5_fc *drop_counter;
+		} legacy;
+		struct {
+			struct mlx5_flow_group *fwd_grp;
+			struct mlx5_flow_handle *fwd_rule;
+		} offloads;
+	};
 };
 
 struct mlx5_vport_drop_stats {
-- 
2.26.2

