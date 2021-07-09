Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9E3C204F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhGIH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:58 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:37856
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231449AbhGIH4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZf93Q+2vPKZP32DKkDCR8c9GAmDqkHfrQ6ZWxksasoDLxBpjf6dK6zGgfgsTu+5/JkA9NkxaGapWwOOSH4LnSHiMDUtMaM/qjD77J1Es6WIofnUQSuKKsgRHyF5G7/C4C5FG8Lkmfli7KZjiVDLzOQhbWRrjRs/R7FzdcwarILX/S7H7U/6QUI6eEtcM33y5Zb15us+p3o+FtvyhMjDlgpuzT5hx9w8TTUvqJ24wnovsZZX5Ul0QkG1lxx6ctzNiCPo277AqjJvb64tHm303Dm4FxGwB2oYVrA6TdvtbrlEngVGOYCWvo75QE2d55LFteYPsR8Yp9T3cpbzliiZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/lfHjh69y4ElIGDzDssEW85yMAGE7V4j6ojsyR+3I0=;
 b=iE1MhUb2uvP3kfyIaXYbdS4RtOvl2T5+tH4Snb4Cbv9Xe1LYBlPgsbKrdM2h7DPlD6ajelFWLnZSlDwZkaFLnzmpF+mhMpFkSNdw0vN0GCRqFdyq8dqSODS0E+tArmXGE7ZW20mJIBqm0p7nIX8U+VW9UHUbWtJMJJKqWxsgWBf86Oe2RKUpIVH8VsyggjkY3Jmq/qLb00lVV2JuBNJY4OmmVwIZbC/GZNOYI/73qZjO4ySSkmSRoV7Kl2OQt0zKB2hAhe33qADVBN0LvvkvCE9ZmZtMBoO6aGINrOS8911HnUMFCbdE7yh82ygI2WZ7emX7f8U9URgKqI2IS4atxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/lfHjh69y4ElIGDzDssEW85yMAGE7V4j6ojsyR+3I0=;
 b=E6p84RISAmTks2LOWH03+InnuhUAVrUpuYfORO8FGBqrLn8jIB0k0Z+xXRMcgabl634p17VXy2IHVF2XJyoJFSa8PI40rRLWfEIU15NEMV6aJ/Fa5Ex3Cr6DZU3tWBhGJy56EhqMSYV7JJGnSNDvfC7ut5F0CevevUptg0VJT7A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6793.eurprd04.prod.outlook.com (2603:10a6:10:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 9 Jul
 2021 07:54:10 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:54:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 4/5] net: fec: add eee mode tx lpi support
