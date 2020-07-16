Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F00222E14
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGPVed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:33 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:32841
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727101AbgGPVe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Em3Pg2lV4u+IIRTADXwc4KAnwxyEMc+tFjbYbr+qW9vCUtxcYXOvPQh7/3mMkkgr+d9v8ITsRghMMCvxgj/oJ5hh6Q1M9DXCh7jHTonOWkncGLiBOdHkPXUCORMkN456Xb0M3bUAUveuRkod87FwJUuFGL32b7NmwcZxa9M2xKKC5TaT+BdvyjM2RLEbo9aDrrlpD26k70SFOYAlBUsIXWmkbgqTrWwN1KQM8C1RFL4mfWPyBjJ2aqDpIIhDozbzI1QaySO2Xk02FthjVnWcHNmGVFXa0o0B+xnDfNYwVSIAHKrXmLsxXrXgwWDsgmeWPDhYlFH86Majob3qjPGmxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNVvI84ZPfYwvr9ZrIby3vdXILL97vPe7zHcaPgnjHw=;
 b=JhK8w9i9jgE5kqI8DWOPTbztexHrbiqDF3XGr3zSsZKivDxkPcrQMqum1hpP1iTBqli2DlLV8+xLHqK10Kg1nrzyNOu8x2KMvfGO+3n198GoSXOPcckaSZy2Hdyd3SS5OZdHZVANim+dJ7+clGfLa6YCPsKyYg0BHV5fXESNiuG6Yd7uwmlcMJ3GJEmw5hEvcKb9cG/4NSy8CoU1vR3NNXteliwOBPpdvw+cZ7lv31KMZiwi/uKjzGWmarBACgIzn/zq0vyn4czQpFHL9fjaOo0R2xrkzs00aUD7dGRHCGqcHQ4OPd5eTfvov9jAZ8B0iGs7XhbkvpoDO6ffGzPQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNVvI84ZPfYwvr9ZrIby3vdXILL97vPe7zHcaPgnjHw=;
 b=Fmg0eKRyEwjnYYm32NO1qj+ECJqH4+l/tSLRodPxvt/BtuF56Mrsl7nDs4KbnQY+bdAy3/x0EoYT/1OYuecMqXONiQ8iJUTdZVJQGWZZj71/PCv87ebKNWqYnX1xrQurzQwZDWo7CfPZ8bwQkO37R724APelU8Z6PXgh8RNMQzg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: Do not request completion on every single UMR WQE
Date:   Thu, 16 Jul 2020 14:33:20 -0700
Message-Id: <20200716213321.29468-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f82199a8-5989-4eea-6b18-08d829cffb95
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992670EB5E8F17F25AD9C96BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDrsW5lPoNqnhSqxRQzX2zcZwJnq/ik/BwoVrvuRFHdfaXcSJsSrhWpgR3dEpV489bA815Zb1utyY/cnqf2BfHfnERnHvTAXW+rIsfL9alKyl3CBEKSBvYsWaM9WtzW5hKJVKx5TldZJrYRweZOhrjhwwbHYgrzqR1kxEsTvHYkR25d4Xqf7HKMVlRWCNK6caMpMLnacU1xdYbuf9nAFVBTIsf6loram8/BamPNeUtiryS8zxw81pAr5AbRLAVYiNM7jPB677YtKt/lhy5rx/QoFZ7QejWu+VwMk4BYoxecEcfNzGsUQtAaNnVYXrAU4wSQejJdTYIuneoqSxFTdn/jHvZvVSzpVJgf7VpT+/kUEuL3WhtyjH0T06ZsPQSfy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b6R3KNUV1/MsnZZ+iWN1rh/qQ5xRtaS8+rZXohMx+D9h475cQ49HWCtFszSie8zFF48oSMWgB7udvAgeNPo/uZq1d3C4wXD3K6cYCl3thH3BQBX8foWhyotLcK0jR7m1z3gB1gvkZ6VhCsOdvTFEWeqOxaVYXnDTgLGDB4U4XTUElqqjEro+uVC+FThlu3kStx/PG/s1YQoO2UwgYDfEVsQ0i+Zkj5uBTQJG8s7akoOiQPYUhZMqMQM4ZxpNX8C8roV3E7x3RYiDgOSn6+vDEENJTPR5P55Bsn2vAAEpenszPhxXbjTzxtIXbbqFVF8/6OL0KY3LfNrZh8KaPVNpK7mDV1Ywdkj+OG4i7NeyhljNHt2weEd4sxedlqZSSZNjPkwC1nongVOchigcmd2Aoct8KcFZu0mFvop277fbgA6TCTTxekLwRltLp0acAXmDEefGOfqaMGn7oPLxpOpKHqZj2UVXtsufqOB1hKi63BM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f82199a8-5989-4eea-6b18-08d829cffb95
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:13.2615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKYeOgFVeGyPvzl098FdnDdLLtt08Ih4vBqY72G+a6M67fwvDmZg6ZxIggv7cxTcycRO9AS78PN4tPCqZeIFiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

UMR WQEs are posted in bulks, and HW is notified once per a bulk.
Reduce the number of completions by requesting such only for
the last WQE of the bulk.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 88ea1908cb14a..9d5d8b28bcd81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -232,7 +232,6 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 
 	cseg->qpn_ds    = cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				      ds_cnt);
-	cseg->fm_ce_se  = MLX5_WQE_CTRL_CQ_UPDATE;
 	cseg->umr_mkey  = rq->mkey_be;
 
 	ucseg->flags = MLX5_UMR_TRANSLATION_OFFSET_EN | MLX5_UMR_INLINE;
-- 
2.26.2

