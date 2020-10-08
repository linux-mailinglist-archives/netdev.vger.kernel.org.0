Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B8B2873A8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgJHL5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:57:19 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:40513
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgJHL5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3VEX8xcCJtdg9m1SYHc3CcggtSo6kXZLsqBCeJPn3A/3MEAdvofSsa3FKVkp3sRQnIvNjJG+E9ClS4cWi522Ln+3YAG4D3PcNKglhp/Nk3txTa1BeuvQ9u430HufSLLQo/LAUOMGJVPfcgoRiYUOAAxbgy3oSBsCAsNr9sQB20akV1phIP/MHGufpa6JwWnPxcuwyRViWEowSrSG/VSYUYWUwJTs5Ga9kE+ROTBZOg1YGtTBXN8HEvlMwd8lljmbVJeJQhwh6WdXb5+B/YYK2SS9+hKUmbTxbh7NoY46Oyl+/Of+rBp7qHxCE8dn+jN2kC1SNGkIQeXA7RhABP+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvGlvzWb3yzEdsp4OMqjzwOT9gGOQOtoiETQOyMKzSo=;
 b=TngIypIERZmD+8eyv4WxAveNHZanPO7XDa88Dil7zOny/7jwAKxTTZvtAQ784ddfBas4cy9WCl0g5szXjtV+gIH5CKJ7uXHa1V6L+RWXnvt54c5gXrNunOWbzAhRCoJNCbtwFc/rA/1Vq+7TJcX/WFO7QDJ4IGsnnzNYyXF3GFRhxazrsW+8xJgwZqUjbcev1JF+H0cUuQZPItDtvJVZ8gSftraiK5yKdERfH/4tErnVBfX/Hw+i9QWc7kuRxV37lKQb24s1WXeAigWZytBxqyCUXRLVA743CTBA5llxJdSNuWAH3utxHaHeleCwW5owoRhsYO/3P8gOLdW0m5b4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvGlvzWb3yzEdsp4OMqjzwOT9gGOQOtoiETQOyMKzSo=;
 b=G/GXKon10qoCll/WdOvS+9aXpoyiXFVx1waaY0gH69lHi1Haq9SWhgHrfSYsYGTlBAKLkSPrG/Ye67NB0iWqItG3oQONc9GVhXt49Z06TpykV/nO0m5Oy3Cr7OIguRuZEq+CE8k0H05eCPGiHs9rgxDk4XEsTkAJ20PpGEWsZF4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 11:57:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 11:57:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/3] net: mscc: ocelot: offload VLAN mangle action to VCAP IS1
Date:   Thu,  8 Oct 2020 14:56:58 +0300
Message-Id: <20201008115700.255648-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201008115700.255648-1-vladimir.oltean@nxp.com>
References: <20201008115700.255648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Thu, 8 Oct 2020 11:57:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d03e92b8-f7a6-4d4e-ae72-08d86b814ab4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709C6539A864D953625BBE1E00B0@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6k03Z1MYXCvAX/SbtT4m2s1kvshEYTq0aNjVOS3sHC92er6zrwpNf2+z7goYGGeqDpR3144gUs77YhGMaks8qZaeZPGYoU9fprDN+t4uLzT5NkzJgWUHdKmDtXu4dvraD9Vhg+HBRbaam+jbFlz4ugpjODOVGdfggwXWtCdepWWgmnu8VwgbmRZmemiUA60a5rPj3FBVOAANQpUDWyADmM8IkG3CyI/6fYgjGzSaN5txYx86VeHhxzTGBmUNn5ZtwYlP9KRpeCIdK+cJJTERK//1wDQ8YDhk2/OuaUbpSDICCiIdbInSsyK4N6IbcmtbY9H+ZZe5Gq70uZV1sBFqt7/QWc7YTLVjjrAHzbzB9izGxhZP+U2OGzAsk2PvdmD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(4326008)(6916009)(66946007)(6486002)(8936002)(83380400001)(86362001)(26005)(36756003)(6506007)(16526019)(2906002)(478600001)(44832011)(66476007)(186003)(66556008)(8676002)(6666004)(956004)(1076003)(52116002)(5660300002)(316002)(69590400008)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7SwPO4g0m2X6dGoPFpwXikAyK2yQ0sDCIp0rQXcP2C12whdu0CDkzf+4aZdioTZ9xcg7gKpBZz1vRAam8Tyiq8a8YB9KbuhLUccHUSVlNVMqTfwFrBHTAtUbx0eZOn0yd4BaoItU4xGbgQPIvq4ce6hXOPvQkAtDRCyup1vM4QoNp4mzZzm4Oe1G7BKZtuyRIPR2HTNvXtR5cMrn59f0BeV9eSkLTLAjAn/+U4NYav8A8R8LAys2bB5bwSpPcwb/TnGZVPIieIqMHb77cZ+1G+NtV4Dt8MXX8hssdpUo0URB+eVy9jCXt2n244cjf5xIxmwS1Whd68p4vBQiiqKn+MHNYyAq8QVn2urV4FST32vTyHRQi1tnVd58ATTVsbe1EBlDC2VhGBxwoY5IcPw28lGcNYyxxVZfgtfZTzcTuw8vFZJoVhmHTuBFSLr4VtiuuOnzgjdjOc6XjAvWYL+yUC2ekGaYCnltApCcKRGlflSypPi26CBansXy0ROBRsXgHAgGwntEcckUnRhEZM45bwT8TZ17bSqxhsA5rz0TCSQnDhtFN/p0dMD8XDZp0jZqbuUikRbUTcVNaVEd2QICk0Zgm9huENCu5LetUD3o2sKgGonkNQ/vK5e1fYYjzBt4K8lRoOn/ZhwPGelSjZJwow==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d03e92b8-f7a6-4d4e-ae72-08d86b814ab4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 11:57:12.3602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bXMEyKaKZROyqlKLJWNILts3QagEjQzqQiWDSB9UUOAtrphF65QplJmF3fQKH704dg40rtTmfrGj8PG79YfzqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VCAP_IS1_ACT_VID_REPLACE_ENA action, from the VCAP IS1 ingress TCAM,
changes the classified VLAN.

