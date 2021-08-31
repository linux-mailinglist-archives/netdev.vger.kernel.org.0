Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F83FC199
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 05:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhHaDgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 23:36:46 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41574 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhHaDgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 23:36:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BA4D31A2574;
        Tue, 31 Aug 2021 05:35:16 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 55C561A2557;
        Tue, 31 Aug 2021 05:35:16 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 3D468183AD05;
        Tue, 31 Aug 2021 11:35:14 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: [PATCH v3 net-next 6/8] net: dsa: felix: add stream gate settings for psfp
Date:   Tue, 31 Aug 2021 11:45:34 +0800
Message-Id: <20210831034536.17497-7-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds stream gate settings for PSFP. Use SGI table to store
stream gate entries. Disable the gate entry when it is not used by any
stream.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 205 ++++++++++++++++++++++++-
 1 file changed, 201 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3dbc4e991748..103f67736638 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -8,6 +8,7 @@
 #include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
+#include <net/tc_act/tc_gate.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/pcs-lynx.h>
@@ -1341,6 +1342,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 #define VSC9959_PSFP_SFID_MAX			175
 #define VSC9959_PSFP_GATE_ID_MAX		183
 #define VSC9959_PSFP_POLICER_MAX		383
+#define VSC9959_PSFP_GATE_LIST_NUM		4
+#define VSC9959_PSFP_GATE_CYCLETIME_MIN		5000
 
 struct felix_stream {
 	struct list_head list;
@@ -1373,6 +1376,24 @@ struct felix_stream_filter_counters {
 	u32 red;
 };
 
+struct felix_stream_gate {
+	u32 index;
+	u8 enable;
+	u8 ipv_valid;
+	u8 init_ipv;
+	u64 basetime;
+	u64 cycletime;
+	u64 cycletime_ext;
+	u32 num_entries;
+	struct action_gate_entry entries[0];
+};
+
+struct felix_stream_gate_entry {
+	struct list_head list;
+	refcount_t refcount;
+	u32 index;
+};
+
 static int vsc9959_stream_identify(struct flow_cls_offload *f,
 				   struct felix_stream *stream)
 {
@@ -1646,6 +1667,152 @@ static void vsc9959_psfp_sfi_table_del(struct ocelot *ocelot, u32 index)
 		}
 }
 
+static void vsc9959_psfp_parse_gate(const struct flow_action_entry *entry,
+				    struct felix_stream_gate *sgi)
+{
+	sgi->index = entry->gate.index;
+	sgi->ipv_valid = (entry->gate.prio < 0) ? 0 : 1;
+	sgi->init_ipv = (sgi->ipv_valid) ? entry->gate.prio : 0;
+	sgi->basetime = entry->gate.basetime;
+	sgi->cycletime = entry->gate.cycletime;
+	sgi->num_entries = entry->gate.num_entries;
+	sgi->enable = 1;
+
+	memcpy(sgi->entries, entry->gate.entries,
+	       entry->gate.num_entries * sizeof(struct action_gate_entry));
+}
+
+static u32 vsc9959_sgi_cfg_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, ANA_SG_ACCESS_CTRL);
+}
+
+static int vsc9959_psfp_sgi_set(struct ocelot *ocelot,
+				struct felix_stream_gate *sgi)
+{
+	struct action_gate_entry *e;
+	struct timespec64 base_ts;
+	u32 interval_sum = 0;
+	u32 val;
+	int i;
+
+	if (sgi->index > VSC9959_PSFP_GATE_ID_MAX)
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
+	if (sgi->cycletime < VSC9959_PSFP_GATE_CYCLETIME_MIN ||
+	    sgi->cycletime > NSEC_PER_SEC)
+		return -EINVAL;
+
+	if (sgi->num_entries > VSC9959_PSFP_GATE_LIST_NUM)
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
+	return readx_poll_timeout(vsc9959_sgi_cfg_status, ocelot, val,
+				  (!(ANA_SG_ACCESS_CTRL_CONFIG_CHANGE & val)),
+				  10, 100000);
+}
+
+static int vsc9959_psfp_sgi_table_add(struct ocelot *ocelot,
+				      struct felix_stream_gate *sgi)
+{
+	struct felix_stream_gate_entry *tmp;
+	struct ocelot_psfp_list *psfp;
+	int ret;
+
+	psfp = &ocelot->psfp;
+
+	list_for_each_entry(tmp, &psfp->sgi_list, list)
+		if (tmp->index == sgi->index) {
+			refcount_inc(&tmp->refcount);
+			return 0;
+		}
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	ret = vsc9959_psfp_sgi_set(ocelot, sgi);
+	if (ret) {
+		kfree(tmp);
+		return ret;
+	}
+
+	tmp->index = sgi->index;
+	refcount_set(&tmp->refcount, 1);
+	list_add_tail(&tmp->list, &psfp->sgi_list);
+
+	return 0;
+}
+
+static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
+				       u32 index)
+{
+	struct felix_stream_gate_entry *tmp, *n;
+	struct felix_stream_gate sgi = {0};
+	struct ocelot_psfp_list *psfp;
+	u8 z;
+
+	psfp = &ocelot->psfp;
+
+	list_for_each_entry_safe(tmp, n, &psfp->sgi_list, list)
+		if (tmp->index == index) {
+			z = refcount_dec_and_test(&tmp->refcount);
+			if (z) {
+				sgi.index = index;
+				sgi.enable = 0;
+				vsc9959_psfp_sgi_set(ocelot, &sgi);
+				list_del(&tmp->list);
+				kfree(tmp);
+			}
+			break;
+		}
+}
+
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
@@ -1672,8 +1839,9 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 	struct felix_stream_filter sfi = {0};
 	const struct flow_action_entry *a;
 	struct felix_stream stream = {0};
