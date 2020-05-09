Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4242F1CBF09
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgEII3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:50 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:50670
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBwXF7hqyXLAPmqKgOI0L9S2fJfbisvTRdwP5m3N2zUmv//2HnvCzdxw9mbOhcXroYcYf4+iobLUbfGWfVfnleYO8C8LwXdsc6uNGHDRDSEbFXSR9SXQJnkJWh7aIhD0+m0Snh27NLl72cy8FXWNDYe0G5bXwDtum4Vuzl5u6uGlzh5j5nrYMiil/C7B7IVb7Qv5izE15jFl4S1vEgEmkBjEhknJzuVmpweKC1l2a98F2uP+7J1O5B8u3IfvEwlBobEmMt0ND+6Bq8Ryg6Rg8csiYkh1Ak7jZJMzs3EFh+99G21ZTydQTbUiQYCEGlp5j8SSS9Z4x8ZeDf0lnIE/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZ3EcoqZthlSwDef1PHX+0aDWVerEISRQhj5pGWVYH0=;
 b=MsU4DGRC/gIvc+2DVKwBCYAs3i9CjyDWf3M+xGKutVBM7KirYaC1lOakqcxV0ZTO0R5gVQ0n+jR3M8IUK91SCmDn/22QOg9jxoUnPTVj9uSOw87uOM6Brvq4QPnVMrUoz3gtiQijIf/wX/tgCTk0cJywGMpYPQxxYMhXlhrPUHkWmTR5EjC42goCykyrcK2PDQx+CZaOhkoJtA0fKV7Ncs9R9dtczOZ9Exqg2JjTF01Db3HE4QFV7yD6XD43lbc638TONMCxGqY3KvkWus4EvNbepqAio3+43cNWjBEEBLbU+7DH5Di7gcEq1Nrb1SIS6rBTynzcN6c+2EDN4CdPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZ3EcoqZthlSwDef1PHX+0aDWVerEISRQhj5pGWVYH0=;
 b=hrj+wG5TwBIEsLRCNfRi3qZxLbbRmwvwKJ3b3eB2hhxSm8FpZXdMHbYEGbOJv3EoAQ3PSci9sqzb4Nn6GuWvd+3IsVU5LTeZBhlaeH6Ndfr9zVo7kHy/n5VqLC88Vi6WAYSZWI/QS0cqOKRUC2PlVcRZuOfuhprp7QkVr7GENb0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/13] net/mlx5e: Take TX WQE info structures out of general EN header
Date:   Sat,  9 May 2020 01:28:53 -0700
Message-Id: <20200509082856.97337-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:35 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ab2504c-9fdb-48c8-4a0c-08d7f3f31c21
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813E326649D42BE90778114BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qdQL6gPuWwEE2sbkgEbLPagzCjB99eiHC31kNvC2B3JMWzLTnDtau0YBAt1ZhQvp73T/VXbdBZTFrx+ws1HGreX8HfKosO8NY6atWB0/pyTb1h7npo4IYFICMh1gImxNxNYBp1vzr0GNQQsn9ZO8eVJo/r3SRAIgPw0IDn6MOXzo1liDxEfoCteIeWPfnPs7AzMmbdWSJUyTQ0ejOMUNaJ4eQjediS11WhWstFeu/jdDJmSK/UBdGtN58mCWovyapIFUAbEynpSeogMHKmpYv9jSpDFjjTDhprgpZl19S7WzCXibvCnIUMLFfgFcmwOrsmK+6vTgKNH/F98OzefkASYgojdziygG5q0na71p+ORNOnnbrBwoP9m6GnZ+MNhYmsENuBimFLZ3CC+AgblHbH1mczxvPSo9zVixLFA5edbwQow/eLTqglsXP337/a/wqAn9UgmeDjDxqjY4KytDKCB5zWkWs6RLNgui+8QbmoAV+vFLMDv0dECopAcr5vEfJxyj8497W3M//t6O/wC2f80/1KPtqMvs9QcmT0eJZ8YaXefeBbIpSeSPwEKP03/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6v2dUcfg3899o9agCSWt30uHmNe495zuA/WGWLQPYfcJ/9abHLSEw/q8b8UIXA5jpMUJ6fVURn6kvAIwWt73XCfFBXCj7GHmX4+ZX7BKPsvyVuFVdqyMpzSFiZmVmwfDhSwBx2UwvxVNUxD6giqDZ/9lhBpWGH+vhN1FM5Eu3HUpkeWyhF6d48/DXkTGFGdpAWn//ioi7ZuwfCkOgPuPBwXpp5Ob0rtIZKCWEV2P6QSLDzcr5204eAY9rLPWmuk95hi9oFInPprpGP4dcqKN+MaCyvr1qx33UrjFVkbQS3/NrpaVVjVRwgnxT9tcVs1k+539Q6VQ8mfUc6EioduD2ukynKMzHD+eLxqjpC42MScqzLST7RzfF1KZThMpetfSc9v48ywwlNT1kzhCwNYgYys81hoOZAhvBd+Z+Up9s58Srd2e0156oJIECgSi/IKCNZOyaZT92IhdjqNnwRzGVw1bApTrDpEICbQlXN+fMVE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab2504c-9fdb-48c8-4a0c-08d7f3f31c21
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:37.3878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjN6LY9shqXfsvklfmjHwRUGI+DirO/5mu/zwh2Wh+At9/JQgPRuO1fDi2LuZOGhRRtQ6F9I9UJDBTXuP2gyUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Into the txrx header file.
The mlx5e_sq_wqe_info structure describes WQE info for the ICOSQ,
rename it to better reflect this.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 27 -------------------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 22 +++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  5 ++++
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index da7fe6aafeed..3bd64c63865b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -339,16 +339,6 @@ struct mlx5e_cq_decomp {
 	u16                        wqe_counter;
 } ____cacheline_aligned_in_smp;
 
