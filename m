Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3BD33B25D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCOMRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:17:13 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:1413
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229792AbhCOMQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 08:16:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RP/rEkXb19t+kvFOiCO10F2J15jKsIrnJFXEFikpkFKygh6hpOV4mzwJ/ehoZz7w6BjplRUSWmewl2f4BdUYxNm6QZc98/1RAYf2IxbYoYMkAGbjVio+JRu0qPFsEKA2idRldoIF2jz2iXRE3OYb9YnLpKwzQbAJ29tvSO0JoDc5vOvk6nnAdHFVxLLb2uT/v2/ml856mvJH8y7pNyvClAK+vB4TIlRDbAKeYllvhBZ7ubIZtdu+NeokJQYPMVOCskrYqdQLTX+q9DzjCaXFPxX7CXCCA0lhonPNeJO/ObBtiU4YDEPETceiY0urDBLcm6KW4Ddr1xQ36lIm0ncU3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmgoptAgIIEnXKSf0YLtKOYgrxt9MtcKoHOgrgv3VXU=;
 b=HruELXDkv8FkPDNc7znTIVGLLk2F7/8Qx6eeDnz6nD90iF10QZIidKOmgwDCdcOKea/2iIo3XOpKy7BdQcDHDUtvpa9CzVgtcypWs5CRRyL2yXTGEHvtBDkeTR7YQpauagFg+QZQHAZEWBo9ZyiPM8F8A0Q2PvkK89LccEhp/GJEl77rOqtD2UezexJdAExpDNQTXZaD4y5cCFxEE+SyNTL1T+wW9lZqHCr6P/WCICKTHB9eFLrmSowd51XRWyEuPEW44j1I3qQvC8CyHyc3HSEplZgHTgqP6Yk0nxo8qS7/E0N9gb3gqEp1bFfRI/EI0xQhsnCrVK/Ycf4oOWxH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmgoptAgIIEnXKSf0YLtKOYgrxt9MtcKoHOgrgv3VXU=;
 b=M3hKnhR86wbOEB+90T+k30npvCxw9RUPhoMP+eoRm6wvkjXEVuJNW1Cj+ZUSYe06UG05YuS3O1fG7dv7VTijYwygUJGGfl+mwjibSP9k/olSPsX6p/R45cx+4UBo7nHTv0OwSXyGtO9OtOqNNsklDxNacYwt/cpIDK6WlPFnydg=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 12:16:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 12:16:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 repost net-next 2/3] net: stmmac: add platform level clocks management
