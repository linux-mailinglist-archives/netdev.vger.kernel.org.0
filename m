Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F557455888
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbhKRKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:04:34 -0500
Received: from inva020.nxp.com ([92.121.34.13]:38326 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245424AbhKRKDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:03:06 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E8F691A32EC;
        Thu, 18 Nov 2021 11:00:04 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8242E1A32BE;
        Thu, 18 Nov 2021 11:00:04 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 84C9C183F0CB;
        Thu, 18 Nov 2021 18:00:02 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Subject: [PATCH v7 net-next 8/8] net: dsa: felix: restrict psfp rules on ingress port
Date:   Thu, 18 Nov 2021 18:12:04 +0800
Message-Id: <20211118101204.4338-9-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PSFP rules take effect on the streams from any port of VSC9959 switch.
This patch use ingress port to limit the rule only active on this port.

Each stream can only match two ingress source ports in VSC9959. Streams
from lowest port gets the configuration of SFID pointed by MAC Table
lookup and streams from highest port gets the configuration of (SFID+1)
pointed by MAC Table lookup. This patch defines the PSFP rule on highest
port as dummy rule, which means that it does not modify the MAC table.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 190 ++++++++++++++++++----
 drivers/net/ethernet/mscc/ocelot_flower.c |   2 +-
 include/soc/mscc/ocelot.h                 |   3 +-
 3 files changed, 163 insertions(+), 32 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index eb6c05f29883..42ac1952b39a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1349,6 +1349,9 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 struct felix_stream {
 	struct list_head list;
 	unsigned long id;
+	bool dummy;
+	int ports;
+	int port;
 	u8 dmac[ETH_ALEN];
 	u16 vid;
 	s8 prio;
@@ -1363,6 +1366,7 @@ struct felix_stream_filter {
 	refcount_t refcount;
 	u32 index;
 	u8 enable;
+	int portmask;
 	u8 sg_valid;
 	u32 sgid;
 	u8 fm_valid;
@@ -1505,10 +1509,12 @@ static int vsc9959_stream_table_add(struct ocelot *ocelot,
 
 	memcpy(stream_entry, stream, sizeof(*stream_entry));
 
-	ret = vsc9959_mact_stream_set(ocelot, stream_entry, extack);
-	if (ret) {
-		kfree(stream_entry);
-		return ret;
+	if (!stream->dummy) {
+		ret = vsc9959_mact_stream_set(ocelot, stream_entry, extack);
+		if (ret) {
+			kfree(stream_entry);
+			return ret;
+		}
 	}
 
 	list_add_tail(&stream_entry->list, stream_list);
@@ -1531,7 +1537,8 @@ vsc9959_stream_table_get(struct list_head *stream_list, unsigned long id)
 static void vsc9959_stream_table_del(struct ocelot *ocelot,
 				     struct felix_stream *stream)
 {
-	vsc9959_mact_stream_set(ocelot, stream, NULL);
+	if (!stream->dummy)
+		vsc9959_mact_stream_set(ocelot, stream, NULL);
 
 	list_del(&stream->list);
 	kfree(stream);
@@ -1586,14 +1593,64 @@ static int vsc9959_psfp_sfi_set(struct ocelot *ocelot,
 				  10, 100000);
 }
 
+static int vsc9959_psfp_sfidmask_set(struct ocelot *ocelot, u32 sfid, int ports)
+{
+	u32 val;
+
+	ocelot_rmw(ocelot,
+		   ANA_TABLES_SFIDTIDX_SFID_INDEX(sfid),
+		   ANA_TABLES_SFIDTIDX_SFID_INDEX_M,
+		   ANA_TABLES_SFIDTIDX);
+
+	ocelot_write(ocelot,
+		     ANA_TABLES_SFID_MASK_IGR_PORT_MASK(ports) |
+		     ANA_TABLES_SFID_MASK_IGR_SRCPORT_MATCH_ENA,
+		     ANA_TABLES_SFID_MASK);
+
+	ocelot_rmw(ocelot,
+		   ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE),
+		   ANA_TABLES_SFIDACCESS_SFID_TBL_CMD_M,
+		   ANA_TABLES_SFIDACCESS);
+
+	return readx_poll_timeout(vsc9959_sfi_access_status, ocelot, val,
+				  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
+				  10, 100000);
+}
+
+static int vsc9959_psfp_sfi_list_add(struct ocelot *ocelot,
+				     struct felix_stream_filter *sfi,
+				     struct list_head *pos)
+{
+	struct felix_stream_filter *sfi_entry;
+	int ret;
+
+	sfi_entry = kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
+	if (!sfi_entry)
+		return -ENOMEM;
+
+	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
+	refcount_set(&sfi_entry->refcount, 1);
+
+	ret = vsc9959_psfp_sfi_set(ocelot, sfi_entry);
+	if (ret) {
+		kfree(sfi_entry);
+		return ret;
+	}
+
+	vsc9959_psfp_sfidmask_set(ocelot, sfi->index, sfi->portmask);
+
+	list_add(&sfi_entry->list, pos);
+
+	return 0;
+}
+
 static int vsc9959_psfp_sfi_table_add(struct ocelot *ocelot,
 				      struct felix_stream_filter *sfi)
 {
-	struct felix_stream_filter *sfi_entry, *tmp;
 	struct list_head *pos, *q, *last;
+	struct felix_stream_filter *tmp;
 	struct ocelot_psfp_list *psfp;
 	u32 insert = 0;
-	int ret;
 
 	psfp = &ocelot->psfp;
 	last = &psfp->sfi_list;
@@ -1602,6 +1659,7 @@ static int vsc9959_psfp_sfi_table_add(struct ocelot *ocelot,
 		tmp = list_entry(pos, struct felix_stream_filter, list);
 		if (sfi->sg_valid == tmp->sg_valid &&
 		    sfi->fm_valid == tmp->fm_valid &&
+		    sfi->portmask == tmp->portmask &&
 		    tmp->sgid == sfi->sgid &&
 		    tmp->fmid == sfi->fmid) {
 			sfi->index = tmp->index;
@@ -1616,22 +1674,40 @@ static int vsc9959_psfp_sfi_table_add(struct ocelot *ocelot,
 	}
 	sfi->index = insert;
 
-	sfi_entry = kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
-	if (!sfi_entry)
-		return -ENOMEM;
+	return vsc9959_psfp_sfi_list_add(ocelot, sfi, last);
+}
 
-	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
-	refcount_set(&sfi_entry->refcount, 1);
+static int vsc9959_psfp_sfi_table_add2(struct ocelot *ocelot,
+				       struct felix_stream_filter *sfi,
+				       struct felix_stream_filter *sfi2)
+{
+	struct felix_stream_filter *tmp;
+	struct list_head *pos, *q, *last;
+	struct ocelot_psfp_list *psfp;
+	u32 insert = 0;
+	int ret;
 
-	ret = vsc9959_psfp_sfi_set(ocelot, sfi_entry);
-	if (ret) {
-		kfree(sfi_entry);
-		return ret;
+	psfp = &ocelot->psfp;
+	last = &psfp->sfi_list;
+
+	list_for_each_safe(pos, q, &psfp->sfi_list) {
+		tmp = list_entry(pos, struct felix_stream_filter, list);
+		/* Make sure that the index is increasing in order. */
+		if (tmp->index >= insert + 2)
+			break;
+
+		insert = tmp->index + 1;
+		last = pos;
 	}
+	sfi->index = insert;
+
+	ret = vsc9959_psfp_sfi_list_add(ocelot, sfi, last);
+	if (ret)
+		return ret;
 
-	list_add(&sfi_entry->list, last);
+	sfi2->index = insert + 1;
 
-	return 0;
+	return vsc9959_psfp_sfi_list_add(ocelot, sfi2, last->next);
 }
 
 static struct felix_stream_filter *
@@ -1832,10 +1908,11 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		     SYS_STAT_CFG);
 }
 
-static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
+static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 				   struct flow_cls_offload *f)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
+	struct felix_stream_filter old_sfi, *sfi_entry;
 	struct felix_stream_filter sfi = {0};
 	const struct flow_action_entry *a;
 	struct felix_stream *stream_entry;
@@ -1896,21 +1973,61 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 		}
 	}
 
-	/* Check if stream is set. */
-	stream_entry = vsc9959_stream_table_lookup(&psfp->stream_list, &stream);
-	if (stream_entry) {
-		NL_SET_ERR_MSG_MOD(extack, "This stream is already added");
-		ret = -EEXIST;
-		goto err;
-	}
+	stream.ports = BIT(port);
+	stream.port = port;
 
+	sfi.portmask = stream.ports;
 	sfi.prio_valid = (stream.prio < 0 ? 0 : 1);
 	sfi.prio = (sfi.prio_valid ? stream.prio : 0);
 	sfi.enable = 1;
 
-	ret = vsc9959_psfp_sfi_table_add(ocelot, &sfi);
-	if (ret)
-		goto err;
+	/* Check if stream is set. */
+	stream_entry = vsc9959_stream_table_lookup(&psfp->stream_list, &stream);
+	if (stream_entry) {
+		if (stream_entry->ports & BIT(port)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The stream is added on this port");
+			ret = -EEXIST;
+			goto err;
+		}
+
+		if (stream_entry->ports != BIT(stream_entry->port)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The stream is added on two ports");
+			ret = -EEXIST;
+			goto err;
+		}
+
+		stream_entry->ports |= BIT(port);
+		stream.ports = stream_entry->ports;
+
+		sfi_entry = vsc9959_psfp_sfi_table_get(&psfp->sfi_list,
+						       stream_entry->sfid);
+		memcpy(&old_sfi, sfi_entry, sizeof(old_sfi));
+
+		vsc9959_psfp_sfi_table_del(ocelot, stream_entry->sfid);
+
+		old_sfi.portmask = stream_entry->ports;
+		sfi.portmask = stream.ports;
+
+		if (stream_entry->port > port) {
+			ret = vsc9959_psfp_sfi_table_add2(ocelot, &sfi,
+							  &old_sfi);
+			stream_entry->dummy = true;
+		} else {
+			ret = vsc9959_psfp_sfi_table_add2(ocelot, &old_sfi,
+							  &sfi);
+			stream.dummy = true;
+		}
+		if (ret)
+			goto err;
+
+		stream_entry->sfid = old_sfi.index;
+	} else {
+		ret = vsc9959_psfp_sfi_table_add(ocelot, &sfi);
+		if (ret)
+			goto err;
+	}
 
 	stream.sfid = sfi.index;
 	stream.sfid_valid = 1;
@@ -1936,9 +2053,9 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
 static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 				   struct flow_cls_offload *f)
 {
+	struct felix_stream *stream, tmp, *stream_entry;
 	static struct felix_stream_filter *sfi;
 	struct ocelot_psfp_list *psfp;
-	struct felix_stream *stream;
 
 	psfp = &ocelot->psfp;
 
@@ -1958,9 +2075,22 @@ static int vsc9959_psfp_filter_del(struct ocelot *ocelot,
 
 	vsc9959_psfp_sfi_table_del(ocelot, stream->sfid);
 
+	memcpy(&tmp, stream, sizeof(tmp));
+
 	stream->sfid_valid = 0;
 	vsc9959_stream_table_del(ocelot, stream);
 
+	stream_entry = vsc9959_stream_table_lookup(&psfp->stream_list, &tmp);
+	if (stream_entry) {
+		stream_entry->ports = BIT(stream_entry->port);
+		if (stream_entry->dummy) {
+			stream_entry->dummy = false;
+			vsc9959_mact_stream_set(ocelot, stream_entry, NULL);
+		}
+		vsc9959_psfp_sfidmask_set(ocelot, stream_entry->sfid,
+					  stream_entry->ports);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b54b52fd9e1b..58fce173f95b 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -837,7 +837,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 	if (filter->type == OCELOT_PSFP_FILTER_OFFLOAD) {
 		kfree(filter);
 		if (ocelot->ops->psfp_filter_add)
-			return ocelot->ops->psfp_filter_add(ocelot, f);
+			return ocelot->ops->psfp_filter_add(ocelot, port, f);
 
 		NL_SET_ERR_MSG_MOD(extack, "PSFP chain is not supported in HW");
 		return -EOPNOTSUPP;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2a41685b5c7d..89d17629efe5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -556,7 +556,8 @@ struct ocelot_ops {
 	u16 (*wm_dec)(u16 value);
 	void (*wm_stat)(u32 val, u32 *inuse, u32 *maxuse);
 	void (*psfp_init)(struct ocelot *ocelot);
-	int (*psfp_filter_add)(struct ocelot *ocelot, struct flow_cls_offload *f);
+	int (*psfp_filter_add)(struct ocelot *ocelot, int port,
+			       struct flow_cls_offload *f);
 	int (*psfp_filter_del)(struct ocelot *ocelot, struct flow_cls_offload *f);
 	int (*psfp_stats_get)(struct ocelot *ocelot, struct flow_cls_offload *f,
 			      struct flow_stats *stats);
-- 
2.17.1

