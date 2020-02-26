Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE716F4D7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgBZBNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:31 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729855AbgBZBN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJaV+DYYzEd5J4XrZNv3x6RPuilTFesfWTrFm00VGC+Wlp75rNhmUJ2Rxj6utUEuF+sEkbsGfVFnxhhROUKxJwY7rYrhHw0xsJCEJx0KkgokzKwnjEYtYX0TUGPxJ9Rw8Exlp5boHFrA6RNgPYyBA4pPBd2e60tHsZMeIAHgy5GS7wyfh9kHkEidPfExrfcW/l2nKlxSqd3QYOcKZG9Pl08gPtqMFEtLtEbjMAGD1cg863z/AF8DwnOI0aW64STsSeLs96Cd1buZTPfMkoFbwulNdl9x1Aez18HBDHvwgNtvrc2O0R9RyDVoSLpR98nGKfXqfQYeYAw4YYjuVSy+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt58zSFN6/39WlHuwvek+3L4Ah4kYve/i6LBynNe06I=;
 b=gTNeVzbKwz8DKA/pgJ3/PEmI2f0x1CFW01pqPg2jdmm6PgGqOVbHMZ0QWDOyqQRx9omiZgdQ3rqwEy+cFA3iCQQc20tGzJhb/VvcDRoNEkFHru9IgvSzKOjJgKzVLHayT817Y0H1yRwNCdPXkPHQSGuyDy95OO+TqLQFnOo/jrIRdpItWm/EYUKcQgoJP++7jvCcMvF0uQFTUdNCIHjoAdZ9L+HC4qdV2Xnsjo/DxQk173AW4TWXub6pki3SKvGcdEhgo345kIXZbTZCEtLXoE1pXqA3zzSKqnU00ei4kN8SEldRmV5ddJNruKh7tgw0QLYZYhyAqeTZ3O2S6DbXMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt58zSFN6/39WlHuwvek+3L4Ah4kYve/i6LBynNe06I=;
 b=L+oQeot7HADVhZs9/FG/ZC4uFCuBxEDmbW603LnRwGw6X646lQcBMcPLvpGb9otltQ8WgWcR9NZfjr3hosM2WuW32dKtmgNdNshhRTzZScC4esM/2lw+AMVh2wbHlb5ZC928hO0S0hIFts2RsoSpAv316R8/YLJF1vuvUtbytZc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/16] net/mlx5e: Add missing LRO cap check
Date:   Tue, 25 Feb 2020 17:12:32 -0800
Message-Id: <20200226011246.70129-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:12 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5d23219-eec6-479c-3a45-08d7ba590da5
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB703866CF28197200BD4E0F9FBEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(316002)(956004)(26005)(52116002)(478600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XjCcJKngDEC1yeGDymmkseVDyy8ba/lsk+zP1lFjBvGnVHM69SjmzVGSCdMOxgRjSmw1c+Tv3dOsOzWQFA2UFxuCC1D1BvLcEXaNRaCYWPEDkABdWxAj2647GfWVvodmpIBMzcLQLlU8lWyLy/ld7AfzaRCWs6UF4+ou85fxWiv5I8KsVO/hiAeUiMdMEMHMf2O4ZzW+CMSq8Ocy9+8313+nPUyUR2TKouof2K5/384dH2jWTlIZZpOYZwqd3OCGkzficCswidLmqvKuDdf5xdSgrAkGoj9UYvJLdj4eSrv+3mOWeatrsHRSHS8WKZSKeuB8d56ipx3kwb15VqhuZJSUI8dkumPyWoutHLaNiWvQy6A0v49npQyr8tIB49aHczNm0QWc+vJ2SMQhibfO/O3xjFTng1cvP9g+1vatlYuGCvBttZFGFx3LpJS5xJyHRmqD2PSkjAYF8QtltjztuwHhovpnAsZwlufk1q98V9Z8FftuzgwSO7aXgGLHn+4pkYTUdo1L+FZHO4/zLOI24JfGwd6CpXVEaKnzwD3cMI=
X-MS-Exchange-AntiSpam-MessageData: E80TympzT/2XBv76MyXORShqQiPTBZkeMWmuA5v8P7HKp+I5aJeA1/Rx9QOWPY0JhrP1TJoMQElIMEjHkY99p2wfc7UfGAwNynvFxj2vi6H2AhKfuBhuqHQA6OfwYWtofB6DTR/jtgHKwetWwgCmQw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d23219-eec6-479c-3a45-08d7ba590da5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:14.3910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQX4fGVlT10FVYsa1wNFLaHSXTeOzTv0PhZtbibI6cFSZwr5awfgTSWJsuw/erNsQxc8pQpD38Nyt9aEIPw/PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The LRO boolean state in params->lro_en must not be set in case
the NIC is not capable.
Enforce this check and remove the TODO comment.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 966983674663..a4d3e1b6ab20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4770,9 +4770,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 	mlx5e_build_rq_params(mdev, params);
 
 	/* HW LRO */
-
-	/* TODO: && MLX5_CAP_ETH(mdev, lro_cap) */
-	if (params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
+	if (MLX5_CAP_ETH(mdev, lro_cap) &&
+	    params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		/* No XSK params: checking the availability of striding RQ in general. */
 		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
 			params->lro_en = !slow_pci_heuristic(mdev);
-- 
2.24.1

