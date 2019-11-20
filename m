Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09D1030B2
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKTAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:25:04 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:12106 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbfKTAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:25:03 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAK0OsfP028458;
        Tue, 19 Nov 2019 16:24:55 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@resnulli.us, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v5 1/3] cxgb4: add TC-MATCHALL classifier egress offload
Date:   Wed, 20 Nov 2019 05:46:06 +0530
Message-Id: <436d2b700038326a5f64d96ddc9bc146ca1e58e4.1574176510.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add TC-MATCHALL classifier offload with TC-POLICE action applied for
all outgoing traffic on the underlying interface. Split flow block
offload to support both egress and ingress classification.

For example, to rate limit all outgoing traffic to 1 Gbps:

$ tc qdisc add dev enp2s0f4 clsact
$ tc filter add dev enp2s0f4 egress matchall skip_sw \
	action police rate 1Gbit burst 8Kbit

Note that skip_sw is important. Otherwise, both stack and hardware
will end up doing policing. Policing can't be shared across flow
blocks. Only 1 egress matchall rule can be active at a time on the
underlying interface.

v5:
- No change.

v4:
- Removed check to reject police offload if prio is not 1.
- Moved TC_SETUP_BLOCK code to separate function.

v3:
- Added check to reject police offload if prio is not 1.
- Assign block_shared variable only for TC_SETUP_BLOCK.

v2:
- Added check to reject flow block sharing for policers.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   6 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  84 ++++++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 213 ++++++++++++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  35 +++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  56 +++--
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  11 +-
 9 files changed, 381 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h

diff --git a/drivers/net/ethernet/chelsio/cxgb4/Makefile b/drivers/net/ethernet/chelsio/cxgb4/Makefile
index 49a19308073b..a4b4d475abf8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/Makefile
+++ b/drivers/net/ethernet/chelsio/cxgb4/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_CHELSIO_T4) += cxgb4.o
 cxgb4-objs := cxgb4_main.o l2t.o smt.o t4_hw.o sge.o clip_tbl.o cxgb4_ethtool.o \
 	      cxgb4_uld.o srq.o sched.o cxgb4_filter.o cxgb4_tc_u32.o \
 	      cxgb4_ptp.o cxgb4_tc_flower.o cxgb4_cudbg.o cxgb4_mps.o \
-	      cudbg_common.o cudbg_lib.o cudbg_zlib.o cxgb4_tc_mqprio.o
+	      cudbg_common.o cudbg_lib.o cudbg_zlib.o cxgb4_tc_mqprio.o \
+	      cxgb4_tc_matchall.o
 cxgb4-$(CONFIG_CHELSIO_T4_DCB) +=  cxgb4_dcb.o
 cxgb4-$(CONFIG_CHELSIO_T4_FCOE) +=  cxgb4_fcoe.o
 cxgb4-$(CONFIG_DEBUG_FS) += cxgb4_debugfs.o
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 1fb273b294a1..9376be6e51a3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -603,6 +603,8 @@ struct port_info {
 	u8 vivld;
 	u8 smt_idx;
 	u8 rx_cchan;
+
+	bool tc_block_shared;
 };
 
 struct dentry;
@@ -1101,6 +1103,9 @@ struct adapter {
 
 	/* TC MQPRIO offload */
 	struct cxgb4_tc_mqprio *tc_mqprio;
+
+	/* TC MATCHALL classifier offload */
+	struct cxgb4_tc_matchall *tc_matchall;
 };
 
 /* Support for "sched-class" command to allow a TX Scheduling Class to be
@@ -1130,6 +1135,7 @@ enum {
 
 enum {
 	SCHED_CLASS_LEVEL_CL_RL = 0,    /* class rate limiter */
+	SCHED_CLASS_LEVEL_CH_RL = 2,    /* channel rate limiter */
 };
 
 enum {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index b5148c57e8bf..f04f9c858d52 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -84,6 +84,7 @@
 #include "cxgb4_tc_u32.h"
 #include "cxgb4_tc_flower.h"
 #include "cxgb4_tc_mqprio.h"
+#include "cxgb4_tc_matchall.h"
 #include "cxgb4_ptp.h"
 #include "cxgb4_cudbg.h"
 
@@ -3234,8 +3235,28 @@ static int cxgb_setup_tc_cls_u32(struct net_device *dev,
 	}
 }
 
