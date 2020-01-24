Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC03A148BC8
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389697AbgAXQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:19:34 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:25554 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbgAXQTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:19:33 -0500
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
IronPort-SDR: BqL6cZUCCO8ERxzM1osKIvn6fVVDvyqU3dJeBC4y5NrLLgYSsPdGQUFkbxkBnMQipEQIx0HE6G
 nJxZIIC0bujGuZexBdCcvDxwoNk3nCXtnhtpwRZP4yEnyeIIQuyrdIqWneX6qQsc5m5eTsYLxi
 Ojb8K84HTCxubnon5k4CwnZtFaAG+2iH3Q3PK7DbWb7gJ5Wp3b7H1h41Z7jtlJ7OxUgqOwXC0b
 F5dHJKwZQtHycW5yhwo27j4a56bllwkA3EQAubHlxomUQ7Dpz3qBIQS5mAuKFLN0xzUfBEGAdW
 mKY=
X-IronPort-AV: E=Sophos;i="5.70,358,1574146800"; 
   d="scan'208";a="19318"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2020 09:19:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Jan 2020 09:19:31 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 24 Jan 2020 09:19:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v3 01/10] net: bridge: mrp: Expose mrp attributes.
Date:   Fri, 24 Jan 2020 17:18:19 +0100
Message-ID: <20200124161828.12206-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200124161828.12206-1-horatiu.vultur@microchip.com>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the attributes and the commands used by the generic netlink interface to
configure the kernel from userspace. The following commands are available:

BR_MRP_GENL_ADD - creates an MRP instance. This doesn't have yet any MRP
  ports attach to it.

BR_MRP_GENL_ADD_PORT - adds a port to an MRP instance. A port can't be part
  of multiple MRP instances.

BR_MRP_GENL_DEL - deletes an MRP instance. By deleting the instance also the
  MRP ports are removed.

BR_MRP_GENL_DEL_PORT - removes a port from an MRP instance. When the port is
  removed then the state machine of the MRP instance is reset because there is
  no point in having only 1 port in a MRP ring.

BR_MRP_GENL_SET_PORT_STATE - sets the port state. The port state can be
  forwarding, which means that the port will forward frames and blocked, which
  will block non-MRP frames.

BR_MRP_GENL_SET_PORT_ROLE - sets the port role, it can be primary or secondary.

BR_MRP_GENL_SET_RING_STATE - sets the ring state. The ring state can be closed
  or open. This information is needed in the MRP_Test frames

BR_MRP_GENL_SET_RING_ROLE - sets the ring role. The supported roles are MRM
  and MRC. A node can have MRM role only if, it can terminate MRP frames,
  redirect MRP frames(except MRP_Test) to the CPU and can notify that it
  stopped receiving frames. A node can have MRC role only if it can copy
  MRP_Topology frames and forward frames between ring ports.

BR_MRP_GENL_SET_START_TEST - this command is used to notify the kernel to start
  to generate MRP frames. A value of 0 for the attribute
  BR_MRP_ATTR_TEST_INTERVAL means that it should stop to generate frames.

BR_MRP_GENL_FLUSH - this command is used to flush the fdb.

BR_MRP_GENL_RING_OPEN - it is used by the kernel to notify userspace
  applications that one of the MRP ring ports stopped receiving MRP_Test frames

The calls to BR_MRP_GENL_SET_PORT_ROLE and BR_MRP_GENL_SET_RING_STATE are
required in case the driver can generate MRP_Test frames because these frames
contains this information. And there is no other way for the HW to get it.

MRP_Test frames contain also the number of times a ring went to open state.
There is no command for that because the driver can count this by counting the
number of times the ring state is set to open.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_ether.h   |   1 +
 include/uapi/linux/mrp_bridge.h | 118 ++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)
 create mode 100644 include/uapi/linux/mrp_bridge.h

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index f6ceb2e63d1e..d6de2b167448 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -92,6 +92,7 @@
 #define ETH_P_PREAUTH	0x88C7		/* 802.11 Preauthentication */
 #define ETH_P_TIPC	0x88CA		/* TIPC 			*/
 #define ETH_P_LLDP	0x88CC		/* Link Layer Discovery Protocol */
+#define ETH_P_MRP	0x88E3		/* Media Redundancy Protocol	*/
 #define ETH_P_MACSEC	0x88E5		/* 802.1ae MACsec */
 #define ETH_P_8021AH	0x88E7          /* 802.1ah Backbone Service Tag */
 #define ETH_P_MVRP	0x88F5          /* 802.1Q MVRP                  */
diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
new file mode 100644
index 000000000000..c5a3d0a2b400
--- /dev/null
+++ b/include/uapi/linux/mrp_bridge.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_MRP_BRIDGE_H
+#define _UAPI_LINUX_MRP_BRIDGE_H
+
+/* These are the attributes used by the generic netlink interface for MRP
+ * BR_MRP_ATTR_BR_IFINDEX - must be the ifindex of the bridge
+ * BR_MRP_ATTR_PORT_IFINDEX - represents the index of one of the ports under the
+ *			      bridge, this is used in both cases to set the
+ *			      primary and secondary port.
+ * BR_MRP_ATTR_RING_NR - represents the ID of each MRP instance. On a bridge can
+ *			 multiple MRP instances.
+ * BR_MRP_ATTR_RING_ROLE - represents the role of the MRP instance. This
+ *			   attribute corresponds to the enum
+ *			   br_mrp_ring_role_type.
+ * BR_MRP_ATTR_RING_STATE - represents the state of the MRP instance. This
+ *			    attribute corresponds to the enum
+ *			    br_mrp_ring_state_type.
+ * BR_MRP_ATTR_PORT_STATE - represents the state of the MRP port. Add means if
+ *			    the port is allowed to forward or not non-MRP
+ *			    frames. It corresponds to enum
+ *			    br_mrp_port_state_type.
+ * BR_MRP_ATTR_PORT_ROLE - represents the role of the MRP port. It corresponds
+ *			   to enum br_mrp_port_role_type.
+ * BR_MRP_ATTR_TEST_INTERVAL - represents the interval of the generated MRP_Test
+ *			       frames. The value is in us.
+ * BR_MRP_ATTR_TEST_MAX_MISS - represents the number of MRP_Test frames that the
+ *			       port can miss before it notifies that the ring
+ *			       is open.
+ * BR_MRP_ATTR_RING_OPEN - represents the Loss of continuity of a port. A value
+ *			   of 1 means that the port stopped receiving MRP_Test
+ *			   while a value of 0 means that the port started to
+ *			   receive MRP_Test frames
+ *
+ * Kernel needs to know about the attributes BR_MRP_ATTR_RING_STATE and
+ * BR_MRP_ATTR_PORT_ROLE because in case it can offload the generation of
+ * MRP_Test frames to HW then the HW needs to know these attributes to be able
+ * to generate correctly MRP_Test frames.
+ */
+enum br_mrp_attr {
+	BR_MRP_ATTR_NONE,
+	BR_MRP_ATTR_BR_IFINDEX,
+	BR_MRP_ATTR_PORT_IFINDEX,
+	BR_MRP_ATTR_RING_NR,
+	BR_MRP_ATTR_RING_ROLE,
+	BR_MRP_ATTR_RING_STATE,
+	BR_MRP_ATTR_PORT_STATE,
+	BR_MRP_ATTR_PORT_ROLE,
+	BR_MRP_ATTR_TEST_INTERVAL,
+	BR_MRP_ATTR_TEST_MAX_MISS,
+	BR_MRP_ATTR_RING_OPEN,
+
+	/* This must be the last entry */
+	BR_MRP_ATTR_END,
+};
+
+#define BR_MRP_ATTR_MAX		(BR_MRP_ATTR_END - 1)
+
+/* These are the commands used by the generic netlink interface for MRP
+ * BR_MRP_GENL_ADD - creates an MRP instance. This doesn't have yet any MRP
+ *		     ports attach to it.
+ * BR_MRP_GENL_ADD_PORT - adds a port to an MRP instance. A port can't be part
+ *			  of multiple MRP instances.
+ * BR_MRP_GENL_DEL - deletes an MRP instance. By deleting the instance also the
+ *		     MRP ports are removed.
+ * BR_MRP_GENL_DEL_PORT - removes a port from an MRP instance.
+ * BR_MRP_GENL_SET_PORT_STATE - sets the port state.
+ * BR_MRP_GENL_SET_PORT_ROLE - sets the port role.
+ * BR_MRP_GENL_SET_RING_STATE - sets the ring state.
+ * BR_MRP_GENL_SET_RING_ROLE - sets the ring role.
+ * BR_MRP_GENL_SET_START_TEST - this command is used to notify the Kernel to
+ *				start to generate MRP frames. A value of 0 for
+ *				the attribute BR_MRP_ATTR_TEST_INTERVAL means
+ *				that it should stop to generate frames.
+ * BR_MRP_GENL_FLUSH - this command is used to flush the fdb.
+ * BR_MRP_GENL_RING_OPEN - it is used by the kernel to notify userspace
+ * 			   applications that one of the MRP ring ports stopped
+ * 			   receiving MRP_Test frames
+ */
+enum br_mrp_genl {
+	BR_MRP_GENL_ADD,
+	BR_MRP_GENL_ADD_PORT,
+	BR_MRP_GENL_DEL,
+	BR_MRP_GENL_DEL_PORT,
+	BR_MRP_GENL_SET_PORT_STATE,
+	BR_MRP_GENL_SET_PORT_ROLE,
+	BR_MRP_GENL_SET_RING_STATE,
+	BR_MRP_GENL_SET_RING_ROLE,
+	BR_MRP_GENL_START_TEST,
+	BR_MRP_GENL_FLUSH,
+	BR_MRP_GENL_RING_OPEN,
+};
+
+enum br_mrp_ring_role_type {
+	BR_MRP_RING_ROLE_DISABLED,
+	BR_MRP_RING_ROLE_MRC,
+	BR_MRP_RING_ROLE_MRM,
+};
+
+enum br_mrp_ring_state_type {
+	BR_MRP_RING_STATE_OPEN,
+	BR_MRP_RING_STATE_CLOSED,
+};
+
+enum br_mrp_port_state_type {
+	BR_MRP_PORT_STATE_DISABLED,
+	BR_MRP_PORT_STATE_BLOCKED,
+	BR_MRP_PORT_STATE_FORWARDING,
+	BR_MRP_PORT_STATE_NOT_CONNECTED,
+};
+
+enum br_mrp_port_role_type {
+	BR_MRP_PORT_ROLE_PRIMARY,
+	BR_MRP_PORT_ROLE_SECONDARY,
+	BR_MRP_PORT_ROLE_NONE,
+};
+
+#endif
-- 
2.17.1

