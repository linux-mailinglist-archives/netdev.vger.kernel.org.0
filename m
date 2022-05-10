Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A23522190
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347602AbiEJQsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347681AbiEJQrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:47:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FD4EAD27
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzSgRmvi3nhScZI051gQGO3tn2W65qC2EWI4qOQ0oBZZJ7RAYLQDQ9MjzOog5MxBql+IKub9hHFpc8HEdFpn31/q645l8lwN7aGqQJi73SjdmAWt/mNRQNlvAnlSYOrCr36neYGYUpLMew3ZmVD0TrMOUBUlW5/vGwIixQ8rRwe5RR8tnlOwcAdYxNC+47YNzWaMPJfesmS6GHsW37NcX2gaUwcdwSYVTB2ytnHimX0lL9EnM0D3xD//bBty5GTTlqnSpd88vuZQdmus4Xzr7kIV36USS2VCAIBcr3j7H6VTS33i9VduNAJC+x6quxH36tGQpJhOzp9DPB5QYU1bLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+JvezSfALUw8RxzdxP2Q62OxHe6QVOCmyLyHO2PGOk=;
 b=L2oc6hbhPaBmz63Mwq1DiHJRwO5XYEr4JpJJfeGhTmlJ/8Mf8GuktuYyGphewYXyh5uSsdYNi67c9gLQmLyGNSfBeTBI6DFojBFnQvsHLzPm/ybFqq3XMUmxIUwJBz+4yK8bFPLVlFUetLom0SCNet/5+hMN+LvIHBKkWss4T1RIMs0vNqiybCGIVxGmWdE0Q8wN5TpJtHSV0b83i2NV8C/m/7xmf3GTWaroeVphsBk6UbyjZB7bN3B68foE4c4ic6Q0E/ovg98i2oiMdKqWKTSOdu4oZ7Sr5bQHhQkDc+vSuB50sAmDqIQXDOOBHyTwHhQ07OFr8CkqiJ109O0Xzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+JvezSfALUw8RxzdxP2Q62OxHe6QVOCmyLyHO2PGOk=;
 b=Av62uIYTU0+3bTPNHadrGBzsp2H5NJ32iOKa6fcjCTIm4CXIvYa/GQrnmAlNZkhbH+pCyqZBpa96k7hJzzxO0g2rds+/7u6/qh/1VuK7wFAmxAdOc9/c48GzgORgye0Lzegh3K+7kJvtTH1ONrP52WnaDSV5Ie5qRKeY/SmNzm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0401MB2579.eurprd04.prod.outlook.com (2603:10a6:203:37::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:43:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:43:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next] net: dsa: ocelot: accept 1000base-X for VSC9959 and VSC9953
