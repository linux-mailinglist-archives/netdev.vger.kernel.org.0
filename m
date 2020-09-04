Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E772325D489
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgIDJTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:19:19 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43022 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730025AbgIDJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599211157; x=1630747157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qPVRsoMSxfAMJPDcs1ETVil+y004jQskQu0zkiyJ718=;
  b=JLq1hnRJ7eYIvtwyiYGH3cNlUyqLisJ3FDn/bWiy1bnn6J+z3R2aaCHR
   +MfuWxxMWxT1ZxhoNUsGqAYkwsbKomrPaIB3LPO/uTvIAMBVrel/xYtCD
   p30HcsWJckHDewbHV/VHqqOGF+FbSnaeQ/VGVUghCYKOMOe/S/0oqtFIe
   kx/emw7RtWZoSuKh0IsYpmR0SpXIkC1A+AKl+3I3/YsZZcpQ9NweQKlgF
   kueHndpITg22Ti24dN3WGds4/NJh/ZiY5GQL5+XGhN2eusJLDjxix8nlr
   5k2a/jBqCUXM4SyXIUcX+RIQUsFegHYoQxzxttY18jwVYIrItkl865ztG
   A==;
IronPort-SDR: vlw+OvQLYc2MsnIm4UcUtrMy0jftvZzCqqODQUigumk0Qdp5tdjwTE8aIkzeYJ3jrsLEpjgX5I
 96AL5to26GGZcjWXWp/OicbnyXjtoK4whnYl3qO2EDHCwew8IYj6NvKU7L/xiS24vii7RtfqdG
 8Pz4c//u8CG/CmeaQgpayPtQa8wSZXMvEd++UUlXUEQXPOvLthVV8Km5iHdWQUmPWQV5IfD78E
 tn6kl6SIOCtk7lGHSzzcSGIx+CqZRxe60SUDJdYeqkS4CCA9sE0tAHmukD6KQoolgii12p/Ysy
 n+A=
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="89829036"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Sep 2020 02:19:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 02:18:27 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Sep 2020 02:19:11 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH RFC 4/7] bridge: cfm: Kernel space implementation of CFM.
Date:   Fri, 4 Sep 2020 09:15:24 +0000
Message-ID: <20200904091527.669109-5-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the implementation of the CFM protocol according to
802.1Q section 12.14.

Connectivity Fault Management (CFM) comprises capabilities for
detecting, verifying, and isolating connectivity failures in
Virtual Bridged Networks. These capabilities can be used in
networks operated by multiple independent organizations, each
with restricted management access to each other’s equipment.

CFM functions are partitioned as follows:
    - Path discovery
    - Fault detection
    - Fault verification and isolation
    - Fault notification
    - Fault recovery

Interface consists of these functions:
br_cfm_mep_create()
br_cfm_mep_delete()
br_cfm_mep_config_set()
br_cfm_mep_status_get()
br_cfm_mep_counters_get()
br_cfm_mep_counters_clear()
br_cfm_cc_config_set()
br_cfm_cc_peer_mep_add()
br_cfm_cc_peer_mep_remove()
br_cfm_cc_rdi_set()
br_cfm_cc_ccm_tx()
br_cfm_cc_status_get()
br_cfm_cc_counters_get()
br_cfm_cc_counters_clear()
br_cfm_cc_peer_status_get()

A MEP instance is created by br_cfm_mep_create()
    -It is the Maintenance association End Point
     described in 802.1Q section 19.2.
    -It is created on a specific level (1-7) and is assuring
     that no CFM frames are passing through this MEP on lower levels.
    -It initiates and validates CFM frames on its level.
    -It can only exist on a port that is related to a bridge.
    -Attributes given cannot be changed until the instance is
     deleted.

A MEP instance can be deleted by br_cfm_mep_delete().

A created MEP instance has attributes that can be
configured by br_cfm_mep_config_set().

A MEP contain status and counter information that can be
retrieved by br_cfm_mep_status_get() and
br_cfm_mep_counters_get().

A MEP counters can be cleared by br_cfm_mep_counters_clear().

A MEP Continuity Check feature can be configured by
br_cfm_cc_config_set()
    The Continuity Check Receiver state machine can be
    enabled and disabled.
    According to 802.1Q section 19.2.8

A MEP can have Peer MEPs added and removed by
br_cfm_cc_peer_mep_add() and br_cfm_cc_peer_mep_remove()
    The Continuity Check feature can maintain connectivity
    status on each added Peer MEP.

A MEP can be configured to start or stop transmission of CCM frames by
br_cfm_cc_ccm_tx()
    The CCM will be transmitted for a selected period in seconds.
    Must call this function before timeout to keep transmission alive.

A MEP transmitting CCM can be configured with inserted RDI in PDU by
br_cfm_cc_rdi_set()

A MEP contain Continuity Check status and counter information
that can be retrieved by br_cfm_cc_status_get() and
br_cfm_cc_counters_get().

A MEP Continuity Check counters can be cleared
by br_cfm_cc_counters_clear().

A MEP contain Peer MEP Continuity Check status information that
can be retrieved by br_cfm_cc_peer_status_get().

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 include/uapi/linux/cfm_bridge.h |  75 +++
 net/bridge/Makefile             |   2 +
 net/bridge/br_cfm.c             | 880 ++++++++++++++++++++++++++++++++
 net/bridge/br_private.h         |  16 +
 net/bridge/br_private_cfm.h     | 242 +++++++++
 5 files changed, 1215 insertions(+)
 create mode 100644 include/uapi/linux/cfm_bridge.h
 create mode 100644 net/bridge/br_cfm.c
 create mode 100644 net/bridge/br_private_cfm.h

