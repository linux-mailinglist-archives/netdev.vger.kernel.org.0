Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED744174764
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgB2Obh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38548 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgB2Obf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id t11so418335wrw.5
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/RduZ5aoyG34Jha4E3UpniVJV43kSIz1YGx2N+Y7+fo=;
        b=DWeZATHRmFBLSs7uAf8nIpD7fBxYLGC6saJ7/Nqv5jHdI8Lbrh0GsTwhd6fClph8Ao
         DK9Wm5MuMzZEpPcK1SyxoXsuIdhpxBd/bT6XCW3CPbTvd/AaA2E0KNdYhhIYNjArfSlJ
         EtNgZh0dMBZKSvZCzgDbzW5AuTizIJrvbThxGOu2l9ZNSuXM/EA2chgyYKMsietxzHNt
         0i/6JuFZ4GSGrN+NfM9raQQJxjpE9ibXZZyOCcuoSTWfF+kZGlVmKi9CjULxjTY2HmHi
         /lmcHUEO8mh3DD7XggAyCCm0HLsg8O2k7JpA34AhXsPZFYvBDKUNdlABOTJbOTra9py0
         SXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/RduZ5aoyG34Jha4E3UpniVJV43kSIz1YGx2N+Y7+fo=;
        b=S9S1LoHizy6/pHbN5wBBI7xjifk0+47iz3a2LtiNnnVs/doX1KV8WTYvj0Qn440UkE
         aJcK9Mtx8ZWayrkmkRg1UM9ZhgFnuBMURP/G05Xqqp2CvAYM05wn5XCXuTU4C/JHK8pb
         aln2tx8+S7k8WEEBIB134y6AgFHIsntrl53frzmY8LLU/EBvsPWEpIXBUFsRvDoCIZjO
         jb7jWqRo4P9FGsnK9nKZZb2tXAi74Nilsg3943X2xul+fLhIf1sYRxN/S5fsgz7YgNYR
         MbblTZUQNtwyMte2D6KVbXAmo4SLa1k7lsrmhBasRVakMSynqtcdZDTvIUM24NvKzxZu
         s1tg==
X-Gm-Message-State: APjAAAX12x7Lfk+dxEf6Mk4DeQY635VZ8p5A9wGDWqFA/Pc2SLbGyw/w
        3wePwEz+i29lkWy0d778Dyk=
X-Google-Smtp-Source: APXvYqymXVN3OXNT5SCI3gu+/YDHdnGBPNr1K47kU6BZnr+KSWuxJ2/4/zlyDKVNluOAFEohtasvvw==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr10980002wru.122.1582986693418;
        Sat, 29 Feb 2020 06:31:33 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 10/10] net: dsa: felix: Wire up the ocelot cls_flower methods
Date:   Sat, 29 Feb 2020 16:31:14 +0200
Message-Id: <20200229143114.10656-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Export the cls_flower methods from the ocelot driver and hook them up to
the DSA passthrough layer.

Tables for the VCAP IS2 parameters, as well as half key packing (field
offsets and lengths) need to be defined for the VSC9959 core, as they
are different from Ocelot, mainly due to the different port count.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Defined VSC9959_VCAP_IS2_CNT, VSC9959_VCAP_IS2_ENTRY_WIDTH,
VSC9959_VCAP_PORT_CNT.

 drivers/net/dsa/ocelot/felix.c         |  31 ++++++
 drivers/net/dsa/ocelot/felix.h         |   3 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 131 +++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |   6 ++
 4 files changed, 171 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f14595b8dad5..69546383a382 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2,6 +2,7 @@
 /* Copyright 2019 NXP Semiconductors
  */
 #include <uapi/linux/if_bridge.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot_dev.h>