Date:   Tue, 10 May 2022 19:43:20 +0300
Message-Id: <20220510164320.10313-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P193CA0022.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0ffe104-db76-47d7-ebc8-08da32a436fe
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2579:EE_
X-Microsoft-Antispam-PRVS: <AM5PR0401MB257937FB22C2E15CD1494479E0C99@AM5PR0401MB2579.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jb1rA7U15ope/yscFnl5Nl/lyOeRiF+oruYlCR36A5xpmkOO3RK9fzykq8Ef3P33A+34QW0OESK6hVAeIBFxnWxBj05FWaOa+UCm+uYyJJ+qn5i3HfHmQ4piNz8I6D7s05ZbmibzKCKWs6FoSTP4z3zITe1yA6kJKRu45XXBrDw8z1vF3JEP5vlFji8rsA598BWpk0J/eYU7ydyrRwWX33E2Dy0KMnDr4mMeUZ3EVeLKOEmMsF9v8S0QKaeRlY8/DR0Vf5qCo1kR+sCaDs6qynCzPVmDqkqofwNxL0xpv/pl1Y9jDZRMrn0rbJY+wvl5UU+LHxktwcqIhN6l9lPA3gMhIDYOeJrZkFLwydefgfQ8XmEPGn3eq6m3C4/XaIQqPlDdSkRIlu1PYEJ6lfQviMaXGgMDqK0uRjWoO62j91zxmPF1mO/psqPEN4A8qCIgWKHUdEtE/Rn51uZJ7ftNR/xdsDs+WnpOm3lGqYsQijr5IuR1ElN9wmImLoa1vk3usQWr/GLKCN9W0lN37rHJ/eKSGE9Ebg4G7NNp8Wha5Kie22bWYZ8evqIV+S5CqdkcRkd4219BjCZGHrl0kDdRcccurV+hCjP6lwlKWw9t4dXrsqHH8iiPpA1/G2oyu9pp6GxsHBosEdj2v/6n+D/xDsP8lPQJWaPFxaCPvHj5YUdNi4+S6x2RJESmHBx1sRPtnip8F8x0/LEOpkMiPJMMmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(508600001)(36756003)(6486002)(2616005)(38100700002)(4326008)(83380400001)(38350700002)(54906003)(6916009)(1076003)(316002)(2906002)(186003)(66946007)(8676002)(66556008)(5660300002)(66476007)(86362001)(7416002)(8936002)(6506007)(6512007)(52116002)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LpkJbhbqFlMBYkm8JOKJ6KxDmsgnJ1vmMPnSkivvf4YKMxvupUsiBgzE8jTJ?=
 =?us-ascii?Q?YFThYN+BVUZayl0Y5A3MD+QAULOufew6msl/HjAsnRMNHC8iUlXAbzVaTvDF?=
 =?us-ascii?Q?IYJOpM+fLi/qXx/6tcXjNPtgXnmTOKb9HiPg79myKBJzwH5jt1lWCv8WXC9e?=
 =?us-ascii?Q?NWiMOL5HApSXRrY6qt0ak++KCLNdAwAB67AXI7PtxdyaXwbPyhgmRFCjDxhx?=
 =?us-ascii?Q?Io43URg4pQ8X3DVm2rmuURZ9P8yMwW7ANZjEwKhJ4BU18RoGsEEMS9/NE46j?=
 =?us-ascii?Q?Gur6KSHPj1hsw64R9UBpqO28wbADntNY9F3h+s7XUZTcBg2NEgpizxLZRExv?=
 =?us-ascii?Q?2YNpXFzzH91Z2TGPgxMiFGrH8t7Q5cwWp599J1T9KiYJGUIHGWMjZQhJ2oO4?=
 =?us-ascii?Q?smH0S+Q9N0F61EbUPpIcBdzwrrtshXnCN5JIWqMvaJcCi9yzE1RPIPVMubdP?=
 =?us-ascii?Q?qYwVPhfu7+0bKP31pWu584kl2OGpvee/ZTh0g6G9uq2uaVqZWlCdi2hLUdPI?=
 =?us-ascii?Q?B8r1sJk+dwocKwPzg0AhdMEHNiFwbUUn1oKmYyrHxnECKWnH02o26/Uu2qS+?=
 =?us-ascii?Q?i55AI4lGL+2a7p9yAIIFbDIbU90RvjxJlmAiNL5tJtfO9x5vFifNb7jODty1?=
 =?us-ascii?Q?tynmvAfBavXbh0apnVr0NlhpbtoovIjVSiQdIoF1YOSphiJX1f2BefJR1qn5?=
 =?us-ascii?Q?DLjLecc63WFSQwLtg34LGZE+nELf4vpEtuqaJl0RcEGTy3JQvufuOtzUGwDq?=
 =?us-ascii?Q?zsBqq197BTCRy8Sx5mfyN49AohEG57nL/oU6Gzlsh6h2Bzh448ZmCDk1Pa/D?=
 =?us-ascii?Q?RIHEBXPOU3KLyxkR7ZvQE5voF5CGSvVVD6gGpieRI8oqKYX1OJH5w7265uSf?=
 =?us-ascii?Q?L+1YbPOJcI4fKzxPpAkB/5PPY/HwZoqlH1fGw6f2qQ96TTzHM4ANEQgdGzku?=
 =?us-ascii?Q?4UuXJ31iUsQ8v1oUEgGt64BQWFhWVWzszaAuyhSl8pa+n07SNM29rpnr+FuL?=
 =?us-ascii?Q?jyyxzciiiBauYf+uw1dqZ8ChXq/hKe7F5+JvWHlIRt7bu8eoNvySyvwwiPHm?=
 =?us-ascii?Q?g4vFhVY8b8Vg9r+/g6MwbrkRqj5IW6c2Mc5FGCwQl2z6pWcWlq13Sr/LO59n?=
 =?us-ascii?Q?7hn73TDSGLt57tpwzpUrfXKiSHXWLJ7pFsiT9Y02ywB/09VK0gimoJblwVnM?=
 =?us-ascii?Q?1+N0NzzTPbIipWsyeqtMCJdc2EIGQ0Le7SplRfq/esjfRVT1vWytWguXsUEQ?=
 =?us-ascii?Q?LdzkBicwNNpFsSwyqHKbu70/7qXpRdb4daivlc1ZvvkIwh0wE4Ll2njh5rex?=
 =?us-ascii?Q?Vpd6u7ndOrHRXbRgWGRUO6MEZNKpXvYEyOY14Og4ZoWWqyx6Bu0QbdDoqRFC?=
 =?us-ascii?Q?QIOT2ONKCR4ushqMwRInWqi4N2iUGaH9QRJqYhILJjyPlvjw6iAhwg0ANsh1?=
 =?us-ascii?Q?NLurpZeOyRsX3tP1nEki5kIQfQIQobBbsKE3O0BLbuVAVIeVp+oTHkjgF5x0?=
 =?us-ascii?Q?ztGejx+JXeZZpYP7ytaDupyYlf5aN4cUlOc9lIp6ZDEoFFSIaAoMXS9RuPDn?=
 =?us-ascii?Q?kzqL4Nw1dB+tp204qJP/mbAigRjWl0k1WgmOV/jFEESPj0lqtQrySXX7UnN8?=
 =?us-ascii?Q?ZWYeNyfR/cKX0SLm6xWRwe2IVwPrm9Yh4WbBKUud5be6dqLv8un+OJ/6l45g?=
 =?us-ascii?Q?iZCn7FbiSXVEODvZHbesI99ejHfdFq9ZUcGMyWfrwfKHMfgR+M3bD8b75Vcd?=
 =?us-ascii?Q?mJhR1bdg5xwXJAmakboc59cwDUYueBs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ffe104-db76-47d7-ebc8-08da32a436fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:43:30.7391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ps4A+h3RnZ3QdULpGKzTTfCNc5xE6d13TvCt7JE5uaH6BhCeKjY1TrasJm5oj8PrKDWVBZxRnPhJr428KHKYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switches using the Lynx PCS driver support 1000base-X optical SFP
