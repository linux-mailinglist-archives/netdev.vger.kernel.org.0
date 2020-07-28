Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A082306C5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgG1JpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:02 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgG1JpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAeEpGlRFKeABpYLh9nC+t2AfrzKHvP4eM29Lt/hckougpl/tP+RU5Hg30P0r2WxzEDfkKHx9hnBeuDaggq2eReZqirPTasaQAwtbLu393FHGmxx+D53zs0kVvLDvE1fCN06eolAeElJmq5O3TUIi1RGWEZivZsYBw3AC2wVKunkturwxvfwnlPcXf+8za8za6pByWSkJ3qGMba1CKkK3J26/AYuqBZLjkrZx/tOaNM+bpRK5Qu1j4ClOeyqV/KdUfVn1xscfT1liJ2txnyUte+N2j2G1pB6c2VO3zrjj3zs3pTV9KWVUDV9fq47WXh0V3HY7DSF88iL8y8PDwU3nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYgQcV6sNF4fiQyTb65aLQeAHYEwWu/jHPfEyEqiYHA=;
 b=ccT2Ryd8C+geIWB6hUsJZwz+sT8oGdQGh2py9mBpqqFXLtaJ4RJM4BEKG6DkQt3AZX+8VyRbNrzNM40tBhLXtLDy/AIjL6u5uNL8xWrGWAxZLgMnvpyckScYGxhS7amdVCpvlzLf+ssTt4U+JdJhfgyE8lH+2Vb9i/pc+GT3JsX1ely3Ca71Af095yWQAmgTbqXdh2TfWhuWW0iTMkQjcdVI/jhN8lEBWlayOc0CiJqBTcrf4wSvku8jgkHPMTaWj5LYJrQ9MFJKF7XOQ1vTa+Xelnce282Sm9C4oAzNu8Sn8yJhLMJMqCp/Bb4UIsiSV0xrY1UWlVSaGBE3ZgwLbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYgQcV6sNF4fiQyTb65aLQeAHYEwWu/jHPfEyEqiYHA=;
 b=I5uSsPSubsCfl/oiTm1EPgtdYyjwtrZh6I5viLDkmw+3JrZaa56xU1tauvCRXjOdamN11a7wRN6OVzTAj4dIFhtw6i3uiClT7jd2djgJrzvg/MTBz7iay/1rg23zY1osz+arjCkViPybpiP8l43ZRWMpwOnvEPmdX6X7fHq8Q68=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/13] net/mlx5e: RX, Re-work initializaiton of RX function pointers
Date:   Tue, 28 Jul 2020 02:44:05 -0700
Message-Id: <20200728094411.116386-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:47 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5354336b-95cb-492e-bd47-08d832dadea5
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71172719CB7DCF76F5A6F3E2BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXSnR3ADEv7tx4GTm+Ed7LDR1rQe1x5lbVHeF3/Vdj8fPgIKkERtXw6sxjv3O8wmirft+An1YHwNEyjYJMvritxOUOdH8YtbjcUVCxF/3AlNvby0lD/c0GTxW0AGBXP0rCA2mhX4gRaAk4bsFNRB8BfVipT4MNTIc1I4b3+puoj0LjtTH6xmwOEmpevptFNPVl/rKGmKpnSWOOh35Z0Rb2ntzjUrIabRqhBWrQe7g0hcpwCLRCuSujKYjLBtuDrRKTj7D+alEWgAwwTB7blc16rk2OBZ2P8amSXafsIBNTUVnKKDgrmKenxrsDrFvGC3ljqGifH3NSt3W0DCqGwzsq/pnTrTJEVMdmei0hBpcCi/VJSj4JQNklcZQVh/K8gA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(30864003)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c3PTAYZBrLv5jRojxFGfNE3CUO/lIL/7GQUlmbFfhyvBJv8WTj5iXzYWkOp/JNlUIM7kX8glhnAqIZZy1ZQbe5fdsGiRHSbRf0ofN0X5KT4TpgJuOQBio6K93KW6qPR/8/ei3cxfM1hVFQqcbSq0ieyC6xlDH1Tgob+QuuH9LndEGcWrIom2Rso4NY7+f8mMHChQUrC9iUucDsgACg50QQcG2etYfPqMIRCj8VcLr73sFV/Nym8KzoNO/Y1YaXFWMJAsxLG0vX4ioVTqne658LPkC+m53VgSVn9xzvAZmaF/5Y6JjVHvBT+7UMk3g+D3DqWnRTrcM37jQQ6pPeRycON/xvmntE4unolS+VPZ65jPzlNfuA81TZl95MaOxDJeREyGOPZnCcMzITtN+jklRipc0VI8w+IVXKKVfui17ZsjLOc732jzo8q5KVX1GHmOzQQE4KszIRB+mlkuUm+dOoI+S8yfhUz5sLHuz/u66sc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5354336b-95cb-492e-bd47-08d832dadea5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:50.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcSULfhEMHVF0u9hNOsA2vKrxvi5CUjBPRcCKKk5BFMLe47tpPJzOHLJGNVixxkPZV/FfGbeG0iqoTe5pBK8sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Instead of exposing the RQ datapath handlers (from en_rx.c) so that
they are set in the control path (in en_main.c), wrap this logic
in a single function in en_rx.c and expose it alone.