-struct mlx5e_tx_wqe_info {
-	struct sk_buff *skb;
-	u32 num_bytes;
-	u8  num_wqebbs;
-	u8  num_dma;
-#ifdef CONFIG_MLX5_EN_TLS
-	struct page *resync_dump_frag_page;
-#endif
-};
-
 enum mlx5e_dma_map_type {
 	MLX5E_DMA_MAP_SINGLE,
 	MLX5E_DMA_MAP_PAGE
@@ -370,18 +360,6 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
-struct mlx5e_icosq_wqe_info {
-	u8  opcode;
-	u8 num_wqebbs;
-
-	/* Auxiliary data for different opcodes. */
-	union {
-		struct {
-			struct mlx5e_rq *rq;
-		} umr;
-	};
-};
-
 struct mlx5e_txqsq {
 	/* data path */
 
@@ -484,11 +462,6 @@ struct mlx5e_xdp_info_fifo {
 	u32 mask;
 };
 
-struct mlx5e_xdp_wqe_info {
-	u8 num_wqebbs;
-	u8 num_pkts;
-};
-
 struct mlx5e_xdp_mpwqe {
 	/* Current MPWQE session */
 	struct mlx5e_tx_wqe *wqe;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 89fe65593c16..9e150d160cde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -81,6 +81,16 @@ mlx5e_post_nop_fence(struct mlx5_wq_cyc *wq, u32 sqn, u16 *pc)
 	return wqe;
 }
 
+struct mlx5e_tx_wqe_info {
+	struct sk_buff *skb;
+	u32 num_bytes;
+	u8 num_wqebbs;
+	u8 num_dma;
+#ifdef CONFIG_MLX5_EN_TLS
+	struct page *resync_dump_frag_page;
+#endif
+};
+
 static inline u16 mlx5e_txqsq_get_next_pi(struct mlx5e_txqsq *sq, u16 size)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
@@ -109,6 +119,18 @@ static inline u16 mlx5e_txqsq_get_next_pi(struct mlx5e_txqsq *sq, u16 size)
 	return pi;
 }
 
+struct mlx5e_icosq_wqe_info {
+	u8 opcode;
+	u8 num_wqebbs;
+
+	/* Auxiliary data for different opcodes. */
+	union {
+		struct {
+			struct mlx5e_rq *rq;
+		} umr;
+	};
+};
+
 static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index ed6f045febeb..e2e01f064c1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -137,6 +137,11 @@ mlx5e_xdp_no_room_for_inline_pkt(struct mlx5e_xdp_mpwqe *session)
 	       session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT > MLX5E_XDP_MPW_MAX_NUM_DS;
 }
 
+struct mlx5e_xdp_wqe_info {
+	u8 num_wqebbs;
+	u8 num_pkts;
+};
+
 static inline void
 mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 			 struct mlx5e_xdp_xmit_data *xdptxd,
-- 
2.25.4