modules. Accept this interface type on a port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 1 +
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 4 +++-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 21968934996a..5ec3a4f149e9 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1024,6 +1024,7 @@ static const u32 felix_phy_match_table[PHY_INTERFACE_MODE_MAX] = {
 	[PHY_INTERFACE_MODE_SGMII] = OCELOT_PORT_MODE_SGMII,
 	[PHY_INTERFACE_MODE_QSGMII] = OCELOT_PORT_MODE_QSGMII,
 	[PHY_INTERFACE_MODE_USXGMII] = OCELOT_PORT_MODE_USXGMII,
+	[PHY_INTERFACE_MODE_1000BASEX] = OCELOT_PORT_MODE_1000BASEX,
 	[PHY_INTERFACE_MODE_2500BASEX] = OCELOT_PORT_MODE_2500BASEX,
 };
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 33281370f415..d44cb97903c4 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -12,6 +12,7 @@
 #define OCELOT_PORT_MODE_QSGMII		BIT(2)
 #define OCELOT_PORT_MODE_2500BASEX	BIT(3)
 #define OCELOT_PORT_MODE_USXGMII	BIT(4)
+#define OCELOT_PORT_MODE_1000BASEX	BIT(5)
 
 /* Platform-specific information */
 struct felix_info {
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 95e165a12382..19da5453c547 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -28,6 +28,7 @@
 
 #define VSC9959_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
 					 OCELOT_PORT_MODE_QSGMII | \
+					 OCELOT_PORT_MODE_1000BASEX | \
 					 OCELOT_PORT_MODE_2500BASEX | \
 					 OCELOT_PORT_MODE_USXGMII)
 
@@ -973,6 +974,7 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 1000baseT_Half);
 	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
 
 	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
 	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e1400fadf064..848ae3a08f2f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -21,7 +21,8 @@
 #define VSC9953_VCAP_POLICER_BASE2		120
 #define VSC9953_VCAP_POLICER_MAX2		161
 
-#define VSC9953_PORT_MODE_SERDES		(OCELOT_PORT_MODE_SGMII | \
+#define VSC9953_PORT_MODE_SERDES		(OCELOT_PORT_MODE_1000BASEX | \
+						 OCELOT_PORT_MODE_SGMII | \
 						 OCELOT_PORT_MODE_QSGMII)
 
 static const u32 vsc9953_port_modes[VSC9953_NUM_PORTS] = {
@@ -947,6 +948,7 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
 
 	if (state->interface == PHY_INTERFACE_MODE_INTERNAL) {
 		phylink_set(mask, 2500baseT_Full);
-- 
2.25.1

