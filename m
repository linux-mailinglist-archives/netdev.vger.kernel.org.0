Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C52F370C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389240AbhALR1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:27:02 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:15590
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729952AbhALR1B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:27:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyTdIqa5ga1+VugtoQbPJQkV+xyZO5OTAEql1S0WXNOkkYwwe8ge2gZaCjT6ibDu3mkci4G0V13pNLPQsMENquqELBa8ogX5fVdWeArmHEvtugLD6mjCGMnS/0oseMLS6GSDnp/Fz/t210qNoeX71QhH19VUUhNuc+zxQVf/9xzeQCZWxw2XT+GWzo0ldhxgunf6B/g0QyajKJOa0Bs07BeGhNNUNoTz/O0oMBDyteFpb6O/J31NXgDuQ10Cw5aEveTsYMOQNsKv8kLAuNF0nK5R+T5IU3PyBRe6dWGIAyjv2LehmyRAELrylfWZfZq2U/XYldwDnfVlfKqptra90A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et9YFgSyZF3WCGK3uGFL94tQ4yuxfKHByvF7KBzACSU=;
 b=SAfrEIm980OG/r239XX5Eu1cNyQP43sgEhV50vxhivklL6yn7jjHDLr1t5kPjjM90i6gk7AXu1tyObtOKbafeQtJxSH+iIsPiX3xwx4eT3/ZTSH8FVnBbFTqCC+raHKHIliV5yqPWT9tFzLaQ1XaL4fw1FXYX619lR8YFcWQf6/5doFgi5U48gv/8Qc+WQ0kxl7k+B3+PP5TuACB2Nxgry9hkQhYxVQzHpJjBBcGR+uCmIp8JRYo37k79XMrRRTKDQHrdGLjWZnhhApobNYkAXT329N2EDqZZPJfwBoXp6T3M8iJCCy7l3rZExXqzlaBTvuZ6LSEjCCcU49vjtaiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et9YFgSyZF3WCGK3uGFL94tQ4yuxfKHByvF7KBzACSU=;
 b=aOFwCAxVcefD2ycXF0MAQyMRJ8XFCMxC6yj0EdDxhwd7UrnPfU3aMPnqkbzZR6rQXpb6o5Lf9mM97vhClAUR+AXzCsPgfZlbYB7wI9+pCPA4yd2fYE70oKMLjIJCd3LkNFZUKtnIrUshLz6McJZ71c/33PlM2lB0VFgtRdNbEhs=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
 by AM0PR0402MB3316.eurprd04.prod.outlook.com (2603:10a6:208:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 17:25:40 +0000
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755]) by AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:25:40 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net 2/2] net: stmmac: fix taprio configuration when base_time is in the past
Date:   Tue, 12 Jan 2021 18:24:57 +0100
Message-Id: <20210112172457.20539-2-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112172457.20539-1-yannick.vignon@oss.nxp.com>
References: <20210112172457.20539-1-yannick.vignon@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: PR3P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::28) To AM0PR04MB5572.eurprd04.prod.outlook.com
 (2603:10a6:208:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by PR3P193CA0023.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 17:25:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44d0c126-dce3-4a3f-07d1-08d8b71f1543
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3316:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33161DC35B8726C75EDAA192D2AA0@AM0PR0402MB3316.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdipbBjZt5uFHOZOZzbjNYxKceNs4/TvmP3s700XNQLmph6AAkdreOzRz+8oXeK3mF8Fh/eugOJOx9vbcx9EVfXLn+uJbz26Ts9XEpfeRpurTpOuW4Q/olj6KJVeKAK8W839Lh158UmpFDJLCpYSzsqGweWKTNtAAj4D/F72CFZXi0JozIf0dAvqmkkl+RbmLp6FADBb+TMqM9cw0zXKnF/BoYs59JaD8WOa5mE6/0M/7626OClolM3a1cXEwvKW0+/u74TGQA2F4g8d1TJfuHisGIWRzmKjHS+Gu2HZB2GqMMp1WswJ07+cmEbXLM7CxnTjiRLO2CQQf/5ggvzsRo3cM+0XXF37+x9S/N09JxssYWL3dSjSmKyeWKWfPhABRzaf3sD990/hU3caw7WQTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5572.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(2616005)(44832011)(1076003)(86362001)(66946007)(26005)(4326008)(110136005)(2906002)(5660300002)(186003)(16526019)(6506007)(66556008)(66476007)(6512007)(478600001)(8676002)(6666004)(6486002)(83380400001)(8936002)(52116002)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6N3WcyWuatqyOsUhCf4ZPUmsOf3wQMhMTQYlo3Lx3wCeOcXvnFTPIPe6QHh3?=
 =?us-ascii?Q?D/c6dcJ6s8K9Gpe/Mmja9UO4+S7hrjpUo7eORDReIiQasBJCcjEdgDX0xCaj?=
 =?us-ascii?Q?VWRACeJAftiOljcNCBZSErQuS/QeyYjNqZ3P3xZPzTTENihgUZ0O8XyR7SDG?=
 =?us-ascii?Q?R9cGWHth03z/9ZdNkTkXh17Oj3kFZczbD1LO3ANTLbgmZx/U1Xc1GFpyOv51?=
 =?us-ascii?Q?oXUsFsM8kWAgPKz5srp4rPc2p4lqE93dqt6VEn1q3ZhfxXrEar7IfWjnrrgF?=
 =?us-ascii?Q?/vN6fI9a5WbDonawGD7uLe7n5tx8xMWrWY4VRtzGyyYpjVm4V7zN+5ItPtHh?=
 =?us-ascii?Q?Y+Qqttu5tVbxDXwLbkPPVXDxaTrBh9NeGo6SVOvyJTPRkE2qjhdXGo2jdHI0?=
 =?us-ascii?Q?WQRY1pTcIFzk7jxRYedngredTx84gg6ccVAcqsphciW402cS9L585JSez0DV?=
 =?us-ascii?Q?cbNAFKKo5EjbRQSgZljPQWgG4CzPG5SxB/ZJdHbMPTDjQ7cSRbfj3bzELMtQ?=
 =?us-ascii?Q?2NUy53XkZ04UHDJXnY9c0xObBGssXhMZAoJHjp+VVqN5iJR6Qd1mdrM2ntU8?=
 =?us-ascii?Q?Isw3VGogh2PlFEy3uljU9XoY0V2OWsXcLBQZUj/iFZDcUix7ITWzcmWNkryC?=
 =?us-ascii?Q?agmkWLuWtjxpxjE2Rh/gUuoKtl7/sQqfZsiBdAX3YHuLCIHG8Xms36iOD3O3?=
 =?us-ascii?Q?wzsiRXb0YuFzF60++5duJWBpY/eXhR4o7W7omLJY0fzz3EtLcMXAAT0kVGAz?=
 =?us-ascii?Q?WXuHgiu8rwAiU4NmEfyYxEth10y5GiQXBTZ5NdaiSVn/Hsh/ZsfhvkSoOleM?=
 =?us-ascii?Q?npU8RstmOPGgwGTNq7rSBidKScV+YDBVH2xnAZqnfZHOYp/i+g3Z81eA/L+x?=
 =?us-ascii?Q?X+4xU8hLqxfhDIWmCd9Ne+m+vmENrD7extX888plL7Ku/Kmn3eRl6GvyKZI7?=
 =?us-ascii?Q?lZCAQpnjaNMBynyTPfJvxyLMTK+NG/6amzSWqOYd0g0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5572.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 17:25:40.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d0c126-dce3-4a3f-07d1-08d8b71f1543
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGVuRb8/vHDb+z4UGw5FNsY58Wxa66KlotzLZRtHD89nJnTooWiEavJHROsY0Eh17GiGirq4YNRLsDCPgdCy2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3316
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

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f5bed4d26e80..f3543ec8ef10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -599,8 +599,9 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 {
 	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct plat_stmmacenet_data *plat = priv->plat;
-	struct timespec64 time;
+	struct timespec64 time, current_time;
 	bool fpe = false;
+	ktime_t current_time_ns;
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
+		s64 n;
+		ktime_t base_time;
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

