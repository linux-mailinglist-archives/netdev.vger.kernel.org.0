Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3D2811F2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgJBMDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:31 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387823AbgJBMDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUWYNdv5+yyxFxBZYRK68bLnp+CBeAfb+sic60C/0JCSQ6Gjk2qoi9TcaJ3+zed+/W5WVxFEp/4KWqi84Mzb4azRbitO/T2MKQ94bCtXUXOSd8v95aKMbZArVFtDdFWz5JoVtdm8zfJ1tVZfiUYK/F40IWKZldE6nqRC2kVPo8BqqsH5l/wQlkvBdAvlN9ykgRIUTUH3v6w3236BIMHiQt8v3okMCaN6EfhmZR3vne8EeRmOkRDX55SJT0deoKIEEiSc3vec5gc8OMNJzyEBXUKj1RvP2tm90IUw5NnqD43buZJgDKEUDgBJRE8LE4XutSnOJD8X887HVJ3e4uzAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYCZfvtTDZcqisH/w0urxVw99yCwxfSuwaz7ltGNL4Y=;
 b=CJ94PPiX280isRuXb9EiA3Z1wUcsQujgp86kOpSzs095YaO3TCK0koKOWQ84O+14cdwSKMMfMvcb3JOITZyNADilh2/XatMpvNp0x4fqpQgnXi9QLzTzzfDfDCMHfqtm3NsXttEDBX+/CyXfHGTLQwCyUNjxK1iynSSipyUwre6gQlyQf5c/YClj5E1e8cU6sq8UQxr+QXV/EwEh0ZNBCWtgl6dxf6+nV7zWzpgouXrqfV1RgTIs57d1MQIxBPWj7UjKpHpKS5clanGLEWKx7lOFuDb7cTYyNUJceaqCHbe5UrnGUvXJKM4ds2easRIvuzQunha4Ees9IjCxnSB7Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYCZfvtTDZcqisH/w0urxVw99yCwxfSuwaz7ltGNL4Y=;
 b=WZOBVWqMspcxLtPdp33dTrwDH0eNX1QOnPz/LJmSY3uo3jMtlbxHrkaZ2/IFB8ZE6dRqXoezwHN5ofBtaPH4ZEGi33sa6RyE+D+bpLTvUkDY5Hf1O9rgHdGedmnS6lakkpe+LSKJ+uNwTjOM+HYvGiOrdSIwzX0y+diKPL6JmQc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 5/9] net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0
Date:   Fri,  2 Oct 2020 15:02:24 +0300
Message-Id: <20201002120228.3451337-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41dc742e-15c4-4c07-b0ae-08d866cb1f68
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42228FD075A075AED63B6053E0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ArU3OnYkiZ+pH2MFnlHYukdimQtqa7kRTX9qcwQ/+nfLFCDLsSLNtRuCGQRK/afNPmYd1Acae5Z0VNIbFEpLAL3KWzArmFp2h9rDIukjog0OAt2yKCoeUsWnmLMh4c4P2a65FiJOHDc/c+W2ddX5Z76DkJPT8cW9qdBKvMvoiLbbC3QuwZ6Kbci7Vmutth7tsN3mVotvajd6Zx+WKmY4LIOyHZM+nIKsHDlDa9poO0EzhXS+c5K9brUR8VkPyZl+SB0rpgdSPv8/IMKK5nc6D622ItFrv70O+scA5504AOLShwyq5YFr4BMth1Q4gZ9GysBmniuHy4+nKrfH7nNnZaNvzJTN3/RLggHrsxNvKqKulKXjDHWfp99gHmTAurNrw/0sCrdxJSqvOu2H7neE3+6mqZ/C3gzIOOEU1QPLr+sEcMA2Oj+AJVBcoHQvFk+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(30864003)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /FrzD4BxvP2jQhHpEkR8AyQVHOu3Xdhx920J2WbPnXSggemwYseBbiMZewhuicmSuVFC6EmN92AiE3WsDTvLLMiUbSyHmm/pl+aVMSWJ7y+/RGxyJKsdLWLRtN5Jos+UeUo3CCbuydQnz+XoUiJYBgyzs3nVfJhgmH9awW9xmzFkcvSRZ3I91hDPQXI0ogYQfGk4aGRCm6o2bdmyC7tCzJBTVPnwCz0nl/59r5mns5bS28ldoxQoJfwU/6CAMfKyGU8/jFLGK/ZLBg5QK42xxuXEulNyuJBVR15dz//SXQcE+hb11YRv0AnOV8vCTeK7fil4mfTY9bC1wnkC58zB/oMan+EK+if2WpbXEbnAYxGm2VnuTncL0KPWQa7teIP7DLBF6pb6UeylUsi72usE/U3Ni309yTJ+mEc5T9RK2d/lD9pK/srpsgsw4tu0lNflAAMIPlFBMs1FhJA5PH1UASQv5DX+5lkXyxH+aBx8321jrLY3EtOWOinKCjxagH2qitm7kUlGi2tHKr3KqAWjkLKioCn/DwxOHCt5TN8eXoxyHTHXI2ZVdhdG3pGxdvAUQ2UiBVY+lIDKVsbyryN0W5uwLGwzH0rXplQIIR6m3uXcWNGzR5QNqfrqnonU/ns1XrVUWaFB63YvCyxkZO0SLQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41dc742e-15c4-4c07-b0ae-08d866cb1f68
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:06.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sz+QhrRwvH13K4rnTd2kE+3yeVei1PNBSpwzSF9Q8hXPK5aoLZ2TJQAAtnjTTawSp9SBmviTXn8t+ocHOe9rgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

