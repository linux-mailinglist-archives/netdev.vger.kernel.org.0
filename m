Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42BB414CBD
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhIVPMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:12:15 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:18976
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232274AbhIVPMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 11:12:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jd+achi8wWAF+XSJ3pyTMliSW1JoqT8/13RhyiSGJbJovyOYIHWl3+nBbZcBDdHZkHS5T7M+QVJ5e5ht1NZszuDgveYKJt4pEBjWfcmZUPfcPhx+uugrU73n7A7Acuj2jCPN+O9OSo4BNp5o/kaueDeerA+u33+MhoSgDGOASCLitYUkHkIUzESLrtLO4hwiDOTzMAKvoZnjqnZRsf10Y2Jzd/rVaFTkAR3bhN3Pkz1Z0ae+o74QHK0Nw0Pn4GqqqMgE5qnmeib0zDMISGT3Qac0k8fJCK9O8Bm5f7LmZofj9lhZSDxXjS0LIAsC3rTCun6f+TTyILkH3onfTJ1V5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+wA+wXrLCg6mb2Nmk4JjPrLCisj2lqnTtDL3L2XFFe8=;
 b=lDtnGdwhKtmLJKNYpYRbETlAz8wKXp2myt0zXy0qvJ7ItxAGmf0m9HQ1B8HAK6e0qwa2ECjmAXJ2BNngtW1f3ZRANYY3oCD5gtrCfkiwjRtgDn/fMis1tm19JACYb5s5Z7CbrDe+HqSKSpLNItL5K01HMmQooVouZt1lMhu0FDGVtw7auMboRW1wxviOEplL2mlqHb64hey5azT+hJai4NITtWHa00MsuQwqXE+ILbuY900M9NeYAAVnPI5bJFE9ReBXsVWRiH62HHutPKBOQH3iNZmE9cgi4fu6VNNlutjmuPJT1JSHGdRrB+ROH2FsMNPt59FdWikdu/iRl203kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wA+wXrLCg6mb2Nmk4JjPrLCisj2lqnTtDL3L2XFFe8=;
 b=m3YocZBnqFv7PK7qK6Y8BNZNSkcXWEt10kQGa66oSI068+cX5FcLHyl4K/JLXSJP0Z+5gVdJUdv7v/S7hbIJ+Up5eM74g8MKSkhVUNhqzebCiO+syVCFXsvOPTBElm8ghAZigJs9MJb9f4ed7KarQa6KGv91XxWg1bnUKOH2eP4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 15:10:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 15:10:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: sja1105: don't keep a persistent reference to the reset GPIO
