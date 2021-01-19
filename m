Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587442FBAED
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389469AbhASPSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:18:43 -0500
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:4165
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390971AbhASPLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSvfEnnkciKyJErufzbKLAPUL07u2WDK85rdMRRuGlUd1HOKx03xDRS7wY7KMXRSbO24WtORLURbRFUQ+VGy4jI/go8+UpB5aiNgSBBa4I4l2GryZ3m+/3u5nOIoVyJ7VA6TJfMHIPiFdQO82CzU1RyFbgzQVzVZcLUgssgcHnprJzzPVf1qWZjtPiDL4JaO5Be6EERQLCstTxOrD/1h0dj8j2zftPZJj7IOJFSncDdycprPdcj75j7iMHCtRf5Exp/XzhfiEJNUpfkj3AEHz3nutX1edVMVoUcFmAQl7dQoSjV0o3B5bpK7c1tK4irNGhWfbcEFeEbc55hJ8KrGUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii3KT96+M7iGpRk0i2yK1cnKu2055MxHxpO0OuA8Ybo=;
 b=cmUF3rw5XTvVB/MNJAL7bLu2Kj43Ut4umjhVWCv1h0IdtHUVIFwbnS6Lk4ZUQWoYX+R++f+IeLhatX2xADVNWRKW/8X4wpSR0WoBSQjFjqL+FLn462fsdraPCggAlqg4fbNbTJf19KigXGnNu8BYzFkUJAIndmd72BIOLCXhXUo0Q4Qv/1Ue1XZOwsJXOoKDUsgxlAOkZTDE+/Yq9sLYNUQS8aANvYMC8FDK8E7wvmn9C9Fsw/Jkmuuwnhtx6c3Lczf/zPuJih8YVDNARhlPbb1EySjRlX5hvGvtM71LF5MipX7MG31P941JtqkBFJD+DBj/TOZrAa96uYrDeyVs9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii3KT96+M7iGpRk0i2yK1cnKu2055MxHxpO0OuA8Ybo=;
 b=dHOLwzxw/Jy6//mqAizU3rdD49ytiRk0RnJNdyBnXE4D61j3XGv/L9EoQSwvilqAi8V22iHQ2THwddkUfVGD+6o6TbRDzSP95D8YdlefNug24CSylrflVq0xhnFEKesjUS0VT9dAkTB/T5v9ol+3FPFut8ye5tY7GhxUM8/t69I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:19 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:19 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 15/17] ethernet: ucc_geth: add helper to replace repeated switch statements