VCAP ES0 is an egress VCAP operating on all outgoing frames.
This patch added ES0 driver to support vlan push action of tc filter.
Usage:

tc filter add dev swp1 egress protocol 802.1Q flower indev swp0 skip_sw \
        vlan_id 1 vlan_prio 1 action vlan push id 2 priority 2

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
Fixed filter->ingress_port.value.

 drivers/net/ethernet/mscc/ocelot.c        |   4 +
 drivers/net/ethernet/mscc/ocelot_flower.c | 152 ++++++++++++++++++++--
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  81 +++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  39 ++++++
 4 files changed, 266 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ba47359c26c7..e026617d6133 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -111,6 +111,10 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_CFG_S1_ENA,
 			 ANA_PORT_VCAP_CFG, port);
+
+	ocelot_rmw_gix(ocelot, REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b8a588e65929..feeaf016f8ca 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -148,6 +148,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
+	enum ocelot_tag_tpid_sel tpid;
 	int i, chain;
 	u64 rate;
 
@@ -267,6 +268,31 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 				filter->type = OCELOT_VCAP_FILTER_PAG;
 			}
 			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			if (filter->block_id != VCAP_ES0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN push action can only be offloaded to VCAP ES0");
+				return -EOPNOTSUPP;
+			}
+			switch (ntohs(a->vlan.proto)) {
+			case ETH_P_8021Q:
+				tpid = OCELOT_TAG_TPID_SEL_8021Q;
+				break;
+			case ETH_P_8021AD:
+				tpid = OCELOT_TAG_TPID_SEL_8021AD;
+				break;
+			default:
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Cannot push custom TPID");
+				return -EOPNOTSUPP;
+			}
+			filter->action.tag_a_tpid_sel = tpid;
+			filter->action.push_outer_tag = OCELOT_ES0_TAG;
+			filter->action.tag_a_vid_sel = 1;
+			filter->action.vid_a_val = a->vlan.vid;
+			filter->action.pcp_a_val = a->vlan.prio;
+			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
 			return -EOPNOTSUPP;
@@ -292,18 +318,73 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	return 0;
 }
 
-static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
-				   struct ocelot_vcap_filter *filter)
+static int ocelot_flower_parse_indev(struct ocelot *ocelot, int port,
+				     struct flow_cls_offload *f,
+				     struct ocelot_vcap_filter *filter)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	int key_length = vcap->keys[VCAP_ES0_IGR_PORT].length;
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct net_device *dev, *indev;
+	struct flow_match_meta match;
+	int ingress_port;
+
+	flow_rule_match_meta(rule, &match);
+
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
+	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
+		return -EOPNOTSUPP;
+	}
+
+	dev = ocelot->ops->port_to_netdev(ocelot, port);
+	if (!dev)
+		return -EINVAL;
+
+	indev = __dev_get_by_index(dev_net(dev), match.key->ingress_ifindex);
+	if (!indev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't find the ingress port to match on");
+		return -ENOENT;
+	}
+
+	ingress_port = ocelot->ops->netdev_to_port(indev);
+	if (ingress_port < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload an ocelot ingress port");
+		return -EOPNOTSUPP;
+	}
+	if (ingress_port == port) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Ingress port is equal to the egress port");
+		return -EINVAL;
+	}
+
+	filter->ingress_port.value = ingress_port;
+	filter->ingress_port.mask = GENMASK(key_length - 1, 0);
+
+	return 0;
+}
+
+static int
+ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
+			struct flow_cls_offload *f,
+			struct ocelot_vcap_filter *filter)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct netlink_ext_ack *extack = f->common.extack;
 	u16 proto = ntohs(f->common.protocol);
 	bool match_protocol = true;
