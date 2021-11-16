Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CCB452AEC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhKPGbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:31:44 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:60901
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232002AbhKPG3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:29:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEDPE5DAz5dgjysi+kPvXjqcQILu4PTDKQWZ3ovEmpppv+Tl2K+JlutbMU2rzZXx3oywB50NG0E66wjFc+65z4x0o2sfYfH7z4xQO3z9cZMhdiZnogqgsMVEztAKokDKKmfYD4RU9IbwGKwGGdgCYJCQA7aBag/h8bCF965JBSnJqIKjyc6YFQfdX8wovsnBgvkQqMz6OsOGB+uoT8x86QHUmIr5wUJSool1AxQ8NUUp7XyhHlX4xpJRWm0MIJfdKYeOhbkLnyFD+PB4PPg2gaLaxaN0V/eSZ7iydDaPgQSEpWdYY1+AquoZE/UPLeB27YoKqCkBxIjnsWQ7dM7xIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9JsKGSxS8228sE3prsCueXlIcq72l2sV5T89kpzo+w=;
 b=kEWI+CMbkiMDRoyPTRsRI/+wzP2AbxEFCdcgI5aqI10uze4vdAj0Uetr1arop5P/IGapzCKJtqa6Hc+SxzJSAP0l2w5GNCvGlVwYS4dsUnn9uhoLWPyR7fMbKxJonG65OBVG9LZ/2ZmscM9mNojaGEolkZZO5a84sTBEZUDmqfKT5QazSGz4LL19rulmJcqkHyxnLngHfuSzIj7qaTWgKAcG4q3Djc91wAuK7cdKP5jeRv3O/0N3miG29NHJvdnZmww5jUvcku/8rCFX7UK1gyhyCadibScr11owCuesa6GjPt2NnDeewr6h70k4CT53abmUQMULXwR415TfqA0ODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9JsKGSxS8228sE3prsCueXlIcq72l2sV5T89kpzo+w=;
 b=e8a1pkmpXenm9UcerxYfZaEXrl4Lsb9j7n44p54hUCic9cwYVV+GyDnF141YchVNk6wYjbBzfPuL8Bj4Ia7McqIihjD11bnGUrVExRlp8/EVNe5q1s0JEdIf6GLOARa5D6LYGPW24Eh8GsyIudx5m9IgCOsgof0DAXi0GqHawxk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:55 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 16/23] pinctrl: microchip-sgpio: change device tree matches to use nodes instead of device
