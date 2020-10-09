Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F91288B99
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbgJIOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:38:24 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:51496 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388914AbgJIOiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254286; x=1633790286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hsra5OnHCajXks3BzibfeiOOXMYwJjva7GRm9YUQmJg=;
  b=vJyFTDiSmAT+gWLivOFug0QVnWv9V51OlVT6d70HKYcBpCGp2zpg4gOt
   7tK32lMbhq2UojnB9WGVyvEc4frMtBFRxSPZMShX6n7kQ/EzVMKgb9HWF
   vM20yd9NJ5rkqdoEP7wvHWEsrEy6zIGZQhpNwexk+jGLYebIyCoqHyIAp
   NdcHJzKwySAc/0qluFE1bDLFuVCxI/kRyyV18MEIpP2m01+kofl2A0ET8
   oQ8g+FiiZSyq3tkRBTAxOINJ+EEvMSWSa4HgMZSjMdQeLTA5Vp3LmwUnl
   2SqLZDC/pqRQ3AXcBAbvhZ9YdriL7Xi2uuIcf5OGXfp9zafLa8fhSjHwV
   g==;
IronPort-SDR: XKHbpPAbydk85W9L9FD71sjhPRqBUDMOSNIDqVstgYVJNPSTm0RSWkUQ5LS5VLDR9e468medtm
 9fQ/8PH5+bWqhpqcOqX0vpFmVJok5v50mrJ6k9AOAXsY8vqGRcdgoJQD2eWc6yu8DCyqDI/NW0
 kQ/ic+yreV+UdhuVUy9ypvWe3f+x16O7ZJ5ylvjqKFVV9hDZy+W4qxw4/GbgL8EoLhDesFPf9p
 YejBApx9F756Lrrv9GJ4ekhTaeJlFhy6mu+W09GF+bUNrRMOTqKxoEVlZXBq+gYyXVJwzthy3t
 rEM=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="92058366"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:38:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:37:31 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:38:02 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 06/10] bridge: cfm: Kernel space implementation of CFM. CCM frame RX added.
Date:   Fri, 9 Oct 2020 14:35:26 +0000
Message-ID: <20201009143530.2438738-7-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third commit of the implementation of the CFM protocol
according to 802.1Q section 12.14.

Functionality is extended with CCM frame reception.
The MEP instance now contains CCM based status information.
Most important is the CCM defect status indicating if correct
CCM frames are received with the expected interval.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
---
 include/uapi/linux/cfm_bridge.h |  10 ++
 net/bridge/br_cfm.c             | 269 ++++++++++++++++++++++++++++++++
 net/bridge/br_private_cfm.h     |  32 ++++
 3 files changed, 311 insertions(+)

diff --git a/include/uapi/linux/cfm_bridge.h b/include/uapi/linux/cfm_bridge.h
index 84a3817da90b..4be195cc6b70 100644
--- a/include/uapi/linux/cfm_bridge.h
+++ b/include/uapi/linux/cfm_bridge.h
@@ -20,6 +20,10 @@
 					 CFM_IF_STATUS_TLV_LENGTH)
 #define CFM_FRAME_PRIO			7
 #define CFM_CCM_TLV_OFFSET		70
+#define CFM_CCM_PDU_MAID_OFFSET		10
+#define CFM_CCM_PDU_MEPID_OFFSET	8
+#define CFM_CCM_PDU_SEQNR_OFFSET	4
+#define CFM_CCM_PDU_TLV_OFFSET		74
 #define CFM_CCM_ITU_RESERVED_SIZE	16
 
 struct br_cfm_common_hdr {
@@ -29,6 +33,12 @@ struct br_cfm_common_hdr {
 	__u8 tlv_offset;
 };
 
+struct br_cfm_status_tlv {
+	__u8 type;
+	__be16 length;
+	__u8 value;
+};
+
 enum br_cfm_opcodes {
 	BR_CFM_OPCODE_CCM = 0x1,
 };
diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index 4b7af1adcd6a..d928de5de155 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -101,6 +101,56 @@ static u32 interval_to_pdu(enum br_cfm_ccm_interval interval)
 	return 0;
 }
 
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
 static struct sk_buff *ccm_frame_build(struct br_cfm_mep *mep,
 				       const struct br_cfm_cc_ccm_tx_info *const tx_info)
 