+	int ret;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_META) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
@@ -312,6 +393,13 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 		return -EOPNOTSUPP;
 	}
 
+	/* For VCAP ES0 (egress rewriter) we can match on the ingress port */
+	if (!ingress) {
+		ret = ocelot_flower_parse_indev(ocelot, port, f, filter);
+		if (ret)
+			return ret;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control match;
 
@@ -321,6 +409,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
+		if (filter->block_id == VCAP_ES0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VCAP ES0 cannot match on MAC address");
+			return -EOPNOTSUPP;
+		}
+
 		if (filter->block_id == VCAP_IS1 &&
 		    !is_zero_ether_addr(match.mask->dst)) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -359,6 +453,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 
 		flow_rule_match_basic(rule, &match);
 		if (ntohs(match.key->n_proto) == ETH_P_IP) {
+			if (filter->block_id == VCAP_ES0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VCAP ES0 cannot match on IP protocol");
+				return -EOPNOTSUPP;
+			}
+
 			filter->key_type = OCELOT_VCAP_KEY_IPV4;
 			filter->key.ipv4.proto.value[0] =
 				match.key->ip_proto;
@@ -367,6 +467,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 			match_protocol = false;
 		}
 		if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
+			if (filter->block_id == VCAP_ES0) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VCAP ES0 cannot match on IP protocol");
+				return -EOPNOTSUPP;
+			}
+
 			filter->key_type = OCELOT_VCAP_KEY_IPV6;
 			filter->key.ipv6.proto.value[0] =
 				match.key->ip_proto;
@@ -381,6 +487,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 		struct flow_match_ipv4_addrs match;
 		u8 *tmp;
 
+		if (filter->block_id == VCAP_ES0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VCAP ES0 cannot match on IP address");
+			return -EOPNOTSUPP;
+		}
+
 		if (filter->block_id == VCAP_IS1 && *(u32 *)&match.mask->dst) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Key type S1_NORMAL cannot match on destination IP");
@@ -410,6 +522,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
+		if (filter->block_id == VCAP_ES0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VCAP ES0 cannot match on L4 ports");
+			return -EOPNOTSUPP;
+		}
+
 		flow_rule_match_ports(rule, &match);
 		filter->key.ipv4.sport.value = ntohs(match.key->src);
 		filter->key.ipv4.sport.mask = ntohs(match.mask->src);
@@ -432,6 +550,12 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 
 finished_key_parsing:
 	if (match_protocol && proto != ETH_P_ALL) {
+		if (filter->block_id == VCAP_ES0) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VCAP ES0 cannot match on L2 proto");
+			return -EOPNOTSUPP;
+		}
+
 		/* TODO: support SNAP, LLC etc */
 		if (proto < ETH_P_802_3_MIN)
 			return -EOPNOTSUPP;
@@ -444,7 +568,8 @@ static int ocelot_flower_parse_key(struct flow_cls_offload *f, bool ingress,
 	return 0;
 }
 
-static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
+static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
+			       struct flow_cls_offload *f,
 			       struct ocelot_vcap_filter *filter)
 {
 	int ret;
@@ -456,12 +581,12 @@ static int ocelot_flower_parse(struct flow_cls_offload *f, bool ingress,
 	if (ret)
 		return ret;
 
-	return ocelot_flower_parse_key(f, ingress, filter);
+	return ocelot_flower_parse_key(ocelot, port, ingress, f, filter);
 }
 
 static struct ocelot_vcap_filter
-*ocelot_vcap_filter_create(struct ocelot *ocelot, int port,
-			 struct flow_cls_offload *f)
+*ocelot_vcap_filter_create(struct ocelot *ocelot, int port, bool ingress,
+			   struct flow_cls_offload *f)
 {
 	struct ocelot_vcap_filter *filter;
 
@@ -469,7 +594,16 @@ static struct ocelot_vcap_filter
 	if (!filter)
 		return NULL;
 
-	filter->ingress_port_mask = BIT(port);
+	if (ingress) {
+		filter->ingress_port_mask = BIT(port);
+	} else {
+		const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+		int key_length = vcap->keys[VCAP_ES0_EGR_PORT].length;
+
+		filter->egress_port.value = port;
+		filter->egress_port.mask = GENMASK(key_length - 1, 0);
+	}
+
 	return filter;
 }
 
@@ -503,11 +637,11 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		return -EOPNOTSUPP;
 	}
 
-	filter = ocelot_vcap_filter_create(ocelot, port, f);
+	filter = ocelot_vcap_filter_create(ocelot, port, ingress, f);
 	if (!filter)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, ingress, filter);
