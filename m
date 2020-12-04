Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307EE2CE5EF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgLDCrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:47:36 -0500
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:4739
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgLDCrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:47:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce6Sl3wLf/kmELZd0/wP5wKRtZE2wQOUSNh2zmbVQF8k3FZPBPLVOVWUDiKDEnHyMSjfe69/47mS4gsyOFeMX+YhjqZaJ7meuamOl/po0nZSaOFBM9pi9c9cgx5Q+/GvngU0BOPRCmek+idFN8uYQLut4ey8FUOvtxLECdNjymXsBcjzZqla8Klaw0/F5A0kyquALvdPSlAbKEfJ26/8BARh7BDdnlJIuggZQw9521MyzIN9XS5kPZ1ymDz+JdHwChXfN76LyDjJcWTnZrfKCecqf+0o4Yzc/oMdyVbVNEAY7uGt8Bu8yzpXW/hI4ec+NtnewyPg9bmTe6x6EG9yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zt2LDV5dRpOEIql0oMOFvGRdYBfHx42wiwqunvHWXE=;
 b=IsZXFiHxNmDy28ZzWivKwHQnm/YdIGBPZ3GhJYNf6IbcHEnoD63JzEn0yZ/ltuXk/RtBr/uvKG7zexvGkFWyzNBDT73DfW9dG55BG/qXRmG03TkhlM6AyHGZn0YkTVwncC2yqp69eHm77fOT/dR6GR/4nF+MDjnLiyhnNuSSeFDwHCElwTJsl0DamsjVOS6dh17dlsz/OrC3aPUsUGcToUkVIqgRG5ftc2CtW541ggy/XKatIX+BX1aV29zbThC3vB4PrSTpAJQkc/mQPbJUyWJ0woWhhddcU/Fnm0KBrgY+tJ2olxwSIBDqAjKn2NtYO8EJqUoL1/HV+dmPeUtTGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zt2LDV5dRpOEIql0oMOFvGRdYBfHx42wiwqunvHWXE=;
 b=MoCegcifWx53IKa3H6m+hcnnwATOc9bQ+1VlbkaH3N1jXBwEBDTd85rYCKyzevkqA51no5K1NqsYhnlSuazVNYS5UczbdS2iW3seeWhX6ZgfFG/YLOq/fJOLLb9gysvkNsVKgzbPEB5oY6mXAsaDRRzarbZSZZEcYlkUYN9e6f8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 2/5] net: stmmac: start phylink instance before stmmac_hw_setup()
Date:   Fri,  4 Dec 2020 10:46:35 +0800
Message-Id: <20201204024638.31351-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d3482a1d-ec39-43d9-696d-08d897fecc98
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3707800351C1707D2CC56110E6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +VlqgMUuDV+UAB0bb27b9MxvWFF4JF/CRqiqZ0lRFvcEZTDRnkz2N7CWPMSJdR3faIlIsgWSJ13cuOuumqk15VwWdj5kzCJLC677aApg5HXNfQtKRYKZ672wqPknjp1Qqwipm+9A8oLYDf+Rd4ySQJVI7PQBDq41i9tfLHBuzcFjwPSThd3yTIc6iSmMw1vfMgMy3/4v4QsMdNwi5Rt6850ESo1wBoDf7kfQk8UIOJvXiQI/zO86K+vF9alyl0M6n/SkQD/XuQ8rnUVbUjE2pQk5zsqHQikz/ffki/EW6aN2vSueHze9n+QHfjXqGu7/KnKMyg1bwBDbxvLVW7AHyeC3pbd6lmIgoWkqlZdQNKHhEutftwBqmi1HQBxwJTHB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?05gKR1O/KvAaBBmEMWwZY9LJwTAZrk/+b2MUSwwc0sIaOofJh+J7r7XbB3iM?=
 =?us-ascii?Q?lyhQHDl5Rv7urB/wjg9Q31cQfHy0Aek+GtcYVgfE4xSI2rNx6dfrQFJ90nSD?=
 =?us-ascii?Q?Ci+5aEO9OzaKWuyQL4oY+62ccBuoz9t5/Xn/kaEoHno9bLq3XqyEb1+Da5p6?=
 =?us-ascii?Q?urkERsVwL/GHbNp8aDlSU8fGJfvzItnQxoXabAKa2rQXjmDUJ6y4Tg3z+2mk?=
 =?us-ascii?Q?YIanZAs0BBWXgIvGIGw36FRQd7L6iWQcL6F1x3EE7LHqddDz3jJ7OUpOpj7i?=
 =?us-ascii?Q?eI9UfAJDmDZsv+RmIN5+Vb1gBhmRc+CfNgzdCRMuiq1gnevWljApBg0YUIzK?=
 =?us-ascii?Q?2BAQAM5ZhH/QAzLtKnimy3ZPzbL3uhTGmHhvIqgH0b11GDzWTI3zSI6X/qhj?=
 =?us-ascii?Q?oQZmAo2BQv95NIvC+XVm3SHres77WhPTe+wHz+RibR+hjIe7hPohSAmhCvrX?=
 =?us-ascii?Q?hfCOdXZzUqQtPrZ2kRYmlCIy4FpTYXguaEO2/+687zn8vDURSCJSOTRrKLB7?=
 =?us-ascii?Q?3TVnmYV6Nz/cWnFvmkJBned5WZOli9/2daxhckJPOjlRomLid19S+6Y3T2Yp?=
 =?us-ascii?Q?Dyr8jdBD8laBmjAQN1zOYiVuvuVFbEzhZ0TNNcYz9eC8YAbXwvpTpoMWFj5+?=
 =?us-ascii?Q?AloHnfCb24AQPaWVpSf9zmceYXYeP713VtzkrEsziaXFTYu7Q+WFuUir5i8N?=
 =?us-ascii?Q?pCzPjNpq1QYJpwddt24Khxpe2t5EQI7DMFcwFIUzBqd83mnCim/z09fcKCRe?=
 =?us-ascii?Q?GDPhyQqmvRwQ4uJU5ua2JYmYV5Kzk4UlwZkFrxsSRoNOaJQnYWka38A059gB?=
 =?us-ascii?Q?lDITTeROtE7RbeS5qtV5+Ai+CpH8qWeD6MuMV8JHmQZQ4FSW5KHx2koo7cVO?=
 =?us-ascii?Q?yeE7vU3ow0swu/nyQOibKiGFyRPqFAdrjGRj78RoqwwYWa2ugHR6+0rXBW0N?=
 =?us-ascii?Q?uoyHxOJdngS4YaiL7G7l1f5LJARHLqs4dHOQnv6K4WRGn+N+c4JNdQBPMtmR?=
 =?us-ascii?Q?6xR1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3482a1d-ec39-43d9-696d-08d897fecc98
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:28.5402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6s8gh041tTzi3RhAj1RVAnDwECQVjxGyMkmFbMzjrSIyT9BeU79vH/pYWVag0OVR95VMdKymO1sCaiXJN8Lqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Start phylink instance and resume back the PHY to supply
RX clock to MAC before MAC layer initialization by calling
.stmmac_hw_setup(), since DMA reset depends on the RX clock,
otherwise DMA reset cost maximum timeout value then finally
timeout.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8c1ac75901ce..107761ef456a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5277,6 +5277,14 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		/* We may have called phylink_speed_down before */
+		phylink_speed_up(priv->phylink);
+		rtnl_unlock();
+	}
+
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
@@ -5295,14 +5303,6 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
-	}
-
 	phylink_mac_change(priv->phylink, true);
 
 	netif_device_attach(ndev);
-- 
2.17.1

