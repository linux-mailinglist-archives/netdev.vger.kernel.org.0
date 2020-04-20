Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53D1B1882
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgDTVgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:36:47 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:25204
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgDTVgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1aHEbnCJPUCavvn7FUDvWmQyiX77TDJkH+TTAdyZJHbCx07iETpmp9rTmVJnsQmL/5zS7QEeTxSGWbWl4cvPqCWqNH5Piz++sblhDXg+3llr27ILJbu8muAD6tk3cTlczxfG4+mQuFnxMQlBfXUUH2acb4ueVf0sRSjfIkpMsZ/arA/63V2GbYbgMoVAPCr/C9Kmx0n6qylYYOnoj09V0umVpEuUlda/U61J2grAU109ipGrAjcKuhzj6/+GrOJGFn+SSKHfjmVH3z/PxABLLci6V4p8Y729IQratmlH0v68QnejTbzQVybTH5T4Qx4LNLY4eYPiNrPSGrI2BgLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX4iiClCIAiFmR6XXfOMJoIGoU2xawhMb2oOw4+0mXY=;
 b=YKNR+tPqIAywYCQ5gJBpISa1AYsesULgctZTWgwXJvfkArIBTs774AYFXxyK61JHtBkVVa7LHIcm8IBPYv00ylWgeX5cex2a43x5IQ3Xfsh/pAe73SiBYFwUXgWt1hQR4lopt1DjYkf/cFs173Sh7GAWLWdohGuo01E2YVyl7pIfU+y/m+Ow8QC69/+y9/b7Arp+anP2Hrdpvvqw1WYMnP5Wo18b6jtuu1bbwWp3uAQeiJxt3JwlZiTl3fQMONhH8+I78bQ/x7N/yNKr4ywFPQhAvVtYgErOeYI/ydCW8+xt4k6aKg9aG8u62HPFW6JwLshDME+R4H1+zVzoGprULg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX4iiClCIAiFmR6XXfOMJoIGoU2xawhMb2oOw4+0mXY=;
 b=qONPXNUHlbD1LMAQo89e0sDrA9lkEspZuES+DWEvijhlEuCrPPO1gykFFXr3Am4azdh1TX1MjqlVcQ7ZH/F+d0SU6qF0JtqqC3nh3GLnxzZd6uB+lSEi/XQ1OzUI1/5ap6ymEVBy7ERBNwWkskSwpf3srJMN87kabkxP7Sn/j/0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5005.eurprd05.prod.outlook.com (2603:10a6:803:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/5] net/mlx5: Fix failing fw tracer allocation on s390
Date:   Mon, 20 Apr 2020 14:36:02 -0700
Message-Id: <20200420213606.44292-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420213606.44292-1-saeedm@mellanox.com>
References: <20200420213606.44292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:40 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92f29c49-d497-46a2-e9a2-08d7e572ea39
X-MS-TrafficTypeDiagnostic: VI1PR05MB5005:|VI1PR05MB5005:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5005A16080C4EB515EC3FDCDBED40@VI1PR05MB5005.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(186003)(16526019)(54906003)(86362001)(8676002)(6512007)(6486002)(26005)(316002)(81156014)(36756003)(8936002)(6506007)(478600001)(956004)(66946007)(2616005)(107886003)(4326008)(66476007)(66556008)(52116002)(2906002)(1076003)(6666004)(6916009)(5660300002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXIzlfv1LepL49Qf/yqDGGY8vZ8yWIEvVGycvTWYAAmxDabdN9F6FFSB/BB6iZg3i09VwGslqLIdMSuGa/4yF8pwkAzdq0jY7pJrR4JoG1tG/b8hS8AnH32TM3rwijHplS1R2jfE5fA3JT7ylXFUavB9Tfo6Ng0EjnbrCOEL55XcZAsjlfl6Houje01qHn6YiDSDr/WA9/Yrvt42IWUGDd5eKiwdxIHxJR0ETNHCITkhqQ0cdK+muXuhRbFVQr7F8sKDszTPyNYqBPJOhypyA1VuI3ZVkYS9a6VqR4+U2tXjc951f4egU3n7HA0GJHIpULFY1QZC5gqY603uG82ajLMJNRppXF6px5OWvN/N0tZYSR6yR2hgMl+G03ZCFp0b59TvGYQWDx8FU8UI9PNEPjkNgPlknBh/vyVsXJU9e1JIq2dyb7hK7FmhgAho0mQ5a4PR6dUZ7dVuFv6aD10um49BZwIMDpc2Zn2xTTEMgQauUHpP11YitjW3+atJ51Ni
X-MS-Exchange-AntiSpam-MessageData: GgUIhl1aVylvL6wk5Ig0BMTMR2cesBFvKXOXrVbfi4NFMePvDT6FdzJupAJC558SBYZWpFF013m6Sg9NouCPAl9UYes0tGvptI3eUO7swcBEKFJWqH1pW/MprOXkxmn76Yq9MBDn3DlZgooQXCHaYQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f29c49-d497-46a2-e9a2-08d7e572ea39
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:41.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QixA76mPoFY/eoyMKJYwMsvRFw8GKvMuK2MbXDp7BBTJ8L/l6hWqvyYQNGxgQjtlchjpqV0zPEu5BJnUuDDIsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

On s390 FORCE_MAX_ZONEORDER is 9 instead of 11, thus a larger kzalloc()
allocation as done for the firmware tracer will always fail.

Looking at mlx5_fw_tracer_save_trace(), it is actually the driver itself
that copies the debug data into the trace array and there is no need for
the allocation to be contiguous in physical memory. We can therefor use
kvzalloc() instead of kzalloc() and get rid of the large contiguous
allcoation.

Fixes: f53aaa31cce7 ("net/mlx5: FW tracer, implement tracer logic")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c9c9b479bda5..5ce6ebbc7f10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -935,7 +935,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 		return NULL;
 	}
 
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kvzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		return ERR_PTR(-ENOMEM);
 
@@ -982,7 +982,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 	tracer->dev = NULL;
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
-	kfree(tracer);
+	kvfree(tracer);
 	return ERR_PTR(err);
 }
 
@@ -1061,7 +1061,7 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	mlx5_fw_tracer_destroy_log_buf(tracer);
 	flush_workqueue(tracer->work_queue);
 	destroy_workqueue(tracer->work_queue);
-	kfree(tracer);
+	kvfree(tracer);
 }
 
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data)
-- 
2.25.3

