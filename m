Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB493C20B4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhGIIUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:43 -0400
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:29408
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231701AbhGIIUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDROowuCTnrci5mQWnQ4DomMvpkl1aVmZfpjglYf8CfUVXwUmwWkNA43LRl/szNvvaVzLHfFKsu2hyWNsfiR7uuNd0MgQNL7mll/edrA9AHwy6rOn++UP8C25ubnlCgmRmShnXzrwcJsXHDUy0iU7lbrTOlyX1L9z2FtC/YjsbSYbE0qNLWQz9/mfm+wcgeTqxIbpGmksGyAsRfIeb56yunMfy4y6vUVU1hUjiDq8ERaapyUizIU3jxtGuz8TPUtHQuL8clMqDtmIpbAy/jDmAa3RoQbpi6M1YlhG9iy86Y8Y32C5te/KJThdXOK4QUUFyC03CK4u8SRRHRXcyE1UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kweURP6Gz/VziteuUY8Ennqc9aDvjbgDQe6WbvrroNY=;
 b=K/zXi0woZBWWKlos7OcVdnTP7iaC+NM0gZVHDfpZJtzCM3lcmMV007vYcv7j6o1aQIYjiRB41Q/bEggF8Yvuj9qL5xa6+QFyznxICLyrWk7ZOJlpqVVSxP2JV3h2xXq0G4qk4C4aohGaWQ18eQQL9aAqaIjmfwlxK/SE8AgvF8GEqWlDnxHw3+9Dq4D2lsuTIdutgxjku+y+LeQXiHn4bzFtf1v6YnBos8rYj0P47QtNv5/w+5tPlI47d76ICPhGpXFi4+RtBAL9iGHqk7L1Ur3uZ0idR0OLNgiAw4YpOzY7HbHUPw3SdbfsidmWmJXol3ISKr2usw0R8KjuJxIL7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kweURP6Gz/VziteuUY8Ennqc9aDvjbgDQe6WbvrroNY=;
 b=FxcjbE9caY5rd91E8EXgLmnvrb2/FpbquSIpeDy8Q1SUm3gM8WCanZpXTGjHKmHOFcj3ZGCwVDfzGJUOV9LPgj0hkpmZpaqd22j+3WOSFBr06fg+D+BAiXN1GVpvVJYjxHthkweD9WqWCRkVEDQG+089YSMDt6yS5Hvbe7Cyz3s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8201.eurprd04.prod.outlook.com (2603:10a6:10:25e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 08:17:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 5/5] net: fec: add MAC internal delayed clock feature support
