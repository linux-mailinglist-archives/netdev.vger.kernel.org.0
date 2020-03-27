Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37F1953C7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgC0JWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:22:34 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2539 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgC0JWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:22:33 -0400
IronPort-SDR: l/nuD/rUe8Ud7BCtdKYCdvJ10fNVuoPSno+5SYp5kwirqm7fCdsP0wmHdvvVnhG8DMxqjSCqBI
 r8cskPWb2VwWFOoli5VQPBU5EgMm9+ZPHYJkrDXA5trQyNwsW0SIXGAoNBrPbVPgtyF1x521Rj
 vYT9GUTrmsA6CMxf50HMiuKNIGmAXtjm87yg0ILUwrohMUY0Tx/GtcQm+NpkPpNvzjHAyWHQnl
 v+3e7ggo4ZqfHmJatOjgP2lVmiJSIeDVD18d+B1hT799tL9SFH1SgXAu2UWTymm8/HkV7Fz7Jr
 qEQ=
X-IronPort-AV: E=Sophos;i="5.72,311,1580799600"; 
   d="scan'208";a="68596750"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Mar 2020 02:22:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Mar 2020 02:22:31 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 27 Mar 2020 02:22:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v4 5/9] switchdev: mrp: Extend switchdev API to offload MRP
Date:   Fri, 27 Mar 2020 10:21:22 +0100
Message-ID: <20200327092126.15407-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327092126.15407-1-horatiu.vultur@microchip.com>
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend switchdev API to add support for MRP. The HW is notified in
following cases:

SWITCHDEV_OBJ_ID_MRP: This is used when a MRP instance is added/removed
  from the MRP ring.

SWITCHDEV_OBJ_ID_RING_ROLE_MRP: This is used when the role of the node
  changes. The current supported roles are MRM and MRC.

SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
  MRP_Test frames on the mrp ring ports. This is called only on nodes that have
  the role MRM. In case this fails then the SW will generate the frames.

SWITCHDEV_ATTR_ID_MRP_PORT_STATE: This is used when the port's state is
  changed. It can be in blocking/forwarding mode.

SWITCHDEV_ATTR_ID_MRP_PORT_ROLE: This is used when port's role changes. The
  roles of the port can be primary/secondary. This is required to notify HW
  because the MRP_Test frame contains the field MRP_PortRole that contains this
  information.

SWITCHDEV_ATTR_ID_MRP_RING_STATE: This is used when the ring changes it states
  to open or closed. This is required to notify HW because the MRP_Test frame
  contains the field MRP_InState which contains this information.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 53 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aee86a189432..3323779122c7 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -40,6 +40,11 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_MRP_RING_STATE,
+#endif
 };
 
 struct switchdev_attr {
@@ -55,6 +60,11 @@ struct switchdev_attr {
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
 		bool mc_disabled;			/* MC_DISABLED */
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+		u8 mrp_port_state;			/* MRP_PORT_STATE */
+		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		u8 mrp_ring_state;			/* MRP_RING_STATE */
+#endif
 	} u;
 };
 
@@ -63,6 +73,11 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_PORT_VLAN,
 	SWITCHDEV_OBJ_ID_PORT_MDB,
 	SWITCHDEV_OBJ_ID_HOST_MDB,
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	SWITCHDEV_OBJ_ID_MRP,
+	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+#endif
 };
 
 struct switchdev_obj {
@@ -94,6 +109,44 @@ struct switchdev_obj_port_mdb {
 #define SWITCHDEV_OBJ_PORT_MDB(OBJ) \
 	container_of((OBJ), struct switchdev_obj_port_mdb, obj)
 
+
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+/* SWITCHDEV_OBJ_ID_MRP */
+struct switchdev_obj_mrp {
+	struct switchdev_obj obj;
+	struct net_device *p_port;
+	struct net_device *s_port;
+	u32 ring_id;
+};
+
+#define SWITCHDEV_OBJ_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_mrp, obj)
+
+/* SWITCHDEV_OBJ_ID_RING_TEST_MRP */
+struct switchdev_obj_ring_test_mrp {
+	struct switchdev_obj obj;
+	/* The value is in us and a value of 0 represents to stop */
+	u32 interval;
+	u8 max_miss;
+	u32 ring_id;
+	u32 period;
+};
+
+#define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_test_mrp, obj)
+
+/* SWICHDEV_OBJ_ID_RING_ROLE_MRP */
+struct switchdev_obj_ring_role_mrp {
+	struct switchdev_obj obj;
+	u8 ring_role;
+	u32 ring_id;
+};
+
+#define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_role_mrp, obj)
+
+#endif
+
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
 enum switchdev_notifier_type {
-- 
2.17.1

