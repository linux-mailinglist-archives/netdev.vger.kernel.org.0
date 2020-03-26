Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AF21938BC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgCZGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:45 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727655AbgCZGil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWgl5UPCGMrlluDASoT6b8LUjaUe2gA4nGdZ6Nlm5e+eQYSGPBldAmi/obhrmbmroPzpaElv6hPdGLnC+rfqgaDWaJXOggxrSvMFdEIimeH/nsdVFeLX2ShSyY+y1jz9E20Ggk+pkuiwJGVb5xgmAdvb1ARkfqNFbG7yayjoAPyGmnGIzy3o9YH8WvHZYc9lTsAY8Pee+W72KsT6bnoe8nvS54DL/X9FlILnOPvaR8/PGhJn2meYfqlD4NolS141StK+me/lKN8G1OvCOUhuXND04do6auqqrOhgTA05JWfcGkh0W1MOCV24KELkekDmZ9se7IP2pk6rZUZ04c0TpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wyazpwIQrqQsv5B38NhGMZ6SYXAentlcpVcV7DR9Ec=;
 b=O6naARev97dsEWeaoq2X/pnvZgoOcaeGMn6rdyk1duIXAMRGEqQHwK/i17LEXlK9FUOj/9ESSv4qgPdFLn14BzTgnEEM2re76GKagNASPNn6g9AdCGv4OvcNEJVCpxFWLfgy+JNhcu7VbOeYkRjOYewpTjcb9AUAUi4oaegeeaLs/JeMQd9GltzOFJbKQyZMy8Ximpup34mSr8gCFtinD7MQ25L2j92DzVj3KmlcIMnXM5TP9H5UuPTt2y8ToI7I8qVq9foAAAKy0LxKhLo8KPIWd2jKbOxnm70SxY3wHxCZ3OHUW6QioBeH1Y00fpednb+hpMX1ztJGbRI/ASzJpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wyazpwIQrqQsv5B38NhGMZ6SYXAentlcpVcV7DR9Ec=;
 b=LfYn+DlDXJHIQqv8FVrCBgdTSzhEP3pgW0WHOVdi/Fx7rhpQ6jZQvn3qR6aGdka9osc590jGvMcRkpFOuZx06Bnczk+8KdkiskmtMUbGvW1UDgctlAsOFqXDG6z/J7QtmUzCtQ8O34EpkbfqWCoBRwmSG35i/IhEpiEeA7S86J4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/16] net/mlx5: E-Switch, Enable chains only if regs loopback is enabled
Date:   Wed, 25 Mar 2020 23:37:57 -0700
Message-Id: <20200326063809.139919-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:36 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ab3d43a-3087-4b5b-4116-08d7d1505113
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64794A5EB7AA598AA30F5DB1BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P0e1p+llWTMPCGKNj/is+bZ40vKG4cczNSwCJVB0hihMgXoOzY9f+T+H/ZMO5sh8YTP1AucgGrWkgw635jVe78ywUyL8E00Ch00NTiMag8v+Ps3ATeIZxYEdawvrv8g9MhKxCHXbpT2JLlO69ljRYbxLyfkYymigm+XpDc0e25YfBZag7S2cue9wGeShdtP7Kc86Np1o9vIrXUmrwRbgpOMFiUh5R9YY1f1jlI/xnAPFDjlQi6zsVJX08JiaNt5jn2ffJBNkS8jG98EhxjQUnszV4ooR93nz8ahEN1ntU4+p4BtoyrVxjbmpxCywP7nqg0D13T9mxn6z7jin0EKzTwnGtamarBIKzeGxZVmZnpNSTZtEPmIinEYDuiKYNnA2CTDqB2dV57X/tgQVCvN7SWMGtvGCozqFpGbX1Qm1rteROxaJMn/rMaeQ4ZjCgpEqwcIuoD/P97ryuJ/dbSMR3XSuxTVb2hDuq5aPUmAw8FgzBUSnK/OsqALQNCqRiUMy
X-MS-Exchange-AntiSpam-MessageData: ScvRTxdcDtRaXbYCTPFXUpan+ANkGGM62jkbV1w2TfzTVfr+N2mx8mp5zOWEL5qf6eAckkGaTLZGur3pspzovuhtp1fdNL0ziHwLbLnaudvU+vhEnOCo8Z+GEBx1TJ4h1iZcITSxYMZ05Yd6tuMEVg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab3d43a-3087-4b5b-4116-08d7d1505113
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:38.6678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oc5rlvhisHX7rZ962bDqkMBXzD/YAyLAhLsTWTmuZfFTUulZFnf3Q3eba7xNa7/tbQrLn6jptWAIL1uGnPIESA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Register c0 loopback is needed to fully support chains and prios.

