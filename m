Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42769212F6B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGBWUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:48 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgGBWUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHT45o7rBHgdMDBQP13UnSUjhilKnKB9WxVNAi2ZChfUSeEpTnZsurt0fpRMngyntrE39ISzOSls+HagRAAwhg7fNXWuq/ZWTLl9ax+ugLQF/1WD9MUjWQwYdZPlatAczZKjQ8SUqvMVECAzNg+hTasYTfU1CoB+pzMqt0Jc5qvG3ZE1gRQLhx1Y4sT3Rhq9D5ZYbegQ14N/WQP5q823sYl9QrsfCvXjF/GQP92FV3axp9DLqtnN0iLrIzeXUxQRtKEDX7P08bsnSWoE8VBqjCKwUaLaV7h32hnHxrK9EmBhw59kp56gpbZLbM/NgsmnYgBVcmQl0hYIyJx7ITEoyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUvt5r8/Ucy+C4McIMX8izt/KJotuT+0YMHgI39ykOU=;
 b=ixzeTnkh62F56N5k+WO+9f0x89Sc1zh4iYAXuof/hNE5d/mJ9f/Me5G0YBHDxvfMglp6GuJlzxfvt3FDwVGZDfOeATjZSN1I4WTO32z1mYQGTZ0hvryi062zA0zyTFnAGKhoovkZTwcAdw9aqUMIWEAOm3Gr1BlY8ej9Z55wl9U3W7LtExITuTahtZC3pXwco+BFBi6j1O3+zAUFhVqH0eXtydf14rbvPvTrnRP/butznEDRdj0VGguD+g0yqGXLcUif6QB13MrpbemlhyLwHHLrklDO4OtJ1+X6CTVmOP5xsx6n3hwzrtp3H8SRJSlQTZm45aaX62U6VRiJ2b6Rdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUvt5r8/Ucy+C4McIMX8izt/KJotuT+0YMHgI39ykOU=;
 b=rQ9ZVGkbbj4olFbi72oIwT+Zlnbd1bImdv0h8BjfGyXYfTPoaDKXbgOcjWy4mr3Cr0L8Yew/mOn5MdeK6mKjeRUsaOWBpUV8jvLq7FUFu8Wq2/hFmF424nPRLpe91ygiFCddFWeZVXBIzN+sV2pv+tMoT5UIltdHaI0A1iY6/kg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/11] net/mlx5: E-Switch, Fix vlan or qos setting in legacy mode
Date:   Thu,  2 Jul 2020 15:19:15 -0700
Message-Id: <20200702221923.650779-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc5ad70e-b2e9-445a-a340-08d81ed62540
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61096F35FE20753809E920E9BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IkCBvseZPZG5BTtRWQ8DBzH48fzPoKSYHms8ROi24CwLrBK7NXHu06f2+HE9c2J3H8mUmPNvOPKWMIGQ478WLvp6la3LQpkSm8dU03adHROdEZL6CqI4qmIKb5TpfDxQnx2G83El7fUJn7O4fxrJ9RzhkHOH4mJvMxmAsdLC3qXOzDnpmeqPf2Yk5HcHuFZ12ZbrUbsKnTygS+Gf522poIXrynR5gUcoJrrLYeDCklIw5DMNpKUcgrHT/y5GWxheOZFjPvKGgbZ9fT4k1WnQySK32+Ol6eb8h2fFTzkv3VGIhaoW6SrRfrJH2Yf3soTsSxirEoDDY644ie6/2WDFGfhu81MaMWMBEEn3AZg3waze0ACJtrRJ0G0Y45GAlvFz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GvWuhbl49NmVU5CS7MZPkCuWqwr4QGGsqBlbZ6Xo9GnihHvXcpQUhOv44yo9Yx+lZ7wbYtZxck6FhRYgv2BvDLe2BNxfJA5muugFDx1dhMP8Fjq1sD+3Yi2qx5cUvmq+F4yeb72CVDNhpqZomUShlkggBKntNwO5oFv7KmHd1TtRvIwvsXBwAvumsInJjl4qydr+aV/mwEh84rVqEiYsLzyMNguDVgcoPDZFwHQP4YrS4VNOyj9V+NzgzcSbxUs8fZkcL941Ohv89J2w2HfuwrhW6hRWFovK6/x7DTvXFvUsqv2wIKet3xjgbq16At7+JIEvSMIm+DiLEHqC2ceCCXlQ9OP22fRLeKAZPXhFesor4LEAF2+7uSDn/ntY3BekzpETMWpxctLKBLseoGMFF6ZyRidekZEWscHoyRjmND6aAQ/KcxOumsHtcgRr9Cqi5hbP5NHPO9bQP4yrtnCNC2LyJjTVec4PAa0NpZ/alOk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5ad70e-b2e9-445a-a340-08d81ed62540
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:37.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXs2AdRpRzDq34CPSU2cZ/MbGRcRwvoGnB3dCw8IO/eLwFHwTzB9OI4YaNiX0T0JQBnMNBTGaDLU/3c3PlajsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Refactoring eswitch ingress acl codes accidentally inserts extra
memset zero that removes vlan and/or qos setting in legacy mode.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 5dc335e621c5..b68976b378b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -217,7 +217,6 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	}
 
 	/* Create ingress allow rule */
-	memset(spec, 0, sizeof(*spec));
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
-- 
2.26.2

