Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9A83C20B1
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGIIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:42 -0400
Received: from mail-db8eur05on2087.outbound.protection.outlook.com ([40.107.20.87]:56129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231684AbhGIIUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cib67fFCnDdxa3EbJOw+jShiPuIJasNDvs/JHlsh2vmaj+8UKm2hubuaJcr5UpN6xaVFKVpDAslZ5wuO8jjmE2KTJY+Dze/fGcx2U6wSqWCXNMdJYKYNsdoOqRHQW9e6QzuYImjJ/joxDP8KV1Fdr6MxAKy9GNsGxDwNe0Wpcy6jjhV1dVIDrBb/0OmgK0EmXoZYEKSh36SbUXfBViAHKsQ5g9tnT0vEZwSNXkStSLzhIO9gQlMOsZbN7IlgFEJ26KNeBnfMGTX1hFfxg5XFeJTYl9ccER6E45jtOhmMIY9nE4gBs7/D2rSZ2pcPxv45+8JzzjHQ9udhi3oZuIOfew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/lfHjh69y4ElIGDzDssEW85yMAGE7V4j6ojsyR+3I0=;
 b=IaMaS5rB69e+sfZQU+0jFOmYBukG9cxUAoTKiJA731i3+kPqyTLQ6TLP6IUYFaJtG0OZI8JfAzegxfn//o+BaJGU1+WU952B4BTURmwQuvxfjt088PFGmfILm3hDVVqJic2L8rWu1bYpmZ6JDQW7XfpofpP9unOmtC9hSsMW+RLaXGCIHNyGiAt5b/e0ltdJ5yHfs5P+2G+dxuWadCUT482M2zKjJMDA3E7pv1eNdsyZl1S8dFkmD8H9dGGDBKI9r4oRUZvTvKcYAO3IRCiSQkq1xx4h+HU+hr1ZXTnDdxiM5qtBsYfcXFSirhtfrAb02P/r7PKmOqNiuZ2i1N4pNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/lfHjh69y4ElIGDzDssEW85yMAGE7V4j6ojsyR+3I0=;
 b=eyd34yOyYKvUFRqOsrqU6aixVqrntIbpu5vezwuMWn9XN9CPVkA3FaLAd7i5KjAQ9KGRZ6Ni11c+xkBhwuxhkf8RwpbU6Z6Vz+zJ2zRaGWfwrNRHo4MaUzdlQgq0E3F9h5CwmJAf61WWCZetADCsgAsKx1vcJgyga9VgghYPjI0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7240.eurprd04.prod.outlook.com (2603:10a6:10:1af::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 08:17:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 4/5] net: fec: add eee mode tx lpi support
Date:   Fri,  9 Jul 2021 16:18:22 +0800
Message-Id: <20210709081823.18696-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e36afef-77f9-46dc-4e74-08d942b20d84
X-MS-TrafficTypeDiagnostic: DBAPR04MB7240:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7240F1213B36A183EB0509F7E6189@DBAPR04MB7240.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S8JuY7D5p6LjwKSJhX8+CO4Uzueob6NXovwdBAYgk4bu6OYzVeZAviWsMY8P8JU7nMqKp8LDssITIIQ/k74HQnz4Ro/b1BmKSiDXGIarorxBSJl4yJorjdfueJMHpHw7A9HOSabQUeMAUI/HLTvYchi8gFSg1QJgydcphcD98xMUIiB91Ml05Rc+1LDCBm2TsziOjzg7C/PSZxNVT0EUMVyVyolsQ9F+sKedsu3rvzGd3VFBD2z++/Q/Dkk8J5tfx/8+jZ6N4LLOfpED1KErXmuZZ4uahdzkHmjaHsxCQyaslso9h/8vcz4kdDQd1JWQMK1YXpNRnZLMm8MatH3XVNYkpepcqGU7EAC7P00WVe7/4ZQB+zk58ohlIQYv5tZnDve91NWnRQs3suig+mcndRoz2ei6gPPGmlohk8i8uEl/ZmXwPWsxOX1bwsIZOGNvPurfjZnMuvRMPifD38QSaNpoGnjs3LKfQGZtQKoRmcCpBT7LxjJdzJQuZV0pvt9MfOD0eTdyyScXUt81nsPkIvvMAeG0ikXkeawTciRMfA2nwgeSoeyESoA/5kRvivLMT8s4lMN59c7xU5JeoGlOg98Xgeaa4AX3kDbwc1NBsFWBlTOUmfmvC9raGqgu3QbZvdfaurVgWBm7dXvsAhbToHs96u64AzBEVUXzxVUY36UgHcurugEOy2++RkoVvEt8fG7/vLc85q+26FoyQ/oB+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(38100700002)(38350700002)(52116002)(6506007)(26005)(86362001)(186003)(83380400001)(36756003)(5660300002)(2616005)(8676002)(6512007)(6666004)(8936002)(66476007)(478600001)(66556008)(316002)(4326008)(956004)(66946007)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4d+Yzh2xvyUhaA9MbFMYptsH0z1OSUa80s5ARyEz2Hb+XbTBVj1/isxZojOR?=
 =?us-ascii?Q?wDH4Io2TYARN4gCY/NMnoSHcbSz1o3ivcUb7eJkPU7OAAYl/0tbytVp9mIIy?=
 =?us-ascii?Q?rBJvzIUzCl0mESuGVAXChyT7u/NsCD30cVvN/88Dafy+rXde4xe/1mxJEULV?=
 =?us-ascii?Q?oPcfNPD6gyQ548jE3Wk53pKlmoEAMpUxJIRvMVtSCAV9x/Qr69R4eXEHJlwN?=
 =?us-ascii?Q?hYuIcOoo0lxvn439ugK3MMEaBFEXEmMPlqDO2REjemG7yOSy+XMm0wU9xUS2?=
 =?us-ascii?Q?10bXqyDe91gsg8sbhWrKqe255QhcbDGFgagjJ9n0RZbyinowuLDjTqMiQ6VN?=
 =?us-ascii?Q?R3vMUiuarpOeXM5BZpEb5s369W6s/+swDD0yqWKtZs+YRoqePYf66nsIXs7d?=
 =?us-ascii?Q?EKiFwemP+leGOnu9WuG50g5HhE4P3Kk4DfuiFrmbBTGzDd4vbfzNNzBrKCPg?=
 =?us-ascii?Q?yrytRWtV616nDU+TQJzG7t5u5LK+T2YzC6nO56YSpwuVtNW4lNytUO1miwOP?=
 =?us-ascii?Q?WxFjszq61wsCRC06dIKuvNKmmaz7eo4vA+r4eCAfnc0LYu4i/PnVItxySwpN?=
 =?us-ascii?Q?53vlMdcRu7QrHTwt/tjijWOcpiDPkj/AEsHATC8m6/k/CYm3bQTl6SA2rYmP?=
 =?us-ascii?Q?UyxlqjIC62H7RAmgQ1gzZWcsyiq8cWHORcMp9IhASdWU812+M6hFjJRaQsL3?=
 =?us-ascii?Q?RI3JNWjdtFgZhJIH7U531apn3iluQYpNkVqM6W4i0KCAk+M9Rr0nd4ksfP8C?=
 =?us-ascii?Q?U9c2PFfaXCEkN22pqF+VKxjJTMVDN/QPC/XtrwPLJSRC1zFGpJAPsO+tDeLU?=
 =?us-ascii?Q?I+3M8UnLVgxZpOE7ea1fcGAJ/iy3Uj2TPjEr3x54tT+UVkUJnWxmWggFlZP/?=
 =?us-ascii?Q?r0teTyIk+dcIh/C4aigQWhmDvPUWUGonF3a2bEbfvwRGoNTF2XIXdZdmA9MG?=
 =?us-ascii?Q?5AQUwAZ3+PPjBLwDoVyXCVsYM0EPl2u0+Q9ulfVLX++olb1iBWBXrWDdcXwd?=
 =?us-ascii?Q?9+oS/QJrscWmDBPXTkY2lfZT6DxhhDvRGei031WZ6RbFVlyk13N09VaYKjRO?=
 =?us-ascii?Q?kClBUc91PeSbdwgGwh6gD+CeY56bwcjgtI3HrxkYj+DzfiMSyZHYns1Zolnp?=
 =?us-ascii?Q?BcP4ys+6Zj7jKcC+vwQLMlEDKxSv+GnoZSfUTiBUvlGJ18coJt0d5bNqVJ4A?=
 =?us-ascii?Q?KsqoHE1tuKy1Ipume96f72GRIdPFh3revvukdP9WFtuM6o8RQBnSZPnjVdWu?=
 =?us-ascii?Q?0zL6oLCWLFtkgg/+VqTrAzbzoPHszPNBGHnHkconI68cG5ULZeAbuiXFQ3AM?=
 =?us-ascii?Q?dUkH3ReSGyx3mYyJVrx7pBAh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e36afef-77f9-46dc-4e74-08d942b20d84
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:55.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gyj5dR5MJKuooP0omiIMatZxOB5nBvPmV+UphS6l1ZbLMOfImbx80ite5q5uAG/+jZIKO8CTLHbNLcHJ2j1CIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7240
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
index dd0b8715e84e..24082b3f2118 100644
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

