Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3BC698E20
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBPHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjBPHxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:55 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B446D4A;
        Wed, 15 Feb 2023 23:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9myIf5R6adMgeLSEDQ7Zhvh99VBRj/PrKvoo71z5ml5TvgUrFGM0NLTNzYbelqWNc7BGaB0yaFAt6VVgD7ddfzCVOcWqYNv9LkZ/Zsb95VTkgAyJRZTPOvdyqoHyt2mJsU2EFRwQW0SeQ+Dw0K3vWHqCyZM65ojnQagemFlPuqwgd2L/abQj3HYxj5brucmm8XLfXJJZHHhWoZLx8nLyO3umhyNxBAzHdDKSrLv5dFleVt6/Zlkyuc+ykAZj+JW4yA3oLPslWaH/46Eid+rPGNAuyZt6wJLIZaFRcyEMdPqv+8l0vMktG6whH8yHKMzmDFIjFKSeNiKhL7F2DC2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXASoJEFaftM0o1PvA9J4RpnlwHgOL8maWN5ZGyU6iI=;
 b=WirR/VHsWHPd5YPt/bjmx2wuWVu/1NZHEy8bp+RUIYkfQy3m5Muqim6MC5l0/Z5MWUdrqAO2G9wBGxL41pvbAPdApkebVptyl99VIA+Uxh6TQXhFzmMjv/rdNe+UeheAlx541uFJmBS1LPy6G2mUSKIGb6SsOaMpiJRC49Vc0y8YV7IqCQiHexguAv4aPsMHzPzuHMvuYcqlBKcxbRLH1sbkuNycojPijjVN5UU8riQ/VyW8+X47JZ9hzw0NyCDZxqlP61+BoqSDXLSOVkFI0fyHCCNMbdpnBa7N5tT7NjeyCj4Qx5IbPQm7VjoUDgQ7tUyFV7lhEFeXlP+EFVB5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXASoJEFaftM0o1PvA9J4RpnlwHgOL8maWN5ZGyU6iI=;
 b=RFO+DSUGAUoZ/fBqOyxwNDUNigeRrNfrMXTUHu/iAAfPP70FUw91VADhv4b/nUxDdZj/LD5n8POUACsMrOurcn5G3RG2oVpwsgdyiqrt+0aBC2wcwuJ8uQuCuZ4rhkIoyYdeDNQRTasLXRt6HbXgKgxiaay4kCQBeMd5AExV63w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 7/7] net: dsa: ocelot_ext: add support for external phys
