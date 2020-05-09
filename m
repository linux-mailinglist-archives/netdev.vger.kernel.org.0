Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710721CBF02
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgEII3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:33 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+BsfMY0qPCCg5oAsJCiYS+uc4Oj6h9xHloyGjooKOkhqY3VeZ+QniALMGmZ4Z9W8WAFQWueLWOebIm0r0cP9jItA9HQvzueyoQ1Il/Sx/ArAbyijSYDfvejxfZCiLn3E6nnCXqrXaseHJt+iNoPTjmAfn99FsJ6p4dAvfhC5V3ak9XPNZUAWV/rFwCrSXLx4+k2a/F9WFgHuaTzSDhsLMRb6UkvWluZ1iWOtWTEcdhvjtFHCFAlZHdrAt4xPRRNc6Mkun+y68c5Gb7ETFQAOidAw0211NBrFw0Upp8kmes3e0NaF/NVQUdbQsPcntXL6P6FLO6xpgjyNufFEm1baQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwPiomMFRulA2QKTtq1qF06+56N+waWlHY6yRWjaxIs=;
 b=RWorv7hrLnWYULjjyXYsZDbuv+xYqetDkblNPe2O4984Cy3szUyU3DYugWurCXR+6McjMYPngnBr9OfaFdr9izGVasa7DszSq0vsgN40Nr+suGg+lnQqNocY3NOfV4Ndw3QP6kl/SIBg0Fv+kbJgmF/0MeXTJioHtzjVsK5uOblPfkEoWoez/Deh3JIAg9MZadMQ3l6UEb9j3JIRBY2BoXFe8JjWcsWXjMbYUR+TaZqd2y0FtOUWjsPQgj4j5RsUxyv7H1SuNQ1sJpRZPILJBCkvutyanx+UfdBGu+sCcb7JUQRYr7ILhltYACVCvpDnbWoVRS1XVjoKhQqPUPpvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwPiomMFRulA2QKTtq1qF06+56N+waWlHY6yRWjaxIs=;
 b=SPHM8TdPmAUG8aeIQu9iYeJTJ+64yzr0TBncezPa892mRs/wgie841jy/RHnNLDLBJRZTuJfHObMcgdUtSVOMrZulqRAxATbkknuY4MHYeP5fm+2GTOAktWJ4J8O2f5HALbKcjlnzs7jE0r2GAJVMmp+/LoSX/uYV6fB1ipKhgk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/13] net/mlx5e: Pass only eseg to IPSEC offload
Date:   Sat,  9 May 2020 01:28:47 -0700
Message-Id: <20200509082856.97337-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:21 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f98b5fd4-332f-4b94-1b34-08d7f3f31412
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB48135C6D8D778FCCEBF60441BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FK2H7Ap6n1KPe4RrGkNar5WTwCp9x8sYktmS3puooQLfCgsX7lVm0aq+oTISVCnUGpGR61d1gvbvKQjAcjG34q5FCoV11GfoSzAbutXcVmRCg77hX8aIeFxfain5WE3qlKmq3v0x/Klg71pBi6QpFQQ4h4xswdsvs/UnHxcMQnF7sUMc0uPcYapN9k1dvHAfCBYpmhSqq6INqvhjMd8FvbDPllTjcD5bqinNTUu95omnMfNYAzI7wMg76TKOH20PGxIJb0bk3VbMnBAu8c3Mz1Mg0g5rNs9S1k3a05NaUCacLYqNf3Jf71k5Hmt+KrOvQg5NF5pi1e5BmM5xP2O9HN83hn3XOW0zALWla7+0GdrAwe3gy7JTW3/KLX+/LxEcp7N+tg+AK723Tgyznmz3XipezBxNsFuSGpZmNFLWV9SR6B70UKyhjNwufW7jnTueqmtyWO7vCaGQZMCysi765k7+bY6NEoqsEQeRF/gkB2jR98JK7NuhFp6XDuxF0R9uAqMQkNwVlBNXfePAEMZtlztoTqxC1S3gadcfyxQaQrc5b6zLQXb5yOM1K6QHqsbI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(4326008)(6512007)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(54906003)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UX4VyisNcLfS1z3rOc7EA3w4tYnCpb/U7vpC2KtD3uhfJJDcestX9wf3+LWsFjdyT6Ihu8rTKg4rpW55y88cTdhg03rpS6fOSR/iUOuwEBSJXkQg7p/hLflalBN0Wv9CTS9F5dwbYb+YWmLwnnfna4qUhotdRZF7HDGZbUsGTN7RrQSQs0V0cJfgES78SxvfCWcwdoNwGOFU3hs/ZUrIgtDOnlKxm0de4wLkgwzW6MqXPlBSirSWEHDBvYBxkm3zlg3qxBB4QmoJ10s3i994+VazbeuyoGVbznsHpH40mn0c7tzBohtD8fBRqrDnQaKoCOcKetMy26Ir1kPHCk5fvfa6MLg+p+x2Kdv9myDeccFtjWUFn8CQehyvRLdB9cikV0R8bBiDzP0peNXsJDWP2V2WGPttch3sSc3kTcT7htF3XCevaUEpvSwxhz0kW5XvQMuQFTqE18iRHStdMqNj2KFLSo4t1JzZKR5Yh6wgR1k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f98b5fd4-332f-4b94-1b34-08d7f3f31412
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:23.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGWAoeXfmDIoDV9sB4fTY5gVrLpt0KV99tGbFzqzJeGU10nl96gdKyY/tN7b7dCN4kd/xc5QFHX2WgXkKVsYtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

IPSEC offload needs to modify the eseg of the WQE that is being filled,
but it receives a pointer to the whole WQE. To make the contract
stricter, pass only the pointer to the eseg of that WQE. This commit is
preparation for the following refactoring of offloads in the TX path and
for the MPWQE support.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 6249998444c0..c658c8556863 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -117,7 +117,7 @@ static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state)) {
-		if (unlikely(!mlx5e_ipsec_handle_tx_skb(dev, *wqe, skb)))
+		if (unlikely(!mlx5e_ipsec_handle_tx_skb(dev, &(*wqe)->eth, skb)))
 			return false;
 	}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index f60eb6a4b57c..0e1ac3e68c72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -234,7 +234,7 @@ static void mlx5e_ipsec_set_metadata(struct sk_buff *skb,
 }
 
 bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
-			       struct mlx5e_tx_wqe *wqe,
+			       struct mlx5_wqe_eth_seg *eseg,
 			       struct sk_buff *skb)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -276,7 +276,7 @@ bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
 		atomic64_inc(&priv->ipsec->sw_stats.ipsec_tx_drop_metadata);
 		goto drop;
 	}
-	mlx5e_ipsec_set_swp(skb, &wqe->eth, x->props.mode, xo);
+	mlx5e_ipsec_set_swp(skb, eseg, x->props.mode, xo);
 	sa_entry = (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 	sa_entry->set_iv_op(skb, x, xo);
 	mlx5e_ipsec_set_metadata(skb, mdata, xo);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 64e948cc3dc5..bd6f32aee8d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -53,7 +53,7 @@ void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
 void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 			struct xfrm_offload *xo);
 bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
-			       struct mlx5e_tx_wqe *wqe,
+			       struct mlx5_wqe_eth_seg *eseg,
 			       struct sk_buff *skb);
 
 #endif /* CONFIG_MLX5_EN_IPSEC */
-- 
2.25.4

