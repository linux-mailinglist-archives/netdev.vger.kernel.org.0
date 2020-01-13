Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED9DC13914C
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgAMMrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:47:23 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:61049 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgAMMrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:47:23 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: RaRo6Qp5kZGX/svhcBrwSlKl9zxajs78SVCcd5NoaiKv62j8rOjoJhRo8p95cUm7ZgqJUGV45Z
 9YumwzgyM2iwwAvdrU2KgdYzp0ZoYYaB/Xcbz2heICi1B8nJfcuA8GlRFRTmQLLm+7PcxPQy8a
 ZXcZmrrq/x3+6ZyZ5ueHzQ726wWZ0gHZZP354TjVhd61a8v0LStbVrIKwbjOWHjC1SSI3mwGfg
 AaZoSdT+Dl7qqlUu9HSsE3OPx3UYoRqLnNvPEzUONNRKre1HC71jBd3RRcY7ON5t1OC9VWQqOK
 3xM=
X-IronPort-AV: E=Sophos;i="5.69,429,1571727600"; 
   d="scan'208";a="63055992"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 05:47:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 05:47:18 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 13 Jan 2020 05:47:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <andrew@lunn.ch>, <dsahern@gmail.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next Patch v2 4/4] net: bridge: mrp: switchdev: Add HW offload
Date:   Mon, 13 Jan 2020 13:46:20 +0100
Message-ID: <20200113124620.18657-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113124620.18657-1-horatiu.vultur@microchip.com>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend switchdev interface to add support for MRP. The HW is notified in
following cases:
- SWITCHDEV_OBJ_ID_PORT_MRP. This is used when a port is added/removed from the
  mrp ring.
- SWITCHDEV_OBJ_ID_RING_ROLE_MRP. This is used when the role of the node
  changes. The current supported roles are Media Redundancy Manager and Media
  Redundancy Client.
- SWITCHDEV_OBJ_ID_RING_TEST_MRP. This is used when to start/stop sending
  MRP_Test frames on the mrp ring ports. This is called only on nodes that have
  the role Media Redundancy Manager.
- SWITCHDEV_ATTR_ID_MRP_PORT_STATE. This is used when the port's state is
  changed. It can be in blocking/forwarding mode.
- SWITCHDEV_ATTR_ID_MRP_PORT_ROLE. This is used when ports's role changes. The
  roles of the port can be primary/secondary. This is required to notify HW
  because the MRP_Test frame contains the field MRP_PortRole that contains this
  information.
- SWITCHDEV_ATTR_ID_MRP_STATE. This is used when the ring changes it states to
  open or closed. This is required to notify HW because the MRP_Test frame
  contains the field MRP_InState which contains this information.
- SWITCHDEV_ATTR_ID_RING_TRANS. This is used to count the number of times the
  ring goes in open state. This is required to notify the HW because the
  MRP_Test frame contains the field MRP_Transition which contains this
  information.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h       |  52 ++++++++++
 net/bridge/Makefile           |   2 +-
 net/bridge/br_mrp.c           |  96 +++++++++++-------
 net/bridge/br_mrp_switchdev.c | 180 ++++++++++++++++++++++++++++++++++
 net/bridge/br_mrp_timer.c     |  37 ++++++-
 net/bridge/br_private_mrp.h   |  16 +++
 6 files changed, 344 insertions(+), 39 deletions(-)
 create mode 100644 net/bridge/br_mrp_switchdev.c

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aee86a189432..c4cd180fbf5a 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -40,6 +40,12 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
+#ifdef CONFIG_BRIDGE_MRP
+	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_MRP_RING_STATE,
+	SWITCHDEV_ATTR_ID_MRP_RING_TRANS,
+#endif
 };
 
 struct switchdev_attr {
@@ -55,6 +61,12 @@ struct switchdev_attr {
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
 		bool mc_disabled;			/* MC_DISABLED */
+#ifdef CONFIG_BRIDGE_MRP
+		u8 mrp_port_state;			/* MRP_PORT_STATE */
+		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		u8 mrp_ring_state;			/* MRP_RING_STATE */
+		u32 mrp_ring_trans;			/* MRP_RING_TRANSITION */
+#endif
 	} u;
 };
 
@@ -63,6 +75,11 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_PORT_VLAN,
 	SWITCHDEV_OBJ_ID_PORT_MDB,
 	SWITCHDEV_OBJ_ID_HOST_MDB,
