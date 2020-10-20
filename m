Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90C72935D6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405209AbgJTHcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36676 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405167AbgJTHcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:47 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 154A41A0773;
        Tue, 20 Oct 2020 09:32:41 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CACE41A0757;
        Tue, 20 Oct 2020 09:32:32 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 87DFA402F3;
        Tue, 20 Oct 2020 09:32:22 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 3/5] net: dsa: felix: add gate action offload based on tc flower
Date:   Tue, 20 Oct 2020 15:23:19 +0800
Message-Id: <20201020072321.36921-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 supports Per-Stream Filtering and Policing(PSFP). Sream is
identified by Null Stream identification which is defined in
IEEE802.1Qci.

For IEEE 802.1Qci, there are four tables need to set: stream table,
stream filter table, stream gate table, and flow meter table. This
patch is using TC flower gate action to set stream gate table, using
TC flower keys{dst_mac, vlan_id} to identify a stream and set the
stream table. Stream filter table is maintained automatically, and
it's index is determined by SGID(stream gate index) and FMID(flow
meter index).

On the ocelot driver, there is also a TC flower offload to set up
VCAPs. We check the chain ID to offload the rule on felix driver to
run PSFP flow.

An example to set stream gate:
	> tc qdisc add dev swp0 clsact
	> tc filter add dev swp0 ingress chain 30000 protocol 802.1Q
		flower skip_sw dst_mac  CA:9C:00:BC:6D:68 vlan_id 1 \
		action gate index 1 base-time 0 \
			sched-entry CLOSE 6000 3 -1

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/Makefile        |   3 +-
 drivers/net/dsa/ocelot/felix.c         |  23 +
 drivers/net/dsa/ocelot/felix.h         |  16 +
 drivers/net/dsa/ocelot/felix_flower.c  | 651 +++++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_vsc9959.c |  10 +-
 include/soc/mscc/ocelot_ana.h          |  10 +
 6 files changed, 709 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_flower.c

diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..22f3f98914e3 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -4,7 +4,8 @@ obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
-	felix_vsc9959.o
+	felix_vsc9959.o \
+	felix_flower.o
 
 mscc_seville-objs := \
 	felix.o \
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f791860d495f..42f972d10539 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -716,6 +716,13 @@ static int felix_cls_flower_add(struct dsa_switch *ds, int port,
 				struct flow_cls_offload *cls, bool ingress)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->flower_replace) {
+		if (cls->common.chain_index == OCELOT_PSFP_CHAIN)
+			return felix->info->flower_replace(ocelot, port, cls,
+							   ingress);
+	}
 
 	return ocelot_cls_flower_replace(ocelot, port, cls, ingress);
 }
@@ -724,6 +731,14 @@ static int felix_cls_flower_del(struct dsa_switch *ds, int port,
 				struct flow_cls_offload *cls, bool ingress)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int ret;
+
+	if (felix->info->flower_destroy) {
+		ret = felix->info->flower_destroy(ocelot, port, cls, ingress);
+		if (!ret)
+			return 0;
+	}
 
 	return ocelot_cls_flower_destroy(ocelot, port, cls, ingress);
 }
@@ -732,6 +747,14 @@ static int felix_cls_flower_stats(struct dsa_switch *ds, int port,
 				  struct flow_cls_offload *cls, bool ingress)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int ret;
