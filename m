Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8145222FAF
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGQAFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:14 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbgGQAFL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhUguT5v3idUSbPGVx/QgXAdgrBaTqhqgTnQPrbGdglieWa4e0+l6u2i7pnBDAMgSjTX2tMhEyMWgc8wOWADTOc2/515ufPrtRVr98Xj7WCt5jlUro7/wIyaTtlbD05AogKCnVftvchuryOed1FZsJ+ODbhW6rcUsXuEWqgr5H04goXT9p5twlh/XoPmYSMX6tYBdEt1iQQ1RQtAK8XUx9vvDnxboCkXtQJY5rgPllUWgWl2YyfNFs1n8PZ7UWF3rNsq7eDG+gLaN7WAbQAUxmcDL1nCwvLz/poVhnT6yBi2idVh8lvc1RszLV8ZZh8mInDTPMfYDoHOPslqVhbSwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNk6m0cT8X1Tw/0CtlbZQuhT5fZJamTVODbVuYwumK8=;
 b=AJF4UIDcOzQB5UiVaAPTyGEzsoyuR9Xk+y7VGmkeWCSY5jV8FqNfNGJU+70DH8ea7H3YBexTV1Cl1inDmHSg21RefP2TJgCZPKyOl8m1yo2flcvCbk8wsDaAdBFXXWpq4F4X+lOgpDlVQZUOdKWHIxCxd7mCUcCSdOfD9UxHDm3G53kYV0VD6mzHwlG+HOo37hyksLwL8WUgW7xAVKrhhRtYvUxeUdABPrGyTvOUftynsbA5DMT+b/wAoobwRnzs4wO+B/wVyKde/4EPHezadeCEJFGtT3xB1V4DRq9bEx6DRe3usSbUbLfLI5xOmQGThJfWJQ/SkuxGHZ/Q6Ngd9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNk6m0cT8X1Tw/0CtlbZQuhT5fZJamTVODbVuYwumK8=;
 b=pBQPuaIPmsHyx3kqFkkSNQI8hguxeubtnN7qlXKHE4gSJSRIMb9J2P8/Lyts8m3NLSPv1PbvbfL2hledMtw6U+LFlD9+yefEMgn3b7hrT3x7VDTXs7BEDKLfTrOkLTfLhoh+1tHY44OYukf6CEqGoSXk1KxK8Xa9SyTwN7CRJHI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 12/15] net/mlx5e: XDP, Avoid indirect call in TX flow
Date:   Thu, 16 Jul 2020 17:04:07 -0700
Message-Id: <20200717000410.55600-13-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad850b45-f2c1-4df8-a2f1-08d829e50b9f
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244889A2363F66C45D615516BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NqSQg0nohdFWDpFykPDviDH2x9el+TTD52VzijciIaQz+nT83XTqaSGbVNMhmAFxfoHYBuxHz+/vy0WOFmXDRmqPEdBfKuqHm5jSJPf2AKCCDgEr74oNNQIyon3cbg2nzOfnVU3COa32wWmYSp4XhsJDm2ZuwAZc2ZcoSCVOqhb7Kl0FSdd4nWr72HtzniS4JZB41lbrzIeFgOvYaQwx1GMR+fZuSAqGTJPIXeX6VUmykAU+8vgWAEs1wNGvrBXERPC5Lb4SKc5Vqu6cCbLG4+X9B784lK+Rd4kFWYqqGtVB+ugReUhG/6kLRKk1TwKcW2X6ZeVBA8DTipwLg452njL8y0hM/NMlP7QhbYqLa0wrmMaryQrOXcxYlpKrDWT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rsUyj8cERu24PHGMnoPWcnFe3ewOrr+UcvwcF7WztcWk75ylXjxY+k6JJYkLnXaZtqFypppra/hx20YNaAvpd3K1unTceHUZEibkepnu+KcnLdKwe1SyegU6ekJ/wdbsH7tjya+aZGKcUq4CyHDsaFKhYjPvEUUhMkN8w+ay0WEOHbACR4502UqfjXyRDaYw5FYDmM2zKPrm7J/GJagtUYhn6VqGY5b2yAW1qBLEUp3JBXk8+4SSsdv6hZf+ya/49gRD4uaL7taePN0mnUluLBH5kvjelB7vG/Z+hKY6FSJFcwY791245m/jW5QLCMPliVMCMRTYF2ywbkNB9R9g6UZqNCIRiC83584HrGwlGBBo5lgoKqEOc4xKztBSKBRHnjVfGP7+/EqdYFfLa35enSkAUyTAVyGCeTnldENHAe6B7zApJrDyAVbEpN3Fna3tGavtt7mRfILiwSft441bUChh+cHUv6QXaDX78tvDFsQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad850b45-f2c1-4df8-a2f1-08d829e50b9f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:59.3995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJ4ctN5o6cKtj+qPtK790j7cHOQowO8ARrNUdPoExMQJv/Q51H2XkPBPpiEsF1KNQIVxFyal+BgKJ75HVtfPXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 27 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 13 +++++++++
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 11 ++++++--
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c9d308e919655..e0c1b010d41ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -34,6 +34,7 @@
 #include <net/xdp_sock_drv.h>
 #include "en/xdp.h"
 #include "en/params.h"
