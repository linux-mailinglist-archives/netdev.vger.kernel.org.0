Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2125F222E13
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgGPVeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:31 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727825AbgGPVeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejBYcJvnGTcRA7Az1ZdSaNP3ow6RSai5R/VopVEPCDYdFtpMJfzW5eRiS2ItA3QsKRZLK0MsgQSWk1OXrv0L1daDsnwnD3GEPLksNPgEtG7B/XZDtVu68OKEgpZeIVZLtR5bo4/HcxOLpr5iTONTfqjn26v9EAq1zMDkygoxl2P85mGCRUnk2d7AHYSMfKXcOWVytAoDJrCzeIyyJRNEV73dULReceVkK9zCffGL2wmQ8aNa4E+r1Mh0jYIoQf0lSS3eIrxFmc01ogcAoiJBH8TP7WWkkG5304uHFcQFSJfG+a30cQIEawfF2WupprA3Jdnw0j8UVPXSmUb4D5VDtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzD4OMaAjDbyoApvCJI+q5KHIE5FfzAANgPBt5e6i5Q=;
 b=bmJsP0gPMhRaOD4wJS/3ImXBIS0B4vCynOetHIzYrFOHe2Udeyy8qsaStaP28ns1clKwZLDwjqlzOFxAidAeI4Hq19/cm5ckxK8ZCxnj36ut6tNqoszSKUcE71KnWI+YdZ9d4kLh+2RXpzL5Gy2Pk6PVR+5M3nKIqly6VJ8p59oMeIzg8ux9I3jhJDLFRQTexNapU9T4H8OjF6zu1cuTLFjHM4CZ5OdHNPKW/y+cL/iDjcWGgjaysqbM9HBAcQSrBBc6gEp04yQyPZ0GFIDY9xd7AJSgaJB0c6qyJCm+NQsPrAB/ixdLYOE+8Coe5bbcJU9bWDUOgexat67o4xOBfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzD4OMaAjDbyoApvCJI+q5KHIE5FfzAANgPBt5e6i5Q=;
 b=tEb0OYDc23pNArHen3G/pIff8+aRTlfk+sH5zje93VNth9ojI/VRPRnfiViqJ5/R56rGzSKJg5GYH8VzNXXdo6YdofkyHFPtbsAjmHMlLQ2VdcJ93jOY8fezR/RUvOrM5n5LHKZWPRVL28BUpmuufwbKBaS/CUaKEyrMBL0Iiz0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5e: XDP, Avoid indirect call in TX flow
