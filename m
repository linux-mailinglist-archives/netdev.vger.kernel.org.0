Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C92CFE26
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLETT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:19:56 -0500
Received: from mail-am6eur05on2131.outbound.protection.outlook.com ([40.107.22.131]:50144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726844AbgLETTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCwVAZpH8c9/3XcXK/MOExudjPWaIVua3NSc4pIkREdJh+vcepCIOf0XD8ITm9/AjbaPwjlVYUB//S1uuePOihJu0fzPtP7fP9rcQd5QI6rXWmFznTrz7BhgwKoqiwdQVlaZWn9Lvi63snc5/feK4mozPW68QWfC1fSW45a3bYWzdZNh+ONho4lio8GyjvGvsdiwHU/bRtmxW7Oq0mvLRTv8eby2pLCM2Ugs2nHR5k3qYndoLevm5i/ZwpVV/Mz5Ta9FNZqKwl+QpFCCVCnGZqlJ/uqVEVbtPmOiCmnSiThCguJ/A1oBhSmVY3157p7UhrUBBgvNOCYyNN1q6DGZvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs6Iobd6zG0ese85pCR5UGUVx2YUPlvL4Jf5TP29EBw=;
 b=kjKHD8kvG/Tjm+6P+WFqB220LQZOsHByLb5Upqu4StJiykFz0d5VKjJuzhruJc+OA1+qVMNupemnd6tKrC+YUQzuX+p2Nqond8HQFbaYkV7YKPUgTxLHSuPLqjc74bpUAMakFc9Gxf9xWEY6RiUHa67bD+xtnziJwiCO2dek3WFvxyqipHFIH3MHKq52CT+lFbza8XXIWSasKOqRcD0QyKUR0XXZu1p3VGaA2+3VzHkauoHlpnJMn+EmVA/s5QY1MD+S6J0+lZYpcnaikM+A10lOHI8DrayEmKp4DlGmdPmVOeuiaaGQpdr6orFKB6/4iJpDI8y5nbqhA2nRgaZVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vs6Iobd6zG0ese85pCR5UGUVx2YUPlvL4Jf5TP29EBw=;
 b=hbutE9c11u9wBeLYp8HAc7Tyoh3UXuIogd8nfI2cwsBtHPlc7KfwL0SeHg4kgYGAQOFIympJoXSAH4N/KGwfJFu3jb2wC5aDyhbX5gaNxfppe6bivGUKUeGp5LhmIhNtAbbF2hohvg0P8pK9hoPt72Pz/rbVnllocjZb89pX8Es=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:23 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:23 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] ethernet: ucc_geth: remove unnecessary memset_io() calls
Date:   Sat,  5 Dec 2020 20:17:31 +0100
Message-Id: <20201205191744.7847-9-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19777769-7581-40f2-d1f2-08d8995288f2
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363FF1FA3596AEB0323EE2993F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vsUegi6BdTlfiZSfzJt+Hru0EZuUb9OapjgzK9K7AG+gXUswqPrqYq3yHrxYTHZqPT/CcDtjiBO70NsEl54hdd+nUeh353H1Puu4jPAnHfz9un9rOSgTwNydv+rYKRtqC5iAxu1iyQb41572ItyT/8lSHsHm3LJEW9LNDzR50XYbalGfYL+66X7IDTcbDaRY1EBJMI2SZkvWYyLEAET2qA05iN63Tx9rqfn3YhqqtaYnxR5ezRYjIUkVdgChmDg/x3XSN63/PoKj5O8scQXVyYkTS00rIB0pc4us3gVNk+83Bf1+bJ6yzQ1Y2KSF3dNbWnIKdX+nncBhav6kKDNgtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FPoZ/Ctj+WFdrP2iLkP/b3CPFTbcV9ye8UKyXjaWXsgRXSHmuG0a1LTKWALP?=
 =?us-ascii?Q?EL2VXo842Z5dl8IONKwTguhPWspKWdcH61zNRzpQfBdlfnUox0ZYoIsF50Jb?=
 =?us-ascii?Q?C9oFlYAcWH8Se6opS90O445kPzVF8WIEgAR5a3iqfHLK6lM9lgH6loxErxmb?=
 =?us-ascii?Q?Ly9x0CpVGP/+yfUKDxHaKvXxEuEjWq82qFJfgvoRQllMNV19s14eh+ezXh+f?=
 =?us-ascii?Q?vPTn/iMyNBGeEp+6Ts4Iv72yvh4ZmTj6TSLEeFUvQPpMpYOAEx506V+/+zE9?=
 =?us-ascii?Q?her8AC3VdMQhkEJa4FHRnvKfGtRP06s86LtWt1YEFW0OBaKrfBybMhw7ehh5?=
 =?us-ascii?Q?9Y7WoiVxMFb+4bf2AH37aamRibVFPAhQ55WAhiq6BwnfJ4pv4q8DPW+Tx+uU?=
 =?us-ascii?Q?jICLiyg7Ask/IcB3Ml4+/L6mQLHC8lTULvGzhyc3cLOKP0kREvhNGf5YbjSB?=
 =?us-ascii?Q?LrEJks2od8djDHhBjYoxR41kFuBUaW3QyuHUA4Eov7KDMH3isc/TQ6u9qAcI?=
 =?us-ascii?Q?69yPoVRhE65TPjfwmsm8JE6Vh/NbNPqhEljcimEZnIf0p0t85K/9fdGHg2Z+?=
 =?us-ascii?Q?hwJK7mgtTg7CuzgReJebgkLM5EI36Eh6OkpeOZjaqbuhK+4uO4XoDo32Ex14?=
 =?us-ascii?Q?K2CrQo/mR2Oo1sl8Jv2xU+b0rGgkOpZwqVei+/pzZVezFA+6jX4gFUaP+WPf?=
 =?us-ascii?Q?GnwJ8H/IK4QZjVFTqSu+bYJhLMR0Ts3i3KaE4B233bD2ickiccCeHDNSebgN?=
 =?us-ascii?Q?q3+YbvyH4XetsuJm7g9zjtwzaHbfH47NMR1pWiPgC6+2MzHz1l+yUxKFCsiG?=
 =?us-ascii?Q?wIoUZUPr68JIWivMWI48ZtNWNXX0oLO9oHN5elyn0s0p5XjAF2ZTvxvjTYZu?=
 =?us-ascii?Q?GYu7ukvgQcxboJfxt7ppHueB5FP09FLUSSVdc7vp3fJt2fBjvLPopgAj+1fk?=
 =?us-ascii?Q?/tX+V+r/5z9yKuMBkbi8JYxU0Lu5BoLPxhBiJUgyKqvFAv1vE3yApCXRxmg1?=
 =?us-ascii?Q?6yBr?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 19777769-7581-40f2-d1f2-08d8995288f2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:23.8087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T81CapYUjLLSCJ1lDzBgzk3hWHk1/abf+erAT5jeuj4mrH5knuagDoodTN9ytoTrBwHttwKzGGJEE7yzovO96AL9mXAGSiRw+bmYDZYFuo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These buffers have all just been handed out from qe_muram_alloc(), aka