Date:   Wed, 15 Feb 2023 23:53:21 -0800
Message-Id: <20230216075321.2898003-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216075321.2898003-1-colin.foster@in-advantage.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c0e3ce2-439e-49f9-3f9b-08db0ff2ed3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuU3L6a5G4gpMJJa5gIrBAc+npbeGvNAd/qfW9cxMGEo+gNgpfnem4QbD2Mo02iiCMEzimDnuLzoSuf02brgonUFy+gQKOeR9LUn/wqaM/FDHXHj2q2adp5WuzUdt8CZOpXWi47h2eXO/RetgpVCOtAAhVFa5qEUo29zp4t2w8iPBuZYE7YTZjjowDVOdkFlo/bhnCs5B2tTpo+YDePgJOkNm3mjRuFbvf+zjGVa7Naswxyi+xDnkXEEyaarGs2VkMAkURgNT7thcWx8fsGqtvmnQrl5GfKKoVfpD9p4A79s1oQEw13GzK44rEXpQhZIvLGgSOjawtoNTWu42wVuFEzxOcQ+LwactXm2BsNBFr/L7t/YHNL0ixnLe/2IhVSYvLUWekJoXTfnPU6LFAhocnOwI/5W8KAPXwu3qeHEOMdRuEUGDGfg+Y0Ge71HP6cl8IRiyCWxXV/tqRCk9pRLkTWLOiBxpId8v2FQWKJAu9v/zDXBSnMMb+rq50y34VOt5+nrWmmHLQMMkhpjf+csmr93sRsptd7FflcCs+E3PdcZbxx9/7xmjO9jwcpKBmMUANr2Ixxb8XgrLfB1vAxQIlmmJinlAbjLIGOI9F0UyZmR3xJEPZhaEzt5BFzB3rGbBZV5bXquCdIRt0AyM9f06tK2xX+sDh9cSuJHz5GNTvAjD+p0D6at4Uy/Y9DE03q6iovirY4eTx0kSIXFRlwP9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(83380400001)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(66899018)(52116002)(6486002)(30864003)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ctaF2cFn8buXG/8kHSPVZsZKp4sBgeS36pGUCmoCT9MhYnTZBw3mfXLTgGKw?=
 =?us-ascii?Q?rKOWzuK5s1pIEWebavoP+jVjXvGL0u9GpUQaYVaxDubUbkNYYGILEjTVlqaK?=
 =?us-ascii?Q?ecJXd/98LBHtB8oOXHbOTHGaBOOv5cg6VbmPYLjCSIwZ69R33RtsCJmjuvzm?=
 =?us-ascii?Q?WHIJ1e38qncJLjVwSiosvmIS9fTf+0uluia2ktKjApPtcgBfXyekdAZNu3G9?=
 =?us-ascii?Q?RU410GAyQj7wcm6OWY9xw4KH2sXZrZBqBCLsgSV78cdVCucalOqoOqRUOHuG?=
 =?us-ascii?Q?nvqICdhLLl1yR8uRYn0DYT3XhL9GqgufURkG3jfJBofaKexVhVY9G6Nfl00w?=
 =?us-ascii?Q?IkZ/+bCedcMLB0vLQMi5mBND36+IbbsDwUtAJX9hmFpqFZ9R4I/oQkv/Ox6A?=
 =?us-ascii?Q?p3HEW9WjmEKoHomBkcHnlL7m/W9Y3Ru3E3X0ZRcV5ZrvZgCua8EpxXrcLSlJ?=
 =?us-ascii?Q?P6wVEKthk3gCPfsxMWYtnHkZTHU0I+9g6NzjhMwVR0K4oub5eR8i9EjRLdaC?=
 =?us-ascii?Q?nJMfjYvyIyZYZeoHVNBQMtVPJ215XXxe3BWUHyXJ04WC0JoJnfvaZM0E6OqY?=
 =?us-ascii?Q?uMJamaEJ2IHEFiszNb5Mpp+aBR8tbL5WflyFYFYDD/Fij40Edz6c6M+EJdx7?=
 =?us-ascii?Q?BQUYsNYsrpAh3BXSGcpkiDbmd0szvfAu/i1AMqZIbQRuH6ZdCKmdeRWiE8Jb?=
 =?us-ascii?Q?V7fvBhKZCVDrDQ39Hck7nRT9oUHI0sSK8e5LikNr21Z+hhcbayCOj5DE4M+w?=
 =?us-ascii?Q?tZ9BnWFtUPiflRXhB+XB7WoeGHyWABpkMpsdTyjGX11InYCIpyaDwxlNLFZR?=
 =?us-ascii?Q?AUnIa+i+2iHeoSpGOvi4mnkUOtNj8aCsoQ6f1+7iFQvkOQa9DwcInh9P1pHq?=
 =?us-ascii?Q?TNvBAkf0IvnOYkf0u4z2+ghcgKoL43955EdX/WHW+oJjgYHIAulxRnPnNXLM?=
 =?us-ascii?Q?EP0weIa8lKnhsxUCAiXmshtLfMUth0XaIfGo+s4nytgrBWpuC8TvUHbDBs00?=
 =?us-ascii?Q?Vh/jfRwH9beM+BNOxkKRFwnwaK4jTWgfBw9vmFxG2OwRxBAHA37vZlJOhGQJ?=
 =?us-ascii?Q?77IsQcgS72bMcVxCwBjtAieUJt+dUakRpgRrKrCee3R91XAH84WVCZoD2Mo+?=
 =?us-ascii?Q?F+9a1H74wePQQ7jDaM71/AlBoZZNgJbc9oydJUOcqncsF2/EYYrMYBNW1abU?=
 =?us-ascii?Q?gMMWmi9caFvVqkifp5nrYbw2imxyAV1XxBSwa4SCBOVjGA2S6RlBx02EUZ5b?=
 =?us-ascii?Q?Xb6Q0C8V7zULPretmeSF3sgyZAxhsZjhlkeiGruCseIITTy37d2+5B8HgNd+?=
 =?us-ascii?Q?7uERV/QShAtQm3iTirHB1TXi186fQ2bsgXQf5gSdP3MCvoosJZ9WcQK/2tdS?=
 =?us-ascii?Q?kAggenh07z2CbSXhdgjV+LLmBjygkw4il4C5lBl+hEt1T6GEBKCpVn46cX12?=
 =?us-ascii?Q?TvgcXbY60Fnv8QvkTN/ABkovR6anrMnG26LvfmRzyOlUfYIvs22yw7RFB0pE?=
 =?us-ascii?Q?lWH8TS/7m2JqQ+eO2fR+q4dMqDMYg6BnEl9JNAJElCriN5c46REgnnxe7Je+?=
 =?us-ascii?Q?vYe6G3DAFLNjg7bT8pzgUWMVhrwlPY0EXC3TPa88AU6sJLju6TjxfFHB20HI?=
 =?us-ascii?Q?xGwxO4n/yM2ahi28RUJDyGo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0e3ce2-439e-49f9-3f9b-08db0ff2ed3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:44.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyKsNffDssYjTln8wjgxVSZ+4cvNGj8H7H8brpUZRNYxL5f0MMNwB0JGd3m1r71jM5LO/OWWtbDtFZ4hh4XcxhyOm3lOg45tZN1BgVElgMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 has four internal copper ports, and can be configured to work