Date:   Tue, 19 Jan 2021 16:08:00 +0100
Message-Id: <20210119150802.19997-16-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48e68eef-bdc0-4ab6-799f-08d8bc8c31ef
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB1922DEA9949E83301A90112D93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /g0goFmdr0dwlRUk5t9pNbMRqhorTMsac72pAGyIq5PCPQK2ynN16/U4/bR/5VB9KqDxmPKlocn4LMjo2Jgza8lyIIGQW+wJtAm3+zEHw2gMhCn9aKCA1QgR+LQybxdF2s/8mmtqm+S2QWATnqKqEx5uVtKFM5AAYkTOf8XIFfxmau+HEaWfk6LP4PsDqsDDPAeLeYkXNjrTwv8YoFXzGo8T7XipaUJ8WTUknZJ95pp6uTG1Wql9cEsX0EvGOIAGjQbPRWRW20/kpHrIjDMvYFGM+dHy3Ig+W+lxNR9+0rpAdzbBgGPYZv5UfLDm7tpFN2XSRX95fak+wRT2izysyGtwt/Jg+QnmcBIuE5nShNvsB44ykgttMcbJdvNraEI3RxNcR2RnX//OJPCJrhxikw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wbXK6lfyKAgSpKJQOXmDvNyXybEkYEXuP13i9mEanRk9dFDc1rOiTthtHJDa?=
 =?us-ascii?Q?GkY9aNeeC7Unylimfe/+a3wPlChi6e3Z3rHNsKMBF7TmoqLrifzDByoebvmW?=
 =?us-ascii?Q?qI4CEyRjBdNE8WzWlWTd5o3xwYl8GHAxtFNTx4oFxXNSECBK1zW+uu5y71Wt?=
 =?us-ascii?Q?0gG+2i6p4yTwYgOaFG0if2FzUnkDHoRJxkr7r5PpZnTB+ZFVYYXBgp+TAXsv?=
 =?us-ascii?Q?Xe5EZ6l5hda3LVbp9xhzhggnsEWo8ZqWDZeCxY94C+yVeeLWv2+HwnW8ErSo?=
 =?us-ascii?Q?X6tAgsW+NsV+QyXMY+3w6fBvU86a9EPFsf2nhzEHL1HnzkO2DByLP9gGhyB/?=
 =?us-ascii?Q?pPtV2zhFdboiWupZPt0lU1kvp3cF3CfVYP8JBGymRjdApa5oDUMZ/NpqRegV?=
 =?us-ascii?Q?+KY1pyg20YcUmokJiP/QUuDvLvxn7nzRUiHQTgoYLZwz3wNIFKdVuT0VxFv9?=
 =?us-ascii?Q?WB30B+7GVCo1mk7vsJRc+A1hSyG4di2fiu1pvkbx11YpmEXFK3zEWVbXGa0i?=
 =?us-ascii?Q?NKvzia/K9Z3hHs3jHmuvANY3jhUHRXhw9lMx4K+IWFjCX5JFgCw1KibMHJHe?=
 =?us-ascii?Q?2UcM1yc80tktcefl7GIhhPySzkmOMm37OVVWFQyXNSRVvYhsgTJZ7M6fKLhQ?=
 =?us-ascii?Q?C4TlXKDQw+InVEB/U4TypX0oz8VzQ3IlImXcvK079H0Ur/ChYvDYfoQslPxU?=
 =?us-ascii?Q?I7ypQ8ui1pCLU4IHSDn9oFCcZ3aPGdlVVTFFBb1Kz4W7BO/EwpazTMNTbeEh?=
 =?us-ascii?Q?AtiViR08Nv/Ozh8te2oiN3V7BcM6IKdIbmMJ4b3mF2OjubEEnvKTdk/Xa+Lg?=
 =?us-ascii?Q?Lkvr65IFnCa+/7RKs1YWnriQ5X10nbqAGgQxdf2Cv0TdzTfoltSpuRHTQBVm?=
 =?us-ascii?Q?Mijt9kBFSEbOm80usriEcfjdNuMdf+P+g6cN/zNz+ZVAdEnibEej4MpQctiZ?=
 =?us-ascii?Q?HBkVBjzxTVP6hOKfbsrGsZToFDpNrGiwDMjvDeTxgrKZC5A9SO6uXqT+EnyP?=
 =?us-ascii?Q?qBZg?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e68eef-bdc0-4ab6-799f-08d8bc8c31ef
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:19.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cgycRYKoC7cScqXsVWalMIM9vikIk+sG55pSRp50jffoc031UL5Um8fTYKl9CpEQBF6vcmO4JkcKOfQldvlFpweEs1CW12dZom+gonwTys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The translation from the ucc_geth_num_of_threads enum value to the
actual count can be written somewhat more compactly with a small
lookup table, allowing us to replace the four switch statements.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 100 +++++-----------------
 1 file changed, 22 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 621a9e3e4b65..960b19fc4fb8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -70,6 +70,20 @@ static struct {
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 0xffff=all)");
 
