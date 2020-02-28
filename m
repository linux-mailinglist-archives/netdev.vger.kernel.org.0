Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C47172D9B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgB1Ap3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:29 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730120AbgB1Ap2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPx/BeM0smWzzIy0z1mXTvwHwc4yQ+gnFVIZXaX8oyVJG8dCcYLD0oU7mAOTxMp+HzR+jBJ6aoaLoB5ifSC0c4ayiVtVPsUvkv56Du+DfKA3GkcgoBvtZoDMILbXpOp4V6oOfjqszZ3epzuB9oLw9/v+muEFfE+iZW2hXuBX4s9HxN+kIod2rqQWXh6NzU4xk1w1bRM3jVpEXf5LuGgEj6HWSh5f/FiFLqS3PrblS+qahEFQdw5w/REn8jeFz8rH4boyiDqyRg5YilKY5wmWqmTrSzViIY5GGwFQTolHciueRTE3NrozRrfi5g1/jycvHQgPvM1Gb4lXqsBTidJVDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdwA3CJAXiPPwWqm2HhMq9AIVfP3jr/1cGaddMN8kiI=;
 b=lS5wWghhkGv396+bsH+kJbq20YD2F8vfKQhZFUscHP6+Je3Do61PNYGq8P0cGauIzY/CTdfTZiA6E5TJFlaRdYG3Q1QsQqhcXjo14OKLoJYz2ekMXcUrjcaTq/13WMavhAnKk0XVEUOTLPNOejsp9v/ju5WmNvAMomzEe66lnGNfd9VtuasfZk90MKpyfzgo0ZWbtVqT7ab7Z9yZfiu04SJI0t2mB5wo95Ce0LsQOK937CQwbaCBH0r5zFkG+TZsKoDpAm5omSOB1PAqXNtK0CPPsjVVbU5ReKMTtKQo4jC8eJedYgsr97CJWLiuJzMc/YUf+FrYxtJxpueLMR7VSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdwA3CJAXiPPwWqm2HhMq9AIVfP3jr/1cGaddMN8kiI=;
 b=Up+CurGrzcnbHHTxOvfHp/bzJz8y7AsWZv6Qio+bJcjwHUkEZaBGcg81+stmTNxFBgQBLAL8NP9s275HuzSKk2A4HGMOZzTj7eFiW2+AQ3lwwiozOgBwsThVqecYGBakQUTHoCcYqKY10UfE5mLC96FHSsWx/hONiZw8jWK5iy0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/16] net/mlx5: E-Switch, Allow goto earlier chain if FW supports it
Date:   Thu, 27 Feb 2020 16:44:34 -0800
Message-Id: <20200228004446.159497-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:18 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 518078da-51ac-4df7-3775-08d7bbe77c91
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41897D47046A3F656A3CD6F7BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:327;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsMyq6ieQXZ+fCydmGJ+3yG9RoOUpkQohU+fZ5+W1VgdECzbNoVXwD9mttNMUv26eHRPfRxGgmR0ox9l24IjNa1XX7TDPkEi9n7Yo8ePL0UyBOp+xVx+Yphga3WuCxJY+/oHb8T5tZMzzMbeoFnW/K1zQImiJEe7ZN1Nu8GLdbeUSvMOc8LISEwfOkbSKQx0LPdVoRsuEK3AQe1r96C1GzobGNrOJW7RLlppizqMYgNpU43pcDUc/SO0ItO6kUPuqGfVetv7Voic6WlnSSmxB7pB98STHfPUOqsCWDLpzgkNim7ds99WJsWeaXWLo5xDI04Jit8YJUyolx3m1xT0nvvXiZmvVaCqUELm04TWZ8rCXQLVLXM111uR7lRpu7gY8UwmFJLFhTPf+SPfUEmhaGL+quFtnQre3KZ27rU6YAUsrq2Ur9IJs/qpgWqsEYzpGjFmLg1UMIqQQW5ropl15hY2Mg6DfakhrvGlQCJo0mwdGyVptcA8h3D04HT9XhdVX+iOvVDMBnjKFvPSyjB6z81KGWPPNdqFLHwDM5vT48M=
X-MS-Exchange-AntiSpam-MessageData: FBEJeyH/iN+ow5dDe/Q0Gd6ZVmXeOTL0AMRzzV3Lru4kUC/ng8h9J93vkG/Pc3+5BE5ci9cVo5pxS9ISs8LrQIrpPH8/FYPYZldn4UTLDztgKhdMnS3ohRNcQHBPwlE+L+ZyheE7DCnylZfINb4Hzw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518078da-51ac-4df7-3775-08d7bbe77c91
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:20.1943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DK2aYqyCSkEz3EMXlRNUqGbo/0puRzomIApu1AUhHsEF8GrUe/QShQxNbJsOb90B4xiwm5rl/tjWeYuWXEG00w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Mellanox FW can support this if ignore_flow_level capability exists.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              | 3 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c    | 5 +++++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h    | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 290cdf32bc5e..3be654ce83e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3533,7 +3533,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
 				return -EOPNOTSUPP;
 			}
-			if (dest_chain <= attr->chain) {
+			if (!mlx5_esw_chains_backwards_supported(esw) &&
+			    dest_chain <= attr->chain) {
 				NL_SET_ERR_MSG(extack, "Goto earlier chain isn't supported");
 				return -EOPNOTSUPP;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 883c9e6ff0b2..60121f2ee6c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -97,6 +97,11 @@ bool mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw)
 	return esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
 }
 
+bool mlx5_esw_chains_backwards_supported(struct mlx5_eswitch *esw)
+{
+	return fdb_ignore_flow_level_supported(esw);
+}
+
 u32 mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw)
 {
 	if (!mlx5_esw_chains_prios_supported(esw))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
index 2e13097fe348..4ae2baf2a7a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.h
@@ -6,6 +6,8 @@
 
 bool
 mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw);
+bool
+mlx5_esw_chains_backwards_supported(struct mlx5_eswitch *esw);
 u32
 mlx5_esw_chains_get_prio_range(struct mlx5_eswitch *esw);
 u32
-- 
2.24.1