diff --git a/include/uapi/linux/cfm_bridge.h b/include/uapi/linux/cfm_bridge.h
new file mode 100644
index 000000000000..389ea1e1f68e
--- /dev/null
+++ b/include/uapi/linux/cfm_bridge.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_CFM_BRIDGE_H_
+#define _UAPI_LINUX_CFM_BRIDGE_H_
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define ETHER_HEADER_LENGTH		(6+6+4+2)
+#define CFM_MAID_LENGTH			48
+#define CFM_CCM_PDU_LENGTH		75
+#define CFM_PORT_STATUS_TLV_LENGTH	4
+#define CFM_IF_STATUS_TLV_LENGTH	4
+#define CFM_IF_STATUS_TLV_TYPE		4
+#define CFM_PORT_STATUS_TLV_TYPE	2
+#define CFM_ENDE_TLV_TYPE		0
+#define CFM_CCM_MAX_FRAME_LENGTH	(ETHER_HEADER_LENGTH+\
+					 CFM_CCM_PDU_LENGTH+\
+					 CFM_PORT_STATUS_TLV_LENGTH+\
+					 CFM_IF_STATUS_TLV_LENGTH)
+#define CFM_FRAME_PRIO			7
+#define CFM_CCM_OPCODE			1
+#define CFM_CCM_TLV_OFFSET		70
+#define CFM_CCM_PDU_MAID_OFFSET		10
+#define CFM_CCM_PDU_MEPID_OFFSET	8
+#define CFM_CCM_PDU_SEQNR_OFFSET	4
+#define CFM_CCM_PDU_TLV_OFFSET		74
+#define CFM_CCM_ITU_RESERVED_SIZE	16
+
+struct br_cfm_common_hdr {
+	__u8 mdlevel_version;
+	__u8 opcode;
+	__u8 flags;
+	__u8 tlv_offset;
+};
+
+struct br_cfm_status_tlv {
+	__u8 type;
+	__be16 length;
+	__u8 value;
+};
+
+enum br_cfm_opcodes {
+	BR_CFM_OPCODE_CCM = 0x1,
+	BR_CFM_OPCODE_LBR = 0x2,
+	BR_CFM_OPCODE_LBM = 0x3,
+	BR_CFM_OPCODE_LTR = 0x4,
+	BR_CFM_OPCODE_LTM = 0x5,
+};
+
+/* MEP domain */
+enum br_cfm_domain {
+	BR_CFM_PORT,
+	BR_CFM_VLAN,
+};
+
+/* MEP direction */
+enum br_cfm_mep_direction {
+	BR_CFM_MEP_DIRECTION_DOWN,
+	BR_CFM_MEP_DIRECTION_UP,
+};
+
+/* CCM interval supported. */
+enum br_cfm_ccm_interval {
+	BR_CFM_CCM_INTERVAL_NONE,
+	BR_CFM_CCM_INTERVAL_3_3_MS,
+	BR_CFM_CCM_INTERVAL_10_MS,
+	BR_CFM_CCM_INTERVAL_100_MS,
+	BR_CFM_CCM_INTERVAL_1_SEC,
+	BR_CFM_CCM_INTERVAL_10_SEC,
+	BR_CFM_CCM_INTERVAL_1_MIN,
+	BR_CFM_CCM_INTERVAL_10_MIN,
+};
+
+#endif
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index ccb394236fbd..ddc0a9192348 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -27,3 +27,5 @@ bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 obj-$(CONFIG_NETFILTER) += netfilter/
 
 bridge-$(CONFIG_BRIDGE_MRP)	+= br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
