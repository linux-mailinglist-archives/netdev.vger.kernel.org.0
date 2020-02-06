Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB4C154D9E
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBFU5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:50 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727526AbgBFU5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox4WhlRrIobelqRgPy47ik+mLZKC9+YIPohDGbpe3OS7Az5Ze1R8mZ3mJZEnHjKRV9ORzhU0lnhq14pH4qeznPbnbBsQ7kAchXoZG8j/wPcH6Xa4SdDL3UoaxB9vv2FyTY4++r2VsRHNjR8cFqWeoRgBOU12KTzC2d+GANFbtQqKhfqD39A6mdG0M7BBL8d0W25hM4IHEqxef3X9mKYMNGgarvwaaVSjO/5MgOZuOaWDklRyxsfEFA0Yj3mILuboKci5pfVKzcxnnOwIxFOVMgDuNRNiFl1Y6w+iihTDE+csXZTY7iDBNOGMPXmGbgjTUnyuivR+NRxQND9xJqaKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x71eZQRR50YT1Tp2otA48ig9oFbdCGPemdK7BYdDbY=;
 b=HkvOjNSX+hy9dvX2EUvzxTpUYMDn7ra/hu5wjuFzM5WZRuuOIBh/5Be/x3+Aqwg4pE5f3lezRTG8ip4jnNRc6aM0tkZyh3F7sQnhNTIRcBV0/apkmeS5BmCp+g3//Ak1EyyG91fIMKP/WW3J4kcs/JYgsc+EvnKbxYVxlTUvm1PKpsxAk7JRGZmhR0vQx3CChirWNZXrxoAQHgBTNJj1ZdAMeoiBRLEysLxkpZHE/E9pQxBj/icM26OiIdGuSrtwCEgb3LfrtHzZp6Z4Dihu/CzQk2FkBlwL9uVsMxPOVJS3gXZFwJsGalnX8POkW1SzKAieQkLrTh10pY12Ok4PiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x71eZQRR50YT1Tp2otA48ig9oFbdCGPemdK7BYdDbY=;
 b=H7pFDBVldTdq/DW/Y+TLYHcbQvld7Gd+Pm8E0X3Bm0X5BoImpJlsOHndG7OeIo7Y6Nq+J66Bo/lT9P5hgCZ2Ll5sYhhny6LlDNGXn29OxVzVrt46BAAubQfoEn7E68TrAb1bpQsVP2+Pa/XRuvqsxSt/55DosdUly3Iu+K4m53k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/5] net/mlx5e: TX, Error completion is for last WQE in batch
Date:   Thu,  6 Feb 2020 12:57:09 -0800
Message-Id: <20200206205710.26861-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:43 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 940c1b84-4ff0-4114-5d77-08d7ab4736c2
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3280617B97EC97C982C992F0BE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(54906003)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9W7Of0XsIdKQNO+xz3LCQjqZvJzZM9l5zIpI4H29NjwKAuhMFBGQCNQdw49+JECa70Udm+b3gxYg+LqcALzbRXKqVm3/J/UDRimq3zP9rImzDzOJIPJzoPSQTR7v9LQlsPoorufkcyTnLm5csto8HnOLSbfEKMYvDweVqVe6QY6nidoQ3K1SBXKOySAnP0QhbPGsyV6lKg/oAD8evlkXGqBlCb07cEpQb9Nh6Ie0Q1+X/fMiXXE5yGNV/gK/eV62jSihFZjFdQkZDQikYrinMLdCkgBFSlwyaXd2tci8Az9RWmtfS0/vBTFpFy+rAmDKPjqh3m9ExMB5KSf3tpSacwU2G/LogZ/uD9oCFqTVx9bhzhsehG7gx3D7piX/ya1IGRRoi6JBCQhicLQqmV9OiTD1xWxVXRgxVY98ZsKXfxIG9RFwqu6PL6STOW/Zp+4okzwuF18kq9468x7GJCcwtvkUCpZp7QT3qLDzmP+v6QULPOqEVYeNP0pJ0t+zd70su45jrFtRkY+OnTqqDZAM5Nyq/gGSyYe960bp+pdBmU=
X-MS-Exchange-AntiSpam-MessageData: 36cjYTslwyV4xlC1qXX3644JhDKIxdijaEyJiwvmFWZ3GObUORWBXBM6pjGVPVEaqbo0j8JfJi7S5S8lzrZsjAJz2x/YngAJkJ3B/VJOTaKsMVFXLUjR5uv8TTFOBk1nCB/EEVjGv9lc7YSNPicHcA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 940c1b84-4ff0-4114-5d77-08d7ab4736c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:44.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iC84PQQIMTXb0JNFAw/Fn8SKWLtZyanIRsr5AXQ++gTtMZgHCEQLZ+b5wHXeVASiDcUILOxg/9YNc/A9TcOwaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