Enable chains and prio only if loopback (of reg c1 which came together
with c0), is enabled. To be able to check that, move enabling of loopback
before eswitch chains init.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 11 +++---
 .../mlx5/core/eswitch_offloads_chains.c       | 35 +++++++++++--------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index cba95890f173..ca6ac3876a1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2351,14 +2351,15 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
-	err = esw_offloads_steering_init(esw);
-	if (err)
-		goto err_steering_init;
 
 	err = esw_set_passing_vport_metadata(esw, true);
 	if (err)
 		goto err_vport_metadata;
 
+	err = esw_offloads_steering_init(esw);
+	if (err)
+		goto err_steering_init;
+
 	/* Representor will control the vport link state */
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
 		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_DOWN;
@@ -2380,9 +2381,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 err_uplink:
 	esw_set_passing_vport_metadata(esw, false);
-err_vport_metadata:
-	esw_offloads_steering_cleanup(esw);
 err_steering_init:
+	esw_offloads_steering_cleanup(esw);
+err_vport_metadata:
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 1e275a8441de..090e56c5414d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -280,7 +280,8 @@ create_fdb_chain_restore(struct fdb_chain *fdb_chain)
 	u32 index;
 	int err;
 
-	if (fdb_chain->chain == mlx5_esw_chains_get_ft_chain(esw))
+	if (fdb_chain->chain == mlx5_esw_chains_get_ft_chain(esw) ||
+	    !mlx5_esw_chains_prios_supported(esw))
 		return 0;
 
 	err = mapping_add(esw_chains_mapping(esw), &fdb_chain->chain, &index);
@@ -335,6 +336,18 @@ create_fdb_chain_restore(struct fdb_chain *fdb_chain)
 	return err;
 }
 
+static void destroy_fdb_chain_restore(struct fdb_chain *fdb_chain)
+{
+	struct mlx5_eswitch *esw = fdb_chain->esw;
+
+	if (!fdb_chain->miss_modify_hdr)
+		return;
+
+	mlx5_del_flow_rules(fdb_chain->restore_rule);
+	mlx5_modify_header_dealloc(esw->dev, fdb_chain->miss_modify_hdr);
+	mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
+}
+
 static struct fdb_chain *
 mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
 {
@@ -361,11 +374,7 @@ mlx5_esw_chains_create_fdb_chain(struct mlx5_eswitch *esw, u32 chain)
 	return fdb_chain;
 
 err_insert:
-	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
-		mlx5_del_flow_rules(fdb_chain->restore_rule);
-		mlx5_modify_header_dealloc(esw->dev,
-					   fdb_chain->miss_modify_hdr);
-	}
+	destroy_fdb_chain_restore(fdb_chain);
 err_restore:
 	kvfree(fdb_chain);
 	return ERR_PTR(err);
@@ -379,14 +388,7 @@ mlx5_esw_chains_destroy_fdb_chain(struct fdb_chain *fdb_chain)
 	rhashtable_remove_fast(&esw_chains_ht(esw), &fdb_chain->node,
 			       chain_params);
 
-	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
-		mlx5_del_flow_rules(fdb_chain->restore_rule);
-		mlx5_modify_header_dealloc(esw->dev,
-					   fdb_chain->miss_modify_hdr);
-
-		mapping_remove(esw_chains_mapping(esw), fdb_chain->id);
-	}
-
+	destroy_fdb_chain_restore(fdb_chain);
 	kvfree(fdb_chain);
 }
 
@@ -423,7 +425,7 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
 	dest.ft = next_fdb;
 
 	if (next_fdb == tc_end_fdb(esw) &&
-	    fdb_modify_header_fwd_to_table_supported(esw)) {
+	    mlx5_esw_chains_prios_supported(esw)) {
 		act.modify_hdr = fdb_chain->miss_modify_hdr;
 		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	}
@@ -783,6 +785,9 @@ mlx5_esw_chains_init(struct mlx5_eswitch *esw)
 	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
 		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
 		esw_warn(dev, "Tc chains and priorities offload aren't supported, update firmware if needed\n");
+	} else if (!mlx5_eswitch_reg_c1_loopback_enabled(esw)) {
+		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
+		esw_warn(dev, "Tc chains and priorities offload aren't supported\n");
 	} else if (!fdb_modify_header_fwd_to_table_supported(esw)) {
 		/* Disabled when ttl workaround is needed, e.g
 		 * when ESWITCH_IPV4_TTL_MODIFY_ENABLE = true in mlxconfig
-- 
2.25.1

