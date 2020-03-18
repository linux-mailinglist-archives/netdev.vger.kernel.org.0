Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4319189425
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCRCsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:37 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:62369
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRCsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+OdWlcemQ24BV0fiklwUnYKbPyhnwgWwzZQ/2MM9Je+B+jwpUDF0lJp2EMViFSXqWxc5yHrL2Dcx4QAEoNDrJHnJpdjvrAVdzmLH3irnFcrJJqc+RvYTadCu+0P+6D3pRmmlVNIeK+7TZAdijKnCqermZE4I/GuMLoCXwNtmDlreOEJj1YewXuvgia6MvEhJve0poZA8AcDvR75SveNF3KapFXWBMj4YBDUvH83L1TVxNUjdjMliDz5x1uZVmQro76W9XncMLlD9rLAjsNKvrn3Ze4qRfQCOHUY6S7fcaEO37MiAMu2sJlIOS2TNb87QpC4eS3Hiznd+/VGCpjVqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlnaCr2aizRLPRw9YiN2Yu0TXt+R6gpaDtVTbq459a8=;
 b=PhftrNe19qbpZRsXs7eXnou4rTocYt+vp3gF8FNdlpr5gEYM9Qa38JCHX9QEZbGW27V8qI8ERhPWqBWPyuJGv3lx6zpqrU734E6KVT5Sg+yNdfZE0qMgOL3nFSh/iLVJKtwb0fdwW6+OoW5FX0HPle8GYmWJkpdIiOnoYv4A48K9E3BbT3MZoynuQw8eJpkc9BpmeMHcyjgqhx70s3aE43mtkMWo9qSkmOoCKGNtW9snPgAzSbst9RsQeAZ8apOHoiqOZ0rqrZCSUNmga5hpprucgaKxcOQ6tre7AvGkMSXWasGBIqinld/RQK5+/t01zShJj6bVypURs0eZ9nOcyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlnaCr2aizRLPRw9YiN2Yu0TXt+R6gpaDtVTbq459a8=;
 b=EmxL4YiJ+2yrFT14j8nEdRFxotlUh2bnr8Lyq/ZFaU18drLN2ArniGCIEV22QzgW0vHTq7C3zAIXEKcMm6l04uZ+NDZY/0GOmhKVvKaF42IKVq7ydxAco9nQIbajqsQtZAcnV99bkGlkF9pyCv5aLPZoe1GzMOzOkCI/XIwAgqQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Eli Cohen <eli@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/14] net/mlx5: Don't use termination tables in slow path
Date:   Tue, 17 Mar 2020 19:47:19 -0700
Message-Id: <20200318024722.26580-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:20 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 958bee0d-0ec7-4887-3bff-08d7cae6d2da
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB410904EECF02898668DD695DBEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(334744003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+NZ8EEeNaQYb/RiFHpJFNDpUBpQ3BBvmHqObJuOrLyzMTvFDhCfOFdp0HhIjfnxTCQFOGXtGqiv11aJURjH7SiUpNlwo6dqa1pe5GkECGMaRTsctouXNxFiipcPsJQpcbc1eFEXTmtD0s322lZ6Q+6nNjDjycYC9f0DzOsUZpn9tL4za9Q059k15PitVbLbuf6Oj9df+6QWReXDjQ981OHB1og2uey99PKVZ3KmRMcWLAnqHoi78697FYVGUZP3ry8N9/H3cxEqzxurvyi4zpY/+dV2rGOErmaQwzj9JtslVUuzDI3zU7P6FRBDsMPzLZyrZ4ASV5zQIMmAcLcI9oN7GwppL/9Zl6XHuDwzhix9/j8R/oKluXp/UwqC+nFn1M6ZtTeNbh0o5u4wGpOt6jAW+ycgcvSyvpCodXQyeU2hu80vt4SbcVEgYRGvoOgM6j4gyaIcHKnDd+gR598lzSrWTU5boovhJrwkZQUWj+2uoqx08hkuhehJX/yj6D4+nd0zQUJ2OPYr+y6UvM4yylB4mIkpmq7sMlT/e9pOH6KcI0TCuFOLrEtbBlJIub3v
X-MS-Exchange-AntiSpam-MessageData: RWIf7SMnzA7Om7ihFd2XayDp9c8CMesjlJ8METi1/HmCWQ+JByYRGd52pikSOA+wrVW5WuPNWJ71JoEdlHdw6WCoEh9v2yxFZnYryayFpMfJH+P7LrvcpYPhON8/7jy5R6V+y4tUD0yHpl8XbGJxVw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958bee0d-0ec7-4887-3bff-08d7cae6d2da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:22.6969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkBMCHtSPgNqUISxqt0kBPGy2o2QQQiHV0qDwy17cdY/ywmO0SPY1+nGxtJQjFaTZKqKbJSjq3rz2e2cmbkTcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Don't use termination tables for packets that are steered to the slow path,
as a pre-step for supporting packet encap (packet reformat) action on
termination tables. Packet encap (reformat action) actions steer the packet
to the slow path until outer arp entries are resolved.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 20 +++++++++++++------
 .../mlx5/core/eswitch_offloads_termtbl.c      |  4 +++-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c18de018c675..95532b258c2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -332,6 +332,7 @@ struct mlx5_termtbl_handle;
 
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
+			      struct mlx5_esw_flow_attr *attr,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec);
 
@@ -393,6 +394,7 @@ enum {
 	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
 	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
+	MLX5_ESW_ATTR_FLAG_HAIRPIN	 = BIT(3),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e2a906085a98..0b4b43ebae9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -300,6 +300,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	bool split = !!(attr->split_count);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
+	bool hairpin = false;
 	int j, i = 0;
 
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
@@ -397,16 +398,21 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		goto err_esw_get;
 	}
 
-	if (mlx5_eswitch_termtbl_required(esw, &flow_act, spec))
+	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec)) {
 		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, attr,
 						     &flow_act, dest, i);
-	else
+		hairpin = true;
+	} else {
 		rule = mlx5_add_flow_rules(fdb, spec, &flow_act, dest, i);
+	}
 	if (IS_ERR(rule))
 		goto err_add_rule;
 	else
 		atomic64_inc(&esw->offloads.num_flows);
 
+	if (hairpin)
+		attr->flags |= MLX5_ESW_ATTR_FLAG_HAIRPIN;
+
 	return rule;
 
 err_add_rule:
@@ -495,10 +501,12 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 
 	mlx5_del_flow_rules(rule);
 
-	/* unref the term table */
-	for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
-		if (attr->dests[i].termtbl)
-			mlx5_eswitch_termtbl_put(esw, attr->dests[i].termtbl);
+	if (attr->flags & MLX5_ESW_ATTR_FLAG_HAIRPIN) {
+		/* unref the term table */
+		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
+			if (attr->dests[i].termtbl)
+				mlx5_eswitch_termtbl_put(esw, attr->dests[i].termtbl);
+		}
 	}
 
 	atomic64_dec(&esw->offloads.num_flows);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 269eddc3d38b..4e76ddc4ef87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -195,10 +195,12 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
+			      struct mlx5_esw_flow_attr *attr,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
-	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table))
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
+	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
 		return false;
 
 	/* push vlan on RX */
-- 
2.24.1

