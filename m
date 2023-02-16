Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BDC698E1B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjBPHxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBPHxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:44 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4A4457E7;
        Wed, 15 Feb 2023 23:53:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwqyPy2ksXU1jwOutKYmVZLEb2VJ5NW3BxQlhL8gMtWD2N2NHeDPNWd6AOjyd4pNJtk8zL3EOKWwKE2j7Rpulj2kBoWefEgk8fthPXJB8De5pTKnZMoXrGv8BN1uM+4bQaBPifgv7Zf8pEqCcfZdseFLSnuSF3rKlNjg2kAewtqGodExLi/HGzKckOQAEPBp5ipvPbnwLu/eFQhz8XeCiR9xSeFrRCv8VwLhqMtoCrGk0M6F9Sj4nPGdWEPJXomeMoyUNzZsDwlrOoRm+fIlmdiBktj7vyZ17pSRVmMJWLFblAPeFcRIIC6rRG4EMFLlx0gs0iX03+716ElYPHfuGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikoCzvkJwxDEDtVMBtlJxrpKoStZKBoWdCQ6UY8oBgs=;
 b=UhNzeTYiln/3qnPZtvy3iQ9y6dp0735WjNOIi2X5TPZS1Z+UyQWVYVqE6lqjFTOA6V7ml0+qyXXw4VeCc0zH3Z3jMmafSag1kgtHz857eGtsbJ2viyyXPaX1/zLToCMbskqWlA0/TmEdLn1Eq/NSiUtjXLFedgze+tyoB1P8zt32L/UEDXdYHSJfDV7MOoBX4rYxwFm88w2X1HOcPrqiu1uhFLnxS72DodhtPJ6J33uH6dSRUb5yig/vWvmjQ17Uvi4HVImJ+6+RO6tYMLzEbUD9jpErRza7SH1HUQqR2pnuOFnNsTzAXDv87NCXZ3QWWsklMAYLMLkMk4/HA3r9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikoCzvkJwxDEDtVMBtlJxrpKoStZKBoWdCQ6UY8oBgs=;
 b=DpVKxshTnWFEtspNnUZ+Jl+WOrdwFT9tUSGzadyXqOcq6Q69/oIeybod3VjK97L6VBo/S+lvD5l4eqWe9ysxv4bplnaw1MGVWHZfA1vR8uvnZ7qLPsTbOjjCBfq/wuCPmu1Q7xpOAokb3MIEXls/c+3zvoHK02aDb06ImhuepIw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:40 +0000
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
Subject: [RFC v1 net-next 4/7] net: mscc: ocelot: expose generic phylink_mac_config routine
Date:   Wed, 15 Feb 2023 23:53:18 -0800
Message-Id: <20230216075321.2898003-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 822d5cd9-a75e-4919-a082-08db0ff2eaed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13jp7GOR7xHp8nQtC2KuNz7p4fKOGlFjGCXcm62/6z38Wme7+fNX+Sjn5L0zbkMoHyuwl4ZFlHGg9wvo2vZ1wBajFkW7jXC8hhtzOXtBCwRTq6vcOsDtjgSYPCTPi5nWPdPtZ3xfkik1CF2Xq+zE7HdDQQ7u7BChKZED6Llk8oCcgPZsZnphCEYdbsAqQgpxK60hjmU+bsU5rec3ewH8UOWG94+LTyHEmVhbKqY8We49mgo/Z1mM3KsaBOzaQVhfaYMcmTVcbPgvUflTb5aOG1quA2Md20BMIGjCbqbIbTkMFUaEGFYc0qpta4IlzsnreAqRGiqDXyzZd2B6a2MWmLTCQ09qHDROucG5Ltf2MrB2geR9CK/c3R9iqzy4BWsp1gzXxlxNbUkxMH0jC0Axh9W6pSEcl1igDd3P86b/dEHABbKsbAop4A6B5Z4w7dVH8Zt7eK9apHb0sNhV0D0+RoHTwkAV2wXJ6QnauiuNgH/LE/j0MWCE8cSGnO2UrIlM+uaC2WvCW+kE70U8Y9IjY2Zp4/KFF9E4Av+vTIBJPYDF+AjIBO+mZ9lsEIhwU9od1I8lz08tD8Bns2i26W7lpMJ6soF5e1OMtkVmnkb7VGsT1nlTVEmrYtwNNKL3v+Yaeg319HVpmUOvTXib0aqM6Q5vTpb7C0K71C1aaeew7Hwzhw3wrqceLTFBp0lF39OU90pGWsO3JxHGyfSs7bcg7XYuuNqXT5OzqT2Qoi+Zetk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(83380400001)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j0AeEHXSSGkFjUvM6ZIaiaY+LEiXvIlQ2ImPI5ZBwfS8tjr5fKKoU804g+9T?=
 =?us-ascii?Q?pfk5lZNIa+eRwD1521x0vzAoTsmsO9nTQ2IRXadg+qvxph57ZK8GNTprNCg4?=
 =?us-ascii?Q?+nwCh347p5+EGHwOC0iEcfu5r0x89Eeu4A/7TH53/RwgAqfu7FESN93GimgE?=
 =?us-ascii?Q?W8MMdEYgz3nB177eaoOiqIvfA5WARh125VW1iZXiVe1NEPyjVOhkpfksyMQe?=
 =?us-ascii?Q?wkHzXlHWuK9+W8923GQZOBSO7onF+mLBW8HbtrBs7hrClfmrnMoMPh1AvLox?=
 =?us-ascii?Q?2HxyLhlC2JnW0YnK0FU0v26RSsYoeaMszl3pqsThFylkIQ8x6Wu1/AGn//aF?=
 =?us-ascii?Q?5dnipuu6dkpNKq4ZpIdnJKgUifO6oiOv2dMjFjjYGWKwH2xEFRO27KgHnFsh?=
 =?us-ascii?Q?XgxWFwrnz9va1wQWrhemF0JWyjN/Y8DyikUBXIDmG2rfBYjwM7PZqLHFBej9?=
 =?us-ascii?Q?HnQzNM53FwDOWOo1THZeEHpoLdl8c+XkaO5oFI216lBHZc4J3iNhYKaZQN2k?=
 =?us-ascii?Q?G98R0xyzEnb88T28zAEvneruNRAMZcMA8F7N5pivTNFdfkmbiIqHIdiio96i?=
 =?us-ascii?Q?KCJurOWP2No7ay62fnwMGuvCS2i5rvjMqbV+zN10rH+GRu9fNfT3/hnjoBtm?=
 =?us-ascii?Q?Cxu7Z+kUhe8rFFT/Tj351+QPfVWANB/vpoitcPaw4Unh8xDcSBjPBaneKkXF?=
 =?us-ascii?Q?0mqy5wkUB2lLWajn4No9E+UH+rkO9TP7CU2Pd9GZ/Q3tN2yQVW6mYPyI4IFI?=
 =?us-ascii?Q?KKWSVvWdy+oZWCnVEc2yniM/1xpegGR6t2Sdiy3x54GAPZi+7iol9cWJpTB3?=
 =?us-ascii?Q?S8llbEdZQbqt1NnVkLfWnWNVas+UVCwEarqpdqdedcRmZk91uSjQzbKiHoYW?=
 =?us-ascii?Q?YJQDP25e6xzx49CniS8aiTpNvIasIWmLE+BwcZQZCdJT1U8moKKCkWUpdTVL?=
 =?us-ascii?Q?7I6mFGspowhB37KRGigWNKm5bDsiQe/eMxBoAkKo9cSohr+wtRFM+jR1DQLp?=
 =?us-ascii?Q?FbNCt+H5sGBhK4ouHyb8E92+IqouEm3mdSzCFtPJKRGqJm2vfCXv73KyVg4f?=
 =?us-ascii?Q?89ZaM4cAcvUVSqv3syLwedEicMiFdI9GVrf89+fDkhpBUAZt507VvNvJZihX?=
 =?us-ascii?Q?oidyXqzI0Nk3z8tyd8jOYc8JcEqdQCmvfbSL5OTyFkiQJIbGFIuKUU985PqE?=
 =?us-ascii?Q?xBKnAnzPpDrmYXuzsHeuBRB/qpR3ckZYF2LtmK2OoM/XAszQj5P0EByMZMR2?=
 =?us-ascii?Q?i+Z0Mke4fRiWC9a42zSZIp4TUvwz/tduuObL4+TeatalvfCu6tT3cYue0RYE?=
 =?us-ascii?Q?NyhiPmEsexE44yTbXN8d/E3E93dAuxjQK4xjRhAGHye6vha3BsYEXHUEN8sg?=
 =?us-ascii?Q?75yxuYZhmDm8blufzFi6eoM01WINQ0hqY9uJHt9ZyTmFZ0kGTrYzuGfCKW+K?=
 =?us-ascii?Q?OZlmBngmK0BUuddSj8YKLh9gBVPmFAo/kTIFiKOdAMqpIcfOpD0rsuvqOUMI?=
 =?us-ascii?Q?npIq3fissi5Ny7d+Sz/H/72JXJE0cYg2zdgx518Z6DltQUJ387whrcqi+JG9?=
 =?us-ascii?Q?86DTpfAmcJCvfhXBprv3jHOnn1hoQG2B6zUUork9lHLBnzjoo3K7XqaP8LwA?=
 =?us-ascii?Q?4j6etvGJSMGs/H2hJdO/v4g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 822d5cd9-a75e-4919-a082-08db0ff2eaed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:40.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUgX7t9nlFBRqAHuzIfpAzgN0PVR+IELHXv45PnZP1wWw8WWpYMuKRc3Hn5O7vBTxoyOp1JeMN5XhtEmNiRQM6f3sQVLoEbjnsaO/1vxjDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-switch driver can utilize the phylink_mac_config routine. Move