Date:   Thu, 16 Jul 2020 14:33:18 -0700
Message-Id: <20200716213321.29468-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9eb5e8aa-0955-4996-5985-08d829cff8f5
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992524CBDB9C6CAE986275ABE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ypPVTJgVwv7TRr6q/cQhZGYOA6+wNLtu76JelnLv9zh5R+Hbix568hp/mABKxDYikMEkyLfOwS/i1o4Ktfis+q16K4GBnjFI4d1u3cZqdx8ajdjTZfKr1j88f5vyaomVJrkvSAcm5YhmxPlr7g1xS9qSN99AqnjNp3BtviFoFClmVVgEOMWw47pLNQI0TFk1f1LB7A0YmM2ghs2rjeOT5vRQ+Z/Boh7rDhy/M6kYS58H69KxefoGzg1utBE23zSGfCs+sb/gLlybr0EI2KApStvT5OlZCDPcYC2Gc5KB0GqkaD2ymEEusCSdAwK0ypW2PZWJRYdL8nV0WI6NxidJ4dRvAiUpq3ZZ8H+SRNSqoxWHpcoxeHGoSA40+geR3elo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XFTVJfUKKxSyR38DQccYikCTfO1mODSWbK2C9zxUQtoNFBQsFbebsu4zNIj1kT9fC8iiXjAZDSQrk9Z1sRSC8Ks2af1DoD9WXSFiBZnLU37VKFrC8oVMsH9jxz8SPYrS9/jkL7S7y35AxnZsrtkmMktVtAjR0m+Nh13uTSd9Uk2w2TYHX+AXzrDcqMeSVkO2eetNEla54v2v+LcCXnLBNEC9a7jAuhp41wK9mHh1r82dqMnf27cvOwHAx8tA1LSSQASa8YTwpPGnKNhaeNmJcWm3B5tAD8THAxeLV+ZeVfpD0G9Y+UUd0g6N7kCP3JeFStkdjhrZJFoSAty8GaRMV0FkEIRH3l6sZLRKqlr+0NYQpuSUINFuIDwCwBUzMsqevSXW9xKkXAGH8mY32d+Poezz3f5+HVMbyNojQCNrHgxUFoVp3FYSxoSfOqgQCcZBUGZeeuIcjKd9Yf97x8z2R03F4I7DUHS+LTQ/4u3VGLM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb5e8aa-0955-4996-5985-08d829cff8f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:08.6821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgACK5Am2A31l4jvEdeJG/eU785t8m+C+PUtmBzhtPnAmU9QEhGx14eMSAQmsUh2nG4y0wUNZgA5W5tSXXmRZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
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
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 36 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 22 ++++++++++--
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c9d308e919655..3514208111555 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -34,6 +34,7 @@
 #include <net/xdp_sock_drv.h>
 #include "en/xdp.h"
 #include "en/params.h"
+#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 {
@@ -55,6 +56,15 @@ int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 	return MLX5E_HW2SW_MTU(params, SKB_MAX_HEAD(hr));
 }
 
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
+							  struct mlx5e_xdp_xmit_data *xdptxd,
+							  struct mlx5e_xdp_info *xdpi,
+							  int check_result));
+INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
+						    struct mlx5e_xdp_xmit_data *xdptxd,
+						    struct mlx5e_xdp_info *xdpi,
+						    int check_result));
+
 static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		    struct mlx5e_dma_info *di, struct xdp_buff *xdp)
@@ -114,7 +124,8 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdpi.page.di    = *di;
 	}
 
-	return sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0);
+	return INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+			       mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
 }
 
 /* returns true if packet was consumed by xdp */
@@ -237,7 +248,7 @@ enum {
 	MLX5E_XDP_CHECK_START_MPWQE = 2,
 };
 
-static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
+INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!sq->mpwqe.wqe)) {
 		const u16 stop_room = mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
@@ -256,10 +267,9 @@ static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq)
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
@@ -293,7 +303,7 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 	return true;
 }
 
-static int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
+INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 {
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
 		/* SQ is full, ring doorbell */
@@ -305,10 +315,9 @@ static int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
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
@@ -506,6 +515,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		struct xdp_frame *xdpf = frames[i];
 		struct mlx5e_xdp_xmit_data xdptxd;
 		struct mlx5e_xdp_info xdpi;
+		bool ret;
 
 		xdptxd.data = xdpf->data;
 		xdptxd.len = xdpf->len;
@@ -522,7 +532,9 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, 0))) {
+		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
+		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
 			xdp_return_frame_rx_napi(xdpf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index e0b3c61af93ea..44f2d7bcf4bb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -6,6 +6,7 @@
 #include "en/xdp.h"
 #include "en/params.h"
 #include <net/xdp_sock_drv.h>
+#include <linux/indirect_call_wrapper.h>
 
 int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
@@ -64,6 +65,17 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 	sq->doorbell_cseg = &nopwqe->ctrl;
 }
 
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
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
 	struct xdp_umem *umem = sq->umem;
@@ -75,8 +87,12 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
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
@@ -98,7 +114,9 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 
 		xsk_buff_raw_dma_sync_for_device(umem, xdptxd.dma_addr, xdptxd.len);
 
-		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
+		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, check_result);
+		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
 
-- 
2.26.2

