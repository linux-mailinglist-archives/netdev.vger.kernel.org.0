Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827FC2CFE3D
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbgLETU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:57 -0500
Received: from mail-am6eur05on2114.outbound.protection.outlook.com ([40.107.22.114]:33377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727457AbgLETUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0NwsEEqAnh/O5fTcqyINRswdo+r+SLYvO+qu5/kq5owGZSyUDiJ8dkYUjnSkavEZRjVCWSP2kTMkQf43v/KWleU4hgaAHGEHcfQhf3yZD/RcYRcl/W/B9hhjAgBMbRNFfiBqHqUwXhwPmKxFNSgu9W+0tJ2+lhzLfzO42VIuU0bsnUTkkAMrs7MzbZGBtJNKyncJne6wr2czWCk1c3CR+AAAKvKdkPoy2IoaBCYDhgG2KNlr76Gy208mp/2gCX1WdP6Bj0b1BEyJHYchiZDd8l9YtLax/kkBQIRaVCrkcthgAT8ELaz/mR1r5kZXRagaNe+UkOA1GpTo9Hnyl2oIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZPaj5py/HUx/r7lOBQI1YfHgXF6/CDK5XLl1BwVAo0=;
 b=lL0lLxdKgwfwi/T5MBAfRUSEZk5fE85OrWaMSgyymMMAmyxOiV8a39pOSG2e1LIAgXX/DPKlhIR9Oy3758KtYc8OUBTbTfWiIPCpjBrtKvvK5MpfXtQXytDdFx/GzG4xpWM8ah6sXKyPuCSoU9FidxugCHUjbAw7p/IUN1TCGuTsVBV+KePJnz7Mt42SwkWdmg8xyNNTOMmUns2crqFCLUR+M44ugOEyHMPsZ9go2feIjNVRRBQsMVxA9XKX7llhdvmEFN0C4mn4gTC3UKugadXv/29yahZarFR6UIltKmd4BhLVemVKHbdq0jMDGuUNL0houocZ6GCwWw7bjAhGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZPaj5py/HUx/r7lOBQI1YfHgXF6/CDK5XLl1BwVAo0=;
 b=TVSsN/H7GB2/Xz4iWsNW6uKD4xgEyGMq6AgabuUOhR28eGQoMaXjrkdJ/f6NX4H0rKRrYnomjIpIGkNcZWz9CXwjAFSOE2wRrEiSu+mp53okwLf/8vDpaZbU5iGJV8Qjio1quwOGHiNAmwASKJwYruxbXXHbOgkzam9gqwmVhYY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:32 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:32 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] ethernet: ucc_geth: add helper to replace repeated switch statements
Date:   Sat,  5 Dec 2020 20:17:41 +0100
Message-Id: <20201205191744.7847-19-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a4833d6-db59-4619-6bdc-08d899528e33
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363E43E3B326D5A0F2D237B93F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmPKYl9gT0JMHesoaH32u1dt5PZGSJiF4ukhWIP2BrKiXAoBvyWtRJSAnkbAno0cmJsCQHjLCiK/zhzi2tLkxszhFc/KOuL2TDDaIxKe4VawChIGHYx/X88v4468z6WgomId+BANBKo5e9HdparuBaEUyur3kDYDwSNYzmjhq6dBuZSlEFFttZW0GGWMY6iv4DKVfjwKn5RnMwMi/nbfVVJLvVIbRG8hTF+tuVyLSSyUUk3rt6FyzcBsFprGKbxHd/Yb7ImKjvyE1niMk9/M7PaLHChNZ0Q6b+ydeVlQMmA/9OfOgpr/AlLz/BdGtanoRgBb1beKp+dSuApm+2m0rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UZ1yNZnt2wzT0xicwgEqfTyMhiaC7rI8KROvOkLEogiM2qLyT34G4+k8jion?=
 =?us-ascii?Q?DKbjNhyG0yLSLdxNSPMOsvK7C65/fpneEeKaprjH8Q9SS0yliCzJEjpbi9mQ?=
 =?us-ascii?Q?BBAgg0wdvAWyVZC0G3VwBAvMRicA4DwX1RSPgryKUQZF0bcuV79NtxJC0fZ5?=
 =?us-ascii?Q?yrnmbw16IpQWSDEZknpAnYWjBDAjjL9G0NAwJuxW+z6PxjAIrBmTgNAwfQgz?=
 =?us-ascii?Q?OKRZd8efItXZ0Rfhk93QRRhBai+D1+BbWBJh/On6UpyimtWg8338Mdp9XoUx?=
 =?us-ascii?Q?Js4KC6/H6toULZGMp03ifK3XKQg9jlps+JBs0oc+GlBPA14weD7JWYaUjuGK?=
 =?us-ascii?Q?Z+FIdR4jU1tABiVoQbRo8Cx1b2dSteYrL+8IN/KOiuAvbN6xCvi9luvLtdwV?=
 =?us-ascii?Q?rdhiOaPw/Q0JO4D6ir+aBTp23VmNpo9nWeMH9zBI3LSsHksrSGSEFJSCh80y?=
 =?us-ascii?Q?h85qwuOhCt7GtRIFsIyA+eWJC6dK3THsiq1bMd0cHd8Pv3NRxcrY66gYUFeX?=
 =?us-ascii?Q?DJe/Rgyl6QmGxsLGkRgL8yMMLEBTQN23nGTkimVgdI3ZHMAiytQKleyZv6Bb?=
 =?us-ascii?Q?HEPffluX2dsfZyjS8b+1ncXl36cYKfjXlPVaKESy4Z6pH3YqokF/rmY6ukil?=
 =?us-ascii?Q?jVKIxroMhR8Mcn2Dr0FJzgRTPBNmH/OwTcCeSZGGt/ef3T6QqcdQpnzXZ8nH?=
 =?us-ascii?Q?b/l+BYY00QrOCNhZ7XnAxEgkFchy0fTBzIEHLaGVLF1avKq/70JXNNN1iNOU?=
 =?us-ascii?Q?IZqPiSRnrRt3+SOq/4+FLCQSBdYxlwAbflNpInR1dCP+pqYu/ze6NGE4qWLq?=
 =?us-ascii?Q?ITBoXVoafglOYayVdk2AYKypZB/cq5BPFQbY6p7f0xez94Y12Hv/PBxVaIlZ?=
 =?us-ascii?Q?2Gi+WDAq/vcDrrqvQ67XkJUbUsoDftRekYljkOhj7eP3YJR+TbWd+o9lueDi?=
 =?us-ascii?Q?n27pvLOFXfl5VUI4vLgB9/KUDIhGh6L85bcOPbMG7Rzd/pLt6D7/WtUcD+iv?=
 =?us-ascii?Q?1aq6?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4833d6-db59-4619-6bdc-08d899528e33
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:32.6297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fG8HLHgXfBb1IaOioE2OVzFrBm+gmtx3qIDASZYTluQeKCL1SpA5SDR/XRcClzLzglDu/cZo2AN6cVnoEXIQl0FGRYAc4TBeDNgakq55zQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
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
index 3aebea191b52..a26d1feb7dab 100644
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

