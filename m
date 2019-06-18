Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A74A264
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbfFRNgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:36:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:21689 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfFRNgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:36:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 06:36:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,389,1557212400"; 
   d="scan'208";a="164705640"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga006.jf.intel.com with ESMTP; 18 Jun 2019 06:36:17 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC net-next 4/5] net: stmmac: enable HW offloading for tc taprio
Date:   Wed, 19 Jun 2019 05:36:17 +0800
Message-Id: <1560893778-6838-5-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enable iproute2's tc taprio to run IEEE802.1Qbv using HW.
tc taprio manual can refer to:
http://man7.org/linux/man-pages/man8/tc-taprio.8.html

To enable HW offloading, an extra argument need to be added:
offload 1

Example to run:
$ tc qdisc add dev IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time 10000000 \
      sched-entry S 03 300000 \
      sched-entry S 02 300000 \
      sched-entry S 06 400000 \
      clockid CLOCK_TAI
      offload 1

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  5 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   | 96 +++++++++++++++++++++++
 3 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index dec9b1f5c557..c9fa60934710 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -514,6 +514,7 @@ struct stmmac_mode_ops {
 struct stmmac_priv;
 struct tc_cls_u32_offload;
 struct tc_cbs_qopt_offload;
+struct tc_taprio_qopt_offload;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -521,6 +522,8 @@ struct stmmac_tc_ops {
 			     struct tc_cls_u32_offload *cls);
 	int (*setup_cbs)(struct stmmac_priv *priv,
 			 struct tc_cbs_qopt_offload *qopt);
+	int (*setup_taprio)(struct stmmac_priv *priv,
+			    struct tc_taprio_qopt_offload *qopt);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -529,6 +532,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_cls_u32, __args)
 #define stmmac_tc_setup_cbs(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_cbs, __args)
+#define stmmac_tc_setup_taprio(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, setup_taprio, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c28b5e69f2cd..a443c42fa58b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3811,6 +3811,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return stmmac_setup_tc_block(priv, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return stmmac_tc_setup_taprio(priv, priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 58ea18af9813..d118e3636d50 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -7,10 +7,13 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
 #include "common.h"
+#include "dw_tsn_lib.h"
 #include "dwmac4.h"
 #include "dwmac5.h"
 #include "stmmac.h"
 
+#define ONE_SEC_IN_NANOSEC 1000000000ULL
+
 static void tc_fill_all_pass_entry(struct stmmac_tc_entry *entry)
 {
 	memset(entry, 0, sizeof(*entry));
@@ -349,8 +352,101 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_setup_taprio(struct stmmac_priv *priv,
+			   struct tc_taprio_qopt_offload *qopt)
+{
+	u64 time_extension = qopt->cycle_time_extension;
+	u64 base_time = ktime_to_ns(qopt->base_time);
+	u64 cycle_time = qopt->cycle_time;
+	struct est_gcrr egcrr;
+	u32 extension_ns;
+	u32 extension_s;
+	u32 cycle_ns;
+	u32 cycle_s;
+	u32 base_ns;
+	u32 base_s;
+	int ret;
+	int i;
+
+	if (qopt->enable) {
+		stmmac_set_est_enable(priv, priv->ioaddr, 1);
+		dev_info(priv->device, "taprio: EST enabled\n");
+	} else {
+		stmmac_set_est_enable(priv, priv->ioaddr, 0);
+		dev_info(priv->device, "taprio: EST disabled\n");
+		return 0;
+	}
+
+	dev_dbg(priv->device, "taprio: time_extension %lld, base_time %lld, cycle_time %lld\n",
+		qopt->cycle_time_extension, qopt->base_time, qopt->cycle_time);
+
+	for (i = 0; i < qopt->num_entries; i++) {
+		struct est_gc_entry sgce;
+
+		sgce.gates = qopt->entries[i].gate_mask;
+		sgce.ti_nsec = qopt->entries[i].interval;
+
+		/* cycle_time will be sum of all time interval
+		 * of the entries in the schedule if the
+		 * cycle_time is not provided
+		 */
+		if (!qopt->cycle_time)
+			cycle_time += qopt->entries[i].interval;
+
+		dev_dbg(priv->device, "taprio: gates 0x%x, ti_ns %d, cycle_ns %d\n",
+			sgce.gates, sgce.ti_nsec, cycle_ns);
+
+		ret = stmmac_set_est_gce(priv, priv->ioaddr, &sgce, i, 0, 0);
+
+		if (ret) {
+			dev_err(priv->device,
+				"taprio: fail to program GC entry(%d).\n", i);
+
+			return ret;
+		}
+	}
+
+	ret = stmmac_set_est_gcrr_llr(priv, priv->ioaddr,
+				      qopt->num_entries,
+				      0, 0);
+	if (ret) {
+		dev_err(priv->device,
+			"taprio: fail to program GC into HW\n");
+	}
+
+	/* set est_info */
+	base_ns = do_div(base_time, ONE_SEC_IN_NANOSEC);
+	base_s = base_time;
+	dev_dbg(priv->device, "taprio: base_s %d, base_ns %d\n",
+		base_s, base_ns);
+
+	cycle_ns = do_div(cycle_time, ONE_SEC_IN_NANOSEC);
+	cycle_s = cycle_time;
+	dev_dbg(priv->device, "taprio: cycle_s %d, cycle_ns %d\n",
+		cycle_s, cycle_ns);
+
+	extension_ns = do_div(time_extension, ONE_SEC_IN_NANOSEC);
+	extension_s = time_extension;
+	dev_dbg(priv->device, "taprio: extension_s %d, extension_ns %d\n",
+		extension_s, extension_ns);
+
+	if (extension_s) {
+		dev_err(priv->device, "taprio: extension in seconds not supported.\n");
+		return -EINVAL;
+	}
+
+	egcrr.cycle_sec = cycle_s;
+	egcrr.cycle_nsec = cycle_ns;
+	egcrr.base_sec = base_s;
+	egcrr.base_nsec = base_ns;
+	egcrr.ter_nsec = extension_ns;
+
+	return stmmac_set_est_gcrr_times(priv, priv->ioaddr, &egcrr, 0, 0);
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
 	.setup_cbs = tc_setup_cbs,
+	.setup_taprio = tc_setup_taprio,
 };
-- 
1.9.1