Date:   Fri,  9 Jul 2021 15:53:54 +0800
Message-Id: <20210709075355.27218-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:54:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5be34a8-4162-4239-2c71-08d942aebc1b
X-MS-TrafficTypeDiagnostic: DB8PR04MB6793:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6793483F4E1DF6A2913D7394E6189@DB8PR04MB6793.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJri3Cib3xQ4ndmEGYJsvniq7jwOcDb2KKzcjeqUyBHnozpEl901tg00L8eSF6OdW/8PowhodA+HfZCI8lji/nuflxJhlJWTEeKK9EVdInJ7gSbmpFiO7ZGF9L1W4xnS0wlNkf1zWfH6O6bSwi7tH87IVEIq6hghpupZI+gFzRClOYLNiLh7EO8gnyEvGOc+Mm55eubVt0I4pTl+hObISXOPGuk7V/YLY9mXMVQUGw+FVHJyyWh1K7uQJRr3wlqE/bERmXZIdqACiGNjsxz7PJANSF7QjkwF24oq7gv/pijHUr0Ecz0cW4lEwQia00yT8zS0ER4dPoMKA5CNRqhcuTPw+nocM9rEMZENVhJc/KqEET10V8HUHO2EBBOE8WBjoWfFIGjWRDU3olsZys0iFSsj02f+wxgHOyZa85znU0BlXVwiWaUO+vFhfH4NInvhgyupdO+fj7KfeqSvh35dyfFfT6fv6bqJK/yM3H66dj1oGzSvPxFXgImjMw3+v48YjopbPQTo5yj6nCgLv2N8tO//78U8b8PM3Nq22y9AIWURYCwQPe94QIPWLttQAMq0o3+ogPgwWGON2R6UBl1BDbGgUk8C3NPoicBZipRgaKnz8kAUyoznlaOR6aoZlG0W7xKh4Ur5nD9hBfxgCEZVMIee+JElxxn8tGL474heAUGOwLW2tHEWDKF1BIz5q8QTuGxlfguPmCmNuaH6eiVM3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(8936002)(956004)(38350700002)(316002)(6486002)(5660300002)(83380400001)(26005)(4326008)(186003)(36756003)(6506007)(478600001)(1076003)(86362001)(2616005)(66476007)(2906002)(38100700002)(52116002)(8676002)(6512007)(66556008)(66946007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6/aXIDyws3QdOzV0PCK5SchQY/Six/0R5YLrAl2JijUx7FVwh3evq0rGuyz4?=
 =?us-ascii?Q?NVJIp2wnGh4sKp6LAxNYtu7+R4tPGoIq1b0FBpVXuN6UyLz2ZMechf6xgXKD?=
 =?us-ascii?Q?aGvuda44oNRqkx++ThxLVstTMQSP7bCzhBtoaAspYXbhc8u0/IILX0NCzoxC?=
 =?us-ascii?Q?6JmUh/lW/tbctK29DIehKhhehv8Vhycld63m1jnc7dnrtKA4kgvQAwWYGJKh?=
 =?us-ascii?Q?BLQHBSxPbAEBallYYy1uewIC52xnpjzHJRsbX77FZVRthr/jCrTBauR0e1yC?=
 =?us-ascii?Q?3p8ZzIaJ3+FX/TUWc4R48NhypCSvUkr1e2XTyl4vTJ+O2Jm+pmVJEBJ0U0NU?=
 =?us-ascii?Q?xA18srLjKw6b5ZLHngl6Q7ukYUKcAL9qIFjTIsN28eozpAKLT5S9HjMUJmQv?=
 =?us-ascii?Q?5mDjb9VAh4pGONdJ1gThgfBMTckcjsZGeh62KwEv+LSCcq/+SJymoqgvtZ7h?=
 =?us-ascii?Q?uGKptIIzb3e0afCSD4lwMGlCzvgHn1BaHrE4ZmlTWMoGf9hoQ+Lsp9dHPOjP?=
 =?us-ascii?Q?q8zzE9TWQ3S7JQCEM5xrPv9WioVpQZEryWJcYL73MDoIwWmYJ/0qDprPpbMF?=
 =?us-ascii?Q?9NFANqIuY/nrbiHW6mlTU3hdgSeppAjO5z7hYJtBRN40WOpzJGxya18BLINo?=
 =?us-ascii?Q?v4PVrEK2SJyYGB5rtu3+r+duFJO1ByZLctts3npLy7cisXYYFUvRCYQIczMj?=
 =?us-ascii?Q?A9bK0Fv2SjIro5r8OHqdIplfahMtzaiPjDMh1i0lxIQX1qU/+K6Q3Bvdnpzn?=
 =?us-ascii?Q?iUx87GQxlOMuMAG6zz+RTjuG61dXFOeQOxe228Kikp8qYU0aGtVKutu4XQO+?=
 =?us-ascii?Q?LvE1UsJRX2j6iao1tzRM8vSCB5HFpbCp3/tVEspGlLZHpfNe6h/xdcWX5utt?=
 =?us-ascii?Q?mghOE3STFhTcWqM6gS5Ev7oUyvNe0gRM7laM5yvnubf1i6+Pt9NjXl0RZtqH?=
 =?us-ascii?Q?ffaF1qikZ2GPlaTaAaYrtxqwvGwjtHDD3hPTV8xo6eZMWWJ5nUKEL3nV9U55?=
 =?us-ascii?Q?uZWeLYcj0G42KzHzW8v97eQuDj4DCq5RPxxIFQf2C+ljbYRN0DVYXDb00mWT?=
 =?us-ascii?Q?GpB6NCG271lq8fP3udT/rtJAoWOHlQ+VTd0OODuVIwaj8iVUHZS+uPLZ28H6?=
 =?us-ascii?Q?hijp6B2tEb9zHHrXLiskySnO7S+C/ukZOLrD3HoZIGR6NpVUQE2NMVsYLXzR?=
 =?us-ascii?Q?b4TbYnRkzFiQ70sPtk1fDCx/Ss7XRb+9Omof74M2ahXPW5kCAtwfzbhoS1Fb?=
 =?us-ascii?Q?+02v+13ZfspI94yaYiVTAlTuqiHBy/K22wjmkAWuFoXxHGfZGynKmRjABC21?=
 =?us-ascii?Q?7bNYR69lPHwRj1QAtpTpXcRR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5be34a8-4162-4239-2c71-08d942aebc1b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:54:09.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gc6b4FLT5veYWsqjyU+qYV4ewuuX+R95ctv9X6MuA+adYJGydXuX0KovECnvz0sVSCNmNxtJd3+nonzXbCQgag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6793
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

