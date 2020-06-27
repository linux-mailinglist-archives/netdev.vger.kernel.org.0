Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07C20C443
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgF0VTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:07 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:8866
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726601AbgF0VTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg9wOoBqfh3xFD1eSLG4qMV2BcDWrhozOghpXPuz9QRZEO2H0oQN9b2+jZJmOTC1DKt7f8K9JkiM5t/pcLz2IUHehu+NKsx7yfUrI0e02fpvJP15kB/x2GW008AtSXdvcOjSU9vPyY3N/24bqEzKP/tlzUed+qOJcDVqd48L/ZeBX6DbzV1XqygIFpjm+eByRGsjz1JY2qTTqNLLHsS0s5GrXC2cLiRvx0taVrUgooD6gubYTsqCCXW/uHNF6nXFq7b4uG0UL4Se2qiMqyoDkAKJ3wwBi9j347bePRvZN/QZFguYP2dYrSR9YwaebMFaq7rh7qbiRA1P+r3qdk+tPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB1EIxhsPSpBrA3cdZ6wzJBbukNCV4D08mBoezhIC6I=;
 b=TwVftglx3fXyW5Z6rIC3Aj3JDgWCdWP0qOsHU1UWp+wmvAH/IEieUBUFWv74KITD9WhBGkxTduy/1HISgxgt7Zz+Trmt6oejujqWKZ/7oX4bB3f58Q9OjEm/vs1bCHT9r07IRlIIVq9wMEQBJV5qGQlD6LeWao2VQhBxdsjqhPZ74UqBCwTGswzi8Pyt8WF37AktywUfzjnSrbR37e0oJGK0hVLysoMcwdSv3FKLlOU58MFx4re/4MD/cbvJUGaAJDTlSvBzjc7qNyt3s2rJDpsREpk4pu/7xLp4DXq0JHJiawAgOLjIhrfwsCF1zKNH+35OKgY8HKkgyMfdE4M7uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rB1EIxhsPSpBrA3cdZ6wzJBbukNCV4D08mBoezhIC6I=;
 b=YCgPMVTyoi47RCCF+IpPUZx276QOEyXutNmn8N7uWD+hEb2hj2WfD4D4ZWKvg8hMAYUPnaFMpMimW2MqKts3dCvytFpxLkiXJeOM8zr+4V5aVkTBs2/7rrax5FMv22sa1CmRKL3fcnCdQX24It1u43oVZhUlturguFMqGpiIGXM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/15] net/mlx5e: kTLS, Use kernel API to extract private offload context
Date:   Sat, 27 Jun 2020 14:17:19 -0700
Message-Id: <20200627211727.259569-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b234d36-848e-494e-a8a8-08d81adfb05c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134D5082F63238647EC1F31BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OT6HEDUqWpzywGRQVFWCfWTPw3sP6/CVmuyt4aXSM6hY9E3JGSmrXAyvlP8fb5+q+yYsMyV9dMz2aej5i6AxjuxHiK8QsDCIby0TZg3Uv8p8BIRj/0fqyYflAPn8Af0pnRkRQVlJYLrXsq0jreQC651PRI3vxZRHYZ+83HTZkQ6MOOUvQL9W1dBFHELLS2AZeQbaId8Nrfz2lYtYedvyZ6sz51uvP9gOmSlhMrmHqyAA6BoGOrOfcpUA4HvmADca1j9J5hMScf2Aw5EYnECVU5e80Ae7y/C6AQBsfXSLMTJUly6GnFd1r/cenf8adPyLc7JnuoDHqJye0xKxyV0FsOHeib1k1SUSCECele7zUS+fAPN/NKrXjk3zizWwRnIV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wqLtymf0vHgwH/ek7Aik5ezm67oN55BCYkKNv52irDfMDL9OSdJ9B6nMMTya3FKwo3MW69dLtTiOXeBD9knhhifJ3UFRnkYf6rnvD7In+fwm8ky4lTBjbmx4gOR3eSSr6jKw6mU+oW1ew2OnW2Kb7B3NDs23mEgsBumjxWN7iX5BsXnKlxPJtSXQ1vp+Lq6HXFykMfMB/6th5Pb2QtPU5uEdAovWFtjYFe+px1/MeqGYztCDErhaEuyJZwib3jlDx3B66dYMFK+nyz8Kc5Wb6ro1XzQfy2877KqWpAFX64ZaDie96didurq2e7k/8UWDUUJqxCjJcA9aZPKtGcbDeOBSEGpOiOA6zM1GJTbL4LpEAeTtsrk6YGukns0/YbRXonsHUDF3BkE4yYagBnmCUfamNpgjEPQdMj8Ty46WXwXP0vy9lKgH4eVb0BwCPNmHwWJSPTlbIlJhZvu2KIN/TCoFW0uvx0rvria6PQ2sgU8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b234d36-848e-494e-a8a8-08d81adfb05c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:51.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPhM46jugEWqMUMpwdsFfcyMAJUVdsIPiSotiyCgODbZuFHMcpesucuR6yPv20hkwvBS7exfMHOuiqYc7CF5Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Modify the implementation of the private kTLS TX HW offload context
getter and setter, so it uses the kernel API functions, instead of
a local shadow structure.
A single BUILD_BUG_ON check is sufficient, remove the duplicate.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 28 ++++++-------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 349e29214b92..5a980f93c326 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -56,37 +56,26 @@ struct mlx5e_ktls_offload_context_tx {
 	bool ctx_post_pending;
 };
 
-struct mlx5e_ktls_offload_context_tx_shadow {
-	struct tls_offload_context_tx         tx_ctx;
-	struct mlx5e_ktls_offload_context_tx *priv_tx;
-};
-
 static void
 mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
 			   struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+	struct mlx5e_ktls_offload_context_tx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_tx *) >
+		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
 
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
-
-	shadow->priv_tx = priv_tx;
-	priv_tx->tx_ctx = tx_ctx;
+	*ctx = priv_tx;
 }
 
 static struct mlx5e_ktls_offload_context_tx *
 mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 {
-	struct tls_offload_context_tx *tx_ctx = tls_offload_ctx_tx(tls_ctx);
-	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
-
-	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
-
-	shadow = (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+	struct mlx5e_ktls_offload_context_tx **ctx =
+		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	return shadow->priv_tx;
+	return *ctx;
 }
 
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
@@ -113,6 +102,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	priv_tx->tx_ctx = tls_offload_ctx_tx(tls_ctx);
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
 
-- 
2.26.2