Date:   Mon, 15 Mar 2021 20:16:47 +0800
Message-Id: <20210315121648.10408-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210315121648.10408-1-qiangqing.zhang@nxp.com>
References: <20210315121648.10408-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK0PR01CA0058.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK0PR01CA0058.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 12:16:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed54c429-f7ef-4854-fa87-08d8e7ac3320
X-MS-TrafficTypeDiagnostic: DB6PR04MB3206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB3206B4FA00179A541BD6AE1AE66C9@DB6PR04MB3206.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cplBflgOSAuGRtSfM5QkVcPTs4GpI7rJffPMV9XNfjxWNmxe98klM6IzfFtnb3CzhW3S44HUDIaHDlYhF0tYIGRms4dLfWSrSRNWexWH+mIFlkLpNkVMIWMj4oRm67yRHCcG3bqKw5+eF82fzhaVnO8ttd5h6Mz3GdARBGbwMubaqpHuVCnG2CdpbY9ivLBQv+K3YrM7i+BVVivkBa3/mVDfrSdlM2AVjSKiWQs/C3w2jxjm2MqULGdP/i6P8eJGOhiMaQThseMQ2WqMhMhLWRFUaV/JmmFuzP2UKoP6s4a+qJXs8XyrKpM2qCiz6MDit3NO1qWBZ3yOl64YVxSMg4w+WkoCi6G6BMD1SA1ogV9ppAd/THRVy6iU/ufakfGDGOvmAz74sSEioZmPPIl/rT6eXMGe0x3AFRYIwQ4yj9INngcM/2p1zAljNQS93Tc1PqbTgHQCDFhhyEFE+aMWaNpSc2J8TStfIPfaJ0AenGlmrjHnnmlpT9/vkzQqr63x487Eq/4xK5DeecKsS5tvibWlMIqw5hZh/VyzU8TD2l30sm8ZQV9n+BVki79i6m0cH1KIqBSUJHs5RmC/AH+vSggewfqTBRNWaJaoAii//IUkj/UBbIgGJ6uqawFvD7GL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(4326008)(316002)(6486002)(2616005)(5660300002)(8936002)(1076003)(186003)(2906002)(16526019)(6506007)(6512007)(8676002)(478600001)(26005)(956004)(52116002)(66476007)(36756003)(86362001)(83380400001)(66946007)(66556008)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6iOANyazB2M9xTTy5p01b+II4pZ47NQfXwgRjWEYgj6GdAy73v/ioplXoV61?=
 =?us-ascii?Q?+tITs+RmHQVdz4XLaAjaqPgY7ajl9p+rTinmrHVOQtmPW2v3ZdkkE8U2P2Nw?=
 =?us-ascii?Q?tXwFSYDNd89CvDQN6qXnJHm1NYc4jRl43anXTTU7q+tYe5ooUjvhjA7fOE8I?=
 =?us-ascii?Q?BGSG7ZV7rY/L8KfQEPpxTsxnToloWceFpURsyqB/lH+LGdVNx8ab/cwx+nOS?=
 =?us-ascii?Q?wKD9/f2I1w0sFkzHpwz3YW7sc7eIMBk+zbG0prJGsVaL+XXsvyg5fxivRky0?=
 =?us-ascii?Q?am3+TsvMECtq5uhXanwx3Ng7CEMiAUGuerHzPNHNvwjpPJcdnFL/HVZghXF4?=
 =?us-ascii?Q?ESxn1RrZhbUc8iVkiqUfhVDJsXMqSDq8X9mGTcT0n8EZA0bqTgYX2caxL5s1?=
 =?us-ascii?Q?BAnI5fPbfcLx2euXb5zRCr48FKeMVYi16PxZgMZlGoR+gL1RhObh2NQD3aPn?=
 =?us-ascii?Q?9obXAkuF8pAj0zOZskJJNt0rDDPfPV5vHbz1y1ywfPrGuwMuHdOGTyNSumVg?=
 =?us-ascii?Q?knlWvPwr23f0na7e0REMv9gbv0eg2W5O7QJTM/PhLP86UtI+egLMMQWeCuPX?=
 =?us-ascii?Q?4ZIsFDtqkzgFCyxjIM2sv3hXqsD2SfPxNOP7Wanp3cliEhPUc2S41QlDsyOn?=
 =?us-ascii?Q?LUODEokGinQX6SkRq1t9sBrTj5Y2wqL8p2JqHFGsLg2ZXrZom39XJdrzLLCK?=
 =?us-ascii?Q?qvtF9Teyy4nl9nDPJlOD9SSAHTTB/i3HciSUhydKmnBslUAAnuty3ksqWshy?=
 =?us-ascii?Q?fXfVvN7jt6YlCuqjJI8r26fKFpm3L7mCfr0FU3pyBrq9G/VaMxexcCXL8NUY?=
 =?us-ascii?Q?K4N6HMNpeXLP4OXqTQj4is9XCGOqXaeXDypaJTUqwXxJfCFJQFoyC+4BNTVh?=
 =?us-ascii?Q?poSRvYLqgGvDnDc2zaNa/QkdpdEGwn5iVkMsr8TP/YC9xVnZu2eLn5wSH+9Y?=
 =?us-ascii?Q?UFkW9vaM04o9h+9cZzb5P7xV+tqx1ahwIbBRr+19+UzBOqxo+UyKalPL+f3a?=
 =?us-ascii?Q?HlCKEB4jBIRETRIjoVGD9PWu7qZt741tjA4/iZg4Reehk6JSuqOND/EyTXA4?=
 =?us-ascii?Q?cDRRc2kjyhAfwvjdx57N31QqP8WXiAwhgq7BS/nnrHriEE7eI2JzdBG1vvkA?=
 =?us-ascii?Q?WvmYgD00Inxo3YsEvcihG2aq/qeIp4VuGSAN/4T23oi60yCeAHEOhY8zg4RA?=
 =?us-ascii?Q?DxPIBo0/IxXS+fyy/i+IxtEa+RCv/PntjG7YplAY4d6LPpnymQAjofDf0CSD?=
 =?us-ascii?Q?OzFXeXRbpg9VJuvabyQ7sLb00Qn/Zct4iQoyfYBsvw5CJOSbDpVeioqbjhh/?=
 =?us-ascii?Q?PRQfx0arsT7xonGRyw5b3TVl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed54c429-f7ef-4854-fa87-08d8e7ac3320
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 12:16:45.2419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAQXxuLZt5/lSOklGC5wuTnhcMj310FPdJSb27LV86LOoztu9TvrYkbtR3BEEBgi6BwlDOvC1awck8Vbh+8O1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
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
index 2a80db92e731..b2c64c5dabde 100644
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