+
+bridge-$(CONFIG_BRIDGE_CFM)	+= br_cfm.o
diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
new file mode 100644
index 000000000000..e38cc3e8f262
--- /dev/null
+++ b/net/bridge/br_cfm.c
@@ -0,0 +1,880 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/cfm_bridge.h>
+#include <uapi/linux/cfm_bridge.h>
+#include "br_private_cfm.h"
+
+static struct br_cfm_mep *br_mep_find(struct net_bridge *br, u32 instance)
+{
+	struct br_cfm_mep *res = NULL;
+	struct br_cfm_mep *mep;
+
+	list_for_each_entry_rcu(mep, &br->mep_list, head,
+				lockdep_rtnl_is_held()) {
+		if (mep->instance == instance) {
+			res = mep;
+			break;
+		}
+	}
+
+	return res;
+}
+
+static struct br_cfm_mep *br_mep_find_ifindex(struct net_bridge *br,
+					      u32 ifindex)
+{
+	struct br_cfm_mep *res = NULL;
+	struct br_cfm_mep *mep;
+
+	list_for_each_entry_rcu(mep, &br->mep_list, head,
+				lockdep_rtnl_is_held()) {
+		if (mep->create.ifindex == ifindex) {
+			res = mep;
+			break;
+		}
+	}
+
+	return res;
+}
+
+static struct br_cfm_peer_mep *br_peer_mep_find(struct br_cfm_mep *mep,
+						u32 mepid)
+{
+	struct br_cfm_peer_mep *res = NULL;
+	struct br_cfm_peer_mep *peer_mep;
+
+	list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head,
+				lockdep_rtnl_is_held()) {
+		if (peer_mep->mepid == mepid) {
+			res = peer_mep;
+			break;
+		}
+	}
+
+	return res;
+}
+
+static struct net_bridge_port *br_mep_get_port(struct net_bridge *br,
+					       u32 ifindex)
+{
+	struct net_bridge_port *res = NULL;
+	struct net_bridge_port *port;
+
+	list_for_each_entry(port, &br->port_list, list) {
+		if (port->dev->ifindex == ifindex) {
+			res = port;
+			break;
+		}
+	}
+
+	return res;
+}
+
+/* Calculate the CCM interval in us. */
+static u32 interval_to_us(enum br_cfm_ccm_interval interval)
+{
+	switch (interval) {
+	case BR_CFM_CCM_INTERVAL_NONE:
+		return 0;
+	case BR_CFM_CCM_INTERVAL_3_3_MS:
+		return 3300;
+	case BR_CFM_CCM_INTERVAL_10_MS:
+		return 10 * 1000;
+	case BR_CFM_CCM_INTERVAL_100_MS:
+		return 100 * 1000;
+	case BR_CFM_CCM_INTERVAL_1_SEC:
+		return 1000 * 1000;
+	case BR_CFM_CCM_INTERVAL_10_SEC:
+		return 10 * 1000 * 1000;
+	case BR_CFM_CCM_INTERVAL_1_MIN:
+		return 60 * 1000 * 1000;
+	case BR_CFM_CCM_INTERVAL_10_MIN:
+		return 10 * 60 * 1000 * 1000;
+	}
+	return 0;
+}
+
+/* Convert the interface interval to CCM PDU value. */
+static u32 interval_to_pdu(enum br_cfm_ccm_interval interval)
+{
+	switch (interval) {
+	case BR_CFM_CCM_INTERVAL_NONE:
+		return 0;
+	case BR_CFM_CCM_INTERVAL_3_3_MS:
+		return 1;
+	case BR_CFM_CCM_INTERVAL_10_MS:
+		return 2;
+	case BR_CFM_CCM_INTERVAL_100_MS:
+		return 3;
+	case BR_CFM_CCM_INTERVAL_1_SEC:
+		return 4;
+	case BR_CFM_CCM_INTERVAL_10_SEC:
+		return 5;
+	case BR_CFM_CCM_INTERVAL_1_MIN:
+		return 6;
+	case BR_CFM_CCM_INTERVAL_10_MIN:
+		return 7;
+	}
+	return 0;
+}
+
+/* Convert the CCM PDU value to interval on interface. */
+static u32 pdu_to_interval(u32 value)
+{
+	switch (value) {
+	case 0:
+		return BR_CFM_CCM_INTERVAL_NONE;
+	case 1:
+		return BR_CFM_CCM_INTERVAL_3_3_MS;
+	case 2:
+		return BR_CFM_CCM_INTERVAL_10_MS;
+	case 3:
+		return BR_CFM_CCM_INTERVAL_100_MS;
+	case 4:
+		return BR_CFM_CCM_INTERVAL_1_SEC;
+	case 5:
+		return BR_CFM_CCM_INTERVAL_10_SEC;
+	case 6:
+		return BR_CFM_CCM_INTERVAL_1_MIN;
+	case 7:
+		return BR_CFM_CCM_INTERVAL_10_MIN;
+	}
+	return BR_CFM_CCM_INTERVAL_NONE;
+}
+
+static void ccm_rx_timer_start(struct br_cfm_peer_mep *peer_mep)
+{
+	u32 interval_us;
+
+	interval_us = interval_to_us(peer_mep->mep->cc_config.exp_interval);
+	/* Function ccm_rx_dwork must be called with 1/4
+	 * of the configured CC 'expected_interval'
+	 * in order to detect CCM defect after 3.25 interval.
+	 */
+	queue_delayed_work(system_wq, &peer_mep->ccm_rx_dwork,
+			   usecs_to_jiffies(interval_us / 4));
+}
+
+static void cc_peer_enable(struct br_cfm_peer_mep *peer_mep)
+{
+	memset(&peer_mep->cc_status, 0, sizeof(peer_mep->cc_status));
+	peer_mep->ccm_rx_count_miss = 0;
+
+	ccm_rx_timer_start(peer_mep);
+}
+
+static void cc_peer_disable(struct br_cfm_peer_mep *peer_mep)
+{
+	cancel_delayed_work_sync(&peer_mep->ccm_rx_dwork);
+}
+
+static struct sk_buff *ccm_frame_build(struct br_cfm_mep *mep,
+				       const struct br_cfm_cc_ccm_tx_info *const tx_info)
+
+{
+	struct br_cfm_common_hdr *common_hdr;
+	struct net_bridge_port *b_port;
+	struct br_cfm_maid *maid;
+	u8 *itu_reserved, *e_tlv;
+	struct ethhdr *eth_hdr;
+	struct sk_buff *skb;
+	__be32 *status_tlv;
+	__be32 *snumber;
+	__be16 *mepid;
+
+	rcu_read_lock();
+	b_port = rcu_dereference(mep->b_port);
+	if (!b_port)
+		return NULL;
+	skb = dev_alloc_skb(CFM_CCM_MAX_FRAME_LENGTH);
+	if (!skb)
+		return NULL;
+
+	skb->dev = b_port->dev;
+	rcu_read_unlock();
+	skb->protocol = htons(ETH_P_CFM);
+	skb->priority = CFM_FRAME_PRIO;
+
+	/* Ethernet header */
+	eth_hdr = skb_put(skb, sizeof(*eth_hdr));
+	ether_addr_copy(eth_hdr->h_dest, tx_info->dmac.addr);
+	ether_addr_copy(eth_hdr->h_source, mep->config.unicast_mac.addr);
+	eth_hdr->h_proto = htons(ETH_P_CFM);
+
+	/* Common CFM Header */
+	common_hdr = skb_put(skb, sizeof(*common_hdr));
+	common_hdr->mdlevel_version = mep->config.mdlevel << 5;
+	common_hdr->opcode = CFM_CCM_OPCODE;
+	common_hdr->flags = (mep->rdi << 7) |
+			    interval_to_pdu(mep->cc_config.exp_interval);
+	common_hdr->tlv_offset = CFM_CCM_TLV_OFFSET;
+
+	/* Sequence number */
+	snumber = skb_put(skb, sizeof(*snumber));
+	if (tx_info->seq_no_update) {
+		*snumber = cpu_to_be32(mep->ccm_tx_snumber);
+		mep->ccm_tx_snumber += 1;
+	} else {
+		*snumber = 0;
+	}
+
+	/* MEP ID */
+	mepid = skb_put(skb, sizeof(*mepid));
+	*mepid = cpu_to_be16((u16)mep->config.mepid);
+
+	/* MA ID */
+	maid = skb_put(skb, sizeof(*maid));
+	memcpy(maid->data, mep->cc_config.exp_maid.data, sizeof(maid->data));
+
+	/* ITU reserved (CFM_CCM_ITU_RESERVED_SIZE octets) */
+	itu_reserved = skb_put(skb, CFM_CCM_ITU_RESERVED_SIZE);
+	memset(itu_reserved, 0, CFM_CCM_ITU_RESERVED_SIZE);
+
+	/* Generel CFM TLV format:
+	 * TLV type:		one byte
+	 * TLV value length:	two bytes
+	 * TLV value:		'TLV value length' bytes
+	 */
+
+	/* Port status TLV. The value length is 1. Total of 4 bytes. */
+	if (tx_info->port_tlv) {
+		status_tlv = skb_put(skb, sizeof(*status_tlv));
+		*status_tlv = cpu_to_be32((CFM_PORT_STATUS_TLV_TYPE << 24) |
+					  (1 << 8) |	/* Value length */
+					  (tx_info->port_tlv_value & 0xFF));
+	}
+
+	/* Interface status TLV. The value length is 1. Total of 4 bytes. */
+	if (tx_info->if_tlv) {
+		status_tlv = skb_put(skb, sizeof(*status_tlv));
+		*status_tlv = cpu_to_be32((CFM_IF_STATUS_TLV_TYPE << 24) |
+					  (1 << 8) |	/* Value length */
+					  (tx_info->if_tlv_value & 0xFF));
+	}
+
+	/* End TLV */
+	e_tlv = skb_put(skb, sizeof(*e_tlv));
+	*e_tlv = CFM_ENDE_TLV_TYPE;
+
+	return skb;
+}
+
+static void ccm_frame_tx(struct sk_buff *skb)
+{
+	skb_reset_network_header(skb);
+	dev_queue_xmit(skb);
+}
+
+/* This function is called with the configured CC 'expected_interval'
+ * in order to drive CCM transmission when enabled.
+ */
+static void ccm_tx_work_expired(struct work_struct *work)
+{
+	struct delayed_work *del_work;
+	struct br_cfm_mep *mep;
+	struct sk_buff *skb;
+	u32 interval_us;
+
+	del_work = to_delayed_work(work);
+	mep = container_of(del_work, struct br_cfm_mep, ccm_tx_dwork);
+
+	if (time_before_eq(mep->ccm_tx_end, jiffies)) {
+		/* Transmission period has ended */
+		mep->cc_ccm_tx_info.period = 0;
+		return;
+	}
+
+	skb = ccm_frame_build(mep, &mep->cc_ccm_tx_info);
+	if (skb)
+		ccm_frame_tx(skb);
+
+	interval_us = interval_to_us(mep->cc_config.exp_interval);
+	queue_delayed_work(system_wq, &mep->ccm_tx_dwork,
+			   usecs_to_jiffies(interval_us));
+}
+
+/* This function is called with 1/4 of the configured CC 'expected_interval'
+ * in order to detect CCM defect after 3.25 interval.
+ */
+static void ccm_rx_work_expired(struct work_struct *work)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct delayed_work *del_work;
+
+	del_work = to_delayed_work(work);
+	peer_mep = container_of(del_work, struct br_cfm_peer_mep, ccm_rx_dwork);
+
+	/* After 13 counts (4 * 3,25) then 3.25 intervals are expired */
+	if (peer_mep->ccm_rx_count_miss < 13) {
+		/* 3.25 intervals are NOT expired without CCM reception */
+		peer_mep->ccm_rx_count_miss++;
+
+		/* Start timer again */
+		ccm_rx_timer_start(peer_mep);
+	} else {
+		/* 3.25 intervals are expired without CCM reception.
+		 * CCM defect detected
+		 */
+		peer_mep->cc_status.ccm_defect = true;
+
+		/* Change in CCM defect status - notify */
+	}
+}
+
+static u32 ccm_tlv_extract(struct sk_buff *skb, u32 index,
+			   struct br_cfm_peer_mep *peer_mep)
+{
+	__be32 *s_tlv;
+	__be32 _s_tlv;
+	u32 h_s_tlv;
+	u8 *e_tlv;
+	u8 _e_tlv;
+
+	e_tlv = skb_header_pointer(skb, index, sizeof(_e_tlv), &_e_tlv);
+	if (!e_tlv)
+		return 0;
+
+	/* TLV is present - get the status TLV */
+	s_tlv = skb_header_pointer(skb,
+				   index,
+				   sizeof(_s_tlv), &_s_tlv);
+	if (!s_tlv)
+		return 0;
+
+	h_s_tlv = ntohl(*s_tlv);
+	if ((h_s_tlv >> 24) == CFM_IF_STATUS_TLV_TYPE) {
+		/* Interface status TLV */
+		peer_mep->cc_status.tlv_seen = true;
+		peer_mep->cc_status.if_tlv_value = (h_s_tlv & 0xFF);
+	}
+
+	if ((h_s_tlv >> 24) == CFM_PORT_STATUS_TLV_TYPE) {
+		/* Port status TLV */
+		peer_mep->cc_status.tlv_seen = true;
+		peer_mep->cc_status.port_tlv_value = (h_s_tlv & 0xFF);
+	}
+
+	/* The Sender ID TLV is not handled */
+	/* The Organization-Specific TLV is not handled */
+
+	/* Return the length of this tlv.
+	 * This is the length of the value field plus 3 bytes for size of type
+	 * field and length field
+	 */
+	return ((h_s_tlv >> 8) & 0xFFFF) + 3;
+}
+
+/* note: already called with rcu_read_lock */
+static int br_cfm_frame_rx(struct net_bridge_port *port, struct sk_buff *skb)
+{
+	u32 mdlevel, interval, size, index, max;
+	const struct br_cfm_common_hdr *hdr;
+	struct br_cfm_peer_mep *peer_mep;
+	const struct br_cfm_maid *maid;
+	struct br_cfm_common_hdr _hdr;
+	struct br_cfm_maid _maid;
+	struct br_cfm_mep *mep;
+	struct net_bridge *br;
+	__be32 *snumber;
+	__be32 _snumber;
+	__be16 *mepid;
+	__be16 _mepid;
+
+	/* If port is disabled don't accept any frames */
+	if (port->state == BR_STATE_DISABLED)
+		return 0;
+
+	hdr = skb_header_pointer(skb, 0, sizeof(_hdr), &_hdr);
+	if (!hdr)
+		return 1;
+
+	br = port->br;
+	mep = br_mep_find_ifindex(br, port->dev->ifindex);
+	if (unlikely(!mep))
+		/* No MEP on this port - must be forwarded */
+		return 0;
+
+	mdlevel = hdr->mdlevel_version >> 5;
+	if (mdlevel > mep->config.mdlevel)
+		/* The level is above this MEP level - must be forwarded */
+		return 0;
+
+	if ((hdr->mdlevel_version & 0x1F) != 0) {
+		/* Invalid version */
+		mep->status.version_unexp_seen = true;
+		return 1;
+	}
+
+	if (mdlevel < mep->config.mdlevel) {
+		/* The level is below this MEP level */
+		mep->status.rx_level_low_seen = true;
+		return 1;
+	}
+
+	if (hdr->opcode == BR_CFM_OPCODE_CCM) {
+		/* CCM PDU received. */
+		/* MA ID is after common header + sequence number + MEP ID */
+		maid = skb_header_pointer(skb,
+					  CFM_CCM_PDU_MAID_OFFSET,
+					  sizeof(_maid), &_maid);
+		if (!maid)
+			return 1;
+		if (memcmp(maid->data, mep->cc_config.exp_maid.data,
+			   sizeof(maid->data)))
+			/* MA ID not as expected */
+			return 1;
+
+		/* MEP ID is after common header + sequence number */
+		mepid = skb_header_pointer(skb,
+					   CFM_CCM_PDU_MEPID_OFFSET,
+					   sizeof(_mepid), &_mepid);
+		if (!mepid)
+			return 1;
+		peer_mep = br_peer_mep_find(mep, (u32)ntohs(*mepid));
+		if (!peer_mep)
+			return 1;
+
+		/* Interval is in common header flags */
+		interval = hdr->flags & 0x07;
+		if (mep->cc_config.exp_interval != pdu_to_interval(interval))
+			/* Interval not as expected */
+			return 1;
+
+		/* A valid CCM frame is received */
+		if (peer_mep->cc_status.ccm_defect) {
+			peer_mep->cc_status.ccm_defect = false;
+
+			/* Change in CCM defect status - notify */
+
+			/* Start CCM RX timer */
+			ccm_rx_timer_start(peer_mep);
+		}
+
+		peer_mep->cc_status.seen = true;
+		peer_mep->ccm_rx_count_miss = 0;
+
+		/* RDI is in common header flags */
+		peer_mep->cc_status.rdi = (hdr->flags & 0x80) ? true : false;
+
+		/* Sequence number is after common header */
+		snumber = skb_header_pointer(skb,
+					     CFM_CCM_PDU_SEQNR_OFFSET,
+					     sizeof(_snumber), &_snumber);
+		if (!snumber)
+			return 1;
+		if (ntohl(*snumber) != (mep->ccm_rx_snumber + 1))
+			/* Unexpected sequence number */
+			peer_mep->cc_status.seq_unexp_seen = true;
+
+		mep->ccm_rx_snumber = ntohl(*snumber);
+
+		/* TLV end is after common header + sequence number + MEP ID +
+		 * MA ID + ITU reserved
+		 */
+		index = CFM_CCM_PDU_TLV_OFFSET;
+		max = 0;
+		do { /* Handle all TLVs */
+			size = ccm_tlv_extract(skb, index, peer_mep);
+			index += size;
+			max += 1;
+		} while (size != 0 && max < 4); /* Max four TLVs possible */
+
+		return 1;
+	}
+
+	mep->status.opcode_unexp_seen = true;
+
+	return 1;
+}
+
+static struct br_frame_type cfm_frame_type __read_mostly = {
+	.type = cpu_to_be16(ETH_P_CFM),
+	.func = br_cfm_frame_rx,
+};
+
+/* note: already called with rtnl_lock */
+int br_cfm_mep_create(struct net_bridge *br,
+		      const u32 instance,
+		      struct br_cfm_mep_create *const create,
+		      struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port *p;
+	struct br_cfm_mep *mep;
+
+	if (create->domain == BR_CFM_VLAN) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN domain not supported");
+		return -EINVAL;
+	}
+	if (create->domain != BR_CFM_PORT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid domain value");
+		return -EINVAL;
+	}
+	if (create->direction == BR_CFM_MEP_DIRECTION_UP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Up-MEP not supported");
+		return -EINVAL;
+	}
+	if (create->direction != BR_CFM_MEP_DIRECTION_DOWN) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid direction value");
+		return -EINVAL;
+	}
+	if (!br_mep_get_port(br, create->ifindex))
+		return -EINVAL;
+
+	mep = br_mep_find(br, instance);
+	if (mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance already created");
+		return -EINVAL;
+	}
+
+	/* In PORT domain only one instance can be created per port */
+	if (create->domain == BR_CFM_PORT) {
+		mep = br_mep_find_ifindex(br, create->ifindex);
+		if (mep) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one Port MEP on a port allowed");
+			return -EINVAL;
+		}
+	}
+
+	mep = kzalloc(sizeof(*mep), GFP_KERNEL);
+	if (!mep)
+		return -ENOMEM;
+
+	/* Save create parameters */
+	mep->create = *create;
+	mep->instance = instance;
+	p = br_mep_get_port(br, mep->create.ifindex);
+	rcu_assign_pointer(mep->b_port, p);
+
+	INIT_LIST_HEAD(&mep->peer_mep_list);
+	INIT_DELAYED_WORK(&mep->ccm_tx_dwork, ccm_tx_work_expired);
+
+	if (list_empty(&br->mep_list))
+		br_add_frame(br, &cfm_frame_type);
+
+	/* Add instance to list */
+	list_add_tail_rcu(&mep->head, &br->mep_list);
+
+	return 0;
+}
+
+static void mep_delete_implementation(struct net_bridge *br,
+				      struct br_cfm_mep *mep)
+{
+	struct br_cfm_peer_mep *peer_mep;
+
+	/* Empty and free peer MEP list */
+	list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head,
+				lockdep_rtnl_is_held()) {
+		cancel_delayed_work_sync(&peer_mep->ccm_rx_dwork);
+		list_del_rcu(&peer_mep->head);
+		kfree_rcu(peer_mep, rcu);
+	}
+
+	/* Stop transmitting */
+	cancel_delayed_work_sync(&mep->ccm_tx_dwork);
+
+	/* Free the MEP instance */
+	rcu_assign_pointer(mep->b_port, NULL);
+	list_del_rcu(&mep->head);
+	kfree_rcu(mep, rcu);
+
+	if (list_empty(&br->mep_list))
+		br_del_frame(br, &cfm_frame_type);
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_mep_delete(struct net_bridge *br,
+		      const u32 instance,
+		      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	mep_delete_implementation(br, mep);
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_mep_config_set(struct net_bridge *br,
+			  const u32 instance,
+			  const struct br_cfm_mep_config *const config,
+			  struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	if (config->mdlevel > 7) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "mdlevel is invalid");
+		return -EINVAL;
+	}
+	if (config->mepid > 0x1FFF) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "mepid is invalid");
+		return -EINVAL;
+	}
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	/* Save config parameters */
+	mep->config = *config;
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_mep_counters_clear(struct net_bridge *br,
+			      const u32 instance,
+			      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	memset(&mep->counters, 0, sizeof(mep->counters));
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_config_set(struct net_bridge *br,
+			 const u32 instance,
+			 const struct br_cfm_cc_config *const config,
+			 struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	/* Check for no change in configuration */
+	if (memcmp(config, &mep->cc_config, sizeof(*config)) == 0)
+		return 0;
+
+	if (config->enable && !mep->cc_config.enable)
+		/* CC is enabled */
+		list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head,
+					lockdep_rtnl_is_held())
+			cc_peer_enable(peer_mep);
+
+	if (!config->enable && mep->cc_config.enable)
+		/* CC is disabled */
+		list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head,
+					lockdep_rtnl_is_held())
+			cc_peer_disable(peer_mep);
+
+	/* Save new cc_config parameters */
+	mep->cc_config = *config;
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
+			   u32 mepid,
+			   struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+	if (mepid > 0x1FFF) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "mepid is invalid");
+		return -EINVAL;
+	}
+
+	peer_mep = br_peer_mep_find(mep, mepid);
+	if (peer_mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Peer MEP-ID already added");
+		return -EINVAL;
+	}
+
+	peer_mep = kzalloc(sizeof(*peer_mep), GFP_KERNEL);
+	if (!peer_mep)
+		return -ENOMEM;
+
+	peer_mep->mepid = mepid;
+	peer_mep->mep = mep;
+	INIT_DELAYED_WORK(&peer_mep->ccm_rx_dwork, ccm_rx_work_expired);
+
+	if (mep->cc_config.enable)
+		/* CC is enabled */
+		cc_peer_enable(peer_mep);
+
+	/* Add Peer MEP to list */
+	list_add_tail_rcu(&peer_mep->head, &mep->peer_mep_list);
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
+			      u32 mepid,
+			      struct netlink_ext_ack *extack)
+{
+	struct br_cfm_peer_mep *peer_mep;
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	peer_mep = br_peer_mep_find(mep, mepid);
+	if (!peer_mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Peer MEP-ID already deleted");
+		return -EINVAL;
+	}
+
+	cc_peer_disable(peer_mep);
+
+	list_del_rcu(&peer_mep->head);
+	kfree_rcu(peer_mep, rcu);
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_rdi_set(struct net_bridge *br, const u32 instance,
+		      const bool rdi, struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	/* Save rdi parameters */
+	mep->rdi = rdi;
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
+		     const struct br_cfm_cc_ccm_tx_info *const tx_info,
+		     struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+	struct sk_buff *skb;
+	u32 interval_us;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	if (memcmp(tx_info, &mep->cc_ccm_tx_info, sizeof(*tx_info)) == 0) {
+		/* No change in tx_info. */
+		if (mep->cc_ccm_tx_info.period == 0)
+			/* Transmission is not enabled - just return */
+			return 0;
+
+		/* Transmission is ongoing, the end time is recalculated */
+		mep->ccm_tx_end = jiffies +
+				  usecs_to_jiffies(tx_info->period * 1000000);
+		return 0;
+	}
+
+	if (tx_info->period == 0 && mep->cc_ccm_tx_info.period == 0)
+		/* Some change in info and transmission is not ongoing */
+		goto save;
+
+	if (tx_info->period != 0 && mep->cc_ccm_tx_info.period != 0) {
+		/* Some change in info and transmission is ongoing */
+		/* The end time is recalculated */
+		mep->ccm_tx_end = jiffies +
+				  usecs_to_jiffies(tx_info->period * 1000000);
+
+		goto save;
+	}
+
+	if (tx_info->period == 0 && mep->cc_ccm_tx_info.period != 0) {
+		/* CCM transmission stop */
+		cancel_delayed_work_sync(&mep->ccm_tx_dwork);
+		goto save;
+	}
+
+	/* Start delayed work to transmit CCM frames */
+	mep->ccm_tx_end = jiffies + usecs_to_jiffies(tx_info->period * 1000000);
+	interval_us = interval_to_us(mep->cc_config.exp_interval);
+	queue_delayed_work(system_wq, &mep->ccm_tx_dwork,
+			   usecs_to_jiffies(interval_us));
+
+	/* Send first CCM frame now */
+	mep->ccm_tx_snumber = 0;
+	skb = ccm_frame_build(mep, tx_info);
+	if (skb)
+		ccm_frame_tx(skb);
+
+save:
+	/* Save tx_info parameters */
+	mep->cc_ccm_tx_info = *tx_info;
+
+	return 0;
+}
+
+/* note: already called with rtnl_lock */
+int br_cfm_cc_counters_clear(struct net_bridge *br, const u32 instance,
+			     struct netlink_ext_ack *extack)
+{
+	struct br_cfm_mep *mep;
+
+	mep = br_mep_find(br, instance);
+	if (!mep) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "MEP instance not created");
+		return -EINVAL;
+	}
+
+	memset(&mep->cc_counters, 0, sizeof(mep->cc_counters));
+
+	return 0;
+}
+
+bool br_cfm_created(struct net_bridge *br)
+{
+	return !list_empty(&br->mep_list);
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6294a3e51a33..385a6a6aa17e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1363,6 +1363,22 @@ static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
 
 #endif
 
+/* br_cfm.c */
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb);
+bool br_cfm_created(struct net_bridge *br);
+#else
+static inline int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool br_cfm_created(struct net_bridge *br)
+{
+	return false;
+}
+#endif
+
 /* br_netlink.c */
 extern struct rtnl_link_ops br_link_ops;
 int br_netlink_init(void);