in various configurations with up to six additional ports. Support for the
initial four ports was added in commit 3d7316ac81ac ("net: dsa: ocelot: add
external ocelot switch control"). This patch adds support for the
additional ports.

The specific hardware configuration for this development uses a QSGMII link
between a VSC7512 and a VSC8514. The VSC8514 offers connection to four RJ45
ports, all of which are verified functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.h      |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 319 ++++++++++++++++++++++++++--
 2 files changed, 305 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index ffb60bcf1817..fdd402305925 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -6,6 +6,7 @@
 
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
 #define FELIX_MAC_QUIRKS		OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION
+#define OCELOT_EXT_MAC_QUIRKS		OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
 
 #define OCELOT_PORT_MODE_NONE		0
 #define OCELOT_PORT_MODE_INTERNAL	BIT(0)
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index 14efa6387bd7..f10271b973b2 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -4,10 +4,13 @@
  */
 
 #include <linux/mfd/ocelot.h>
+#include <linux/of_net.h>
+#include <linux/phy/phy.h>
 #include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <soc/mscc/ocelot.h>
+#include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/vsc7514_regs.h>
 #include "felix.h"
 
@@ -16,20 +19,283 @@
 #define OCELOT_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
 					 OCELOT_PORT_MODE_QSGMII)
 
