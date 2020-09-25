Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F362786EF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgIYMTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:50 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbgIYMTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhQWyIR61etf0hh6dO39FJxOOf2Do0FgK/9wEDWcWZuA1wrOd91zw5QOX+uI+JkzdVk8ognUJctiVR2gAEmryWGxPBPCdVA1QnQ08QkorSPtDtbisoOm3zcfdsvlUqK3/Lc1LsZAINBJ4Rxh+NGoZHaV1CRO9hnNmEt1Py0TAuhhKUYP5Qax1vxmiYGSmIBSu2fgHzMbUptZqaffGNz0mRboTv82eSG6CU2xJ5WLtDJR0q1eX8REEPWRRABGNDyDjVPdJxcD/ExJiAXRrzcHyTmlMAx9D+KPgc8nxnk8mlmo0bDeFFmqu+BKDHBLIszVOe6zlbhMRVNdnrnoe8Sz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W870QHTL+4ocMl43PJs0+V8LllMbf8nyVOFquD9+AdY=;
 b=HoHF2GC4dKg3SRTZO+JeezPNyFlGaITzDSRlYV2qL7+N88L7y604XxtGT4r3Uirap7d6C7sd9FSUjnvZa0hY4eUQ2LBaLyPeMvoLOA95pFkWTp19KmhQKsGJooJwxyK0cOKC3G0yrrpIXS0HtQkbqeOL9Ccl8XXydzzPppD+WhwSutnm0O9vWqIiz/dKE+l3O6F7Qi5tV61KTHFWbczxwf8flX0C5HQFel62WJwBbw9WFD88BrBZFfb7dQcBaQxibGqkNJ+tXR2wecUj+nLzYVEz7sv3FzydRyC11F89nvMnbYGxSBqU0Hxo6U1ZLHnHpnqZHrRfkQ58KXHfSGvvQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W870QHTL+4ocMl43PJs0+V8LllMbf8nyVOFquD9+AdY=;
 b=ZuAPaidnLkNB2xx0tB8SFUbH57dS53RJnkfGh8mVV61e0Gw+Hp++RmZuBBSBcOqmtLoL5/gvi+kekKrhZJUogQ+qW2JeXOk3v5QC3yFuiGgLmYVHAA9PBejA2ZgpJpsB+5JTU5jcvIjkFXOEDHXTXhVtJbAlUMEOdDvNV29uStM=
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
Subject: [RFC PATCH net-next 11/14] net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG
Date:   Fri, 25 Sep 2020 15:18:52 +0300
Message-Id: <20200925121855.370863-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d56bcaef-ebf5-4857-0c07-08d8614d4083
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3550DDE43E50CBE4DE2606F9E0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDBRkL7WX9dFz13VtWWPH0faAgMEw1sxHAO6fp+YQx2aU9gbifQmFBWxhbXFXKCa17i0cEbO1N7FYNzyp7Ei3N8G8n5iAWm8zMtQHGXDfnEHCXmiLVnbIllDzxeaMzvNv+JWYsqT5giKBXNMV0GXhQzwmZGQRcdkNThq4HwJh53JXHp7o4LK8swEgt9MFLDyp9/U9ErtBTwQ2jenR5x+QTkE0dNjJ92pXvOrxJNrJzBPDvFe/h/Not8K7975EkZngZpqGAzmzH8+OT89AC73u/XFKxt4XBQvN/aaSNQYiCXFgXYToKE990zliA43hAZ/snomE3v0bHCzxBF4qBtcdY/q3UHYuahOrzSDeeU9mZjsVMJHrnMC+7NDAhqGMZHT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9smpCFbzrQ3xurSkUob1IGWfKu6jqCejzzSRGHD1U5cOVe85WWrAtbY0BopwZXgisyHZ7EQ+O7OAK0K8M4ugR2BbdZKsfCYjVwKVxRTj37N/6KGo06gi8Qq1OMAxES31gb2Bvr3rWgrS1TNl8nyu5nRc5Ml1MSGPt+FlMkEWCLseGgjmlk7cinDqEKLc56T8aWcZmXTJzG/l1Yp5yVgAFqfpLy/UAbl9/G8SUZOtlIykN1H/0u7a2NeH/Px5MyRc/ZS5IJ16t4HI4qGIVyQ++xBhi6FV2cVjjZ/EvgwUbFvixM76HfYSFr5+noegtV70H90FJtDZ7Pkyv7aVawd5/4SO3Sc22d1cqUZlMZSBkMQLNuk6+gR52VwxVuI0zChPyf9vQLNotnSH8np9PioqecVbdO68F2MXmcRQ0hwxc+kdSIzJP6kxCRm/wFBWl8b2WnZqFSAuVMHujYSVIBOAVyIXS37INrgwOu3AKUtVdwiQmfh7tI+VfJIbqCtyjXbobyEiDNO4CMLgMZU+aIEbbR0S3tYppJ2wsQr34pntyvB5kY91vCQ75a880ZfZSUh17yiVQDe3vOVFnN6qp5IW4b92PwLTaEvDWBNdpsE3fBBYz8xrKTUUbkOTqveVHZHoQnTMMawtCDRP9pHP/plZhg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56bcaef-ebf5-4857-0c07-08d8614d4083
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:29.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlUZXuGdp7BRF+WcTrCYWeglhtMEaQiqXtLtgMarz/05kZBgsDcNOBU+CgFz5oUCIxaoygMUjdx1J1hY4T+DBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were installing TCAM rules with the LOOKUP field as unmasked, meaning
that all entries were matching on all lookups. Now that lookups are
exposed as individual chains, let's make the LOOKUP explicit when
offloading TCAM entries.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 10 ++++++----
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  6 +++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index d01b235f5134..d7e5b9051333 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -159,6 +159,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	}
 	if (filter->block_id == VCAP_IS1 || filter->block_id == VCAP_IS2)
 		filter->lookup = ocelot_chain_to_lookup(chain);
+	if (filter->block_id == VCAP_IS2)
+		filter->pag = ocelot_chain_to_pag(chain);
 
 	filter->goto_target = -1;
 	filter->type = OCELOT_VCAP_FILTER_DUMMY;
@@ -198,9 +200,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_POLICE:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Police action can only be offloaded to VCAP IS2");
+						   "Police action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
@@ -269,8 +272,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 		case FLOW_ACTION_GOTO:
 			filter->goto_target = a->chain_index;
 
-			if (filter->block_id == VCAP_IS1 &&
-			    ocelot_chain_to_lookup(chain) == 2) {
+			if (filter->block_id == VCAP_IS1 && filter->lookup == 2) {
 				int pag = ocelot_chain_to_pag(filter->goto_target);
 
 				filter->action.pag_override_mask = 0xff;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 527b55199c0d..dbc11db0c984 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -350,7 +350,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
-	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, 0, 0);
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, filter->pag, 0xff);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST,
+			 (filter->lookup == 0) ? OCELOT_VCAP_BIT_1 :
+			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
@@ -671,6 +674,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	if (filter->prio != 0)
 		data.tg |= data.tg_value;
 
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_LOOKUP, filter->lookup, 0x3);
 	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, filter->dmac_mc);
-- 
2.25.1

