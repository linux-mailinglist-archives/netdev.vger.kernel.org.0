Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471F42306C6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgG1JpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:08 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgG1JpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPORv3A611MrtdYEr5ZFBuMgG9ZcFQwzL/X9A2ay7AMkAuTQ6lFumC814iaIEhhfb/kY3FhmLz6MeoLfzJZxzzbnZlN/mFGOEYX5EAQaBduYZyxceFjMq+PlkJ90HReP5w0ndDzfgy32gei6hr4hB8EinHBsJnCECvTU3iVjIIw9nTmdYdpo6I+GCb9DVTHrS4HbRc8BXfFH3NuS+RNghZViv3hqCqaWKO/GPf3rm4erx+3N5ktgQXm24pmGEk7dGLSYCGQSrrXeufnKlOg1JqMcA4ToSFGB5jz7IDZEr2LD4JfBHQPlxVm2CLaggUBMejaBWNAAQsP175EZ0pDymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8whGShSGJau/JSYV5cKz3Pq+Ao1TS+2GHOKVJQeYZuQ=;
 b=ERHTzebQQjTYS0ewxcRnTS3r+opIP3nuLaSWyAy166i6C3anXarMDAhsPH4J36SYvd4qmYRoD/SsmEdM9wUbINWjMg5RIknAu0jmmzEPanT9P+IMDR03ii/rEDazwx6E/h1p6cijmnZg+DQJqZJFK3FqhBS4NgAu5BpH3Y4qgpy/fomssmcVSoXDZ6hnhcD30KbJ+l8Mnf7EYkviUS8yMYkhQkcaPL0HjIazAwbnBT5fChkX5MfiF0qXYMd0EwaVUum98hlu6gxMJ0/5As6s4wOTVrkuWCuOQQr2hT5HHwi8kuVrP67PPzpFwUMhxbyDbDpKvSIBPYfEq3fnlX+cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8whGShSGJau/JSYV5cKz3Pq+Ao1TS+2GHOKVJQeYZuQ=;
 b=B+G5Pi8rdRBLBwwENyOpnRiMMICae58HWpLV1ZTurRRU7Rc+NGDjIh+8m2OntDcq8Wx0qN3dbNBhs0y6BeSjq0ak29q0FbCPdu0hxgwH+G3KRbXFmAVsMtVObJ2OO0SjScPzDN4guZZWhfaC5A3Wbl4x368jm7gyU9T5Gi2XIuQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/13] net/mlx5e: Move exposure of datapath function to txrx header
Date:   Tue, 28 Jul 2020 02:44:06 -0700
Message-Id: <20200728094411.116386-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c3bbca35-a7d7-4e1e-d307-08d832dae0e5
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71170E773387586102CC1B68BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP0gajKTfRRGPk8NDgHGdhD1nAUJcV5iLMxQIBzhWnBTps0/l8GCA8QwemTt/WOkv7PiiOzJDm7SiXLUXJnPTZR2MTVBlIkcvQu7E07NR6IEwcHPV0hzhk9BNffrNobtntX40aMFzpK/btdtgv5BEsp08PA6APSMk5qoZTEGxQcmXHzWkW95mTfuuN6f8E1As93rn5+DkNEKp54yOYqefkMZcMpZeMynrFKS/IgwFmYnNFCfGALtRaeR6emrXyrZY2/hAkiwQZJMYQPf3pRTLPB+b6nJ00RnkxlpnXCAzvovwO9yZw89SpLcUtChdZMx8dSBZUv6moiafjT8k8ybQvELIX300QfAFKLXBFpWv5LHun1Bcf3Jhq5TY9zl9Kc0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t2GRzC/4JxuBSjN4pkxhv0jTYWpudvxPC/g4X5ln0ne35aaeaqqXD46QquIH7zCuNWm752Km8kqFc5ePFEbpG+LlQXFqaww3Dt4wdvzITREOfqum2zXIfnUp0JH5eviSIriFSxxiu2OMGaMImKq4rLSI0wCX6hDiCF6C9ghjJ1++y5AUWyAv3oeN4zZCWG03wGZT4SmxFfPXx1ZpfuXWFnW+rF6xqNlku7oS53ErWNMs7tdW7v1NXD1asA4djwexKX6aZCjIg2RROV+NyuLGSfuCtG1zyJRgySOwnCn8X4i52MweApxTfeKfRqy4Wa5dreI5esttF/JMzu/H4XsRv8EOAjQkBrySq8VRs0qDCPyvGOB+ZrCIJaXw+hYw7uMsYzmILsKezL2lg9R80TPy8K6dNIz5O7NqKOm8+I+6r+VLD/Aco8JyjXTa0MTCXM9HSYUbWKC0+Zpd5rPr4BdgBq1we9MdfPq8G9GFmpd+xVE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bbca35-a7d7-4e1e-d307-08d832dae0e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:53.2518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2b9+CHwiyZpo8VVn5uIlO4xNVfemFKoq+KgnYGV3ud/Sohn8FRUVZX2fx5BU/vNlfrmGX//Q8i5ZD1uYs6wBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Move them from the generic header file "en.h", to the
datapath header file "txrx.h".

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 23 ----------------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 27 +++++++++++++++++++
 .../mellanox/mlx5/core/en/xsk/setup.c         |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  1 +
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 878714f949a55..0fb30fe93207b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -844,31 +844,10 @@ struct mlx5e_profile {
 
 void mlx5e_build_ptys2ethtool_map(void);
 
-u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
-		       struct net_device *sb_dev);
-netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
-void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
-
-void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
-void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
-void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
-int mlx5e_napi_poll(struct napi_struct *napi, int budget);
-bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
-int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
-void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
-
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
 
-void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
-void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
-				struct mlx5e_dma_info *dma_info,
-				bool recycle);
-bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
-int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
-bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
 void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s);
 
@@ -971,8 +950,6 @@ void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
-void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
-void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
 void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index cf425a60cddcf..b25e4ec752281 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -18,6 +18,33 @@ enum mlx5e_icosq_wqe_type {
 #endif
 };
 
+/* General */
+void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
+void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
+void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
+int mlx5e_napi_poll(struct napi_struct *napi, int budget);
+int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
+
+/* RX */
+void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
+void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
+				struct mlx5e_dma_info *dma_info,
+				bool recycle);
+bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
+bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
+int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
+void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
+void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
+
+/* TX */
+u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
+		       struct net_device *sb_dev);
+netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
+void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
+bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
+void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index cc46414773b50..dd9df519d383b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -3,6 +3,7 @@
 
 #include "setup.h"
 #include "en/params.h"
+#include "en/txrx.h"
 
 /* It matches XDP_UMEM_MIN_CHUNK_SIZE, but as this constant is private and may
  * change unexpectedly, and mlx5e has a minimum valid stride size for striding
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ea6b99b8bcd83..111477086f66e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -42,6 +42,7 @@
 #include "esw/chains.h"
 #include "en.h"
 #include "en_rep.h"
+#include "en/txrx.h"
 #include "en_tc.h"
 #include "en/rep/tc.h"
 #include "en/rep/neigh.h"
-- 
2.26.2

