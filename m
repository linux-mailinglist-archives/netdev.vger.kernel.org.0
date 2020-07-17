Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546E4222FAE
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgGQAFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:10 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:40032
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgGQAFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFJ9+eWjxwAM6hWcB3tcB3Orn62ZJqv/AqbVIFsaTkLwvq8NpfN8JxYjk+1AnbmAHQCwx13fgLDv6VCwkHt2NG56sZCt68HNuY/5g//d7KKPDsiOcnk6gkp1zU3Eq5sP7udgapwKY81OzepaCm5dJldC7aoegdr8xIu2ZTl/DW/mdL8oBxTMOybD+EJ8/qdVp+J+SPvJM/VvxRz1tX0goo3DW7M8HipfAlJvXs9HDGONVR12Vsgqncns/8gtsUioRGQ5z6BUXrj251KVrpyjCtjQIALWE7EUjjLVRrhH9eVJ8U1LVRObIBul6vUBw+nXBwsGCcbhdX0Fy826PX95Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1VhY46Dg1ahQlXuYGKa0jcFizfKEfDlt5Z+hTRirYQ=;
 b=DWbEnmP0CQqWBZFfIzzOTqF4fl8ooDfPd4eSEI/ZZD0BVw3+sVnkONfMvGYJC7Lp1Ec1S4cakvz9tpx4JgpMfdxk1AJr5OS4oyyvIYqCiH/7ooABJLTsPMSBeYRXjon9LTZu2AIgwPcdDPK8jGVDu/VfI6WKEdU+MPGSNK7NX3G/YEVupG3qV7DksXjNtaZk0ajui8NNz00CJjYeEXwBcVxO+B2krRGDO/mcpzm7qEjLo0rqjh8gpfymScydIjJBP7c15WDyFTPOTxbnIiKzwJ97w+TnF04X9/yu4u0LtGhOhn/mOypKqDLuYS3PA6xqhY8qDDrGdjcVoqIxXf5WTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1VhY46Dg1ahQlXuYGKa0jcFizfKEfDlt5Z+hTRirYQ=;
 b=LsTixAh+IYlJvLNsdWL+z6OBHDlAkMwhoEHrQT5t/d2SPRVafz7pEE+XEX+6dF2Om9JsMD1ygsimTuM5mVp32F8/6Sf3Un8C8TysjjLwp4HZkRHK1YuJdiiopUfagihNMDCE37bZesTDI6U3NTzlIc8UfwXu8ORzPr+6Ylbo+1g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3710.eurprd05.prod.outlook.com (2603:10a6:803:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 17 Jul
 2020 00:05:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:05:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 13/15] net/mlx5e: RX, Avoid indirect call in representor CQE handling
Date:   Thu, 16 Jul 2020 17:04:08 -0700
Message-Id: <20200717000410.55600-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 07e72a5b-8266-46d5-5386-08d829e50ce2
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3710CA34A855A91D1E84C53EBE7C0@VI1PR0502MB3710.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzAOjH84QVa3QCPkkzYuWqUeVSAyOUbz5yhh1PzX7C9xG5A6pDJUwqz+n3BhTbzjJmUMc+PBK5hAJkcBOeHP1LBJenSbE3ZQr0XaoHiBT7vkMhhuthid9VGqu9sWMH0KR6pyCXM97FsBX6GEgNUwDoJ69Qld9KDTUnOvFvVZEGVRv3BFz0KexdlbQoQ1GQOnXj1afqMGnB6PsGU0P0Eqh6/SoWyfW6TojdDQLxzElffR8MuIIFejSGJOpPGPEinSvt16Ihzx01uLW049gCV6ccp7KzLFy/3ACouhCjXzvvnxsjilfl22AwLhC1BOoCFx09KCoA2Vqb6pcrbNHr6fQSVXKGAPp9tsDHbWsEfDCEZfpSUrybS8A4r4eJh5XJAo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(2616005)(316002)(6666004)(16526019)(956004)(2906002)(478600001)(8676002)(6506007)(186003)(26005)(36756003)(52116002)(5660300002)(6512007)(6486002)(83380400001)(4326008)(54906003)(1076003)(66946007)(66476007)(107886003)(86362001)(8936002)(66556008)(110136005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XOXCZNsalJsC/dQ4oKIvM+N1FdnhKKL9ab9wG8F7QbNYmpiz5z1BCyGGAlB9TDJRMBcXbfgsIDkLrtqFaaPOl1mmaCVonrkMl7ULVCPdpZkjMFYfRZ1q1niYZhZ3Ne9A+oUVJFuMPDwUlF2+nK3zOChpGEgDGg4N+KCmOY4qCYYSbKR3h2Il/saEEP1uL93ZAkvyQ/g0I7/IuiMyv+QzuREDzwopSkuZIN8MZe95m9cmKkO068U4ol40uVlQYnB9kLZg29rcGl+NdFJB9GEGTDR5Fmw/IwmTOv2FV7HUDvwbQQVfSfoT1W6DSSh2l0toIDOZQrcpk52tK8s43AEB/61y8QGxLXT3p+dQGWEPfSv7ZXSfwdlC4Viw+ToW//Ik0sRV1a+5HGCT4nPaf5cCODCt4imZY3iru0nleiOGX5KSRXw2Rj83KO2y/nwav74IANx5+DOC6FUgGerCa7iu+DQbF09yqbYMiew34du90lE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e72a5b-8266-46d5-5386-08d829e50ce2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:05:01.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oFUS4gULH7hJ9uL7RDsPyc7ykiMzRdJ8oeWi9l4x2/myt6TepL/B02SMWaEzFaGMSW7Q+djSYKCO7I0YbdpwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
when/if CONFIG_RETPOLINE=y.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8b24e44f860a8..74860f3827b1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1266,7 +1266,10 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 		goto free_wqe;
 	}
 
-	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
+	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+			      mlx5e_skb_from_cqe_linear,
+			      mlx5e_skb_from_cqe_nonlinear,
+			      rq, cqe, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-- 
2.26.2