Every profile will now have a pointer to the new mlx5e_rx_handlers
structure, instead of directly pointing to the previously-exposed
RQ handlers.

This significantly improves locality and modularity of the driver,
and allows many functions in en_rx.c to become static.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  31 ++----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  53 +--------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 103 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   3 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |   2 +-
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |   3 +-
 9 files changed, 112 insertions(+), 96 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c44669102626b..878714f949a55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -530,6 +530,8 @@ typedef struct sk_buff *
 typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *rq);
 typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
 
+int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool xsk);
+
 enum mlx5e_rq_flag {
 	MLX5E_RQ_FLAG_XDP_XMIT,
 	MLX5E_RQ_FLAG_XDP_REDIRECT,
@@ -812,6 +814,13 @@ struct mlx5e_priv {
 	struct mlx5e_scratchpad    scratchpad;
 };
 
+struct mlx5e_rx_handlers {
+	mlx5e_fp_handle_rx_cqe handle_rx_cqe;
+	mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
+};
+
+extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic;
+
 struct mlx5e_profile {
 	int	(*init)(struct mlx5_core_dev *mdev,
 			struct net_device *netdev,
@@ -828,10 +837,7 @@ struct mlx5e_profile {
 	void	(*update_carrier)(struct mlx5e_priv *priv);
 	unsigned int (*stats_grps_num)(struct mlx5e_priv *priv);
 	mlx5e_stats_grp_t *stats_grps;
-	struct {
-		mlx5e_fp_handle_rx_cqe handle_rx_cqe;
-		mlx5e_fp_handle_rx_cqe handle_rx_cqe_mpwqe;
-	} rx_handlers;
+	const struct mlx5e_rx_handlers *rx_handlers;
 	int	max_tc;
 	u8	rq_groups;
 };
@@ -860,26 +866,9 @@ void mlx5e_page_dma_unmap(struct mlx5e_rq *rq, struct mlx5e_dma_info *dma_info);
 void mlx5e_page_release_dynamic(struct mlx5e_rq *rq,
 				struct mlx5e_dma_info *dma_info,
 				bool recycle);
-void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
-void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq);
 int mlx5e_poll_ico_cq(struct mlx5e_cq *cq);
 bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq);
-void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix);
-void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix);
-struct sk_buff *
-mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
-				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
-struct sk_buff *
-mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
-				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
-struct sk_buff *
-mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			  struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt);
-struct sk_buff *
-mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt);
-
 void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 2a47673da5a4e..f96e786db158e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -47,7 +47,6 @@
 
 struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
 					  struct sk_buff *skb, u32 *cqe_bcnt);