Date:   Mon, 15 Nov 2021 22:23:21 -0800
Message-Id: <20211116062328.1949151-17-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ebb60a-afb1-4c9c-dc01-08d9a8c9aa38
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722965224C3DF890C4009E3A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:60;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JxSQuGsUDBv9BfrPg0uFYGQfsmmA+Y5GFmT9iJLvjAj0I5vGKVA+yVn3ssSi1xnpUf/P7XfedX/filvg9ykXMZwsnqSrGpA4QeUa73v8gtW7KwxhL2BOiu8Oj1ixOZ/epaAsMj/ghIzjxeHqju9jaWFCGMMFtK+wOIR065NZMMpDanwvIik7u9/KOMFKaAchq1Tou4E3LI23w7daL4QkN2ZohPLFCIu22jX7mP3TAqdIAFH8w0B1mA5GGGNkv9wQGIYqvxFRLNRoJlyRqq4CLAy/p1jvXoBki4Uj0F2ab2BcRktEQr/w5npGrgLvXS7Zil//jgf/+RVBVqVavZAeqZ4IxS+H1/3GzJ2aUo0tsuSfYLnbQ+P6eyapyoog8fA2QaU4vvgZk7hzgJ9ft8JaENB65k74xCY4xxGfXtA2eF7Rzi6vzi/DawKdSLtlcNdJO5jlgBqAPFIgcriJkSGPl7vJowwb0HADeR7R08kqmYBQ+Gwc58RnaXo1DNGGDyO27rZwNJPWpe9vSM9XAeqhC7vaPwO7pqpaNsxsZU74nDmgnSkLHS5dLBB4frnJqsshZ57q3pnKyIIKLyEwlQGzB4uf/plaNmCE0SGhKyWEwzqNFr887LOTry2pQoYv547IkPrjAgKIasXuPURcMRgnCe14hybMMixGs+HefyvTW0wGgAQ8IosLmO1keIxSnRo450TJqz4MALhDnPnGFerwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovQZyD5yHb206BAUWWEvD8IPChkVlbS0bqQrlGgCw9yux7zH15mc1cI3Yc6V?=
 =?us-ascii?Q?z4aq2OW0b6li5uHU4BmZn6XT64Xnsfgg6gvocuXRgqTwkEDxIsYEyAGEeTkx?=
 =?us-ascii?Q?S8vKLzhNyaUR07he4kbDCmXxN3Rn3kIZDDQPbmZjKeVoryVGw95uDTYdiKRT?=
 =?us-ascii?Q?X6QhCb0JcR7/x2abzcs8MzikmTHM6zKVtiq44idpL4BLAJn3bXnHYDfLCkDn?=
 =?us-ascii?Q?H0jDdXjDIp5VFG5GHziMTS2icnw6aRs0owe2LYnp8b8iUe8ZCILxQyD6irwP?=
 =?us-ascii?Q?v24pzbGGM29yyl3+jEYBVD5P0V3dHQGe0+MGomyM1iIEC+F5Ae+4KGenCm/A?=
 =?us-ascii?Q?KmWHG1NJ08R3Tv7nz2AseCMTBdeZNOxsgh4O5TxbjrXMTcCOuLvph6jmcIPe?=
 =?us-ascii?Q?ba/YYwZ1SOgRjrajp6CLyllvR7KXNWYTnkqhP8nvew/aZAj7mYStlHa2eNAf?=
 =?us-ascii?Q?+nope7afYKLpYjoTUdHHNOxKwP+2L1ZPt9ajjkyTb8UPTneeQTArwfNRa0DR?=
 =?us-ascii?Q?roALuS7Q/cHZojNwxDeTSCJELs1WW/F9sofe7udIhy1Qs4fIaWoRFk11Gldn?=
 =?us-ascii?Q?mXE12jDz2/zqSTk7xiCZadlmTBfSqVgFt75agoTUxl2WmUE7HYX0PIExO/8j?=
 =?us-ascii?Q?b5vmHKgl2yMd33bkur3KG+Sk/hhbcj8ZcJ5XPPlyDIizAh1znLCkRjAGcjyU?=
 =?us-ascii?Q?Lc43WLKPKuFAS5PY9ZW0DUo8y7Yh96CkFDocoZ/fCX83UjINVXG63PPld/2K?=
 =?us-ascii?Q?6msTdeddvX1vkG2wR9ObiPPifa6ps986/MyirtiJAvMe2lLepi4hPGgcRqVP?=
 =?us-ascii?Q?O5gA4lIhH/FGRsyg87s0lJIpz+eOSB4NKkxkEPEQnDcpVS2PKDhn4R8i0sUx?=
 =?us-ascii?Q?QpWrp7MeycfLW0+Z/NvAOy8ML/MKYwhm+adWE0Rv6up/+ow+cyH6Cz5aVC1J?=
 =?us-ascii?Q?KsD/UYgnlwLHaMp21cYSprCYTLzke1XWIIPWFhFuUmrGI83K5Lgc4yxyfBZj?=
 =?us-ascii?Q?KslFzvTQPOLKYA/zoPmlNSAkT7l6OkDZk4wVvs3HDi2fz0QHJaVHsweJvG+G?=
 =?us-ascii?Q?yhSy5Oaj6zUwbZJiMlb0bHl64inMobCDlyP2ycSmeXz8wQb9YlG/2xUbgPRb?=
 =?us-ascii?Q?F0C9GCJoHdm8afbpz8tIoAcQLU4IKbft5DThvf5zH0y4Ft52npRqlfG5oyKS?=
 =?us-ascii?Q?uVNe2ZDKdAMf5yPPrLNiFmsR9dDnlQE9c+RNYU29AC2ofkZNXPs1mbXb+VXL?=
 =?us-ascii?Q?2YOrkWkzzKm8KTDHObuHf0FyNJJW1BcELIvY+S4lfiG/Dk9UAn256YKnJlAR?=
 =?us-ascii?Q?aY85OtaW2agFL2A9HRMIxaYgUG2tLaw46SPmzNEFEZUhuhOD2vvMOC1o7ZjP?=
 =?us-ascii?Q?xrZRcm3H19GflwNTxZZ5BKL+M/KaJuY4g171RnmNshsXureFVTBCSdAZAQma?=
 =?us-ascii?Q?WECykoKiJJE/h1XFaSip06Q4UAA522C+xBZiWQrHX8co8l5LzKUnbvYErXN9?=
 =?us-ascii?Q?lKihp2wh/omQjtFhL9UGekBgnQSwfyAH0gGdO6DZ384kIVDb9io75xFMs7ar?=
 =?us-ascii?Q?GC1/IPEcAn1iDtCQ/LFvqpE7dqC/J7h3uHp4oqFGQec3Esodc1HCeWZpKNGL?=
 =?us-ascii?Q?h1tlk5Rk+JjJHp7TFEtZsv3gLWwATL1KJbMC44WYyMNuypiTPAuQTEzuRTM8?=
 =?us-ascii?Q?Iu8q9K0+E56BaR6j8HRGLG9CZ38=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ebb60a-afb1-4c9c-dc01-08d9a8c9aa38
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:55.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hkld14XiAxcTxehD+SDIA7KAN25w3nKSduh+wazbFn0lW/+TUb+xeAWPUxD2tqzePUUcmJmshxkCZQef1t3JNxJjWcj1qzjiozjIAeEHVyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

