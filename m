Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2938324F80
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhBYLwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:52:08 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:2291
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234220AbhBYLvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:51:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPA0eoHjM0N9eBMtGZ9sBFYT3O2Y+tkmk0wQoxEzNyRMgT1xUFXzy7F4YdRV7KD2fLI8Kr1FimMp+jNcuBfgWqdTSRUFMtHiIoOWoQGbxognTscLpuf3IAQaQ485mPL1844x+JtgaUSCowtOtjnyxqNolREZ+JIbCUqf63/15YEx9acg9WVcd3ic1ZjRjOEc1wAZHUnHx2bOfJ+AJncB6Rkvd1/gBCv90C3Xi+/HbTa3BqVFg/IU3xJiHwsy1s+FNED7BwgLuICAsFxpukyVZz5Oildhizxfcj8PtgKeBi27pwO3cudUbcjQz/NViY24Nc0qsD0OH+als9+G8B1E3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yvUqb5sKoKex3qpJ2yF6douJVHof3i8VukA/lxouo=;
 b=TBsCvANWQW3s8ou2wUHRbS+jtbwh649Fd1sL721KiN1sDx5zHhFT9TtiLXe25ZYq39IFoEJp1sUhI2YKtEEkqaZd/xYI3mL1d1fzdPXbuJ5EmMq4nAzanozbO+Lxmf+H0EJjK3QTVrI8DG9B1m4UdLZ4xaTe8H7QRLYz5QRSI14v4WlZHcU/25D9IQ2p9MGWT9/rGCC/1b9quGSBxhwCihadoWCeKNxNFqeeQPs8aYKV5qpIBsLIczBm/mdg12e97Rs8zJQmHQ/6jisrFPyiFFfS/0ECNs+aO2k2zYDGHCt3CFOa03OsTLGg+XwTXNWt7Sr5HeCu/voJRdiYVV/j0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yvUqb5sKoKex3qpJ2yF6douJVHof3i8VukA/lxouo=;
 b=NDpIpiwVsf8rEReF4ue7ZQziPKfICTUzcHRdGUFeQxqQTcko7CWtOwWDpOwNDzoX/osT9vsK4YcyI2NKmxvaOn2yEC9BfPOlVIiQNBssBW7u35ENxqnFzWUZukYXY7INYQSkQxkzonvYWwDRFHS5r8buzovx0Iv1e5uPX4GRktM=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5132.eurprd04.prod.outlook.com (2603:10a6:10:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 11:50:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 11:50:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 net-next 2/3] net: stmmac: add platform level clocks management
