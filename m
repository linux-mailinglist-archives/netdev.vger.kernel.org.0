Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACBA2F4C26
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbhAMNRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:17:45 -0500
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:62486
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbhAMNRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 08:17:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1dUfF8UtiTtDhZ3tDRcE82TrSxue2Nnfb3Hb431IO+UVl4nw5eIYTHzbPUzKZbNG1KFb/gTl1t5X8yo4lCbKeyQCxetFMgrXLWvBNKkzdhUcExhHikKQCe31JYvh0vtbLoB7lpDLN783IQWl2H1X3IoFt2eVQzicYR/evsNMeA9/PaKMvqj4frkMHRnG1SNAwHCbFeVAi5OgBXpDrChRKOiJOVS83o7NbClDxudOJzZi9ZkbEKRM1X3jUj/P2k46747YUUcAgaH1g014BaVmhdryM2xqPoVs/gKqsdCZJS9jtPoYY+piY+sQ8oVy7NBkxDwSA6hPDpXJvvZzgy3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6G4NgMb8A+1Y9Zb2a8Z/ZsYi7oOv8e3/NWUnrFHKHhM=;
 b=b0ChpJ6s5ui3IBD40o2G+2w3PrQBLLkMOIL2gfmOBMizR1PHjeLKPpHta+1iqB+o/JzzbUeBahpsFvvOL4+KRcoDV7F/AePFRVamxaUQF+JCnt5Folbox3TfsKncOorsjbLLelpLrtx7IySbGqDfkiDGNHxPCyVPraii8YCRzba9ik1lS7wjgqYgAplRYAxUc3isod/lNYCWYWh+PPYAQMkvj7EQHEW/ZPsXB1q54sSyJboX29VzHGsR0XzMxLw9KDSRrSBYfgRO018/+XC3SMFJyAzgdd0yQ8JyVVHWN7CMtalolXnMI9R7sCfqmtuSAGJG3CHPpo6PEGAMQOOgOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6G4NgMb8A+1Y9Zb2a8Z/ZsYi7oOv8e3/NWUnrFHKHhM=;
 b=AJmcSvZxC0rIuza/0XhpBUkc8q9fXVra/RGa0erZ/dhqkXOIckPyJHn4vMsfE4BgfWTzhWCoqqftbb7gFT2wSaUPTi92rxmPfG5AzRKLqXuf5KCn0ihyV0p5GCZr8GFvtJuGhaLdAqNfECiVRGsLmAdwn8vvNwd3bXR8wEKMTfM=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
 by AM0PR04MB4884.eurprd04.prod.outlook.com (2603:10a6:208:d0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 13:16:22 +0000
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755]) by AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 13:16:22 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net v2 2/2] net: stmmac: fix taprio configuration when base_time is in the past
Date:   Wed, 13 Jan 2021 14:15:57 +0100
Message-Id: <20210113131557.24651-2-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113131557.24651-1-yannick.vignon@oss.nxp.com>
References: <20210113131557.24651-1-yannick.vignon@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM9P193CA0021.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::26) To AM0PR04MB5572.eurprd04.prod.outlook.com
 (2603:10a6:208:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM9P193CA0021.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 13:16:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e475ccd-50a4-4db9-ec01-08d8b7c56c00
X-MS-TrafficTypeDiagnostic: AM0PR04MB4884:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4884BFE4B195459878F4EA2AD2A90@AM0PR04MB4884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: icmhDaLMQX3Bt4sNAVSCUStSs1aEtDbzsXFy83iMrhGkbzr7FGBM5sUsT9BIZtVwxWMv9C/wq8wXmfLY1gYT15bbmeP6shrP5chGSQ7qekFva7k2op0vnd9OHGM7FU0GZfTl7px5Mzx17bJcjHMeUOMxGfvMCs5UmX0fxdrcfTGU1XYTG2NI/1Uh7FvrkZgIHcusrLeNCJg6eVZvJMWHihC7Goy1VPRmP6QzLRdzE9c8Lckt/PJxGaCBXxxCYzw0M4G9H62n6UJh6Llj/PbjTtTK0eEgkcQA5qBsxqLtyId2oCh8fh8v8UR9Ihrmj88ABZVU9mOwTFYR1qfrUMJjVVAfn7t4J+/yPOO5tdmvkrf8opxEkjOtd81isk/0aSbs2IjXhAmfIOpLs4+FhQaloQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5572.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(2906002)(66946007)(66556008)(66476007)(186003)(26005)(16526019)(8676002)(478600001)(1076003)(6512007)(8936002)(4326008)(6666004)(6486002)(2616005)(86362001)(5660300002)(110136005)(52116002)(6506007)(83380400001)(44832011)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m91N6HZ7f8Y/sR+ZzVJd8tHHBET+tALqMv+cmt4sron5gu6Mwllly2vB0VgB?=
 =?us-ascii?Q?4sZHVxM0pclwLK5lAWO6sohUUKEm7FLhZZavXxUcHK7g8iFmJ0mkPE/vSVar?=
 =?us-ascii?Q?4LzBpY94qRHmmfJ6WzbdFiy/M5ZsXQScKG186e4jZknA9jTUkKmZBTCpgla9?=
 =?us-ascii?Q?ffnFZTIjyXBVjJSXHF/x7oqBSaWT2nsN6RI8x0sBFuiGVoJYUMLhBTBDkAVw?=
 =?us-ascii?Q?54eFwTQAwflFJ9xNsa+w6Ph5y9ZdP7yxgENH61xeesmovZhvs2f96lpv14G3?=
 =?us-ascii?Q?INvYHKAVBPGYZR8nn1vjxbV+61XcN+mfsx2vd7Oz/3vFlqexfY0PmO4OWsL+?=
 =?us-ascii?Q?pQX+2WbRfT7Mc/mZTSZNrpbr/Fr+yy7Nd/LSUN6NkKfCkqH7AXBomM3LJuEC?=
 =?us-ascii?Q?A+ave/e5mWtzrWBMDXC6aNbpqd8bYEjaZBYUqioKXAkzsu+M0/GrOv76Go3L?=
 =?us-ascii?Q?RnHcb0ByHGv3vr0pt3zaHS5jvfGhG9bvK0uFw8zTJQ72pmISqhndaZS6E7G9?=
 =?us-ascii?Q?KhhSrSUUKXaLzMbTkvYw6e/WiGxko1M+my9hastFC1NrKKuypj7bGOss+ZAn?=
 =?us-ascii?Q?/qZZPiMIWoIP3844dPwERK4aPuVnbq03kb4OqevY2kPxmxE6SFNHsKKehFvX?=
 =?us-ascii?Q?ZH9a0uwCgYpJyHzB9SUlP48q07iaYLgKiut9EOHQrxz3mkqMGZNMQCPhlj2n?=
 =?us-ascii?Q?EG8lEDjOB4FBCMUyFANOihAmWuMgDGZ3F8F8S1bAoGIKS1fI5UnmaLJiBol5?=
 =?us-ascii?Q?Q8BCZnG0lcOLdDRB0dgke4mKSCGHRjnqNTLZ5HDc/FExi0S1Lrqdz2wrcJGn?=
 =?us-ascii?Q?g7iA7YnSSkQ2rHQEKIpyXp/fj8HoOWgza38Bv4S3t3IQEi/GhpZIKmS2Vf6G?=
 =?us-ascii?Q?cMb9jqzttozRNLEijkYgoSjoqA3shjZW9EJsfcZMPN5GZHVERbVAaQlnoOYx?=
 =?us-ascii?Q?Ie2WJGIrUIJ6WSBA4UYUG6j6Ts0JtpIhB1MXfFn0WXNy4EOQSd0fpFrMJvhr?=
 =?us-ascii?Q?9Nan?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5572.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 13:16:22.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e475ccd-50a4-4db9-ec01-08d8b7c56c00
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnZLytjbpcrHGaqkrhfMGetJgg2NYhymvziByU+S/ulfU3r3nD+Mz3euKcMfOLUyncCLrmHTaCGAiEeL1BZBtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

The Synopsys TSN MAC supports Qbv base times in the past, but only up to a
certain limit. As a result, a taprio qdisc configuration with a small
base time (for example when treating the base time as a simple phase
offset) is not applied by the hardware and silently ignored.

This was observed on an NXP i.MX8MPlus device, but likely affects all
TSN-variants of the MAC.

Fix the issue by making sure the base time is in the future, pushing it by
an integer amount of cycle times if needed. (a similar check is already
done in several other taprio implementations, see for example
drivers/net/ethernet/intel/igc/igc_tsn.c#L116 or
drivers/net/dsa/sja1105/sja1105_ptp.h#L39).

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---

Changes in v2:
 - Add Fixes tag.
 - Fix order of declaration lines.

 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f5bed4d26e80..8ed3b2c834a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -599,7 +599,8 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 {
 	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct plat_stmmacenet_data *plat = priv->plat;
-	struct timespec64 time;
+	struct timespec64 time, current_time;
+	ktime_t current_time_ns;
 	bool fpe = false;
 	int i, ret = 0;
 	u64 ctr;
@@ -694,7 +695,22 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	}
 
 	/* Adjust for real system time */
-	time = ktime_to_timespec64(qopt->base_time);
+	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
+	current_time_ns = timespec64_to_ktime(current_time);
+	if (ktime_after(qopt->base_time, current_time_ns)) {
+		time = ktime_to_timespec64(qopt->base_time);
+	} else {
+		ktime_t base_time;
+		s64 n;
+
+		n = div64_s64(ktime_sub_ns(current_time_ns, qopt->base_time),
+			      qopt->cycle_time);
+		base_time = ktime_add_ns(qopt->base_time,
+					 (n + 1) * qopt->cycle_time);
+
+		time = ktime_to_timespec64(base_time);
+	}
+
 	priv->plat->est->btr[0] = (u32)time.tv_nsec;
 	priv->plat->est->btr[1] = (u32)time.tv_sec;
 
-- 
2.17.1

