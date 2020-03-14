Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34471853C3
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCNBRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:10 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727813AbgCNBRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NI+CEXoRMdQaVXZawJ1q9wzlTqoLddbVoW67YKUuTbRdwR+CpXbSBZDvY++pQdKe0gMdJzlTfBa8IklKuIY8HrqrESGGPyWfP5fKjwGDlajwlG+0RUcjVgQmIihzcLZnAuL5Z2hitoMdOWra1wRo76Q99SWrij1llJV5GT/aBkdg83ek88J0OiXUy/Yb0Rj/YJkbyUaxwJdbnlYYiRtLbMvY+/YLPaEbuNk+SwGZCaPihdh41Nni13umjHZZPI7LQ8zLWavpd9dPgCWnzJrJ1+WlMOVN7xriQxSfpWGRSZ29EnG9gsgs+k4zm2EDjIxpg/Uo89cnt938cY1Won7RkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfLS8TXB9qt0QbHEig7moo37s6j1oX0lTZFkcd8/NEg=;
 b=ZwelAac8FKQCRsUzq1fJEm5N/FRjq/AVcPKbsym1+DJSuEbpzx7N1cz8WHrdgdMgk14qfE5hSMKYY2ZNfdyeN7ehsX7of5hXLhT2wv9U/ZiSxcuMhXR90gekU3IrgCuXGPKf4Jhxq+JAGhDHamquEeg4vRsHPKX+3+AzaD0uk7b/OZZ3kXgBxs8IzoTzy1qAeHcwrGrIWIiKorCsKo+JhrUHjszVBKssPLJf0KDWyuAlWutZZBdCT13js4lXQ/2PZiTFVdNwZCOxu6x/JGA5oHSm1S4Xaz+iPKG0deg6INqDvd5VYdOVy5H7RzeM0Fey5PFpRLfVySdAIFJjpIKyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfLS8TXB9qt0QbHEig7moo37s6j1oX0lTZFkcd8/NEg=;
 b=BPp+FvTpWljHBWM2b0dsYluWkH05DQZ18061tuU6enpX9qHnkW/RTlAiZDMCX8hvDlIZmHDhI6CxMfFe619ORiRcsI+YfQsgAgg8Fj5/xJUc5NL2byLFCp6sTtC3213y/uU9P3j73GQfOHWP/COFtGvG9IBaG1mwBHIrdmukeCY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/14] net/mlx5: E-Switch, Refactor unload all reps per rep type
Date:   Fri, 13 Mar 2020 18:16:16 -0700
Message-Id: <20200314011622.64939-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:59 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4f87735-0d68-4164-4526-08d7c7b565c3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB68458BEB9AC4CA815753FC78BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fc/XuZwcVVOP4MoHUTgt2uQ0LyYHth9QyWkHfID2bkokoueABIbylHTl3y7dGhVIee9LZjrMN6lp0o/cifJncp92D7B69uUT3YBFFVulEL17uRKv4wLxcYf3LOAEqn72sOzpaUMfUGvdDmKtQcfdE4Q8Y0JW4y6OyJG0BKDlee3guwTtBBhX+Cno6qQwfpSdnXFxQ47pxd0stHummZhqYZkWedIBOvTr084bhYItPPNPsudR0iZVvUMtQdjrtAsejV/ZtJxBKOvPPS8d85YowS4TEOmJXI1+l7wKEm4DIjJbBhhyxMo9EGllZUE+7eiFKsttuDCVKfOtZJOHcmc3XYSjTFhvQTPSSPPY8b7BW/b9c5QY8zw5DFktIFflbxQAd2I8LNsq96Yp7cy0OiQGfSSt/YhVBve9EFLnqPjCMMQckCZ5mPjJ5A8sZzNGYPvUnS+/n6EHWbhFPNay+jjPHP/p8kFXYU37iMsGXqky9w0D0dh+hONcyXfk3zJjEDPL07hH0FnZoTE+D7OYih3foiMtr52bTEZlg6+5E12tzKc=
X-MS-Exchange-AntiSpam-MessageData: SqJvjY57tk8iwC97vBRN6T73TuMkmv3PICYFnRiGwXjVjf+wsWorIDahCV8VfEXwTrjjcLgL0FX6DLqK54BB0B9OclU/+vUrM/H76H4v+EYWIkekaesAiv0Rwi87yE0RwNNbBEpAj/tYFs1xz3U/4Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f87735-0d68-4164-4526-08d7c7b565c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:00.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1cq1Hxv/Enk3XJJ64eUB6xTE9XCwDz5yJSYOPMWv7j4/tvVk+f7scOV993ALa7fl0Ut5ZIiEFegwVkdTEzgG1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Following introduction of per vport configuration of vport and rep,
unload all reps per rep type is still needed as IB reps can be
unloaded individually. However, a few internal functions exist purely
for this purpose, merge them to a single function.

This patch doesn't change any existing functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 24 ++++---------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index badae90206ac..aedbb026ed99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1634,9 +1634,13 @@ static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 		esw->offloads.rep_ops[rep_type]->unload(rep);
 }
 
-static void __unload_reps_special_vport(struct mlx5_eswitch *esw, u8 rep_type)
+static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
+	int i;
+
+	mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, esw->esw_funcs.num_vfs)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
 
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_ECPF);
@@ -1652,24 +1656,6 @@ static void __unload_reps_special_vport(struct mlx5_eswitch *esw, u8 rep_type)
 	__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
-static void __unload_reps_vf_vport(struct mlx5_eswitch *esw, int nvports,
-				   u8 rep_type)
-{
-	struct mlx5_eswitch_rep *rep;
-	int i;
-
-	mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, nvports)
-		__esw_offloads_unload_rep(esw, rep, rep_type);
-}
-
-static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
-{
-	__unload_reps_vf_vport(esw, esw->esw_funcs.num_vfs, rep_type);
-
-	/* Special vports must be the last to unload. */
-	__unload_reps_special_vport(esw, rep_type);
-}
-
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
-- 
2.24.1

