Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CE81B4A5A
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgDVQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:22:24 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:24020 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgDVQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587572534; x=1619108534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Wk5W6JOrVyShu0Bu566DjA/nJMtV0L8hDnh56QYpSOM=;
  b=jmQLE9wgjbiL8EeJkGRIzLxAA4ApiptlkMb25lSkLEE4MyxdLRoJkXpz
   wuGjOC1RUbQiLUzxa02oAnGH2yEEsRFY6XekS5VdBO+D+fPLlgYtcV+B3
   gsMlH0PkYNvQLJs5nrL7LeuT4lYcY4YXEgCWcEFk0/Fl8gywDA4/FMIzK
   oCbGAyz8Ui0lmihZDebpQuqU9JT0LKHOtKChidTrHN5rFGW1DhI7Libdo
   0gPRQb5vmRK7UHVl5uJPff33BJfdonfdPZNFjn6h7DldR1uCi4OfWrmH3
   1gvlNC+ETywsBvkPJl/nWCTmv2Y7O3xBflRAxUIdA9FAzb+7HaJfL+ZcR
   A==;
IronPort-SDR: BkKNcp0cleGm0x3/bUdbWeDy4sliKg8MOaf2LvpHeGhHLpDZgBqlPXHH8v0H7xvHft7peBbiIN
 7j7mBDMG0fstXPWi2KLBFbxKO1MV+THo+1tguC26Fyt3PxPjjIQY6IKkrOe4wvw2Fj/ZP1oXnn
 Nj+3dAgUQB4XyGVYHnP3rz0nsBMlkBtoWJb3PfZ2PNbIYgJioQg8mk3hcDYzeZVhrwkvAWlJZL
 BGYoP5DOQInCUGjB+D3RZkHYV9u5xskQS6kOBffNpP0CCwAr/mp6m8hjd637m8WWJiLwN5nMdg
 za8=
X-IronPort-AV: E=Sophos;i="5.73,304,1583218800"; 
   d="scan'208";a="76894600"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2020 09:21:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Apr 2020 09:21:58 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 22 Apr 2020 09:21:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 06/11] switchdev: mrp: Extend switchdev API to offload MRP
Date:   Wed, 22 Apr 2020 18:18:28 +0200
Message-ID: <20200422161833.1123-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422161833.1123-1-horatiu.vultur@microchip.com>
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
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

