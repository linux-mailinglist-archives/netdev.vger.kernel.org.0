Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2F3213294
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgGCEJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:21 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGCEJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIAoF3jXARaNj/BRsaA1I9K9K1eiRnO8XGmQhrxZFzAeQA8TFlba9rOeoXeCYxijppx3kvzqlB4sb0/RHSYClDPNrn0/LJjQyh29dDervtuh00l4KMNpeEGBJ6xiPFpEOyNsUjMAY6FN6rF8imqdI9WOOXL7fl+88TxgF3l9ejLAIXbf6rzUowUMrhpqatuQO+OgSjHLfAxprh/Zj6/9LDlashJSKTvQ63FxTFRYN87dlIcuFnEimU801oQYoFpCmFQwlvexsOceFBTIGtQ6d37MI79YwfEsdfC2u/KL5FDvk3WodXDRXQAWrQ5NtDUc/Q9LXxtlX41YeugltCSuzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XRcmT/HSciG/AbwHXUhHaCXIXh/tnEQeWMLNnzQj1k=;
 b=GahV3QVN4Qj97EpPauMebD4JHHRo08QGpxaO/nLgDcGmrmfSpaUU3dAxv/9Pq72pELgUIxbsvBpNjMr6ADa0+32rKKhm8LRk3N0tqQ6OcQADae2SWJAorKK3NoV9Wa3RsLUBluWRF8Ofjp8HF9NvN5TPZ3pPMGoCmC9yRvIdpLV8APb222c9zeR0YsyHrqrWxuTKrEPC9xcPA9ENpXBLsyVriptn28STx0UYb8FzTw6Bt0bxYM0ipsekOOeogfNICtoJOP5hgEBKpBMPNHBAIAfCGh5A/a46HLP7VrzVTIh3l7U9pODWRo64XkTwDCXJ4lrz+yZXMz+WjLO8XQWPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XRcmT/HSciG/AbwHXUhHaCXIXh/tnEQeWMLNnzQj1k=;
 b=AohvpjGmKu2X7IRkKWD094LToI3PZeZlrpqzQ1ph3lz+5soh9N/VX9/3aSTZ+7OvKP2c15FAAjACN3mNRKu5ZAdws9/0DC33nu32eYabhdXn7hUFWpwclkElt+B0huJxzdWAkIpdBiCEH6KsHsnU9KaJIHSy2Tzzv1M62ZuNyQU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/12] net/mlx5e: Add a flush timeout define
Date:   Thu,  2 Jul 2020 21:08:22 -0700
Message-Id: <20200703040832.670860-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc373df1-8d49-465f-ed9f-08d81f06d557
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534A5787B0EACCEF2321D41BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EOANVP8CfkvXzrgBfmfhfgkOWV0n1vvrQVgzMoeoJzojU8UKt1oGK4wm/RdEDGiyg6Vs5nqGsEjYH9t05KLvoWN8ALgOp9TYgbPmWjsMer8JAXNjQMghQcN8de9BhFynFF1M+rRFF6ICrbQOHQySUm+WKckIgMdWIKNl03J9NhoxapOcuQOD7kBO7cKf3oPMIjjXRyLEm0G/ZwEZskZKDamV83cxkb35pgUUMVj1wpOlOj/dAb3mMbeGmDM0mY4zCuDg29aZyNWq46dJqHYtHtLvkldM8GXxQMIxHGa0cCEQx8AUxQHxhTFtO54HnhPuwt/7MxaO9N/+Op8z+nmm1GpzGRtpa/MhsWs/JX7uapYHSQ7CqkSZcS7pyNrX9UQp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0weVjXyZF/mfME3xMI+HllXi5QwqbTMLuM2VgXHhCLUnlELKIdM4T2od81LDkFnagujd9sVzO2EvlZERIvEotU1zZnLGRFKjZ/H8xy/Gmp8RBUb4KDg2zrv8Jo8Cp+Ml1oRtJHDVTQSpt9uLC2sVSfd5xu+isQePyB/BVCC3pEbR1LUrfHPbKlRH2ZpzIy9PjXAr7p/lMUv0wba64XsowI40unCAz1RJJRn/vIe3d2d6E9wNDPmVDE+X9zDIFgtHrPeU5eIkWR0WGQtNybcg1w9MpId3leMSGq9ZATuQFhPUp5W90e+GizuPyeMgSIC2AFAz1htOQESbkma1LdVpRRZLPsEBmKBjeufIIJ2hA3aH4SUauKOfvYpnG6duoHqg/jpiX87/iCUYFKaSRaFfratqQY67G03BO5ke5luCRpTvwTIquOj5tBWV1IxPZ31s+7xAQnpWMQ+VrkhWSWaH83/zR3BeH5wAcb2ONzokueY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc373df1-8d49-465f-ed9f-08d81f06d557
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:08.4238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+JY3BQUWo0BpuMZl28Xnl2bxgkWVlnfIMncNC7RWjugDwbgl/mnEPANLAWbwKubu2gWJlTkIt3aq6cWLeqz3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

During queue's recovery, driver waits for flush. The flush timeout is
set to 2 seconds. Add a define for this value for the benefit of RX and
TX reporters.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 895d03d56c9d..2938553a7606 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -33,6 +33,7 @@ void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq);
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
 
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
+#define MLX5E_REPORTER_FLUSH_TIMEOUT_MSEC 2000
 
 struct mlx5e_err_ctx {
 	int (*recover)(void *ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 5161a1954577..495a3e6bf82b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -29,7 +29,8 @@ static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 
 static int mlx5e_wait_for_icosq_flush(struct mlx5e_icosq *icosq)
 {
-	unsigned long exp_time = jiffies + msecs_to_jiffies(2000);
+	unsigned long exp_time = jiffies +
+				 msecs_to_jiffies(MLX5E_REPORTER_FLUSH_TIMEOUT_MSEC);
 
 	while (time_before(jiffies, exp_time)) {
 		if (icosq->cc == icosq->pc)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b95dc15f23b9..6eb2971231d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -5,7 +5,8 @@
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
-	unsigned long exp_time = jiffies + msecs_to_jiffies(2000);
+	unsigned long exp_time = jiffies +
+				 msecs_to_jiffies(MLX5E_REPORTER_FLUSH_TIMEOUT_MSEC);
 
 	while (time_before(jiffies, exp_time)) {
 		if (sq->cc == sq->pc)
-- 
2.26.2

