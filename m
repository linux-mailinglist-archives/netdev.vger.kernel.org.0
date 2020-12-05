Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879922CFE30
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgLETUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:25 -0500
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:29825
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725923AbgLETUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6nesnBf+TsP/CLo2skr20/t55zRtD5RRtehK1nClyLXCWyP3uPglb7cjO6v/poXUqNdwN2M/XVrNPfn6LMfbhbGRignJUbkVSOIDgf2J3qFueQqmPgqNJC3vnp9B+nVTiHtp9FpIh1JS9tEok1p1m1WsetK/ixrmyhOBvwT+R5eX6Z4bDAiatzCvgHP51K94ALuHPVKlP4gPO/xRBZsooCBZDU2Rd5HjQv7u2Y3qgcWb69ZUjg8Z2L7+FsY4/aEPdxmuFsqsVj09KG9WDyiWNCq0F2korZE0quoflL/MAt8pdeDLmMzzz2gPs2GDpn+CsL5WCsShKeq/PEeoal/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqDmudZI8cCvX9sVGlUWP2+66rOjDwmqtiVJn2rC1Hs=;
 b=C37joQnzhWCZkwZM2IQfgFoG+RVuIyc22PFc6eHqjdGym2hZfBC9+s+1VrdWAP8j16scvlOLc70VwyyScU/iWctSsCoNbpEE9y2Rk8K+RqASeAvVk1n8jRp18oROoI5V9b9zlsr1hWUok0RlctHe45kjOPe3tv0oPsPLJG3nbpzHhlFwWEDlXXGa4plsFP3lp9USa3cbPpGa5mF4ntBI6iGY9PgKSTReayNL72oKg3UZr2yHoj3oiV+uHmiCIHk0kYC+WSZmBcX+8AhfuhFoU209fYXtzXM9mnEvtngUcAUTnKXWZs8VrEMnZKVAAsNZi3ZekhGva0R8OKrdRvHKWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqDmudZI8cCvX9sVGlUWP2+66rOjDwmqtiVJn2rC1Hs=;
 b=dRAFbCmFy5A+DWlrwPL3AI7d+N3SMc1KCW+MDuJVZufm/xIrfOjIFJXD3SLyCEL/0g/KNYA/VAkRv1pJ2kxcgC3QETtgYGQJRTtml9philMmuUKoTQa8m1026tICx2oxYLW5CJhINFjCrxI0SUv46+hFTF3k6lfdne12PBN/iwM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:25 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:25 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct ucc_geth_private
