Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37151B2A5D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgDUOm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:42:59 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:61621 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgDUOm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587480176; x=1619016176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Wk5W6JOrVyShu0Bu566DjA/nJMtV0L8hDnh56QYpSOM=;
  b=mQqeBpuSfv3Ayujr9FkEYzbIyXqy/GAY2JqciV/g9ctPrWsK1J6ZblWI
   D8Xqv7Sj3HtS00CnWClQazasSllIDCI5p9PCakFY6dbG+JCjyDS5MMZI9
   7v1k4lAzaj2E5HDlYgNDbWjy8rHi4FEMhuLvkE2zBnAn/pX7GBHyMQqyd
   /vANO6KLx8+6J4DBlDy2B4iMeyXTsyrg44H/BaNAww5ncIlMxvoSOPJgi
   xAtV0jOJnw93CK6RRmAsxZqvhzcFSbjuMjZC+WJeHn+LVu5/6yl1sJQ4j
   iyzPUPsOo318nrfqE9mafi1poTfja2uYKzmx+8NAgMM78sXIAbYLh1/+P
   w==;
IronPort-SDR: 6u41ZC8mwRw4I4NhUH/7FH3/f7kFSJe7VNO4vX+hFL6OlUVhUdU9Yeuhvo31TtOeczF09nolux
 D2jXibPabi6Nx+Dd2m7O04zLt3NFArQMAyvJ/q3ZdyD29/s/bWEqUFKKZ8Q4k82aV+lvVoXADf
 YK0F4I+pwum5b8d29lgKsBxzCwCCuy3kYGlVeDAJLH+1l+38av0/5nPV7vzQnc9G1FN89/JRbN
 /hIyFUGWNuEv3WN9myACv4wWEcPPCISUrT0hXuQSuY5FIAr5UFqbcxnRxjMM+VcXm1jTtCRWBI
 xUw=
X-IronPort-AV: E=Sophos;i="5.72,410,1580799600"; 
   d="scan'208";a="72862640"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2020 07:42:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 07:42:56 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 21 Apr 2020 07:42:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 06/11] switchdev: mrp: Extend switchdev API to offload MRP
Date:   Tue, 21 Apr 2020 16:37:47 +0200
Message-ID: <20200421143752.2248-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421143752.2248-1-horatiu.vultur@microchip.com>
References: <20200421143752.2248-1-horatiu.vultur@microchip.com>
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

SWITCHDEV_OBJ_ID_RING_STATE_STATE: This is used when the ring changes it states
  to open or closed. This is required to notify HW because the MRP_Test frame
  contains the field MRP_InState which contains this information.

SWITCHDEV_ATTR_ID_MRP_PORT_STATE: This is used when the port's state is
  changed. It can be in blocking/forwarding mode.

SWITCHDEV_ATTR_ID_MRP_PORT_ROLE: This is used when port's role changes. The
  roles of the port can be primary/secondary. This is required to notify HW
  because the MRP_Test frame contains the field MRP_PortRole that contains this
  information.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/net/switchdev.h | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aee86a189432..ae7aeb0d1f9c 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -40,6 +40,10 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
+	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+#endif
 };
 
 struct switchdev_attr {
@@ -55,6 +59,11 @@ struct switchdev_attr {
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
 
@@ -63,6 +72,12 @@ enum switchdev_obj_id {
 	SWITCHDEV_OBJ_ID_PORT_VLAN,
 	SWITCHDEV_OBJ_ID_PORT_MDB,
 	SWITCHDEV_OBJ_ID_HOST_MDB,
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	SWITCHDEV_OBJ_ID_MRP,
+	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+	SWITCHDEV_OBJ_ID_RING_STATE_MRP,
+#endif
 };
 
 struct switchdev_obj {
@@ -94,6 +109,53 @@ struct switchdev_obj_port_mdb {
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
+struct switchdev_obj_ring_state_mrp {
+	struct switchdev_obj obj;
+	u8 ring_state;
+	u32 ring_id;
+};
+
+#define SWITCHDEV_OBJ_RING_STATE_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_state_mrp, obj)
+
+#endif
+
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
 enum switchdev_notifier_type {
-- 
2.17.1

