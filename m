Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D07222E08
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgGPVdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:33:52 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgGPVdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:33:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eP/kU3gUHbxzCpq/8MWot6hbnW5xRFbTQI8iKwcZNEfBc9BFfHdh7LIq0N5aw6cNOF/a/TO5AeudkzzkcZFTE36I2Z/rt9dLaNM2J3QHLLRZsl6VKpVkyR0PTj+SIptinhapp22cxMxAEZ8Kxi2CV7ZOheNl7bsxmKmnjZJYAAkhf4SzeSKJ2wLm3FhBGrw2c5pm1f03NmQqBD/QAIvFCp1sfJxM4+hmwala++VVde5+iVS2/WT/v50ABfpQKPimO4rTw13zY4dlvb1nb7jRkfOPqZQTgl8JJSs7uFacLic2yLeu6Lm/hy3scT8mZuNyUNyDdM/eUwyRn1UVMbKDYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE6guOee59Z7tHrCtTM4iyJSwAtQNLHN9Oi24VlBEw=;
 b=cy9pjdrzt56AeT+czTM4VoyGWmOWRfdoVNE2huU2WhBEEP+SKUmO6u37ZhqRNGYfCmG1AzCoX+AIz1UpXURwwvmGkGgCYFv2fs43MHfdVLSsuqCuHZRefbNnCwJDZotojhYv9fTOR7i1CQA0R15aAAfJGDHP2okDyyug47OVgmmA9nNGtF6eYc9BjQ7+fXfxeyytSPQnyv+FjNL12uHXBDugNGQxuhYu1Y+1D93lS6zTP+pSv27kqgKbcE5/DWibBztXY2PetlRpzLY7njVji0d1zGBrtiUu4c6Nu3kuWEzkZqMWH726XJtsSXXeTST6n/ev8XU5bzHlsuFMBka7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE6guOee59Z7tHrCtTM4iyJSwAtQNLHN9Oi24VlBEw=;
 b=NH3Am4zVkrnwqJseHyPn9Zrt17FF5S4It6Fm6SCaQwnz8YhNuMU8lQFLHv3+ztujsp2YQ+DcSyaGJiTOOeQAVHBUVz48AEc6QFF0IzmdU2dmq/fO7DPFnYVYXoAZKEloFL248KxrAe8K6TLgpOO/p5F/llzzCGrxouHR9cjMTMc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [net-next 02/15] net/mlx5e: Fix build break when CONFIG_XPS is not set
Date:   Thu, 16 Jul 2020 14:33:08 -0700
Message-Id: <20200716213321.29468-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eedf117f-99c9-4b1e-5584-08d829cfeb47
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992AD81685E49F49CE2EE29BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovOpaOBm//UEC2QgDqOx4qnjXrQ+xx7BHvk/ip0T/qhDfwP2TCDqENz26B7fl/aBj4Mj//LeBJNrgTlvokpVrlyssCnCLdIl1lkpXkdonP8hT4pxcOCAmXf8uk/BaB8I5Cs3VNCihoCbsjbxiUCcQ7sVi3xizkKawbSZX1qZOEE3SShbuSIe68lnu03QtXBq4w3mkx2mbl5lPBjbFCuK37s/qndQ7TSCNzOcURtAJc7nMiNy7DoMaTmko/GkuBQ/X7tuX4YVMaNgDFkO55ntQ9sUa+8fwNeNh6yhnYaHSaldTiL4QiSqI+qlkyfCgl/dFd1FjieilnZkUT7Abg6jxAwd1wOjK97zMxIgk0qzuN1b7unBedo+x3cYeZziIBqC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +D6JAReGlG94i/uhsBUkMXm8WCaIob3CEYYbcCHw5RhMnUEGuA2ZfKTP0OfDjll3qAHsKOqSA5lgKp6hotosx2npe/mM0mzMMlaaVUjwyxR0Uq90cP/S9KBroyPSML/bBm7ql2GkA9hSFbGlOKO9Fli5WTD6n/F9eu6T77YqLmXDzqIAwagQ6aag1Sw2GkUMwsyktvq6DI7LnzgSUHmf7AXgshVt0nbKYgQYGb8HACYq6wtwTrBnwxlhu5ycmGkqLZ4xjQZ+T9KPUSl2EwM2ChUBVjHiAIDLb+N/+UbcAZM4n7cFs/F92dGluvksEZMkCviJpi6prq3lYiOj/JpBnXdyZ82825jmQBg4QfZcBVdEQDvush3CVr6D2aAXyMSfB/6sBNfWlGtJ8Wj7udY5kciuhgCkBMwU64HLdF8gRvx4EZjklP71uHlB5QraP/tgFPUka2PCGw/GCT8KBNWXOEo2QdcJHOwjVEQCMEm/Rr8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eedf117f-99c9-4b1e-5584-08d829cfeb47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:45.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vsk8AL1cu3bfEIxqyHsvgXntjhfCvfLJzBV0nFBHnEZKs3VlP+33BS6fbn3Z2k/NG11GRSnrSY7h6F+MCXLKqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_accel_sk_get_rxq is only used in ktls_rx.c file which already
depends on XPS to be compiled, move it from the generic en_accel.h
header to be local in ktls_rx.c, to fix the below build break

In file included from
../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:49:0:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h:
In function ‘mlx5e_accel_sk_get_rxq’:
../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h:153:12:
error: implicit declaration of function ‘sk_rx_queue_get’ ...
  int rxq = sk_rx_queue_get(sk);
            ^~~~~~~~~~~~~~~

Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
---
 .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h  | 10 ----------
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c   | 12 +++++++++++-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 7b6abea850d44..110476bdeffbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -148,16 +148,6 @@ static inline bool mlx5e_accel_tx_finish(struct mlx5e_priv *priv,
 	return true;
 }
 
-static inline int mlx5e_accel_sk_get_rxq(struct sock *sk)
-{
-	int rxq = sk_rx_queue_get(sk);
-
-	if (unlikely(rxq == -1))
-		rxq = 0;
-
-	return rxq;
-}
-
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_rx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index d7215defd4036..acf6d80a6bb7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -547,6 +547,16 @@ void mlx5e_ktls_handle_ctx_completion(struct mlx5e_icosq_wqe_info *wi)
 	queue_work(rule->priv->tls->rx_wq, &rule->work);
 }
 
+static int mlx5e_ktls_sk_get_rxq(struct sock *sk)
+{
+	int rxq = sk_rx_queue_get(sk);
+
+	if (unlikely(rxq == -1))
+		rxq = 0;
+
+	return rxq;
+}
+
 int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info,
 		      u32 start_offload_tcp_sn)
@@ -573,7 +583,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	priv_rx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 
-	rxq = mlx5e_accel_sk_get_rxq(sk);
+	rxq = mlx5e_ktls_sk_get_rxq(sk);
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
 
-- 
2.26.2