Date:   Fri,  9 Jul 2021 16:18:23 +0800
Message-Id: <20210709081823.18696-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3cabebf-161d-4aa2-27c9-08d942b20f4b
X-MS-TrafficTypeDiagnostic: DB9PR04MB8201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB8201132CE9FF695760DDF0EFE6189@DB9PR04MB8201.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F//q+vycfqBsak8hqZJC2lYj8Z3BwBTV/wZ4EYiT8k1r+q5edIrROhqBWppEaqlZweR86a5f8J/bBShXYAg6HrRENWoF54qCnd0sNN1h8K1JoWwftuAnuWPkpRU4IU+nDVVbLKcUiHrGNFbaxEppY/AaDuSLw3hP/phlQsw2+fXgjsi4qoOE/nasTxxy3qBcKL4xhqzNy8cIUyQHv9d1llB6nGDkuc5Am8cbe6ohXnx3OsMHTxn++8IgF7X1kcJ0neA9v/2QGjF5pzFzFvjoxmCFxPnjPON5kuoI/lv0foYhIlad7i77yXuEbih8OJJ+NpmaHqiqP+v+L4VGMxloIkE4jW2zODi6grL9lQQZBszM9p+UX92hmbz5ZLESbVS+IaIQNELW7xxAFfhOQzVDKvyDZ28uMozXcwWydLS51FrLhpt0/DUbCUN6MPKVA+2bFWIquNv/nAHiD3rLhKxFFQvwDcqieQGYetJAGz9O+SZvwuxuVf0aRF1pLEksdX+bFPoC7D9YX1Kjl9rwGgOVhaobHS05VRP/WHlkm77za30L/VIWl7Qq5Z2iETb0EfP/fqNAUI68jyPIKbVrNL12YY34tnMamp+uiSjiRZd3KE+QBRuFKz2YWgdzDg/VVoe0yVPDe3XhdGISuHwhEJ/NGksCs8yO13ijmW1b5+PQGDhfiSN5eYoAWRunvTSpIGTRuWuPMTK1sXUTYnTqPxYnJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(26005)(86362001)(6666004)(186003)(2616005)(956004)(4326008)(52116002)(5660300002)(83380400001)(38350700002)(38100700002)(316002)(36756003)(8676002)(66476007)(8936002)(6486002)(6506007)(2906002)(66556008)(6512007)(66946007)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TISweeSNp9cBQwlRQIeregS4fyTIBPVp3ule5zMjI6RN/C/jQppUy9g3R6+H?=
 =?us-ascii?Q?7hTk/Egc/LfSKaoO9+9NDMNm4CiXb0ob2niLVxNnFBA3AvoNFumX6jx6LQm9?=
 =?us-ascii?Q?sxTaSFXjsTwKVvBGpDuLqzl5xukoTLcHHDAberdH4P+CNBdeqRP16CgkmiKi?=
 =?us-ascii?Q?eJ5nacXrsuZeeVQRusARDGskV3jRX4MXvtDzizS5oS+AbPmZigvKq1sUmKLy?=
 =?us-ascii?Q?AdT08xzV/VWdaJNV2LNgpqJbg7+flIgixAtyJrxjiWgeY8JS8cY+UoUmn0iN?=
 =?us-ascii?Q?AxvRxPmp38TqPwajYQ2hBvHeeunyJbNs7n9P0ZR4AeHSvOWWFNknBqsmXqPi?=
 =?us-ascii?Q?L+yCa21OaOswgDv9mP/ypMMmdSAV3f1cv/alKxDi724QG9jyzmeXDw6h3m92?=
 =?us-ascii?Q?BE/CFhCH6LPz6kbfyhPpHc5AzVSbrehQYqVhKvp01i/TGgpIBtaWv+xe5su0?=
 =?us-ascii?Q?4C+hfs1eYzOUdGASaV4kVGylx0VInBE6Zv1O1ICtJqIOgdH86Nh/rwpvVQfS?=
 =?us-ascii?Q?IxHJqWozfzR/NJP4v6yecl01Gw3Dfn0wVyVg/aHsbD3HSm40KRQoJsHzO414?=
 =?us-ascii?Q?USUbwVBFPRcOJTBCi91eCzY1SsAoo3tybI6QB3MoW9yE58g4t1YjY4+uD/gK?=
 =?us-ascii?Q?G8HY3KJo7xHDrAKva0KSFe9KwhGbHk/fqNMIuPJPD7oXoPK+gRY0rkIklt8S?=
 =?us-ascii?Q?605P7AeqhT3+lCoaXnNzE5IlRSq4VPdpABDjxy3Da9ZuRzJR6yPL/TXP8GUj?=
 =?us-ascii?Q?ONqmBx12no53t4ynChZSX8K3QPZm9aD/rct+6Ic01hoesTj1rLzjUNp6lFO0?=
 =?us-ascii?Q?Fr17eR0YrD2r/f438dcCDxSYJKBMqtjL/a3KkRzJuoTxiR62YsyqmXJ45lQL?=
 =?us-ascii?Q?Ykr1l+aqYstzdr/NRg8Nbjqa9C7GSgrL/TCgIPuvNYVelgzmoJuhzRhfeUBr?=
 =?us-ascii?Q?D5a3B67KRjTKvNKityQYjpPZ24bK5Cr5be4YJ5GtPX23KSFHr9m8FratQA4O?=
 =?us-ascii?Q?k0h0/nLjPVuyzaoaqalUvGCMKcLb6J7ZGDNVXOxMLt9zhI7jVOXb2n7Pge8Z?=
 =?us-ascii?Q?yo3s281daA/QbzboEwMPcHj/snaNKliQveP6Yhf7MejeQ/gcdQRMCaKAe6Y1?=
 =?us-ascii?Q?aWeksxpNpth7Zf69uuRBWH4vfPy1Lzs7hxzaJHXVzQPqlaKJBVMPkM1E4d3t?=
 =?us-ascii?Q?epbS3EvdW8eTaGGli6U7f3mMEOKIeiIu46ilYLe7FNk7GHLql1w/PQeygSIa?=
 =?us-ascii?Q?r/jXoYFUkf53NvGWTOu2SP5bg+BmUHhyViQ0RQoZKQ0LIgkn/ZHZsBXdaxon?=
 =?us-ascii?Q?KXXe5WJwp+dpa2Ucwr609Y78?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3cabebf-161d-4aa2-27c9-08d942b20f4b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:58.0081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GBuPllJ9wjyIIZGuDwwivneUatZRLrb/SL+d85TBhYSYeYJX9nFsEq8t2B4WYBJu5oW6NN22KkajJ9BDhu7Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8201
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

