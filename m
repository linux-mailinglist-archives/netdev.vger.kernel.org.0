Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D823E2786F3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgIYMUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:20:03 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:28384
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728369AbgIYMUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:20:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkT5xMm1wriLI88mavr3tKtwIN5/lhVRK3untQz8K5V0SwOBcIUzbGsf+MdnlVLNQPhsJmKk0JwChVfgJVwTECYxQg2oHxmGBAgwcl7OypsZdzCu1PJSO8Nz4qymegMGqZxKV2O4a+KhZHUhJgjE2kcKvY3LEE6lI7DqY2HC82YR/WS1a6KeqPEQVj0My2RTJPiJkCuJ5SbcNbBCAxP5JiAA5Jy4AqUTmW4c9GLyQawMMzNlktO1Cka5Gzjn6otIeDvUiJIhjWRBV7Yv/pdMK9DfyUt6Rqv59Phx5UrPsVhGwedrRSBhVKjlFYqKsIN1hmptktKAvP38BFcoZoN3QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ypa6b5e61iVevCibbx+iuLobX+7XnDFI9VsDiUFICOE=;
 b=lcSN2XUZ22WWdlNm/80EiaZJlXNYVL6XUDALuUoKTjfxbMI3efcAlekxOLgL623g8WJR0DCV5T1te3nvb40XU1d/fLdBtzHI+ENUhFD5FTb8xjZiIBdw+fNpDAw5IocpwX/j+zdH5Qd7+JhGMzgB7oYThlu5fA1V3DXf3tULD3OiRpHKfVf4iDXjYAJ+OZH6TqwibdOYD5USXI+/Axjwn+MC/Z+JEsyf9om3OxeC8Q4/6AVoDdzqseEk/as0m9188dJBvoIWbbhd/C7IVnjbI3HOeYeTZ68cQ95ZWHjrx59zm+cL9SZR1B81WOOe0rXx6U9NL5vyYUUxVvMYk7hZ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ypa6b5e61iVevCibbx+iuLobX+7XnDFI9VsDiUFICOE=;
 b=ZU6+1B0l2shD+QSnbX69tn5mXZU0hcy+1PLTN76HvutqzMl//4ihA5ZE0cRbot92xpHX/jEySL+uRBkU34cpKGQ9Y85cypKLnn0uARpJk/00p6VKT1tdtqkm+Y62U/8wG14072bPb0WcFHgfFjZidFYf4rzLTXlO0oNlZmBEyNc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 13/14] net: mscc: ocelot: offload redirect action to VCAP IS2
Date:   Fri, 25 Sep 2020 15:18:54 +0300
Message-Id: <20200925121855.370863-14-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cd742e3-c28c-4445-209e-08d8614d414b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35504E3521738B741D2EDE0DE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nrmi7ACFGlZISIbQ7cbnXZDTZKF6wkCzanMCqiJBCGZtNVCr/gPf0H6ru4lETg3NCJd3Bv/xSjFiGhKGtC2nYuT0KLj19PlF7xDIK0HZ2S+h4lVVHRKNXPQJiolkhnZpIX3fDqeWFX++g4FDiIpnFxtyZLHg48lYMSocv7aR89aN+GylYflVq/uHon+SpMNkR6twvcCr7ffUxTLDdjwh/o4GkzB+bCIQHjxz/V0qcJcY/zO+4/GTbvdasMnruiApl1xZi0chms6BwNrdoC35e1TB5j5N/drlzqt+fq1CByjZwT5nRRisqfehgOa2SwC5VkvInGWychJb1oBtUGQlUm1iqCyYnpemAoqYpE/yj4DmwmhSE0HrjCxT7DVsORb9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pfxZlhI9IZC8yCkuxC5ZRjZ+Pt6yY6419d4MXVio5ez7XRtohgApoiQuU1k13WJeFBvW5M9Xpumh4D+v25sqgU/GrQ2BH1Vf5ftDvaxU8wOIVOkD5+VpTKpyoy61miV63gD2vctm8axocJ7h/QWZs+124q2AR+cSPfMeZiLhwzWgAYBI/dNBm2F96NeEEjIq/VW7yvHEgLP4pNXBHejLPqBiQ01A2RRA3OAZ1cHt02wMhNOY7qjb14hJS1G4pCM3Nw/K1PzZBnWV4L/Qf15EGnSNGMYath+GBWLKlrpAHoZL9zIEaeXr+tDdMQQDD9Pqw7XVIm51CwQN3X68zBplEH7rVgoxgVdK38fZRjiNaOKrxZjG4how54EqSTTRVv50vDl7rMOl6Piv4eYdPkQAjsOUYhymAjqWYxym/dj6FzIwxriqG+ZKCReIuLy1vOCVvC9b71IpLpM2Sw+ifjU7dxlQGuGzgaS1UsxacyhFTITprN6d+od9AXcZz2KY/GO2ERM380Q8QrOTrx2EdXKP3Li4DP8T7V8NX82G5Sl1tNGJCEXUCnadyHmB6mNi9cZ4mNFDCuAKeGEQaK4Dt5ry3mE3O+tEKTj/7tpgP689V/YcQU8l63/B3IAAVwfktoQB2ETR7crT49JRRToI6FIAAw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd742e3-c28c-4445-209e-08d8614d414b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:31.0712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA518xseb/8SQROcxxWP3fozblZqfcaac/FbmAkEQA45XlnwkIXMjiIlUaDxix5Ue7Fase5PO1fxDFzo4NVQ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Via the OCELOT_MASK_MODE_REDIRECT flag put in the IS2 action vector, it
is possible to replace previous forwarding decisions with the port mask
installed in this rule.

I have studied Table 54 "MASK_MODE and PORT_MASK Combinations" from the
VSC7514 documentation and it appears to behave sanely when this rule is
installed in either lookup 0 or 1. Namely, a redirect in lookup 1 will
overwrite the forwarding decision taken by any entry in lookup 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 28 ++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index d7e5b9051333..f42d5a3cd005 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -137,14 +137,15 @@ ocelot_find_vcap_filter_that_points_at(struct ocelot *ocelot, int chain)
 	return NULL;
 }
 
-static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
+static int ocelot_flower_parse_action(struct ocelot *ocelot,
+				      struct flow_cls_offload *f, bool ingress,
 				      struct ocelot_vcap_filter *filter)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
 	enum ocelot_tag_tpid_sel tpid;
-	int i, chain;
+	int i, chain, egress_port;
 	u64 rate;
 
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
@@ -217,6 +218,27 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->action.pol.burst = a->police.burst;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_REDIRECT:
+			if (filter->block_id != VCAP_IS2) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Redirect action can only be offloaded to VCAP IS2");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			egress_port = ocelot->ops->netdev_to_port(a->dev);
+			if (egress_port < 0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Destination not an ocelot port");
+				return -EOPNOTSUPP;
+			}
+			filter->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+			filter->action.port_mask = BIT(egress_port);
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_VLAN_POP:
 			if (filter->block_id != VCAP_IS1) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -528,7 +550,7 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
-	return ocelot_flower_parse_action(f, ingress, filter);
+	return ocelot_flower_parse_action(ocelot, f, ingress, filter);
 }
 
 static struct ocelot_vcap_filter
-- 
2.25.1

