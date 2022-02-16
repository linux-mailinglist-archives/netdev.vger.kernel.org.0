Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21794B8B7F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiBPOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiBPOdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:07 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F39516C4E5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVP3SknN0lAmWLYDgk8cXs5ejng69t/IrVJj1UKHhkPURN7ddmxZ+V3wpIvxGku9hhkDv1Erj7zn0DYZ1Z3qWx8w2l/IfdMjdEMUJxZ+c5Q+ZiEKBaQbbGY5lxMYd9hWC7l4RJV44aPBiO/vG9I35aT0fGFUpI/gOVwbcvzwIpZswzRTy8YEg3+H6N8kXFIX10DIHDYwOMxhZTZEDHgWR/3D2vqr0Nxt7iXS/JDB2PRLd7ClxJnn2taodkmsGQZvBbmNu+g1rJO4d+UEa3pq3PmcvgoXmIO2HfXlynalVv7nZ2BtDTwcGtMS1BoNKItMivzUBkwH9am4OhT/FznOsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Unw6VPDBqTR55cH74+c2pPy23yBB6u+msFdQMV/SxXg=;
 b=kHR8B/E6hnq1uNJcPlFUhGYulFp9ZI0QriinziMMRVXFz40k+Ww9kOO8/TSp2riL28f3l1BZPU6b2NZyWCDUbEY/U31CueCAzQer024shJkzGjjAGepRfeCgHn8A8IAx4o0tfzagA7OvQftiCdycWNMZfNON8Q1mnk6joQ+1iPDrD0ccU9TPiQV6476TitONFRkylG8Dc0fZApguMaQKwLR4DtjVIa/g+shv21yTNJ/5uTvI+0Urd51ty8CEHaDAjwlnzs1QMyE5hnafX38iWpAKGnenIi7zoXTou6OzlHKgHjsUsPZeC5A4Bas2YkP9cHqPhpslVFTMFe4f0JYp8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Unw6VPDBqTR55cH74+c2pPy23yBB6u+msFdQMV/SxXg=;
 b=ZtCfg7Tz/vbe4H65dojTipVTixpTggB8GL3AAXinX0qKs1wGURAKCScP+oZRsujD6WgK2cz0gHesZCRZQCZrCXtk095rKSXOp5aBqZuILFxLOI7VPVj6Ae0IkABz6Gj78NTg5HJwTPqSIplSDoZctRhLjiePJOiJC/eh3cP433k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 08/11] net: mscc: ocelot: annotate which traps need PTP timestamping
