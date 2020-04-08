Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F21A2C0A
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgDHWwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:09 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:65377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbgDHWwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QX0gY3bh8syU/pDzv7Avg45DhNNBeTa1VglMgXbWrhS/KozEOM6+kMeYvtY7eJIdGVN3IN7pcZ3NBsODVVGTEsyjlpusnZUyjl8qDTcEYMXKL6QKK3+XihHVXaOb8lJJ2pCy19n1TUnHU3qu5sbFsiIKnSXivy175eXdnVS3RTApJ6iii4ZiSM8wT+B+wdnWtVuQ/VyJd4j8xufwNJZizg9SDuwA1R7GQNhCbhYtitxGHbtM6WNgRF7MKBkQB0Po6bm+gvpzjQkJylYbUmYJCPNZ14MOuHY1s64LFXkjLMSpAqySqkRej/ZR3Gqb4y0HHkZV87KRcr3sAImZBbJQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMl+Xmog7Zgt2utb0OBUFQuNaXxrCfvFgwGZ+u9BPMo=;
 b=VGwdNMBQMS6spOM1qWNBuGqiHXs6vpXsjo5JhJ9iT7w7J1VlDdi3EL2c3i8icKxxVNs0a1fbYYQFoIKVRZRCnvlRcBTF/7D//pPaShsRKp19Cpzb2YM5zjyA5hom9HDz/4Ij/TFe+nixhrFndXE2gWNCzXS2zhd8WHv+W4twBDsdAkjD1Y/fdEMs0SolQrf1Gdn4CyenuCsDmUk/UCxTRpDZ7tIQ9PUAIyFlGU0wjKDYOttfH+o8dS80qbSyMpyj22gZenEAMyiFKGn+T1HFA016l2OhAzHtDAQsYTGVlVN/67MeiPUDxj+3PNkEc78tgBLientP3T5EJB33e7h8Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMl+Xmog7Zgt2utb0OBUFQuNaXxrCfvFgwGZ+u9BPMo=;
 b=N33Ub1dUTPXYQ07nV0CaSC4Ia7Z3tu1lc+o4EZ4j6szoMruB5303HBO1J59Q8C7zgAUVl7C+HZK7y1GoFy049uYZy5SUXHkjUloAoSa0CRzqUAwRVao4TddFsGpbi+QjNVgnUaSSF0C1xdXirq4WK5Kf35cSz20AXz4Okxm1oLU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/8] net/mlx5: Fix condition for termination table cleanup
Date:   Wed,  8 Apr 2020 15:51:18 -0700
Message-Id: <20200408225124.883292-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:44 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36d9b529-62e9-4d87-d0b5-08d7dc0f69c4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6365ED242158A6E853C97F7EBEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnVxahDM8uuhob3PSEz4yqssdYJCrh2tgNzfYtD0rR/B39HfVyFkSwb7TQGBv4HDm+gWLlMkJRbCPnBqKzCyA0XgYSE4LwwvamayfZN2wJTAW5cwl6isthkNdticJKRe1I2mB8gGyWVynoqJSfKQPK07yHR5+u6YDrkie6yAM9mx4p9Ws8I77awzrwyeg01xv6qqowZ+TpFvTeLcqZQ2sWoU/H/L+QRMeWiNVigUQ+6ATGNfk94LYYR3rkSA91ONy3E63zCrRhPkKh4zOPGG55h6QAwb9VbpgNNTQBfhfupsKniF3VQnH6ayJCDkk5jeHcnaPfkkF42du/P6Ln4TE4J0VLfXn1NmYHMzhCep4yvyAxFa5wcQ10Rgs04GKWQhufIYvFLCACIE/CwnHlTGHdA8T+79+rUsVdNbDr9D2WlOFGqJVBF/ybI176uEg+EAlN+hkA7n0X/JhaMwc98NsHSdNgTmChoNRDhuGS1j65cUvh8snY+qro+jPfakBJAW
X-MS-Exchange-AntiSpam-MessageData: uClMkxqjhVTjcIG3Z6PLicyPQaXKSdKU9JrrkR8aHKN765pXDCgIwqODgAKepjhbhmX9HSd3sF6xC+5FbvlEFaRX+L+OPdXiYR1THFsTWxkDnvEvqAziXNrchJqXakvV9qxK18VkOyIfSxE6ddECfQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d9b529-62e9-4d87-d0b5-08d7dc0f69c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:45.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6n6kPzlb14PKE49S5vvDcglLMTMwP6KKUfoyxGCJ2xNt/QBwDOxdobPqL05qxkA0JGBBcJEHwbG8djPpth+Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

When we destroy rules from slow path we need to avoid destroying
termination tables since termination tables are never created in slow
path. By doing so we avoid destroying the termination table created for the
slow path.

Fixes: d8a2034f152a ("net/mlx5: Don't use termination tables in slow path")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h    |  1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 +++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 39f42f985fbd..c1848b57f61c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -403,7 +403,6 @@ enum {
 	MLX5_ESW_ATTR_FLAG_VLAN_HANDLED  = BIT(0),
 	MLX5_ESW_ATTR_FLAG_SLOW_PATH     = BIT(1),
 	MLX5_ESW_ATTR_FLAG_NO_IN_PORT    = BIT(2),
-	MLX5_ESW_ATTR_FLAG_HAIRPIN	 = BIT(3),
 };
 
 struct mlx5_esw_flow_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f171eb2234b0..b2e38e0cde97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -300,7 +300,6 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	bool split = !!(attr->split_count);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_table *fdb;
-	bool hairpin = false;
 	int j, i = 0;
 
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
@@ -398,21 +397,16 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		goto err_esw_get;
 	}
 
-	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec)) {
+	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec))
 		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, attr,
 						     &flow_act, dest, i);
-		hairpin = true;
-	} else {
+	else
 		rule = mlx5_add_flow_rules(fdb, spec, &flow_act, dest, i);
-	}
 	if (IS_ERR(rule))
 		goto err_add_rule;
 	else
 		atomic64_inc(&esw->offloads.num_flows);
 
-	if (hairpin)
-		attr->flags |= MLX5_ESW_ATTR_FLAG_HAIRPIN;
-
 	return rule;
 
 err_add_rule:
@@ -501,7 +495,7 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 
 	mlx5_del_flow_rules(rule);
 
-	if (attr->flags & MLX5_ESW_ATTR_FLAG_HAIRPIN) {
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
 		/* unref the term table */
 		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
 			if (attr->dests[i].termtbl)
-- 
2.25.1