Date:   Wed, 22 Sep 2021 18:10:29 +0300
Message-Id: <20210922151029.2457157-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0012.eurprd09.prod.outlook.com
 (2603:10a6:101:16::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0012.eurprd09.prod.outlook.com (2603:10a6:101:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 15:10:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6108b75d-5bc5-4a30-df29-08d97ddb2454
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74086956EC0B91896D1C23E6E0A29@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lM/3gp9ddEwsmeQDIW9vvlFa6zH+7Eydaw1M9lWIJnBXn6OQYS+IJgiEuWq6Lo7L1ytUX1YlLFzufK/jJjsoS182kquCdX2K++8n7lErY1Oyo5Hh/sHPN210GzqAu7vIlw5OHXnxj4vYvsfJmGOV5Cm276y0ZZXktzeMGYMnH/NXLWofSSAzSLH/At8e2Z7PuxQMU9yEI3ip3TgdpO0/spKg35C5BzzmEMZ3QdSvzNnjFSD3+LCRmSnS8cNkvXD3eKNz4RDKXLjycH6KmMxHgND8snylsK98HX7FMNbgNBbv6nDL6CvqhfKsI+jOLJffN/MyuzqMr3fZZKsP6PtRXE84p/HZ/tvgsMf3YIsPWas1e9yJy/8vrH78Osn+IagYHAzV7FF69d4FJ0Mte1noWFDvbdmHoi9J2XHOq140Bf7b4J3G0OvVHoi90u4svK6MB8V2FXJ6g73q0UTA0XXaEfAj3JjOgiqZDxJKNMus14Tb78FduxfbumY+y0Fu5sewcVXiP70vYRfWgq8QQnrknOUoXCMYyagJLhje2XiYRby+3BEGAj3M/trE+wc2d7btVGXKBvhFEH6LU0gOiKWGnKWYRds9rmVxq58wP8ysUuqoTQq+FOD1Hi8g0IIylQtaRVsHYne7V9UEqyrfRFtqxDDwRGfFzk1dR+fBZfsGg48CNWRxEkTQOuSX4yd5cE8T+Hnl4gHY6gc3sPjlfnPPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(44832011)(2906002)(6666004)(8676002)(316002)(4326008)(54906003)(6512007)(6486002)(26005)(186003)(2616005)(36756003)(38100700002)(508600001)(38350700002)(52116002)(66946007)(66476007)(5660300002)(1076003)(83380400001)(86362001)(66556008)(6506007)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?878Nw6tQQNx3g/zGqLmOT/CIa7NN5MD2800FZ0z5OARjKc/1RH0Hh8MG0BGH?=
 =?us-ascii?Q?w7sMJ0fIsASfK+Z8IqsCSf2b5ifebpucvUV/r87Ph/fNMtLkOWZ/u8tllKUr?=
 =?us-ascii?Q?Hq/nyR3PaJwpiJ0BeWPW7DOe0h8d3+P6TWa/HlcE9/vACNzM8pgXqhHPmxiC?=
 =?us-ascii?Q?yFRFgHYfSQRCms48C0sGEqQf9CAnIaTEN4xhQihalakmiMimlz/oAImPYs1A?=
 =?us-ascii?Q?vdouwLUlslMw/o1hxWwcdG1kn2p3umLJaoOOxQQcYoQVWgyEK1p1WbBYenGV?=
 =?us-ascii?Q?NHQpiwKb1FaGj5kuB6DS6uQWP3R3d8maRGzZ0NmTYlS+xTTjAIsY282uujpN?=
 =?us-ascii?Q?ooHZvacT/Bk4RUSiaA/BU/iS+twF62Go16CxbVz5G00Iyoxa2KVKjrOFYur2?=
 =?us-ascii?Q?+1ZSIIM5giG9tAH5/frP6jPbIzayl/472cjB2KFiRwXUdj8vMzDKg8PT1FRV?=
 =?us-ascii?Q?rKuFpCdwDiLW58AAQKwllCKtE5BzbWnBIXIMpFwSEZW4xvfSqYMQDKJTYJJB?=
 =?us-ascii?Q?22pfr86jtWBXUHOA0W8twu9Hmd5tGMk+GzcoZATKU5w1937lq/N9O+d/h0aM?=
 =?us-ascii?Q?JkCltNCdidkLcDMZbf7mZOfcfs+4t4LpWKPVOenO//L1oImP2llrFx3xWDfJ?=
 =?us-ascii?Q?7phpYd87NnaVZf7iKLkTTnAzr3tedZDi+xbQDSGgIPD9gy0NzehNUDmIjXFA?=
 =?us-ascii?Q?APOE4LrFcjYmgMgzvyTJq8bzYHXAbSYPZL8KcbHVFBtwYDuaCa5+1uLaNUBV?=
 =?us-ascii?Q?nFABn33ZDJTBhP3rbvG4I0SvQtg5s9Uabs8oyKUq5uDoiJly4j674ywsNR2U?=
 =?us-ascii?Q?JgjwDE+2R/MLLLd0qlXF3xB/VlS/BYvXaMO1tBwC0tPXTmhapnG7X7eyyrUo?=
 =?us-ascii?Q?hXk4Rqis4vF4GeOApEiy41TzmS6HCQfegWrVRFwAmZ75Mb/esZB+xYDPzhdG?=
 =?us-ascii?Q?HdDL6vEw3U/JUyKrd+OUDGCJDWr0pOp87qtk34As3f2zxVmozlt2RmQaOHQ2?=
 =?us-ascii?Q?zr1RndEDnn3b2v8987+MoB7oi8ZC/1nSaGgYAS5BeY8OxjvAtX4vTYNCxgTT?=
 =?us-ascii?Q?PLgy8U4gxOA08BC8/D09OIGOOckr/DSugIEQFGsu1zgZYzWp08o7kc+rUXTM?=
 =?us-ascii?Q?CQ4ritVQ2tPuIhKqgBsgISCOgipGYRFWdRip7zmgNKhcHcVI/jaa56ICI6tw?=
 =?us-ascii?Q?CoB8Y5RrpuFtLkza1brEUWO3DwlaldbVUpnklWYlWArNfYb/GR+8UHKAG2Vu?=
 =?us-ascii?Q?dg50ePJlML2meToXDfHDrCyMLuaSCunzhrYXY9y+LhRfPNLSL8OcYbdQbRD3?=
 =?us-ascii?Q?5V4IHX/hNlw9qNdgAVi/GKTA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6108b75d-5bc5-4a30-df29-08d97ddb2454
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 15:10:41.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXKHJ0pvCd/OW5xdyqdMB/BekPHra4AzlxOaiOucxg+GJ1aCKQSCuqWHcqoFvwt62l98jpeAipAr4vtQBQ4Obg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver only needs the reset GPIO for a very brief period, so instead
of using devres and keeping the descriptor pointer inside priv, just use
that descriptor inside the sja1105_hw_reset function and then let go of
it.

Also use gpiod_get_optional while at it, and error out on real errors
(bad flags etc).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++--------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index b83a5114348c..618c8d6a8be1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -230,7 +230,6 @@ struct sja1105_private {
 	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
 	size_t max_xfer_len;
-	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	u16 bridge_pvid[SJA1105_MAX_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 22f39c35f53f..741e965f6068 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -27,15 +27,29 @@
 
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
 
-static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
-			     unsigned int startup_delay)
+/* Configure the optional reset pin and bring up switch */
+static int sja1105_hw_reset(struct device *dev, unsigned int pulse_len,
+			    unsigned int startup_delay)
 {
+	struct gpio_desc *gpio;
+
+	gpio = gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(gpio))
+		return PTR_ERR(gpio);
+
+	if (!gpio)
+		return 0;
+
 	gpiod_set_value_cansleep(gpio, 1);
 	/* Wait for minimum reset pulse length */
 	msleep(pulse_len);
 	gpiod_set_value_cansleep(gpio, 0);
 	/* Wait until chip is ready after reset */
 	msleep(startup_delay);
+
+	gpiod_put(gpio);
+
+	return 0;
 }
 
 static void
@@ -3224,17 +3238,14 @@ static int sja1105_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	rc = sja1105_hw_reset(dev, 1, 1);
+	if (rc)
+		return rc;
+
 	priv = devm_kzalloc(dev, sizeof(struct sja1105_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	/* Configure the optional reset pin and bring up switch */
-	priv->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(priv->reset_gpio))
-		dev_dbg(dev, "reset-gpios not defined, ignoring\n");
-	else
-		sja1105_hw_reset(priv->reset_gpio, 1, 1);
-
 	/* Populate our driver private structure (priv) based on
 	 * the device tree node that was probed (spi)
 	 */
-- 
2.25.1