Date:   Wed, 16 Feb 2022 16:30:11 +0200
Message-Id: <20220216143014.2603461-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab3cb692-69cd-49c2-0054-08d9f15932c9
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815A79F33EB95C69D9A99ECE0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RTLES6SCSwF3kUnINDo6OwLuDrHBdxsbPGovBIaLg2oiXTUy4nDxbh2RZ7G6bT9/ttxZtME7VkvwW5sq36U7CMQjzSz58tZ4wcgHWAvzJsdPy1iEEB8A0Oa+ZetEICRSm5RDg4s1DMJ8dDOMOeL2cdgYsDKAnnBrOjr1AHicLv2uBRUUEVOUI+gb8MQemutu3U1TraiwilVtQZh46cvE6oFEBWJGi9+olPeWSzoNZ+/DZN5VSvvq0FYHfZBroWiC2ax5yfl1Okj0KFI4A07E7dOL0mS4OYOxFNNddkQKsHGSF/EqrOd7dyS4YPcTN5oEDr5+vtIQs77U2IDmLOxSTBpg1sBiK4uxMQkC2zpusiR9Fzw8j1wBE1Tx8wBGJS62jEq3rgtJOdaDmM97ZxeJfGK23Nu+0Qq+o4DgkyBJ9rxuj8YeWgTxRLeYbMY1cQGPIhaOoJaxsNwUMAB2na4k/Q80kywG5jZ4RNt192ltohg9R3fTvCsUISV6JTUjm4Tr0jjQwDZnue88aS7cMlpd9zf9UQ0PThabVWu8NWfvzqbmhtPDhnBBCquFNjY8REkmD3ebZErVhlGsFRXVAHU8kwmkLzFjhnnzUbZPqIg/gV2bmIoCQAikwdu4tyCY+LiiA5AxFq3pSX6OG8dV7LQhSBR1zqrhAyJKkVWvWcW3ScOgPpq9+OyhLPXe/9+Y2Et0QZ1890VDc+hgHI7X02fgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5Oz+BUUGAwqGgdOOCgzbv/xtkUMAqNogs7a9IkHy6ZDhrFrvvgtYq39OThz?=
 =?us-ascii?Q?RlBQZGqfqdNbToWD9V8KrdSqUkmrvXJ1M1tTX99PLTUM4gcjUZyuahHN1+IQ?=
 =?us-ascii?Q?VEUQBliBc+mA6ge/OAmGVS01Z2naSiVg5VuGAPRR1jcbH/B3FqHth6AVLWWy?=
 =?us-ascii?Q?3btvWSFIP98JxRVPAsbxS6Ou5AyHgcp8tERdi6GDc22Yn58aVemWaIozXaMl?=
 =?us-ascii?Q?anLnljb1aEs61fqW+VWKuObtFSsdp5/GOW5YoNIrRrQsg1zCS9rPAwLzTe+w?=
 =?us-ascii?Q?WBnDowU9+4Ux/rl3IGyEQIAdykKPryPrvNpgbRjruh9tJCZY4qoIx+iZSy/C?=
 =?us-ascii?Q?ZA1aveEZWk4ZBiLC6UMVv3s3i+lrPOYAzOUz3/qe4k7Tu5CIu1Voxs6wpIZW?=
 =?us-ascii?Q?+2gr6BDPhLRfJDwsgumya48YZb9E5UtD6z76S3w80wvfUtjTpUBKmD4h42R8?=
 =?us-ascii?Q?cqjlL5m+9vw8Ra975hZYP/wUjKMhS2afs7zUWznHsaHVjBlLTtaTCz30GHQ1?=
 =?us-ascii?Q?6azdJEYrnim/bNtOWqJDNM5ywBoFg4DKtCB5Q0sxOg+KlVIAflS/tGgrTvAm?=
 =?us-ascii?Q?HgGwYQw87BWJmnyXWjDv2yoKlMLZ3Av+wV0dfpIYKgDKMC7xGUpseowRXoEl?=
 =?us-ascii?Q?63gbSLEHXmGjTc0NykHLOiB3Vz7KPmWSzLHWNOftVAYJciC+Z9TR+aBpMSwH?=
 =?us-ascii?Q?AkXO119bQNKvmBvNIaJhz8wQo3hUvzeSzIEVdNLu87Xz+eHzwtEnJlzixJPh?=
 =?us-ascii?Q?y6JP4KAOSJDOB9NWeL64gTRnE5R86IVujz76J3km8mnbzK/eptdzU4MKueVy?=
 =?us-ascii?Q?1JfCS6qmahlad5jWez6Xm7ogiW9B9XcmTSZV8pdiHKFELqjtNwdkiS4YMskH?=
 =?us-ascii?Q?Yzy7RDCJXaHNovzVUIKBDvGo5BcwK00b0581cWvKhJOY2QotOm1za/IcSW/o?=
 =?us-ascii?Q?qbuhkt2TvNST64r9E+cM6Y9Pc132pxRUBJO84NUha32rTYHiOLhcGNUu/mx2?=
 =?us-ascii?Q?AO45dL3BCleuVTiVIvoftK84CSbd8BBw6UKKtlMB71p59AqTF2F0s1A7DR9C?=
 =?us-ascii?Q?jWi0CeIQYZ+5uQkpsMRGCVndZc8GShzTiUO6xgEeEkVAz45ezDUJU1pEaUbh?=
 =?us-ascii?Q?UEnjqHkRTRF6y0UxM0NQxPfwsFcA6CrdDurKeH/awMjJRHcJZS1JcFEehHJh?=
 =?us-ascii?Q?HezZLOiFc1uk+BerdpVM11kK68GNxMHHO22LTyuiveSqft4C8KcyXBtX5BPC?=
 =?us-ascii?Q?QY1DqJRbDZTt2SH8KbT0v8/5cBQhnzLYbsy0FTYqfdYUr04azqXL26vvLzyG?=
 =?us-ascii?Q?rl0nYX3balFQI1xj3AN0AQ05v1Clk2PGDY7uOTa2I4xX8sEpzwW4n9aKm+tA?=
 =?us-ascii?Q?tTMEYEt393kwzKMq2zSoMYR2jVIgpRISmHbJgYerRptbETodn8Ji0o0LGhE0?=
 =?us-ascii?Q?VjLMCuqPXhgilhsf0wkEZCJn9gIOkhBrfCkX93lW4hlX7xxY0uIfoAJmikd8?=
 =?us-ascii?Q?CdJSAcTkTY9lPT5R6O3dxnbzZOZ/7qu6l76wkkc9ErskBzEMkJ+bJWFVQ6bf?=
 =?us-ascii?Q?qYNUlUchyEseuifXfWuxW9vUUur2a3PUZ3VkaCVZ33kn0kxloTj4VDsiclmM?=
 =?us-ascii?Q?4+wxqbiv45N9byOFjkFcJfA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3cb692-69cd-49c2-0054-08d9f15932c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:45.7302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKeJV6/aVvo1uTGwv1zbdQ8dUCuGGPm0YNP1lvNdxRuyr0VJjsm9TVay9laMYq9VObAbJufb6jtOlLQshc5yjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switch library does not need this information, but the felix