+static int ucc_geth_thread_count(enum ucc_geth_num_of_threads idx)
+{
+	static const u8 count[] = {
+		[UCC_GETH_NUM_OF_THREADS_1] = 1,
+		[UCC_GETH_NUM_OF_THREADS_2] = 2,
+		[UCC_GETH_NUM_OF_THREADS_4] = 4,
+		[UCC_GETH_NUM_OF_THREADS_6] = 6,
+		[UCC_GETH_NUM_OF_THREADS_8] = 8,
+	};
+	if (idx >= ARRAY_SIZE(count))
+		return 0;
+	return count[idx];
+}
+
 static const struct ucc_geth_info ugeth_primary_info = {
 	.uf_info = {
 		    .rtsm = UCC_FAST_SEND_IDLES_BETWEEN_FRAMES,
@@ -668,32 +682,12 @@ static void dump_regs(struct ucc_geth_private *ugeth)
 		in_be32(&ugeth->ug_regs->scam));
 
 	if (ugeth->p_thread_data_tx) {
-		int numThreadsTxNumerical;
-		switch (ugeth->ug_info->numThreadsTx) {
-		case UCC_GETH_NUM_OF_THREADS_1:
-			numThreadsTxNumerical = 1;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_2:
-			numThreadsTxNumerical = 2;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_4:
-			numThreadsTxNumerical = 4;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_6:
-			numThreadsTxNumerical = 6;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_8:
-			numThreadsTxNumerical = 8;
-			break;
-		default:
-			numThreadsTxNumerical = 0;
-			break;
-		}
+		int count = ucc_geth_thread_count(ugeth->ug_info->numThreadsTx);
 
 		pr_info("Thread data TXs:\n");
 		pr_info("Base address: 0x%08x\n",
 			(u32)ugeth->p_thread_data_tx);
-		for (i = 0; i < numThreadsTxNumerical; i++) {
+		for (i = 0; i < count; i++) {
 			pr_info("Thread data TX[%d]:\n", i);
 			pr_info("Base address: 0x%08x\n",
 				(u32)&ugeth->p_thread_data_tx[i]);
@@ -702,32 +696,12 @@ static void dump_regs(struct ucc_geth_private *ugeth)
 		}
 	}
 	if (ugeth->p_thread_data_rx) {
-		int numThreadsRxNumerical;
-		switch (ugeth->ug_info->numThreadsRx) {
-		case UCC_GETH_NUM_OF_THREADS_1:
-			numThreadsRxNumerical = 1;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_2:
-			numThreadsRxNumerical = 2;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_4:
-			numThreadsRxNumerical = 4;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_6:
-			numThreadsRxNumerical = 6;
-			break;
-		case UCC_GETH_NUM_OF_THREADS_8:
-			numThreadsRxNumerical = 8;
-			break;
-		default:
-			numThreadsRxNumerical = 0;
-			break;
-		}
+		int count = ucc_geth_thread_count(ugeth->ug_info->numThreadsRx);
 
 		pr_info("Thread data RX:\n");
 		pr_info("Base address: 0x%08x\n",
 			(u32)ugeth->p_thread_data_rx);
-		for (i = 0; i < numThreadsRxNumerical; i++) {
+		for (i = 0; i < count; i++) {
 			pr_info("Thread data RX[%d]:\n", i);
 			pr_info("Base address: 0x%08x\n",
 				(u32)&ugeth->p_thread_data_rx[i]);
@@ -2315,45 +2289,15 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	uf_regs = uccf->uf_regs;
 	ug_regs = ugeth->ug_regs;
 
-	switch (ug_info->numThreadsRx) {
-	case UCC_GETH_NUM_OF_THREADS_1:
-		numThreadsRxNumerical = 1;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_2:
-		numThreadsRxNumerical = 2;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_4:
-		numThreadsRxNumerical = 4;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_6:
-		numThreadsRxNumerical = 6;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_8:
-		numThreadsRxNumerical = 8;
-		break;
-	default:
+	numThreadsRxNumerical = ucc_geth_thread_count(ug_info->numThreadsRx);
+	if (!numThreadsRxNumerical) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Bad number of Rx threads value\n");
 		return -EINVAL;
 	}
 
-	switch (ug_info->numThreadsTx) {
-	case UCC_GETH_NUM_OF_THREADS_1:
-		numThreadsTxNumerical = 1;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_2:
-		numThreadsTxNumerical = 2;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_4:
-		numThreadsTxNumerical = 4;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_6:
-		numThreadsTxNumerical = 6;
-		break;
-	case UCC_GETH_NUM_OF_THREADS_8:
-		numThreadsTxNumerical = 8;
-		break;
-	default:
+	numThreadsTxNumerical = ucc_geth_thread_count(ug_info->numThreadsTx);
+	if (!numThreadsTxNumerical) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Bad number of Tx threads value\n");
 		return -EINVAL;
-- 
2.23.0