this to the ocelot library location and export the symbol to make this
possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 26 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c | 21 +++------------------
 include/soc/mscc/ocelot.h              |  3 +++
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b8403e29445..8292e93a3782 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -809,6 +809,32 @@ static int ocelot_port_flush(struct ocelot *ocelot, int port)
 	return err;
 }
 
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+}
+EXPORT_SYMBOL_GPL(ocelot_phylink_mac_config);
+
 void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				  unsigned int link_an_mode,
 				  phy_interface_t interface,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ca4bde861397..590a2b2816ad 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1675,25 +1675,10 @@ static void vsc7514_phylink_mac_config(struct phylink_config *config,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct ocelot_port_private *priv = netdev_priv(ndev);
-	struct ocelot_port *ocelot_port = &priv->port;
-
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->port.index;
 
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+	ocelot_phylink_mac_config(ocelot, port, link_an_mode, state);
 }
 
 static void vsc7514_phylink_mac_link_down(struct phylink_config *config,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 751d9b250615..87ade87d3540 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1111,6 +1111,9 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+void ocelot_phylink_mac_config(struct ocelot *ocelot, int port,
+			       unsigned int link_an_mode,
+			       const struct phylink_link_state *state);
 void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 				  unsigned int link_an_mode,
 				  phy_interface_t interface,
-- 
2.25.1

