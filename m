Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3783DE620
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 07:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhHCFYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 01:24:50 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:33614
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhHCFYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 01:24:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHkUlhcc1/0/07zG13ZqncGQ+I2weM8KKRWuMnhlQjZCyFME3q6tJfyt69qSJnzW2oD43md5C/jOmHTTNA7fKqW2WcVb0kKBWvJZbNLzvegQZ/6hZISUum7QUwLgcFcnUXN7PO8UVUclnJNXl8VyNFNRJ7P+Osnf0bOYqAB4W3Wkuvo2SS9T4X3GZQbllHrvvZ4PshOw8zLZfY8c59vPjMdMw/4NWuhUuXqynudKLxuYTF8Z8hnm6mv5iS6CF/aLnibnVSE0a75HT1jZ4mgqzOOBj0o+xVRShOKDzX+aiBaxUmtQ1Q64iZRXGNz6ak/aOjTQhEgiqV8rS+Mytqw1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIhcVf0wTcO5AtGUt5Fvq7nJf0+HNf4fyZj3jclj04g=;
 b=jLpAMZZOKbgqMfoo+MvllHTR4jkm0xBO3LtNn5tx4W8I5V5q9xqAbko272GJHhgT6w/MsiIse4CqYaG8fSABEGF01RX0HRWXMexWEF3/PGwuC5MlxNyf8c8rXVtRlSzefx8/AemYZlH6BN1wEht2/uflW1OWowQTUrDbF5KmB7dkWRkO2jUte+BUn9lm+IAh4JOnixKtpp4hieuFuu8+wvgg8I40geAXJstVX+fNU9+Aefc3iIG8/9U/pIXnsgfLfuuPyh5CbPYxEgOTjqpOv50GOM8T7iB2wW+x0N8YrKIVDErCz6lcEY0hW/FrhCaPwm5a+uFFNcpYUfBrS3NxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIhcVf0wTcO5AtGUt5Fvq7nJf0+HNf4fyZj3jclj04g=;
 b=mWgUwtmlJ4f34QOJXP7v3NUPL01Fa92XDwox6IolnaXnp77kk0yr3xqQnPuVwPaoaIGrueB9qEHN2W95v45n54Re7yMwc4Cr2lo8o/ZF2Owtm5aKGPclzWYFSMxUGYhZQjpYbGtEtiMwoPz8GQTi29xwPMQ+NQh5ibjkYpr9axs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 05:24:37 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 05:24:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net-next V2] net: fec: fix MAC internal delay doesn't work
