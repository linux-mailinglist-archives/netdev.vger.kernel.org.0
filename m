Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2B222FA4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgGQAEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:52 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgGQAEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhf0iAKT9qCBEf+rpbjKcIa/bpwfrpsw3LigKqrhsPHMHH5OSm055+C7hakyOLG4RjXrjvQpy84ldLisc3Piz2Dy6i3i+we46vUKYNJarudaaMdVxS1Mv1wpLt5v+q7uz2R1Py3hIpxrPTEAeYdCNIyz+YPgkKsqj1vdrTNLteHePHE7gEpA0SAnuN3CPk5qM4lVLI7jU9nIAF7O53xCaeRExKq0bKoeLIH42U2cPBTfJ0taq/OphgWgdR9Gd//d0my1CJ0oMVyK/08g9cw+ovA5a4NRxSas9aQ46TVz+oUtHKZelrDj4QI55a/3y2ISxyU0X8Kr21gRLYU5BfZD+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE6guOee59Z7tHrCtTM4iyJSwAtQNLHN9Oi24VlBEw=;
 b=MFhR2jK7jejGK7GrPZ9WZDkQQFGiAPzoV4mR9MvTL0Xc5Og0SddBGCsYXevGXETvsQgLjAv+nTC6U1wAPN+UUxeGUDzgYOjztqclPmx5VeesGfBcN6MQy0vrhumlg2UREnEBTmX6xPQVseAdZBElbSODoNL1mnvzvSn4ubhJP8Kz6qoeW6UTWTyzGUSxGST4jPhCvvOPkV3l3oIxeMAWuN2IPb1OYlomT1Zxe2xA5de7CcQqjsPWB0Z41fMBBMQOpQa2KsH3+eVq/CM5zs79BBj3hY/GVHxc04efX5OdMmqFfQQre2tPKL0j4e5mTz8DC+8zaiqt9RexoO1A1dtSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhE6guOee59Z7tHrCtTM4iyJSwAtQNLHN9Oi24VlBEw=;
 b=JUjbHoAhohlybbfCKTdQKP4LFGO1KMu36m8wfbRzclOX/uaHWy11niWrxfdoOe/JLsKSb/haP6Hajb3A4xcAeH27379gz0PiFFpe9CKtEO7Nq7MUjChpcNOWfn8EhDpWmAtsxWiBJbqEepfftF3JtnIqGQBILYV8vKJonP5tdS8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [net-next V2 02/15] net/mlx5e: Fix build break when CONFIG_XPS is not set
Date:   Thu, 16 Jul 2020 17:03:57 -0700
Message-Id: <20200717000410.55600-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:33 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b487d646-0f14-4cf4-b0b4-08d829e4fd19
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244882CAAB3C68B8506B2E99BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0kneuX9HPazLpeg8cBSQjBl9prxGWryQDNKK/gVKkzCzr5CLOd+vJZLnSrkmK07Dk9QLLea09umtGeAdH6/RXC0NyytsFjsi+9bvs6locAFrYMhxUDTT5SRESQ/XifACm23yR2G7W8UJmCCjHyzZP9IRtr7BYFmOJ1pyPcWxgeRk4EIDzXOfABKUP2XFqwhAmWURzQv+4oJxDOEg/ibEWyztgMxAM9Ac3R4Rauyg7l+rv2SSI8fT/DjUnsZVEArxY/LxrpJ4DsH3UW8dWX3xLPVNhZg2RuKxWe0B4L2P4+kfncWWNwy4y3szVJUIYDhws/PbTJJbS52hAId+bTZW9vBgtDgVTs5ENDmk1QxxhKtaQJXwhBsDPQDTD+qVGwT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HCc+0yAyT7hw6aGLrt31x6E9mpMhGvfpzinsc3X/FyTqWmtV6OCbKSptrmf3xgjFe6hqraWqn0kMg2X85qscRp0ZUIDgr/3v+qGeehJnF5C/GkZErJyqkXO109dN5H0ZIzM+HwxbRaosP3mn0X6QK3tGR8dVEDRAB6FlO8D8GlzW8BEI75J3ybiUnSue2n+4ugspMOBprw+Dn7PQLHRu+6pp+R4aCEJsfA7ePoI/t6i5wL0wR5IuOUgqEJZXqc2aVA44irvzOUrnmPDifpt8XRkoSeFzS7CT7qt1Hg4Cm4EOsWm0WRKobYh0M3swCgAZv5iBh0O9f/9LiPWamZTIG5AEd82s8F96F/6W4oCjTCh01m2EYMNMyNKKqc/EviDMglJ+xaSL/JPDvQo4Y+cSiqd6+bfKmmEM1JFqXtoB0ejvESNDxmSlt2DI3Fq+p1Ug8QK/R07vwACI4jbPfcE/GmHsaUHVpqqII3ZQb//AN/w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b487d646-0f14-4cf4-b0b4-08d829e4fd19
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:35.3663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FwNe65E2NcLKdRki+e3NVUZTFQObv4bXuRJAFLBQWtp7Fi2npBfI/+sQwg70SkhlcCpSWg7fBQ4Lnxa1fiQlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