i.MX8QM ENET IP version support timing specification that MAC
integrate clock delay in RGMII mode, the delayed TXC/RXC as an
alternative option to work well with various PHYs.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  6 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 26 +++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0a741bc440e4..ae3259164395 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -381,6 +381,9 @@ struct bufdesc_ex {
 #define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
+#define FEC_ENET_TXC_DLY	((uint)0x00010000)
+#define FEC_ENET_RXC_DLY	((uint)0x00020000)
+
 /* ENET interrupt coalescing macro define */
 #define FEC_ITR_CLK_SEL		(0x1 << 30)
 #define FEC_ITR_EN		(0x1 << 31)
@@ -543,6 +546,7 @@ struct fec_enet_private {
 	struct clk *clk_ref;
 	struct clk *clk_enet_out;
 	struct clk *clk_ptp;
+	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
 	struct mutex ptp_clk_mutex;
@@ -565,6 +569,8 @@ struct fec_enet_private {
 	uint	phy_speed;
 	phy_interface_t	phy_interface;
 	struct device_node *phy_node;
+	bool	rgmii_txc_dly;
+	bool	rgmii_rxc_dly;
 	int	link;
 	int	full_duplex;
 	int	speed;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 24082b3f2118..18ab60322688 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1137,6 +1137,13 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		ecntl |= (1 << 4);
 
+	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
+	    fep->rgmii_txc_dly)
+		ecntl |= FEC_ENET_TXC_DLY;
+	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
+	    fep->rgmii_rxc_dly)
+		ecntl |= FEC_ENET_RXC_DLY;
+
 #ifndef CONFIG_M5272
 	/* Enable the MIB statistic event counters */
 	writel(0 << 31, fep->hwp + FEC_MIB_CTRLSTAT);
@@ -2000,6 +2007,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		if (ret)
 			goto failed_clk_ref;
 
+		ret = clk_prepare_enable(fep->clk_2x_txclk);
+		if (ret)
+			goto failed_clk_2x_txclk;
+
 		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
@@ -2010,10 +2021,14 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 		clk_disable_unprepare(fep->clk_ref);
+		clk_disable_unprepare(fep->clk_2x_txclk);
 	}
 
 	return 0;
 
+failed_clk_2x_txclk:
+	if (fep->clk_ref)
+		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
 		mutex_lock(&fep->ptp_clk_mutex);
@@ -3761,6 +3776,12 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_stop_mode;
 
+	if (of_get_property(np, "fsl,rgmii_txc_dly", NULL))
+		fep->rgmii_txc_dly = true;
+
+	if (of_get_property(np, "fsl,rgmii_rxc_dly", NULL))
+		fep->rgmii_rxc_dly = true;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3812,6 +3833,11 @@ fec_probe(struct platform_device *pdev)
 		fep->clk_ref = NULL;
 	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
+	/* clk_2x_txclk is optional, depends on board */
+	fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
+	if (IS_ERR(fep->clk_2x_txclk))
+		fep->clk_2x_txclk = NULL;
+
 	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
 	if (IS_ERR(fep->clk_ptp)) {
-- 
2.17.1