+#ifdef CONFIG_BRIDGE_MRP
+	SWITCHDEV_OBJ_ID_PORT_MRP,
+	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+#endif
 };
 
 struct switchdev_obj {
@@ -94,6 +111,41 @@ struct switchdev_obj_port_mdb {
 #define SWITCHDEV_OBJ_PORT_MDB(OBJ) \
 	container_of((OBJ), struct switchdev_obj_port_mdb, obj)
 
+#ifdef CONFIG_BRIDGE_MRP
+/* SWITCHDEV_OBJ_ID_PORT_MRP */
+struct switchdev_obj_port_mrp {
+	struct switchdev_obj obj;
+	struct net_device *port;
+	u32 ring_nr;
+};
+
+#define SWITCHDEV_OBJ_PORT_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_port_mrp, obj)
+
+/* SWITCHDEV_OBJ_ID_RING_TEST_MRP */
+struct switchdev_obj_ring_test_mrp {
+	struct switchdev_obj obj;
+	/* The value is in us and a value of 0 represents to stop */
+	u32 interval;
+	u8 max;
+	u32 ring_nr;
+};
+
+#define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_test_mrp, obj)
+
+/* SWITCHDEV_OBJ_ID_RING_ROLE_MRP */
+struct switchdev_obj_ring_role_mrp {
+	struct switchdev_obj obj;
+	u8 ring_role;
+	u32 ring_nr;
+};
+
+#define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_role_mrp, obj)
+
+#endif
+
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
 enum switchdev_notifier_type {
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 917826c9d8de..a51a9fc112ed 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -26,4 +26,4 @@ bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
 obj-$(CONFIG_NETFILTER) += netfilter/
 
-bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp.o br_mrp_timer.o
+bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp.o br_mrp_timer.o br_mrp_switchdev.o
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 4173021d3bfa..d109fce226d5 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -78,6 +78,10 @@ void br_mrp_set_mrm_state(struct br_mrp *mrp,
 {
 	br_debug(mrp->br, "mrm_state: %s\n", br_mrp_get_mrm_state(state));
 	mrp->mrm_state = state;
+
+	br_mrp_switchdev_set_ring_state(mrp, state == BR_MRP_MRM_STATE_CHK_RC ?
+					BR_MRP_RING_STATE_CLOSED :
+					BR_MRP_RING_STATE_OPEN);
 }
 
 void br_mrp_set_mrc_state(struct br_mrp *mrp,
@@ -101,9 +105,9 @@ static int br_mrp_set_mrm_role(struct br_mrp *mrp)
 
 	br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_AC_STAT1);
 
-	mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
-	mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
-	mrp->ring_role = BR_MRP_RING_ROLE_MRM;
+	br_mrp_port_switchdev_set_state(mrp->p_port, BR_MRP_PORT_STATE_BLOCKED);
+	br_mrp_port_switchdev_set_state(mrp->s_port, BR_MRP_PORT_STATE_BLOCKED);
+	br_mrp_switchdev_set_ring_role(mrp, BR_MRP_RING_ROLE_MRM);
 
 	if (br_mrp_is_port_up(mrp->p_port))
 		br_mrp_port_link_change(mrp->p_port, true);
@@ -128,9 +132,9 @@ static int br_mrp_set_mrc_role(struct br_mrp *mrp)
 
 	br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_AC_STAT1);
 
-	mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
-	mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
-	mrp->ring_role = BR_MRP_RING_ROLE_MRC;
+	br_mrp_port_switchdev_set_state(mrp->p_port, BR_MRP_PORT_STATE_BLOCKED);
+	br_mrp_port_switchdev_set_state(mrp->s_port, BR_MRP_PORT_STATE_BLOCKED);
+	br_mrp_switchdev_set_ring_role(mrp, BR_MRP_RING_ROLE_MRC);
 
 	if (br_mrp_is_port_up(mrp->p_port))
 		br_mrp_port_link_change(mrp->p_port, true);
@@ -385,7 +389,8 @@ static void br_mrp_mrm_recv_ring_test(struct br_mrp *mrp)
 		br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_CHK_RC);
 		break;
 	case BR_MRP_MRM_STATE_CHK_RO:
-		mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+		br_mrp_port_switchdev_set_state(mrp->s_port,
+						BR_MRP_PORT_STATE_BLOCKED);
 
 		mrp->ring_test_curr_max = mrp->ring_test_conf_max - 1;
 		mrp->ring_test_curr = 0;
@@ -455,7 +460,8 @@ static void br_mrp_recv_ring_topo(struct net_bridge_port *port,
 	case BR_MRP_MRC_STATE_PT:
 		mrp->ring_link_curr_max = mrp->ring_link_conf_max;
 		br_mrp_ring_link_up_stop(mrp);
-		mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+		br_mrp_port_switchdev_set_state(mrp->s_port,
+						BR_MRP_PORT_STATE_FORWARDING);
 		br_mrp_clear_fdb_start(mrp, ntohs(hdr->interval));
 		br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_PT_IDLE);
 		break;
@@ -538,7 +544,8 @@ static void br_mrp_recv_ring_link(struct net_bridge_port *port,
 		}
 
 		if (type == BR_MRP_TLV_HEADER_RING_LINK_UP && !mrp->blocked) {
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			mrp->ring_test_curr_max = mrp->ring_test_conf_max - 1;
 			mrp->ring_test_curr = 0;
 
@@ -570,8 +577,9 @@ static void br_mrp_recv_ring_link(struct net_bridge_port *port,
 
 		if (type == BR_MRP_TLV_HEADER_RING_LINK_DOWN &&
 		    mrp->react_on_link_change) {
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
-			mrp->ring_transitions++;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_FORWARDING);
+			br_mrp_switchdev_update_ring_transitions(mrp);
 			br_mrp_ring_topo_req(mrp, 0);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_CHK_RO);
 			break;
@@ -808,14 +816,16 @@ static void br_mrp_mrm_port_link(struct net_bridge_port *p, bool up)
 	switch (mrp->mrm_state) {
 	case BR_MRP_MRM_STATE_AC_STAT1:
 		if (up && p == mrp->p_port) {
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_FORWARDING);
 			br_mrp_ring_test_req(mrp, mrp->ring_test_conf_interval);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 		}
 		if (up && p != mrp->p_port) {
 			mrp->s_port = mrp->p_port;
 			mrp->p_port = p;
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_FORWARDING);
 			br_mrp_ring_test_req(mrp, mrp->ring_test_conf_interval);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 		}
@@ -823,7 +833,8 @@ static void br_mrp_mrm_port_link(struct net_bridge_port *p, bool up)
 	case BR_MRP_MRM_STATE_PRM_UP:
 		if (!up && p == mrp->p_port) {
 			br_mrp_ring_test_stop(mrp);
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_AC_STAT1);
 		}
 		if (up && p != mrp->p_port) {
@@ -838,14 +849,16 @@ static void br_mrp_mrm_port_link(struct net_bridge_port *p, bool up)
 		if (!up && p == mrp->p_port) {
 			mrp->s_port = mrp->p_port;
 			mrp->p_port = p;
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_test_req(mrp, mrp->ring_test_conf_interval);
 			br_mrp_ring_topo_req(mrp, topo_interval);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 			break;
 		}
 		if (!up && p != mrp->p_port) {
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 		}
 		break;
@@ -853,16 +866,18 @@ static void br_mrp_mrm_port_link(struct net_bridge_port *p, bool up)
 		if (!up && p == mrp->p_port) {
 			mrp->p_port = mrp->s_port;
 			mrp->s_port = p;
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+			br_mrp_port_switchdev_set_role(mrp->s_port,
+						       BR_MRP_PORT_STATE_BLOCKED);
+			br_mrp_port_switchdev_set_role(mrp->p_port,
+						       BR_MRP_PORT_STATE_FORWARDING);
 			br_mrp_ring_test_req(mrp, mrp->ring_test_conf_interval);
 			br_mrp_ring_topo_req(mrp, topo_interval);
-			mrp->ring_transitions++;
+			br_mrp_switchdev_update_ring_transitions(mrp);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 			break;
 		}
 		if (!up && p != mrp->p_port) {
-			mrp->ring_transitions++;
+			br_mrp_switchdev_update_ring_transitions(mrp);
 			br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_PRM_UP);
 			break;
 		}
@@ -887,13 +902,15 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 	switch (mrp->mrc_state) {
 	case BR_MRP_MRC_STATE_AC_STAT1:
 		if (up && p == mrp->p_port) {
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_FORWARDING);
 			br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_DE_IDLE);
 		}
 		if (up && p != mrp->p_port) {
 			mrp->s_port = mrp->p_port;
 			mrp->p_port = p;
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_FORWARDING);
 			br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_DE_IDLE);
 		}
 		break;
