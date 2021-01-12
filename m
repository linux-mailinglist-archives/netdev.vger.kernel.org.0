Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4D2F3705
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbhALR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:26:21 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:10081
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728887AbhALR0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:26:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGNWlf/XRjoKqMS59u4Xh7yY1HBvXCuyKM1boXxsS9o56lwtRTOTdHU0rVr1aYpQlwiyHEHRFfa1Ev6ihKB1AuHizWR2ZnwHtnU4JQvU0rvUXdr3hcEzMoEV3mDiFNGxBt9FYAvytvT078ZMkAK6R82AK6UTn9DK4DEbskW+tWhmXvl4rKCwVIJ8kn1Gl/bx6t0tDfIS/zhIshgk7Dgj2VWqUC/47s/mxAp7JAb2Qe8OYGk1Sz5dkfmTQBarrjShtdhsBXuinx0oiDUrl/rRitR+8QxPcZOahMxA43AzT3hMyjJecg5ORfKp4LCDLs69hNxl2gqAN9xwxAYpn2y3Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHR0XGW8eYCNyt3vG5jf/+sIBpn1kNRhw7T5itWt77I=;
 b=TbuMyLhQZ+pSpu0eMKnqsMkVWf6dCWe8JbIabN670mfEBPLUZXDut4OsGSv/tbAu02kfphSOuQm9dKh6uruqIoie88VXsSBCW2feyyEZw9+WolLRU2R24ZNeuxjlzu9Qi3hBTOK2YrVdLmmiSBcWAJT/Z+RWH4jd7aApXAmH4TzqkzU8DQTa690XKK759KiJqTyQlJeKfgBCtwwMV+DhNKSSv2TqNFGb2jigZIdWxSB74i0m7zOF0+kKvoA7Fv578skbHwHuypaN0CX6bNhCQSl5i5rt0ryTKYAIvv1d3NjROKf4mQK4YkyDSY4trrIqRcx/+GYsT5ycXfwljFcxlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHR0XGW8eYCNyt3vG5jf/+sIBpn1kNRhw7T5itWt77I=;
 b=YPdSo98RNgqer7P29+SawSrdRZCDxb8oGb1qS44VDwq4WMZqNZ7fXSwX/PtCoY4FmB+ccTz3y8DY7og/P0Zc5AlZS7rtM4010GbHaeA0RT5Zjabmbyde+TOpPORFrcYXAyaw+mC8OL12kJr5y2ZVjrYCU8TwYZLHjGQRvYzDdtE=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
 by AM0PR0402MB3316.eurprd04.prod.outlook.com (2603:10a6:208:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 17:25:32 +0000
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755]) by AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:25:32 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net 1/2] net: stmmac: fix taprio schedule configuration
Date:   Tue, 12 Jan 2021 18:24:56 +0100
Message-Id: <20210112172457.20539-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: PR3P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::28) To AM0PR04MB5572.eurprd04.prod.outlook.com
 (2603:10a6:208:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by PR3P193CA0023.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 17:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0c89a34-c8ab-44a3-18c1-08d8b71f1077
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3316:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3316458D0E0EC64FCA5C0DF8D2AA0@AM0PR0402MB3316.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CA9ZQ/xyQ23uCSPt+hDOwJ2Dfgnqvm+NmKjkspeVVEAlRinbZu5XuIMh+Vj42SG3JNSOfxOjpwOfTS7CN//QFgZVsKs1NWcdnPY8kqf+w/+Xs4SdqwJNb53fpmH4IIlkY7pyi5Ry0EA8gSB9WT8IDSlRimarTMGZ2Tb+6T4ZsVGk50P30MvyotWeuT6LsR6Y83dWKjjFC8a9aYSXwkaRTBbPwsK5qs378DChD6pip3Pd6rxIabRbY6yhRU0F9FIX1paE3lCBbCo1HI1wIOvIcC6qNE3ljkEDJNwomivlll9kk0LMLtkCEO+Mj+lw1fXWk0HlxVKNpDRu3pBM4709CV2lmf2eY+xG5bcP4MrlsCaQDoe436CLZF19OLLvqGo6nBHyVrBJrK8saSTG+X6L7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5572.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(2616005)(44832011)(1076003)(86362001)(66946007)(26005)(4326008)(110136005)(2906002)(5660300002)(186003)(16526019)(6506007)(66556008)(66476007)(6512007)(478600001)(8676002)(6666004)(6486002)(83380400001)(8936002)(52116002)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?T9oNVGBxDbMfuF5qe31gHp9z96FeY926VVCWbXbC9OZgd/scE1/3OwAKcDwB?=
 =?us-ascii?Q?dcigc481NI64qqX/UvPrOMNBaiy6QF7MP6VteWy/S01kUNF5OpB1KSm9v5dU?=
 =?us-ascii?Q?ojwWWkuLwhjs79MBbgbuSKBW01ui1PdeXjFJJM12WOg7NTks8nmytcrMclbb?=
 =?us-ascii?Q?7OOQ3oXBAXYlyWW+J8wO+VvT0mWf2rK1zinl+31n7bN2f/MGFeqNkgZwkHU3?=
 =?us-ascii?Q?p44TQZB4/JQOgFuAMAmdXltbQ52aNeCX3qTFBLRZurVFhE/iAV4oK+Z7bEr0?=
 =?us-ascii?Q?Ob4e+uB7MgrSj1Eo40AeR0tMwSmO2xDchqT5epc3YBR/EX9A7mKxt/D003bj?=
 =?us-ascii?Q?ZXEvBgxi8yQEa8jsMapnw4gB+bMhUe/MrTAqqgZ2jL3YEE9QzNFlgFcPGAnE?=
 =?us-ascii?Q?ck0heSWJ4Fskkx8rfAKvdN2i8nbg7aZO0fhw9LLjBgK5MuDUFAEzKDKVPvHb?=
 =?us-ascii?Q?0lg54njzmdW3NWIyO/STJt3w0jDIBRXpUMiPKtYstPEy0TXNg8ng84eoTpUQ?=
 =?us-ascii?Q?bLKNgeP6ehRpoka9AgrD9Lo+zpkMUj5JnctxWjc9CwTREoh8v2TEdv7cVAyi?=
 =?us-ascii?Q?h9yR0o0lmoVil1lk4K5+wpC6GHO3lxEHbmFJKpC5LHlkO/hIOt2Fiy/I6UDG?=
 =?us-ascii?Q?BPdqB2sKTwaUmHHghGSyRaGcLPyuo0IFysh2pPLEsONCxqoOaE0KWzkCeYUH?=
 =?us-ascii?Q?VQdBpuRFmQ882tyMkbRHtHkbls/c7+nVB4AsI4uVogPBTRplp4nT7kwKi3R4?=
 =?us-ascii?Q?aZ9ahDl3MBa5dmS8WNQED2y8FwhW1VQLo+8tqlILE1gPgPy6Co5nHqfGxT3N?=
 =?us-ascii?Q?Snksx7RLZxYk1nO9aS69We5bDXEA5+gof1kK2zr2UBcTHNxW/PqPwEtAV1NE?=
 =?us-ascii?Q?KDA4fQeso/NsZJurAyzZK0MbWPc7tZLICoDeHjjZJkvzbh2TW3/iJ9wFvdol?=
 =?us-ascii?Q?05qGXlZTHUw/6Stb4fbdbr8zBYw4rLIip6TsEHy77WU=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5572.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 17:25:32.0595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c89a34-c8ab-44a3-18c1-08d8b71f1077
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wR4qs9I9iwCrswkKnpDXaroMr5FMm9y0NNsWqZnUkyshEISn6cIBDG3BpmTPtly+FZuVBo86t4Y73M+1QjEIsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

When configuring a 802.1Qbv schedule through the tc taprio qdisc on an NXP
i.MX8MPlus device, the effective cycle time differed from the requested one
by N*96ns, with N number of entries in the Qbv Gate Control List. This is
because the driver was adding a 96ns margin to each interval of the GCL,
apparently to account for the IPG. The problem was observed on NXP
i.MX8MPlus devices but likely affected all devices relying on the same
configuration callback (dwmac 4.00, 4.10, 5.10 variants).

Fix the issue by removing the margins, and simply setup the MAC with the
provided cycle time value. This is the behavior expected by the user-space
API, as altering the Qbv schedule timings would break standards conformance.
This is also the behavior of several other Ethernet MAC implementations
supporting taprio, including the dwxgmac variant of stmmac.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 52 ++------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 03e79a677c8b..cdef27bb7b6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -568,68 +568,24 @@ static int dwmac5_est_write(void __iomem *ioaddr, u32 reg, u32 val, bool gcl)
 int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate)
 {
-	u32 speed, total_offset, offset, ctrl, ctr_low;
-	u32 extcfg = readl(ioaddr + GMAC_EXT_CONFIG);
-	u32 mac_cfg = readl(ioaddr + GMAC_CONFIG);
+	u32 ctrl;
 	int i, ret = 0x0;
-	u64 total_ctr;
-
-	if (extcfg & GMAC_CONFIG_EIPG_EN) {
-		offset = (extcfg & GMAC_CONFIG_EIPG) >> GMAC_CONFIG_EIPG_SHIFT;
-		offset = 104 + (offset * 8);
-	} else {
-		offset = (mac_cfg & GMAC_CONFIG_IPG) >> GMAC_CONFIG_IPG_SHIFT;
-		offset = 96 - (offset * 8);
-	}
-
-	speed = mac_cfg & (GMAC_CONFIG_PS | GMAC_CONFIG_FES);
-	speed = speed >> GMAC_CONFIG_FES_SHIFT;
-
-	switch (speed) {
-	case 0x0:
-		offset = offset * 1000; /* 1G */
-		break;
-	case 0x1:
-		offset = offset * 400; /* 2.5G */
-		break;
-	case 0x2:
-		offset = offset * 100000; /* 10M */
-		break;
-	case 0x3:
-		offset = offset * 10000; /* 100M */
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	offset = offset / 1000;
 
 	ret |= dwmac5_est_write(ioaddr, BTR_LOW, cfg->btr[0], false);
 	ret |= dwmac5_est_write(ioaddr, BTR_HIGH, cfg->btr[1], false);
 	ret |= dwmac5_est_write(ioaddr, TER, cfg->ter, false);
 	ret |= dwmac5_est_write(ioaddr, LLR, cfg->gcl_size, false);
+	ret |= dwmac5_est_write(ioaddr, CTR_LOW, cfg->ctr[0], false);
+	ret |= dwmac5_est_write(ioaddr, CTR_HIGH, cfg->ctr[1], false);
 	if (ret)
 		return ret;
 
-	total_offset = 0;
 	for (i = 0; i < cfg->gcl_size; i++) {
-		ret = dwmac5_est_write(ioaddr, i, cfg->gcl[i] + offset, true);
+		ret = dwmac5_est_write(ioaddr, i, cfg->gcl[i], true);
 		if (ret)
 			return ret;
-
-		total_offset += offset;
 	}
 
-	total_ctr = cfg->ctr[0] + cfg->ctr[1] * 1000000000ULL;
-	total_ctr += total_offset;
-
-	ctr_low = do_div(total_ctr, 1000000000);
-
-	ret |= dwmac5_est_write(ioaddr, CTR_LOW, ctr_low, false);
-	ret |= dwmac5_est_write(ioaddr, CTR_HIGH, total_ctr, false);
-	if (ret)
-		return ret;
-
 	ctrl = readl(ioaddr + MTL_EST_CONTROL);
 	ctrl &= ~PTOV;
 	ctrl |= ((1000000000 / ptp_rate) * 6) << PTOV_SHIFT;
-- 
2.17.1