-static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
-				  void *cb_priv)
+static int cxgb_setup_tc_matchall(struct net_device *dev,
+				  struct tc_cls_matchall_offload *cls_matchall)
+{
+	struct adapter *adap = netdev2adap(dev);
+
+	if (!adap->tc_matchall)
+		return -ENOMEM;
+
+	switch (cls_matchall->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return cxgb4_tc_matchall_replace(dev, cls_matchall);
+	case TC_CLSMATCHALL_DESTROY:
+		return cxgb4_tc_matchall_destroy(dev, cls_matchall);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int cxgb_setup_tc_block_ingress_cb(enum tc_setup_type type,
+					  void *type_data, void *cb_priv)
 {
 	struct net_device *dev = cb_priv;
 	struct port_info *pi = netdev2pinfo(dev);
@@ -3261,6 +3282,33 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static int cxgb_setup_tc_block_egress_cb(enum tc_setup_type type,
+					 void *type_data, void *cb_priv)
+{
+	struct net_device *dev = cb_priv;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	if (!(adap->flags & CXGB4_FULL_INIT_DONE)) {
+		dev_err(adap->pdev_dev,
+			"Failed to setup tc on port %d. Link Down?\n",
+			pi->port_id);
+		return -EINVAL;
+	}
+
+	if (!tc_cls_can_offload_and_chain0(dev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return cxgb_setup_tc_matchall(dev, type_data);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int cxgb_setup_tc_mqprio(struct net_device *dev,
 				struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -3274,19 +3322,34 @@ static int cxgb_setup_tc_mqprio(struct net_device *dev,
 
 static LIST_HEAD(cxgb_block_cb_list);
 
+static int cxgb_setup_tc_block(struct net_device *dev,
+			       struct flow_block_offload *f)
+{
+	struct port_info *pi = netdev_priv(dev);
+	flow_setup_cb_t *cb;
+	bool ingress_only;
+
+	pi->tc_block_shared = f->block_shared;
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+		cb = cxgb_setup_tc_block_egress_cb;
+		ingress_only = false;
+	} else {
+		cb = cxgb_setup_tc_block_ingress_cb;
+		ingress_only = true;
+	}
+
+	return flow_block_cb_setup_simple(f, &cxgb_block_cb_list,
+					  cb, pi, dev, ingress_only);
+}
+
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
-	struct port_info *pi = netdev2pinfo(dev);
-
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return cxgb_setup_tc_mqprio(dev, type_data);
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data,
-						  &cxgb_block_cb_list,
-						  cxgb_setup_tc_block_cb,
-						  pi, dev, true);
+		return cxgb_setup_tc_block(dev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -5741,6 +5804,7 @@ static void free_some_resources(struct adapter *adapter)
 	kvfree(adapter->srq);
 	t4_cleanup_sched(adapter);
 	kvfree(adapter->tids.tid_tab);
+	cxgb4_cleanup_tc_matchall(adapter);
 	cxgb4_cleanup_tc_mqprio(adapter);
 	cxgb4_cleanup_tc_flower(adapter);
 	cxgb4_cleanup_tc_u32(adapter);
@@ -6315,6 +6379,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (cxgb4_init_tc_mqprio(adapter))
 			dev_warn(&pdev->dev,
 				 "could not offload tc mqprio, continuing\n");
+
+		if (cxgb4_init_tc_matchall(adapter))
+			dev_warn(&pdev->dev,
+				 "could not offload tc matchall, continuing\n");
 	}
 
 	if (is_offload(adapter) || is_hashfilter(adapter)) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
new file mode 100644
index 000000000000..85bf0a238a49
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2019 Chelsio Communications.  All rights reserved. */
+
+#include "cxgb4.h"
+#include "cxgb4_tc_matchall.h"
+#include "sched.h"
+
+static int cxgb4_matchall_egress_validate(struct net_device *dev,
+					  struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct flow_action *actions = &cls->rule->action;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct flow_action_entry *entry;
+	u64 max_link_rate;
+	u32 i, speed;
+	int ret;
+
+	if (!flow_action_has_entries(actions)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress MATCHALL offload needs at least 1 policing action");
+		return -EINVAL;
+	} else if (!flow_offload_has_one_action(actions)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress MATCHALL offload only supports 1 policing action");
+		return -EINVAL;
+	} else if (pi->tc_block_shared) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress MATCHALL offload not supported with shared blocks");
+		return -EINVAL;
+	}
+
+	ret = t4_get_link_params(pi, NULL, &speed, NULL);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to get max speed supported by the link");
+		return -EINVAL;
+	}
+
+	/* Convert from Mbps to bps */
+	max_link_rate = (u64)speed * 1000 * 1000;
+
+	flow_action_for_each(i, entry, actions) {
+		switch (entry->id) {
+		case FLOW_ACTION_POLICE:
+			/* Convert bytes per second to bits per second */
+			if (entry->police.rate_bytes_ps * 8 > max_link_rate) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Specified policing max rate is larger than underlying link speed");
+				return -ERANGE;
+			}
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only policing action supported with Egress MATCHALL offload");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int cxgb4_matchall_alloc_tc(struct net_device *dev,
+				   struct tc_cls_matchall_offload *cls)
+{
+	struct ch_sched_params p = {
+		.type = SCHED_CLASS_TYPE_PACKET,
+		.u.params.level = SCHED_CLASS_LEVEL_CH_RL,
+		.u.params.mode = SCHED_CLASS_MODE_CLASS,
+		.u.params.rateunit = SCHED_CLASS_RATEUNIT_BITS,
+		.u.params.ratemode = SCHED_CLASS_RATEMODE_ABS,
+		.u.params.class = SCHED_CLS_NONE,
+		.u.params.minrate = 0,
+		.u.params.weight = 0,
+		.u.params.pktsize = dev->mtu,
+	};
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct flow_action_entry *entry;
+	struct sched_class *e;
+	u32 i;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+
+	flow_action_for_each(i, entry, &cls->rule->action)
+		if (entry->id == FLOW_ACTION_POLICE)
+			break;
+
+	/* Convert from bytes per second to Kbps */
+	p.u.params.maxrate = div_u64(entry->police.rate_bytes_ps * 8, 1000);
+	p.u.params.channel = pi->tx_chan;
+	e = cxgb4_sched_class_alloc(dev, &p);
+	if (!e) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "No free traffic class available for policing action");
+		return -ENOMEM;
+	}
+
+	tc_port_matchall->egress.hwtc = e->idx;
+	tc_port_matchall->egress.cookie = cls->cookie;
+	tc_port_matchall->egress.state = CXGB4_MATCHALL_STATE_ENABLED;
+	return 0;
+}
+
+static void cxgb4_matchall_free_tc(struct net_device *dev)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	cxgb4_sched_class_free(dev, tc_port_matchall->egress.hwtc);
+
+	tc_port_matchall->egress.hwtc = SCHED_CLS_NONE;
+	tc_port_matchall->egress.cookie = 0;
+	tc_port_matchall->egress.state = CXGB4_MATCHALL_STATE_DISABLED;
+}
+
+int cxgb4_tc_matchall_replace(struct net_device *dev,
+			      struct tc_cls_matchall_offload *cls_matchall)
+{
+	struct netlink_ext_ack *extack = cls_matchall->common.extack;
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	int ret;
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (tc_port_matchall->egress.state == CXGB4_MATCHALL_STATE_ENABLED) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only 1 Egress MATCHALL can be offloaded");
+		return -ENOMEM;
+	}
+
+	ret = cxgb4_matchall_egress_validate(dev, cls_matchall);
+	if (ret)
+		return ret;
+
+	return cxgb4_matchall_alloc_tc(dev, cls_matchall);
+}
+
+int cxgb4_tc_matchall_destroy(struct net_device *dev,
+			      struct tc_cls_matchall_offload *cls_matchall)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (cls_matchall->cookie != tc_port_matchall->egress.cookie)
+		return -ENOENT;
+
+	cxgb4_matchall_free_tc(dev);
+	return 0;
+}
+
+static void cxgb4_matchall_disable_offload(struct net_device *dev)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+
+	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	if (tc_port_matchall->egress.state == CXGB4_MATCHALL_STATE_ENABLED)
+		cxgb4_matchall_free_tc(dev);
+}
+
+int cxgb4_init_tc_matchall(struct adapter *adap)
+{
+	struct cxgb4_tc_port_matchall *tc_port_matchall;
+	struct cxgb4_tc_matchall *tc_matchall;
+	int ret;
+
+	tc_matchall = kzalloc(sizeof(*tc_matchall), GFP_KERNEL);
+	if (!tc_matchall)
+		return -ENOMEM;
+
+	tc_port_matchall = kcalloc(adap->params.nports,
+				   sizeof(*tc_port_matchall),
+				   GFP_KERNEL);
+	if (!tc_port_matchall) {
+		ret = -ENOMEM;
+		goto out_free_matchall;
+	}
+
+	tc_matchall->port_matchall = tc_port_matchall;
+	adap->tc_matchall = tc_matchall;
+	return 0;
+
+out_free_matchall:
+	kfree(tc_matchall);
+	return ret;
+}
+
+void cxgb4_cleanup_tc_matchall(struct adapter *adap)
+{
+	u8 i;
+
+	if (adap->tc_matchall) {
+		if (adap->tc_matchall->port_matchall) {
+			for (i = 0; i < adap->params.nports; i++) {
+				struct net_device *dev = adap->port[i];
+
+				if (dev)
+					cxgb4_matchall_disable_offload(dev);
+			}
+			kfree(adap->tc_matchall->port_matchall);
+		}
+		kfree(adap->tc_matchall);
+	}
+}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
new file mode 100644
index 000000000000..ce5b0800f0d8
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2019 Chelsio Communications.  All rights reserved. */
+
+#ifndef __CXGB4_TC_MATCHALL_H__
+#define __CXGB4_TC_MATCHALL_H__
+
+#include <net/pkt_cls.h>
+
+enum cxgb4_matchall_state {
+	CXGB4_MATCHALL_STATE_DISABLED = 0,
+	CXGB4_MATCHALL_STATE_ENABLED,
+};
+
+struct cxgb4_matchall_egress_entry {
+	enum cxgb4_matchall_state state; /* Current MATCHALL offload state */
+	u8 hwtc; /* Traffic class bound to port */
+	u64 cookie; /* Used to identify the MATCHALL rule offloaded */
+};
+
+struct cxgb4_tc_port_matchall {
+	struct cxgb4_matchall_egress_entry egress; /* Egress offload info */
+};
+
+struct cxgb4_tc_matchall {
+	struct cxgb4_tc_port_matchall *port_matchall; /* Per port entry */
+};
+
+int cxgb4_tc_matchall_replace(struct net_device *dev,
+			      struct tc_cls_matchall_offload *cls_matchall);
+int cxgb4_tc_matchall_destroy(struct net_device *dev,
+			      struct tc_cls_matchall_offload *cls_matchall);
+
+int cxgb4_init_tc_matchall(struct adapter *adap);
+void cxgb4_cleanup_tc_matchall(struct adapter *adap);
+#endif /* __CXGB4_TC_MATCHALL_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index ce442c63f496..db55673b77bd 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -11,8 +11,7 @@ static int cxgb4_mqprio_validate(struct net_device *dev,
 	u64 min_rate = 0, max_rate = 0, max_link_rate;
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
-	u32 qcount = 0, qoffset = 0;
-	u32 link_ok, speed, mtu;
+	u32 speed, qcount = 0, qoffset = 0;
 	int ret;
 	u8 i;
 