Date:   Sat,  5 Dec 2020 20:17:33 +0100
Message-Id: <20201205191744.7847-11-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83976c98-6732-4d67-1b52-08d8995289f2
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363E1A78DB3041C9AB6529D93F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCSvGooze2if/M5UctcnzBFutXb9lHYDe5hJtdCDnwz17PfuHiQPKPsBV44CJtZj5adLZYOExtM08ZuairlzVpsdbStyhqciRlJibR7bDbRqEQwTFVKSCj/LovCaQZ5ZcB4WhVW6RUP6qK0F9/LCAgPufE+5Vt72JiSlocLv2Dh/BkzUzVTnu1ac1uoQDCebqWCxnaMLgMWFJ6hZeJBj6xrycWjXtlSD8u990BYJdeOujoPuPpiWv1lYk36QRyKdPox9qgJrap0UEbi9c5E21Dep13rXSScz6MNWUdBmsvQ5t5mRm3i5FABJhjW4yXfbKaVszFigscTrz2X4oHomlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EWXewEIa/DMZOF32u8ZaqSJClcDu7AfGv/YQkMMyOO07qEhO3D/Ti4ih1PQw?=
 =?us-ascii?Q?DuA06VyIwH0Kn+OjRunWKhQ3kr8/fe5x4tF3QdSJHZqAloqvBtN4mmTjyfKW?=
 =?us-ascii?Q?kn4SfPODWtE2VlA2dEtA/Q/Omo9t99l+juGb4txJwzOyodcG1j4VPiMsbJjm?=
 =?us-ascii?Q?zb7C6ZogveybNvBSugNqFm3+Jn2cWkaq/jo4Jyl6MnlkEAXn/ovR5XTlQI1u?=
 =?us-ascii?Q?Zm3/3aoIhJkw1PWziAgASLLdu7EZ92C+saU/LnQcb++jseG5P3IssY/aEcPB?=
 =?us-ascii?Q?7OVZO7DgJy4RZ0b1UEzamzkEFHi9zmuiM3ZJlPMWBv5dkCoyBZY/T29gAw9q?=
 =?us-ascii?Q?r8tE8Sv6WwpNOCuKpAJMIN+clRUyonCCav0agWcwoGZIw5JaJYxU+LWBm2pz?=
 =?us-ascii?Q?PuuQZT8xz6tRqRdFNPIp/KF09evXykg+fGZFz9HTn5g1PxUKcnk6ZBF0N2OW?=
 =?us-ascii?Q?i6JcW7P1KSpJTZGuzZRX8/cz44onnIDa2OOQO4zgftDCUrKBzmSVL18sleiw?=
 =?us-ascii?Q?DwExTYlpolcqabVslGso8BFfTkUck/gJ6S2TawK74xeKF/rMQuMsQx6TaK6K?=
 =?us-ascii?Q?iTTo1fXJ5O4Plpg+t6TfBCdF2Ee0AVZRiM9i0pGVCZDNjOmN2U/EoH2NBDeW?=
 =?us-ascii?Q?x7YDDZt+ffrVbbH648z2DGpFRb02k33IzxZet6ioBSI17QMmcU5RyK1TKqpw?=
 =?us-ascii?Q?DXsTWFyZLGUvdS62RA/yZtpRPj82/KLWWpaiRIkGQTXKHVMR9Zb4TnLY6su/?=
 =?us-ascii?Q?JePZfPpvGBCRXEyI6pMQhJeJoHX5gb1VwvbGpZjtBoHzux9HMzxDpl/7hByU?=
 =?us-ascii?Q?hRE24qSy44ceqZAACF7W6zmvRR2UDFTOD4MBRARL3lfVdWcdutlmWZnfIXHA?=
 =?us-ascii?Q?g7oM/TuaRFKozXRUEf+ku7TY3DVeo73yLp6cKWTivQcs012cLKuWXf3a+hh+?=
 =?us-ascii?Q?8JbJFAAL79nRZ6TpuyGBoqoVML03wXufXdAvuCPudv1RmvRs8Fr7erkWIQGM?=
 =?us-ascii?Q?uO2Q?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 83976c98-6732-4d67-1b52-08d8995289f2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:25.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNWJzObnucmdRKfThmms9TqvUceSxvNg6riTFr+tC3N5o9QamItjlm7QIdhjpjZCxvOpeFO5WqQTTZt+bTo4g4CCa5+Jht17bfayT2G5jLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fields are only used within ucc_geth_startup(), so they might as
well be local variables in that function rather than being stashed in
struct ucc_geth_private.