+#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 {
@@ -114,7 +115,8 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdpi.page.di    = *di;
 	}
 
-	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0);
+	return INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+			       mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
 }
 
 /* returns true if packet was consumed by xdp */
@@ -237,7 +239,7 @@ enum {
 	MLX5E_XDP_CHECK_START_MPWQE = 2,
 };
 
-static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
+INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!sq->mpwqe.wqe)) {
 		const u16 stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
@@ -256,10 +258,9 @@ static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
 	return MLX5E_XDP_CHECK_OK;
 }
 
-static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
-				       struct mlx5e_xdp_xmit_data *xdptxd,
-				       struct mlx5e_xdp_info *xdpi,
-				       int check_result)
+INDIRECT_CALLABLE_SCOPE bool
+mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *xdptxd,
+			   struct mlx5e_xdp_info *xdpi, int check_result)
 {
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
@@ -293,7 +294,7 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 	return true;
 }
 
-static int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
+INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
 		/* SQ is full, ring doorbell */
@@ -305,10 +306,9 @@ static int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 	return MLX5E_XDP_CHECK_OK;
 }
 
-static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
-				 struct mlx5e_xdp_xmit_data *xdptxd,
-				 struct mlx5e_xdp_info *xdpi,
-				 int check_result)
+INDIRECT_CALLABLE_SCOPE bool
+mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *xdptxd,
+		     struct mlx5e_xdp_info *xdpi, int check_result)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
 	u16                       pi   = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -506,6 +506,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		struct xdp_frame *xdpf = frames[i];
 		struct mlx5e_xdp_xmit_data xdptxd;
 		struct mlx5e_xdp_info xdpi;
+		bool ret;
 
 		xdptxd.data = xdpf->data;
 		xdptxd.len = xdpf->len;
@@ -522,7 +523,9 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0))) {
+		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
+		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
 			xdp_return_frame_rx_napi(xdpf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index ca48c293151be..e806c13d491f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -32,6 +32,8 @@
 #ifndef __MLX5_EN_XDP_H__
 #define __MLX5_EN_XDP_H__
 
+#include <linux/indirect_call_wrapper.h>
+
 #include "en.h"
 #include "en/txrx.h"
 
@@ -70,6 +72,17 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		   u32 flags);
 
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
+							  struct mlx5e_xdp_xmit_data *xdptxd,
+							  struct mlx5e_xdp_info *xdpi,
+							  int check_result));
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
+						    struct mlx5e_xdp_xmit_data *xdptxd,
+						    struct mlx5e_xdp_info *xdpi,
+						    int check_result));
+INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
+INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
+
 static inline void mlx5e_xdp_tx_enable(struct mlx5e_priv *priv)
 {
 	set_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index e0b3c61af93ea..0dfbc96e952ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -6,6 +6,7 @@
 #include "en/xdp.h"
 #include "en/params.h"
 #include <net/xdp_sock_drv.h>
+#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
@@ -75,8 +76,12 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 	xdpi.mode = MLX5E_XDP_XMIT_MODE_XSK;
 
 	for (; budget; budget--) {
-		int check_result = sq->xmit_xdp_frame_check(sq);
+		int check_result = INDIRECT_CALL_2(sq->xmit_xdp_frame_check,
+						   mlx5e_xmit_xdp_frame_check_mpwqe,
+						   mlx5e_xmit_xdp_frame_check,
+						   sq);
 		struct xdp_desc desc;
+		bool ret;
 
 		if (unlikely(check_result < 0)) {
 			work_done = false;
@@ -98,7 +103,9 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 
 		xsk_buff_raw_dma_sync_for_device(umem, xdptxd.dma_addr, xdptxd.len);
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
+		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, check_result);
+		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
 
-- 
2.26.2

