Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE62632C41F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhCDALY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:24 -0500
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:31648
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1357058AbhCCKsw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:48:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNeXhqLzF/qPQxGBjo6t35DoMcuZnIlTJ1liluW62ibpBytrkBdHdKS5la3eBpPZhr9gc1WrVHI8CQnVnm0OoCPUeDN+BBHG7K91FXTDsWB5AbLFTKPtI5UoYBrBgoI9eZkOwRQFhOs0MYEKfIxz2w/tV5V1H0YYXRTQfMkOpI0Ph1Kx7bMAzim4EFCaeO4M7hDCjGEZNuXzlWNiPg0RowYMtwFBYkZlXDCKlf4rlLqt393EMlJHiagfoDufQ/K9mFi2Jn60JH91Uo2x5LI9oz+2Kw5lmuAhJpg8aneDsEz4qn+tF0Dr61eOYOERH1QDI+lbBj8LUaCeqIYgwdmmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kC9EJYyDMcio9Lx8rw2jwUL0nOcStuL9+wPWZpJ/hY4=;
 b=PGAKp4xjwrbos6GG/v0mHuYyS9Ouxu3MMS9sqGjt/p5UhXdsfby8hJW8BJ4cxX8QFhRnZ4Ma44+EEB89MKfwfi2JjxEHoDBeDlTr83sxZdnFvQVihZdzAJf39RdXW1syPGcvwIZvz3xKD32UIXNBiy0Ttwq5Htuf0CRCdyPpArtRmNqtEt8H0UQRboAllt1ncyLIHLhldKJQJj2BG5pfV8dYSX1mUSvTYpx1lspK0EnuMZ3irRivt2kXpm+ZxPMZksjvlsoCrb4WQ5QjreAetKkyooJuf/hpwzA9O7dYvjHaDrXvsYwgKl7PcuJfUQUWc+ga6lMnXooKcQBZpvDvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kC9EJYyDMcio9Lx8rw2jwUL0nOcStuL9+wPWZpJ/hY4=;
 b=f28p2+1o9kqivmVcbzyf3ENehsCK24YS9+BGrNKW+hXYHlWbW1HbrfEabL6oIQb7W76obn7AXjaZttwPjM4upaKEnvzeXHaIZquWWVb3OSN04T3bMfQCDzx33wpqoDNbcig+cxduUm3ho9ElDv1FdSeoKlmamPuTFegOgtipbu8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6252.eurprd04.prod.outlook.com (2603:10a6:10:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 3 Mar
 2021 10:47:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 10:47:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [RFC V3 net-next 2/3] net: stmmac: add platform level clocks management
Date:   Wed,  3 Mar 2021 18:47:23 +0800
Message-Id: <20210303104724.1316-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
References: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0068.apcprd04.prod.outlook.com
 (2603:1096:202:15::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0068.apcprd04.prod.outlook.com (2603:1096:202:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 10:47:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7016c38d-8402-4cae-50ea-08d8de31bdd2
X-MS-TrafficTypeDiagnostic: DBBPR04MB6252:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB625224585879172778269165E6989@DBBPR04MB6252.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ndT4ZsZcpw5b163GE6BBiQvuXV1g0scAu11Qx5jn9HoGZNoiWmKVe8biRKP9gcwDqgxfe73gE4AIYrptlJ98NS6ljAIL9yNBFR3Fs7oJbMBBvRYDRofy2Amu3YhlujZBeJD1mPiVfaC03b736BiVG8n1/OamKnahA1kww9kgsDG/lwlLHKBcZMoHEsUImUWUfCOgqEtHFfJcXwD4ipq4I2R205zMUauiRQadgIv8FkOqBwV0nkCEX8k3rOwX8q+S4pH6mWq61ZmmGxqKrfD4BDHzn6gQG30K64HsZemp02roRuCIG0mfOT8tGvmzFZgS2pDM+9wEb+ax1oUe/XJNDHwVguU5pcGy2ubTCMcQxt1JFHqbU4wssvTHS22tbI3rtPyO359z2VzfMxRNYYAeS+2yZL4MRvZabEOKhoFTB4Xcd9Ie5AuMGWD+2PE2thaokJbiENF4hvLPteTa83cb3jwQgKcp2djOK37tTE93nBUZffMjLRQDhZ9qWBSabH61/KCAs/8iQmhrF9++LSHXuiZL6+CiFRnn/3G1gtNjyX+Rt6HYEQ2KXStI+uuCb+YDlBPra6PVFsTrQIC2q/DrxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(478600001)(956004)(316002)(6486002)(66946007)(66556008)(16526019)(186003)(2616005)(26005)(66476007)(8936002)(2906002)(4326008)(8676002)(52116002)(5660300002)(36756003)(6512007)(6666004)(83380400001)(86362001)(1076003)(6506007)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6q4XvazaXN3Q/XfSI5EmmXQeWrV8+CsLNNuM8JI8gsefxyMTEOEEiSmCJBnJ?=
 =?us-ascii?Q?mVlNqOIesOWv4CX1mPSWE6dj47pT1f/VtcppS3TJxtN8J3TGqeKH4CoZvoC4?=
 =?us-ascii?Q?/ea0+C5UR+r/B4iEwVl8FINgooKhZDPItxFIzovnUXEYziQRlQBxiStrZyyP?=
 =?us-ascii?Q?UTS38d5IN9p9XwIPNQ4Ni/TJDKHcPYKOWkj2RrkTqTQ9n+gjDpWBX8u/TEU8?=
 =?us-ascii?Q?e23CCtirYhrltSu4fSWi4y0Zwdv8bEo+wmMUr8/i9a1abpWgm9nDzC1v0zgU?=
 =?us-ascii?Q?d5pTgYlMITf59tXbC0TBF/RzNm2xxNr764ZuJ9GRKEAf63B4oIO9Z2HO9Wwq?=
 =?us-ascii?Q?Tw5ogtRhyB69LrlqqRgivjZSjE1Z/YK92cB6XbtHIwAuOxfBfTXkzcvwOxBq?=
 =?us-ascii?Q?/u6/lovnN0kfBG5DRE4kNb9bc0nzAFM0SjVHIc7XTQQkFBscq1ilJ0bH0umX?=
 =?us-ascii?Q?bbwxk5qkqu9uxXF8aB7Cyj6+hhn5Nh+lIkRULSLaz8shJRu17fiNKL/dYApm?=
 =?us-ascii?Q?d3pHxaQwRACQlEyllS/XM9zWiTihujdOxxgUUIhAoPLEK6ItzTGyhSsSYuKW?=
 =?us-ascii?Q?bdMrsEwYNlltFM10oR9xk1oS5crOjMCW78cQM1hIx9ncpus9SN0If0Yd2upW?=
 =?us-ascii?Q?t/TcJeb5cOETETEqQTLP2xQCUDKa6ZN76GttQa+IShI4d/zKbIMWCDxp2Je0?=
 =?us-ascii?Q?/OYZVLzfpBj5u1WYEA5YdnOxjtlI1Exf1bld4l8t1MBEdIqG+WK5XlaZcb11?=
 =?us-ascii?Q?16Q+6MX7y4pf4xRMdjpGVzpPAwrxoGXogq2y2GDsNLvSvkSSjsd8GuMpyPTT?=
 =?us-ascii?Q?LHgdSkMhkj7UxPa7RJCpRv9+yWsSdXGsACfBL7pw5FBnqcO8SfRg0Zf3VMAC?=
 =?us-ascii?Q?s99WC19i43+dPlTxVLsWOra+2VmL2vcfM5OkykQoa4m7p+9/DqAA2nwbGdtS?=
 =?us-ascii?Q?YAHAin5L+7GBu0Dn32VTS7hpjc0P5bYIDjfySAvdY7RZJ+ua75yrRy1Y6S32?=
 =?us-ascii?Q?ZeAzLuKI5kt4XJzHHyx1miGdRYrtz3x0nFy7mqkc6+aThw21iMdevYAXIp5q?=
 =?us-ascii?Q?WsNWt/CxBLnAQlvD3ApVg4yL+V6JKMgGXfnr8SAl+y908pzlZT9KDtHlYcDC?=
 =?us-ascii?Q?FecwzTu/poCY9mQefV8iCCAiuZonMlq0h9Jq+RLXV3GODX5IqKvaVM3sEOtj?=
 =?us-ascii?Q?2pjkjNDtG5h/sNGEISm1IKbPDc36qmjkcdW8+nblKH/SAlkz6406VZTrY9rY?=
 =?us-ascii?Q?N/elue+fhwIycLFc1NXsTsWYGoGNK5jMKPmdMDv7m6cEnDDj14L3BDN9AtPe?=
 =?us-ascii?Q?YtVe6SuPI8uP96JsEgKZRHr1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7016c38d-8402-4cae-50ea-08d8de31bdd2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:47:29.3819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BamGeMQlFg7kFjk/2OgTaJUg58jUc/fvakFJqtpjibBgOd3uo0GbmycecT7SLW1GPmUVEwIGyDeiCNCf326MfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add platform level clocks management. Some
platforms may have their own special clocks, they also need to be
managed dynamically. If you want to manage such clocks, please implement
clks_config callback.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 include/linux/stmmac.h                            |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b4bc1c2104df..33b0783de270 100644
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