+#define phylink_config_to_ocelot_port(config) \
+	container_of(config, struct ocelot_ext_port_priv, phylink_config)
+#define phylink_pcs_to_ocelot_port(pl_pcs) \
+	container_of(pl_pcs, struct ocelot_ext_port_priv, pcs)
+
+struct ocelot_ext_port_priv {
+	struct device_node *node;
+	struct phylink_config phylink_config;
+	struct phylink *phylink;
+	struct ocelot *ocelot;
+	int chip_port;
+	struct phylink_pcs pcs;
+};
+
+struct ocelot_ext_priv {
+	struct felix felix;
+	struct ocelot_ext_port_priv *port_priv[VSC7514_NUM_PORTS];
+};
+
+static struct ocelot_ext_priv *felix_to_ocelot_ext_priv(struct felix *felix)
+{
+	return container_of(felix, struct ocelot_ext_priv, felix);
+}
+
 static const u32 vsc7512_port_modes[VSC7514_NUM_PORTS] = {
 	OCELOT_PORT_MODE_INTERNAL,
 	OCELOT_PORT_MODE_INTERNAL,
 	OCELOT_PORT_MODE_INTERNAL,
 	OCELOT_PORT_MODE_INTERNAL,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SGMII,
+	OCELOT_PORT_MODE_SERDES,
+};
+
+static void ocelot_ext_phylink_of_cleanup(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct ocelot_ext_priv *ocelot_ext_priv;
+	int i;
+
+	ocelot_ext_priv = felix_to_ocelot_ext_priv(felix);
+	for (i = 0; i < VSC7514_NUM_PORTS; i++) {
+		struct ocelot_ext_port_priv *port_priv;
+
+		port_priv = ocelot_ext_priv->port_priv[i];
+		if (port_priv && port_priv->node)
+			of_node_put(port_priv->node);
+	}
+}
+
+static void ocelot_ext_phylink_mac_config(struct phylink_config *config,
+					  unsigned int link_an_mode,
+					  const struct phylink_link_state *state)
+{
+	struct ocelot_ext_port_priv *priv =
+		phylink_config_to_ocelot_port(config);
+	struct ocelot *ocelot = priv->ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_config(ocelot, port, link_an_mode, state);
+}
+
+static void ocelot_ext_phylink_mac_link_down(struct phylink_config *config,
+					     unsigned int link_an_mode,
+					     phy_interface_t interface)
+{
+	struct ocelot_ext_port_priv *priv =
+		phylink_config_to_ocelot_port(config);
+	struct ocelot *ocelot = priv->ocelot;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
+				     felix->info->quirks);
+}
+
+static void ocelot_ext_phylink_mac_link_up(struct phylink_config *config,
+					   struct phy_device *phydev,
+					   unsigned int link_an_mode,
+					   phy_interface_t interface,
+					   int speed, int duplex,
+					   bool tx_pause, bool rx_pause)
+{
+	struct ocelot_ext_port_priv *priv =
+		phylink_config_to_ocelot_port(config);
+	struct ocelot *ocelot = priv->ocelot;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
+				   interface, speed, duplex, tx_pause, rx_pause,
+				   felix->info->quirks);
+}
+
+static const struct phylink_mac_ops ocelot_ext_phylink_ops = {
+	.validate		= phylink_generic_validate,
+	.mac_config		= ocelot_ext_phylink_mac_config,
+	.mac_link_down		= ocelot_ext_phylink_mac_link_down,
+	.mac_link_up		= ocelot_ext_phylink_mac_link_up,
+};
+
+static void ocelot_ext_pcs_get_state(struct phylink_pcs *pcs,
+				     struct phylink_link_state *state)
+{
+	struct ocelot_ext_port_priv *port_priv =
+		phylink_pcs_to_ocelot_port(pcs);
+
+	/* TODO: Determine state from hardware? */
+}
+
+static int ocelot_ext_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+				 phy_interface_t interface,
+				 const unsigned long *advertising,
+				 bool permit_pause_to_mac)
+{
+	struct ocelot_ext_port_priv *port_priv =
+		phylink_pcs_to_ocelot_port(pcs);
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_QSGMII:
+		ocelot_ext_phylink_mac_config(&port_priv->phylink_config, mode,
+					      NULL);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void ocelot_ext_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	/* TODO: Restart autonegotiaion process */
+}
+
+static void ocelot_ext_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+				   phy_interface_t interface, int speed,
+				   int duplex)
+{
+	struct ocelot_ext_port_priv *port_priv =
+		phylink_pcs_to_ocelot_port(pcs);
+
+	ocelot_ext_phylink_mac_link_up(&port_priv->phylink_config, NULL, mode,
+				       interface, speed, duplex, false, false);
+}
+
+static const struct phylink_pcs_ops ocelot_ext_pcs_ops = {
+	.pcs_get_state = ocelot_ext_pcs_get_state,
+	.pcs_config = ocelot_ext_pcs_config,
+	.pcs_an_restart = ocelot_ext_pcs_an_restart,
+	.pcs_link_up = ocelot_ext_pcs_link_up,
 };
 