@@ -35,7 +34,7 @@ static int cxgb4_mqprio_validate(struct net_device *dev,
 		return -ERANGE;
 	}
 
-	ret = t4_get_link_params(pi, &link_ok, &speed, &mtu);
+	ret = t4_get_link_params(pi, NULL, &speed, NULL);
 	if (ret) {
 		netdev_err(dev, "Failed to get link speed, ret: %d\n", ret);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index 0a98c4dbb36b..3e61bd5d0c29 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -50,6 +50,7 @@ static int t4_sched_class_fw_cmd(struct port_info *pi,
 	e = &s->tab[p->u.params.class];
 	switch (op) {
 	case SCHED_FW_OP_ADD:
+	case SCHED_FW_OP_DEL:
 		err = t4_sched_params(adap, p->type,
 				      p->u.params.level, p->u.params.mode,
 				      p->u.params.rateunit,
@@ -188,10 +189,8 @@ static int t4_sched_queue_unbind(struct port_info *pi, struct ch_sched_queue *p)
 		e = &pi->sched_tbl->tab[qe->param.class];
 		list_del(&qe->list);
 		kvfree(qe);
-		if (atomic_dec_and_test(&e->refcnt)) {
-			e->state = SCHED_STATE_UNUSED;
-			memset(&e->info, 0, sizeof(e->info));
-		}
+		if (atomic_dec_and_test(&e->refcnt))
+			cxgb4_sched_class_free(adap->port[pi->port_id], e->idx);
 	}
 	return err;
 }
@@ -261,10 +260,8 @@ static int t4_sched_flowc_unbind(struct port_info *pi, struct ch_sched_flowc *p)
 		e = &pi->sched_tbl->tab[fe->param.class];
 		list_del(&fe->list);
 		kvfree(fe);
-		if (atomic_dec_and_test(&e->refcnt)) {
-			e->state = SCHED_STATE_UNUSED;
-			memset(&e->info, 0, sizeof(e->info));
-		}
+		if (atomic_dec_and_test(&e->refcnt))
+			cxgb4_sched_class_free(adap->port[pi->port_id], e->idx);
 	}
 	return err;
 }