@@ -231,6 +281,200 @@ static void ccm_tx_work_expired(struct work_struct *work)
 			   usecs_to_jiffies(interval_us));
 }
 
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
+	.frame_handler = br_cfm_frame_rx,
+};
+
 int br_cfm_mep_create(struct net_bridge *br,
 		      const u32 instance,
 		      struct br_cfm_mep_create *const create,
@@ -295,6 +539,9 @@ int br_cfm_mep_create(struct net_bridge *br,
 	INIT_HLIST_HEAD(&mep->peer_mep_list);
 	INIT_DELAYED_WORK(&mep->ccm_tx_dwork, ccm_tx_work_expired);
 
+	if (hlist_empty(&br->mep_list))
+		br_add_frame(br, &cfm_frame_type);
+
 	hlist_add_tail_rcu(&mep->head, &br->mep_list);
 
 	return 0;
@@ -310,6 +557,7 @@ static void mep_delete_implementation(struct net_bridge *br,
 
 	/* Empty and free peer MEP list */
 	hlist_for_each_entry_safe(peer_mep, n_store, &mep->peer_mep_list, head) {
+		cancel_delayed_work_sync(&peer_mep->ccm_rx_dwork);
 		hlist_del_rcu(&peer_mep->head);
 		kfree_rcu(peer_mep, rcu);
 	}
@@ -319,6 +567,9 @@ static void mep_delete_implementation(struct net_bridge *br,
 	RCU_INIT_POINTER(mep->b_port, NULL);
 	hlist_del_rcu(&mep->head);
 	kfree_rcu(mep, rcu);
+
+	if (hlist_empty(&br->mep_list))
+		br_del_frame(br, &cfm_frame_type);
 }
 
 int br_cfm_mep_delete(struct net_bridge *br,
@@ -379,6 +630,7 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 			 const struct br_cfm_cc_config *const config,
 			 struct netlink_ext_ack *extack)
 {
+	struct br_cfm_peer_mep *peer_mep;
 	struct br_cfm_mep *mep;
 
 	ASSERT_RTNL();
@@ -394,7 +646,18 @@ int br_cfm_cc_config_set(struct net_bridge *br,
 	if (memcmp(config, &mep->cc_config, sizeof(*config)) == 0)
 		return 0;
 
+	if (config->enable && !mep->cc_config.enable)
+		/* CC is enabled */
+		hlist_for_each_entry(peer_mep, &mep->peer_mep_list, head)
+			cc_peer_enable(peer_mep);
+
+	if (!config->enable && mep->cc_config.enable)
+		/* CC is disabled */
+		hlist_for_each_entry(peer_mep, &mep->peer_mep_list, head)
+			cc_peer_disable(peer_mep);
+
 	mep->cc_config = *config;
+	mep->ccm_rx_snumber = 0;
 	mep->ccm_tx_snumber = 1;
 
 	return 0;
@@ -435,6 +698,10 @@ int br_cfm_cc_peer_mep_add(struct net_bridge *br, const u32 instance,
 
 	peer_mep->mepid = mepid;
 	peer_mep->mep = mep;
+	INIT_DELAYED_WORK(&peer_mep->ccm_rx_dwork, ccm_rx_work_expired);
+
+	if (mep->cc_config.enable)
+		cc_peer_enable(peer_mep);
 
 	hlist_add_tail_rcu(&peer_mep->head, &mep->peer_mep_list);
 
@@ -464,6 +731,8 @@ int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
 		return -ENOENT;
 	}
 
+	cc_peer_disable(peer_mep);
+
 	hlist_del_rcu(&peer_mep->head);
 	kfree_rcu(peer_mep, rcu);
 
diff --git a/net/bridge/br_private_cfm.h b/net/bridge/br_private_cfm.h
index 8d1b449acfbf..6a2294c0ea79 100644
--- a/net/bridge/br_private_cfm.h
+++ b/net/bridge/br_private_cfm.h
@@ -43,6 +43,8 @@ struct br_cfm_cc_config {
 	/* Expected received CCM PDU interval. */
 	/* Transmitting CCM PDU interval when CCM tx is enabled. */
 	enum br_cfm_ccm_interval exp_interval;
+
+	bool enable; /* Enable/disable CCM PDU handling */
 };
 
 int br_cfm_cc_config_set(struct net_bridge *br,
@@ -87,6 +89,31 @@ int br_cfm_cc_ccm_tx(struct net_bridge *br, const u32 instance,
 		     const struct br_cfm_cc_ccm_tx_info *const tx_info,
 		     struct netlink_ext_ack *extack);
 
+struct br_cfm_mep_status {
+	/* Indications that an OAM PDU has been seen. */
+	bool opcode_unexp_seen; /* RX of OAM PDU with unexpected opcode */
+	bool version_unexp_seen; /* RX of OAM PDU with unexpected version */
+	bool rx_level_low_seen; /* Rx of OAM PDU with level low */
+};
+
+struct br_cfm_cc_peer_status {
+	/* This CCM related status is based on the latest received CCM PDU. */
+	u8 port_tlv_value; /* Port Status TLV value */
+	u8 if_tlv_value; /* Interface Status TLV value */
+
+	/* CCM has not been received for 3.25 intervals */
+	bool ccm_defect;
+
+	/* (RDI == 1) for last received CCM PDU */
+	bool rdi;
+
+	/* Indications that a CCM PDU has been seen. */
+	bool seen; /* CCM PDU received */
+	bool tlv_seen; /* CCM PDU with TLV received */
+	/* CCM PDU with unexpected sequence number received */
+	bool seq_unexp_seen;
+};
+
 struct br_cfm_mep {
 	/* list header of MEP instances */
 	struct hlist_node		head;
@@ -101,6 +128,8 @@ struct br_cfm_mep {
 	unsigned long			ccm_tx_end;
 	struct delayed_work		ccm_tx_dwork;
 	u32				ccm_tx_snumber;
+	u32				ccm_rx_snumber;
+	struct br_cfm_mep_status	status;
 	bool				rdi;
 	struct rcu_head			rcu;
 };
@@ -108,7 +137,10 @@ struct br_cfm_mep {
 struct br_cfm_peer_mep {
 	struct hlist_node		head;
 	struct br_cfm_mep		*mep;
+	struct delayed_work		ccm_rx_dwork;
 	u32				mepid;
+	struct br_cfm_cc_peer_status	cc_status;
+	u32				ccm_rx_count_miss;
 	struct rcu_head			rcu;
 };
 
-- 
2.28.0