+
+	if (felix->info->flower_stats) {
+		ret = felix->info->flower_stats(ocelot, port, cls, ingress);
+		if (!ret)
+			return 0;
+	}
 
 	return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
 }
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4c717324ac2f..9ea880deb2a0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -37,6 +37,12 @@ struct felix_info {
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
 	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
+	int	(*flower_replace)(struct ocelot *ocelot, int port,
+				  struct flow_cls_offload *f, bool ingress);
+	int	(*flower_destroy)(struct ocelot *ocelot, int port,
+				  struct flow_cls_offload *f, bool ingress);
+	int	(*flower_stats)(struct ocelot *ocelot, int port,
+				struct flow_cls_offload *f, bool ingress);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
@@ -55,4 +61,14 @@ struct felix {
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
 int felix_netdev_to_port(struct net_device *dev);
 
+void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
+			   u64 cycle_time, struct timespec64 *new_base_ts);
+int felix_flower_stream_replace(struct ocelot *ocelot, int port,
+				struct flow_cls_offload *f, bool ingress);
+int felix_flower_stream_destroy(struct ocelot *ocelot, int port,
+				struct flow_cls_offload *f, bool ingress);
+int felix_flower_stream_stats(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress);
+void felix_psfp_init(struct ocelot *ocelot);
+
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_flower.c b/drivers/net/dsa/ocelot/felix_flower.c
new file mode 100644
index 000000000000..71894dcc0af2
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_flower.c
@@ -0,0 +1,651 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Copyright 2020 NXP Semiconductors
+ */
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <net/tc_act/tc_gate.h>
+#include <net/flow_offload.h>
+#include <soc/mscc/ocelot.h>
+#include <net/pkt_sched.h>
+#include "felix.h"
+
+#define FELIX_PSFP_SFID_MAX		175
+#define FELIX_PSFP_GATE_ID_MAX		183
+#define FELIX_POLICER_PSFP_BASE		63
+#define FELIX_POLICER_PSFP_MAX		383
+#define FELIX_PSFP_GATE_LIST_NUM	4
+#define FELIX_PSFP_GATE_CYCLETIME_MIN	5000
+
+struct felix_streamid {
+	struct list_head list;
+	u32 id;
+	u8 dmac[ETH_ALEN];
+	u16 vid;
+	s8 prio;
+	u8 sfid_valid;
+	u32 sfid;
+};
+
+struct felix_stream_gate_conf {
+	u32 index;
+	u8 enable;
+	u8 ipv_valid;
+	u8 init_ipv;
+	u64 basetime;
+	u64 cycletime;
+	u64 cycletimext;
+	u32 num_entries;
+	struct action_gate_entry entries[0];
+};
+
+struct felix_stream_filter {
+	struct list_head list;
+	refcount_t refcount;
+	u32 index;
+	u8 enable;
+	u8 sg_valid;
+	u32 sgid;
+	u8 fm_valid;
+	u32 fmid;
+	u8 prio_valid;
+	u8 prio;
+	u32 maxsdu;
+};
+
+struct felix_stream_gate {
+	struct list_head list;
+	refcount_t refcount;
+	u32 index;
+};
+
+struct felix_psfp_stream_counters {
+	u32 match;
+	u32 not_pass_gate;
+	u32 not_pass_sdu;
+	u32 red;
+};
+
+struct felix_psfp_list {
+	struct list_head stream_list;
+	struct list_head gate_list;
+	struct list_head sfi_list;
+};
+
+static struct felix_psfp_list lpsfp;
+
+static u32 felix_sg_cfg_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, ANA_SG_ACCESS_CTRL);
+}
+
+static int felix_hw_sgi_set(struct ocelot *ocelot,
+			    struct felix_stream_gate_conf *sgi)
+{
+	struct action_gate_entry *e;
+	struct timespec64 base_ts;
+	u32 interval_sum = 0;
+	u32 val;
+	int i;
+
+	if (sgi->index > FELIX_PSFP_GATE_ID_MAX)
+		return -EINVAL;
+
+	ocelot_write(ocelot, ANA_SG_ACCESS_CTRL_SGID(sgi->index),
+		     ANA_SG_ACCESS_CTRL);
+
+	if (!sgi->enable) {
+		ocelot_rmw(ocelot, ANA_SG_CONFIG_REG_3_INIT_GATE_STATE,
+			   ANA_SG_CONFIG_REG_3_INIT_GATE_STATE |
+			   ANA_SG_CONFIG_REG_3_GATE_ENABLE,
+			   ANA_SG_CONFIG_REG_3);
+
+		return 0;
+	}
+
+	if (sgi->cycletime < FELIX_PSFP_GATE_CYCLETIME_MIN ||
+	    sgi->cycletime > NSEC_PER_SEC)
+		return -EINVAL;
+
+	if (sgi->num_entries > FELIX_PSFP_GATE_LIST_NUM)
+		return -EINVAL;
+
+	vsc9959_new_base_time(ocelot, sgi->basetime, sgi->cycletime, &base_ts);
+	ocelot_write(ocelot, base_ts.tv_nsec, ANA_SG_CONFIG_REG_1);
+	val = lower_32_bits(base_ts.tv_sec);
+	ocelot_write(ocelot, val, ANA_SG_CONFIG_REG_2);
+
+	val = upper_32_bits(base_ts.tv_sec);
+	ocelot_write(ocelot,
+		     (sgi->ipv_valid ? ANA_SG_CONFIG_REG_3_IPV_VALID : 0) |
+		     ANA_SG_CONFIG_REG_3_INIT_IPV(sgi->init_ipv) |
+		     ANA_SG_CONFIG_REG_3_GATE_ENABLE |
+		     ANA_SG_CONFIG_REG_3_LIST_LENGTH(sgi->num_entries) |
+		     ANA_SG_CONFIG_REG_3_INIT_GATE_STATE |
+		     ANA_SG_CONFIG_REG_3_BASE_TIME_SEC_MSB(val),
+		     ANA_SG_CONFIG_REG_3);
+
+	ocelot_write(ocelot, sgi->cycletime, ANA_SG_CONFIG_REG_4);
+
+	e = sgi->entries;
+	for (i = 0; i < sgi->num_entries; i++) {
+		u32 ips = (e[i].ipv < 0) ? 0 : (e[i].ipv + 8);
+
+		ocelot_write_rix(ocelot, ANA_SG_GCL_GS_CONFIG_IPS(ips) |
+				 (e[i].gate_state ?
+				  ANA_SG_GCL_GS_CONFIG_GATE_STATE : 0),
+				 ANA_SG_GCL_GS_CONFIG, i);
+
+		interval_sum += e[i].interval;
+		ocelot_write_rix(ocelot, interval_sum, ANA_SG_GCL_TI_CONFIG, i);
+	}
+
+	ocelot_rmw(ocelot, ANA_SG_ACCESS_CTRL_CONFIG_CHANGE,
+		   ANA_SG_ACCESS_CTRL_CONFIG_CHANGE,
+		   ANA_SG_ACCESS_CTRL);
+
+	return readx_poll_timeout(felix_sg_cfg_status, ocelot, val,
+				  (!(ANA_SG_ACCESS_CTRL_CONFIG_CHANGE & val)),
+				  10, 100000);
+}
+
+static u32 felix_sfi_access_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, ANA_TABLES_SFIDACCESS);
+}
+
+static int felix_hw_sfi_set(struct ocelot *ocelot,
+			    struct felix_stream_filter *sfi)
+{
+	u32 val;
+
+	if (sfi->index > FELIX_PSFP_SFID_MAX)
+		return -EINVAL;
+
+	if (!sfi->enable) {
+		ocelot_write(ocelot, ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
+			     ANA_TABLES_SFIDTIDX);
+
+		val = ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE);
+		ocelot_write(ocelot, val, ANA_TABLES_SFIDACCESS);
+
+		return readx_poll_timeout(felix_sfi_access_status, ocelot, val,
+					  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
+					  10, 100000);
+	}
+
+	if (sfi->sgid > FELIX_PSFP_GATE_ID_MAX ||
+	    sfi->fmid > FELIX_POLICER_PSFP_MAX)
+		return -EINVAL;
+
+	ocelot_write(ocelot,
+		     (sfi->sg_valid ? ANA_TABLES_SFIDTIDX_SGID_VALID : 0) |
+		     ANA_TABLES_SFIDTIDX_SGID(sfi->sgid) |
+		     (sfi->fm_valid ? ANA_TABLES_SFIDTIDX_POL_ENA : 0) |
+		     ANA_TABLES_SFIDTIDX_POL_IDX(sfi->fmid) |
+		     ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
+		     ANA_TABLES_SFIDTIDX);
+
+	ocelot_write(ocelot,
+		     (sfi->prio_valid ? ANA_TABLES_SFIDACCESS_IGR_PRIO_MATCH_ENA : 0) |
+		     ANA_TABLES_SFIDACCESS_IGR_PRIO(sfi->prio) |
+		     ANA_TABLES_SFIDACCESS_MAX_SDU_LEN(sfi->maxsdu) |
+		     ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE),
+		     ANA_TABLES_SFIDACCESS);
+
+	return readx_poll_timeout(felix_sfi_access_status, ocelot, val,
+				  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
+				  10, 100000);
+}
+
+static u32 felix_mact_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
+}
+
+static int felix_mact_stream_update(struct ocelot *ocelot,
+				    struct felix_streamid *stream,
+				    struct netlink_ext_ack *extack)
+{
+	u32 row, col, reg, val;
+	u8 type;
+	int ret;
+
+	/* Stream identification desn't support to add a stream with non
+	 * existent MAC (The MAC entry has not been learned in MAC table).
+	 * return -EOPNOTSUPP to continue offloading to other modules.
+	 */
+	ret = ocelot_mact_lookup(ocelot, stream->dmac, stream->vid, &row, &col);
+	if (ret) {
+		if (extack)
+			NL_SET_ERR_MSG_MOD(extack, "Stream is not learned in MAC table");
+		return -EOPNOTSUPP;
+	}
+
+	ocelot_rmw(ocelot,
+		   (stream->sfid_valid ? ANA_TABLES_STREAMDATA_SFID_VALID : 0) |
+		   ANA_TABLES_STREAMDATA_SFID(stream->sfid),
+		   ANA_TABLES_STREAMDATA_SFID_VALID |
+		   ANA_TABLES_STREAMDATA_SFID_M,
+		   ANA_TABLES_STREAMDATA);
+
+	reg = ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
+	reg &= (ANA_TABLES_STREAMDATA_SFID_VALID | ANA_TABLES_STREAMDATA_SSID_VALID);
+	type = (reg ? ENTRYTYPE_LOCKED : ENTRYTYPE_NORMAL);
+	ocelot_rmw(ocelot,  ANA_TABLES_MACACCESS_VALID |
+		   ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
+		   ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_WRITE),
+		   ANA_TABLES_MACACCESS_VALID |
+		   ANA_TABLES_MACACCESS_ENTRYTYPE_M |
+		   ANA_TABLES_MACACCESS_MAC_TABLE_CMD_M,
+		   ANA_TABLES_MACACCESS);
+
+	return readx_poll_timeout(felix_mact_status, ocelot, val,
+				  (!ANA_TABLES_MACACCESS_MAC_TABLE_CMD(val)),
+				  10, 100000);
+}
+
+static void felix_stream_counters_get(struct ocelot *ocelot, u32 index,
+				      struct felix_psfp_stream_counters *counters)
+{
+	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
+		   SYS_STAT_CFG_STAT_VIEW_M,
+		   SYS_STAT_CFG);
+
+	counters->match = ocelot_read_gix(ocelot, SYS_CNT, 0x200);
+	counters->not_pass_gate = ocelot_read_gix(ocelot, SYS_CNT, 0x201);
+	counters->not_pass_sdu = ocelot_read_gix(ocelot, SYS_CNT, 0x202);
+	counters->red = ocelot_read_gix(ocelot, SYS_CNT, 0x203);
+}
+
+static int felix_list_gate_add(struct ocelot *ocelot,
+			       struct felix_stream_gate_conf *sgi)
+{
+	struct felix_stream_gate *gate, *tmp;
+	struct list_head *pos, *q;
+	int ret;
+
+	list_for_each_safe(pos, q, &lpsfp.gate_list) {
+		tmp = list_entry(pos, struct felix_stream_gate, list);
+		if (tmp->index == sgi->index) {
+			refcount_inc(&tmp->refcount);
+			return 0;
+		}
+		if (tmp->index > sgi->index)
+			break;
+	}
+
+	ret = felix_hw_sgi_set(ocelot, sgi);
+	if (ret)
+		return ret;
+
+	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+	if (!gate)
+		return -ENOMEM;
+
+	gate->index = sgi->index;
+	refcount_set(&gate->refcount, 1);
+	list_add(&gate->list, pos->prev);
+
+	return 0;
+}
+
+static void felix_list_gate_del(struct ocelot *ocelot, u32 index)
+{
+	struct felix_stream_gate *tmp;
+	struct felix_stream_gate_conf sgi;
+	struct list_head *pos, *q;
+	u8 z;
+
+	list_for_each_safe(pos, q, &lpsfp.gate_list) {
+		tmp = list_entry(pos, struct felix_stream_gate, list);
+		if (tmp->index == index) {
+			z = refcount_dec_and_test(&tmp->refcount);
+			if (z) {
+				sgi.index = index;
+				sgi.enable = 0;
+				felix_hw_sgi_set(ocelot, &sgi);
+				list_del(pos);
+				kfree(tmp);
+			}
+			break;
+		}
+	}
+}
+
+static int felix_list_stream_filter_add(struct ocelot *ocelot,
+					struct felix_stream_filter *sfi)
+{
+	struct felix_stream_filter *sfi_entry, *tmp;
+	struct list_head *last = &lpsfp.sfi_list;
+	struct list_head *pos, *q;
+	u32 insert = 0;
+	int ret;
+
+	list_for_each_safe(pos, q, &lpsfp.sfi_list) {
+		tmp = list_entry(pos, struct felix_stream_filter, list);
+		if (sfi->sg_valid == tmp->sg_valid &&
+		    tmp->sgid == sfi->sgid &&
+		    tmp->fmid == sfi->fmid) {
+			sfi->index = tmp->index;
+			refcount_inc(&tmp->refcount);
+			return 0;
+		}
+		if (tmp->index == insert) {
+			last = pos;
+			insert++;
+		}
+	}
+	sfi->index = insert;
+	ret = felix_hw_sfi_set(ocelot, sfi);
+	if (ret)
+		return ret;
+
+	sfi_entry = kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
+	if (!sfi_entry)
+		return -ENOMEM;
+
+	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
+	refcount_set(&sfi_entry->refcount, 1);
+
+	list_add(&sfi_entry->list, last->next);
+
+	return 0;
+}
+
+static void felix_list_stream_filter_del(struct ocelot *ocelot, u32 index)
+{
+	struct felix_stream_filter *tmp;
+	struct list_head *pos, *q;
+	u8 z;
+
+	list_for_each_safe(pos, q, &lpsfp.sfi_list) {
+		tmp = list_entry(pos, struct felix_stream_filter, list);
+		if (tmp->index == index) {
+			if (tmp->sg_valid)
+				felix_list_gate_del(ocelot, tmp->sgid);
+
+			z = refcount_dec_and_test(&tmp->refcount);
+			if (z) {
+				tmp->enable = 0;
+				felix_hw_sfi_set(ocelot, tmp);
+				list_del(pos);
+				kfree(tmp);
+			}
+			break;
+		}
+	}
+}
+
+static int felix_list_stream_add(struct felix_streamid *stream)
+{
+	struct felix_streamid *stream_entry;
+	struct list_head *pos;
+
+	stream_entry = kzalloc(sizeof(*stream_entry), GFP_KERNEL);
+	if (!stream_entry)
+		return -ENOMEM;
+
+	memcpy(stream_entry, stream, sizeof(*stream_entry));
+
+	if (list_empty(&lpsfp.stream_list)) {
+		list_add(&stream_entry->list, &lpsfp.stream_list);
+		return 0;
+	}
+
+	pos = &lpsfp.stream_list;
+	list_add(&stream_entry->list, pos->prev);
+
+	return 0;
+}
+
+static int felix_list_stream_lookup(struct felix_streamid *stream)
+{
+	struct felix_streamid *tmp;
+
+	list_for_each_entry(tmp, &lpsfp.stream_list, list) {
+		if (tmp->dmac[0] == stream->dmac[0] &&
+		    tmp->dmac[1] == stream->dmac[1] &&
+		    tmp->dmac[2] == stream->dmac[2] &&
+		    tmp->dmac[3] == stream->dmac[3] &&
+		    tmp->dmac[4] == stream->dmac[4] &&
+		    tmp->dmac[5] == stream->dmac[5] &&
+		    tmp->vid == stream->vid &&
+		    (tmp->sfid_valid & stream->sfid_valid))
+			return 0;
+	}
+
+	return -ENOENT;
+}
+
+static struct felix_streamid *felix_list_stream_get(u32 id)
+{
+	struct felix_streamid *tmp;
+	struct list_head *pos, *q;
+
+	list_for_each_safe(pos, q, &lpsfp.stream_list) {
+		tmp = list_entry(pos, struct felix_streamid, list);
+		if (tmp->id == id)
+			return tmp;
+	}
+
+	return NULL;
+}
+
+static int felix_list_stream_del(struct ocelot *ocelot, u32 id)
+{
+	struct felix_streamid *tmp;
+	struct list_head *pos, *q;
+
+	list_for_each_safe(pos, q, &lpsfp.stream_list) {
+		tmp = list_entry(pos, struct felix_streamid, list);
+		if (tmp->id == id) {
+			tmp->sfid_valid = 0;
+			felix_list_stream_filter_del(ocelot, tmp->sfid);
+			felix_mact_stream_update(ocelot, tmp, NULL);
+			list_del(pos);
+			kfree(tmp);
+
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int felix_psfp_set(struct ocelot *ocelot,
+			  struct felix_streamid *stream,
+			  struct felix_stream_filter *sfi,
+			  struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	sfi->prio_valid = (stream->prio < 0 ? 0 : 1);
+	sfi->prio = (sfi->prio_valid ? stream->prio : 0);
+	sfi->enable = 1;
+	ret = felix_list_stream_filter_add(ocelot, sfi);
+	if (ret) {
+		if (sfi->sg_valid)
+			felix_list_gate_del(ocelot, sfi->sgid);
+		return ret;
+	}
+
+	stream->sfid = sfi->index;
+	ret = felix_mact_stream_update(ocelot, stream, extack);
+	if (ret) {
+		felix_list_stream_filter_del(ocelot, sfi->index);
+		return ret;
+	}
+
+	ret = felix_list_stream_add(stream);
+	if (ret)
+		felix_list_stream_filter_del(ocelot, sfi->index);
+
+	return ret;
+}
+
+static void felix_parse_gate(const struct flow_action_entry *entry,
+			     struct felix_stream_gate_conf *sgi)
+{
+	struct action_gate_entry *e;
+	int i;
+
+	sgi->index = entry->gate.index;
+	sgi->ipv_valid = (entry->gate.prio < 0) ? 0 : 1;
+	sgi->init_ipv = (sgi->ipv_valid) ? entry->gate.prio : 0;
+	sgi->basetime = entry->gate.basetime;
+	sgi->cycletime = entry->gate.cycletime;
+	sgi->num_entries = entry->gate.num_entries;
+	sgi->enable = 1;
+
+	e = sgi->entries;
+	for (i = 0; i < entry->gate.num_entries; i++) {
+		e[i].gate_state = entry->gate.entries[i].gate_state;
+		e[i].interval = entry->gate.entries[i].interval;
+		e[i].ipv = entry->gate.entries[i].ipv;
+		e[i].maxoctets = entry->gate.entries[i].maxoctets;
+	}
+}
+
+static int felix_flower_parse_key(struct flow_cls_offload *f,
+				  struct felix_streamid *stream)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct flow_dissector *dissector = rule->match.dissector;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS)))
+		return -EOPNOTSUPP;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		struct flow_match_eth_addrs match;
+
+		flow_rule_match_eth_addrs(rule, &match);
+		ether_addr_copy(stream->dmac, match.key->dst);
+		if (!is_zero_ether_addr(match.mask->src))
+			return -EOPNOTSUPP;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		if (match.mask->vlan_priority)
+			stream->prio = match.key->vlan_priority;
+		else
+			stream->prio = -1;
+
+		if (!match.mask->vlan_id)
+			return -EOPNOTSUPP;
+		stream->vid = match.key->vlan_id;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	stream->id = f->cookie;
+
+	return 0;
+}
+
+int felix_flower_stream_replace(struct ocelot *ocelot, int port,
+				struct flow_cls_offload *f, bool ingress)
+{
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct felix_stream_filter sfi = {0};
+	struct felix_streamid stream = {0};
+	struct felix_stream_gate_conf *sgi;
+	const struct flow_action_entry *a;
+	int ret, size, i;
+	u32 index;
+
+	ret = felix_flower_parse_key(f, &stream);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack, "Only can match on VID, PCP, and dest MAC");
+		return ret;
+	}
+
+	if (!flow_action_basic_hw_stats_check(&f->rule->action,
+					      f->common.extack))
+		return -EOPNOTSUPP;
+
+	flow_action_for_each(i, a, &f->rule->action) {
+		switch (a->id) {
+		case FLOW_ACTION_GATE:
+			if (f->common.chain_index != OCELOT_PSFP_CHAIN) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Gate action only be offloaded to PSFP chain");
+				return -EOPNOTSUPP;
+			}
+
+			size = struct_size(sgi, entries, a->gate.num_entries);
+			sgi = kzalloc(size, GFP_KERNEL);
+			felix_parse_gate(a, sgi);
+			ret = felix_list_gate_add(ocelot, sgi);
+			if (ret) {
+				kfree(sgi);
+				return ret;
+			}
+
+			sfi.sg_valid = 1;
+			sfi.sgid = sgi->index;
+			stream.sfid_valid = 1;
+			kfree(sgi);
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	/* Check if stream is set. */
+	ret = felix_list_stream_lookup(&stream);
+	if (!ret) {
+		if (sfi.sg_valid)
+			felix_list_gate_del(ocelot, sfi.sgid);
+
+		NL_SET_ERR_MSG_MOD(extack, "This stream is already added");
+
+		return -EEXIST;
+	}
+
+	if (stream.sfid_valid)
+		return felix_psfp_set(ocelot, &stream, &sfi, extack);
+
+	return -EOPNOTSUPP;
+}
+
+int felix_flower_stream_destroy(struct ocelot *ocelot, int port,
+				struct flow_cls_offload *f, bool ingress)
+{
+	return felix_list_stream_del(ocelot, f->cookie);
+}
+
+int felix_flower_stream_stats(struct ocelot *ocelot, int port,
+			      struct flow_cls_offload *f, bool ingress)
+{
+	struct felix_psfp_stream_counters counters;
+	struct felix_streamid *stream;
+	struct flow_stats stats;
+
+	stream = felix_list_stream_get(f->cookie);
+	if (!stream)
+		return -ENOENT;
+
+	felix_stream_counters_get(ocelot, stream->sfid, &counters);
+	stats.pkts = counters.match;
+
+	flow_stats_update(&f->stats, 0x0, stats.pkts, 0x0, 0,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
+
+	return 0;
+}
+
+void felix_psfp_init(struct ocelot *ocelot)
+{
+	INIT_LIST_HEAD(&lpsfp.stream_list);
+	INIT_LIST_HEAD(&lpsfp.gate_list);
+	INIT_LIST_HEAD(&lpsfp.sfi_list);
+}
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3e925b8d5306..f171e6f3fc98 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -931,6 +931,8 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	/* enable switch core */
 	ocelot_field_write(ocelot, SYS_RESET_CFG_CORE_ENA, 1);
 
+	felix_psfp_init(ocelot);
+
 	return 0;
 }
 
