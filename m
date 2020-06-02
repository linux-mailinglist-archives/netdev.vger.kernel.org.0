Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3251EB525
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgFBFYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44542 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgFBFYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:13 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D57B1A0B71;
        Tue,  2 Jun 2020 07:24:08 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B5771A0A5A;
        Tue,  2 Jun 2020 07:23:58 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 9F9DC4031F;
        Tue,  2 Jun 2020 13:23:46 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 05/10] net: mscc: ocelot: VCAP IS1 support
Date:   Tue,  2 Jun 2020 13:18:23 +0800
Message-Id: <20200602051828.5734-6-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VCAP IS1 is a VCAP module which can filter MAC, IP, VLAN, protocol, and
TCP/UDP ports keys, and do Qos classified and VLAN retag actions.

This patch added VCAP IS1 support in ocelot ace driver, which can supports
vlan modify and skbedit priority action of tc filter.
Usage:
	tc qdisc add dev swp0 ingress
	tc filter add dev swp0 protocol 802.1Q parent ffff: flower \
	skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 102 +++++++++++
 drivers/net/ethernet/mscc/ocelot.c        |   7 +
 drivers/net/ethernet/mscc/ocelot_ace.c    | 198 +++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_ace.h    |  11 ++
 drivers/net/ethernet/mscc/ocelot_flower.c |  11 ++
 drivers/net/ethernet/mscc/ocelot_regs.c   |   1 +
 include/soc/mscc/ocelot.h                 |   1 +
 include/soc/mscc/ocelot_vcap.h            |  91 ++++++++++
 8 files changed, 421 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ef3bf875e64c..f08a5f1c61a5 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -16,6 +16,8 @@
 #define VSC9959_VCAP_IS2_CNT		1024
 #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
 #define VSC9959_VCAP_PORT_CNT		6
+#define VSC9959_VCAP_IS1_CNT		256
+#define VSC9959_VCAP_IS1_ENTRY_WIDTH	376
 
 /* TODO: should find a better place for these */
 #define USXGMII_BMCR_RESET		BIT(15)
@@ -337,6 +339,7 @@ static const u32 *vsc9959_regmap[] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
 	[GCB]	= vsc9959_gcb_regmap,