Date:   Tue,  3 Aug 2021 13:24:24 +0800
Message-Id: <20210803052424.19008-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0176.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0176.apcprd01.prod.exchangelabs.com (2603:1096:4:28::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Tue, 3 Aug 2021 05:24:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 701d11f2-9d62-4787-0cf2-08d9563efc06
X-MS-TrafficTypeDiagnostic: DB9PR04MB8204:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB82041A01C3BBDBBD3562F14EE6F09@DB9PR04MB8204.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foO2Gqw9EeEunR8fNtaADjXEvfcqABr4Qbt/ARMqt+w/MM/kk93f/6x/+dRhU0GCRKIIY/V6bad+kQkc0/WpDai8PB4/cmYK2ahgRVCzI+Lm99rorfg5sZnaXW2B6fwL7x7IFzk8Tq1ByOzw2s+zO1Nz79TSkBNdwSEtZrBnt7DkiMexeIl6+Qz+vNnnMVh69nVPmNhH5CK93Ha3V63Hm95a1BKDwXJjB8YfdmgdVOYVa435il6UTExy7/UlIgqV+34bSY54CZKvJ6FL3PtLQylnVvaCoF9ZQU4RDtcDcvkldHrgmnFhSKLojjwN+SLZze77WcT+GMUuxsVrw734fdRbEiStvt7k52Z4yM5AUFwChk4TbB0tZHCSIY9XEr3YY5O0Q+SM+pLbFAk391DpOeTTPf57a8NmLJh8VxeGjvO3aqXExRN+ZQzuotC9yCrn9kTSeP5Tqm/dhPK9gkkA1pr1vF3aqZy+A/V+jras5Q83OK64+2GZR/ulV9PgcXTHFBDIdRNeDAJR8aWlHYl2isgGWbw6gIDOOUv0owHN/jokZ6q1Lf2IpwYhFxfhx82Ke2M4Lk+7Etc8y6/enSCfGuqiHQm/yCZhikhrQOw/7z/sKJf9skdVEAeQmoTCJE9Dx/gOyoAG10wiWjPhrPj0eL6n/OInhFVZbezvqT1L6PpdrlObIhytUUwCkAsc3x7dcS4oCXg4x2U8UL3yY5ypMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(52116002)(6512007)(2906002)(8936002)(5660300002)(6506007)(2616005)(956004)(8676002)(478600001)(26005)(83380400001)(316002)(4326008)(1076003)(6666004)(86362001)(186003)(66556008)(38350700002)(38100700002)(66476007)(6486002)(36756003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SYbq2r+KJtGLQBmjaSbKuuLHxiRPdsgIgQvL3EgPj24yqMUv9N8YPjsaWjma?=
 =?us-ascii?Q?7SLoBp950x7sk29lu+Of/n+acidRCrkeHfUTVAefRReOnL1jqUIEj2Xl7gCP?=
 =?us-ascii?Q?wdlklg5d6HZCUql44Ph+JffjdO9Dyl1rLkj5vxI2cinVjO7HV0Pv4ddITNps?=
 =?us-ascii?Q?z4BG81tvjgvE0l3mWraeddOjaXhQOAWhbpx/aUbi0oFH385uyrk6U+n+UjD5?=
 =?us-ascii?Q?AjD6hSjaXh/mCX8ylK06J/bx75pH9+N9bG01jbY4Q1P+THtAIqKI/1FSC9N4?=
 =?us-ascii?Q?i5JoheUk+yHPkFVWelFCggc6NuzGMIsjfdFG/sn0/HhHUoiMr0RRE9xYAbRd?=
 =?us-ascii?Q?zhyg3DtNgN0PugpD5dOKG9s4uQHlPGAto140rbfyofFKeuFOmiQy0ZRsyeeR?=
 =?us-ascii?Q?oDBhc0gigxUI6OqedX3oCPaefQuphcqR7EDIrMnXESK80tKIeZhuhIeRpYL9?=
 =?us-ascii?Q?/RoCbsOWvMvzJur9l+jT3fFLsftNfytFLku9vG1xBCoZLp8WDj5DftBToWF4?=
 =?us-ascii?Q?5WHA3cUVFVkzVh5XZuaudICCOc840R3H3lxiVFHUKPpO4FHlC43mzDP7FjHh?=
 =?us-ascii?Q?Mzqpe+WIjAwj7XcZ06s9TYjahztTdBFxh0oPRMOTUwdyKfYiUOvJQaxmdVpv?=
 =?us-ascii?Q?+2TH89nSiOR0os91imPmyKfbIw8iENO4CIusM5HNb/53yuX6ksOS7ZavuXSz?=
 =?us-ascii?Q?3mNPuWytNMiy5F+SOQ92eKMXdtbXLqtMC0i2dqK/2JxxCq+wymejVeDEqUHd?=
 =?us-ascii?Q?bgVZvFFw8u+hrU2iskJa6ZRREjGJh+GXhWZzoalclIIn0am6Lmt+zyjr4901?=
 =?us-ascii?Q?04O9y6RCCRgdZdKHEoRX8J8bBNWZTEYZXnSu722JbJrKv/4IbiLz33G4t9Jl?=
 =?us-ascii?Q?kQq76igvom73WqUXsCvC8s/3TsjD9P7vNJhXxGExqLNcl2mV/M3RkPhl52Tt?=
 =?us-ascii?Q?QRTB80K1vT7k5ZP+hvZLJePyELAFhOB4HFMJxOqpL7SfOLAuL7ltRq4XZsKU?=
 =?us-ascii?Q?bDQacOK7xvMnMWL9REL2c4zUGj7F8UJZjjJvdE+bRnD1GGMPgFT+RNKSu64g?=
 =?us-ascii?Q?CuGOsREyf8639xLXNzeki7rb8+TWiGFcpqmCgSPegcx/XNqea4B0XAPJhY37?=
 =?us-ascii?Q?3alZl30W5Phtkpvm2KFgjqqptBTthRmiH8tBSysAE8lXjxJAyqHEyKGPObbA?=
 =?us-ascii?Q?xiY98XqVl2AWAObu8dhuLZTAdyc6PREnPQQ9IXnj7RC27JwSBMuRDTPG0UAJ?=
 =?us-ascii?Q?2ucccfs9tioIybLawdfMDToktWzHseTT6bXTMMbjRDuRFFJEBX3OOToRdI8A?=
 =?us-ascii?Q?2tgN3x7Q+7k/8RStxUSn4ONP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701d11f2-9d62-4787-0cf2-08d9563efc06
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 05:24:36.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Auq4D5BamyRQvBt85euHnquYSSyhcwE2g0atgkAVTGD9wFZw4uq3Iw7Aa9r6FaXf1RMj3je/mnyqOL+xSfslaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to fix MAC internal delay doesn't work, due to use
of_property_read_u32() incorrectly, and improve this feature a bit:
1) check the delay value if valid, only program register when it's 2000ps.
2) only enable "enet_2x_txclk" clock when require MAC internal delay.