We are only exposing this ability for switch ports that are under VLAN
aware bridges. This is because in standalone ports mode and under a
bridge with vlan_filtering=0, the ocelot driver configures the switch to
operate as VLAN-unaware, so the classified VLAN is not derived from the
802.1Q header from the packet, but instead is always equal to the
port-based VLAN ID of the ingress port. We _can_ still change the
classified VLAN for packets when operating in this mode, but the end
result will most likely be a drop, since both the ingress and the egress
port need to be members of the modified VLAN. And even if we install the
new classified VLAN into the VLAN table of the switch, the result would
still not be as expected: we wouldn't see, on the output port, the
modified VLAN tag, but the original one, even though the classified VLAN
was indeed modified. This is because of how the hardware works: on
egress, what is pushed to the frame is a "port tag", which gives us the
following options:

- Tag all frames with port tag (derived from the classified VLAN)
- Tag all frames with port tag, except if the classified VLAN is 0 or
  equal to the native VLAN of the egress port
- No port tag

Needless to say, in VLAN-unaware mode we are disabling the port tag.
Otherwise, the existing VLAN tag would be ignored, and a second VLAN
tag (the port tag), holding the classified VLAN, would be pushed
(instead of replacing the existing 802.1Q tag). This is definitely not
what the user wanted when installing a "vlan modify" action.

So it is simply not worth bothering with VLAN modify rules under other
configurations except when the ports are fully VLAN-aware.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        | 15 +++++++++++-
 drivers/net/ethernet/mscc/ocelot_flower.c | 29 ++++++++++++++++++++---
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a965a554ff8b..3c4aa6a0c397 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -205,8 +205,21 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val;
 
-	if (switchdev_trans_ph_prepare(trans))
+	if (switchdev_trans_ph_prepare(trans)) {
+		struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
+		struct ocelot_vcap_filter *filter;
+
+		list_for_each_entry(filter, &block->rules, list) {
+			if (filter->ingress_port_mask & BIT(port) &&
+			    filter->action.vid_replace_ena) {
+				dev_err(ocelot->dev,
+					"Cannot change VLAN state with vlan modify rules active\n");
+				return -EBUSY;
+			}
+		}
+
 		return 0;
+	}
 
 	ocelot_port->vlan_aware = vlan_aware;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 0ea6d4f411cb..729495a1a77e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -142,10 +142,11 @@ ocelot_find_vcap_filter_that_points_at(struct ocelot *ocelot, int chain)
 	return NULL;
 }
 
-static int ocelot_flower_parse_action(struct ocelot *ocelot, bool ingress,
-				      struct flow_cls_offload *f,
+static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
+				      bool ingress, struct flow_cls_offload *f,
 				      struct ocelot_vcap_filter *filter)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
@@ -266,6 +267,28 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, bool ingress,
 			}
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_VLAN_MANGLE:
+			if (filter->block_id != VCAP_IS1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN modify action can only be offloaded to VCAP IS1");
+				return -EOPNOTSUPP;
+			}
+			if (filter->goto_target != -1) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Last action must be GOTO");
+				return -EOPNOTSUPP;
+			}
+			if (!ocelot_port->vlan_aware) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Can only modify VLAN under VLAN aware bridge");
+				return -EOPNOTSUPP;
+			}
+			filter->action.vid_replace_ena = true;
+			filter->action.pcp_dei_ena = true;
+			filter->action.vid = a->vlan.vid;
+			filter->action.pcp = a->vlan.prio;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		case FLOW_ACTION_PRIORITY:
 			if (filter->block_id != VCAP_IS1) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -601,7 +624,7 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
 
-	ret = ocelot_flower_parse_action(ocelot, ingress, f, filter);
+	ret = ocelot_flower_parse_action(ocelot, port, ingress, f, filter);
 	if (ret)
 		return ret;
 
-- 
2.25.1

