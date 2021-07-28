Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07893D8D22
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhG1LwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:18 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:21025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236224AbhG1LwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+i5utCaFlDf/PfrbZbIBwbOYMtku/fDH41gBdWJPc/D9S5DJZbdDZkHA0+Wd/aitz8lXp2hirD5dyXVaPQ10OVXR3I8fx3nICIEUuBa51I9/sFctONR/V9lMs0u4ZCV7K3vcsLRHV6BCmuNmFt4aCwNy+kcbTx7c0jXy1NEdnQS7BXnEDHNfjqGharnafkwCmSXFXox2yUvxMlO/NFAZvFHAWXwXPwrc7TzpSYuUD/kbdyWU+dvv0F9zdf7TwP39z9KMiXu4MUEjkueVNv9pcIx4dv7MlODf/Uux8dokpa+XtEV9qoudpMeCH31hjsBa9k4bSbwoLB72/mKthNv0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWVIk4rGK7tmZyZkPUCutgEGfzu8OHcQdN2TY0mq7pE=;
 b=iTTM6QQ9So1IBlccVU+cuRl98XGcrSyJ7WQDQJr4a735wfEHy5blVJimEV7PnpRYBJY3SsaqoDlWntyIhM+/U7GEPQnXnkxZn6b74sT5+pJodGuhijlXIyJoBvrtBb3C8usjIjO39iKhAUnc6rwdSa7nE6jc28GjWxMVeOQCPg6VOsDfrhsBT/fyJ8V9hnVxE6OIxvP0wfliyGoMz05E5RTIY5eScB6VN5cPFsQcWYRJN4Z6r5AR/IFN0qHJMwZELv7Sn/W4c2gX6/ur0Kef/bGSYwWNmSpi3+55rB0focUuQMLGs+uOCjU2gZ9qirKzEKQPZIGraQfZFORH+fykbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWVIk4rGK7tmZyZkPUCutgEGfzu8OHcQdN2TY0mq7pE=;
 b=cUijFQAhiBgrZNmU2/vxHym/6wiYhBS11P8ua8Tjq3DDT2kIWg8MLSLBdGttlB7q/On5LDdelsGeciyAaclZ6eYNJjGMKm0acFw2PjczFtA/2smY8zEAYCKLZCam67lGzf/arTwbUYpdSEkyhQg9g0sShsN4AlsbhO33TSCtgS0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:52:08 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 4/7] net: fec: add eee mode tx lpi support