@@ -908,7 +925,8 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 			br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_PT);
 		}
 		if (!up && p == mrp->p_port) {
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_AC_STAT1);
 		}
 		break;
@@ -916,7 +934,8 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 		if (!up && p != mrp->p_port) {
 			mrp->ring_link_curr_max = mrp->ring_link_conf_max;
 			br_mrp_ring_link_up_stop(mrp);
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_link_down_start(mrp,
 						    mrp->ring_link_conf_interval);
 			br_mrp_ring_link_req(mrp->p_port, up,
@@ -930,8 +949,10 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 			br_mrp_ring_link_up_stop(mrp);
 			mrp->p_port = mrp->s_port;
 			mrp->s_port = p;
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_FORWARDING);
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_link_down_start(mrp,
 						    mrp->ring_link_conf_interval);
 			br_mrp_ring_link_req(mrp->p_port, up,
@@ -953,7 +974,8 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 		}
 		if (!up && p == mrp->p_port) {
 			mrp->ring_link_curr_max = mrp->ring_link_conf_max;
-			mrp->p_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->p_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_link_down_stop(mrp);
 			br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_AC_STAT1);
 		}
@@ -961,7 +983,8 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 	case BR_MRP_MRC_STATE_PT_IDLE:
 		if (!up && p != mrp->p_port) {
 			mrp->ring_link_curr_max = mrp->ring_link_conf_max;
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_link_down_start(mrp,
 						    mrp->ring_link_conf_interval);
 			br_mrp_ring_link_req(mrp->p_port, up,
@@ -973,7 +996,8 @@ static void br_mrp_mrc_port_link(struct net_bridge_port *p, bool up)
 			mrp->ring_link_curr_max = mrp->ring_link_conf_max;
 			mrp->p_port = mrp->s_port;
 			mrp->s_port = p;
-			mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_BLOCKED;
+			br_mrp_port_switchdev_set_state(mrp->s_port,
+							BR_MRP_PORT_STATE_BLOCKED);
 			br_mrp_ring_link_down_start(mrp,
 						    mrp->ring_link_conf_interval);
 			br_mrp_ring_link_req(mrp->p_port, up,
@@ -1183,7 +1207,7 @@ static int br_mrp_port_init(struct net_bridge_port *port, struct br_mrp *mrp,
 	 * to set again the role(MRM or MRC)
 	 */
 	br_mrp_reset_ring_state(mrp);
-	mrp->ring_role = BR_MRP_RING_ROLE_DISABLED;
+	br_mrp_switchdev_set_ring_role(mrp, BR_MRP_RING_ROLE_DISABLED);
 
 	if (!port->mrp_port) {
 		port->mrp_port = devm_kzalloc(&port->br->dev->dev,
@@ -1194,8 +1218,9 @@ static int br_mrp_port_init(struct net_bridge_port *port, struct br_mrp *mrp,
 	}
 
 	port->mrp_port->mrp = mrp;
-	port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
-	port->mrp_port->role = role;
+	br_mrp_port_switchdev_set_role(port, BR_MRP_PORT_STATE_FORWARDING);
+	br_mrp_port_switchdev_set_role(port, role);
+	br_mrp_port_switchdev_add(port);
 
 	if (role == BR_MRP_PORT_ROLE_PRIMARY)
 		mrp->p_port = port;
@@ -1218,15 +1243,16 @@ void br_mrp_port_uninit(struct net_bridge_port *port)
 	mutex_lock(&mrp->lock);
 
 	br_mrp_reset_ring_state(mrp);
-	mrp->ring_role = BR_MRP_RING_ROLE_DISABLED;
+	br_mrp_switchdev_set_ring_role(mrp, BR_MRP_RING_ROLE_DISABLED);
 
 	if (port->mrp_port->role == BR_MRP_PORT_ROLE_PRIMARY)
 		mrp->p_port = NULL;
 	if (port->mrp_port->role == BR_MRP_PORT_ROLE_SECONDARY)
 		mrp->s_port = NULL;
 
-	port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
-	port->mrp_port->role = BR_MRP_PORT_ROLE_NONE;
+	br_mrp_port_switchdev_set_state(port, BR_MRP_PORT_STATE_FORWARDING);
+	br_mrp_port_switchdev_set_role(port, BR_MRP_PORT_ROLE_NONE);
+	br_mrp_port_switchdev_del(port);
 	port->mrp_port->mrp = NULL;
 
 	devm_kfree(&port->br->dev->dev, port->mrp_port);
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
new file mode 100644
index 000000000000..c02f46e0ca47
--- /dev/null
+++ b/net/bridge/br_mrp_switchdev.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <net/switchdev.h>
+
+#include "br_private_mrp.h"
+
+int br_mrp_port_switchdev_add(struct net_bridge_port *p)
+{
+	struct net_bridge *br = p->br;
+	struct switchdev_obj_port_mrp mrp = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_MRP,
+		.port = p->dev,
+		.ring_nr = p->mrp_port->mrp->ring_nr,
+	};
+	int err = 0;
+
+	err = switchdev_port_obj_add(br->dev, &mrp.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_role(struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role)
+{
+	struct switchdev_obj_ring_role_mrp mrp_role = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+		.ring_role = role,
+		.ring_nr = mrp->ring_nr,
+	};
+	int err = 0;
+
+	mrp->ring_role = role;
+
+	pr_info("%s role: %d\n", __func__, role);
+
+	if (role == BR_MRP_RING_ROLE_DISABLED)
+		err = switchdev_port_obj_del(mrp->br->dev, &mrp_role.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &mrp_role.obj, NULL);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_send_ring_test(struct br_mrp *mrp, u32 interval, u8 max)
+{
+	struct switchdev_obj_ring_test_mrp test = {
+		.obj.orig_dev = mrp->br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+		.interval = interval,
+		.max = max,
+		.ring_nr = mrp->ring_nr,
+	};
+	int err = 0;
+
+	if (interval == 0)
+		err = switchdev_port_obj_del(mrp->br->dev, &test.obj);
+	else
+		err = switchdev_port_obj_add(mrp->br->dev, &test.obj, NULL);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_del(struct net_bridge_port *p)
+{
+	struct net_bridge *br = p->br;
+	struct switchdev_obj_port_mrp mrp = {
+		.obj.orig_dev = br->dev,
+		.obj.id = SWITCHDEV_OBJ_ID_PORT_MRP,
+		.port = p->dev,
+	};
+	int err = 0;
+
+	if (!p->mrp_port->mrp)
+		return 0;
+
+	mrp.ring_nr = p->mrp_port->mrp->ring_nr;
+
+	err = switchdev_port_obj_del(br->dev, &mrp.obj);
+
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+		.u.mrp_port_state = state,
+	};
+	int err = 0;
+
+	p->mrp_port->state = state;
+
+	pr_info("%s port: %s, state: %d\n", __func__, p->dev->name, state);
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		br_warn(p->br, "error setting offload MRP state on port %u(%s)\n",
+			(unsigned int)p->port_no, p->dev->name);
+
+	return err;
+}
+
+int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
+				   enum br_mrp_port_role_type role)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+		.u.mrp_port_role = role,
+	};
+	int err;
+
+	p->mrp_port->role = role;
+
+	err = switchdev_port_attr_set(p->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
+int br_mrp_switchdev_set_ring_state(struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state)
+{
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_MRP_RING_STATE,
+		.u.mrp_ring_state = state,
+	};
+	int err = 0;
+
+	attr.orig_dev = mrp->p_port->dev,
+	err = switchdev_port_attr_set(mrp->p_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	attr.orig_dev = mrp->s_port->dev;
+	err = switchdev_port_attr_set(mrp->s_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return err;
+}
+
+int br_mrp_switchdev_update_ring_transitions(struct br_mrp *mrp)
+{
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_MRP_RING_TRANS,
+	};
+	int err;
+
+	mrp->ring_transitions++;
+
+	attr.u.mrp_ring_trans = mrp->ring_transitions;
+
+	attr.orig_dev = mrp->p_port->dev,
+	err = switchdev_port_attr_set(mrp->p_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	attr.orig_dev = mrp->s_port->dev;
+	err = switchdev_port_attr_set(mrp->s_port->dev, &attr);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
+}
+
diff --git a/net/bridge/br_mrp_timer.c b/net/bridge/br_mrp_timer.c
index 59aa8c05724f..6493fc94bd49 100644
--- a/net/bridge/br_mrp_timer.c
+++ b/net/bridge/br_mrp_timer.c
@@ -6,7 +6,8 @@
 
 static void br_mrp_ring_open(struct br_mrp *mrp)
 {
-	mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+	br_mrp_port_switchdev_set_state(mrp->s_port,
+					BR_MRP_PORT_STATE_FORWARDING);
 
 	mrp->ring_test_curr_max = mrp->ring_test_conf_max - 1;
 	mrp->ring_test_curr = 0;
@@ -18,7 +19,7 @@ static void br_mrp_ring_open(struct br_mrp *mrp)
 
 	br_mrp_ring_test_req(mrp, mrp->ring_test_conf_interval);
 
-	mrp->ring_transitions++;
+	br_mrp_switchdev_update_ring_transitions(mrp);
 	br_mrp_set_mrm_state(mrp, BR_MRP_MRM_STATE_CHK_RO);
 }
 
@@ -111,7 +112,8 @@ static void br_mrp_ring_link_up_expired(struct work_struct *work)
 		br_mrp_ring_link_req(mrp->p_port, true, interval);
 	} else {
 		mrp->ring_link_curr_max = mrp->ring_link_conf_max;
-		mrp->s_port->mrp_port->state = BR_MRP_PORT_STATE_FORWARDING;
+		br_mrp_port_switchdev_set_state(mrp->s_port,
+						BR_MRP_PORT_STATE_FORWARDING);
 		br_mrp_set_mrc_state(mrp, BR_MRP_MRC_STATE_PT_IDLE);
 	}
 
@@ -152,12 +154,41 @@ static void br_mrp_ring_link_down_expired(struct work_struct *work)
 
 void br_mrp_ring_test_start(struct br_mrp *mrp, u32 interval)
 {
+	int err;
+
+	err = br_mrp_switchdev_send_ring_test(mrp, interval,
+					      mrp->ring_test_conf_max);
+	/* If HW can transmit the test frames then don't start anymore the
+	 * SW timers
+	 */
+	if (!err) {
+		pr_info("HW timers started\n");
+		return;
+	} else if (err != -EOPNOTSUPP) {
+		pr_info("HW can't start timers error: %d\n", err);
+		return;
+	}
+
 	queue_delayed_work(mrp->timers_queue, &mrp->ring_test_work,
 			   usecs_to_jiffies(interval));
 }
 
 void br_mrp_ring_test_stop(struct br_mrp *mrp)
 {
+	int err;
+
+	err = br_mrp_switchdev_send_ring_test(mrp, 0, 0);
+	/* If HW can stop the transmission of the test frames then the SW timers
+	 * were not start so just exit
+	 */
+	if (!err) {
+		pr_info("HW timers stopped\n");
+		return;
+	} else if (err != -EOPNOTSUPP) {
+		pr_info("HW can't stop timers error: %d\n", err);
+		return;
+	}
+
 	cancel_delayed_work(&mrp->ring_test_work);
 }
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 13fd2330ccfc..f3f34749774d 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -205,4 +205,20 @@ void br_mrp_ring_link_up_stop(struct br_mrp *mrp);
 void br_mrp_ring_link_down_start(struct br_mrp *mrp, u32 interval);
 void br_mrp_ring_link_down_stop(struct br_mrp *mrp);
 
+/* br_mrp_switchdev.c */
+int br_mrp_port_switchdev_add(struct net_bridge_port *p);
+int br_mrp_port_switchdev_del(struct net_bridge_port *p);
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
+				    enum br_mrp_port_state_type state);
+int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
+				   enum br_mrp_port_role_type role);
+
+int br_mrp_switchdev_set_ring_role(struct br_mrp *mrp,
+				   enum br_mrp_ring_role_type role);
+int br_mrp_switchdev_set_ring_state(struct br_mrp *mrp,
+				    enum br_mrp_ring_state_type state);
+int br_mrp_switchdev_update_ring_transitions(struct br_mrp *mrp);
+
+int br_mrp_switchdev_send_ring_test(struct br_mrp *mrp, u32 interval, u8 max);
+
 #endif /* BR_PRIVATE_MRP_H_ */
-- 
2.17.1