+	ret = ocelot_flower_parse(ocelot, port, ingress, f, filter);
 	if (ret) {
 		kfree(filter);
 		return ret;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index be3293e7c892..d0e5c5bbdbf8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -774,6 +774,79 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void es0_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   const struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	const struct ocelot_vcap_action *a = &filter->action;
+
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_OUTER_TAG,
+			a->push_outer_tag);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_INNER_TAG,
+			a->push_inner_tag);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_TPID_SEL,
+			a->tag_a_tpid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_VID_SEL,
+			a->tag_a_vid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_PCP_SEL,
+			a->tag_a_pcp_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_VID_A_VAL, a->vid_a_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PCP_A_VAL, a->pcp_a_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_B_TPID_SEL,
+			a->tag_b_tpid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_B_VID_SEL,
+			a->tag_b_vid_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_B_PCP_SEL,
+			a->tag_b_pcp_sel);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_VID_B_VAL, a->vid_b_val);
+	vcap_action_set(vcap, data, VCAP_ES0_ACT_PCP_B_VAL, a->pcp_b_val);
+}
+
+static void es0_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_vcap_filter *filter)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	struct ocelot_vcap_key_vlan *tag = &filter->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	int row = ix;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_FULL;
+	data.type = ES0_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (filter->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_ES0_IGR_PORT, filter->ingress_port.value,
+		     filter->ingress_port.mask);
+	vcap_key_set(vcap, &data, VCAP_ES0_EGR_PORT, filter->egress_port.value,
+		     filter->egress_port.mask);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_MC, filter->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_BC, filter->dmac_bc);
+	vcap_key_set(vcap, &data, VCAP_ES0_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_ES0_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+
+	es0_action_set(ocelot, &data, filter);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, filter->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, int ix,
 			   struct ocelot_vcap_filter *filter)
 {
@@ -782,7 +855,11 @@ static void vcap_entry_get(struct ocelot *ocelot, int ix,
 	int row, count;
 	u32 cnt;
 
-	data.tg_sw = VCAP_TG_HALF;
+	if (filter->block_id == VCAP_ES0)
+		data.tg_sw = VCAP_TG_FULL;
+	else
+		data.tg_sw = VCAP_TG_HALF;
+
 	count = (1 << (data.tg_sw - 1));
 	row = (ix / count);
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
@@ -801,6 +878,8 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
 		return is1_entry_set(ocelot, ix, filter);
 	if (filter->block_id == VCAP_IS2)
 		return is2_entry_set(ocelot, ix, filter);
+	if (filter->block_id == VCAP_ES0)
+		return es0_entry_set(ocelot, ix, filter);
 }
 
 static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index a71bb4447648..82fd10581a14 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -78,6 +78,11 @@ struct ocelot_vcap_udp_tcp {
 	u16 mask;
 };
 
+struct ocelot_vcap_port {
+	u8 value;
+	u8 mask;
+};
+
 enum ocelot_vcap_key_type {
 	OCELOT_VCAP_KEY_ANY,
 	OCELOT_VCAP_KEY_ETYPE,
@@ -184,8 +189,38 @@ enum ocelot_mask_mode {
 	OCELOT_MASK_MODE_REDIRECT,
 };
 
+enum ocelot_es0_tag {
+	OCELOT_NO_ES0_TAG,
+	OCELOT_ES0_TAG,
+	OCELOT_FORCE_PORT_TAG,
+	OCELOT_FORCE_UNTAG,
+};
+
+enum ocelot_tag_tpid_sel {
+	OCELOT_TAG_TPID_SEL_8021Q,
+	OCELOT_TAG_TPID_SEL_8021AD,
+};
+
 struct ocelot_vcap_action {
 	union {
+		/* VCAP ES0 */
+		struct {
+			enum ocelot_es0_tag push_outer_tag;
+			enum ocelot_es0_tag push_inner_tag;
+			enum ocelot_tag_tpid_sel tag_a_tpid_sel;
+			int tag_a_vid_sel;
+			int tag_a_pcp_sel;
+			u16 vid_a_val;
+			u8 pcp_a_val;
+			u8 dei_a_val;
+			enum ocelot_tag_tpid_sel tag_b_tpid_sel;
+			int tag_b_vid_sel;
+			int tag_b_pcp_sel;
+			u16 vid_b_val;
+			u8 pcp_b_val;
+			u8 dei_b_val;
+		};
+
 		/* VCAP IS1 */
 		struct {
 			bool vid_replace_ena;
@@ -239,7 +274,11 @@ struct ocelot_vcap_filter {
 
 	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
+	/* For VCAP IS1 and IS2 */
 	unsigned long ingress_port_mask;
+	/* For VCAP ES0 */
+	struct ocelot_vcap_port ingress_port;
+	struct ocelot_vcap_port egress_port;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
-- 
2.25.1