Fixes: fc539459e900 ("net: fec: add MAC internal delayed clock feature support")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
This fix targes to net-next as this is where the offending patch was applied.

ChangeLogs:
V1->V2:
	* Jump to failed_rgmii_delay label to release phy_node
---
 drivers/net/ethernet/freescale/fec_main.c | 48 ++++++++++++++++++-----
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 40ea318d7396..1201c13afa6f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2042,6 +2042,34 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	return ret;
 }
 
+static int fec_enet_parse_rgmii_delay(struct fec_enet_private *fep,
+				      struct device_node *np)
+{
+	u32 rgmii_tx_delay, rgmii_rx_delay;
+
+	/* For rgmii tx internal delay, valid values are 0ps and 2000ps */
+	if (!of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_tx_delay)) {
+		if (rgmii_tx_delay != 0 && rgmii_tx_delay != 2000) {
+			dev_err(&fep->pdev->dev, "The only allowed RGMII TX delay values are: 0ps, 2000ps");
+			return -EINVAL;
+		} else if (rgmii_tx_delay == 2000) {
+			fep->rgmii_txc_dly = true;
+		}
+	}
+
+	/* For rgmii rx internal delay, valid values are 0ps and 2000ps */
+	if (!of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_rx_delay)) {
+		if (rgmii_rx_delay != 0 && rgmii_rx_delay != 2000) {
+			dev_err(&fep->pdev->dev, "The only allowed RGMII RX delay values are: 0ps, 2000ps");
+			return -EINVAL;
+		} else if (rgmii_rx_delay == 2000) {
+			fep->rgmii_rxc_dly = true;
+		}
+	}
+
+	return 0;
+}
+
 static int fec_enet_mii_probe(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3719,7 +3747,6 @@ fec_probe(struct platform_device *pdev)
 	char irq_name[8];
 	int irq_cnt;
 	struct fec_devinfo *dev_info;
-	u32 rgmii_delay;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3777,12 +3804,6 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_stop_mode;
 
-	/* For rgmii internal delay, valid values are 0ps and 2000ps */
-	if (of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_delay))
-		fep->rgmii_txc_dly = true;
-	if (of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_delay))
-		fep->rgmii_rxc_dly = true;
-
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3806,6 +3827,10 @@ fec_probe(struct platform_device *pdev)
 		fep->phy_interface = interface;
 	}
 
+	ret = fec_enet_parse_rgmii_delay(fep, np);
+	if (ret)
+		goto failed_rgmii_delay;
+
 	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(fep->clk_ipg)) {
 		ret = PTR_ERR(fep->clk_ipg);
@@ -3835,9 +3860,11 @@ fec_probe(struct platform_device *pdev)
 	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
 	/* clk_2x_txclk is optional, depends on board */
-	fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
-	if (IS_ERR(fep->clk_2x_txclk))
-		fep->clk_2x_txclk = NULL;
+	if (fep->rgmii_txc_dly || fep->rgmii_rxc_dly) {
+		fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
+		if (IS_ERR(fep->clk_2x_txclk))
+			fep->clk_2x_txclk = NULL;
+	}
 
 	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
@@ -3955,6 +3982,7 @@ fec_probe(struct platform_device *pdev)
 failed_clk_ipg:
 	fec_enet_clk_enable(ndev, false);
 failed_clk:
+failed_rgmii_delay:
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
-- 
2.17.1