@@ -469,10 +466,7 @@ static struct sched_class *t4_sched_class_lookup(struct port_info *pi,
 	struct sched_class *found = NULL;
 	struct sched_class *e, *end;
 
-	/* Only allow tc to be shared among SCHED_FLOWC types. For
-	 * other types, always allocate a new tc.
-	 */
-	if (!p || p->u.params.mode != SCHED_CLASS_MODE_FLOW) {
+	if (!p) {
 		/* Get any available unused class */
 		end = &s->tab[s->sched_size];
 		for (e = &s->tab[0]; e != end; ++e) {
@@ -514,7 +508,7 @@ static struct sched_class *t4_sched_class_lookup(struct port_info *pi,
 static struct sched_class *t4_sched_class_alloc(struct port_info *pi,
 						struct ch_sched_params *p)
 {
-	struct sched_class *e;
+	struct sched_class *e = NULL;
 	u8 class_id;
 	int err;
 
@@ -529,10 +523,13 @@ static struct sched_class *t4_sched_class_alloc(struct port_info *pi,
 	if (class_id != SCHED_CLS_NONE)
 		return NULL;
 
-	/* See if there's an exisiting class with same
-	 * requested sched params
+	/* See if there's an exisiting class with same requested sched
+	 * params. Classes can only be shared among FLOWC types. For
+	 * other types, always request a new class.
 	 */
-	e = t4_sched_class_lookup(pi, p);
+	if (p->u.params.mode == SCHED_CLASS_MODE_FLOW)
+		e = t4_sched_class_lookup(pi, p);
+
 	if (!e) {
 		struct ch_sched_params np;
 
@@ -592,10 +589,35 @@ void cxgb4_sched_class_free(struct net_device *dev, u8 classid)
 {
 	struct port_info *pi = netdev2pinfo(dev);
 	struct sched_table *s = pi->sched_tbl;
+	struct ch_sched_params p;
 	struct sched_class *e;
+	u32 speed;
+	int ret;
 
 	e = &s->tab[classid];
-	if (!atomic_read(&e->refcnt)) {
+	if (!atomic_read(&e->refcnt) && e->state != SCHED_STATE_UNUSED) {
+		/* Port based rate limiting needs explicit reset back
+		 * to max rate. But, we'll do explicit reset for all
+		 * types, instead of just port based type, to be on
+		 * the safer side.
+		 */
+		memcpy(&p, &e->info, sizeof(p));
+		/* Always reset mode to 0. Otherwise, FLOWC mode will
+		 * still be enabled even after resetting the traffic
+		 * class.
+		 */
+		p.u.params.mode = 0;
+		p.u.params.minrate = 0;
+		p.u.params.pktsize = 0;
+
+		ret = t4_get_link_params(pi, NULL, &speed, NULL);
+		if (!ret)
+			p.u.params.maxrate = speed * 1000; /* Mbps to Kbps */
+		else
+			p.u.params.maxrate = SCHED_MAX_RATE_KBPS;
+
+		t4_sched_class_fw_cmd(pi, &p, SCHED_FW_OP_DEL);
+
 		e->state = SCHED_STATE_UNUSED;
 		memset(&e->info, 0, sizeof(e->info));
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.h b/drivers/net/ethernet/chelsio/cxgb4/sched.h
index 80bed8e59362..e92ff68bdd0a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.h
@@ -52,6 +52,7 @@ enum {
 
 enum sched_fw_ops {
 	SCHED_FW_OP_ADD,
+	SCHED_FW_OP_DEL,
 };
 
 enum sched_bind_type {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index f2a7824da42b..19d18acfc9a6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -8777,8 +8777,8 @@ int t4_get_link_params(struct port_info *pi, unsigned int *link_okp,
 		       unsigned int *speedp, unsigned int *mtup)
 {
 	unsigned int fw_caps = pi->adapter->params.fw_caps_support;
-	struct fw_port_cmd port_cmd;
 	unsigned int action, link_ok, mtu;
+	struct fw_port_cmd port_cmd;
 	fw_port_cap32_t linkattr;
 	int ret;
 
@@ -8813,9 +8813,12 @@ int t4_get_link_params(struct port_info *pi, unsigned int *link_okp,
 			be32_to_cpu(port_cmd.u.info32.auxlinfo32_mtu32));
 	}
 
-	*link_okp = link_ok;
-	*speedp = fwcap_to_speed(linkattr);
-	*mtup = mtu;
+	if (link_okp)
+		*link_okp = link_ok;
+	if (speedp)
+		*speedp = fwcap_to_speed(linkattr);
+	if (mtup)
+		*mtup = mtu;
 
 	return 0;
 }
-- 
2.24.0