Aside from making that struct a tiny bit smaller, it also shortens
some lines (getting rid of pointless casts while here), and fixes the
problems with using IS_ERR_VALUE() on a u32 as explained in commit
800cd6fb76f0 ("soc: fsl: qe: change return type of cpm_muram_alloc()
to s32").

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 21 +++++++++------------
 drivers/net/ethernet/freescale/ucc_geth.h |  2 --
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index e1574c14b7e5..b132fcfc7c17 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2351,6 +2351,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	u8 function_code = 0;
 	u8 __iomem *endOfRing;
 	u8 numThreadsRxNumerical, numThreadsTxNumerical;
+	s32 rx_glbl_pram_offset, tx_glbl_pram_offset;
 
 	ugeth_vdbg("%s: IN", __func__);
 	uccf = ugeth->uccf;
@@ -2495,17 +2496,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	 */
 	/* Tx global PRAM */
 	/* Allocate global tx parameter RAM page */
-	ugeth->tx_glbl_pram_offset =
+	tx_glbl_pram_offset =
 	    qe_muram_alloc(sizeof(struct ucc_geth_tx_global_pram),
 			   UCC_GETH_TX_GLOBAL_PRAM_ALIGNMENT);
-	if (IS_ERR_VALUE(ugeth->tx_glbl_pram_offset)) {
+	if (tx_glbl_pram_offset < 0) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate DPRAM memory for p_tx_glbl_pram\n");
 		return -ENOMEM;
 	}
-	ugeth->p_tx_glbl_pram =
-	    (struct ucc_geth_tx_global_pram __iomem *) qe_muram_addr(ugeth->
-							tx_glbl_pram_offset);
+	ugeth->p_tx_glbl_pram = qe_muram_addr(tx_glbl_pram_offset);
 	/* Fill global PRAM */
 
 	/* TQPTR */
@@ -2656,17 +2655,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 
 	/* Rx global PRAM */
 	/* Allocate global rx parameter RAM page */
-	ugeth->rx_glbl_pram_offset =
+	rx_glbl_pram_offset =
 	    qe_muram_alloc(sizeof(struct ucc_geth_rx_global_pram),
 			   UCC_GETH_RX_GLOBAL_PRAM_ALIGNMENT);
-	if (IS_ERR_VALUE(ugeth->rx_glbl_pram_offset)) {
+	if (rx_glbl_pram_offset < 0) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate DPRAM memory for p_rx_glbl_pram\n");
 		return -ENOMEM;
 	}
-	ugeth->p_rx_glbl_pram =
-	    (struct ucc_geth_rx_global_pram __iomem *) qe_muram_addr(ugeth->
-							rx_glbl_pram_offset);
+	ugeth->p_rx_glbl_pram = qe_muram_addr(rx_glbl_pram_offset);
 	/* Fill global PRAM */
 
 	/* RQPTR */
@@ -2928,7 +2925,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	    ((u32) ug_info->numThreadsTx) << ENET_INIT_PARAM_TGF_SHIFT;
 
 	ugeth->p_init_enet_param_shadow->rgftgfrxglobal |=
-	    ugeth->rx_glbl_pram_offset | ug_info->riscRx;
+	    rx_glbl_pram_offset | ug_info->riscRx;
 	if ((ug_info->largestexternallookupkeysize !=
 	     QE_FLTR_LARGEST_EXTERNAL_TABLE_LOOKUP_KEY_SIZE_NONE) &&
 	    (ug_info->largestexternallookupkeysize !=
@@ -2966,7 +2963,7 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	}
 
 	ugeth->p_init_enet_param_shadow->txglobal =
-	    ugeth->tx_glbl_pram_offset | ug_info->riscTx;
+	    tx_glbl_pram_offset | ug_info->riscTx;
 	if ((ret_val =
 	     fill_init_enet_entries(ugeth,
 				    &(ugeth->p_init_enet_param_shadow->
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index c80bed2c995c..be47fa8ced15 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -1166,9 +1166,7 @@ struct ucc_geth_private {
 	struct ucc_geth_exf_global_pram __iomem *p_exf_glbl_param;
 	u32 exf_glbl_param_offset;
 	struct ucc_geth_rx_global_pram __iomem *p_rx_glbl_pram;
-	u32 rx_glbl_pram_offset;
 	struct ucc_geth_tx_global_pram __iomem *p_tx_glbl_pram;
-	u32 tx_glbl_pram_offset;
 	struct ucc_geth_send_queue_mem_region __iomem *p_send_q_mem_reg;
 	u32 send_q_mem_reg_offset;
 	struct ucc_geth_thread_data_tx __iomem *p_thread_data_tx;
-- 
2.23.0

