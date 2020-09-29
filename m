Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E411427C219
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgI2KL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:58 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728295AbgI2KLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av38qI7ps9BV7bFCSrCML/FZS+822RimaQH+etm48hzmbK808S6JghTfCnr/YFApgZ/P1d4TMjczwTfS7Jn+PsBov+NZd96T4EJWz7JUaisF724a7b+R1jnMA+nzAD3+qAHBWw6t0moPf9We2MUvf3A5zgkB/Vwa3p9jRSrliVRwclRYKGdJvF3eswVlU4zWVjeF7ntttSNTJixH1FnrPhI/d/RRltWRi6a4IKWkLAFayc/GqABscqQSwkyY33/PyK1kpCXUEtCED71S0jiIDcSySytuv7JfNYsTJAS0zVpMC0l2wc9EZff4jpiQ9Jdw12Ac86+VjdgiScfZPvxQ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFnVfqlDgYBxfpRvMYGl9lO+zZyIU8omK2mzU8p5Qjc=;
 b=DwrtINty1FMB0Ng+z/B+CQslAQqLFsQHvlhPXCULixIAKpnTlJZcryuYjUnqGaHCNUbD/3UjBBCwLHt8+MKcsh7zA4slaJLC568R3vTKB0nKj4WkLZQeAU27GNSHudvcrAMTSuISd3DPM9o1Xtcxc34PVYT/P4CADhep+cSoprESU+EKgrPTV0MawXcZimiIRbrWyMU0pISS5t6y+1BY6KTAFE06kRofAFSpgAXq8LgfuFPYjaZd31AHRMxnu6Ls9XFNfazPDwRy5zQR78TrLGAeJB7xnubZnCsQ0Yzpt4m7E0yFgMXDBrelXn7LOfeLXQHSnxOkQXKJK9fQpMMDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFnVfqlDgYBxfpRvMYGl9lO+zZyIU8omK2mzU8p5Qjc=;
 b=LShcogsKiJEDp+xDXprnCIw2GEV9TDm3Jycs3kVJDOU0HaX4w2QX8bvOW6H+92ezMM1hZdXFGBjQLUQXuZ9vypQxo2PR+MMZ0mYpwly7OWd/zjIccpy8PPlUUTLOR5nSsqA2oqu7JrZnkyaMR39wN+BwKu14Clj/tbqK4vU8BQ4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:50 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 19/21] net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
Date:   Tue, 29 Sep 2020 13:10:14 +0300
Message-Id: <20200929101016.3743530-20-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d7a1e52a-b83c-4dbc-9f9f-08d8645ff13e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D39C302356A13A3BBD04E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6cjAU9TrANZeVSr7MePomd0U0xE+wtRnd+ygiL2EsHw0Oo09bD8JdAGsyEpYwLwBVfUMmwfoaPmqNIpekPQAPmwCHM7P+8CIg0rulXrneSzHDQD4Xl7JkxbAyG1VCX4U2EzzTjK8NlniB36vOkryBcdqmXYg+sT8+AoKg3CYQPxk/phoBGFAtqclif3c3NRdZz6ruKhDWQBxi/Ws90AVI+/8E9h3tB/P0SP1sQdqE1fxIpzFCIvjShQwB9tBWWn/+GpCJ8gYfbEYIUZ9d8KuoZtzsmOQx3rnpZlFmu9/HapRLh/8oPNvklsGF2CXcTK+YuLpsf/boHSjbOh2LnRexqYoeAZuh8ObhmeGtQUazf+cKh4nOmpw+bUHLeiOU8U7QGhXqo6q+Vi3N/TFvoBz9+vDOau+sEyHs6pw4m5K5ZTghAA8ra6bOmpr1kM4eN3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2i1WiMivMZM0T46DSoMB1CjcxvZKOj1veeFNG4xMVx7XSREL+uqKSi1y8K9TvGzp/LuO0iZ6i/5Hqt5dLhyxZiZ52uXgFLbtpHvSBfTujJvcLDyRLQ+imKfo1BAp1cTKGA04dKytBiQqGU6zeQYj5pUQJIWmJ6k8P4OFN67z2f0VS1bEuE4XNWStyt3r5q4FIGDubPaFPSBOCwWP2nRp002AwtrmtiXqxvoBU14uWAJP/4RdN7KQgvmFj7uVy3xRX5g3Uo9XlETpTdaKyTCilJDEO2LZXfeBdiiiSX/878tpeI/Ta00KAauIsokALtNutvFJwhcp+GNRqLnZxqx7il2sgAfptWd6g3ejp7Gz9zKY/GsxMGJXDR4rNjDiWIuCjP+snqwWkKi35w63LBf6TTSq1Yzsm82Wm9eeCVpCSAf0nh0x4F0vFClmEF0EAl8hBakodbQNZkEizbmyhrzzZcwrK+eqJ285ot0vDqa58enIbu8gOh6Yh6hghQWYjD5fFhM5fLU4Gt2t8199c2wJt/9zja3gDGEIftkoKyop9cfkJZVUN9QWf3ivy5mJ12kS0yj/kWwYxjgbnUcuPgz1aYiTpb1YFTr1NchnzUb8qbyUd//fshH3+repKn+cQXnja49myjEaItyydo8gFTcODQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a1e52a-b83c-4dbc-9f9f-08d8645ff13e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:50.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4tuwuSeEKBJ3dqmJZSOwrX9Nq+DLwwjjUChqE7lAiMhPO89yvVvGAnwAo4alBrBFAMVG4nXfzBbeiaaFKkYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 36 +++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 958d8263bcdb..6811d6391a88 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -947,23 +947,23 @@ ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
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
 
@@ -1014,30 +1014,38 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
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
@@ -1052,7 +1060,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
+				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules, use the other IS2 lookup");
 		return -EBUSY;
 	}
 
-- 
2.25.1