@@ -369,6 +372,11 @@ static const struct resource vsc9959_target_io_res[] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S1] = {
+		.start	= 0x0050000,
+		.end	= 0x00503ff,
+		.name	= "s1",
+	},
 	[S2] = {
 		.start	= 0x0060000,
 		.end	= 0x00603ff,
@@ -559,6 +567,80 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+struct vcap_field vsc9959_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= {  0,   1},
+	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= {  3,   7},
+	[VCAP_IS1_HK_RSV]			= { 10,   9},
+	[VCAP_IS1_HK_OAM_Y1731]			= { 19,   1},
+	[VCAP_IS1_HK_L2_MC]			= { 20,   1},
+	[VCAP_IS1_HK_L2_BC]			= { 21,   1},
+	[VCAP_IS1_HK_IP_MC]			= { 22,   1},
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 23,   1},
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 24,   1},
+	[VCAP_IS1_HK_TPID]			= { 25,   1},
+	[VCAP_IS1_HK_VID]			= { 26,  12},
+	[VCAP_IS1_HK_DEI]			= { 38,   1},
+	[VCAP_IS1_HK_PCP]			= { 39,   3},
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 42,  48},
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 90,   1},
+	[VCAP_IS1_HK_ETYPE]			= { 91,  16},
+	[VCAP_IS1_HK_IP_SNAP]			= {107,   1},
+	[VCAP_IS1_HK_IP4]			= {108,   1},
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= {109,   1},
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= {110,   1},
+	[VCAP_IS1_HK_L3_OPTIONS]		= {111,   1},
+	[VCAP_IS1_HK_L3_DSCP]			= {112,   6},
+	[VCAP_IS1_HK_L3_IP4_SIP]		= {118,  32},
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= {150,   1},
+	[VCAP_IS1_HK_TCP]			= {151,   1},
+	[VCAP_IS1_HK_L4_SPORT]			= {152,  16},
+	[VCAP_IS1_HK_L4_RNG]			= {168,   8},
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 42,   1},
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 43,  12},
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 55,   1},
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 56,   3},
+	[VCAP_IS1_HK_IP4_IP4]			= { 59,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 60,   1},
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 61,   1},
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 62,   1},
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 63,   6},
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 69,  32},
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= {101,  32},
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= {133,   8},
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= {141,   1},
+	[VCAP_IS1_HK_IP4_TCP]			= {142,   1},
+	[VCAP_IS1_HK_IP4_L4_RNG]		= {143,   8},
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= {151,  32},
+};
+
+struct vcap_field vsc9959_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= {  0,  1},
+	[VCAP_IS1_ACT_DSCP_VAL]			= {  1,  6},
+	[VCAP_IS1_ACT_QOS_ENA]			= {  7,  1},
+	[VCAP_IS1_ACT_QOS_VAL]			= {  8,  3},
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1},
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1},
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
+	[VCAP_IS1_ACT_RSV]			= { 29,  9},
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1},
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12},
+	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2},
+	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13},
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1},
+	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3},
+	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1},
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2},
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4},
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1},
+};
+
 struct vcap_field vsc9959_vcap_is2_keys[] = {
 	/* Common: 41 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
@@ -658,6 +740,26 @@ struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_IS1] = {
+		.tg_width = 2,
+		.sw_count = 4,
+		.entry_count = VSC9959_VCAP_IS1_CNT,
+		.entry_width = VSC9959_VCAP_IS1_ENTRY_WIDTH,
+		.action_count = VSC9959_VCAP_IS1_CNT + 1,
+		.action_width = 312,
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78,
+				.count = 4
+			},
+		},
+		.counter_words = 1,
+		.counter_width = 4,
+		.target = S1,
+		.keys = vsc9959_vcap_is1_keys,
+		.actions = vsc9959_vcap_is1_actions,
+	},
 	[VCAP_IS2] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9cfe1fd98c30..533e907af0e9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -136,6 +136,13 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 	ocelot_write_gix(ocelot, ANA_PORT_VCAP_S2_CFG_S2_ENA |
 			 ANA_PORT_VCAP_S2_CFG_S2_IP6_CFG(0xa),
 			 ANA_PORT_VCAP_S2_CFG, port);
+
+	ocelot_write_gix(ocelot, ANA_PORT_VCAP_CFG_S1_ENA,
+			 ANA_PORT_VCAP_CFG, port);
+	ocelot_write_gix(ocelot,
+			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP6_CFG(2) |
+			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP4_CFG(2),
+			 ANA_PORT_VCAP_S1_KEY_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 8c384b0771bb..bf21e4c5a9db 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -645,6 +645,197 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   struct ocelot_ace_rule *ace)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+
+	switch (ace->action) {
+	case OCELOT_ACL_ACTION_VLAN_MODIFY:
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_ADD_VAL,
+				ace->vlan_modify.vid);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_DEI_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_VAL,
+				ace->vlan_modify.pcp);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_DEI_VAL,
+				ace->vlan_modify.dei);
+		break;
+	case OCELOT_ACL_ACTION_PRIORITY:
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_VAL,
+				ace->qos_val);
+		break;
+	default:
+		break;
+	}
+}
+
+static void is1_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_ace_rule *ace)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
+	u32 val, msk, type, i;
+	struct ocelot_ace_vlan *tag = &ace->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	int row = ix / 2;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_HALF;
+	data.type = IS1_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (ace->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
+		     ~ace->ingress_port_mask);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, ace->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_BC, ace->dmac_bc);
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_VLAN_TAGGED, tag->tagged);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+	type = IS1_TYPE_S1_NORMAL;
+
+	switch (ace->type) {
+	case OCELOT_ACE_TYPE_ETYPE: {
+		struct ocelot_ace_frame_etype *etype = &ace->frame.etype;
+
+		type = IS1_TYPE_S1_NORMAL;
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_L2_SMAC,
+				   etype->smac.value, etype->smac.mask);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
+				   etype->etype.value, etype->etype.mask);
+		break;
+	}
+	case OCELOT_ACE_TYPE_IPV4:
+	case OCELOT_ACE_TYPE_IPV6: {
+		enum ocelot_vcap_bit sip_eq_dip, sport_eq_dport;
+		enum ocelot_vcap_bit seq_zero, tcp;
+		enum ocelot_vcap_bit ttl, fragment, options;
+		enum ocelot_vcap_bit tcp_ack, tcp_urg;
+		enum ocelot_vcap_bit tcp_fin, tcp_syn, tcp_rst, tcp_psh;
+		struct ocelot_ace_frame_ipv4 *ipv4 = NULL;
+		struct ocelot_ace_frame_ipv6 *ipv6 = NULL;
+		struct ocelot_vcap_udp_tcp *sport, *dport;
+		struct ocelot_vcap_ipv4 sip, dip;
+		struct ocelot_vcap_u8 proto, ds;
+		struct ocelot_vcap_u48 *ip_data;
+		struct ocelot_vcap_u32 port;
+
+		type = IS1_TYPE_S1_5TUPLE_IP4;
+		if (ace->type == OCELOT_ACE_TYPE_IPV4) {
+			ipv4 = &ace->frame.ipv4;
+			ttl = ipv4->ttl;
+			fragment = ipv4->fragment;
+			options = ipv4->options;
+			proto = ipv4->proto;
+			ds = ipv4->ds;
+			ip_data = &ipv4->data;
+			sip = ipv4->sip;
+			dip = ipv4->dip;
+			sport = &ipv4->sport;
+			dport = &ipv4->dport;
+			tcp_fin = ipv4->tcp_fin;
+			tcp_syn = ipv4->tcp_syn;
+			tcp_rst = ipv4->tcp_rst;
+			tcp_psh = ipv4->tcp_psh;
+			tcp_ack = ipv4->tcp_ack;
+			tcp_urg = ipv4->tcp_urg;
+			sip_eq_dip = ipv4->sip_eq_dip;
+			sport_eq_dport = ipv4->sport_eq_dport;
+			seq_zero = ipv4->seq_zero;
+		} else {
+			ipv6 = &ace->frame.ipv6;
+			ttl = ipv6->ttl;
+			fragment = OCELOT_VCAP_BIT_ANY;
+			options = OCELOT_VCAP_BIT_ANY;
+			proto = ipv6->proto;
+			ds = ipv6->ds;
+			ip_data = &ipv6->data;
+			for (i = 0; i < 4; i++) {
+				dip.value.addr[i] = ipv6->dip.value[i];
+				dip.mask.addr[i] = ipv6->dip.mask[i];
+				sip.value.addr[i] = ipv6->sip.value[i];
+				sip.mask.addr[i] = ipv6->sip.mask[i];
+			}
+			sport = &ipv6->sport;
+			dport = &ipv6->dport;
+			tcp_fin = ipv6->tcp_fin;
+			tcp_syn = ipv6->tcp_syn;
+			tcp_rst = ipv6->tcp_rst;
+			tcp_psh = ipv6->tcp_psh;
+			tcp_ack = ipv6->tcp_ack;
+			tcp_urg = ipv6->tcp_urg;
+			sip_eq_dip = ipv6->sip_eq_dip;
+			sport_eq_dport = ipv6->sport_eq_dport;
+			seq_zero = ipv6->seq_zero;
+		}
+
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_IP4,
+				 ipv4 ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_L3_FRAGMENT,
+				 fragment);
+		vcap_key_set(vcap, &data, VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0,
+			     0, 0);
+		vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_L3_OPTIONS,
+				 options);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_IP4_L3_IP4_DIP,
+				   dip.value.addr, dip.mask.addr);
+		vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_IP4_L3_IP4_SIP,
+				   sip.value.addr, sip.mask.addr);
+		val = proto.value[0];
+		msk = proto.mask[0];
+		if (msk == 0xff && (val == 6 || val == 17)) {
+			/* UDP/TCP protocol match */
+			tcp = (val == 6 ?
+			       OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+			vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_IP4_TCP,
+					 tcp);
+			vcap_key_l4_port_set(vcap, &data,
+					     VCAP_IS1_HK_L4_SPORT, sport);
+			vcap_key_set(vcap, &data, VCAP_IS1_HK_IP4_L4_RNG,
+				     0, 0);
+			port.value[0] = sport->value & 0xFF;
+			port.value[1] = sport->value >> 8;
+			port.value[2] = dport->value & 0xFF;
+			port.value[3] = dport->value >> 8;
+			port.mask[0] = sport->mask & 0xFF;
+			port.mask[1] = sport->mask >> 8;
+			port.mask[2] = dport->mask & 0xFF;
+			port.mask[3] = dport->mask >> 8;
+			vcap_key_bytes_set(vcap, &data,
+					   VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE,
+					   port.value, port.mask);
+		}
+		break;
+	}
+	default:
+		break;
+	}
+	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_TYPE,
+			 type ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
+
+	is1_action_set(ocelot, &data, ace);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, ace->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 			   int ix, int block_id)
 {
@@ -670,6 +861,9 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
 			   int block_id)
 {
 	switch (block_id) {
+	case VCAP_IS1:
+		is1_entry_set(ocelot, ix, ace);
+		break;
 	case VCAP_IS2:
 		is2_entry_set(ocelot, ix, ace);
 		break;
@@ -986,6 +1180,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 {
 	struct ocelot_acl_block *block;
 
+	vcap_init(ocelot, &ocelot->vcap[VCAP_IS1]);
 	vcap_init(ocelot, &ocelot->vcap[VCAP_IS2]);
 
 	/* Create a policer that will drop the frames for the cpu.
@@ -1005,7 +1200,8 @@ int ocelot_ace_init(struct ocelot *ocelot)
 
 	block = &ocelot->acl_block[VCAP_IS2];
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
-	INIT_LIST_HEAD(&block->rules);
+	INIT_LIST_HEAD(&ocelot->acl_block[VCAP_IS1].rules);
+	INIT_LIST_HEAD(&ocelot->acl_block[VCAP_IS2].rules);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index a9fd99401a65..bb2df6adaefd 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -93,6 +93,12 @@ struct ocelot_ace_vlan {
 	enum ocelot_vcap_bit tagged; /* Tagged/untagged frame */
 };
 
+struct ocelot_ace_action_vlan {
+	u16 vid;
+	u8 pcp;
+	u8 dei;
+};
+
 struct ocelot_ace_frame_etype {
 	struct ocelot_vcap_u48 dmac;
 	struct ocelot_vcap_u48 smac;
@@ -158,6 +164,7 @@ struct ocelot_ace_frame_ipv4 {
 struct ocelot_ace_frame_ipv6 {
 	struct ocelot_vcap_u8 proto; /* IPv6 protocol */
 	struct ocelot_vcap_u128 sip; /* IPv6 source (byte 0-7 ignored) */
+	struct ocelot_vcap_u128 dip; /* IPv6 destination (byte 0-7 ignored) */
 	enum ocelot_vcap_bit ttl;  /* TTL zero */
 	struct ocelot_vcap_u8 ds;
 	struct ocelot_vcap_u48 data; /* Not UDP/TCP: IP data */
@@ -179,6 +186,8 @@ enum ocelot_ace_action {
 	OCELOT_ACL_ACTION_DROP,
 	OCELOT_ACL_ACTION_TRAP,
 	OCELOT_ACL_ACTION_POLICE,
+	OCELOT_ACL_ACTION_VLAN_MODIFY,
+	OCELOT_ACL_ACTION_PRIORITY,
 };
 
 struct ocelot_ace_stats {
@@ -200,6 +209,7 @@ struct ocelot_ace_rule {
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
 	struct ocelot_ace_vlan vlan;
+	struct ocelot_ace_action_vlan vlan_modify;
 
 	enum ocelot_ace_type type;
 	union {
@@ -213,6 +223,7 @@ struct ocelot_ace_rule {
 	} frame;
 	struct ocelot_policer pol;
 	u32 pol_ix;
+	u8 qos_val;
 };
 
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index a1f7b6b28170..7f1a40ede652 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -63,6 +63,17 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 			ace->action = OCELOT_ACL_ACTION_NULL;
 			allowed_chain = f->common.chain_index;
 			break;
+		case FLOW_ACTION_VLAN_MANGLE:
+			ace->action = OCELOT_ACL_ACTION_VLAN_MODIFY;
+			ace->vlan_modify.vid = a->vlan.vid;
+			ace->vlan_modify.pcp = a->vlan.prio;
+			allowed_chain = 0;
+			break;
+		case FLOW_ACTION_PRIORITY:
+			ace->action = OCELOT_ACL_ACTION_PRIORITY;
+			ace->qos_val = a->priority;
+			allowed_chain = 0;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 18ce99730406..2be74b275685 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -254,6 +254,7 @@ static const u32 *ocelot_regmap[] = {
 	[QSYS] = ocelot_qsys_regmap,
 	[REW] = ocelot_rew_regmap,
 	[SYS] = ocelot_sys_regmap,
+	[S1] = ocelot_vcap_regmap,
 	[S2] = ocelot_vcap_regmap,
 	[PTP] = ocelot_ptp_regmap,
 };
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4b2320bdc036..1768ad1ca4e6 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -107,6 +107,7 @@ enum ocelot_target {
 	QSYS,
 	REW,
 	SYS,
+	S1,
 	S2,
 	HSIO,
 	PTP,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 495847a40490..9e83757f9b02 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -264,4 +264,95 @@ enum vcap_is2_action_field {
 	VCAP_IS2_ACT_HIT_CNT,
 };
 
+/* =================================================================
+ *  VCAP IS1
+ * =================================================================
+ */
+
+/* IS1 half key types */
+#define IS1_TYPE_S1_NORMAL 0
+#define IS1_TYPE_S1_5TUPLE_IP4 1
+
+/* IS1 full key types */
+#define IS1_TYPE_S1_NORMAL_IP6 0
+#define IS1_TYPE_S1_7TUPLE 1
+#define IS2_TYPE_S1_5TUPLE_IP6 2
+
+enum {
+	IS1_ACTION_TYPE_NORMAL,
+	IS1_ACTION_TYPE_MAX,
+};
+
+enum vcap_is1_half_key_field {
+	VCAP_IS1_HK_TYPE,
+	VCAP_IS1_HK_LOOKUP,
+	VCAP_IS1_HK_IGR_PORT_MASK,
+	VCAP_IS1_HK_RSV,
+	VCAP_IS1_HK_OAM_Y1731,
+	VCAP_IS1_HK_L2_MC,
+	VCAP_IS1_HK_L2_BC,
+	VCAP_IS1_HK_IP_MC,
+	VCAP_IS1_HK_VLAN_TAGGED,
+	VCAP_IS1_HK_VLAN_DBL_TAGGED,
+	VCAP_IS1_HK_TPID,
+	VCAP_IS1_HK_VID,
+	VCAP_IS1_HK_DEI,
+	VCAP_IS1_HK_PCP,
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	VCAP_IS1_HK_L2_SMAC,
+	VCAP_IS1_HK_ETYPE_LEN,
+	VCAP_IS1_HK_ETYPE,
+	VCAP_IS1_HK_IP_SNAP,
+	VCAP_IS1_HK_IP4,
+	VCAP_IS1_HK_L3_FRAGMENT,
+	VCAP_IS1_HK_L3_FRAG_OFS_GT0,
+	VCAP_IS1_HK_L3_OPTIONS,
+	VCAP_IS1_HK_L3_DSCP,
+	VCAP_IS1_HK_L3_IP4_SIP,
+	VCAP_IS1_HK_TCP_UDP,
+	VCAP_IS1_HK_TCP,
+	VCAP_IS1_HK_L4_SPORT,
+	VCAP_IS1_HK_L4_RNG,
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	VCAP_IS1_HK_IP4_INNER_TPID,
+	VCAP_IS1_HK_IP4_INNER_VID,
+	VCAP_IS1_HK_IP4_INNER_DEI,
+	VCAP_IS1_HK_IP4_INNER_PCP,
+	VCAP_IS1_HK_IP4_IP4,
+	VCAP_IS1_HK_IP4_L3_FRAGMENT,
+	VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0,
+	VCAP_IS1_HK_IP4_L3_OPTIONS,
+	VCAP_IS1_HK_IP4_L3_DSCP,
+	VCAP_IS1_HK_IP4_L3_IP4_DIP,
+	VCAP_IS1_HK_IP4_L3_IP4_SIP,
+	VCAP_IS1_HK_IP4_L3_PROTO,
+	VCAP_IS1_HK_IP4_TCP_UDP,
+	VCAP_IS1_HK_IP4_TCP,
+	VCAP_IS1_HK_IP4_L4_RNG,
+	VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE,
+};
+
+enum vcap_is1_action_field {
+	VCAP_IS1_ACT_DSCP_ENA,
+	VCAP_IS1_ACT_DSCP_VAL,
+	VCAP_IS1_ACT_QOS_ENA,
+	VCAP_IS1_ACT_QOS_VAL,
+	VCAP_IS1_ACT_DP_ENA,
+	VCAP_IS1_ACT_DP_VAL,
+	VCAP_IS1_ACT_PAG_OVERRIDE_MASK,
+	VCAP_IS1_ACT_PAG_VAL,
+	VCAP_IS1_ACT_RSV,
+	VCAP_IS1_ACT_VID_REPLACE_ENA,
+	VCAP_IS1_ACT_VID_ADD_VAL,
+	VCAP_IS1_ACT_FID_SEL,
+	VCAP_IS1_ACT_FID_VAL,
+	VCAP_IS1_ACT_PCP_DEI_ENA,
+	VCAP_IS1_ACT_PCP_VAL,
+	VCAP_IS1_ACT_DEI_VAL,
+	VCAP_IS1_ACT_VLAN_POP_CNT_ENA,
+	VCAP_IS1_ACT_VLAN_POP_CNT,
+	VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA,
+	VCAP_IS1_ACT_HIT_STICKY,
+};
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.17.1