-void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 
 void mlx5e_ipsec_inverse_table_init(void);
 bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9d5d8b28bcd81..ac91504be8e8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -45,7 +45,6 @@
 #include "en_tc.h"
 #include "en_rep.h"
 #include "en_accel/ipsec.h"
-#include "en_accel/ipsec_rxtx.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/tls.h"
 #include "accel/ipsec.h"
@@ -65,7 +64,6 @@
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
-#include "fpga/ipsec.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -428,29 +426,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		pool_size = MLX5_MPWRQ_PAGES_PER_WQE <<
 			mlx5e_mpwqe_get_log_rq_size(params, xsk);
 
-		rq->post_wqes = mlx5e_post_rx_mpwqes;
-		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
-
-		rq->handle_rx_cqe = c->priv->profile->rx_handlers.handle_rx_cqe_mpwqe;
-#ifdef CONFIG_MLX5_EN_IPSEC
-		if (MLX5_IPSEC_DEV(mdev)) {
-			err = -EINVAL;
-			netdev_err(c->netdev, "MPWQE RQ with IPSec offload not supported\n");
-			goto err_rq_wq_destroy;
-		}
-#endif
-		if (!rq->handle_rx_cqe) {
-			err = -EINVAL;
-			netdev_err(c->netdev, "RX handler of MPWQE RQ is not set, err %d\n", err);
-			goto err_rq_wq_destroy;
-		}
-
-		rq->mpwqe.skb_from_cqe_mpwrq = xsk ?
-			mlx5e_xsk_skb_from_cqe_mpwrq_linear :
-			mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ?
-				mlx5e_skb_from_cqe_mpwrq_linear :
-				mlx5e_skb_from_cqe_mpwrq_nonlinear;
-
 		rq->mpwqe.log_stride_sz = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
@@ -492,30 +467,13 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		if (err)
 			goto err_free;
 
-		rq->post_wqes = mlx5e_post_rx_wqes;
-		rq->dealloc_wqe = mlx5e_dealloc_rx_wqe;
-
-#ifdef CONFIG_MLX5_EN_IPSEC
-		if ((mlx5_fpga_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_DEVICE) &&
-		    c->priv->ipsec)
-			rq->handle_rx_cqe = mlx5e_ipsec_handle_rx_cqe;
-		else
-#endif
-			rq->handle_rx_cqe = c->priv->profile->rx_handlers.handle_rx_cqe;
-		if (!rq->handle_rx_cqe) {
-			err = -EINVAL;
-			netdev_err(c->netdev, "RX handler of RQ is not set, err %d\n", err);
-			goto err_free;
-		}
-
-		rq->wqe.skb_from_cqe = xsk ?
-			mlx5e_xsk_skb_from_cqe_linear :
-			mlx5e_rx_is_linear_skb(params, NULL) ?
-				mlx5e_skb_from_cqe_linear :
-				mlx5e_skb_from_cqe_nonlinear;
 		rq->mkey_be = c->mkey_be;
 	}
 
+	err = mlx5e_rq_set_handlers(rq, params, xsk);
+	if (err)
+		goto err_free;
+
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
@@ -5288,8 +5246,7 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.update_rx	   = mlx5e_update_nic_rx,
 	.update_stats	   = mlx5e_update_ndo_stats,
 	.update_carrier	   = mlx5e_update_carrier,
-	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.rx_handlers       = &mlx5e_rx_handlers_nic,
 	.max_tc		   = MLX5E_MAX_NUM_TC,
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps	   = mlx5e_nic_stats_grps,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a7a74748c9484..ea6b99b8bcd83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1143,8 +1143,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 	.enable		        = mlx5e_rep_enable,
 	.update_rx		= mlx5e_update_rep_rx,
 	.update_stats           = mlx5e_update_ndo_stats,
-	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
+	.rx_handlers            = &mlx5e_rx_handlers_rep,
 	.max_tc			= 1,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_rep_stats_grps,