Date:   Thu, 25 Feb 2021 19:50:49 +0800
Message-Id: <20210225115050.23971-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
References: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 11:50:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10f399e0-fc19-4bb3-cc74-08d8d9838eed
X-MS-TrafficTypeDiagnostic: DB7PR04MB5132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB513233D174155A0775D91C7EE69E9@DB7PR04MB5132.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgaWJhrnYq71ujpf/FYlYd6Qmb/cv3RLeuH3jLHrF7ywN8YFE6HsBD8RwI+OsAegA9Dx8sSuiefrfAzK9bgTZpytHs9wOKs5lNhuG8xxrWbAAFFY/hjwwyJ58m0/7R8f/i92JUh6owSllsUKxVcvj6HqxIsXpObhI3J1/nQmmHEM3OicQXq8cO8P/u9inr6OvUKol02Vq/LCZgTcsglKdyWLE5mW+T7+WRvLmX043DxGOZx7rgUzgzs6PkKLJ7TukuB5C7ulO2qDtvjZqaOZnJh9C9xlej2SMdToaIys2d2TT2qbXGwu9TAVBBIn4y94WyEhQdVLeP7OZJHzterVh4TwlqC/vs2rPUwgynL8exa3bAbb/WGtdVokrfdh1wxOozND1DTwOX2kUNAKDnwFvk3gGgoPx4kjmh1Y9XA1kJmS89kf24ZOOeOS5yYqjmcQztRqwTfBI1O6saLUN79ngYMo6CJ/uzBBWl6JOrvZ1AWKi7UzEZUpeUb1AFG/VX+kacGBdSXtEeHxlnaWQK1XS3CNf8MRYQlVwP3qsaNQRE77n96QDP6FLO/tYSkY2Hc0HRcUVnxPWJpGqPHEmwlsDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(8676002)(6486002)(6512007)(186003)(26005)(316002)(5660300002)(69590400012)(1076003)(52116002)(36756003)(16526019)(8936002)(478600001)(6666004)(83380400001)(956004)(6506007)(2906002)(86362001)(66946007)(4326008)(2616005)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9Zz9sErMo9Kqj3zsVt0uXtry0tH02OWjkismJ3ol0Ieb2eqpHl+QwvxERr90?=
 =?us-ascii?Q?F0yHRg2MG+TFGrUWdvhQuOjKw3a650Od+XyvqoiZZhwcMvFVV1OBxv8J7Zw1?=
 =?us-ascii?Q?d4AzWsv3ZH1Qkjl4t4tymcURfTeo1bWnhNJ7F8AsUGCI6k80PoEw2mxnfQjB?=
 =?us-ascii?Q?WcTtrj45fq+ETszp4y2VhwWbEQ4hw67DfAyRw7zfIRW9tkRSMwNJRAc7ikEa?=
 =?us-ascii?Q?tGt0ol+QADr3et2MXVErEn+tL0GN71JFkZDLDi6C1a9VC5ir60LvB1s+6tTG?=
 =?us-ascii?Q?BT1MBHqhD01XaB93pUwGROPc9UCP2EJPJkZw5O+AXSL2+OwXwdkrMwMmnJVU?=
 =?us-ascii?Q?H4XNuwEjoB3L9jIvkP2wc4Ng0XbT1h5UGHwxu+DmZP/EXOaDIP8QH1dH2Hq7?=
 =?us-ascii?Q?ceqnPev+s0kCfuhZ40sF0+sPfKnNc28xJAF/zllUbpXV6sR3fTvfrIIUXKJ3?=
 =?us-ascii?Q?+Y9JrlfvTyhKPhRl+7Bba0tcgbxXCRo9+sCe71Ba+EGiFV8AoDTGuvmTAoM4?=
 =?us-ascii?Q?TkR0gjx4OthL/2NDUiRjCegnN52rAMpT45rW88w5qC3mamvgvZ3Z4UJ4KfCf?=
 =?us-ascii?Q?UucwvNNYfjDaa0ktsF3jocxj8p0IUmSr1V6Qd01jQQouTUCaHdHM9NZOIMwm?=
 =?us-ascii?Q?SkMcqK5HyI1nF+BaA82LvBaYnIjnJcfSRSjWkaKzuXNP28nvXyQBft1f7Hhr?=
 =?us-ascii?Q?5pA81iNUZcelkEe3zq0LLsIhkqSFIOkPMemuf8h8nNyOV8beLRg0/rWIwI8i?=
 =?us-ascii?Q?davEjhVemWRxAuNdKf+L6a0iZoNxMTTvJAXgLhL6OLNGta/L4fYXP/kc2EAl?=
 =?us-ascii?Q?HnVRW1MIxbQAUpTdq+rV6Af0v6lgrifsYgKFFaf0MethF7BHGk5uD0OHCfhm?=
 =?us-ascii?Q?Ddq8R+o9YmEx5AbMaDqyqHHSxB8VmT0Ci4Pz4hnAb9kqQQoY8bTscSONlY3M?=
 =?us-ascii?Q?yHAW35VIdajbN45rKvr9tI8vcpEuyfx9hrOOuTUa9wwQex0HD3qCI/6aNhxx?=
 =?us-ascii?Q?R0Fh1gX0G/CMC4hMW7kcX+PldxAbZ4FDlIPobd9A74SeO754FZ9DYroA9RAg?=
 =?us-ascii?Q?UNejKd5YMrIN16TSX+ejm7rI1XuFC4uFjNJfOCaBa1CU9IjqZYKNZZuq7FYh?=
 =?us-ascii?Q?orFSXCA5fee8v0ndumB/oGtdgqNRk2gyTS9tF/ci0aE4FY6n+VN9YPt+0XV7?=
 =?us-ascii?Q?CAz0OUUtQC7Co4jZuRRfeMtbo+o1BiuhBMAAsX2bjkgEEkJNQYqxGoQZMmpz?=
 =?us-ascii?Q?yE/K6U5uLFHOxb4v9TCmJe3PFcKqriKMkOnGNTRwUGPsfd2EsCsd+6Vlkr96?=
 =?us-ascii?Q?2DKk6GW7kRgLN8L8Ib7T5D94?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f399e0-fc19-4bb3-cc74-08d8d9838eed
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 11:50:33.8003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjK2UNHdeh3pKwn/C3apYMkLlkFQbEqPzmmDBgo9TVy3ybUtiNhAuEz3gaEgTJNCnRKuFyMzP0PBkgllPrvzQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add platform level clocks management. Some
platforms may have their own special clocks, they also need to be
managed dynamically. If you want to manage such clocks, please implement
clks_config callback.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 include/linux/stmmac.h                            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 291f530abada..fb427366a1a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -127,9 +127,19 @@ int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
 			clk_disable_unprepare(priv->plat->stmmac_clk);
 			return ret;
 		}
+		if (priv->plat->clks_config) {
+			ret = priv->plat->clks_config(priv->plat->bsp_priv, enabled);
+			if (ret) {
+				clk_disable_unprepare(priv->plat->stmmac_clk);
+				clk_disable_unprepare(priv->plat->pclk);
+				return ret;
+			}
+		}
 	} else {
 		clk_disable_unprepare(priv->plat->stmmac_clk);
 		clk_disable_unprepare(priv->plat->pclk);
+		if (priv->plat->clks_config)
+			priv->plat->clks_config(priv->plat->bsp_priv, enabled);
 	}
 
 	return ret;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a302982de2d7..5ab2a8138149 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -183,6 +183,7 @@ struct plat_stmmacenet_data {
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
+	int (*clks_config)(void *priv, bool enabled);
 	void *bsp_priv;
 	struct clk *stmmac_clk;
 	struct clk *pclk;
-- 
2.17.1

