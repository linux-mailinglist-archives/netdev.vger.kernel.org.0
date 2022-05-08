Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B74651EE93
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiEHPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiEHPb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:26 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FEFBBE
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIkBTu2z0kMvOmhxbAKG9G+enw8JU8KBTRw8v9V0M0QFtgqaTtDsT6cKH+vBkGCrGuBORt5vme7P0vj4IXo+ZrlWJvGqDGbrrcsfLzStIdudgbrFD9PBXAQrni2bhv3Yg9asE+uhUTWqD4Xni+d3b5AVPXXdRkHXqcgT9vQr7BIqpA6MVlM/6PGvou/spLZ7OGUaC0CaDex9d2aP+5u578GLULguLCd3mi/b/q/s9DKyvhsZy5da6vc4jw/tvCsZDARsITxMRmUtOXtvCar41p/dzVPFxZFByG2RP7idNHFcR4RaAXO7/YW4/TtWEMAcbt/pots4GpNvgf4VnPz9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egt6MWu/WXDifbwtZbLGtOb9TFKYdMtcabqEf9RnNlU=;
 b=DQsYyd3U6Fvq/Qi9DPOPqNyD+hKg2CipNXYLQAtobLto3djT7sQgiDtsUaSrwiKKAOFWDKw74QqWO6HA37Q2az5hNCUN+jLHoSngbIPvEVu2PO5q8ZDE2cr0rAQPkBEwTIiLa/beba+3NKxUaAZCCFzpmL0gedilXHfdNv164/p6aHQdOlsaiSJjThPVDgt217HU/KYdt3CRfwopszOW3Ct8XWUGvAuaMlcd+0kvj5ueuACER2AvleSlqcXdAU1BoyX9JvtnsUvxpfXi2BqBsoZWiBY5StZTRmYAFVeEqfpU5crWmKHjEALZjCiZ7LsJBO5/GhifExw8gfWNAVC9mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egt6MWu/WXDifbwtZbLGtOb9TFKYdMtcabqEf9RnNlU=;
 b=UqIs//H9A23gWbgADeXJMc9BBeoUf/QcuXw+CHHMIuzn2eFAduabrhiNcSE/aSS0kT/53pNa9HEVmKp+flxH91UTJ2Xm7D2EGg81wKiMBDArGiN4VInQ/vpFsRf9tCGcg2ZHju93xuPfnBmqpfL705xJuDX4qdLAqKaEuRudyUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:32 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:32 +0000
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 3/8] net: dsa: felix: bring the NPI port indirection for host flooding to surface
Date:   Sun,  8 May 2022 18:27:08 +0300
Message-Id: <20220508152713.2704662-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 101267fe-06ab-47e7-ab01-08da31074546
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB280696DB23903E0AB3E2774BE0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukDzwyP6j9z1v7GDagoGIEIceln417SK1eD0TwOTIUsmFFl9Wz7+jXYzaUiyh4/U+sRWryyvJm6aiCkmLwCIb4RzaEVmpqNSHOsn/83c871fZKrnPX2zXo4nRWtVtWc+ibHVBrboxcL2g8yqzXmxUM75sQ6EdqGx8kz5jy6Q9VD6lMRdQyXHhrWsclkK7F2sJG7ZHLcyz2+3BCHHxOPb0eAPAqhjeViSuHWLKtUygokIylyGPNVPAxE43YobafmPZf7qBT9srnD7PRr7KRJ7dXRAr0JPstOR3w+CV8scURgvLMdmEj9WHn4hSushOEY4+FsCSmCpxWqTI7c8f9Oz9ttj9kKYS1vF12YnGQkSuuu98iVp66JGaGsJUx74REgtqa7gXhn8+pcRZaFQD8+KVKuM3D/qzpVPxN3neAFiD/P5gv//p+Fe6w55y+tFPTMGYjoVujLwzF67RlFQEcoLc0NM3RKlD/mtMu/iSH9kc1sD0mEZJ+H0r0FpGXIQqYM7IGvpOArA8IXTM5oJG1aaX00rDdDDICHVh7HgwWAxVWctGogb8vI/2Yr+ufEdtngD3UJm1y9Llwhj29zAxKzCgBe6jaKXc5V9lg/a0TQyNwMD8aQ56IZB1uMMA0ajnTtrM6PlitegAmMhuu5B+BNygVXq1Nmh+bbwp2LjlAelN5nEhOw5V4TNszszfQ0bnk4WaWv8bdjjQLuJlrddT8xQMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKVMffGNB/yYeqq6y10hnKMxc/7m6dVBJebuwgkOdKWQeWeqA94YX0BCXhMn?=
 =?us-ascii?Q?BOL0KXFwyRl7B1p3jquDW0X9xVQ7VPoTzFwoRa4OOnmG/SQFz4sXOOmKoazj?=
 =?us-ascii?Q?yo0Nbl8fX0kcBPvoAbZ7IzDXif686ZH+enrJIHG716NUjqK+JO1SNYKVaqkV?=
 =?us-ascii?Q?kgSXyeTLcCgIiK++P7RpTH+ryEbBLGY+JeDc84kLeFPASknbfn8ORceQuNec?=
 =?us-ascii?Q?spZgW9tTW4mqHAlP4YDrJG17agx5QaeD16PqRw9MKOIiox1xET8vRVtXHW/Q?=
 =?us-ascii?Q?RYwZBfh9nCNHdGiWBODugnBPkapiNpdMBxkr+f3/3X7P6oFyW37lWx1CGGnk?=
 =?us-ascii?Q?Ymq+87wPQMefJigG43PvMqbi5Yqi0WU4m8bnMkJj0yAeNkzV6MOxFkhOjkDl?=
 =?us-ascii?Q?BrlpNMT6uLl9vcqneAUdNalBFAnkWMel/rhE01W+gCvcQv0VicM1I3xBim12?=
 =?us-ascii?Q?xj6pxrsiZValfi6O1Ipl+BGJSD9gbsrs3XVoAElWxxVZ4+cRwYNlvZU4UsW0?=
 =?us-ascii?Q?k/oMg8b+ldwjC+1FEatMwA4wwCWapylJWqlppuoMWdiTi7tkheVmgfltrWIl?=
 =?us-ascii?Q?iWDZzruBvbeezjQu5BGWVbe8PIqMQPvTq9qbTR1glC22jnJemrHFJr44p2Re?=
 =?us-ascii?Q?oBCZ9qRUe2qi+M+WzUzAgxO3b8+lIhFN7tPEGDIcLfO1y4X/3ZmpQW9bpwi+?=
 =?us-ascii?Q?V4ZBeBeE3r/KGx/4SsI4K2xQRa58WKGi3ZlttPFYQ2jQUUcCdPIeKq986v9v?=
 =?us-ascii?Q?UisUKKYlxh5b6nbzJXfmjlZPvc6/FVyzRBRkqvA2VhP/pJ3UYm7SwZNtnWxq?=
 =?us-ascii?Q?tW1LzFLkhkTctk61+IWv4Hy7tCXatYYvhSkHHIpp2yNToq06ApVWlpMijC1o?=
 =?us-ascii?Q?lR0DOPANC6b4HNMCrYF2vBqHAfmr8oYCFSCfN4esC2ox9pwDfBEh3vgtOk/n?=
 =?us-ascii?Q?Ien/J+oIDJVxKQHKm++vdzISB9yygArWBqnni0zf58wZNbkLWB3Pz2MGmURN?=
 =?us-ascii?Q?qcCr+/ynnOQWzS0VRTmbAuxKk0qfdRbs1eq+55IUcvy9bZR84RBZus8lLOyb?=
 =?us-ascii?Q?enTKQFUbG483T7r23RVa2Epl/yy/rWV1GBNcGmQI3hS71R3Dk57Tay79ns6d?=
 =?us-ascii?Q?HqoCvuALaa2Yn6bRlXrtkj887rQt6CFBdoGZIY7R4IsQYVQIWOS8tO1WGk1U?=
 =?us-ascii?Q?N+n3xcfPSYV/YPK7XnZw0KNEj1Ca8l4P4xIxU8Q+UZd/n41TXK6Z7RlJTia9?=
 =?us-ascii?Q?d90ryjXGvGxZgb4wqkpTh2rzyBbS25PlEFDM42z2DrSaOb2TBA+ihZHFK/H4?=
 =?us-ascii?Q?9fTVAJPnQysJBt02VcWs7XPbjklR5Ei5NAIYpB91hSssHVX2Z4EABtJlus2S?=
 =?us-ascii?Q?3HxDOdDeIOEarmWUxf6QkosdUckHJgMYGa5NSDCecEo8MhkZR/mxZDC2NZRy?=
 =?us-ascii?Q?7gSVIVdyk2CIz4FGKMClFlBq/kcK9qGJrxqOehOW83YBQV4nx4T0Wbc28uBe?=
 =?us-ascii?Q?HG9fd9Pvcu7dSFc3I8eu7wUBYza9xGEhvff8z2o8CFSSwXsJifgoP4XzaTjR?=
 =?us-ascii?Q?jZvRz4qipBO0rtgTb2QBqYVkoV2ruJJmniwLm2Xvu1faoghil8cc+NYppIny?=
 =?us-ascii?Q?K05tZ6XASWilz63Z5q2lgBsI6uIOfiPCnPJ3dsQoxpV68qeO7LqMhmcERlKY?=
 =?us-ascii?Q?gUcbJQSRl3X07pvUD/1W8mpzN8OHF9IFwt54It8wPl0543MYYO+g9M/8V/yI?=
 =?us-ascii?Q?dwdjdxIEVoLu/Ms+UCKq/FrIggwsoY0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101267fe-06ab-47e7-ab01-08da31074546
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:32.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al7/QtefMija5J8BAr00+n8JNBAXQsTQZW6vFfRtSuSEnNxGCfO8qkMDYYVfOXsESm16tj7768R2DlH721Ax8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with host FDBs and MDBs where the indirection is now
handled outside the ocelot switch lib, do the same for bridge port
flags (unicast/multicast/broadcast flooding).

The only caller of the ocelot switch lib which uses the NPI port is the
Felix DSA driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 3 +++
 drivers/net/ethernet/mscc/ocelot.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3f23a6093b27..e9d8aa9cc294 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -794,6 +794,9 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	ocelot_port_bridge_flags(ocelot, port, val);
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 29e8011e4a91..e0d1d5b59981 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2943,9 +2943,6 @@ EXPORT_SYMBOL(ocelot_port_pre_bridge_flags);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags flags)
 {
-	if (port == ocelot->npi)
-		port = ocelot->num_phys_ports;
-
 	if (flags.mask & BR_LEARNING)
 		ocelot_port_set_learning(ocelot, port,
 					 !!(flags.val & BR_LEARNING));
-- 
2.25.1