@@ -1163,8 +1162,7 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.update_rx		= mlx5e_update_rep_rx,
 	.update_stats           = mlx5e_update_ndo_stats,
 	.update_carrier	        = mlx5e_update_carrier,
-	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
+	.rx_handlers            = &mlx5e_rx_handlers_rep,
 	.max_tc			= MLX5E_MAX_NUM_TC,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_ul_rep_stats_grps,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 1d56698014843..622c27ae4ac7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -41,6 +41,8 @@
 #include "lib/port_tun.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
+extern const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep;
+
 struct mlx5e_neigh_update_table {
 	struct rhashtable       neigh_ht;
 	/* Save the neigh hash entries in a list in addition to the hash table
@@ -223,10 +225,6 @@ bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
 void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
 
-void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
-void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
-				   struct mlx5_cqe64 *cqe);
-
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
 bool mlx5e_eswitch_vf_rep(struct net_device *netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 74860f3827b1a..9c0ef6e5da881 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -44,12 +44,29 @@
 #include "en_rep.h"
 #include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
+#include "accel/ipsec.h"
+#include "fpga/ipsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
 #include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
+#include "en/params.h"
+
+static struct sk_buff *
+mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
+static struct sk_buff *
+mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
+static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
+static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
+
+const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
+	.handle_rx_cqe       = mlx5e_handle_rx_cqe,
+	.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+};
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -370,7 +387,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 		mlx5e_put_rx_frag(rq, wi, recycle);
 }
 
-void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
+static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_wqe_frag_info *wi = get_frag(rq, ix);
 
@@ -537,7 +554,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	return err;
 }
 
-void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
+static void mlx5e_dealloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 {
 	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[ix];
 	/* Don't recycle, this function is called on rq/netdev close */
@@ -1106,7 +1123,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 	xdp->frame_sz = rq->buff.frame0_sz;
 }
 
-struct sk_buff *
+static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			  struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
@@ -1146,7 +1163,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	return skb;
 }
 
-struct sk_buff *
+static struct sk_buff *
 mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
@@ -1201,7 +1218,7 @@ static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	}
 }
 
-void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
@@ -1244,7 +1261,7 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 }
 
 #ifdef CONFIG_MLX5_ESWITCH
-void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct net_device *netdev = rq->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -1299,8 +1316,7 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5_wq_cyc_pop(wq);
 }
 
-void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
-				   struct mlx5_cqe64 *cqe)
+static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
 	u16 wqe_id         = be16_to_cpu(cqe->wqe_id);
@@ -1358,9 +1374,14 @@ void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 	mlx5e_free_rx_mpwqe(rq, wi, true);
 	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
 }
+
+const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
+	.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
+	.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
+};
 #endif
 
-struct sk_buff *
+static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
@@ -1406,7 +1427,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	return skb;
 }
 
-struct sk_buff *
+static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
@@ -1456,7 +1477,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	return skb;
 }
 
-void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
 	u16 wqe_id         = be16_to_cpu(cqe->wqe_id);
@@ -1652,7 +1673,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	stats->bytes += cqe_bcnt;
 }
 
-void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
@@ -1688,11 +1709,15 @@ void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5_wq_cyc_pop(wq);
 }
 
+const struct mlx5e_rx_handlers mlx5i_rx_handlers = {
+	.handle_rx_cqe       = mlx5i_handle_rx_cqe,
+	.handle_rx_cqe_mpwqe = NULL, /* Not supported */
+};
 #endif /* CONFIG_MLX5_CORE_IPOIB */
 
 #ifdef CONFIG_MLX5_EN_IPSEC
 
-void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+static void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
@@ -1729,3 +1754,55 @@ void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 }
 
 #endif /* CONFIG_MLX5_EN_IPSEC */