Date:   Wed, 28 Jul 2021 19:52:00 +0800
Message-Id: <20210728115203.16263-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:52:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bf5a178-e7ab-4c37-dcdc-08d951be20cf
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB309462AE5E5B9BE41DD05188E6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hweyQkdnKQO2TVb7n8XXW69SfOVtGvAei3RiTMf7ir0jVaGTHg2JZ/TQCYD0vqVFs3EzXhXw3xg2monJiZf+851iReQ8PZFuI+ZMTYg6yazzG03COm8hY5nWpgiIxqI0lB2hW6gOxnFrQR5fwd3Zm0gXd/hkPDlXoNiKA8wEGi8mv4+gFBoN+7uZM0Mzk+CJXphsO2BZb1YmzwHTbr4eDgujCH4Cp1eGVJvthFTrkXIPikPiCuxN1Xf99puNBwV41UJR4899Z+6hUax62zXjnoIsQUecBTto/YBOfW0CG9CpeCwdD4kIDCvWdKZqVgwA1C4/C/rGcxByrBnvd9xx+vEB+E+3hGxnjbt5lwtTGKdWJEOA6/CAPtFTiO2ZrCXX2FVdnQNODSdFHi6T8ukIris0UIVnhOO9Sxpi2eJh2QxmcnpEA/+zAXO64s1EX5Ik8PERHBKV5HIU7xfPZoeUswroUBFZPj28O6a05nYsdzdWY7xo7hCSxS6CYi1zfu/p6WI8IYsODhs35+Wlk3Bx7TZZWHitSWO019ieTxECTCJy3JRycG6N0tMfAeKEVxwQjgM4Uhli6RlQzMg8j2nKHHQ8SaJfV8MDohy1f2p8J5KbGNQ6k0XZ5yc6FzgLymdxGqqwTeezKw7UyHyT9XQhc5aDf1KbmcxmcIxsaL9fG9s13hj68wzoby8o+WcyYoYcIgOZxQpiXONjiq/PKKYOkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(6666004)(26005)(2906002)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(83380400001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Guvx4RjJoaSrp9VdSCXaZZpQtTK8yLsdSWakS6Ind9nG+y5a0CR0GW6pgk8G?=
 =?us-ascii?Q?hLy/qYGXuTkqWnimmtie2mbFOo0Qh/dz1sU0Vxofl44P21HE6JdJ2/v2QLyh?=
 =?us-ascii?Q?tC0bhzrFL8/wSb/xcJ4a13D5P/uPcBZsbokotmqo3sMS0gZarpGIR+rHCvkw?=
 =?us-ascii?Q?h0baPwnb6S+ZYqg7m9pqlKTQ3urtyUOVBjFglyOl2rQOFoR3vb1MDs9rt7VD?=
 =?us-ascii?Q?FrYTb578Epqbz2cFYaYst4P3Nsu+ywI1Hj1uxFe/Z49SAH7BwCs1y0ewwKFM?=
 =?us-ascii?Q?ITgWfdgpXzFj3/3sO2DsJvmxeCnMq93w5qWP6C8EZwOd9/0HXUoKa3nlRCLz?=
 =?us-ascii?Q?KdepwZFXLYm57EPIo2E2mNiZre4md6UevXmzq+aCCMyM+4LlyzrDkMdGwe4A?=
 =?us-ascii?Q?D0MktEDvacyIYVNga0zgvE9d5CzMfvbGx4YHwiECV4geACg40DvulL5gMJ+6?=
 =?us-ascii?Q?uJRsB8CZ+HURw9pGU8NIeOlPzZ+0DmeOAtMYfJOjVaToZlybHq2rHX2NUEzK?=
 =?us-ascii?Q?gyu4NX4rx+UtJdl6T6CSCVdxZWDMqsgn1RmAdKoQec6BVkNdXVG3sbMQ5lQX?=
 =?us-ascii?Q?YMmHBVX4a8tSyj1JnUEodM0WJPQc3Fx4I5cniHtgfPyQmib1xQch6fNXP04s?=
 =?us-ascii?Q?Y9ECaj8PY8tY8i+eMUdLJCsMxz9gJquy18wmVnNnyaWr9cH57UAaJzqnJky4?=
 =?us-ascii?Q?omZ1EHQVpvuYqTwabGOG3c9MzDxmokd9lsDbVvrgk3P/G4E7vzVwhITSJ7NH?=
 =?us-ascii?Q?4RgN9EngUF+lHTuvsILLN4miYbgoXXK0HxzfwzoSRZEv0hn4KW9p/+AhqalT?=
 =?us-ascii?Q?Ylzfvfz73Hm3IRu+/dBEG8iAsyzrOTEQQxnD8swlPcXV2+qnl93zX7VyOnLs?=
 =?us-ascii?Q?yk+/d7OruUBnNpQAhDB8jrl4YofX9l5RRCapAtmRtjd4yDxuSwa3H5XkOAve?=
 =?us-ascii?Q?xyTSu61PFowR0+ql1aM5E3ykATWSOJzVzY6/U0GYWo1N6RobctXl8+dRBTon?=
 =?us-ascii?Q?gSY3EN2oBLT0o+neQ+LVt9F8MtJYfNElX29pg4a5u/v0LR8zYFLr7EVbsq3e?=
 =?us-ascii?Q?Q4cIP8o2NndiPuAJrMEbSMepD2tNkRBvHv2EZfsLJHfHJFCaZWyQ1lWBJVKd?=
 =?us-ascii?Q?Pm+xAgIFrw6A/YVgBMMDMCKyEF/zv/FcK3yqJXbsx9QL//+fFxSOEsiIMC7F?=
 =?us-ascii?Q?wZ2ztCCrEPeLh/ifyI/9CfLzjK99SnH/z3yhRPJL5IeTTBmFCfMjUHq3f4OA?=
 =?us-ascii?Q?z74I8VnngynFEawqYZxjft7J3PPrpTRV+ocCVe0EbVGjiEiQWGMZ4u/WQx/K?=
 =?us-ascii?Q?f6GucvDQOi47wQZg9MezohDX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf5a178-e7ab-4c37-dcdc-08d951be20cf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:08.7726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RI7JN5E+bTCBGRsQ2hKbVHmH5MEDboUeM4487BoEv6O5RX0x1NWApU8KNxnnSJgyHrgm3cTnHHbgdjcbebz2Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The i.MX8MQ ENET version support IEEE802.3az eee mode, add
eee mode tx lpi enable to support ethtool interface.

usage:
1. set sleep and wake timer to 5ms:
ethtool --set-eee eth0 eee on tx-lpi on tx-timer 5000
2. check the eee mode:
~# ethtool --show-eee eth0
EEE Settings for eth0:
        EEE status: enabled - active
        Tx LPI: 5000 (us)
        Supported EEE link modes:  100baseT/Full
                                   1000baseT/Full
        Advertised EEE link modes:  100baseT/Full
                                    1000baseT/Full
        Link partner advertised EEE link modes:  100baseT/Full

Note: For realtime case and IEEE1588 ptp case, it should disable
EEE mode.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  6 ++
 drivers/net/ethernet/freescale/fec_main.c | 89 +++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index c1f93aa79d63..0a741bc440e4 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -77,6 +77,8 @@
 #define FEC_R_DES_ACTIVE_2	0x1e8 /* Rx descriptor active for ring 2 */
 #define FEC_X_DES_ACTIVE_2	0x1ec /* Tx descriptor active for ring 2 */
 #define FEC_QOS_SCHEME		0x1f0 /* Set multi queues Qos scheme */
+#define FEC_LPI_SLEEP		0x1f4 /* Set IEEE802.3az LPI Sleep Ts time */
+#define FEC_LPI_WAKE		0x1f8 /* Set IEEE802.3az LPI Wake Tw time */
 #define FEC_MIIGSK_CFGR		0x300 /* MIIGSK Configuration reg */
 #define FEC_MIIGSK_ENR		0x308 /* MIIGSK Enable reg */
 
@@ -602,6 +604,10 @@ struct fec_enet_private {
 	unsigned int tx_time_itr;
 	unsigned int itr_clk_rate;
 
+	/* tx lpi eee mode */
+	struct ethtool_eee eee;
+	unsigned int clk_ref_rate;
+
 	u32 rx_copybreak;
 
 	/* ptp clock period in ns*/
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d9ba9d6f7af7..f13a9da180a2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2722,6 +2722,92 @@ static int fec_enet_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
+/* LPI Sleep Ts count base on tx clk (clk_ref).
+ * The lpi sleep cnt value = X us / (cycle_ns).
+ */
+static int fec_enet_us_to_tx_cycle(struct net_device *ndev, int us)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	return us * (fep->clk_ref_rate / 1000) / 1000;
+}
+
+static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct ethtool_eee *p = &fep->eee;
+	unsigned int sleep_cycle, wake_cycle;
+	int ret = 0;
+
+	if (enable) {
+		ret = phy_init_eee(ndev->phydev, 0);
+		if (ret)
+			return ret;
+
+		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
+		wake_cycle = sleep_cycle;
+	} else {
+		sleep_cycle = 0;
+		wake_cycle = 0;
+	}
+
+	p->tx_lpi_enabled = enable;
+	p->eee_enabled = enable;
+	p->eee_active = enable;
+
+	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
+	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
+
+	return 0;
+}
+
+static int
+fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct ethtool_eee *p = &fep->eee;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
+		return -EOPNOTSUPP;
+
+	if (!netif_running(ndev))
+		return -ENETDOWN;
+
+	edata->eee_enabled = p->eee_enabled;
+	edata->eee_active = p->eee_active;
+	edata->tx_lpi_timer = p->tx_lpi_timer;
+	edata->tx_lpi_enabled = p->tx_lpi_enabled;
+
+	return phy_ethtool_get_eee(ndev->phydev, edata);
+}
+
+static int
+fec_enet_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct ethtool_eee *p = &fep->eee;
+	int ret = 0;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_EEE))
+		return -EOPNOTSUPP;
+
+	if (!netif_running(ndev))
+		return -ENETDOWN;
+
+	p->tx_lpi_timer = edata->tx_lpi_timer;
+
+	if (!edata->eee_enabled || !edata->tx_lpi_enabled ||
+	    !edata->tx_lpi_timer)
+		ret = fec_enet_eee_mode_set(ndev, false);
+	else
+		ret = fec_enet_eee_mode_set(ndev, true);
+
+	if (ret)
+		return ret;
+
+	return phy_ethtool_set_eee(ndev->phydev, edata);
+}
+
 static void
 fec_enet_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
@@ -2782,6 +2868,8 @@ static const struct ethtool_ops fec_enet_ethtool_ops = {
 	.set_tunable		= fec_enet_set_tunable,
 	.get_wol		= fec_enet_get_wol,
 	.set_wol		= fec_enet_set_wol,
+	.get_eee		= fec_enet_get_eee,
+	.set_eee		= fec_enet_set_eee,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.self_test		= net_selftest,
@@ -3722,6 +3810,7 @@ fec_probe(struct platform_device *pdev)
 	fep->clk_ref = devm_clk_get(&pdev->dev, "enet_clk_ref");
 	if (IS_ERR(fep->clk_ref))
 		fep->clk_ref = NULL;
+	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
 	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
-- 
2.17.1

