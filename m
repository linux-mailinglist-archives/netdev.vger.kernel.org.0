Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7962F4C21
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbhAMNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:17:07 -0500
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:8903
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbhAMNRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 08:17:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfexGqekKlbGDnzBHFVRwbBkzSrR/fQh9QQdyDQBp0tdMjal5pvLGyLVb9tQs/3hepFWYBG+DIxDxgzgOz/M3UhtgB0RbeZv/Ggr1IZRw8/dQcnUNbt6ReaIR4NOalH3vKL2wmTjtkMk5bRX742w3rhIljoamcxwWk3K/QNIYhiAKydpEjjMDKk/WD6gAqMJS1s2VlnjTaEOP9jkGbxoEEIrDirvWmasglnBXyYyx2oa8gPmiP+g6Ub6qHKtbAHueo2dRf1f+jb44crIcEiMbuPQeHEpdCLpQH/suYPAYUpKOMCy21aca/meZEeuT9uLD2JRYtFQXFIye6pA932RCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioeMS4YABBL4O4AfIMR104JzrTqo4NakSS9BgAaspz8=;
 b=AlGLKSk/k09swtkUD4ppSUVGlTXFfFut/VS79B8QZSTapBHqshz/qNVruO7pDe6zP5JXxUfROZVpVmtqaMzcF19cUo0jqyZuJg4DHCHrFq6rFI6gGkg2FafBWX/L1JmmNAVxLQ5cY8B9oCmKWk3gRAqMOkIhQhUremRLnNbq8Tbqixzoi4DAVBn0FNMv1qaaox6DDWbTiYBC01Sle84coZt0Nz48/4u4ZHiihpme91zEx2EV+f1SMGimxhCVCdDA+mwzGm/kHQC9Q6KRJ4Z7YMlwqXp54a4xQYqQqaqdWVg+sPHZx4iKIv49GlCFUigvcN7XL8ELkYPQHSn+ZHVMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioeMS4YABBL4O4AfIMR104JzrTqo4NakSS9BgAaspz8=;
 b=G+uc1V0s0UsyCViSXk0kx6WYDzlevAD8Bljr1tQIF97qTCJxuHi2AZbZ3hSvLeo7Pvn6LsfOK00nILU0h4Zi6SVI/jmcYyu5BgimdXqKRO84w1TlCzQK9Tlk6NhC6RLY9XGk/AKFjybXX0sSnuTvEORRlGy0rEt4HXsQIqrRKgc=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com (2603:10a6:208:11d::20)
 by AM0PR04MB4884.eurprd04.prod.outlook.com (2603:10a6:208:d0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 13:16:17 +0000
Received: from AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755]) by AM0PR04MB5572.eurprd04.prod.outlook.com
 ([fe80::ad3a:2347:dd30:e755%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 13:16:17 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net v2 1/2] net: stmmac: fix taprio schedule configuration
Date:   Wed, 13 Jan 2021 14:15:56 +0100
Message-Id: <20210113131557.24651-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM9P193CA0021.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::26) To AM0PR04MB5572.eurprd04.prod.outlook.com
 (2603:10a6:208:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM9P193CA0021.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 13:16:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b027eeb-9db8-49f8-cd65-08d8b7c5695d
X-MS-TrafficTypeDiagnostic: AM0PR04MB4884:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4884945B01547FA5B96A521FD2A90@AM0PR04MB4884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duXNw83CbTNU8c8FixtrS40Db0Iq4DAaqPp2t++mOrfWuvojSxkCVJ/CMcwPIb8D82bqOHDTDHYSx8cPK4EJlIZL8PvDBczLj2uC4EyTUoNqrESFlRVTU9msBqNp8U9EQgw02LkN/6ZCup5VJLZJOFmv+hzxzgp1d5cxSokUBCiCAH+kqDCXkZ6LfJkmPq5KdSObADN8mRB3LNXupdLoPesLgL1RdPMpQlwQddipSB4Yv9Nu94I6aYh3orek5gXydO7uCqFOIUJxFEV7YhrIOu+eUv+THp4K0+2XBXKFygvGhjyjg9gxUAF1TyG8bn5eR33HZBVQKKdrEJ+7srT12pgjsq3WV7dVcN2YLtG+lutdJPxslqLnjYagn9V55ctSUxNxou18UwG4vkeo/1P0UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5572.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(2906002)(66946007)(66556008)(66476007)(186003)(26005)(16526019)(8676002)(478600001)(1076003)(6512007)(8936002)(4326008)(6666004)(6486002)(2616005)(86362001)(5660300002)(110136005)(52116002)(6506007)(83380400001)(44832011)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/7ANj69lOALALuM13NemreukEVJ9r59IETmYW0s8SYejl/tqr5gtIrMbMu2U?=
 =?us-ascii?Q?hgbK+z1Buoc+3QshUpO3u78oWsZ/eCs+uhAWcl/WkUlHoRnUcEQhkUAaB6Yw?=
 =?us-ascii?Q?uabkF8ZcsISOjyx0xm38snR4H2mPVK9Sk5GTeK5j6Xk4H9wzqjk5xhigUXce?=
 =?us-ascii?Q?fvcCrJic0Ngl4aHmJXct7xxghZTz0/DcNVWx/1qQIuZmxGKiJCj1Rx03OcBm?=
 =?us-ascii?Q?CSEdGvpj8V9dhGrrJKfI6iM9UuWYYp4W16MRYvtjdX8r0J3E1cD0JbMeKHSj?=
 =?us-ascii?Q?M6WpDdZXnDRrOv0WBIv8Q0sEuJ4MnYL9AaTW1Ymag1B1qQYQSITP2WSHwgF0?=
 =?us-ascii?Q?QxLOMwuk6xBMdRigy2xAeLvgiaDyYFiUT7BdDEMUST1xHw21KHW5zv+ZY38P?=
 =?us-ascii?Q?qiw5XrojGFHJsUgFc674zZy+V2zwmCczT2n/N5+s0Fd+tW2RR0bT9B9dq+fx?=
 =?us-ascii?Q?vdn78wB6k3W3RsKFIx0PfBjV1ZQHZbXbD9PfxVxa9YuhoWynshsOBskX4OOv?=
 =?us-ascii?Q?/kHlgy9VRjVmd3daTfXB5nkLe12Ps2740FT0r+ZJmGW4OqkFpbk4zqrAIy6u?=
 =?us-ascii?Q?w4R7tGJFSd9A7sG8Qn6HTZ7k42CdaB6yn3TDCjPzN7GVTcwHExeO3ZnaVVbf?=
 =?us-ascii?Q?8223u1xurleyQgYiy+8kW8T4dP2G5WW7AO+Fuqd+mIKAhYxp76CPZwuXm/6r?=
 =?us-ascii?Q?NwV/KLE0k2TSCGgwk8RSLUy1moHEiCYYotdxR2dZT9lFwxrOpiCEFBLhZfNh?=
 =?us-ascii?Q?jG4Bd+mQAqEEDvDjbQhyZ0j4k0czY39n9FqL5he5OKsDmCSFdFb2qlHktWZS?=
 =?us-ascii?Q?fCWdei/QABIRFvRASJK9wVdrMFZjJYwJKtkteTKK96PHUIxHGDIMoa+8zSWJ?=
 =?us-ascii?Q?SCF7ZoCXZJ58ZBP4GBZil14LFGS0mHi8NMhMsSPyXMeg+5uejeUVPD1SYCpq?=
 =?us-ascii?Q?VCmfv7pcsp5iOheehTtKyEv8AqYm/k5iTfL1l5Cc5lmVsvMJ8XZoWJH/6YiD?=
 =?us-ascii?Q?o4KR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5572.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 13:16:17.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b027eeb-9db8-49f8-cd65-08d8b7c5695d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8+YJZmn4Ba8JDVbI8KYwSLyM4vipntfLU4vjztVEiLMAebR18n44XQ9F1VmjRJlNqlW5kZvQFTyfgu+YvvRkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4884
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

Fixes: 504723af0d85 ("net: stmmac: Add basic EST support for GMAC5+")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---

Changes in v2:
 - Add Fixes tag.
 - Fix order of declaration lines.

 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 52 ++------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 03e79a677c8b..8f7ac24545ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -568,68 +568,24 @@ static int dwmac5_est_write(void __iomem *ioaddr, u32 reg, u32 val, bool gcl)
 int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
 			 unsigned int ptp_rate)
 {
-	u32 speed, total_offset, offset, ctrl, ctr_low;
-	u32 extcfg = readl(ioaddr + GMAC_EXT_CONFIG);
-	u32 mac_cfg = readl(ioaddr + GMAC_CONFIG);
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
+	u32 ctrl;
 
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

