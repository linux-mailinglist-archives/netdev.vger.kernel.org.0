Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7B1A795D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439057AbgDNL1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:27:25 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:34443 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439035AbgDNL1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863634; x=1618399634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=vDrpOpgEWHfNz6LI1u5HydEX1GJ5sS1kWXjTC9pmWsg=;
  b=YX9r+Z8GlCQ96azSUOdvlggfvCkQlMJ4/Io5siYKDgzC/aN/Z8hAqb3q
   +imw+2RVKA7Dt4QP8fRU0tfS0lEOXN+p7zgncZJtuFLn9uViG06+Vfhur
   0pt4AuC19O6zINfuaW+CBdNZBzL52RFJ6y/zRBbzFgY1Biyc0tJ9tdfYO
   7Q2//9jofbHe0e4BGR+/a8DXWBcuimHjQ6Dca3LS7IF1hYx+xJcqRDGAM
   goo1CFfv4pKdVPBaNzIgAtOqDsHVdwvu9dQjTnv4RP4hzbyfVWUHd6/6K
   aqeKhU5DFTMtqRDP4Jn9w3B15jIDKEYslgPPvKBuuFwwZhXZMVktvDSum
   Q==;
IronPort-SDR: rX5J6VHqddVRIcI8NSm7P9/i86F5hEMNJ39lzcUT+8CITOMF0TPvg3ln4ns/bNHH3w8yxS7ntY
 LN+yRplK9M1XEZGyJuw+5NEmmZW1IidQqdBUfIqeZrmayP7gYguMXtA6t0U557s09M0I94BGQy
 +dOcc+BoWAJ2IkXNQeznLazHn16YgXhDovkzI1hqMOmB4K0n6G1LxSkW2DkkDq5PhOW7/IM+Fd
 FKnI5KcUWwuHb//tjtHGFvrsX766V6/YiSUqDcfHTCvdsbLRq4reqWGvCF9cI75mGFynMZS3e5
 qz0=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="9066813"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:27:13 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 1/9] bridge: uapi: mrp: Add mrp attributes.
Date:   Tue, 14 Apr 2020 13:26:10 +0200
Message-ID: <20200414112618.3644-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new nested netlink attribute to configure the MRP. These attributes are used
by the userspace to add/delete/configure MRP instances and by the kernel to
notify the userspace when the MRP ring gets open/closed. MRP nested attribute
has the following attributes:

IFLA_BRIDGE_MRP_INSTANCE - the parameter type is br_mrp_instance which contains
  the instance id, and the ifindex of the two ports. The ports can't be part of
  multiple instances. This is used to create/delete MRP instances.

IFLA_BRIDGE_MRP_PORT_STATE - the parameter type is u32. Which can be forwarding,
  blocking or disabled.

IFLA_BRIDGE_MRP_PORT_ROLE - the parameter type is br_mrp_port_role which
  contains the instance id and the role. The role can be primary or secondary.

IFLA_BRIDGE_MRP_RING_STATE - the parameter type is br_mrp_ring_state which
  contains the instance id and the state. The state can be open or closed.

IFLA_BRIDGE_MRP_RING_ROLE - the parameter type is br_mrp_ring_role which
  contains the instance id and the ring role. The role can be MRM or MRC.

IFLA_BRIDGE_MRP_START_TEST - the parameter type is br_mrp_start_test which
  contains the instance id, the interval at which to send the MRP_Test frames,
  how many test frames can be missed before declaring the ring open and the
  period which represent for how long to send the test frames.

IFLA_BRIDGE_MRP_RING_OPEN - the parameter type is u32 and has a value of 1 if
  the port stopped receiving test frames and a value 0 is started to receive
  them.  This attribut is used by the kernel to notify the userspace when the
  ring gets open or closed.