+	struct felix_stream_gate *sgi;
 	struct ocelot_psfp_list *psfp;
-	int ret, i;
+	int ret, i, size;
 
 	psfp = &ocelot->psfp;
 
@@ -1686,6 +1854,18 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_GATE:
+			size = struct_size(sgi, entries, a->gate.num_entries);
+			sgi = kzalloc(size, GFP_KERNEL);
+			vsc9959_psfp_parse_gate(a, sgi);
+			ret = vsc9959_psfp_sgi_table_add(ocelot, sgi);
+			if (ret) {
+				kfree(sgi);
+				return ret;
+			}
+			sfi.sg_valid = 1;
+			sfi.sgid = sgi->index;
+			kfree(sgi);
+			break;
 		case FLOW_ACTION_POLICE:
 		default:
 			return -EOPNOTSUPP;
@@ -1696,7 +1876,8 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 	ret = vsc9959_stream_table_lookup(&psfp->stream_list, &stream);
 	if (ret) {
 		NL_SET_ERR_MSG_MOD(extack, "This stream is already added");
-		return -EEXIST;
+		ret = -EEXIST;
+		goto err;
 	}
 
 	sfi.prio_valid = (stream.prio < 0 ? 0 : 1);
@@ -1705,14 +1886,22 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 
 	ret = vsc9959_psfp_sfi_table_add(ocelot, &sfi);
 	if (ret)
-		return ret;
+		goto err;
 
 	stream.sfid = sfi.index;
 	stream.sfid_valid = 1;
 	ret = vsc9959_stream_table_add(ocelot, &psfp->stream_list,
 				       &stream, extack);
-	if (ret)
+	if (ret) {
 		vsc9959_psfp_sfi_table_del(ocelot, stream.sfid);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	if (sfi.sg_valid)
+		vsc9959_psfp_sgi_table_del(ocelot, sfi.sgid);
 
 	return ret;
 }
@@ -1720,6 +1909,7 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 				   struct flow_cls_offload *f)
 {
+	static struct felix_stream_filter *sfi;
 	struct ocelot_psfp_list *psfp;
 	struct felix_stream *stream;
 
@@ -1729,6 +1919,13 @@ static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 	if (!stream)
 		return -ENOMEM;
 
+	sfi = vsc9959_psfp_sfi_table_get(&psfp->sfi_list, stream->sfid);
+	if (!sfi)
+		return -ENOMEM;
+
+	if (sfi->sg_valid)
+		vsc9959_psfp_sgi_table_del(ocelot, sfi->sgid);
+
 	vsc9959_psfp_sfi_table_del(ocelot, stream->sfid);
 
 	stream->sfid_valid = 0;
-- 
2.17.1