+
+int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool xsk)
+{
+	struct mlx5_core_dev *mdev = rq->mdev;
+	struct mlx5e_channel *c = rq->channel;
+
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		rq->mpwqe.skb_from_cqe_mpwrq = xsk ?
+			mlx5e_xsk_skb_from_cqe_mpwrq_linear :
+			mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ?
+				mlx5e_skb_from_cqe_mpwrq_linear :
+				mlx5e_skb_from_cqe_mpwrq_nonlinear;
+		rq->post_wqes = mlx5e_post_rx_mpwqes;
+		rq->dealloc_wqe = mlx5e_dealloc_rx_mpwqe;
+
+		rq->handle_rx_cqe = c->priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
+#ifdef CONFIG_MLX5_EN_IPSEC
+		if (MLX5_IPSEC_DEV(mdev)) {
+			netdev_err(c->netdev, "MPWQE RQ with IPSec offload not supported\n");
+			return -EINVAL;
+		}
+#endif
+		if (!rq->handle_rx_cqe) {
+			netdev_err(c->netdev, "RX handler of MPWQE RQ is not set\n");
+			return -EINVAL;
+		}
+		break;
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		rq->wqe.skb_from_cqe = xsk ?
+			mlx5e_xsk_skb_from_cqe_linear :
+			mlx5e_rx_is_linear_skb(params, NULL) ?
+				mlx5e_skb_from_cqe_linear :
+				mlx5e_skb_from_cqe_nonlinear;
+		rq->post_wqes = mlx5e_post_rx_wqes;
+		rq->dealloc_wqe = mlx5e_dealloc_rx_wqe;
+
+#ifdef CONFIG_MLX5_EN_IPSEC
+		if ((mlx5_fpga_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_DEVICE) &&
+		    c->priv->ipsec)
+			rq->handle_rx_cqe = mlx5e_ipsec_handle_rx_cqe;
+		else
+#endif
+			rq->handle_rx_cqe = c->priv->profile->rx_handlers->handle_rx_cqe;
+		if (!rq->handle_rx_cqe) {
+			netdev_err(c->netdev, "RX handler of RQ is not set\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 690b822c61524..5763965d5ef33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -464,8 +464,7 @@ static const struct mlx5e_profile mlx5i_nic_profile = {
 	.update_rx	   = mlx5i_update_nic_rx,
 	.update_stats	   = NULL, /* mlx5i_update_stats */
 	.update_carrier    = NULL, /* no HW update in IB link */
-	.rx_handlers.handle_rx_cqe       = mlx5i_handle_rx_cqe,
-	.rx_handlers.handle_rx_cqe_mpwqe = NULL, /* Not supported */
+	.rx_handlers       = &mlx5i_rx_handlers,
 	.max_tc		   = MLX5I_MAX_NUM_TC,
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps        = mlx5i_stats_grps,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index 79071a15c4ca7..b79dc1e28c418 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -42,6 +42,7 @@
 
 extern const struct ethtool_ops mlx5i_ethtool_ops;
 extern const struct ethtool_ops mlx5i_pkey_ethtool_ops;
+extern const struct mlx5e_rx_handlers mlx5i_rx_handlers;
 
 #define MLX5_IB_GRH_BYTES       40
 #define MLX5_IPOIB_ENCAP_LEN    4
@@ -117,7 +118,6 @@ struct mlx5i_tx_wqe {
 
 void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more);
-void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 
 #endif /* CONFIG_MLX5_CORE_IPOIB */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index f70367018862f..7163d9f6c4a6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -349,8 +349,7 @@ static const struct mlx5e_profile mlx5i_pkey_nic_profile = {
 	.disable	   = NULL,
 	.update_rx	   = mlx5i_update_nic_rx,
 	.update_stats	   = NULL,
-	.rx_handlers.handle_rx_cqe       = mlx5i_handle_rx_cqe,
-	.rx_handlers.handle_rx_cqe_mpwqe = NULL, /* Not supported */
+	.rx_handlers       = &mlx5i_rx_handlers,
 	.max_tc		   = MLX5I_MAX_NUM_TC,
 	.rq_groups	   = MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
-- 
2.26.2