microchip-sgpio is being updated to support being a device of a device. As
such, standard devicetree parsing functions (device_property_count_u32) are
being changed to a lower level functions like fwnode_property_count_u32.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 72 +++++++++++++++--------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 762611f76438..10736ef5c6ca 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -109,6 +109,7 @@ struct sgpio_bank {
 
 struct sgpio_priv {
 	struct device *dev;
+	struct device_node *dev_node;
 	struct sgpio_bank in;
 	struct sgpio_bank out;
 	u32 bitcount;
@@ -524,12 +525,16 @@ static int microchip_sgpio_of_xlate(struct gpio_chip *gc,
 static int microchip_sgpio_get_ports(struct sgpio_priv *priv)
 {
 	const char *range_property_name = "microchip,sgpio-port-ranges";
+	struct device_node *dev_node = priv->dev_node;
+	const struct fwnode_handle *fwnode_handle;
 	struct device *dev = priv->dev;
 	u32 range_params[64];
 	int i, nranges, ret;
 
+	fwnode_handle = of_fwnode_handle(dev_node);
+
 	/* Calculate port mask */
-	nranges = device_property_count_u32(dev, range_property_name);
+	nranges = fwnode_property_count_u32(fwnode_handle, range_property_name);
 	if (nranges < 2 || nranges % 2 || nranges > ARRAY_SIZE(range_params)) {
 		dev_err(dev, "%s port range: '%s' property\n",
 			nranges == -EINVAL ? "Missing" : "Invalid",
@@ -537,7 +542,7 @@ static int microchip_sgpio_get_ports(struct sgpio_priv *priv)
 		return -EINVAL;
 	}
 
-	ret = device_property_read_u32_array(dev, range_property_name,
+	ret = fwnode_property_read_u32_array(fwnode_handle, range_property_name,
 					     range_params, nranges);
 	if (ret) {
 		dev_err(dev, "failed to parse '%s' property: %d\n",
@@ -804,11 +809,38 @@ static int microchip_sgpio_register_bank(struct device *dev,
 	return ret;
 }
 
+static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
+	{
+		.compatible = "microchip,sparx5-sgpio",
+		.data = &properties_sparx5,
+	}, {
+		.compatible = "mscc,luton-sgpio",
+		.data = &properties_luton,
+	}, {
+		.compatible = "mscc,ocelot-sgpio",
+		.data = &properties_ocelot,
+	}, {
+		/* sentinel */
+	}
+};
+
+static struct sgpio_properties
+*microchip_sgpio_match_from_node(struct device_node *node)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(of_match_ptr(microchip_sgpio_gpio_of_match), node);
+	if (match)
+		return (struct sgpio_properties *)match->data;
+	return NULL;
+}
+
 static int microchip_sgpio_probe(struct platform_device *pdev)
 {
 	int div_clock = 0, ret, port, i, nbanks;
 	struct device *dev = &pdev->dev;
-	struct fwnode_handle *fwnode;
+	struct device_node *node = dev_of_node(dev);
+	struct fwnode_handle *child, *fwnode;
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
 	struct clk *clk;
@@ -825,18 +857,21 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->dev = dev;
+	priv->dev_node = node;
+
+	fwnode = of_fwnode_handle(node);
 
-	reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");
+	reset = devm_reset_control_get_optional_shared(dev, "switch");
 	if (IS_ERR(reset))
 		return dev_err_probe(dev, PTR_ERR(reset), "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	clk = devm_clk_get(dev, NULL);
+	clk = devm_get_clk_from_child(dev, node, NULL);
 	if (IS_ERR(clk))
 		return dev_err_probe(dev, PTR_ERR(clk), "Failed to get clock\n");
 
 	div_clock = clk_get_rate(clk);
-	if (device_property_read_u32(dev, "bus-frequency", &priv->clock))
+	if (fwnode_property_read_u32(fwnode, "bus-frequency", &priv->clock))
 		priv->clock = 12500000;
 	if (priv->clock == 0 || priv->clock > (div_clock / 2)) {
 		dev_err(dev, "Invalid frequency %d\n", priv->clock);
@@ -852,7 +887,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->regs);
 
 	priv->regs_offset = 0;
-	priv->properties = device_get_match_data(dev);
+	priv->properties = microchip_sgpio_match_from_node(node);
 	priv->in.is_input = true;
 
 	/* Get rest of device properties */
@@ -860,17 +895,17 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	nbanks = device_get_child_node_count(dev);
+	nbanks = fwnode_get_child_node_count(fwnode);
 	if (nbanks != 2) {
 		dev_err(dev, "Must have 2 banks (have %d)\n", nbanks);
 		return -EINVAL;
 	}
 
 	i = 0;
-	device_for_each_child_node(dev, fwnode) {
-		ret = microchip_sgpio_register_bank(dev, priv, fwnode, i++);
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = microchip_sgpio_register_bank(dev, priv, child, i++);
 		if (ret) {
-			fwnode_handle_put(fwnode);
+			fwnode_handle_put(child);
 			return ret;
 		}
 	}
@@ -892,21 +927,6 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
-	{
-		.compatible = "microchip,sparx5-sgpio",
-		.data = &properties_sparx5,
-	}, {
-		.compatible = "mscc,luton-sgpio",
-		.data = &properties_luton,
-	}, {
-		.compatible = "mscc,ocelot-sgpio",
-		.data = &properties_ocelot,
-	}, {
-		/* sentinel */
-	}
-};
-
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
 		.name = "pinctrl-microchip-sgpio",
-- 
2.25.1

