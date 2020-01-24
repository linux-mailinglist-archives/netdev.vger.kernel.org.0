Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101AC148BDB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390126AbgAXQTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:19:54 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25653 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390009AbgAXQTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:51 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: +FvT4PgZPtezS7ktZ8vSBz8QMBMmu+d3HeOyBatLVnYR+EW9Hy5f2RdavxgWP6475FlQVtwMxv
 pDslQDOyYtajI8V9nk+8aeebVzLvSUV26xYz6cM8fPRRz0iuWZgEs3xKVLxK7A4TnO8LBENbwd
 gpt07RX3p+RSZY1T7XX6nOkl/DsdizrSX0DI56pm7UUWx79nvC/vArvy91fVJS+Go6EpwPCo8w
 LbxzcNLAWSIMJlL20Hsto4D3Oh2tpn+WsQjx44UwZTV6XizZOdp/tIvhQceUneTRrZ74x1xLtb
 Hqw=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="19415"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:46 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend switchdev API to offload MRP
Date:   Fri, 24 Jan 2020 17:18:24 +0100
Message-ID: <20200124161828.12206-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend switchdev API to add support for MRP. The HW is notified in
following cases:

SWITCHDEV_OBJ_ID_PORT_MRP: This is used when a port is added/removed from the
  mrp ring.

SWITCHDEV_OBJ_ID_RING_ROLE_MRP: This is used when the role of the node
  changes. The current supported roles are Media Redundancy Manager and Media
  Redundancy Client.

SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
  MRP_Test frames on the mrp ring ports. This is called only on nodes that have
  the role Media Redundancy Manager.

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
 include/net/switchdev.h | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aee86a189432..b1ed170fc01d 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -40,6 +40,11 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
+#ifdef CONFIG_BRIDGE_MRP
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
+#ifdef CONFIG_BRIDGE_MRP
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
+#ifdef CONFIG_BRIDGE_MRP
+	SWITCHDEV_OBJ_ID_PORT_MRP,
+	SWITCHDEV_OBJ_ID_RING_TEST_MRP,
+	SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
+#endif
 };
 
 struct switchdev_obj {
@@ -94,6 +109,42 @@ struct switchdev_obj_port_mdb {
 #define SWITCHDEV_OBJ_PORT_MDB(OBJ) \
 	container_of((OBJ), struct switchdev_obj_port_mdb, obj)
 
+
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
+	u8 max_miss;
+	u32 ring_nr;
+};
+
+#define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
+	container_of((OBJ), struct switchdev_obj_ring_test_mrp, obj)
+
+/* SWICHDEV_OBJ_ID_RING_ROLE_MRP */
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
-- 
2.17.1

