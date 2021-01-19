Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BB2FBB45
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391328AbhASPda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:33:30 -0500
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:58206
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390595AbhASPLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0d3avvlV0FEPVJRgB6OgyZEIBhOMq9Xs9oFZYVmE0sSd+UI2yGCxmCnr9q2cFT6fnZgQefZJ7VvJ+xCbefcHfKLF75p8Ue6fHlNMK4Q2p2+vC95m0mWrW9ohnmoNehNcFCaYq3g+qQzwQ12pL2Y3lX8ubkbT+av+IQQ452iGCC7GiPj3YO4eFkOzfz7b3xznCoZ50gMeBib+SyQfrY0EoM4NSfKaaJ7g01cTKeUsdVtrc0o2BK2d+w8LsYHqH5c/2l90Y3yV9GKjrZKeKm11XtmPhJmFyC4PP0bcPdPN+iydIvISioSWhWICZfzYFjPuXXdqXyDWLb+/2GC/9HfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2CQBAxmQlNRTwlqPcj1JbXeejuHyHBoraiQjO3Hg9E=;
 b=kWFS1YvyxTQBojpQteC7Tv8RT71weTZDTdmcsKERNEsniWiCAot5kCMSk6i49SLnvWH3BxjSzKZy/ZNXgSsicvVW+vj4BRX2gosErOhZlmAljwBVYsZRR0L6+WVYnhP48qTg6yhRooHEIzLdRAg5wSTHZyWGaaI50VRilPA61cV4Reot4M/xgKm0U/yAB0iipEKqacmHSz4XkDeVp1LlXG8M/u7g9Uxt9T+rTMD1XWbbhUom6F63imh6FgVD4RQ5cys18+Brzia4shoqqLHWHEQ2tz0jrxUr6yYyMNH3REg37O2SKVygP1U+GLbf3zH9YSQkNEvVu1eteuSBKljCtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2CQBAxmQlNRTwlqPcj1JbXeejuHyHBoraiQjO3Hg9E=;
 b=gMUrEiNKCHvbFyUHhD5Ry84iAbVhlWF9NFfeHZFtxIp8SVyel8T0f6b0xKMog6Yof1oPOPGbJE4tjbCXw+EreH7wrEJO9O/Tu+PoRaTe6A67BVbfp8QzwxygT0HJthzV8OKJJ4nndOO63ZyHRMTn8+w89Cp60KE5CfL8LmvTQwQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:06 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:06 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 05/17] ethernet: ucc_geth: use qe_muram_free_addr()
Date:   Tue, 19 Jan 2021 16:07:50 +0100
Message-Id: <20210119150802.19997-6-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d8f6dd4-4cb8-45de-bcb0-08d8bc8c29fb
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB19221DE0D467831724DF026293A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGzAg+cILYEqDqHii3WocJeAFWaFSzZULG+gfunM+IBkEjjoRR9PM5N/+KKarjc8Lrv3oxZkIYAfpTPi/4V+KzeC3XgpU3aG/NtvIVBYWPspXjr9dk4WDM4dzKInClmaQIMRonFgEU6d9maNEktlHmqNc6bLdcPojqi2DrGhzLabTVvjlLy095z2uKt3SkBPcBPm4SJZhBPggeWWLJtzqnMxddjknCk/1wcyUAffn13nAblo+mqL+f3/d/5F51b9WJYCs0L+NvVewj+AMrgZnsYHc5W4nE5m0KRhW0kzI2zFPIYddnoR8Cl8pG/QqMFtIwvZTowhMPapKGhnpBJllcxr1kdPiYX9ogyiV1kNQMXW2n1ptdUPDVtVHSiGZGA2g4l6qcPMPEKFoi5D09fb2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HoAN2Pvg2U0x8VZSjj/NhjuW0T6i8tEWs+a3ncZqjUwPgXPKp3AZRMtiyOT2?=
 =?us-ascii?Q?5cDWUEa4i6PrZXFdh8NqL22EJtebBoQOir9u5HjC85c66oRyIKw2wMpQGDrF?=
 =?us-ascii?Q?O6fl7dZ+TmRu6QDraD+7gSgWook7BNhixbpn77lClphrxl8LYfpqusHjxql2?=
 =?us-ascii?Q?UF4yvhSqYeHwwure7oPlmNV0j/rtxTyEnHPvcJk4EZRAK/V/Bwy9XEX8Qs9l?=
 =?us-ascii?Q?fEBCgjj276383+kqpcywhj/kNx7t4Btf219PTkoXW4IIe0GaSQsI9KfkG7au?=
 =?us-ascii?Q?xcNgX3ba13JAklBE5ox1g2ciRetzzw6jkBjVRQv78NIvDBbpMRuN+QjmwZqi?=
 =?us-ascii?Q?2F3SnwhM2WS7LDaG3wrJdRZqNHjpV1B47GdpESoKjRdFbycvHMbX5cpy7lDj?=
 =?us-ascii?Q?IHutPOjmpHq/aue8XAahVT4hQGCHW5SIIQRbrmDw6nUdrHjdDMadP6bLFzOB?=
 =?us-ascii?Q?XWWMMBmDQRgXHJlPe+iqyA89/+Z8dJ3+FNx4VbwpAQWkVnqclpZnAQvfyXw7?=
 =?us-ascii?Q?FA0bBjQyI/GyDvFoZqdybEdD0kuXpXsPAEaoqtCArxYJSdnK8HJuZxqka8Vl?=
 =?us-ascii?Q?JTXwrrGr1mewSkpt4P2D9mlPSeCGFS/4HiRH6bO4BlINOTKkFKQW31CGLvd1?=
 =?us-ascii?Q?a2o8gPrY0CAimeJy9PpfrvT/hoDVWCulW4Q6OqH/5nsZRWilsoNVRfhvH1DB?=
 =?us-ascii?Q?U8tCVtAjGmW4occ9TggPTMe/+1uOW+7h5UchwodkTthDC5OcO54n0DPfnJnL?=
 =?us-ascii?Q?LqopuugAdTM7BERH28zpTcw7LAOXcZxC8UwoJ0yQJpCp48b1Agtk1s5jtZXy?=
 =?us-ascii?Q?Q9JgLU9e+n0Z3Qu4UCk6oFQE9eiz12nmIjXDgaQNcADvKcOv8hdB67Ytk0bL?=
 =?us-ascii?Q?EPNnvbHCngc3MqN4GHsLzJGTuWJwCm2iNTNMhZ90q3fo2wq55S9EbGjRCkNc?=
 =?us-ascii?Q?Fqi7qoF8Qyily+QCSoZcr3PrMFMgrgPrI3DHUUl02TL1MLybeqpUF7Ug7GRf?=
 =?us-ascii?Q?Yjaa?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8f6dd4-4cb8-45de-bcb0-08d8bc8c29fb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:06.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/uVV+yb9jC+0a2mUE4JBHNm7N8DhDw3GrNQ0338oIrGctGNKFkqEyl35HQXmhq4YeRF32a1sE/eONFbllfE4DIW4uUDMD4/NaRQ1oymNxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the explicit NULL checks, and allows us to stop storing
