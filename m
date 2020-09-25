Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277C2786F1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgIYMTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:54 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728632AbgIYMTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8ZI3gzTaG3yK64/RioLxjLfWjgAdZxWKhosx5gu6y/2u/mpK6bcXQgxqDLrJbIaVRSaLyTwAN88kXCLVpfzWqZpWzA2EXBC68vOnjXqahe8O6iOoZfZbLMGG3Zoi6K0lPTB/RjVG7uTvEl0SvIgVaoRGxeno1D1MByzFYUcaYhga0xa4SRN1+XE5Nn9Ch5QOjM11aCYXLyTtg7ZNtxBu5sVZEjjFUIZgUCVTKcfaELrFzOGVuy2tOsWSv8fvtxr4tvwKetkzIkmd071axUrlBkfn6x5eL8lsJD0qtIIckAu6WTLiqAderlEd/0cQZ8mBBgiQ6FwO7eFwZYDOZLsQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHXOZItsmQRxrHit+LIA0EE3RerdX8wMPl3BvCAbV9k=;
 b=n0R2v5dxeyOa0I/+Wfo0esHXw5+fuSfTtRRJsmDzWGGcWpfaIIyRJ0ZGL7LNXQoiZ4tqXGxl4UksxIhSGQfVltTfwZOIw3/lV0bIfPubUtjxR4pO7NOieWsYegihvYN40Cjwtfchh+6Qri5BaeN79tdsL19v42o2EsqVZ7boxPoETlRvS6l9KclGipGj/DPX0753++inBNUo2hNaLgihommSJ6Go1O0JCPPngzWwjpS+2fWDOnMfecg/9ITiexUCzFrhL0VWhx2v+07a+Hy4Y/qSK6r0ThT9L/Nj8OIvZ/rhlrrnh+bI4XndBORSPC9H933kjiM0poA2tg/ZSK/rvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHXOZItsmQRxrHit+LIA0EE3RerdX8wMPl3BvCAbV9k=;
 b=g6hutzmdYe0DYXZPtMNzYsoPQLDQxoLU3KAVL4w+pX+6J3RDQkjIhp3/D/7/dK90ss5JZELLdSCH1I8KNYIyRCjJX1+cv5lYBYZ8VV9Xu7aXqSq93A4zUpfPGgqftUdOf8U99I5RvqMePjL2895UBGYepDagau9ayR8wyrn66YU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 12/14] net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
Date:   Fri, 25 Sep 2020 15:18:53 +0300
Message-Id: <20200925121855.370863-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: edc19f29-dee0-4737-5feb-08d8614d40e9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35508170393724BB630CDC65E0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cHErQyKm6L8/2YTvorpmpYvo2JGjdctF12To0aMNt5TqyTiSLBYK1rC3wo6ms34sUZK/IuwS2pVKjqvAMxO25syF0kJR2ps8GvM3b/dMWudV/dHnv0E9L56lAK7n42s7AesjCNEcSddelRnRk/nNROW2H8pRaYemZVspcjC9lFbAS1LJC3AOk6NXhMtuwaChb+u/5K0jA9g2tGmS7x3er7Pq2uJDXoCVLr+lV78cxxQ0KvkH6rHDDtpI5A12fTOAL8lPwv4rZQkZPCO+5923kpJ0VDF5xqP1QdLuBj90+pVvPEEH4AM/jBxbpD9fL74fc5+Qdh5DhX2qNJx4G6oV4l93bsheSWNAUEF+UGuDSoe3lqnc4a89JOiDsiCIdWp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AM0VWRGbMma9lCOiwf6pIB7xUAWP7miqZzIWFMfG08gyxBdmYLNHDxOA+G/z4Wq8DDKKrdw3p6+rObsXk/BhKrkwBoGll68nHO0QXfZKYEmdpuqCsGW3DVkeJdaQlCcrsOqIdOG8SilppQoU73Ld4cSnr7QdqlM18KV/wPNmOTEkSchwv1gv4VisqjOg6D40U0Qxs1+liETzPjgTUFvC5TxiPgs9Ets6eq4NRcht/UT+hT5gE2uOMiNhg9vzCC1z8WqFZZTHJvRVY9040RGfR52oTVg01g5s15kPfb0xOAvoP8XlpFKRh86DwiY5amHjkTDkj4PslfGilDQbgk3UT5lPQyBFaxfX0PGHXpwmWwjgazbJGlWpCaRVhADVKZ7NQxhbPnz1g+qV7jBXgAIHaaIHnH7V/bu/+dVY6zQBfhsohEkf0jRtUiRUcoZCbv5BsW6PKojHmK6JVoJomJjeN47zdXNAZOqrqO2n96vk+H8NsUjdRpfaE/5EfrkURplD2yXlt6+TQ8lDO8xuBDP3hno6jHBCMUmiZd3phkgfwhVmtyxNbZp8X5ycSjhym6g4VOZ8MRKzjQ/eg/+sWxnfbO/aj2G/ltKSj/wzx9sgbfO9KlAcFb5Bc2iaIzgGRrdw7wDtgieTRQ2/eCrkBK/sRA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc19f29-dee0-4737-5feb-08d8614d40e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:30.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHrVXkDVhljTBXLpqxMbkWAUHp3pcfo6uvYDh0p9p2BXZ3VZ8e5D2ZFLmVBYpHWaLe7X++btJMXJNjxfDmbNug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue which led to the introduction of this check was that MAC_ETYPE
rules, such as filters on dst_mac and src_mac, would only match non-IP
frames. There is a knob in VCAP_S2_CFG which forces all IP frames to be
treated as non-IP, which is what we're currently doing if the user
requested a dst_mac filter, in order to maintain sanity.

But that knob is actually per IS2 lookup. And the good thing with
exposing the lookups to the user via tc chains is that we're now able to
offload MAC_ETYPE keys to one lookup, and IP keys to the other lookup.
So let's do that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 36 +++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index dbc11db0c984..798134666586 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1045,23 +1045,23 @@ ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
  * on any _other_ keys than MAC_ETYPE ones.
  */
 static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
-					  bool on)
+					  int lookup, bool on)
 {
 	u32 val = 0;
 
 	if (on)
-		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(3);
+		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(BIT(lookup));
 
 	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS_M,
+		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(BIT(lookup)),
 		       ANA_PORT_VCAP_S2_CFG, port);
 }
 
@@ -1112,30 +1112,38 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	unsigned long port;
 	int i;
 
+	/* We only have the S2_IP_TCPUDP_DIS set of knobs for VCAP IS2 */
+	if (filter->block_id != VCAP_IS2)
+		return true;
+
 	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
 			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    tmp->lookup == filter->lookup &&
 			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
 		}
 
 		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
-			ocelot_match_all_as_mac_etype(ocelot, port, true);
+			ocelot_match_all_as_mac_etype(ocelot, port,
+						      filter->lookup, true);
 	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
 			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    tmp->lookup == filter->lookup &&
 			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
 		}
 
 		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
-			ocelot_match_all_as_mac_etype(ocelot, port, false);
+			ocelot_match_all_as_mac_etype(ocelot, port,
+						      filter->lookup, false);
 	}
 
 	return true;
@@ -1150,7 +1158,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
+				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules, use the other IS2 lookup");
 		return -EBUSY;
 	}
 
-- 
2.25.1