Also add the file include/uapi/linux/mrp_bridge.h which defines all the types
used by MRP that are also needed by the userpace.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/if_bridge.h  | 43 +++++++++++++++++
 include/uapi/linux/if_ether.h   |  1 +
 include/uapi/linux/mrp_bridge.h | 84 +++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 include/uapi/linux/mrp_bridge.h

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index bfe621ea51b3..5853162cca89 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -120,6 +120,7 @@ enum {
 	IFLA_BRIDGE_MODE,
 	IFLA_BRIDGE_VLAN_INFO,
 	IFLA_BRIDGE_VLAN_TUNNEL_INFO,
+	IFLA_BRIDGE_MRP,
 	__IFLA_BRIDGE_MAX,
 };
 #define IFLA_BRIDGE_MAX (__IFLA_BRIDGE_MAX - 1)
@@ -157,6 +158,48 @@ struct bridge_vlan_xstats {
 	__u32 pad2;
 };
 
+enum {
+	IFLA_BRIDGE_MRP_UNSPEC,
+	IFLA_BRIDGE_MRP_INSTANCE,
+	IFLA_BRIDGE_MRP_PORT_STATE,
+	IFLA_BRIDGE_MRP_PORT_ROLE,
+	IFLA_BRIDGE_MRP_RING_STATE,
+	IFLA_BRIDGE_MRP_RING_ROLE,
+	IFLA_BRIDGE_MRP_START_TEST,
+	IFLA_BRIDGE_MRP_RING_OPEN,
+	__IFLA_BRIDGE_MRP_MAX,
+};
+
+struct br_mrp_instance {
+	__u32 ring_id;
+	__u32 p_ifindex;
+	__u32 s_ifindex;
+};
+
+struct br_mrp_port_role {
+	__u32 ring_id;
+	__u32 role;
+};
+
+struct br_mrp_ring_state {
+	__u32 ring_id;
+	__u32 ring_state;
+};
+
+struct br_mrp_ring_role {
+	__u32 ring_id;
+	__u32 ring_role;
+};
+
+struct br_mrp_start_test {
+	__u32 ring_id;
+	__u32 interval;
+	__u32 max_miss;
+	__u32 period;
+};
+
+#define IFLA_BRIDGE_MRP_MAX (__IFLA_BRIDGE_MRP_MAX - 1)
+
 struct bridge_stp_xstats {
 	__u64 transition_blk;
 	__u64 transition_fwd;
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
index 000000000000..2600cdf5a284
--- /dev/null
+++ b/include/uapi/linux/mrp_bridge.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_MRP_BRIDGE_H_
+#define _UAPI_LINUX_MRP_BRIDGE_H_
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define MRP_MAX_FRAME_LENGTH		200
+#define MRP_DEFAULT_PRIO		0x8000
+#define MRP_DOMAIN_UUID_LENGTH		16
+#define MRP_VERSION			1
+#define MRP_FRAME_PRIO			7
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
+enum br_mrp_tlv_header_type {
+	BR_MRP_TLV_HEADER_END = 0x0,
+	BR_MRP_TLV_HEADER_COMMON = 0x1,
+	BR_MRP_TLV_HEADER_RING_TEST = 0x2,
+	BR_MRP_TLV_HEADER_RING_TOPO = 0x3,
+	BR_MRP_TLV_HEADER_RING_LINK_DOWN = 0x4,
+	BR_MRP_TLV_HEADER_RING_LINK_UP = 0x5,
+};
+
+struct br_mrp_tlv_hdr {
+	__u8 type;
+	__u8 length;
+};
+
+struct br_mrp_end_hdr {
+	struct br_mrp_tlv_hdr hdr;
+};
+
+struct br_mrp_common_hdr {
+	__u16 seq_id;
+	__u8 domain[MRP_DOMAIN_UUID_LENGTH];
+};
+
+struct br_mrp_ring_test_hdr {
+	__u16 prio;
+	__u8 sa[ETH_ALEN];
+	__u16 port_role;
+	__u16 state;
+	__u16 transitions;
+	__u32 timestamp;
+};
+
+struct br_mrp_ring_topo_hdr {
+	__u16 prio;
+	__u8 sa[ETH_ALEN];
+	__u16 interval;
+};
+
+struct br_mrp_ring_link_hdr {
+	__u8 sa[ETH_ALEN];
+	__u16 port_role;
+	__u16 interval;
+	__u16 blocked;
+};
+
+#endif
-- 
2.17.1