at least some of the _offset values separately.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 77 ++++++++++-------------
 1 file changed, 33 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index d4b775870f4e..14c58667992e 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -1921,50 +1921,39 @@ static void ucc_geth_memclean(struct ucc_geth_private *ugeth)
 		ugeth->uccf = NULL;
 	}
 
-	if (ugeth->p_thread_data_tx) {
-		qe_muram_free(ugeth->thread_dat_tx_offset);
-		ugeth->p_thread_data_tx = NULL;
-	}
-	if (ugeth->p_thread_data_rx) {
-		qe_muram_free(ugeth->thread_dat_rx_offset);
-		ugeth->p_thread_data_rx = NULL;
-	}
-	if (ugeth->p_exf_glbl_param) {
-		qe_muram_free(ugeth->exf_glbl_param_offset);
-		ugeth->p_exf_glbl_param = NULL;
-	}
-	if (ugeth->p_rx_glbl_pram) {
-		qe_muram_free(ugeth->rx_glbl_pram_offset);
-		ugeth->p_rx_glbl_pram = NULL;
-	}
-	if (ugeth->p_tx_glbl_pram) {
-		qe_muram_free(ugeth->tx_glbl_pram_offset);
-		ugeth->p_tx_glbl_pram = NULL;
-	}
-	if (ugeth->p_send_q_mem_reg) {
-		qe_muram_free(ugeth->send_q_mem_reg_offset);
-		ugeth->p_send_q_mem_reg = NULL;
-	}
-	if (ugeth->p_scheduler) {
-		qe_muram_free(ugeth->scheduler_offset);
-		ugeth->p_scheduler = NULL;
-	}
-	if (ugeth->p_tx_fw_statistics_pram) {
-		qe_muram_free(ugeth->tx_fw_statistics_pram_offset);
-		ugeth->p_tx_fw_statistics_pram = NULL;
-	}
-	if (ugeth->p_rx_fw_statistics_pram) {
-		qe_muram_free(ugeth->rx_fw_statistics_pram_offset);
-		ugeth->p_rx_fw_statistics_pram = NULL;
-	}
-	if (ugeth->p_rx_irq_coalescing_tbl) {
-		qe_muram_free(ugeth->rx_irq_coalescing_tbl_offset);
-		ugeth->p_rx_irq_coalescing_tbl = NULL;
-	}
-	if (ugeth->p_rx_bd_qs_tbl) {
-		qe_muram_free(ugeth->rx_bd_qs_tbl_offset);
-		ugeth->p_rx_bd_qs_tbl = NULL;
-	}
+	qe_muram_free_addr(ugeth->p_thread_data_tx);
+	ugeth->p_thread_data_tx = NULL;
+
+	qe_muram_free_addr(ugeth->p_thread_data_rx);
+	ugeth->p_thread_data_rx = NULL;
+
+	qe_muram_free_addr(ugeth->p_exf_glbl_param);
+	ugeth->p_exf_glbl_param = NULL;
+
+	qe_muram_free_addr(ugeth->p_rx_glbl_pram);
+	ugeth->p_rx_glbl_pram = NULL;
+
+	qe_muram_free_addr(ugeth->p_tx_glbl_pram);
+	ugeth->p_tx_glbl_pram = NULL;
+
+	qe_muram_free_addr(ugeth->p_send_q_mem_reg);
+	ugeth->p_send_q_mem_reg = NULL;
+
+	qe_muram_free_addr(ugeth->p_scheduler);
+	ugeth->p_scheduler = NULL;
+
+	qe_muram_free_addr(ugeth->p_tx_fw_statistics_pram);
+	ugeth->p_tx_fw_statistics_pram = NULL;
+
+	qe_muram_free_addr(ugeth->p_rx_fw_statistics_pram);
+	ugeth->p_rx_fw_statistics_pram = NULL;
+
+	qe_muram_free_addr(ugeth->p_rx_irq_coalescing_tbl);
+	ugeth->p_rx_irq_coalescing_tbl = NULL;
+
+	qe_muram_free_addr(ugeth->p_rx_bd_qs_tbl);
+	ugeth->p_rx_bd_qs_tbl = NULL;
+
 	if (ugeth->p_init_enet_param_shadow) {
 		return_init_enet_entries(ugeth,
 					 &(ugeth->p_init_enet_param_shadow->
-- 
2.23.0

