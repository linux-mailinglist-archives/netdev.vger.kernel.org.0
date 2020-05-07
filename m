Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C301C7F74
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgEGA6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:58:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:22030 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgEGA6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 20:58:30 -0400
IronPort-SDR: RniS7+j3p2A8uli8LpVVuf+qdcfXIAp38XXmDCIfUCBdOPrHShRgkc8CcTJpPf1StyIAV9BqBa
 rDs3sMxARZBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 17:58:30 -0700
IronPort-SDR: acZDNPVVene1EnLG5BKt3QDuLJwvcnfJeI8qICXcblXqgGDFwwA9jGovhVFikjTsKR6GV0Bcai
 GPItoK52Re7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,361,1583222400"; 
   d="scan'208";a="295537902"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga002.fm.intel.com with ESMTP; 06 May 2020 17:58:29 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH net-next] net: remove newlines in NL_SET_ERR_MSG_MOD
Date:   Wed,  6 May 2020 17:58:27 -0700
Message-Id: <20200507005827.3919243-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NL_SET_ERR_MSG_MOD macro is used to report a string describing an
error message to userspace via the netlink extended ACK structure. It
should not have a trailing newline.

Add a cocci script which catches cases where the newline marker is
present. Using this script, fix the handful of cases which accidentally
included a trailing new line.

I couldn't figure out a way to get a patch mode working, so this script
only implements context, report, and org.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c         |  6 +-
 net/bridge/br_mrp_netlink.c                   |  2 +-
 net/bridge/br_stp_if.c                        |  2 +-
 net/dsa/slave.c                               |  6 +-
 .../coccinelle/misc/newline_in_nl_msg.cocci   | 75 +++++++++++++++++++
 6 files changed, 84 insertions(+), 9 deletions(-)
 create mode 100644 scripts/coccinelle/misc/newline_in_nl_msg.cocci

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 77397aa66810..a050808f2128 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1097,7 +1097,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		if (IS_ERR(priv->fs.tc.t)) {
 			mutex_unlock(&priv->fs.tc.t_lock);
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed to create tc offload table\n");
+					   "Failed to create tc offload table");
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
 			return PTR_ERR(priv->fs.tc.t);
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index d326e231f0ad..b7baf7624e18 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -48,7 +48,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 
 		if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Only one policer per port is supported\n");
+					   "Only one policer per port is supported");
 			return -EEXIST;
 		}
 
@@ -59,7 +59,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 
 		err = ocelot_port_policer_add(ocelot, port, &pol);
 		if (err) {
-			NL_SET_ERR_MSG_MOD(extack, "Could not add policer\n");
+			NL_SET_ERR_MSG_MOD(extack, "Could not add policer");
 			return err;
 		}
 
@@ -73,7 +73,7 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 		err = ocelot_port_policer_del(ocelot, port);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Could not delete policer\n");
+					   "Could not delete policer");
 			return err;
 		}
 		priv->tc.police_id = 0;
diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 503896638be0..397e7f710772 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -28,7 +28,7 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 	int err;
 
 	if (br->stp_enabled != BR_NO_STP) {
-		NL_SET_ERR_MSG_MOD(extack, "MRP can't be enabled if STP is already enabled\n");
+		NL_SET_ERR_MSG_MOD(extack, "MRP can't be enabled if STP is already enabled");
 		return -EINVAL;
 	}
 
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index a42850b7eb9a..ba55851fe132 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -203,7 +203,7 @@ int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
 
 	if (br_mrp_enabled(br)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "STP can't be enabled if MRP is already enabled\n");
+				   "STP can't be enabled if MRP is already enabled");
 		return -EINVAL;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index fa2634043751..8c93f52e2449 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -913,13 +913,13 @@ dsa_slave_add_cls_matchall_police(struct net_device *dev,
 
 	if (!ds->ops->port_policer_add) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Policing offload not implemented\n");
+				   "Policing offload not implemented");
 		return -EOPNOTSUPP;
 	}
 
 	if (!ingress) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Only supported on ingress qdisc\n");
+				   "Only supported on ingress qdisc");
 		return -EOPNOTSUPP;
 	}
 
@@ -930,7 +930,7 @@ dsa_slave_add_cls_matchall_police(struct net_device *dev,
 	list_for_each_entry(mall_tc_entry, &p->mall_tc_list, list) {
 		if (mall_tc_entry->type == DSA_PORT_MALL_POLICER) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Only one port policer allowed\n");
+					   "Only one port policer allowed");
 			return -EEXIST;
 		}
 	}
diff --git a/scripts/coccinelle/misc/newline_in_nl_msg.cocci b/scripts/coccinelle/misc/newline_in_nl_msg.cocci
new file mode 100644
index 000000000000..c175886e4015
--- /dev/null
+++ b/scripts/coccinelle/misc/newline_in_nl_msg.cocci
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-only
+///
+/// Catch strings ending in newline with GENL_SET_ERR_MSG, NL_SET_ERR_MSG,
+/// NL_SET_ERR_MSG_MOD.
+///
+// Confidence: Very High
+// Copyright: (C) 2020 Intel Corporation
+// URL: http://coccinelle.lip6.fr/
+// Options: --no-includes --include-headers
+
+virtual context
+virtual org
+virtual report
+
+@r depends on context || org || report@
+expression e;
+constant m;
+position p;
+@@
+  \(GENL_SET_ERR_MSG\|NL_SET_ERR_MSG\|NL_SET_ERR_MSG_MOD\)(e,m@p)
+
+@script:python@
+m << r.m;
+@@
+
+if not m.endswith("\\n\""):
+	cocci.include_match(False)
+
+@r1 depends on r@
+identifier fname;
+expression r.e;
+constant r.m;
+position r.p;
+@@
+  fname(e,m@p)
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context && r@
+identifier r1.fname;
+expression r.e;
+constant r.m;
+@@
+* fname(e,m)
+
+//----------------------------------------------------------
+//  For org mode
+//----------------------------------------------------------
+
+@script:python depends on org@
+fname << r1.fname;
+m << r.m;
+p << r.p;
+@@
+
+if m.endswith("\\n\""):
+	msg="WARNING avoid newline at end of message in %s" % (fname)
+	msg_safe=msg.replace("[","@(").replace("]",")")
+	coccilib.org.print_todo(p[0], msg_safe)
+
+//----------------------------------------------------------
+//  For report mode
+//----------------------------------------------------------
+
+@script:python depends on report@
+fname << r1.fname;
+m << r.m;
+p << r.p;
+@@
+
+if m.endswith("\\n\""):
+	msg="WARNING avoid newline at end of message in %s" % (fname)
+	coccilib.report.print_report(p[0], msg)
-- 
2.25.2