+static int ocelot_ext_parse_port_node(struct ocelot *ocelot,
+				      struct device_node *ports_node,
+				      phy_interface_t phy_mode, int port)
+{
+	struct ocelot_ext_port_priv *ocelot_ext_port_priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct ocelot_ext_priv *ocelot_ext_priv;
+
+	ocelot_ext_priv = felix_to_ocelot_ext_priv(felix);
+
+	ocelot_ext_port_priv = devm_kzalloc(ocelot->dev,
+					    sizeof(*ocelot_ext_port_priv),
+					    GFP_KERNEL);
+	if (!ocelot_ext_port_priv)
+		return -ENOMEM;
+
+	ocelot_ext_port_priv->ocelot = ocelot;
+	ocelot_ext_port_priv->chip_port = port;
+	ocelot_ext_port_priv->pcs.ops = &ocelot_ext_pcs_ops;
+
+	if (!felix->pcs)
+		felix->pcs = devm_kcalloc(ocelot->dev, felix->info->num_ports,
+					  sizeof(struct phylink_pcs *),
+					  GFP_KERNEL);
+
+	if (!felix->pcs)
+		return -ENOMEM;
+
+	felix->pcs[port] = &ocelot_ext_port_priv->pcs;
+
+	ocelot_ext_priv->port_priv[port] = ocelot_ext_port_priv;
+
+	ocelot_ext_port_priv->node = of_node_get(ports_node);
+
+	return 0;
+}
+
+static int ocelot_ext_phylink_create(struct ocelot *ocelot, int port)
+{
+	struct ocelot_ext_port_priv *ocelot_ext_port_priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct ocelot_ext_priv *ocelot_ext_priv;
+	struct device *dev = ocelot->dev;
+	struct ocelot_port *ocelot_port;
+	struct device_node *portnp;
+	phy_interface_t phy_mode;
+	struct phylink *phylink;
+	int err;
+
+	ocelot_ext_priv = felix_to_ocelot_ext_priv(felix);
+	ocelot_port = ocelot->ports[port];
+	ocelot_ext_port_priv = ocelot_ext_priv->port_priv[port];
+
+	if (!ocelot_ext_port_priv)
+		return 0;
+
+	portnp = ocelot_ext_port_priv->node;
+	phy_mode = ocelot_port->phy_mode;
+
+	/* Break out early if we're internal...? */
+	if (phy_mode == PHY_INTERFACE_MODE_INTERNAL)
+		return 0;
+
+	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
+		ocelot_port_rmwl(ocelot_port, 0,
+				 DEV_CLOCK_CFG_MAC_TX_RST |
+				 DEV_CLOCK_CFG_MAC_RX_RST,
+				 DEV_CLOCK_CFG);
+
+	if (phy_mode != PHY_INTERFACE_MODE_INTERNAL) {
+		struct phy *serdes = of_phy_get(portnp, NULL);
+
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			dev_err_probe(dev, err,
+				      "missing SerDes phys for port %d\n",
+				      port);
+			return err;
+		}
+
+		err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode);
+		of_phy_put(serdes);
+		if (err) {
+			dev_err(dev,
+				"Could not set SerDes mode on port %d: %pe\n",
+				port, ERR_PTR(err));
+			return err;
+		}
+	}
+
+	ocelot_ext_port_priv->phylink_config.dev = dev;
+	ocelot_ext_port_priv->phylink_config.type = PHYLINK_DEV;
+	ocelot_ext_port_priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
+		MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
+
+	__set_bit(ocelot_port->phy_mode,
+		  ocelot_ext_port_priv->phylink_config.supported_interfaces);
+
+	phylink = phylink_create(&ocelot_ext_port_priv->phylink_config,
+				 of_fwnode_handle(portnp),
+				 phy_mode, &ocelot_ext_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		dev_err(dev, "Could not create phylink (%pe)\n", phylink);
+		return err;
+	}
+
+	ocelot_ext_port_priv->phylink = phylink;
+
+	err = phylink_of_phy_connect(phylink, portnp, 0);
+	if (err) {
+		dev_err(dev, "Could not connect to PHY: %pe\n", ERR_PTR(err));
+		phylink_destroy(phylink);
+		ocelot_ext_port_priv->phylink = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
 static const struct ocelot_ops ocelot_ext_ops = {
 	.reset		= ocelot_reset,
 	.wm_enc		= ocelot_wm_enc,
@@ -48,6 +314,7 @@ static const char * const vsc7512_resource_names[TARGET_MAX] = {
 	[QS] = "qs",
 	[QSYS] = "qsys",
 	[ANA] = "ana",
+	[HSIO] = "hsio",
 };
 
 static const struct felix_info vsc7512_info = {
@@ -56,25 +323,32 @@ static const struct felix_info vsc7512_info = {
 	.map				= vsc7514_regmap,
 	.ops				= &ocelot_ext_ops,
 	.vcap				= vsc7514_vcap_props,
+	.quirks				= OCELOT_EXT_MAC_QUIRKS,
 	.num_mact_rows			= 1024,
 	.num_ports			= VSC7514_NUM_PORTS,
 	.num_tx_queues			= OCELOT_NUM_TC,
 	.port_modes			= vsc7512_port_modes,
+	.parse_port_node		= ocelot_ext_parse_port_node,
+	.phylink_create			= ocelot_ext_phylink_create,
+	.phylink_of_cleanup		= ocelot_ext_phylink_of_cleanup,
 };
 
 static int ocelot_ext_probe(struct platform_device *pdev)
 {
+	struct ocelot_ext_priv *ocelot_ext_priv;
 	struct device *dev = &pdev->dev;
 	struct dsa_switch *ds;
 	struct ocelot *ocelot;
 	struct felix *felix;
 	int err;
 
-	felix = kzalloc(sizeof(*felix), GFP_KERNEL);
-	if (!felix)
+	ocelot_ext_priv = kzalloc(sizeof(*ocelot_ext_priv), GFP_KERNEL);
+	if (!ocelot_ext_priv)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, felix);
+	dev_set_drvdata(dev, ocelot_ext_priv);
+
+	felix = &ocelot_ext_priv->felix;
 
 	ocelot = &felix->ocelot;
 	ocelot->dev = dev;
@@ -116,28 +390,43 @@ static int ocelot_ext_probe(struct platform_device *pdev)
 
 static int ocelot_ext_remove(struct platform_device *pdev)
 {
-	struct felix *felix = dev_get_drvdata(&pdev->dev);
+	struct ocelot_ext_priv *ocelot_ext_priv = dev_get_drvdata(&pdev->dev);
+	struct felix *felix;
 
-	if (!felix)
+	if (!ocelot_ext_priv)
 		return 0;
 
+	felix = &ocelot_ext_priv->felix;
+
 	dsa_unregister_switch(felix->ds);
 
 	kfree(felix->ds);
-	kfree(felix);
+	kfree(ocelot_ext_priv);
 
 	return 0;
 }
 
 static void ocelot_ext_shutdown(struct platform_device *pdev)
 {
-	struct felix *felix = dev_get_drvdata(&pdev->dev);
+	struct ocelot_ext_priv *ocelot_ext_priv = dev_get_drvdata(&pdev->dev);
+	struct ocelot_ext_port_priv *port_priv;
+	struct felix *felix;
+	int i;
 
-	if (!felix)
+	if (!ocelot_ext_priv)
 		return;
 
+	felix = &ocelot_ext_priv->felix;
+
 	dsa_switch_shutdown(felix->ds);
 
+	for (i = 0; i < felix->info->num_ports; i++) {
+		port_priv = ocelot_ext_priv->port_priv[i];
+
+		if (port_priv && port_priv->phylink)
+			phylink_destroy(port_priv->phylink);
+	}
+
 	dev_set_drvdata(&pdev->dev, NULL);
 }
 
-- 
2.25.1