diff --git a/net/bridge/br_private_cfm.h b/net/bridge/br_private_cfm.h
new file mode 100644
index 000000000000..379334a42667
--- /dev/null
+++ b/net/bridge/br_private_cfm.h
@@ -0,0 +1,242 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _BR_PRIVATE_CFM_H_
+#define _BR_PRIVATE_CFM_H_
+
+#include "br_private.h"
+#include <uapi/linux/cfm_bridge.h>
+
+/* MEP create parameters */
+struct br_cfm_mep_create {
+	enum br_cfm_domain domain; /* Domain for this MEP */
+	enum br_cfm_mep_direction direction; /* Up or Down MEP direction */
+	u32 ifindex; /* Residence port */
+	u16 vid; /* Classified VID in VLAN domain */
+};
+
+/* Create/Delete a MEP. */
+int br_cfm_mep_create(struct net_bridge *br,
+		      const u32 instance,
+		      struct br_cfm_mep_create *const create,
+		      struct netlink_ext_ack *extack);
+int br_cfm_mep_delete(struct net_bridge *br,
+		      const u32 instance,
+		      struct netlink_ext_ack *extack);
+
+/* MEP configuration parameters */
+struct br_cfm_mep_config {
+	u32 mdlevel;
+	u32 mepid; /* MEPID for this MEP */
+	struct mac_addr unicast_mac; /* The MEP unicast MAC */
+	/* Added tag VID in case of tagged PORT domain. Untagged if zero. */
+	u16 vid;
+};
+
+/* Set general configuration of MEP */
+int br_cfm_mep_config_set(struct net_bridge *br,
+			  const u32 instance,
+			  const struct br_cfm_mep_config *const config,
+			  struct netlink_ext_ack *extack);
+
+/* MEP status. */
+struct br_cfm_mep_status {
+	/* Indications that an OAM PDU has been seen. */
+	/* Are cleared during call to br_cfm_status_get(). */
+	bool opcode_unexp_seen; /* RX of OAM PDU with unexpected opcode */
+	bool dmac_unexp_seen; /* RX of OAM Frame with unexpected DMAC */
+	bool tx_level_low_seen; /* TX of OAM PDU with level low blocked */
+	bool version_unexp_seen; /* RX of OAM PDU with unexpected version */
+	bool rx_level_low_seen; /* Rx of OAM PDU with level low */
+};
+
+/* MEP status get. */
+int br_cfm_mep_status_get(const u32 instance, struct br_cfm_mep_status *const status);
+
+/* MEP counters */
+struct br_cfm_mep_counters {
+	/* All the following counters are cleared during call to */
+	/* br_cfm_counters_clear(). */
+
+	/* OAM PDU Rx and Tx counters. */
+	u64 rx_counter;
+	u64 tx_counter;
+
+	/* Rx/Tx PDUs that are discarded due to filtering */
+	u64 rx_discard_counter; /* Check of MEL or DMAC or Version or CCM */
+	u64 tx_discard_counter; /* Check of MEL */
+};
+
+/* Get MEP counters. */
+int br_cfm_mep_counters_get(const u32 instance, struct br_cfm_mep_counters *counters);
+
+/* MEP counter clear. */
+int br_cfm_mep_counters_clear(struct net_bridge *br,
+			      const u32 instance,
+			      struct netlink_ext_ack *extack);
+
+struct br_cfm_maid {
+	u8 data[CFM_MAID_LENGTH];
+};
+
+struct br_cfm_cc_config {
+	/* Expected received CCM PDU MAID. */
+	struct br_cfm_maid exp_maid;
+
+	/* Expected received CCM PDU interval. */
+	/* Transmitting CCM PDU interval when CCM tx is enabled. */
+	enum br_cfm_ccm_interval exp_interval;
+
+	/* Expected received CCM PDU Priority */
+	u8 exp_priority;
+
+	bool enable; /* Enable/disable CCM PDU handling */
+};
+
+/* Set CC configuration of a MEP */
+int br_cfm_cc_config_set(struct net_bridge *br,
+			 const u32 instance,
+			 const struct br_cfm_cc_config *const config,
+			 struct netlink_ext_ack *extack);
+
+/* Set CC Peer MEP ID add/remove */
+int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
+			   u32 peer_mep_id,
+			   struct netlink_ext_ack *extack);
+int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
+			      u32 peer_mep_id,
+			      struct netlink_ext_ack *extack);
+
+/* Transmitted CCM Remote Defect Indication status set.
+ * This RDI is inserted in transmitted CCM PDUs if CCM transmission is enabled.
+ * See br_cfm_cc_ccm_tx() with interval != BR_CFM_CCM_INTERVAL_NONE
+ */
+int br_cfm_cc_rdi_set(struct net_bridge *br, const u32 instance,
+		      const bool rdi, struct netlink_ext_ack *extack);
+
+/* OAM PDU Tx information */
+struct br_cfm_cc_ccm_tx_info {
+	struct mac_addr dmac;
+	u8 priority;
+	bool dei;
+	/* The CCM will be transmitted for this period in seconds.
+	 * Call br_cfm_cc_ccm_tx before timeout to keep transmission alive.
+	 * When period is zero any ongoing transmission will be stopped.
+	 */
+	u32 period;
+
+	bool seq_no_update; /* Update Tx CCM sequence number */
+	bool if_tlv; /* Insert Interface Status TLV */
+	u8 if_tlv_value; /* Interface Status TLV value */
+	bool port_tlv; /* Insert Port Status TLV */
+	u8 port_tlv_value; /* Port Status TLV value */
+	/* Sender ID TLV ??
+	 * Organization-Specific TLV ??
+	 */
+};
+
+/* Transmit CCM PDU */
+int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
+		     const struct br_cfm_cc_ccm_tx_info *const tx_info,
+		     struct netlink_ext_ack *extack);
+
+struct br_cfm_cc_status {
+	/* (interval == 0) for last received CCM PDU */
+	bool zero_interval;
+
+	/* Unexpected MD Level received. Cleared after 3.5 interval */
+	bool mdlevel_unexp;
+
+	/* Unexpected MAID received. Cleared after 3.5 interval */
+	bool maid_unexp;
+
+	/* Unexpected MEPID received. Cleared after 3.5 interval */
+	bool mepid_unexp;
+};
+
+/* Get CC status. */
+int br_cfm_cc_status_get(const u32 instance, struct br_cfm_cc_status *const status);
+
+struct br_cfm_cc_counters {
+	/* CCM PDU RX and TX counters
+	 * Are cleared during call to br_cfm_cc_counters_clear()
+	 */
+	u64 rx_valid_counter;
+	u64 rx_invalid_counter;
+	u64 rx_oo_counter;  /* Out of Order sequence numbers counter */
+	u64 tx_counter;
+};
+
+/* Get CC counters. */
+int br_cfm_cc_counters_get(const u32 instance, struct br_cfm_cc_counters *counters);
+
+/* CC counter clear. */
+int br_cfm_cc_counters_clear(struct net_bridge *br, const u32 instance,
+			     struct netlink_ext_ack *extack);
+
+struct br_cfm_cc_peer_status {
+	struct mac_addr unicast_mac; /* The Peer MEP unicast MAC */
+
+	/* Unexpected Interval. Cleared after 3.5 interval */
+	bool interval_unexp;
+
+	/* Unexpected Priority received. Cleared after 3.5 interval */
+	bool priority_unexp;
+
+	/* This CCM related status is based on the latest received CCM PDU. */
+	u32 rx_ifindex; /* The ingress port */
+	u8 port_tlv_value; /* Port Status TLV value */
+	u8 if_tlv_value; /* Interface Status TLV value */
+
+	/* CCM has not been received for 3.25 intervals */
+	bool ccm_defect;
+
+	/* (RDI == 1) for last received CCM PDU */
+	bool rdi;
+
+	/* Indications that a CCM PDU has been seen.
+	 * Are cleared during call to br_cfm_cc_status_get()
+	 */
+	bool seen; /* CCM PDU received */
+	bool tlv_seen; /* CCM PDU with TLV received */
+	/* CCM PDU with unexpected sequence number received */
+	bool seq_unexp_seen;
+};
+
+/* Get CC peer MEP status. */
+int br_cfm_cc_peer_status_get(const u32 instance, const u32 mepid,
+			      struct br_cfm_cc_peer_status *const status);
+
+struct br_cfm_mep {
+	/* list header of MEP instances */
+	struct list_head		head;
+	u32				instance;
+	struct br_cfm_mep_create	create;
+	struct br_cfm_mep_config	config;
+	struct br_cfm_cc_config		cc_config;
+	struct br_cfm_cc_ccm_tx_info	cc_ccm_tx_info;
+	struct br_cfm_mep_counters	counters;
+	struct br_cfm_cc_counters	cc_counters;
+	/* List of multiple peer MEPs */
+	struct list_head		peer_mep_list;
+	struct rcu_head			rcu;
+	struct net_bridge_port __rcu	*b_port;
+	unsigned long			ccm_tx_end;
+	struct delayed_work		ccm_tx_dwork;
+	struct br_cfm_cc_status		cc_status;
+	u32				ccm_tx_snumber;
+	u32				ccm_rx_snumber;
+	struct br_cfm_mep_status	status;
+	bool				rdi;
+};
+
+struct br_cfm_peer_mep {
+	struct list_head		head;
+	struct br_cfm_mep		*mep;
+	struct rcu_head			rcu;
+	struct delayed_work		ccm_rx_dwork;
+	u32				mepid;
+	struct br_cfm_cc_peer_status	cc_status;
+	u32				ccm_rx_count_miss;
+};
+
+#endif /* _BR_PRIVATE_CFM_H_ */
-- 
2.28.0

