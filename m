Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AB7522FE5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiEKJwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiEKJuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:50:44 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20077.outbound.protection.outlook.com [40.107.2.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F133FCDB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO0mUVIAIJbp4PMYwe3g/RFqTCA4Ljlwy5XmvdNtxMoqN8pF4iLFzrJ/gDxurRmzFQ1dKMj7htUkn75VtnMolvqXF7pRxVE72yWdnVBgxob4bYQRv8JSSjozs3cVHoTFyFfOmk+ZfhdbDZj4xXlxxbrpTt7tzcNTbF13OJZRaZ1jhAzujBiKilojAQul8N9HnOPx4LfUPiz6faOj9S9LqHDM/VcRdhALUr7uzt4lT8vMFGXLC2sGF7fGnQxyie/SphO/PviwSy32bWS8lrj45LheRyvOZ/FYtbUdpAPovGPQrliHeox5OWDJqXwYG6YjA4vdLxvyhLO/NBDawsFZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fi5+f6OYsHTn/1WNdutLYIUfyM6awdeA5Dkh3ZqjkFI=;
 b=kgB92Ae8FmmiftlrjB2go4/R1kaDtCxR3DoHT3t6UbTUGLxFXlopI3l10hs3Xb3rWeAnshiPH3fIPOHrOCzn0+NqAWNGsI/rxdvAeRuXnqeK8wpkXI2NyTW12PoNH+HL82fb4BldP2bAJG9rOsqKV5UEUejmpatzmDn7O/8+uPmQ4HHeurTuY8z3fsN3EAWq1QV6XOC15f8BbsaYjVUnGYU1z5VQhPSywveeB8eEePThDS1VeqJQLXBRStbktPJ17B17ZuESQLlugeg8DvxE9BnYRykj2VZKPxvkVQD1l/bB8hN8aKqfi12L66cttjOPlCGHC1gtfPLjoaRH5yLdSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fi5+f6OYsHTn/1WNdutLYIUfyM6awdeA5Dkh3ZqjkFI=;
 b=pUbS26AM/AA2ya+I2T5Q7K8SxooArQoq4oZqZmhEDL80tVF27Ldevl4et7e1CCs4VN12bez2ysJwc/x1fBZ9lLX+aCsazqMtA/OHA0giXGMVoY5VIsNuCVLWgI39HcsyGxi4xQNT3xqjTezgIIsW1b2Ftup2WJa3yJmrywvoizg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9155.eurprd04.prod.outlook.com (2603:10a6:102:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Wed, 11 May
 2022 09:50:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:38 +0000
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
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 3/8] net: dsa: felix: bring the NPI port indirection for host flooding to surface
Date:   Wed, 11 May 2022 12:50:15 +0300
Message-Id: <20220511095020.562461-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3c7d88b-21dc-4cba-0e02-08da3333b404
X-MS-TrafficTypeDiagnostic: PAXPR04MB9155:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9155F753D6E6D269A071C721E0C89@PAXPR04MB9155.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOoN4EtNE9wh4ZN/7MzsfXfrEiJ05k9/7tW0Kjfnxr8jwHxtJKau05dUZHhbqJHG7O5L3IbQEglTFTpTfNgPaPAlYx7VsDJtZBfedOb21yenqZN3KK1ohnFrWXnTzXfx8w+1ObG5UUEDTspUoTZBsvQH58E3g0hC906oMJbtZiphkjP1hSLbl8NlUxSpzCeDRvQ6Qbfemi8elEr40cr2/XAELL/pza95IIyERwZKcRLjKRRg5otV2oF+BkaYGon936BZPRLath0IH6oAOvOo40En1YcPAMuinQQ0Ek2m4rLxo9Svabk2p36H+a8kvjwIFssmT3ftridHi11wp60fL5ijUCB+KppG69c5mDHwrx9fgwLPrmH2mHl2UHb08YVy4lG+fSBXMudsNkWJD78BnK7H2fIBy5nARnFFt52IGW+a61Bml97O36wVx+W5wj/cgAr3ujJ55NOANf3NThrjQX+EjkD8x1yrTw9E/c+GK45YhTEgeQ31GgbblizPtIk54xODqF5az0EueNMcwPgqTnlbPqXRp0WbOGI5TtOpbSYldMnSN63Kc+OgUhdccZq7KYjWRFvvBt5nHykgnpSLPe0sjHoBJwAFRi4Rqssxp5VpIDnJCy2vTLA8qknUZWuTiA/tX1P1wQCS1+4xHcvQiQ0NItJtL2/7qBHtj+TO2dbTUr3G2HX0K4Y8AA1ixGIV4MwT987lv85bqvwZLR9bnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(38100700002)(38350700002)(1076003)(7416002)(2906002)(44832011)(5660300002)(8936002)(36756003)(2616005)(8676002)(6506007)(6666004)(66556008)(66946007)(54906003)(4326008)(66476007)(6916009)(52116002)(316002)(26005)(6512007)(6486002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CsHwC/3j2ZfGfDv8kIdunMSOlYjpyCR7Yt86x9TgFW+sYuY3bcnmgTL4BPST?=
 =?us-ascii?Q?Jy4DCMYSO8tMYsp+oKzy2JVmxE7Pchhvr92Wk/uXk/ESsT/V0gwgUVnPy0CC?=
 =?us-ascii?Q?fBNt6w8lgB11jaRSDDwc0ZexcpZfIfO5AVxLPV5wFQn/WY59tyILS4sargAV?=
 =?us-ascii?Q?Ysgcxylz31FLghWWRIPS6KN7dp6GB9vnHLFaAqlxQS82o3qNHdWeA+Izoa15?=
 =?us-ascii?Q?X1rdL1X2fH7cz2sTUaOK9ZfR1MfbKjObGhddvLeVC1Bs1MUMeMvJltnQrL/x?=
 =?us-ascii?Q?r4RO/eE7Ir1atKFUn/aPySVK03zdTZS7qxarFErd6mN1rphOhP5Psego/90r?=
 =?us-ascii?Q?7R8WzxmJHL8i1csAv6tadqK09vpZQplY5dfwXQfLj9wKkcRDff5QHE5urqI+?=
 =?us-ascii?Q?lBHT1iQ6lQEzXTmIFMsGQUTn8+HWfvlpjZzzUXPbBiydPhD9dh2Lu+sqbcys?=
 =?us-ascii?Q?LsxNesSVQKXcBzVLXqJ/uxTTAg4i/Igc0HsOE1mtuQt6Cc4yWoGp/8/lhmmF?=
 =?us-ascii?Q?ipbQCqd60XzYyK5nrx6NCRQyty6qA9dChmQPUX/ho4XrBoJzoMauiI4SGVXj?=
 =?us-ascii?Q?eX26QtmoLj9loU3+U5ZOqG93YY8hSBmjkbwG5rNUC/X1GXpEo4nmLF0XgoM2?=
 =?us-ascii?Q?7LzJa/8jbbExnUjHFRYWyf3f5FpeeZvrVFtxvOHwhUtSPOuPfJIMruJd1GH1?=
 =?us-ascii?Q?/LHz/LhNzm5CQHpfr5K04ZnEXS9V2rAL+ne/Nfi5qfqfj8K05xcBSzo3yAOD?=
 =?us-ascii?Q?moIlOWiK/5J6K4oIjrmYo001BgPhyLrn1ueKAoav0QbIVX9YM3m5l7LA2K1p?=
 =?us-ascii?Q?4cOp6bnuHVEmAZAT0cCRLGXCHuTulINoEbNlGsBxo/3TDCXo3rbG8tUJwNpm?=
 =?us-ascii?Q?m81h5Mx+ycERaS7DGy8CNETU+USsUqVLQdPCIoIa0D+o29539APEVhref7vo?=
 =?us-ascii?Q?fNcHlePC3X1tbYHYWhgsvzt9J6uRXFG6TC6Ow1uS05t7UU6z2XiSv4ITLMz5?=
 =?us-ascii?Q?EWO9FVLnw7d9B6g1hJw+OaWjnfheaSTJWpp1ISQwopwWaFVxUQy80ULY09mn?=
 =?us-ascii?Q?Vsh5zA50Tg3+8l9Swtx4p1xjkBBspiL/qpiLt93MtQx7Kacx9Ud3RfI0ALnG?=
 =?us-ascii?Q?s8OLqA0w5/v6skB/Urv0ZjvUhuUTa95a5+bKvzzUjcgfeEigB8K4Q4GS4NX8?=
 =?us-ascii?Q?dmWsZ2lSDujlwpEWmP6MXG5T449Q+gh4DrYbzzG7fsBOUpdz8qqEYAxyopzI?=
 =?us-ascii?Q?KhF9PrP1Tqa/tmzyde0vpQsrwAIfSYlddP8gaKcMPN2tmk1c5y2igwCha38E?=
 =?us-ascii?Q?X0ai9RfNqFVF4p3wvjxC0BiDACHlnrrx859bkX1WlYdhT0aRxaKsDfkvu9Er?=
 =?us-ascii?Q?4okO0wqRVDbztwsnRwBTj87SoHwG8IWs3C66NmR6Fl+zA61pStGb6l4M8Ne0?=
 =?us-ascii?Q?tPfanXmO/mw7AwvpUiHLBELNlFleOuxLvV8okL3sqDc/9aAMKTnDz8ZSqqDv?=
 =?us-ascii?Q?dy/bosi3ONahXSiymHBRpe6DMWhfr3+VXNc8OqfK7xPbImYBkEbU41Ef69eo?=
 =?us-ascii?Q?5HDLVbxUKHSOPBbTahcUh2COsd+nC9JEC1EpNPcXxzcRvY7UeOwbBVxPfwZF?=
 =?us-ascii?Q?GOKUpvOeVNpTOuXO3b4d+ievjsHm58oJISs2v1j+eAQstK5WNXZOtmjG0qos?=
 =?us-ascii?Q?aqRsHBQl7cGEp7wYUG/JV+fWEOQf4eYGECBzlOVm4udU2YWQVb3d3Gzr5Pmo?=
 =?us-ascii?Q?ksSH+uy+lEaThqnEpME1MceL5pvz6l0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c7d88b-21dc-4cba-0e02-08da3333b404
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:38.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ciJvfNEtqhUlgTTQJc/kVq5zEEE/m9G3Qjc4qxb8fKwP132UVW6YVHZLCmrphZ4q6Z1jTUo0MyMWkBrQ4yQpsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
v1->v2: none

 drivers/net/dsa/ocelot/felix.c     | 3 +++
 drivers/net/ethernet/mscc/ocelot.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f8a587ae9c6b..59221d838a45 100644
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