cpm_muram_alloc(), and the helper cpm_muram_alloc_common() already
does

        memset_io(cpm_muram_addr(start), 0, size);

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index bbcdb77be9a8..f854ff90f238 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2506,9 +2506,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	ugeth->p_tx_glbl_pram =
 	    (struct ucc_geth_tx_global_pram __iomem *) qe_muram_addr(ugeth->
 							tx_glbl_pram_offset);
-	/* Zero out p_tx_glbl_pram */
-	memset_io((void __iomem *)ugeth->p_tx_glbl_pram, 0, sizeof(struct ucc_geth_tx_global_pram));
-
 	/* Fill global PRAM */
 
 	/* TQPTR */
@@ -2596,8 +2593,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 							   scheduler_offset);
 		out_be32(&ugeth->p_tx_glbl_pram->schedulerbasepointer,
 			 ugeth->scheduler_offset);
-		/* Zero out p_scheduler */
-		memset_io((void __iomem *)ugeth->p_scheduler, 0, sizeof(struct ucc_geth_scheduler));
 
 		/* Set values in scheduler */
 		out_be32(&ugeth->p_scheduler->mblinterval,
@@ -2640,9 +2635,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		ugeth->p_tx_fw_statistics_pram =
 		    (struct ucc_geth_tx_firmware_statistics_pram __iomem *)
 		    qe_muram_addr(ugeth->tx_fw_statistics_pram_offset);
-		/* Zero out p_tx_fw_statistics_pram */
-		memset_io((void __iomem *)ugeth->p_tx_fw_statistics_pram,
-		       0, sizeof(struct ucc_geth_tx_firmware_statistics_pram));
 	}
 
 	/* temoder */
@@ -2675,9 +2667,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	ugeth->p_rx_glbl_pram =
 	    (struct ucc_geth_rx_global_pram __iomem *) qe_muram_addr(ugeth->
 							rx_glbl_pram_offset);
-	/* Zero out p_rx_glbl_pram */
-	memset_io((void __iomem *)ugeth->p_rx_glbl_pram, 0, sizeof(struct ucc_geth_rx_global_pram));
-
 	/* Fill global PRAM */
 
 	/* RQPTR */
@@ -2715,9 +2704,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 		ugeth->p_rx_fw_statistics_pram =
 		    (struct ucc_geth_rx_firmware_statistics_pram __iomem *)
 		    qe_muram_addr(ugeth->rx_fw_statistics_pram_offset);
-		/* Zero out p_rx_fw_statistics_pram */
-		memset_io((void __iomem *)ugeth->p_rx_fw_statistics_pram, 0,
-		       sizeof(struct ucc_geth_rx_firmware_statistics_pram));
 	}
 
 	/* intCoalescingPtr */
@@ -2803,11 +2789,6 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	    (struct ucc_geth_rx_bd_queues_entry __iomem *) qe_muram_addr(ugeth->
 				    rx_bd_qs_tbl_offset);
 	out_be32(&ugeth->p_rx_glbl_pram->rbdqptr, ugeth->rx_bd_qs_tbl_offset);
-	/* Zero out p_rx_bd_qs_tbl */
-	memset_io((void __iomem *)ugeth->p_rx_bd_qs_tbl,
-	       0,
-	       ug_info->numQueuesRx * (sizeof(struct ucc_geth_rx_bd_queues_entry) +
-				       sizeof(struct ucc_geth_rx_prefetched_bds)));
 
 	/* Setup the table */
 	/* Assume BD rings are already established */
-- 
2.23.0

