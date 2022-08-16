Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029ED595DD2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiHPNzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiHPNya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:30 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10058.outbound.protection.outlook.com [40.107.1.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFA14AD59
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbinaQ0lhy424Qdy/7cjVrz1IstTurOw/WMH/ykI06vtm6qo7SS9hxDm6jHGgjEgJeIkMfcS84mLN44sZ0uGIxyWgZk0w0yp25H/jkFIkE2IXQBWqHmY6YoBDIOu7nSeMsS8BER40hCiYmLmPlkX1nwfo5qWM3NWF4jXBgglzDUFzOqayXUoJfjNXAG9/nRAB9ECb+3LyfAnALbzJIfj67pkCNqzvVay5GMjpgfFxjKnrtJAQ4ZxC2IjsJMg4jlTRu5dDHPSjxzzuhZdDR+J19/4EdlOnY7Rm5nbCULcvuNALi79IRaWRK84R94j5lWLH8NU/sT/raGEzCCVjmXfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgrrBpl9vdLCaqZojuQbk8Cis3CYki/goHKfDQqze/M=;
 b=XUOfV+Kfzdhe+6otmaaCcaIFlH7dJP3PFRt2Wl/eNmT+wRrYznjfN2sDSElquKx/VoNFIAojtdFNRYPq0bkWl56JGEw5wc/FT/hOoDqNcoG/58t7S3V99vmbdylVoORBCuiZy9NClVqGaDY53bqj8bK63GInXidscmI5fRn62tZT7yNTQNsBCnckcPzLpM6j46OXFxJ9bobhTRQvxPuoV24yyG/WJd1SFnejGiGPAa+h8HtRzUqHhtaiGRThKAUG4Xbsuwty01j1MuhqK/z/Qz+P9ZV/VfiEgKE/F6x0EMUsEbhTNeEeuNCNAQnJGk3w2HHXzt9is1AFzn93Wpkd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgrrBpl9vdLCaqZojuQbk8Cis3CYki/goHKfDQqze/M=;
 b=nOrreDFFxl4II7FrNp20Pbil4osfwYe6nNJgdQtCIEFFgfqstK4nD46yB7oTbWK8OUqjbSWpjDGQTYqdek9r+w6ChmXPfdO8ikL6JvJgWfsV7Zke1/Zm/9MKs2pHOZocA+Z4weqNkxjluDGt67bg1P7KeErLQhEUkfO591dOYas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5702.eurprd04.prod.outlook.com (2603:10a6:20b:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 13:54:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 8/8] net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats
Date:   Tue, 16 Aug 2022 16:53:52 +0300
Message-Id: <20220816135352.1431497-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c374daca-ee55-4556-b9e6-08da7f8ed12d
X-MS-TrafficTypeDiagnostic: AM6PR04MB5702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3d66UEGbZ0yli3mvTxlrROcsbSMx7/E8xhlB4Ue9vkLRnp5kfy75xuYzDFOR/H0xuw9tbjRTISiEaljRMUq/5HS7uUQFiJItQSmxUnPrOx6hpFunMHWYAGdDq/cjolSIi9yO/4feNXjaonULWGjt1zE6GLGRJHJV8Ampha4AdnKD/yJStYsYelbj/qRgE2epQ8vGIc9hBZMrZzEk7AvfzSSKSNRXW78PNuMG4TCkqQ9mUiliPRNOpzVg4B2UUENnUszCZpSSa4Mo4bgCVQQUED8yuXlbrucaNNBWOpFdT7Qqj+biWXlT+b0h+q5uugz5qEeRHcA1pr/72i30Zn1zvdicSLLfXV7KFNw5cmnd+i1eUP86f/5xgF0twC9Mnw+r19JAAKkyXwaEyXvqwbJ9zySa/BXIitIAnl4GKv6i0E+/xAI7n3XEmTgyzZmLsd8d6Dfzs9RXc6WHouwS30ITSzi/60qgBcRfaaFUfAj9mbJ7yZFz8gbPE0WTt+uZDnq8lppM6JQiCYyRMcEk+DnvgdQ+3WbltjuEBJGtrQJrs5+a2AFQuC2vOOdphlzXsOPgC6Etz/XCRnw9+v/PxsnJfUOmD09GNOKOy8osyYMXGjMSTvdHpXeoDoEVqr4hIPPx79HTnpyl0mxlJbikRUoVo49Tr64XN4xyzCKjJKaZH4URwZl7PSwj6EvvzL3iTXMAkVmtj1BfsyDSmIEglrViQyzHDsIZjTjm96KRUrqvH14fF/9BzvUwf2tpWZ1ElfOf+exjivdWY60OkHO7RmDZ/5Q5bKkt/uyis1u9aUYD4Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(54906003)(316002)(6916009)(83380400001)(52116002)(36756003)(1076003)(41300700001)(6512007)(6486002)(478600001)(7416002)(2616005)(186003)(6506007)(6666004)(5660300002)(26005)(8676002)(66946007)(2906002)(38350700002)(66476007)(86362001)(44832011)(8936002)(66556008)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8OJHulZPOFDRQ6vOMug7390fd2zz2ChWknAiclJSc0TNUhZHSXiegq7vsjRv?=
 =?us-ascii?Q?bsnplHKOYTV3aClVGYn3pby5rmKM1t8XG7PlPA7NoOBbXrp0qaMle2LkQsr8?=
 =?us-ascii?Q?VCGcERvR5AT8Q1E8RiBgoKbcUOfzsshffhQ2UsT9ahBwpoE5Ocqz09c9scYE?=
 =?us-ascii?Q?Yn+lHFr4fvwlBMaHtBc5SEEJfgtvGIkCAIllI9xJnsT+7Tp0fCUbv2RltyE3?=
 =?us-ascii?Q?g42//d/NKWVy9GciZV6RZ3TRO2BEIGfp4JrBoTFWXlhgrDKTHC7pv23hNi0D?=
 =?us-ascii?Q?C56dsrriw4hfhOsavuSBITDcT0C/JDALw13kFw5umvCkkgz7GSZ1zOa9t2AY?=
 =?us-ascii?Q?1BgRIc1jYz+sjosD1/BTEJLRpDg6hKYnuMI95WrZpmQGJO8THMaupifL86NW?=
 =?us-ascii?Q?d26M8Obzsl70Br7ZCRUH+Iqrfj+SXhiiW4X8DOY1TW9eZ8d0e7HPXfV17/tP?=
 =?us-ascii?Q?jrG5ZVIv8YhTTOqjwbL0UbDhRuamxaRluh2u7uyzMe/NcC6yQfE+4nhm8nDI?=
 =?us-ascii?Q?Gs9Lr1yJNpZuAEpxdYQjKwcaA75OijFWvRG+hA/UCFbKJE6/vq1SGKmgFj44?=
 =?us-ascii?Q?RntJB2QOdFqjqj49MUi5fXdU5UQK+BfDEQnWCWm2tSUuLcNkS4XA1hSEYZ0F?=
 =?us-ascii?Q?M17B9C9AhlHJC1m9zqAm0TB7+hS+OzGYRasM9DACf95hUACEfWaue2aHtPPm?=
 =?us-ascii?Q?wRv6wLLHwqFsWSggsEmet7Emb3pMn0td3xkyxQ7eDvzt0l72pDUt6ho87o50?=
 =?us-ascii?Q?SX05FlqTWdupMmfGCUSSh6/DNaH6v1bIwwPzNwO2sbFLNVyQOe5+TQrv/ohr?=
 =?us-ascii?Q?MUi7amVVpjqwIVT0J5WapL0QtUyqlE7+x3oyMij3AjbAhad4dqryTedEw3K9?=
 =?us-ascii?Q?BsqBnOcHdkG34DonB05OZlQomIaZiHGegEj9dd/ziQoNF0GIMAPhBAjxWP3i?=
 =?us-ascii?Q?ZWej5GMSy0VA2Wci53jbUJLN5Vv3jNieGprhkjJLrzJxdLd2Z6AjcHzvOx8N?=
 =?us-ascii?Q?NiBk0y8lFOBf9bCwTRa6rltVTgdbyFoj6xUMF9Ll8LIaN30hk8kRlCl+meYE?=
 =?us-ascii?Q?rBXOJwc84doxYGCPOR3cYTdaUjYcmiGV15Pv63hn1jjI9OtCYmp2BHS8IXWl?=
 =?us-ascii?Q?A72Etk8SYC76CuB6Blj7yrQ4+9V11L9k6p6MrfapXWqT5sz3wr/CmXLNin4e?=
 =?us-ascii?Q?5Nbf7nBiOVSGTor2nIosNOCQy0SN2G6MjKDJHgMG4zSmBadXoayvGXP7B5nJ?=
 =?us-ascii?Q?bOkKO6nwZ9PxEkHc9yGCM/latlombyh4A9uFKl7d+dP7smYHsnXdodXWS8Z0?=
 =?us-ascii?Q?3z69CFyevKnNtpU822ZenCf/MMOhY9/tv2DXQYeaZUa02H8X4GpyDxdQBVGk?=
 =?us-ascii?Q?usViM+Jt3A47tCDAhR7Ja4OMEtUeCYAi1n+gBr8BslH2RMihL2D0zhc85iWS?=
 =?us-ascii?Q?owfsFn4T1bsJFln9or8htXug9D4oVEKH8bayM1297na3+7tszhW19tSYd1zb?=
 =?us-ascii?Q?jPMjD+l3kjzcPvVApUVn+Z5iR+x9NVq/339MOUM4Owhr6gdbeO+ht7Tsl/8P?=
 =?us-ascii?Q?H0wuKgrCW1vSKk872K5sww+c2chjKa5S0YoWtR40Af1hthyJSsIa5v7xh6Zq?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c374daca-ee55-4556-b9e6-08da7f8ed12d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:19.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMy6LaPwCcbdqGzMTHz1hrkeIN92nxv5X3ixdQ7Z+IhqvukGfsG1ks3DLpttjXpJGePs/J6J5V7m3SOWuhclAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than reading the stats64 counters directly from the 32-bit
hardware, it's better to rely on the output produced by the periodic
ocelot_port_update_stats().

It would be even better to call ocelot_port_update_stats() right from
ocelot_get_stats64() to make sure we report the current values rather
than the ones from 2 seconds ago. But we need to export
ocelot_port_update_stats() from the switch lib towards the switchdev
driver for that, and future work will largely undo that.

There are more ocelot-based drivers waiting to be introduced, an example
of which is the SPI-controlled VSC7512. In that driver's case, it will
be impossible to call ocelot_port_update_stats() from ndo_get_stats64
context, since the latter is atomic, and reading the stats over SPI is
sleepable. So the compromise taken here, which will also hold going
forward, is to report 64-bit counters to stats64, which are not 100% up
to date.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 53 +++++++++++++-------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 6b9d37138844..330d30841cdc 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -725,41 +725,40 @@ static void ocelot_get_stats64(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
+	u64 *s;
 
 	spin_lock(&ocelot->stats_lock);
 
-	/* Configure the port to read the stats from */
-	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
-		     SYS_STAT_CFG);
+	s = &ocelot->stats[port * OCELOT_NUM_STATS];
 
 	/* Get Rx stats */
-	stats->rx_bytes = ocelot_read(ocelot, SYS_COUNT_RX_OCTETS);
-	stats->rx_packets = ocelot_read(ocelot, SYS_COUNT_RX_SHORTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_FRAGMENTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_JABBERS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_LONGS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_256_511) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_512_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
-	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
+	stats->rx_bytes = s[OCELOT_STAT_RX_OCTETS];
+	stats->rx_packets = s[OCELOT_STAT_RX_SHORTS] +
+			    s[OCELOT_STAT_RX_FRAGMENTS] +
+			    s[OCELOT_STAT_RX_JABBERS] +
+			    s[OCELOT_STAT_RX_LONGS] +
+			    s[OCELOT_STAT_RX_64] +
+			    s[OCELOT_STAT_RX_65_127] +
+			    s[OCELOT_STAT_RX_128_255] +
+			    s[OCELOT_STAT_RX_256_511] +
+			    s[OCELOT_STAT_RX_512_1023] +
+			    s[OCELOT_STAT_RX_1024_1526] +
+			    s[OCELOT_STAT_RX_1527_MAX];
+	stats->multicast = s[OCELOT_STAT_RX_MULTICAST];
 	stats->rx_dropped = dev->stats.rx_dropped;
 
 	/* Get Tx stats */
-	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
-	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_256_511) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
-	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
-	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+	stats->tx_bytes = s[OCELOT_STAT_TX_OCTETS];
+	stats->tx_packets = s[OCELOT_STAT_TX_64] +
+			    s[OCELOT_STAT_TX_65_127] +
+			    s[OCELOT_STAT_TX_128_255] +
+			    s[OCELOT_STAT_TX_256_511] +
+			    s[OCELOT_STAT_TX_512_1023] +
+			    s[OCELOT_STAT_TX_1024_1526] +
+			    s[OCELOT_STAT_TX_1527_MAX];
+	stats->tx_dropped = s[OCELOT_STAT_TX_DROPS] +
+			    s[OCELOT_STAT_TX_AGED];
+	stats->collisions = s[OCELOT_STAT_TX_COLLISION];
 
 	spin_unlock(&ocelot->stats_lock);
 }
-- 
2.34.1