@@ -1150,9 +1152,8 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG, port);
 }
 
-static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
-				  u64 cycle_time,
-				  struct timespec64 *new_base_ts)
+void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
+			   u64 cycle_time, struct timespec64 *new_base_ts)
 {
 	struct timespec64 ts;
 	ktime_t new_base_time;
@@ -1370,6 +1371,9 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.xmit_template_populate	= vsc9959_xmit_template_populate,
+	.flower_replace		= felix_flower_stream_replace,
+	.flower_destroy		= felix_flower_stream_destroy,
+	.flower_stats		= felix_flower_stream_stats,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/include/soc/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.h
index 1669481d9779..c5a0b7174518 100644
--- a/include/soc/mscc/ocelot_ana.h
+++ b/include/soc/mscc/ocelot_ana.h
@@ -227,6 +227,11 @@
 #define ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(x)             ((x) & GENMASK(1, 0))
 #define ANA_TABLES_SFIDACCESS_SFID_TBL_CMD_M              GENMASK(1, 0)
 
+#define SFIDACCESS_CMD_IDLE                             0
+#define SFIDACCESS_CMD_READ                             1
+#define SFIDACCESS_CMD_WRITE                            2
+#define SFIDACCESS_CMD_INIT				3
+
 #define ANA_TABLES_SFIDTIDX_SGID_VALID                    BIT(26)
 #define ANA_TABLES_SFIDTIDX_SGID(x)                       (((x) << 18) & GENMASK(25, 18))
 #define ANA_TABLES_SFIDTIDX_SGID_M                        GENMASK(25, 18)
@@ -255,6 +260,11 @@
 #define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) & GENMASK(24, 21))
 #define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21)
 #define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMASK(24, 21)) >> 21)
+#define ANA_SG_CONFIG_REG_3_IPV_VALID                     BIT(24)
+#define ANA_SG_CONFIG_REG_3_IPV_INVALID(x)		  (((x) << 24) & GENMASK(24, 24))
+#define ANA_SG_CONFIG_REG_3_INIT_IPV(x)                   (((x) << 21) & GENMASK(23, 21))
+#define ANA_SG_CONFIG_REG_3_INIT_IPV_M                    GENMASK(23, 21)
+#define ANA_SG_CONFIG_REG_3_INIT_IPV_X(x)                 (((x) & GENMASK(23, 21)) >> 21)
 #define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
 
 #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
-- 
2.17.1