@@ -401,6 +402,9 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
+	ocelot->vcap_is2_keys	= felix->info->vcap_is2_keys;
+	ocelot->vcap_is2_actions= felix->info->vcap_is2_actions;
+	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
@@ -605,6 +609,30 @@ static bool felix_txtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static int felix_cls_flower_add(struct dsa_switch *ds, int port,
+				struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_replace(ocelot, port, cls, ingress);
+}
+
+static int felix_cls_flower_del(struct dsa_switch *ds, int port,
+				struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_destroy(ocelot, port, cls, ingress);
+}
+
+static int felix_cls_flower_stats(struct dsa_switch *ds, int port,
+				  struct flow_cls_offload *cls, bool ingress)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
+}
+
 static const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
@@ -636,6 +664,9 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_hwtstamp_set	= felix_hwtstamp_set,
 	.port_rxtstamp		= felix_rxtstamp,
 	.port_txtstamp		= felix_txtstamp,
+	.cls_flower_add		= felix_cls_flower_add,
+	.cls_flower_del		= felix_cls_flower_del,
+	.cls_flower_stats	= felix_cls_flower_stats,
 };
 
 static struct felix_info *felix_instance_tbl[] = {
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 3a7580015b62..82d46f260041 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -18,6 +18,9 @@ struct felix_info {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
+	struct vcap_field		*vcap_is2_keys;
+	struct vcap_field		*vcap_is2_actions;
+	const struct vcap_props		*vcap;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 93800e81cdd4..b4078f3c5c38 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -3,12 +3,17 @@
  * Copyright 2018-2019 NXP Semiconductors
  */
 #include <linux/fsl/enetc_mdio.h>
+#include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include "felix.h"
 
+#define VSC9959_VCAP_IS2_CNT		1024
+#define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
+#define VSC9959_VCAP_PORT_CNT		6
+
 /* TODO: should find a better place for these */
 #define USXGMII_BMCR_RESET		BIT(15)
 #define USXGMII_BMCR_AN_EN		BIT(12)
@@ -547,6 +552,129 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+struct vcap_field vsc9959_vcap_is2_keys[] = {
+	/* Common: 41 bits */
+	[VCAP_IS2_TYPE]				= {  0,   4},
+	[VCAP_IS2_HK_FIRST]			= {  4,   1},
+	[VCAP_IS2_HK_PAG]			= {  5,   8},
+	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,   7},
+	[VCAP_IS2_HK_RSV2]			= { 20,   1},
+	[VCAP_IS2_HK_HOST_MATCH]		= { 21,   1},
+	[VCAP_IS2_HK_L2_MC]			= { 22,   1},
+	[VCAP_IS2_HK_L2_BC]			= { 23,   1},
+	[VCAP_IS2_HK_VLAN_TAGGED]		= { 24,   1},
+	[VCAP_IS2_HK_VID]			= { 25,  12},
+	[VCAP_IS2_HK_DEI]			= { 37,   1},
+	[VCAP_IS2_HK_PCP]			= { 38,   3},
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	[VCAP_IS2_HK_L2_DMAC]			= { 41,  48},
+	[VCAP_IS2_HK_L2_SMAC]			= { 89,  48},
+	/* MAC_ETYPE (TYPE=000) */
+	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= {137,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= {153,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= {169,   8},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= {177,   3},
+	/* MAC_LLC (TYPE=001) */
+	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= {137,  40},
+	/* MAC_SNAP (TYPE=010) */
+	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= {137,  40},
+	/* MAC_ARP (TYPE=011) */
+	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 41,  48},
+	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 89,   1},
+	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 90,   1},
+	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 91,   1},
+	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 92,   1},
+	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 93,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 94,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= { 95,   2},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= { 97,  32},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= {129,  32},
+	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= {161,   1},
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	[VCAP_IS2_HK_IP4]			= { 41,   1},
+	[VCAP_IS2_HK_L3_FRAGMENT]		= { 42,   1},
+	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 43,   1},
+	[VCAP_IS2_HK_L3_OPTIONS]		= { 44,   1},
+	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 45,   1},
+	[VCAP_IS2_HK_L3_TOS]			= { 46,   8},
+	[VCAP_IS2_HK_L3_IP4_DIP]		= { 54,  32},
+	[VCAP_IS2_HK_L3_IP4_SIP]		= { 86,  32},
+	[VCAP_IS2_HK_DIP_EQ_SIP]		= {118,   1},
+	/* IP4_TCP_UDP (TYPE=100) */
+	[VCAP_IS2_HK_TCP]			= {119,   1},
+	[VCAP_IS2_HK_L4_SPORT]			= {120,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {136,  16},
+	[VCAP_IS2_HK_L4_RNG]			= {152,   8},
+	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {160,   1},
+	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {161,   1},
+	[VCAP_IS2_HK_L4_URG]			= {162,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {163,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {164,   1},
+	[VCAP_IS2_HK_L4_RST]			= {165,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {166,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_1588_DOM]		= {168,   8},
+	[VCAP_IS2_HK_L4_1588_VER]		= {176,   4},
+	/* IP4_OTHER (TYPE=101) */
+	[VCAP_IS2_HK_IP4_L3_PROTO]		= {119,   8},
+	[VCAP_IS2_HK_L3_PAYLOAD]		= {127,  56},
+	/* IP6_STD (TYPE=110) */
+	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 41,   1},
+	[VCAP_IS2_HK_L3_IP6_SIP]		= { 42, 128},
+	[VCAP_IS2_HK_IP6_L3_PROTO]		= {170,   8},
+	/* OAM (TYPE=111) */
+	[VCAP_IS2_HK_OAM_MEL_FLAGS]		= {137,   7},
+	[VCAP_IS2_HK_OAM_VER]			= {144,   5},
+	[VCAP_IS2_HK_OAM_OPCODE]		= {149,   8},
+	[VCAP_IS2_HK_OAM_FLAGS]			= {157,   8},
+	[VCAP_IS2_HK_OAM_MEPID]			= {165,  16},
+	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= {181,   1},
+	[VCAP_IS2_HK_OAM_IS_Y1731]		= {182,   1},
+};
+
+struct vcap_field vsc9959_vcap_is2_actions[] = {
+	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
+	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
+	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
+	[VCAP_IS2_ACT_MASK_MODE]		= {  5,  2},
+	[VCAP_IS2_ACT_MIRROR_ENA]		= {  7,  1},
+	[VCAP_IS2_ACT_LRN_DIS]			= {  8,  1},
+	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
+	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9},
+	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1},
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11},
+	[VCAP_IS2_ACT_REW_OP]			= { 31,  9},
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1},
+	[VCAP_IS2_ACT_RSV]			= { 41,  2},
+	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6},
+	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
+};
+
+static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_IS2] = {
+		.tg_width = 2,
+		.sw_count = 4,
+		.entry_count = VSC9959_VCAP_IS2_CNT,
+		.entry_width = VSC9959_VCAP_IS2_ENTRY_WIDTH,
+		.action_count = VSC9959_VCAP_IS2_CNT +
+				VSC9959_VCAP_PORT_CNT + 2,
+		.action_width = 89,
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 44,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.counter_words = 4,
+		.counter_width = 32,
+	},
+};
+
 #define VSC9959_INIT_TIMEOUT			50000
 #define VSC9959_GCB_RST_SLEEP			100
 #define VSC9959_SYS_RAMINIT_SLEEP		80
@@ -1088,6 +1216,9 @@ struct felix_info felix_info_vsc9959 = {
 	.ops			= &vsc9959_ops,
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
+	.vcap_is2_keys		= vsc9959_vcap_is2_keys,
+	.vcap_is2_actions	= vsc9959_vcap_is2_actions,
+	.vcap			= vsc9959_vcap_props,
 	.shared_queue_sz	= 128 * 1024,
 	.num_ports		= 6,
 	.switch_pci_bar		= 4,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e572c6446df0..63d93ac1879e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -608,5 +608,11 @@ int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
 int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 				 struct sk_buff *skb);
 void ocelot_get_txtstamp(struct ocelot *ocelot);
+int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress);
+int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress);
+int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
+			    struct flow_cls_offload *f, bool ingress);
 
 #endif
-- 
2.17.1