DSA driver does.

As a reminder, the VSC9959 switch in LS1028A doesn't have an IRQ line
for packet extraction, so to be notified that a PTP packet needs to be
dequeued, it receives that packet also over Ethernet, by setting up a
packet trap. The Felix driver needs to install special kinds of traps
for packets in need of RX timestamps, such that the packets are
replicated both over Ethernet and over the CPU port module.

But the Ocelot switch library sets up more than one trap for PTP event
messages; it also traps PTP general messages, MRP control messages etc.
Those packets don't need PTP timestamps, so there's no reason for the
Felix driver to send them to the CPU port module.

By knowing which traps need PTP timestamps, the Felix driver can
adjust the traps installed using ocelot_trap_add() such that only those
will actually get delivered to the CPU port module.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 14 ++++++++------
 drivers/net/ethernet/mscc/ocelot.h     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_mrp.c |  2 +-
 include/soc/mscc/ocelot_vcap.h         |  1 +
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 049fa1e6d5ff..2fb713e9baa4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1472,7 +1472,8 @@ ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 	trap->key.ipv6.dport.mask = 0xffff;
 }
 
-int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
+int ocelot_trap_add(struct ocelot *ocelot, int port,
+		    unsigned long cookie, bool take_ts,
 		    void (*populate)(struct ocelot_vcap_filter *f))
 {
 	struct ocelot_vcap_block *block_vcap_is2;
@@ -1499,6 +1500,7 @@ int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
 		trap->action.cpu_copy_ena = true;
 		trap->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 		trap->action.port_mask = 0;
+		trap->take_ts = take_ts;
 		list_add_tail(&trap->trap_list, &ocelot->traps);
 		new = true;
 	}
@@ -1547,7 +1549,7 @@ static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
 {
 	unsigned long l2_cookie = OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot);
 
-	return ocelot_trap_add(ocelot, port, l2_cookie,
+	return ocelot_trap_add(ocelot, port, l2_cookie, true,
 			       ocelot_populate_l2_ptp_trap_key);
 }
 
@@ -1564,12 +1566,12 @@ static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
 	unsigned long ipv4_ev_cookie = OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot);
 	int err;
 
-	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie,
+	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie, true,
 			      ocelot_populate_ipv4_ptp_event_trap_key);
 	if (err)
 		return err;
 
-	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie,
+	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie, false,
 			      ocelot_populate_ipv4_ptp_general_trap_key);
 	if (err)
 		ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
@@ -1594,12 +1596,12 @@ static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
 	unsigned long ipv6_ev_cookie = OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot);
 	int err;
 
-	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie,
+	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie, true,
 			      ocelot_populate_ipv6_ptp_event_trap_key);
 	if (err)
 		return err;
 
-	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie,
+	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie, false,
 			      ocelot_populate_ipv6_ptp_general_trap_key);
 	if (err)
 		ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 674043cd9088..5277c4b53af4 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -103,7 +103,8 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 			     enum devlink_port_flavour flavour);
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
 
-int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
+int ocelot_trap_add(struct ocelot *ocelot, int port,
+		    unsigned long cookie, bool take_ts,
 		    void (*populate)(struct ocelot_vcap_filter *f));
 int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 68fa833f4aaa..142e897ea2af 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -92,7 +92,7 @@ static int ocelot_mrp_trap_add(struct ocelot *ocelot, int port)
 {
 	unsigned long cookie = OCELOT_VCAP_IS2_MRP_TRAP(ocelot);
 
-	return ocelot_trap_add(ocelot, port, cookie,
+	return ocelot_trap_add(ocelot, port, cookie, false,
 			       ocelot_populate_mrp_trap_key);
 }
 
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 69b3d880302d..50af64e2ca3c 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -695,6 +695,7 @@ struct ocelot_vcap_filter {
 	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
 	/* For VCAP IS1 and IS2 */
+	bool take_ts;
 	unsigned long ingress_port_mask;
 	/* For VCAP ES0 */
 	struct ocelot_vcap_port ingress_port;
-- 
2.25.1