For a cyclic work queue, when not requesting a completion per WQE,
a single CQE might indicate the completion of several WQEs.
However, in case some WQE in the batch causes an error, then an error
completion is issued, breaking the batch, and pointing to the offending
WQE in the wqe_counter field.

Hence, WQE-specific error CQE handling (like printing, breaking, etc...)
should be performed only for the last WQE in batch.

Fixes: 130c7b46c93d ("net/mlx5e: TX, Dump WQs wqe descriptors on CQE with error events")
Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 16 +++++----
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 33 ++++++++-----------
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9e9960146e5b..1c3ab69cbd96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -613,13 +613,6 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
-			netdev_WARN_ONCE(cq->channel->netdev,
-					 "Bad OP in ICOSQ CQE: 0x%x\n", get_cqe_opcode(cqe));
-			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
-				queue_work(cq->channel->priv->wq, &sq->recover_work);
-			break;
-		}
 		do {
 			struct mlx5e_sq_wqe_info *wi;
 			u16 ci;
@@ -629,6 +622,15 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.ico_wqe[ci];
 
+			if (last_wqe && unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
+				netdev_WARN_ONCE(cq->channel->netdev,
+						 "Bad OP in ICOSQ CQE: 0x%x\n",
+						 get_cqe_opcode(cqe));
+				if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
+					queue_work(cq->channel->priv->wq, &sq->recover_work);
+				break;
+			}
+
 			if (likely(wi->opcode == MLX5_OPCODE_UMR)) {
 				sqcc += MLX5E_UMR_WQEBBS;
 				wi->umr.rq->mpwqe.umr_completed++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2565ba8692d9..ee60383adc5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -451,34 +451,17 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 	i = 0;
 	do {
+		struct mlx5e_tx_wqe_info *wi;
 		u16 wqe_counter;
 		bool last_wqe;
+		u16 ci;
 
 		mlx5_cqwq_pop(&cq->wq);
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
-		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
-			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
-					      &sq->state)) {
-				struct mlx5e_tx_wqe_info *wi;
-				u16 ci;
-
-				ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
-				wi = &sq->db.wqe_info[ci];
-				mlx5e_dump_error_cqe(sq,
-						     (struct mlx5_err_cqe *)cqe);
-				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
-				queue_work(cq->channel->priv->wq,
-					   &sq->recover_work);
-			}
-			stats->cqe_err++;
-		}
-
 		do {
-			struct mlx5e_tx_wqe_info *wi;
 			struct sk_buff *skb;
-			u16 ci;
 			int j;
 
 			last_wqe = (sqcc == wqe_counter);
@@ -516,6 +499,18 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			napi_consume_skb(skb, napi_budget);
 		} while (!last_wqe);
 
+		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
+			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
+					      &sq->state)) {
+				mlx5e_dump_error_cqe(sq,
+						     (struct mlx5_err_cqe *)cqe);
+				mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
+				queue_work(cq->channel->priv->wq,
+					   &sq->recover_work);
+			}
+			stats->cqe_err++;
+		}
+
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	stats->cqes += i;
-- 
2.24.1

