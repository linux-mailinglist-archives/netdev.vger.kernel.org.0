Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82B1AE372
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgDQRN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbgDQRNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:25 -0400
IronPort-SDR: GNH+VyKKTP3WsGsdJ1JjVg3ZginOYUrVItEv5VRAyhagmeDHVizUoCfkeNr55rDc7SVh2HKZ8e
 W+f9k8YkRR1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:56 -0700
IronPort-SDR: ZqkElPqY2VoO4oFS0+LwiAR8LjqltG3swnZ4tc+OmpxjT40NFLfavh3ux1swGpyj0MIdqrlpSE
 CIAYhATq8ICg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383723"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:55 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 07/16] RDMA/irdma: Add connection manager
Date:   Fri, 17 Apr 2020 10:12:42 -0700
Message-Id: <20200417171251.1533371-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add connection management (CM) implementation for
iWARP including accept, reject, connect, create_listen,
destroy_listen and CM utility functions

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/cm.c | 4499 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/cm.h |  413 +++
 2 files changed, 4912 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/cm.c
 create mode 100644 drivers/infiniband/hw/irdma/cm.h

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
new file mode 100644
index 000000000000..87d6300fee35
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -0,0 +1,4499 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#include <linux/highmem.h>
+#include <net/addrconf.h>
+#include <net/ip6_route.h>
+#include <net/flow.h>
+#include <net/secure_seq.h>
+
+#include "main.h"
+#include "trace.h"
+
+static void irdma_rem_ref_cm_node(struct irdma_cm_node *);
+static void irdma_cm_post_event(struct irdma_cm_event *event);
+static void irdma_disconnect_worker(struct work_struct *work);
+
+/**
+ * irdma_free_sqbuf - put back puda buffer if refcount is 0
+ * @vsi: The VSI structure of the device
+ * @bufp: puda buffer to free
+ */
+void irdma_free_sqbuf(struct irdma_sc_vsi *vsi, void *bufp)
+{
+	struct irdma_puda_buf *buf = bufp;
+	struct irdma_puda_rsrc *ilq = vsi->ilq;
+
+	if (refcount_dec_and_test(&buf->refcount))
+		irdma_puda_ret_bufpool(ilq, buf);
+}
+
+/**
+ * irdma_derive_hw_ird_setting - Calculate IRD
+ * @cm_ird: IRD of connection's node
+ *
+ * The ird from the connection is rounded to a supported HW
+ * setting (2,8,32,64,128) and then encoded for ird_size field
+ * of qp_ctx
+ */
+u8 irdma_derive_hw_ird_setting(u16 cm_ird)
+{
+	/* ird_size field is encoded in qp_ctx */
+	switch (cm_ird ? roundup_pow_of_two(cm_ird) : 0) {
+	case IRDMA_HW_IRD_SETTING_128:
+		return 4;
+	case IRDMA_HW_IRD_SETTING_64:
+		return 3;
+	case IRDMA_HW_IRD_SETTING_32:
+	case IRDMA_HW_IRD_SETTING_16:
+		return 2;
+	case IRDMA_HW_IRD_SETTING_8:
+	case IRDMA_HW_IRD_SETTING_4:
+		return 1;
+	case IRDMA_HW_IRD_SETTING_2:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_record_ird_ord - Record IRD/ORD passed in
+ * @cm_node: connection's node
+ * @conn_ird: connection IRD
+ * @conn_ord: connection ORD
+ */
+static void irdma_record_ird_ord(struct irdma_cm_node *cm_node, u32 conn_ird,
+				 u32 conn_ord)
+{
+	if (conn_ird > cm_node->dev->hw_attrs.max_hw_ird)
+		conn_ird = cm_node->dev->hw_attrs.max_hw_ird;
+
+	if (conn_ord > cm_node->dev->hw_attrs.max_hw_ord)
+		conn_ord = cm_node->dev->hw_attrs.max_hw_ord;
+	else if (!conn_ord && cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO)
+		conn_ord = 1;
+	cm_node->ird_size = conn_ird;
+	cm_node->ord_size = conn_ord;
+}
+
+/**
+ * irdma_copy_ip_ntohl - copy IP address from  network to host
+ * @dst: IP address in host order
+ * @src: IP address in network order (big endian)
+ */
+void irdma_copy_ip_ntohl(u32 *dst, __be32 *src)
+{
+	*dst++ = ntohl(*src++);
+	*dst++ = ntohl(*src++);
+	*dst++ = ntohl(*src++);
+	*dst = ntohl(*src);
+}
+
+/**
+ * irdma_copy_ip_htonl - copy IP address from host to network order
+ * @dst: IP address in network order (big endian)
+ * @src: IP address in host order
+ */
+void irdma_copy_ip_htonl(__be32 *dst, u32 *src)
+{
+	*dst++ = htonl(*src++);
+	*dst++ = htonl(*src++);
+	*dst++ = htonl(*src++);
+	*dst = htonl(*src);
+}
+
+/**
+ * irdma_get_addr_info
+ * @cm_node: contains ip/tcp info
+ * @cm_info: to get a copy of the cm_node ip/tcp info
+ */
+static void irdma_get_addr_info(struct irdma_cm_node *cm_node,
+				struct irdma_cm_info *cm_info)
+{
+	memset(cm_info, 0, sizeof(*cm_info));
+	cm_info->ipv4 = cm_node->ipv4;
+	cm_info->vlan_id = cm_node->vlan_id;
+	memcpy(cm_info->loc_addr, cm_node->loc_addr, sizeof(cm_info->loc_addr));
+	memcpy(cm_info->rem_addr, cm_node->rem_addr, sizeof(cm_info->rem_addr));
+	cm_info->loc_port = cm_node->loc_port;
+	cm_info->rem_port = cm_node->rem_port;
+}
+
+/**
+ * irdma_fill_sockaddr4 - fill in addr info for IPv4 connection
+ * @cm_node: connection's node
+ * @event: upper layer's cm event
+ */
+static inline void irdma_fill_sockaddr4(struct irdma_cm_node *cm_node,
+					struct iw_cm_event *event)
+{
+	struct sockaddr_in *laddr = (struct sockaddr_in *)&event->local_addr;
+	struct sockaddr_in *raddr = (struct sockaddr_in *)&event->remote_addr;
+
+	laddr->sin_family = AF_INET;
+	raddr->sin_family = AF_INET;
+
+	laddr->sin_port = htons(cm_node->loc_port);
+	raddr->sin_port = htons(cm_node->rem_port);
+
+	laddr->sin_addr.s_addr = htonl(cm_node->loc_addr[0]);
+	raddr->sin_addr.s_addr = htonl(cm_node->rem_addr[0]);
+}
+
+/**
+ * irdma_fill_sockaddr6 - fill in addr info for IPv6 connection
+ * @cm_node: connection's node
+ * @event: upper layer's cm event
+ */
+static inline void irdma_fill_sockaddr6(struct irdma_cm_node *cm_node,
+					struct iw_cm_event *event)
+{
+	struct sockaddr_in6 *laddr6 = (struct sockaddr_in6 *)&event->local_addr;
+	struct sockaddr_in6 *raddr6 = (struct sockaddr_in6 *)&event->remote_addr;
+
+	laddr6->sin6_family = AF_INET6;
+	raddr6->sin6_family = AF_INET6;
+
+	laddr6->sin6_port = htons(cm_node->loc_port);
+	raddr6->sin6_port = htons(cm_node->rem_port);
+
+	irdma_copy_ip_htonl(laddr6->sin6_addr.in6_u.u6_addr32,
+			    cm_node->loc_addr);
+	irdma_copy_ip_htonl(raddr6->sin6_addr.in6_u.u6_addr32,
+			    cm_node->rem_addr);
+}
+
+/**
+ * irdma_get_cmevent_info - for cm event upcall
+ * @cm_node: connection's node
+ * @cm_id: upper layers cm struct for the event
+ * @event: upper layer's cm event
+ */
+static inline void irdma_get_cmevent_info(struct irdma_cm_node *cm_node,
+					  struct iw_cm_id *cm_id,
+					  struct iw_cm_event *event)
+{
+	memcpy(&event->local_addr, &cm_id->m_local_addr,
+	       sizeof(event->local_addr));
+	memcpy(&event->remote_addr, &cm_id->m_remote_addr,
+	       sizeof(event->remote_addr));
+	if (cm_node) {
+		event->private_data = cm_node->pdata_buf;
+		event->private_data_len = (u8)cm_node->pdata.size;
+		event->ird = cm_node->ird_size;
+		event->ord = cm_node->ord_size;
+	}
+}
+
+/**
+ * irdma_send_cm_event - upcall cm's event handler
+ * @cm_node: connection's node
+ * @cm_id: upper layer's cm info struct
+ * @type: Event type to indicate
+ * @status: status for the event type
+ */
+static int irdma_send_cm_event(struct irdma_cm_node *cm_node,
+			       struct iw_cm_id *cm_id,
+			       enum iw_cm_event_type type, int status)
+{
+	struct iw_cm_event event = {};
+
+	event.event = type;
+	event.status = status;
+	switch (type) {
+	case IW_CM_EVENT_CONNECT_REQUEST:
+		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
+					  __builtin_return_address(0));
+		if (cm_node->ipv4)
+			irdma_fill_sockaddr4(cm_node, &event);
+		else
+			irdma_fill_sockaddr6(cm_node, &event);
+		event.provider_data = cm_node;
+		event.private_data = cm_node->pdata_buf;
+		event.private_data_len = (u8)cm_node->pdata.size;
+		event.ird = cm_node->ird_size;
+		break;
+	case IW_CM_EVENT_CONNECT_REPLY:
+		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
+					  __builtin_return_address(0));
+		irdma_get_cmevent_info(cm_node, cm_id, &event);
+		break;
+	case IW_CM_EVENT_ESTABLISHED:
+		trace_irdma_send_cm_event(cm_node, cm_id, type, status,
+					  __builtin_return_address(0));
+		event.ird = cm_node->ird_size;
+		event.ord = cm_node->ord_size;
+		break;
+	case IW_CM_EVENT_DISCONNECT:
+		trace_irdma_send_cm_event_no_node(cm_id, type, status,
+						  __builtin_return_address(0));
+		break;
+	case IW_CM_EVENT_CLOSE:
+		trace_irdma_send_cm_event_no_node(cm_id, type, status,
+						  __builtin_return_address(0));
+		break;
+	default:
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: Unsupported event type received type = %d\n",
+			  type);
+		return -1;
+	}
+
+	return cm_id->event_handler(cm_id, &event);
+}
+
+/**
+ * irdma_create_event - create cm event
+ * @cm_node: connection's node
+ * @type: Event type to generate
+ */
+static struct irdma_cm_event *irdma_create_event(struct irdma_cm_node *cm_node,
+						 enum irdma_cm_event_type type)
+{
+	struct irdma_cm_event *event;
+
+	if (!cm_node->cm_id)
+		return NULL;
+
+	event = kzalloc(sizeof(*event), GFP_ATOMIC);
+
+	if (!event)
+		return NULL;
+
+	event->type = type;
+	event->cm_node = cm_node;
+	memcpy(event->cm_info.rem_addr, cm_node->rem_addr,
+	       sizeof(event->cm_info.rem_addr));
+	memcpy(event->cm_info.loc_addr, cm_node->loc_addr,
+	       sizeof(event->cm_info.loc_addr));
+	event->cm_info.rem_port = cm_node->rem_port;
+	event->cm_info.loc_port = cm_node->loc_port;
+	event->cm_info.cm_id = cm_node->cm_id;
+	ibdev_dbg(to_ibdev(cm_node->iwdev),
+		  "CM: node=%p event=%p type=%u dst=%pI4 src=%pI4\n", cm_node,
+		  event, type, event->cm_info.loc_addr,
+		  event->cm_info.rem_addr);
+	trace_irdma_create_event(cm_node, type, __builtin_return_address(0));
+	irdma_cm_post_event(event);
+
+	return event;
+}
+
+/**
+ * irdma_free_retrans_entry - free send entry
+ * @cm_node: connection's node
+ */
+static void irdma_free_retrans_entry(struct irdma_cm_node *cm_node)
+{
+	struct irdma_device *iwdev = cm_node->iwdev;
+	struct irdma_timer_entry *send_entry;
+
+	send_entry = cm_node->send_entry;
+	if (!send_entry)
+		return;
+
+	cm_node->send_entry = NULL;
+	irdma_free_sqbuf(&iwdev->vsi, send_entry->sqbuf);
+	kfree(send_entry);
+	refcount_dec(&cm_node->refcnt);
+}
+
+/**
+ * irdma_cleanup_retrans_entry - free send entry with lock
+ * @cm_node: connection's node
+ */
+static void irdma_cleanup_retrans_entry(struct irdma_cm_node *cm_node)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
+	irdma_free_retrans_entry(cm_node);
+	spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
+}
+
+/**
+ * irdma_form_ah_cm_frame - get a free packet and build frame with address handle
+ * @cm_node: connection's node ionfo to use in frame
+ * @options: pointer to options info
+ * @hdr: pointer mpa header
+ * @pdata: pointer to private data
+ * @flags:  indicates FIN or ACK
+ */
+static struct irdma_puda_buf *irdma_form_ah_cm_frame(struct irdma_cm_node *cm_node,
+						     struct irdma_kmem_info *options,
+						     struct irdma_kmem_info *hdr,
+						     struct irdma_kmem_info *pdata,
+						     u8 flags)
+{
+	struct irdma_puda_buf *sqbuf;
+	struct irdma_sc_vsi *vsi = &cm_node->iwdev->vsi;
+	u8 *buf;
+	struct tcphdr *tcph;
+	u16 pktsize;
+	u32 opts_len = 0;
+	u32 pd_len = 0;
+	u32 hdr_len = 0;
+
+	if (!cm_node->ah || !cm_node->ah->ah_info.ah_valid) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: AH invalid\n");
+		return NULL;
+	}
+
+	sqbuf = irdma_puda_get_bufpool(vsi->ilq);
+	if (!sqbuf) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: SQ buf NULL\n");
+		return NULL;
+	}
+
+	sqbuf->ah_id = cm_node->ah->ah_info.ah_idx;
+	buf = sqbuf->mem.va;
+	if (options)
+		opts_len = (u32)options->size;
+
+	if (hdr)
+		hdr_len = hdr->size;
+
+	if (pdata)
+		pd_len = pdata->size;
+
+	pktsize = sizeof(*tcph) + opts_len + hdr_len + pd_len;
+
+	memset(buf, 0, pktsize);
+
+	sqbuf->totallen = pktsize;
+	sqbuf->tcphlen = sizeof(*tcph) + opts_len;
+	sqbuf->scratch = cm_node;
+
+	tcph = (struct tcphdr *)buf;
+	buf += sizeof(*tcph);
+
+	tcph->source = htons(cm_node->loc_port);
+	tcph->dest = htons(cm_node->rem_port);
+	tcph->seq = htonl(cm_node->tcp_cntxt.loc_seq_num);
+
+	if (flags & SET_ACK) {
+		cm_node->tcp_cntxt.loc_ack_num = cm_node->tcp_cntxt.rcv_nxt;
+		tcph->ack_seq = htonl(cm_node->tcp_cntxt.loc_ack_num);
+		tcph->ack = 1;
+	} else {
+		tcph->ack_seq = 0;
+	}
+
+	if (flags & SET_SYN) {
+		cm_node->tcp_cntxt.loc_seq_num++;
+		tcph->syn = 1;
+	} else {
+		cm_node->tcp_cntxt.loc_seq_num += hdr_len + pd_len;
+	}
+
+	if (flags & SET_FIN) {
+		cm_node->tcp_cntxt.loc_seq_num++;
+		tcph->fin = 1;
+	}
+
+	if (flags & SET_RST)
+		tcph->rst = 1;
+
+	tcph->doff = (u16)((sizeof(*tcph) + opts_len + 3) >> 2);
+	sqbuf->tcphlen = tcph->doff << 2;
+	tcph->window = htons(cm_node->tcp_cntxt.rcv_wnd);
+	tcph->urg_ptr = 0;
+
+	if (opts_len) {
+		memcpy(buf, options->addr, opts_len);
+		buf += opts_len;
+	}
+
+	if (hdr_len) {
+		memcpy(buf, hdr->addr, hdr_len);
+		buf += hdr_len;
+	}
+
+	if (pdata && pdata->addr)
+		memcpy(buf, pdata->addr, pdata->size);
+
+	refcount_set(&sqbuf->refcount, 1);
+
+	irdma_debug_buf(vsi->dev, IRDMA_DEBUG_ILQ, "TRANSMIT ILQ BUFFER",
+			sqbuf->mem.va, sqbuf->totallen);
+
+	return sqbuf;
+}
+
+/**
+ * irdma_form_uda_cm_frame - get a free packet and build frame full tcpip packet
+ * @cm_node: connection's node ionfo to use in frame
+ * @options: pointer to options info
+ * @hdr: pointer mpa header
+ * @pdata: pointer to private data
+ * @flags:  indicates FIN or ACK
+ */
+static struct irdma_puda_buf *irdma_form_uda_cm_frame(struct irdma_cm_node *cm_node,
+						      struct irdma_kmem_info *options,
+						      struct irdma_kmem_info *hdr,
+						      struct irdma_kmem_info *pdata,
+						      u8 flags)
+{
+	struct irdma_puda_buf *sqbuf;
+	struct irdma_sc_vsi *vsi = &cm_node->iwdev->vsi;
+	u8 *buf;
+
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+	struct ethhdr *ethh;
+	u16 pktsize;
+	u16 eth_hlen = ETH_HLEN;
+	u32 opts_len = 0;
+	u32 pd_len = 0;
+	u32 hdr_len = 0;
+
+	u16 vtag;
+
+	sqbuf = irdma_puda_get_bufpool(vsi->ilq);
+	if (!sqbuf)
+		return NULL;
+
+	buf = sqbuf->mem.va;
+
+	if (options)
+		opts_len = (u32)options->size;
+
+	if (hdr)
+		hdr_len = hdr->size;
+
+	if (pdata)
+		pd_len = pdata->size;
+
+	if (cm_node->vlan_id < VLAN_N_VID)
+		eth_hlen += 4;
+
+	if (cm_node->ipv4)
+		pktsize = sizeof(*iph) + sizeof(*tcph);
+	else
+		pktsize = sizeof(*ip6h) + sizeof(*tcph);
+	pktsize += opts_len + hdr_len + pd_len;
+
+	memset(buf, 0, eth_hlen + pktsize);
+
+	sqbuf->totallen = pktsize + eth_hlen;
+	sqbuf->maclen = eth_hlen;
+	sqbuf->tcphlen = sizeof(*tcph) + opts_len;
+	sqbuf->scratch = cm_node;
+
+	ethh = (struct ethhdr *)buf;
+	buf += eth_hlen;
+
+	if (cm_node->do_lpb)
+		sqbuf->do_lpb = true;
+
+	if (cm_node->ipv4) {
+		sqbuf->ipv4 = true;
+
+		iph = (struct iphdr *)buf;
+		buf += sizeof(*iph);
+		tcph = (struct tcphdr *)buf;
+		buf += sizeof(*tcph);
+
+		ether_addr_copy(ethh->h_dest, cm_node->rem_mac);
+		ether_addr_copy(ethh->h_source, cm_node->loc_mac);
+		if (cm_node->vlan_id < VLAN_N_VID) {
+			((struct vlan_ethhdr *)ethh)->h_vlan_proto =
+				htons(ETH_P_8021Q);
+			vtag = (cm_node->user_pri << VLAN_PRIO_SHIFT) |
+			       cm_node->vlan_id;
+			((struct vlan_ethhdr *)ethh)->h_vlan_TCI = htons(vtag);
+
+			((struct vlan_ethhdr *)ethh)->h_vlan_encapsulated_proto =
+				htons(ETH_P_IP);
+		} else {
+			ethh->h_proto = htons(ETH_P_IP);
+		}
+
+		iph->version = IPVERSION;
+		iph->ihl = 5; /* 5 * 4Byte words, IP headr len */
+		iph->tos = cm_node->tos;
+		iph->tot_len = htons(pktsize);
+		iph->id = htons(++cm_node->tcp_cntxt.loc_id);
+
+		iph->frag_off = htons(0x4000);
+		iph->ttl = 0x40;
+		iph->protocol = IPPROTO_TCP;
+		iph->saddr = htonl(cm_node->loc_addr[0]);
+		iph->daddr = htonl(cm_node->rem_addr[0]);
+	} else {
+		sqbuf->ipv4 = false;
+		ip6h = (struct ipv6hdr *)buf;
+		buf += sizeof(*ip6h);
+		tcph = (struct tcphdr *)buf;
+		buf += sizeof(*tcph);
+
+		ether_addr_copy(ethh->h_dest, cm_node->rem_mac);
+		ether_addr_copy(ethh->h_source, cm_node->loc_mac);
+		if (cm_node->vlan_id < VLAN_N_VID) {
+			((struct vlan_ethhdr *)ethh)->h_vlan_proto =
+				htons(ETH_P_8021Q);
+			vtag = (cm_node->user_pri << VLAN_PRIO_SHIFT) |
+			       cm_node->vlan_id;
+			((struct vlan_ethhdr *)ethh)->h_vlan_TCI = htons(vtag);
+			((struct vlan_ethhdr *)ethh)->h_vlan_encapsulated_proto =
+				htons(ETH_P_IPV6);
+		} else {
+			ethh->h_proto = htons(ETH_P_IPV6);
+		}
+		ip6h->version = 6;
+		ip6h->priority = cm_node->tos >> 4;
+		ip6h->flow_lbl[0] = cm_node->tos << 4;
+		ip6h->flow_lbl[1] = 0;
+		ip6h->flow_lbl[2] = 0;
+		ip6h->payload_len = htons(pktsize - sizeof(*ip6h));
+		ip6h->nexthdr = 6;
+		ip6h->hop_limit = 128;
+		irdma_copy_ip_htonl(ip6h->saddr.in6_u.u6_addr32,
+				    cm_node->loc_addr);
+		irdma_copy_ip_htonl(ip6h->daddr.in6_u.u6_addr32,
+				    cm_node->rem_addr);
+	}
+
+	tcph->source = htons(cm_node->loc_port);
+	tcph->dest = htons(cm_node->rem_port);
+	tcph->seq = htonl(cm_node->tcp_cntxt.loc_seq_num);
+
+	if (flags & SET_ACK) {
+		cm_node->tcp_cntxt.loc_ack_num = cm_node->tcp_cntxt.rcv_nxt;
+		tcph->ack_seq = htonl(cm_node->tcp_cntxt.loc_ack_num);
+		tcph->ack = 1;
+	} else {
+		tcph->ack_seq = 0;
+	}
+
+	if (flags & SET_SYN) {
+		cm_node->tcp_cntxt.loc_seq_num++;
+		tcph->syn = 1;
+	} else {
+		cm_node->tcp_cntxt.loc_seq_num += hdr_len + pd_len;
+	}
+
+	if (flags & SET_FIN) {
+		cm_node->tcp_cntxt.loc_seq_num++;
+		tcph->fin = 1;
+	}
+
+	if (flags & SET_RST)
+		tcph->rst = 1;
+
+	tcph->doff = (u16)((sizeof(*tcph) + opts_len + 3) >> 2);
+	sqbuf->tcphlen = tcph->doff << 2;
+	tcph->window = htons(cm_node->tcp_cntxt.rcv_wnd);
+	tcph->urg_ptr = 0;
+
+	if (opts_len) {
+		memcpy(buf, options->addr, opts_len);
+		buf += opts_len;
+	}
+
+	if (hdr_len) {
+		memcpy(buf, hdr->addr, hdr_len);
+		buf += hdr_len;
+	}
+
+	if (pdata && pdata->addr)
+		memcpy(buf, pdata->addr, pdata->size);
+
+	refcount_set(&sqbuf->refcount, 1);
+
+	irdma_debug_buf(vsi->dev, IRDMA_DEBUG_ILQ, "TRANSMIT ILQ BUFFER",
+			sqbuf->mem.va, sqbuf->totallen);
+
+	return sqbuf;
+}
+
+/**
+ * irdma_send_reset - Send RST packet
+ * @cm_node: connection's node
+ */
+int irdma_send_reset(struct irdma_cm_node *cm_node)
+{
+	struct irdma_puda_buf *sqbuf;
+	int flags = SET_RST | SET_ACK;
+
+	trace_irdma_send_reset(cm_node, 0, __builtin_return_address(0));
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, NULL, NULL, NULL,
+						flags);
+	if (!sqbuf)
+		return -1;
+
+	return irdma_schedule_cm_timer(cm_node, sqbuf, IRDMA_TIMER_TYPE_SEND, 0,
+				       1);
+}
+
+/**
+ * irdma_active_open_err - send event for active side cm error
+ * @cm_node: connection's node
+ * @reset: Flag to send reset or not
+ */
+static void irdma_active_open_err(struct irdma_cm_node *cm_node, bool reset)
+{
+	trace_irdma_active_open_err(cm_node, reset,
+				    __builtin_return_address(0));
+	irdma_cleanup_retrans_entry(cm_node);
+	cm_node->cm_core->stats_connect_errs++;
+	if (reset) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: cm_node=%p state=%d\n", cm_node,
+			  cm_node->state);
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+	}
+
+	cm_node->state = IRDMA_CM_STATE_CLOSED;
+	irdma_create_event(cm_node, IRDMA_CM_EVENT_ABORTED);
+}
+
+/**
+ * irdma_passive_open_err - handle passive side cm error
+ * @cm_node: connection's node
+ * @reset: send reset or just free cm_node
+ */
+static void irdma_passive_open_err(struct irdma_cm_node *cm_node, bool reset)
+{
+	irdma_cleanup_retrans_entry(cm_node);
+	cm_node->cm_core->stats_passive_errs++;
+	cm_node->state = IRDMA_CM_STATE_CLOSED;
+	ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: cm_node=%p state =%d\n",
+		  cm_node, cm_node->state);
+	trace_irdma_passive_open_err(cm_node, reset,
+				     __builtin_return_address(0));
+	if (reset)
+		irdma_send_reset(cm_node);
+	else
+		irdma_rem_ref_cm_node(cm_node);
+}
+
+/**
+ * irdma_event_connect_error - to create connect error event
+ * @event: cm information for connect event
+ */
+static void irdma_event_connect_error(struct irdma_cm_event *event)
+{
+	struct irdma_qp *iwqp;
+	struct iw_cm_id *cm_id;
+
+	cm_id = event->cm_node->cm_id;
+	if (!cm_id)
+		return;
+
+	iwqp = cm_id->provider_data;
+
+	if (!iwqp || !iwqp->iwdev)
+		return;
+
+	iwqp->cm_id = NULL;
+	cm_id->provider_data = NULL;
+	irdma_send_cm_event(event->cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY,
+			    -ECONNRESET);
+	cm_id->rem_ref(cm_id);
+	irdma_rem_ref_cm_node(event->cm_node);
+}
+
+/**
+ * irdma_process_options - process options from TCP header
+ * @cm_node: connection's node
+ * @optionsloc: point to start of options
+ * @optionsize: size of all options
+ * @syn_pkt: flag if syn packet
+ */
+static int irdma_process_options(struct irdma_cm_node *cm_node, u8 *optionsloc,
+				 u32 optionsize, u32 syn_pkt)
+{
+	u32 tmp;
+	u32 offset = 0;
+	union all_known_options *all_options;
+	char got_mss_option = 0;
+
+	while (offset < optionsize) {
+		all_options = (union all_known_options *)(optionsloc + offset);
+		switch (all_options->base.optionnum) {
+		case OPTION_NUM_EOL:
+			offset = optionsize;
+			break;
+		case OPTION_NUM_NONE:
+			offset += 1;
+			continue;
+		case OPTION_NUM_MSS:
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: MSS Length: %d Offset: %d Size: %d\n",
+				  all_options->mss.len, offset, optionsize);
+			got_mss_option = 1;
+			if (all_options->mss.len != 4)
+				return -EINVAL;
+			tmp = ntohs(all_options->mss.mss);
+			if ((cm_node->ipv4 &&
+			     (tmp + IRDMA_MTU_TO_MSS_IPV4) < IRDMA_MIN_MTU_IPV4) ||
+			    (!cm_node->ipv4 &&
+			     (tmp + IRDMA_MTU_TO_MSS_IPV6) < IRDMA_MIN_MTU_IPV6))
+				return -EINVAL;
+			if (tmp < cm_node->tcp_cntxt.mss)
+				cm_node->tcp_cntxt.mss = tmp;
+			break;
+		case OPTION_NUM_WINDOW_SCALE:
+			cm_node->tcp_cntxt.snd_wscale =
+				all_options->windowscale.shiftcount;
+			break;
+		default:
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: Unsupported TCP Option: %x\n",
+				  all_options->base.optionnum);
+			break;
+		}
+		offset += all_options->base.len;
+	}
+	if (!got_mss_option && syn_pkt)
+		cm_node->tcp_cntxt.mss = IRDMA_CM_DEFAULT_MSS;
+
+	return 0;
+}
+
+/**
+ * irdma_handle_tcp_options - setup TCP context info after parsing TCP options
+ * @cm_node: connection's node
+ * @tcph: pointer tcp header
+ * @optionsize: size of options rcvd
+ * @passive: active or passive flag
+ */
+static int irdma_handle_tcp_options(struct irdma_cm_node *cm_node,
+				    struct tcphdr *tcph, int optionsize,
+				    int passive)
+{
+	u8 *optionsloc = (u8 *)&tcph[1];
+
+	if (optionsize) {
+		if (irdma_process_options(cm_node, optionsloc, optionsize,
+					  (u32)tcph->syn)) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: Node %p, Sending Reset\n", cm_node);
+			if (passive)
+				irdma_passive_open_err(cm_node, true);
+			else
+				irdma_active_open_err(cm_node, true);
+			return -1;
+		}
+	}
+
+	cm_node->tcp_cntxt.snd_wnd = ntohs(tcph->window)
+				     << cm_node->tcp_cntxt.snd_wscale;
+
+	if (cm_node->tcp_cntxt.snd_wnd > cm_node->tcp_cntxt.max_snd_wnd)
+		cm_node->tcp_cntxt.max_snd_wnd = cm_node->tcp_cntxt.snd_wnd;
+
+	return 0;
+}
+
+/**
+ * irdma_build_mpa_v1 - build a MPA V1 frame
+ * @cm_node: connection's node
+ * @start_addr: address where to build frame
+ * @mpa_key: to do read0 or write0
+ */
+static void irdma_build_mpa_v1(struct irdma_cm_node *cm_node, void *start_addr,
+			       u8 mpa_key)
+{
+	struct ietf_mpa_v1 *mpa_frame = start_addr;
+
+	switch (mpa_key) {
+	case MPA_KEY_REQUEST:
+		memcpy(mpa_frame->key, IEFT_MPA_KEY_REQ, IETF_MPA_KEY_SIZE);
+		break;
+	case MPA_KEY_REPLY:
+		memcpy(mpa_frame->key, IEFT_MPA_KEY_REP, IETF_MPA_KEY_SIZE);
+		break;
+	default:
+		break;
+	}
+	mpa_frame->flags = IETF_MPA_FLAGS_CRC;
+	mpa_frame->rev = cm_node->mpa_frame_rev;
+	mpa_frame->priv_data_len = htons(cm_node->pdata.size);
+}
+
+/**
+ * irdma_build_mpa_v2 - build a MPA V2 frame
+ * @cm_node: connection's node
+ * @start_addr: buffer start address
+ * @mpa_key: to do read0 or write0
+ */
+static void irdma_build_mpa_v2(struct irdma_cm_node *cm_node, void *start_addr,
+			       u8 mpa_key)
+{
+	struct ietf_mpa_v2 *mpa_frame = start_addr;
+	struct ietf_rtr_msg *rtr_msg = &mpa_frame->rtr_msg;
+	u16 ctrl_ird, ctrl_ord;
+
+	/* initialize the upper 5 bytes of the frame */
+	irdma_build_mpa_v1(cm_node, start_addr, mpa_key);
+	mpa_frame->flags |= IETF_MPA_V2_FLAG;
+	mpa_frame->priv_data_len = cpu_to_be16(be16_to_cpu(mpa_frame->priv_data_len) +
+					       IETF_RTR_MSG_SIZE);
+
+	/* initialize RTR msg */
+	if (cm_node->mpav2_ird_ord == IETF_NO_IRD_ORD) {
+		ctrl_ird = IETF_NO_IRD_ORD;
+		ctrl_ord = IETF_NO_IRD_ORD;
+	} else {
+		ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
+				   IETF_NO_IRD_ORD :
+				   cm_node->ird_size;
+		ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
+				   IETF_NO_IRD_ORD :
+				   cm_node->ord_size;
+	}
+	ctrl_ird |= IETF_PEER_TO_PEER;
+
+	switch (mpa_key) {
+	case MPA_KEY_REQUEST:
+		ctrl_ord |= IETF_RDMA0_WRITE;
+		ctrl_ord |= IETF_RDMA0_READ;
+		break;
+	case MPA_KEY_REPLY:
+		switch (cm_node->send_rdma0_op) {
+		case SEND_RDMA_WRITE_ZERO:
+			ctrl_ord |= IETF_RDMA0_WRITE;
+			break;
+		case SEND_RDMA_READ_ZERO:
+			ctrl_ord |= IETF_RDMA0_READ;
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+	rtr_msg->ctrl_ird = htons(ctrl_ird);
+	rtr_msg->ctrl_ord = htons(ctrl_ord);
+}
+
+/**
+ * irdma_cm_build_mpa_frame - build mpa frame for mpa version 1 or version 2
+ * @cm_node: connection's node
+ * @mpa: mpa: data buffer
+ * @mpa_key: to do read0 or write0
+ */
+static int irdma_cm_build_mpa_frame(struct irdma_cm_node *cm_node,
+				    struct irdma_kmem_info *mpa, u8 mpa_key)
+{
+	int hdr_len = 0;
+
+	switch (cm_node->mpa_frame_rev) {
+	case IETF_MPA_V1:
+		hdr_len = sizeof(struct ietf_mpa_v1);
+		irdma_build_mpa_v1(cm_node, mpa->addr, mpa_key);
+		break;
+	case IETF_MPA_V2:
+		hdr_len = sizeof(struct ietf_mpa_v2);
+		irdma_build_mpa_v2(cm_node, mpa->addr, mpa_key);
+		break;
+	default:
+		break;
+	}
+
+	return hdr_len;
+}
+
+/**
+ * irdma_send_mpa_request - active node send mpa request to passive node
+ * @cm_node: connection's node
+ */
+static int irdma_send_mpa_request(struct irdma_cm_node *cm_node)
+{
+	struct irdma_puda_buf *sqbuf;
+
+	if (!cm_node) {
+		pr_err("cm_node == NULL\n");
+		return -1;
+	}
+
+	cm_node->mpa_hdr.addr = &cm_node->mpa_frame;
+	cm_node->mpa_hdr.size = irdma_cm_build_mpa_frame(cm_node,
+							 &cm_node->mpa_hdr,
+							 MPA_KEY_REQUEST);
+	if (!cm_node->mpa_hdr.size) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: mpa size = %d\n",
+			  cm_node->mpa_hdr.size);
+		return -1;
+	}
+
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, NULL,
+						&cm_node->mpa_hdr,
+						&cm_node->pdata, SET_ACK);
+	if (!sqbuf)
+		return -1;
+
+	return irdma_schedule_cm_timer(cm_node, sqbuf, IRDMA_TIMER_TYPE_SEND, 1,
+				       0);
+}
+
+/**
+ * irdma_send_mpa_reject -
+ * @cm_node: connection's node
+ * @pdata: reject data for connection
+ * @plen: length of reject data
+ */
+static int irdma_send_mpa_reject(struct irdma_cm_node *cm_node,
+				 const void *pdata, u8 plen)
+{
+	struct irdma_puda_buf *sqbuf;
+	struct irdma_kmem_info priv_info;
+
+	cm_node->mpa_hdr.addr = &cm_node->mpa_frame;
+	cm_node->mpa_hdr.size = irdma_cm_build_mpa_frame(cm_node,
+							 &cm_node->mpa_hdr,
+							 MPA_KEY_REPLY);
+
+	cm_node->mpa_frame.flags |= IETF_MPA_FLAGS_REJECT;
+	priv_info.addr = (void *)pdata;
+	priv_info.size = plen;
+
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, NULL,
+						&cm_node->mpa_hdr, &priv_info,
+						SET_ACK | SET_FIN);
+	if (!sqbuf)
+		return -ENOMEM;
+
+	cm_node->state = IRDMA_CM_STATE_FIN_WAIT1;
+
+	return irdma_schedule_cm_timer(cm_node, sqbuf, IRDMA_TIMER_TYPE_SEND, 1,
+				       0);
+}
+
+/**
+ * irdma_mpav2_negotiate_ird_ord - negotiate MPAv2 IRD/ORD
+ * @cm_node: connection's node
+ * @buf: Data pointer
+ */
+static int irdma_negotiate_mpa_v2_ird_ord(struct irdma_cm_node *cm_node,
+					  u8 *buf)
+{
+	struct ietf_mpa_v2 *mpa_v2_frame;
+	struct ietf_rtr_msg *rtr_msg;
+	u16 ird_size;
+	u16 ord_size;
+	u16 ctrl_ord;
+	u16 ctrl_ird;
+
+	mpa_v2_frame = (struct ietf_mpa_v2 *)buf;
+	rtr_msg = &mpa_v2_frame->rtr_msg;
+
+	/* parse rtr message */
+	ctrl_ord = ntohs(rtr_msg->ctrl_ord);
+	ctrl_ird = ntohs(rtr_msg->ctrl_ird);
+	ird_size = ctrl_ird & IETF_NO_IRD_ORD;
+	ord_size = ctrl_ord & IETF_NO_IRD_ORD;
+
+	if (!(ctrl_ird & IETF_PEER_TO_PEER))
+		return -1;
+
+	if (ird_size == IETF_NO_IRD_ORD || ord_size == IETF_NO_IRD_ORD) {
+		cm_node->mpav2_ird_ord = IETF_NO_IRD_ORD;
+		goto negotiate_done;
+	}
+
+	if (cm_node->state != IRDMA_CM_STATE_MPAREQ_SENT) {
+		/* responder */
+		if (!ord_size && (ctrl_ord & IETF_RDMA0_READ))
+			cm_node->ird_size = 1;
+		if (cm_node->ord_size > ird_size)
+			cm_node->ord_size = ird_size;
+	} else {
+		/* initiator */
+		if (!ird_size && (ctrl_ord & IETF_RDMA0_READ))
+			/* Remote peer doesn't support RDMA0_READ */
+			return -1;
+
+		if (cm_node->ord_size > ird_size)
+			cm_node->ord_size = ird_size;
+
+		if (cm_node->ird_size < ord_size)
+		/* no resources available */
+			return -1;
+	}
+
+negotiate_done:
+	if (ctrl_ord & IETF_RDMA0_READ)
+		cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
+	else if (ctrl_ord & IETF_RDMA0_WRITE)
+		cm_node->send_rdma0_op = SEND_RDMA_WRITE_ZERO;
+	else
+		/* Not supported RDMA0 operation */
+		return -1;
+
+	ibdev_dbg(to_ibdev(cm_node->iwdev),
+		  "CM: MPAV2 Negotiated ORD: %d, IRD: %d\n",
+		  cm_node->ord_size, cm_node->ird_size);
+	trace_irdma_negotiate_mpa_v2(cm_node);
+	return 0;
+}
+
+/**
+ * recv_mpa - process an IETF MPA frame
+ * @cm_node: connection's node
+ * @buf: Data pointer
+ * @type: to return accept or reject
+ * @len: Len of mpa buffer
+ */
+static int irdma_parse_mpa(struct irdma_cm_node *cm_node, u8 *buf, u32 *type,
+			   u32 len)
+{
+	struct ietf_mpa_v1 *mpa_frame;
+	int mpa_hdr_len;
+	int priv_data_len;
+
+	*type = IRDMA_MPA_REQUEST_ACCEPT;
+
+	if (len < sizeof(struct ietf_mpa_v1)) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: ietf buffer small (%x)\n", len);
+		return -1;
+	}
+
+	mpa_frame = (struct ietf_mpa_v1 *)buf;
+	mpa_hdr_len = sizeof(struct ietf_mpa_v1);
+	priv_data_len = ntohs(mpa_frame->priv_data_len);
+
+	if (priv_data_len > IETF_MAX_PRIV_DATA_LEN) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: large pri_data %d\n",
+			  priv_data_len);
+		return -1;
+	}
+
+	if (mpa_frame->rev != IETF_MPA_V1 && mpa_frame->rev != IETF_MPA_V2) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: unsupported mpa rev = %d\n", mpa_frame->rev);
+		return -1;
+	}
+
+	if (mpa_frame->rev > cm_node->mpa_frame_rev) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: rev %d\n",
+			  mpa_frame->rev);
+		return -1;
+	}
+
+	cm_node->mpa_frame_rev = mpa_frame->rev;
+	if (cm_node->state != IRDMA_CM_STATE_MPAREQ_SENT) {
+		if (memcmp(mpa_frame->key, IEFT_MPA_KEY_REQ,
+			   IETF_MPA_KEY_SIZE)) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: Unexpected MPA Key received\n");
+			return -1;
+		}
+	} else {
+		if (memcmp(mpa_frame->key, IEFT_MPA_KEY_REP,
+			   IETF_MPA_KEY_SIZE)) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: Unexpected MPA Key received\n");
+			return -1;
+		}
+	}
+
+	if (priv_data_len + mpa_hdr_len > len) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: ietf buffer len(%x + %x != %x)\n",
+			  priv_data_len, mpa_hdr_len, len);
+		return -1;
+	}
+
+	if (len > IRDMA_MAX_CM_BUF) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: ietf buffer large len = %d\n", len);
+		return -1;
+	}
+
+	switch (mpa_frame->rev) {
+	case IETF_MPA_V2:
+		mpa_hdr_len += IETF_RTR_MSG_SIZE;
+		if (irdma_negotiate_mpa_v2_ird_ord(cm_node, buf))
+			return -1;
+		break;
+	case IETF_MPA_V1:
+	default:
+		break;
+	}
+
+	memcpy(cm_node->pdata_buf, buf + mpa_hdr_len, priv_data_len);
+	cm_node->pdata.size = priv_data_len;
+
+	if (mpa_frame->flags & IETF_MPA_FLAGS_REJECT)
+		*type = IRDMA_MPA_REQUEST_REJECT;
+
+	if (mpa_frame->flags & IETF_MPA_FLAGS_MARKERS)
+		cm_node->snd_mark_en = true;
+
+	return 0;
+}
+
+/**
+ * irdma_schedule_cm_timer
+ * @cm_node: connection's node
+ * @sqbuf: buffer to send
+ * @type: if it is send or close
+ * @send_retrans: if rexmits to be done
+ * @close_when_complete: is cm_node to be removed
+ *
+ * note - cm_node needs to be protected before calling this. Encase in:
+ *		irdma_rem_ref_cm_node(cm_core, cm_node);
+ *		irdma_schedule_cm_timer(...)
+ *		refcount_inc(&cm_node->refcnt);
+ */
+int irdma_schedule_cm_timer(struct irdma_cm_node *cm_node,
+			    struct irdma_puda_buf *sqbuf,
+			    enum irdma_timer_type type, int send_retrans,
+			    int close_when_complete)
+{
+	struct irdma_sc_vsi *vsi = &cm_node->iwdev->vsi;
+	struct irdma_cm_core *cm_core = cm_node->cm_core;
+	struct irdma_timer_entry *new_send;
+	u32 was_timer_set;
+	unsigned long flags;
+
+	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
+	if (!new_send) {
+		if (type != IRDMA_TIMER_TYPE_CLOSE)
+			irdma_free_sqbuf(vsi, sqbuf);
+		return -ENOMEM;
+	}
+
+	new_send->retrycount = IRDMA_DEFAULT_RETRYS;
+	new_send->retranscount = IRDMA_DEFAULT_RETRANS;
+	new_send->sqbuf = sqbuf;
+	new_send->timetosend = jiffies;
+	new_send->type = type;
+	new_send->send_retrans = send_retrans;
+	new_send->close_when_complete = close_when_complete;
+
+	if (type == IRDMA_TIMER_TYPE_CLOSE) {
+		new_send->timetosend += (HZ / 10);
+		if (cm_node->close_entry) {
+			kfree(new_send);
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: already close entry\n");
+			return -EINVAL;
+		}
+
+		cm_node->close_entry = new_send;
+	} else { /* type == IRDMA_TIMER_TYPE_SEND */
+		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
+		cm_node->send_entry = new_send;
+		refcount_inc(&cm_node->refcnt);
+		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
+		new_send->timetosend = jiffies + IRDMA_RETRY_TIMEOUT;
+
+		refcount_inc(&sqbuf->refcount);
+		irdma_puda_send_buf(vsi->ilq, sqbuf);
+		if (!send_retrans) {
+			irdma_cleanup_retrans_entry(cm_node);
+			if (close_when_complete)
+				irdma_rem_ref_cm_node(cm_node);
+			return 0;
+		}
+	}
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	was_timer_set = timer_pending(&cm_core->tcp_timer);
+
+	if (!was_timer_set) {
+		cm_core->tcp_timer.expires = new_send->timetosend;
+		add_timer(&cm_core->tcp_timer);
+	}
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	return 0;
+}
+
+/**
+ * irdma_retrans_expired - Could not rexmit the packet
+ * @cm_node: connection's node
+ */
+static void irdma_retrans_expired(struct irdma_cm_node *cm_node)
+{
+	struct iw_cm_id *cm_id = cm_node->cm_id;
+	enum irdma_cm_node_state state = cm_node->state;
+
+	cm_node->state = IRDMA_CM_STATE_CLOSED;
+	switch (state) {
+	case IRDMA_CM_STATE_SYN_RCVD:
+	case IRDMA_CM_STATE_CLOSING:
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT1:
+	case IRDMA_CM_STATE_LAST_ACK:
+		if (cm_node->cm_id)
+			cm_id->rem_ref(cm_id);
+		irdma_send_reset(cm_node);
+		break;
+	default:
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+		irdma_create_event(cm_node, IRDMA_CM_EVENT_ABORTED);
+		break;
+	}
+}
+
+/**
+ * irdma_handle_close_entry - for handling retry/timeouts
+ * @cm_node: connection's node
+ * @rem_node: flag for remove cm_node
+ */
+static void irdma_handle_close_entry(struct irdma_cm_node *cm_node,
+				     u32 rem_node)
+{
+	struct irdma_timer_entry *close_entry = cm_node->close_entry;
+	struct iw_cm_id *cm_id = cm_node->cm_id;
+	struct irdma_qp *iwqp;
+	unsigned long flags;
+
+	if (!close_entry)
+		return;
+	iwqp = (struct irdma_qp *)close_entry->sqbuf;
+	if (iwqp) {
+		spin_lock_irqsave(&iwqp->lock, flags);
+		if (iwqp->cm_id) {
+			iwqp->hw_tcp_state = IRDMA_TCP_STATE_CLOSED;
+			iwqp->hw_iwarp_state = IRDMA_QP_STATE_ERROR;
+			iwqp->last_aeq = IRDMA_AE_RESET_SENT;
+			iwqp->ibqp_state = IB_QPS_ERR;
+			spin_unlock_irqrestore(&iwqp->lock, flags);
+			irdma_cm_disconn(iwqp);
+		} else {
+			spin_unlock_irqrestore(&iwqp->lock, flags);
+		}
+	} else if (rem_node) {
+		/* TIME_WAIT state */
+		irdma_rem_ref_cm_node(cm_node);
+	}
+	if (cm_id)
+		cm_id->rem_ref(cm_id);
+	kfree(close_entry);
+	cm_node->close_entry = NULL;
+}
+
+/**
+ * irdma_build_timer_list - Add cm_nodes to timer list
+ * @timer_list: ptr to timer list
+ * @hte: ptr to accelerated or non-accelerated list
+ */
+static void irdma_build_timer_list(struct list_head *timer_list,
+				   struct list_head *hte)
+{
+	struct irdma_cm_node *cm_node;
+	struct list_head *list_core_temp, *list_node;
+
+	list_for_each_safe (list_node, list_core_temp, hte) {
+		cm_node = container_of(list_node, struct irdma_cm_node, list);
+		if (cm_node->close_entry || cm_node->send_entry) {
+			refcount_inc(&cm_node->refcnt);
+			list_add(&cm_node->timer_entry, timer_list);
+		}
+	}
+}
+
+/**
+ * irdma_cm_timer_tick - system's timer expired callback
+ * @t: Pointer to timer_list
+ */
+static void irdma_cm_timer_tick(struct timer_list *t)
+{
+	unsigned long nexttimeout = jiffies + IRDMA_LONG_TIME;
+	struct irdma_cm_node *cm_node;
+	struct irdma_timer_entry *send_entry, *close_entry;
+	struct list_head *list_core_temp;
+	struct list_head *list_node;
+	struct irdma_cm_core *cm_core = from_timer(cm_core, t, tcp_timer);
+	struct irdma_sc_vsi *vsi;
+	u32 settimer = 0;
+	unsigned long timetosend;
+	unsigned long flags;
+	struct list_head timer_list;
+
+	INIT_LIST_HEAD(&timer_list);
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	irdma_build_timer_list(&timer_list, &cm_core->non_accelerated_list);
+	irdma_build_timer_list(&timer_list, &cm_core->accelerated_list);
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	list_for_each_safe (list_node, list_core_temp, &timer_list) {
+		cm_node = container_of(list_node, struct irdma_cm_node,
+				       timer_entry);
+		close_entry = cm_node->close_entry;
+
+		if (close_entry) {
+			if (time_after(close_entry->timetosend, jiffies)) {
+				if (nexttimeout > close_entry->timetosend ||
+				    !settimer) {
+					nexttimeout = close_entry->timetosend;
+					settimer = 1;
+				}
+			} else {
+				irdma_handle_close_entry(cm_node, 1);
+			}
+		}
+
+		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
+
+		send_entry = cm_node->send_entry;
+		if (!send_entry)
+			goto done;
+		if (time_after(send_entry->timetosend, jiffies)) {
+			if (cm_node->state != IRDMA_CM_STATE_OFFLOADED) {
+				if (nexttimeout > send_entry->timetosend ||
+				    !settimer) {
+					nexttimeout = send_entry->timetosend;
+					settimer = 1;
+				}
+			} else {
+				irdma_free_retrans_entry(cm_node);
+			}
+			goto done;
+		}
+
+		if (cm_node->state == IRDMA_CM_STATE_OFFLOADED ||
+		    cm_node->state == IRDMA_CM_STATE_CLOSED) {
+			irdma_free_retrans_entry(cm_node);
+			goto done;
+		}
+
+		if (!send_entry->retranscount || !send_entry->retrycount) {
+			irdma_free_retrans_entry(cm_node);
+
+			spin_unlock_irqrestore(&cm_node->retrans_list_lock,
+					       flags);
+			irdma_retrans_expired(cm_node);
+			cm_node->state = IRDMA_CM_STATE_CLOSED;
+			spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
+			goto done;
+		}
+		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
+
+		vsi = &cm_node->iwdev->vsi;
+		if (!cm_node->ack_rcvd) {
+			refcount_inc(&send_entry->sqbuf->refcount);
+			irdma_puda_send_buf(vsi->ilq, send_entry->sqbuf);
+			cm_node->cm_core->stats_pkt_retrans++;
+		}
+
+		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
+		if (send_entry->send_retrans) {
+			send_entry->retranscount--;
+			timetosend = (IRDMA_RETRY_TIMEOUT <<
+				      (IRDMA_DEFAULT_RETRANS -
+				       send_entry->retranscount));
+
+			send_entry->timetosend = jiffies +
+			    min(timetosend, IRDMA_MAX_TIMEOUT);
+			if (nexttimeout > send_entry->timetosend || !settimer) {
+				nexttimeout = send_entry->timetosend;
+				settimer = 1;
+			}
+		} else {
+			int close_when_complete;
+
+			close_when_complete = send_entry->close_when_complete;
+			irdma_free_retrans_entry(cm_node);
+			if (close_when_complete)
+				irdma_rem_ref_cm_node(cm_node);
+		}
+done:
+		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
+		irdma_rem_ref_cm_node(cm_node);
+	}
+
+	if (settimer) {
+		spin_lock_irqsave(&cm_core->ht_lock, flags);
+		if (!timer_pending(&cm_core->tcp_timer)) {
+			cm_core->tcp_timer.expires = nexttimeout;
+			add_timer(&cm_core->tcp_timer);
+		}
+		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+	}
+}
+
+/**
+ * irdma_send_syn - send SYN packet
+ * @cm_node: connection's node
+ * @sendack: flag to set ACK bit or not
+ */
+int irdma_send_syn(struct irdma_cm_node *cm_node, u32 sendack)
+{
+	struct irdma_puda_buf *sqbuf;
+	int flags = SET_SYN;
+	char optionsbuf[sizeof(struct option_mss) +
+			sizeof(struct option_windowscale) +
+			sizeof(struct option_base) + TCP_OPTIONS_PADDING];
+	struct irdma_kmem_info opts;
+	int optionssize = 0;
+	/* Sending MSS option */
+	union all_known_options *options;
+
+	opts.addr = optionsbuf;
+	if (!cm_node)
+		return -EINVAL;
+
+	options = (union all_known_options *)&optionsbuf[optionssize];
+	options->mss.optionnum = OPTION_NUM_MSS;
+	options->mss.len = sizeof(struct option_mss);
+	options->mss.mss = htons(cm_node->tcp_cntxt.mss);
+	optionssize += sizeof(struct option_mss);
+
+	options = (union all_known_options *)&optionsbuf[optionssize];
+	options->windowscale.optionnum = OPTION_NUM_WINDOW_SCALE;
+	options->windowscale.len = sizeof(struct option_windowscale);
+	options->windowscale.shiftcount = cm_node->tcp_cntxt.rcv_wscale;
+	optionssize += sizeof(struct option_windowscale);
+	options = (union all_known_options *)&optionsbuf[optionssize];
+	options->eol = OPTION_NUM_EOL;
+	optionssize += 1;
+
+	if (sendack)
+		flags |= SET_ACK;
+
+	opts.size = optionssize;
+
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, &opts, NULL, NULL,
+						flags);
+	if (!sqbuf)
+		return -ENOMEM;
+
+	return irdma_schedule_cm_timer(cm_node, sqbuf, IRDMA_TIMER_TYPE_SEND, 1,
+				       0);
+}
+
+/**
+ * irdma_send_ack - Send ACK packet
+ * @cm_node: connection's node
+ */
+void irdma_send_ack(struct irdma_cm_node *cm_node)
+{
+	struct irdma_puda_buf *sqbuf;
+	struct irdma_sc_vsi *vsi = &cm_node->iwdev->vsi;
+
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, NULL, NULL, NULL,
+						SET_ACK);
+	if (sqbuf)
+		irdma_puda_send_buf(vsi->ilq, sqbuf);
+}
+
+/**
+ * irdma_send_fin - Send FIN pkt
+ * @cm_node: connection's node
+ */
+static int irdma_send_fin(struct irdma_cm_node *cm_node)
+{
+	struct irdma_puda_buf *sqbuf;
+
+	sqbuf = cm_node->cm_core->form_cm_frame(cm_node, NULL, NULL, NULL,
+						SET_ACK | SET_FIN);
+	if (!sqbuf)
+		return -1;
+
+	return irdma_schedule_cm_timer(cm_node, sqbuf, IRDMA_TIMER_TYPE_SEND, 1,
+				       0);
+}
+
+/**
+ * irdma_find_node - find a cm node that matches the reference
+ * cm node
+ * @cm_core: cm's core
+ * @rem_port: remote tcp port num
+ * @rem_addr: remote ip addr
+ * @loc_port: local tcp port num
+ * @loc_addr: loc ip addr
+ * @add_refcnt: flag to increment refcount of cm_node
+ * @accelerated_list: flag for accelerated vs non-accelerated list to search
+ */
+struct irdma_cm_node *irdma_find_node(struct irdma_cm_core *cm_core,
+				      u16 rem_port, u32 *rem_addr, u16 loc_port,
+				      u32 *loc_addr, bool add_refcnt,
+				      bool accelerated_list)
+{
+	struct list_head *hte;
+	struct irdma_cm_node *cm_node;
+	unsigned long flags;
+
+	hte = accelerated_list ? &cm_core->accelerated_list :
+				 &cm_core->non_accelerated_list;
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	list_for_each_entry (cm_node, hte, list) {
+		if (!memcmp(cm_node->loc_addr, loc_addr, sizeof(cm_node->loc_addr)) &&
+		    cm_node->loc_port == loc_port &&
+		    !memcmp(cm_node->rem_addr, rem_addr, sizeof(cm_node->rem_addr)) &&
+		    cm_node->rem_port == rem_port) {
+			if (add_refcnt)
+				refcount_inc(&cm_node->refcnt);
+			spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+			trace_irdma_find_node(cm_node, 0, NULL);
+			return cm_node;
+		}
+	}
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	/* no owner node */
+	return NULL;
+}
+
+/**
+ * irdma_find_listener - find a cm node listening on this addr-port pair
+ * @cm_core: cm's core
+ * @dst_addr: listener ip addr
+ * @dst_port: listener tcp port num
+ * @vlan_id: virtual LAN ID
+ * @listener_state: state to match with listen node's
+ */
+static struct irdma_cm_listener *
+irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
+		    u16 vlan_id, enum irdma_cm_listener_state listener_state)
+{
+	struct irdma_cm_listener *listen_node;
+	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
+	u32 listen_addr[4];
+	u16 listen_port;
+	unsigned long flags;
+
+	/* walk list and find cm_node associated with this session ID */
+	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+	list_for_each_entry (listen_node, &cm_core->listen_nodes, list) {
+		memcpy(listen_addr, listen_node->loc_addr, sizeof(listen_addr));
+		listen_port = listen_node->loc_port;
+		/* compare node pair, return node handle if a match */
+		if ((!memcmp(listen_addr, dst_addr, sizeof(listen_addr)) ||
+		     !memcmp(listen_addr, ip_zero, sizeof(listen_addr))) &&
+		    listen_port == dst_port &&
+		    vlan_id == listen_node->vlan_id &&
+		    (listener_state & listen_node->listener_state)) {
+			refcount_inc(&listen_node->refcnt);
+			spin_unlock_irqrestore(&cm_core->listen_list_lock,
+					       flags);
+			trace_irdma_find_listener(listen_node);
+			return listen_node;
+		}
+	}
+	spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+
+	return NULL;
+}
+
+/**
+ * irdma_add_hte_node - add a cm node to the hash table
+ * @cm_core: cm's core
+ * @cm_node: connection's node
+ */
+static void irdma_add_hte_node(struct irdma_cm_core *cm_core,
+			       struct irdma_cm_node *cm_node)
+{
+	unsigned long flags;
+
+	if (!cm_node || !cm_core)
+		return;
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	list_add_tail(&cm_node->list, &cm_core->non_accelerated_list);
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+}
+
+/**
+ * irdma_find_port - find port that matches reference port
+ * @hte: ptr to accelerated or non-accelerated list
+ * @port: port number
+ */
+static bool irdma_find_port(struct list_head *hte, u16 port)
+{
+	struct irdma_cm_node *cm_node;
+
+	list_for_each_entry (cm_node, hte, list) {
+		if (cm_node->loc_port == port)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * irdma_port_in_use - determine if port is in use
+ * @cm_core: cm's core
+ * @port: port number
+ */
+bool irdma_port_in_use(struct irdma_cm_core *cm_core, u16 port)
+{
+	struct irdma_cm_listener *listen_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	if (irdma_find_port(&cm_core->accelerated_list, port) ||
+	    irdma_find_port(&cm_core->non_accelerated_list, port)) {
+		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+		return true;
+	}
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+	list_for_each_entry (listen_node, &cm_core->listen_nodes, list) {
+		if (listen_node->loc_port == port) {
+			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+			return true;
+		}
+	}
+	spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+
+	return false;
+}
+
+/**
+ * irdma_del_multiple_qhash - Remove qhash and child listens
+ * @iwdev: iWarp device
+ * @cm_info: CM info for parent listen node
+ * @cm_parent_listen_node: The parent listen node
+ */
+static enum irdma_status_code
+irdma_del_multiple_qhash(struct irdma_device *iwdev,
+			 struct irdma_cm_info *cm_info,
+			 struct irdma_cm_listener *cm_parent_listen_node)
+{
+	struct irdma_cm_listener *child_listen_node;
+	enum irdma_status_code ret = IRDMA_ERR_CFG;
+	struct list_head *pos, *tpos;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iwdev->cm_core.listen_list_lock, flags);
+	list_for_each_safe (pos, tpos,
+			    &cm_parent_listen_node->child_listen_list) {
+		child_listen_node = list_entry(pos, struct irdma_cm_listener,
+					       child_listen_list);
+		if (child_listen_node->ipv4)
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: removing child listen for IP=%pI4, port=%d, vlan=%d\n",
+				  child_listen_node->loc_addr,
+				  child_listen_node->loc_port,
+				  child_listen_node->vlan_id);
+		else
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: removing child listen for IP=%pI6, port=%d, vlan=%d\n",
+				  child_listen_node->loc_addr,
+				  child_listen_node->loc_port,
+				  child_listen_node->vlan_id);
+		trace_irdma_del_multiple_qhash(child_listen_node);
+		list_del(pos);
+		memcpy(cm_info->loc_addr, child_listen_node->loc_addr,
+		       sizeof(cm_info->loc_addr));
+		cm_info->vlan_id = child_listen_node->vlan_id;
+		if (child_listen_node->qhash_set) {
+			ret = irdma_manage_qhash(iwdev, cm_info,
+						 IRDMA_QHASH_TYPE_TCP_SYN,
+						 IRDMA_QHASH_MANAGE_TYPE_DELETE,
+						 NULL, false);
+			child_listen_node->qhash_set = false;
+		} else {
+			ret = 0;
+		}
+		ibdev_dbg(to_ibdev(iwdev),
+			  "CM: Child listen node freed = %p\n",
+			  child_listen_node);
+		kfree(child_listen_node);
+		cm_parent_listen_node->cm_core->stats_listen_nodes_destroyed++;
+	}
+	spin_unlock_irqrestore(&iwdev->cm_core.listen_list_lock, flags);
+
+	return ret;
+}
+
+/**
+ * irdma_netdev_vlan_ipv6 - Gets the netdev and mac
+ * @addr: local IPv6 address
+ * @vlan_id: vlan id for the given IPv6 address
+ * @mac: mac address for the given IPv6 address
+ *
+ * Returns the net_device of the IPv6 address and also sets the
+ * vlan id and mac for that address.
+ */
+struct net_device *irdma_netdev_vlan_ipv6(u32 *addr, u16 *vlan_id, u8 *mac)
+{
+	struct net_device *ip_dev = NULL;
+	struct in6_addr laddr6;
+
+	if (!IS_ENABLED(CONFIG_IPV6))
+		return NULL;
+
+	irdma_copy_ip_htonl(laddr6.in6_u.u6_addr32, addr);
+	if (vlan_id)
+		*vlan_id = 0xFFFF;	/* Match rdma_vlan_dev_vlan_id() */
+	if (mac)
+		eth_zero_addr(mac);
+
+	rcu_read_lock();
+	for_each_netdev_rcu (&init_net, ip_dev) {
+		if (ipv6_chk_addr(&init_net, &laddr6, ip_dev, 1)) {
+			if (vlan_id)
+				*vlan_id = rdma_vlan_dev_vlan_id(ip_dev);
+			if (ip_dev->dev_addr && mac)
+				ether_addr_copy(mac, ip_dev->dev_addr);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ip_dev;
+}
+
+/**
+ * irdma_get_vlan_ipv4 - Returns the vlan_id for IPv4 address
+ * @addr: local IPv4 address
+ */
+u16 irdma_get_vlan_ipv4(u32 *addr)
+{
+	struct net_device *netdev;
+	u16 vlan_id = 0xFFFF;
+
+	netdev = ip_dev_find(&init_net, htonl(addr[0]));
+	if (netdev) {
+		vlan_id = rdma_vlan_dev_vlan_id(netdev);
+		dev_put(netdev);
+	}
+
+	return vlan_id;
+}
+
+/**
+ * irdma_add_mqh_6 - Adds multiple qhashes for IPv6
+ * @iwdev: iWarp device
+ * @cm_info: CM info for parent listen node
+ * @cm_parent_listen_node: The parent listen node
+ *
+ * Adds a qhash and a child listen node for every IPv6 address
+ * on the adapter and adds the associated qhash filter
+ */
+static enum irdma_status_code
+irdma_add_mqh_6(struct irdma_device *iwdev, struct irdma_cm_info *cm_info,
+		struct irdma_cm_listener *cm_parent_listen_node)
+{
+	struct net_device *ip_dev;
+	struct inet6_dev *idev;
+	struct inet6_ifaddr *ifp, *tmp;
+	enum irdma_status_code ret = 0;
+	struct irdma_cm_listener *child_listen_node;
+	unsigned long flags;
+
+	rtnl_lock();
+	for_each_netdev (&init_net, ip_dev) {
+		if (!(ip_dev->flags & IFF_UP))
+			continue;
+
+		if (((rdma_vlan_dev_vlan_id(ip_dev) >= VLAN_N_VID) ||
+		     (rdma_vlan_dev_real_dev(ip_dev) != iwdev->netdev)) &&
+		    ip_dev != iwdev->netdev)
+			continue;
+
+		idev = __in6_dev_get(ip_dev);
+		if (!idev) {
+			ibdev_dbg(to_ibdev(iwdev), "CM: idev == NULL\n");
+			break;
+		}
+		list_for_each_entry_safe (ifp, tmp, &idev->addr_list, if_list) {
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: IP=%pI6, vlan_id=%d, MAC=%pM\n",
+				  &ifp->addr, rdma_vlan_dev_vlan_id(ip_dev),
+				  ip_dev->dev_addr);
+			child_listen_node = kzalloc(sizeof(*child_listen_node), GFP_KERNEL);
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: Allocating child listener %p\n",
+				  child_listen_node);
+			if (!child_listen_node) {
+				ibdev_dbg(to_ibdev(iwdev),
+					  "CM: listener memory allocation\n");
+				ret = IRDMA_ERR_NO_MEMORY;
+				goto exit;
+			}
+
+			cm_info->vlan_id = rdma_vlan_dev_vlan_id(ip_dev);
+			cm_parent_listen_node->vlan_id = cm_info->vlan_id;
+			memcpy(child_listen_node, cm_parent_listen_node,
+			       sizeof(*child_listen_node));
+			irdma_copy_ip_ntohl(child_listen_node->loc_addr,
+					    ifp->addr.in6_u.u6_addr32);
+			memcpy(cm_info->loc_addr, child_listen_node->loc_addr,
+			       sizeof(cm_info->loc_addr));
+			ret = irdma_manage_qhash(iwdev, cm_info,
+						 IRDMA_QHASH_TYPE_TCP_SYN,
+						 IRDMA_QHASH_MANAGE_TYPE_ADD,
+						 NULL, true);
+			if (ret) {
+				kfree(child_listen_node);
+				continue;
+			}
+
+			trace_irdma_add_mqh_6(iwdev, child_listen_node,
+					      ip_dev->dev_addr);
+
+			child_listen_node->qhash_set = true;
+			spin_lock_irqsave(&iwdev->cm_core.listen_list_lock, flags);
+			list_add(&child_listen_node->child_listen_list,
+				 &cm_parent_listen_node->child_listen_list);
+			spin_unlock_irqrestore(&iwdev->cm_core.listen_list_lock, flags);
+			cm_parent_listen_node->cm_core->stats_listen_nodes_created++;
+		}
+	}
+exit:
+	rtnl_unlock();
+
+	return ret;
+}
+
+/**
+ * irdma_add_mqh_4 - Adds multiple qhashes for IPv4
+ * @iwdev: iWarp device
+ * @cm_info: CM info for parent listen node
+ * @cm_parent_listen_node: The parent listen node
+ *
+ * Adds a qhash and a child listen node for every IPv4 address
+ * on the adapter and adds the associated qhash filter
+ */
+static enum irdma_status_code
+irdma_add_mqh_4(struct irdma_device *iwdev, struct irdma_cm_info *cm_info,
+		struct irdma_cm_listener *cm_parent_listen_node)
+{
+	struct net_device *dev;
+	struct in_device *idev;
+	struct irdma_cm_listener *child_listen_node;
+	enum irdma_status_code ret = 0;
+	unsigned long flags;
+	const struct in_ifaddr *ifa;
+
+	rtnl_lock();
+	for_each_netdev (&init_net, dev) {
+		if (!(dev->flags & IFF_UP))
+			continue;
+
+		if (((rdma_vlan_dev_vlan_id(dev) >= VLAN_N_VID) ||
+		     (rdma_vlan_dev_real_dev(dev) != iwdev->netdev)) &&
+		    dev != iwdev->netdev)
+			continue;
+
+		idev = in_dev_get(dev);
+		in_dev_for_each_ifa_rtnl(ifa, idev) {
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
+				  &ifa->ifa_address,
+				  rdma_vlan_dev_vlan_id(dev), dev->dev_addr);
+			child_listen_node = kzalloc(sizeof(*child_listen_node), GFP_KERNEL);
+			cm_parent_listen_node->cm_core->stats_listen_nodes_created++;
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: Allocating child listener %p\n",
+				  child_listen_node);
+			if (!child_listen_node) {
+				ibdev_dbg(to_ibdev(iwdev),
+					  "CM: listener memory allocation\n");
+				in_dev_put(idev);
+				ret = IRDMA_ERR_NO_MEMORY;
+				goto exit;
+			}
+
+			cm_info->vlan_id = rdma_vlan_dev_vlan_id(dev);
+			cm_parent_listen_node->vlan_id = cm_info->vlan_id;
+			memcpy(child_listen_node, cm_parent_listen_node,
+			       sizeof(*child_listen_node));
+			child_listen_node->loc_addr[0] =
+				ntohl(ifa->ifa_address);
+			memcpy(cm_info->loc_addr, child_listen_node->loc_addr,
+			       sizeof(cm_info->loc_addr));
+			ret = irdma_manage_qhash(iwdev, cm_info,
+						 IRDMA_QHASH_TYPE_TCP_SYN,
+						 IRDMA_QHASH_MANAGE_TYPE_ADD,
+						 NULL, true);
+			if (ret) {
+				kfree(child_listen_node);
+				cm_parent_listen_node->cm_core
+					->stats_listen_nodes_created--;
+				continue;
+			}
+
+			trace_irdma_add_mqh_4(iwdev, child_listen_node,
+					      dev->dev_addr);
+
+			child_listen_node->qhash_set = true;
+			spin_lock_irqsave(&iwdev->cm_core.listen_list_lock,
+					  flags);
+			list_add(&child_listen_node->child_listen_list,
+				 &cm_parent_listen_node->child_listen_list);
+			spin_unlock_irqrestore(&iwdev->cm_core.listen_list_lock, flags);
+		}
+		in_dev_put(idev);
+	}
+exit:
+	rtnl_unlock();
+
+	return ret;
+}
+
+/**
+ * irdma_dec_refcnt_listen - delete listener and associated cm nodes
+ * @cm_core: cm's core
+ * @listener: pointer to listener node
+ * @free_hanging_nodes: to free associated cm_nodes
+ * @apbvt_del: flag to delete the apbvt
+ */
+static int irdma_dec_refcnt_listen(struct irdma_cm_core *cm_core,
+				   struct irdma_cm_listener *listener,
+				   int free_hanging_nodes, bool apbvt_del)
+{
+	int err;
+	struct list_head *list_pos;
+	struct list_head *list_temp;
+	struct irdma_cm_node *cm_node;
+	struct list_head reset_list;
+	struct irdma_cm_info nfo;
+	enum irdma_cm_node_state old_state;
+	unsigned long flags;
+
+	trace_irdma_dec_refcnt_listen(listener, __builtin_return_address(0));
+	/* free non-accelerated child nodes for this listener */
+	INIT_LIST_HEAD(&reset_list);
+	if (free_hanging_nodes) {
+		spin_lock_irqsave(&cm_core->ht_lock, flags);
+		list_for_each_safe (list_pos, list_temp,
+				    &cm_core->non_accelerated_list) {
+			cm_node = container_of(list_pos, struct irdma_cm_node,
+					       list);
+			if (cm_node->listener == listener &&
+			    !cm_node->accelerated) {
+				refcount_inc(&cm_node->refcnt);
+				list_add(&cm_node->reset_entry, &reset_list);
+			}
+		}
+		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+	}
+
+	list_for_each_safe (list_pos, list_temp, &reset_list) {
+		cm_node = container_of(list_pos, struct irdma_cm_node,
+				       reset_entry);
+		if (cm_node->state >= IRDMA_CM_STATE_FIN_WAIT1) {
+			irdma_rem_ref_cm_node(cm_node);
+			continue;
+		}
+
+		irdma_cleanup_retrans_entry(cm_node);
+		err = irdma_send_reset(cm_node);
+		if (err) {
+			cm_node->state = IRDMA_CM_STATE_CLOSED;
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: send reset failed\n");
+		} else {
+			old_state = cm_node->state;
+			cm_node->state = IRDMA_CM_STATE_LISTENER_DESTROYED;
+			if (old_state != IRDMA_CM_STATE_MPAREQ_RCVD)
+				irdma_rem_ref_cm_node(cm_node);
+		}
+	}
+
+	if (refcount_dec_and_test(&listener->refcnt)) {
+		spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+		list_del(&listener->list);
+		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+
+		if (listener->iwdev) {
+			if (apbvt_del)
+				irdma_manage_apbvt(listener->iwdev,
+						   listener->loc_port,
+						   IRDMA_MANAGE_APBVT_DEL);
+			memcpy(nfo.loc_addr, listener->loc_addr,
+			       sizeof(nfo.loc_addr));
+			nfo.loc_port = listener->loc_port;
+			nfo.ipv4 = listener->ipv4;
+			nfo.vlan_id = listener->vlan_id;
+			nfo.user_pri = listener->user_pri;
+			nfo.qh_qpid = listener->iwdev->vsi.ilq->qp_id;
+
+			if (!list_empty(&listener->child_listen_list)) {
+				irdma_del_multiple_qhash(listener->iwdev, &nfo,
+							 listener);
+			} else {
+				if (listener->qhash_set)
+					irdma_manage_qhash(listener->iwdev,
+							   &nfo,
+							   IRDMA_QHASH_TYPE_TCP_SYN,
+							   IRDMA_QHASH_MANAGE_TYPE_DELETE,
+							   NULL, false);
+			}
+		}
+
+		cm_core->stats_listen_destroyed++;
+		kfree(listener);
+		cm_core->stats_listen_nodes_destroyed++;
+		listener = NULL;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * irdma_cm_del_listen - delete a listener
+ * @cm_core: cm's core
+ * @listener: passive connection's listener
+ * @apbvt_del: flag to delete apbvt
+ */
+static int irdma_cm_del_listen(struct irdma_cm_core *cm_core,
+			       struct irdma_cm_listener *listener,
+			       bool apbvt_del)
+{
+	listener->listener_state = IRDMA_CM_LISTENER_PASSIVE_STATE;
+	listener->cm_id = NULL;
+
+	return irdma_dec_refcnt_listen(cm_core, listener, 1, apbvt_del);
+}
+
+/**
+ * irdma_addr_resolve_neigh - resolve neighbor address
+ * @iwdev: iwarp device structure
+ * @src_ip: local ip address
+ * @dst_ip: remote ip address
+ * @arpindex: if there is an arp entry
+ */
+static int irdma_addr_resolve_neigh(struct irdma_device *iwdev, u32 src_ip,
+				    u32 dst_ip, int arpindex)
+{
+	struct rtable *rt;
+	struct neighbour *neigh;
+	int rc = arpindex;
+	__be32 dst_ipaddr = htonl(dst_ip);
+	__be32 src_ipaddr = htonl(src_ip);
+
+	rt = ip_route_output(&init_net, dst_ipaddr, src_ipaddr, 0, 0);
+	if (IS_ERR(rt)) {
+		ibdev_dbg(to_ibdev(iwdev), "CM: ip_route_output fail\n");
+		return -EINVAL;
+	}
+
+	neigh = dst_neigh_lookup(&rt->dst, &dst_ipaddr);
+	if (!neigh)
+		goto exit;
+
+	if (neigh->nud_state & NUD_VALID)
+		rc = irdma_add_arp(iwdev->rf, &dst_ip, true, neigh->ha);
+	else
+		neigh_event_send(neigh, NULL);
+exit:
+	if (neigh)
+		neigh_release(neigh);
+
+	ip_rt_put(rt);
+
+	return rc;
+}
+
+/**
+ * irdma_get_dst_ipv6 - get destination cache entry via ipv6 lookup
+ * @src_addr: local ipv6 sock address
+ * @dst_addr: destination ipv6 sock address
+ */
+static struct dst_entry *irdma_get_dst_ipv6(struct sockaddr_in6 *src_addr,
+					    struct sockaddr_in6 *dst_addr)
+{
+	struct dst_entry *dst = NULL;
+
+	if ((IS_ENABLED(CONFIG_IPV6))) {
+		struct flowi6 fl6 = {};
+
+		fl6.daddr = dst_addr->sin6_addr;
+		fl6.saddr = src_addr->sin6_addr;
+		if (ipv6_addr_type(&fl6.daddr) & IPV6_ADDR_LINKLOCAL)
+			fl6.flowi6_oif = dst_addr->sin6_scope_id;
+
+		dst = ip6_route_output(&init_net, NULL, &fl6);
+	}
+
+	return dst;
+}
+
+/**
+ * irdma_addr_resolve_neigh_ipv6 - resolve neighbor ipv6 address
+ * @iwdev: iwarp device structure
+ * @src: local ip address
+ * @dest: remote ip address
+ * @arpindex: if there is an arp entry
+ */
+static int irdma_addr_resolve_neigh_ipv6(struct irdma_device *iwdev, u32 *src,
+					 u32 *dest, int arpindex)
+{
+	struct neighbour *neigh;
+	int rc = arpindex;
+	struct dst_entry *dst;
+	struct sockaddr_in6 dst_addr = {};
+	struct sockaddr_in6 src_addr = {};
+
+	dst_addr.sin6_family = AF_INET6;
+	irdma_copy_ip_htonl(dst_addr.sin6_addr.in6_u.u6_addr32, dest);
+	src_addr.sin6_family = AF_INET6;
+	irdma_copy_ip_htonl(src_addr.sin6_addr.in6_u.u6_addr32, src);
+	dst = irdma_get_dst_ipv6(&src_addr, &dst_addr);
+	if (!dst || dst->error) {
+		if (dst) {
+			dst_release(dst);
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: ip6_route_output returned dst->error = %d\n",
+				  dst->error);
+		}
+		return -EINVAL;
+	}
+
+	neigh = dst_neigh_lookup(dst, dst_addr.sin6_addr.in6_u.u6_addr32);
+	if (!neigh)
+		goto exit;
+
+	ibdev_dbg(to_ibdev(iwdev), "CM: dst_neigh_lookup MAC=%pM\n",
+		  neigh->ha);
+
+	trace_irdma_addr_resolve(iwdev, neigh->ha);
+
+	if (neigh->nud_state & NUD_VALID)
+		rc = irdma_add_arp(iwdev->rf, dest, false, neigh->ha);
+	else
+		neigh_event_send(neigh, NULL);
+exit:
+	if (neigh)
+		neigh_release(neigh);
+	dst_release(dst);
+
+	return rc;
+}
+
+/**
+ * irdma_ipv4_is_lpb - check if loopback
+ * @loc_addr: local addr to compare
+ * @rem_addr: remote address
+ */
+bool irdma_ipv4_is_lpb(u32 loc_addr, u32 rem_addr)
+{
+	return ipv4_is_loopback(htonl(rem_addr)) || (loc_addr == rem_addr);
+}
+
+/**
+ * irdma_ipv6_is_loopback - check if loopback
+ * @loc_addr: local addr to compare
+ * @rem_addr: remote address
+ */
+bool irdma_ipv6_is_lpb(u32 *loc_addr, u32 *rem_addr)
+{
+	struct in6_addr raddr6;
+
+	irdma_copy_ip_htonl(raddr6.in6_u.u6_addr32, rem_addr);
+
+	return !memcmp(loc_addr, rem_addr, 16) || ipv6_addr_loopback(&raddr6);
+}
+
+/**
+ * irdma_cm_create_ah - create a cm address handle
+ * @cm_node: The connection manager node to create AH for
+ * @wait: Provides option to wait for ah creation or not
+ */
+static int irdma_cm_create_ah(struct irdma_cm_node *cm_node, bool wait)
+{
+	struct irdma_ah_info ah_info = {};
+	struct irdma_device *iwdev = cm_node->iwdev;
+
+	ether_addr_copy(ah_info.mac_addr, iwdev->netdev->dev_addr);
+
+	ah_info.hop_ttl = 0x40;
+	ah_info.tc_tos = cm_node->tos;
+	ah_info.vsi = &iwdev->vsi;
+
+	if (cm_node->ipv4) {
+		ah_info.ipv4_valid = true;
+		ah_info.dest_ip_addr[0] = cm_node->rem_addr[0];
+		ah_info.src_ip_addr[0] = cm_node->loc_addr[0];
+		ah_info.do_lpbk = irdma_ipv4_is_lpb(ah_info.src_ip_addr[0],
+						    ah_info.dest_ip_addr[0]);
+	} else {
+		memcpy(ah_info.dest_ip_addr, cm_node->rem_addr,
+		       sizeof(ah_info.dest_ip_addr));
+		memcpy(ah_info.src_ip_addr, cm_node->loc_addr,
+		       sizeof(ah_info.src_ip_addr));
+		ah_info.do_lpbk = irdma_ipv6_is_lpb(ah_info.src_ip_addr,
+						    ah_info.dest_ip_addr);
+	}
+
+	ah_info.vlan_tag = cm_node->vlan_id;
+	if (cm_node->vlan_id < VLAN_N_VID) {
+		ah_info.insert_vlan_tag = 1;
+		ah_info.vlan_tag |= cm_node->user_pri << VLAN_PRIO_SHIFT;
+	}
+
+	ah_info.dst_arpindex =
+		irdma_arp_table(iwdev->rf, ah_info.dest_ip_addr,
+				ah_info.ipv4_valid, NULL, IRDMA_ARP_RESOLVE);
+
+	if (irdma_puda_create_ah(&iwdev->rf->sc_dev, &ah_info, wait,
+				 IRDMA_PUDA_RSRC_TYPE_ILQ, cm_node,
+				 &cm_node->ah))
+		return -ENOMEM;
+
+	trace_irdma_create_ah(cm_node);
+	return 0;
+}
+
+/**
+ * irdma_cm_free_ah - free a cm address handle
+ * @cm_node: The connection manager node to create AH for
+ */
+static void irdma_cm_free_ah(struct irdma_cm_node *cm_node)
+{
+	struct irdma_device *iwdev = cm_node->iwdev;
+
+	trace_irdma_cm_free_ah(cm_node);
+	irdma_puda_free_ah(&iwdev->rf->sc_dev, cm_node->ah);
+	cm_node->ah = NULL;
+}
+
+/**
+ * irdma_make_cm_node - create a new instance of a cm node
+ * @cm_core: cm's core
+ * @iwdev: iwarp device structure
+ * @cm_info: quad info for connection
+ * @listener: passive connection's listener
+ */
+static struct irdma_cm_node *
+irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
+		   struct irdma_cm_info *cm_info,
+		   struct irdma_cm_listener *listener)
+{
+	struct irdma_cm_node *cm_node;
+	int oldarpindex;
+	int arpindex;
+	struct net_device *netdev = iwdev->netdev;
+
+	/* create an hte and cm_node for this instance */
+	cm_node = kzalloc(sizeof(*cm_node), GFP_ATOMIC);
+	if (!cm_node)
+		return NULL;
+
+	/* set our node specific transport info */
+	cm_node->ipv4 = cm_info->ipv4;
+	cm_node->vlan_id = cm_info->vlan_id;
+	if (cm_node->vlan_id >= VLAN_N_VID && iwdev->dcb)
+		cm_node->vlan_id = 0;
+	cm_node->tos = cm_info->tos;
+	cm_node->user_pri = cm_info->user_pri;
+	if (listener) {
+		if (listener->tos != cm_info->tos)
+			dev_warn(rfdev_to_dev(&iwdev->rf->sc_dev),
+				 "application TOS[%d] and remote client TOS[%d] mismatch\n",
+				 listener->tos, cm_info->tos);
+		cm_node->tos = max(listener->tos, cm_info->tos);
+		cm_node->user_pri = rt_tos2priority(cm_node->tos);
+		ibdev_dbg(to_ibdev(iwdev),
+			  "DCB: listener: TOS:[%d] UP:[%d]\n", cm_node->tos,
+			  cm_node->user_pri);
+		trace_irdma_listener_tos(iwdev, cm_node->tos,
+					 cm_node->user_pri);
+	}
+	memcpy(cm_node->loc_addr, cm_info->loc_addr, sizeof(cm_node->loc_addr));
+	memcpy(cm_node->rem_addr, cm_info->rem_addr, sizeof(cm_node->rem_addr));
+	cm_node->loc_port = cm_info->loc_port;
+	cm_node->rem_port = cm_info->rem_port;
+
+	cm_node->mpa_frame_rev = IRDMA_CM_DEFAULT_MPA_VER;
+	cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
+	cm_node->iwdev = iwdev;
+	cm_node->dev = &iwdev->rf->sc_dev;
+
+	cm_node->ird_size = cm_node->dev->hw_attrs.max_hw_ird;
+	cm_node->ord_size = cm_node->dev->hw_attrs.max_hw_ord;
+
+	cm_node->listener = listener;
+	cm_node->cm_id = cm_info->cm_id;
+	ether_addr_copy(cm_node->loc_mac, netdev->dev_addr);
+	spin_lock_init(&cm_node->retrans_list_lock);
+	cm_node->ack_rcvd = false;
+
+	refcount_set(&cm_node->refcnt, 1);
+	/* associate our parent CM core */
+	cm_node->cm_core = cm_core;
+	cm_node->tcp_cntxt.loc_id = IRDMA_CM_DEFAULT_LOCAL_ID;
+	cm_node->tcp_cntxt.rcv_wscale = iwdev->rcv_wscale;
+	cm_node->tcp_cntxt.rcv_wnd = iwdev->rcv_wnd >> cm_node->tcp_cntxt.rcv_wscale;
+	if (cm_node->ipv4) {
+		cm_node->tcp_cntxt.loc_seq_num = secure_tcp_seq(htonl(cm_node->loc_addr[0]),
+								htonl(cm_node->rem_addr[0]),
+								htons(cm_node->loc_port),
+								htons(cm_node->rem_port));
+		cm_node->tcp_cntxt.mss = iwdev->vsi.mtu - IRDMA_MTU_TO_MSS_IPV4;
+	} else if (IS_ENABLED(CONFIG_IPV6)) {
+		__be32 loc[4] = {
+			htonl(cm_node->loc_addr[0]), htonl(cm_node->loc_addr[1]),
+			htonl(cm_node->loc_addr[2]), htonl(cm_node->loc_addr[3])
+		};
+		__be32 rem[4] = {
+			htonl(cm_node->rem_addr[0]), htonl(cm_node->rem_addr[1]),
+			htonl(cm_node->rem_addr[2]), htonl(cm_node->rem_addr[3])
+		};
+		cm_node->tcp_cntxt.loc_seq_num = secure_tcpv6_seq(loc, rem,
+								  htons(cm_node->loc_port),
+								  htons(cm_node->rem_port));
+		cm_node->tcp_cntxt.mss = iwdev->vsi.mtu - IRDMA_MTU_TO_MSS_IPV6;
+	}
+
+	if ((cm_node->ipv4 &&
+	     irdma_ipv4_is_lpb(cm_node->loc_addr[0], cm_node->rem_addr[0])) ||
+	    (!cm_node->ipv4 &&
+	     irdma_ipv6_is_lpb(cm_node->loc_addr, cm_node->rem_addr))) {
+		cm_node->do_lpb = true;
+		arpindex = irdma_arp_table(iwdev->rf, cm_node->rem_addr,
+					   cm_node->ipv4, NULL,
+					   IRDMA_ARP_RESOLVE);
+	} else {
+		oldarpindex = irdma_arp_table(iwdev->rf, cm_node->rem_addr,
+					      cm_node->ipv4, NULL,
+					      IRDMA_ARP_RESOLVE);
+		if (cm_node->ipv4)
+			arpindex = irdma_addr_resolve_neigh(iwdev,
+							    cm_info->loc_addr[0],
+							    cm_info->rem_addr[0],
+							    oldarpindex);
+		else if (IS_ENABLED(CONFIG_IPV6))
+			arpindex = irdma_addr_resolve_neigh_ipv6(iwdev,
+								 cm_info->loc_addr,
+								 cm_info->rem_addr,
+								 oldarpindex);
+		else
+			arpindex = -EINVAL;
+	}
+
+	if (arpindex < 0)
+		goto err;
+
+	ether_addr_copy(cm_node->rem_mac,
+			iwdev->rf->arp_table[arpindex].mac_addr);
+	irdma_add_hte_node(cm_core, cm_node);
+	cm_core->stats_nodes_created++;
+	return cm_node;
+
+err:
+	kfree(cm_node);
+
+	return NULL;
+}
+
+/**
+ * irdma_rem_ref_cm_node - destroy an instance of a cm node
+ * @cm_node: connection's node
+ */
+static void irdma_rem_ref_cm_node(struct irdma_cm_node *cm_node)
+{
+	struct irdma_cm_core *cm_core = cm_node->cm_core;
+	struct irdma_qp *iwqp;
+	struct irdma_cm_info nfo;
+	unsigned long flags;
+
+	trace_irdma_rem_ref_cm_node(cm_node, 0, __builtin_return_address(0));
+	spin_lock_irqsave(&cm_node->cm_core->ht_lock, flags);
+	if (!refcount_dec_and_test(&cm_node->refcnt)) {
+		spin_unlock_irqrestore(&cm_node->cm_core->ht_lock, flags);
+		return;
+	}
+
+	list_del(&cm_node->list);
+	spin_unlock_irqrestore(&cm_node->cm_core->ht_lock, flags);
+
+	/* if the node is destroyed before connection was accelerated */
+	if (!cm_node->accelerated && cm_node->accept_pend) {
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: node destroyed before established\n");
+		atomic_dec(&cm_node->listener->pend_accepts_cnt);
+	}
+	if (cm_node->close_entry)
+		irdma_handle_close_entry(cm_node, 0);
+	if (cm_node->listener) {
+		irdma_dec_refcnt_listen(cm_core, cm_node->listener, 0, true);
+	} else {
+		if (cm_node->apbvt_set) {
+			irdma_manage_apbvt(cm_node->iwdev, cm_node->loc_port,
+					   IRDMA_MANAGE_APBVT_DEL);
+			cm_node->apbvt_set = 0;
+		}
+		irdma_get_addr_info(cm_node, &nfo);
+		if (cm_node->qhash_set) {
+			nfo.qh_qpid = cm_node->iwdev->vsi.ilq->qp_id;
+			irdma_manage_qhash(cm_node->iwdev, &nfo,
+					   IRDMA_QHASH_TYPE_TCP_ESTABLISHED,
+					   IRDMA_QHASH_MANAGE_TYPE_DELETE, NULL,
+					   false);
+			cm_node->qhash_set = 0;
+		}
+	}
+
+	iwqp = cm_node->iwqp;
+	if (iwqp) {
+		iwqp->cm_node = NULL;
+		irdma_rem_ref(&iwqp->ibqp);
+		cm_node->iwqp = NULL;
+	} else if (cm_node->qhash_set) {
+		irdma_get_addr_info(cm_node, &nfo);
+		nfo.qh_qpid = cm_node->iwdev->vsi.ilq->qp_id;
+		irdma_manage_qhash(cm_node->iwdev, &nfo,
+				   IRDMA_QHASH_TYPE_TCP_ESTABLISHED,
+				   IRDMA_QHASH_MANAGE_TYPE_DELETE, NULL, false);
+		cm_node->qhash_set = 0;
+	}
+	cm_core->cm_free_ah(cm_node);
+	cm_node->cm_core->stats_nodes_destroyed++;
+	kfree(cm_node);
+}
+
+/**
+ * irdma_handle_fin_pkt - FIN packet received
+ * @cm_node: connection's node
+ */
+static void irdma_handle_fin_pkt(struct irdma_cm_node *cm_node)
+{
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_RCVD:
+	case IRDMA_CM_STATE_SYN_SENT:
+	case IRDMA_CM_STATE_ESTABLISHED:
+	case IRDMA_CM_STATE_MPAREJ_RCVD:
+		cm_node->tcp_cntxt.rcv_nxt++;
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_LAST_ACK;
+		irdma_send_fin(cm_node);
+		break;
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		irdma_create_event(cm_node, IRDMA_CM_EVENT_ABORTED);
+		cm_node->tcp_cntxt.rcv_nxt++;
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT1:
+		cm_node->tcp_cntxt.rcv_nxt++;
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSING;
+		irdma_send_ack(cm_node);
+		/*
+		 * Wait for ACK as this is simultaneous close.
+		 * After we receive ACK, do not send anything.
+		 * Just rm the node.
+		 */
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT2:
+		cm_node->tcp_cntxt.rcv_nxt++;
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_TIME_WAIT;
+		irdma_send_ack(cm_node);
+		irdma_schedule_cm_timer(cm_node, NULL, IRDMA_TIMER_TYPE_CLOSE,
+					1, 0);
+		break;
+	case IRDMA_CM_STATE_TIME_WAIT:
+		cm_node->tcp_cntxt.rcv_nxt++;
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	case IRDMA_CM_STATE_OFFLOADED:
+	default:
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: bad state node state = %d\n", cm_node->state);
+		break;
+	}
+}
+
+/**
+ * irdma_handle_rst_pkt - process received RST packet
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static void irdma_handle_rst_pkt(struct irdma_cm_node *cm_node,
+				 struct irdma_puda_buf *rbuf)
+{
+	irdma_cleanup_retrans_entry(cm_node);
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_SENT:
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		switch (cm_node->mpa_frame_rev) {
+		case IETF_MPA_V2:
+			/* Drop down to MPA_V1*/
+			cm_node->mpa_frame_rev = IETF_MPA_V1;
+			/* send a syn and goto syn sent state */
+			cm_node->state = IRDMA_CM_STATE_SYN_SENT;
+			if (irdma_send_syn(cm_node, 0))
+				irdma_active_open_err(cm_node, false);
+			break;
+		case IETF_MPA_V1:
+		default:
+			irdma_active_open_err(cm_node, false);
+			break;
+		}
+		break;
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+		atomic_add_return(1, &cm_node->passive_state);
+		break;
+	case IRDMA_CM_STATE_ESTABLISHED:
+	case IRDMA_CM_STATE_SYN_RCVD:
+	case IRDMA_CM_STATE_LISTENING:
+		irdma_passive_open_err(cm_node, false);
+		break;
+	case IRDMA_CM_STATE_OFFLOADED:
+		irdma_active_open_err(cm_node, false);
+		break;
+	case IRDMA_CM_STATE_CLOSED:
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT2:
+	case IRDMA_CM_STATE_FIN_WAIT1:
+	case IRDMA_CM_STATE_LAST_ACK:
+		cm_node->cm_id->rem_ref(cm_node->cm_id);
+		/* fall through */
+	case IRDMA_CM_STATE_TIME_WAIT:
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * irdma_handle_rcv_mpa - Process a recv'd mpa buffer
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static void irdma_handle_rcv_mpa(struct irdma_cm_node *cm_node,
+				 struct irdma_puda_buf *rbuf)
+{
+	int err;
+	int datasize = rbuf->datalen;
+	u8 *dataloc = rbuf->data;
+
+	enum irdma_cm_event_type type = IRDMA_CM_EVENT_UNKNOWN;
+	u32 res_type;
+
+	err = irdma_parse_mpa(cm_node, dataloc, &res_type, datasize);
+	if (err) {
+		if (cm_node->state == IRDMA_CM_STATE_MPAREQ_SENT)
+			irdma_active_open_err(cm_node, true);
+		else
+			irdma_passive_open_err(cm_node, true);
+		return;
+	}
+
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_ESTABLISHED:
+		if (res_type == IRDMA_MPA_REQUEST_REJECT)
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: state for reject\n");
+		cm_node->state = IRDMA_CM_STATE_MPAREQ_RCVD;
+		type = IRDMA_CM_EVENT_MPA_REQ;
+		irdma_send_ack(cm_node); /* ACK received MPA request */
+		atomic_set(&cm_node->passive_state,
+			   IRDMA_PASSIVE_STATE_INDICATED);
+		break;
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		irdma_cleanup_retrans_entry(cm_node);
+		if (res_type == IRDMA_MPA_REQUEST_REJECT) {
+			type = IRDMA_CM_EVENT_MPA_REJECT;
+			cm_node->state = IRDMA_CM_STATE_MPAREJ_RCVD;
+		} else {
+			type = IRDMA_CM_EVENT_CONNECTED;
+			cm_node->state = IRDMA_CM_STATE_OFFLOADED;
+		}
+		irdma_send_ack(cm_node);
+		break;
+	default:
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: wrong cm_node state =%d\n", cm_node->state);
+		break;
+	}
+	irdma_create_event(cm_node, type);
+}
+
+/**
+ * irdma_check_syn - Check for error on received syn ack
+ * @cm_node: connection's node
+ * @tcph: pointer tcp header
+ */
+static int irdma_check_syn(struct irdma_cm_node *cm_node, struct tcphdr *tcph)
+{
+	if (ntohl(tcph->ack_seq) != cm_node->tcp_cntxt.loc_seq_num) {
+		irdma_active_open_err(cm_node, true);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_check_seq - check seq numbers if OK
+ * @cm_node: connection's node
+ * @tcph: pointer tcp header
+ */
+static int irdma_check_seq(struct irdma_cm_node *cm_node, struct tcphdr *tcph)
+{
+	u32 seq;
+	u32 ack_seq;
+	u32 loc_seq_num = cm_node->tcp_cntxt.loc_seq_num;
+	u32 rcv_nxt = cm_node->tcp_cntxt.rcv_nxt;
+	u32 rcv_wnd;
+	int err = 0;
+
+	seq = ntohl(tcph->seq);
+	ack_seq = ntohl(tcph->ack_seq);
+	rcv_wnd = cm_node->tcp_cntxt.rcv_wnd;
+	if (ack_seq != loc_seq_num ||
+	    !between(seq, rcv_nxt, (rcv_nxt + rcv_wnd)))
+		err = -1;
+	if (err)
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: seq number err\n");
+
+	return err;
+}
+
+/**
+ * irdma_handle_syn_pkt - is for Passive node
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static void irdma_handle_syn_pkt(struct irdma_cm_node *cm_node,
+				 struct irdma_puda_buf *rbuf)
+{
+	struct tcphdr *tcph = (struct tcphdr *)rbuf->tcph;
+	int err;
+	u32 inc_sequence;
+	int optionsize;
+	struct irdma_cm_info nfo;
+
+	optionsize = (tcph->doff << 2) - sizeof(struct tcphdr);
+	inc_sequence = ntohl(tcph->seq);
+
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_SENT:
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		/* Rcvd syn on active open connection */
+		irdma_active_open_err(cm_node, 1);
+		break;
+	case IRDMA_CM_STATE_LISTENING:
+		/* Passive OPEN */
+		if (atomic_read(&cm_node->listener->pend_accepts_cnt) >
+		    cm_node->listener->backlog) {
+			cm_node->cm_core->stats_backlog_drops++;
+			irdma_passive_open_err(cm_node, false);
+			break;
+		}
+		err = irdma_handle_tcp_options(cm_node, tcph, optionsize, 1);
+		if (err) {
+			irdma_passive_open_err(cm_node, false);
+			/* drop pkt */
+			break;
+		}
+		err = cm_node->cm_core->cm_create_ah(cm_node, false);
+		if (err) {
+			irdma_passive_open_err(cm_node, false);
+			/* drop pkt */
+			break;
+		}
+		cm_node->tcp_cntxt.rcv_nxt = inc_sequence + 1;
+		cm_node->accept_pend = 1;
+		atomic_inc(&cm_node->listener->pend_accepts_cnt);
+
+		cm_node->state = IRDMA_CM_STATE_SYN_RCVD;
+		irdma_get_addr_info(cm_node, &nfo);
+		nfo.qh_qpid = cm_node->iwdev->vsi.ilq->qp_id;
+		err = irdma_manage_qhash(cm_node->iwdev, &nfo,
+					 IRDMA_QHASH_TYPE_TCP_ESTABLISHED,
+					 IRDMA_QHASH_MANAGE_TYPE_ADD,
+					 cm_node, false);
+		cm_node->qhash_set = true;
+		break;
+	case IRDMA_CM_STATE_CLOSED:
+		irdma_cleanup_retrans_entry(cm_node);
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_OFFLOADED:
+	case IRDMA_CM_STATE_ESTABLISHED:
+	case IRDMA_CM_STATE_FIN_WAIT1:
+	case IRDMA_CM_STATE_FIN_WAIT2:
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+	case IRDMA_CM_STATE_LAST_ACK:
+	case IRDMA_CM_STATE_CLOSING:
+	case IRDMA_CM_STATE_UNKNOWN:
+	default:
+		break;
+	}
+}
+
+/**
+ * irdma_handle_synack_pkt - Process SYN+ACK packet (active side)
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static void irdma_handle_synack_pkt(struct irdma_cm_node *cm_node,
+				    struct irdma_puda_buf *rbuf)
+{
+	struct tcphdr *tcph = (struct tcphdr *)rbuf->tcph;
+	int err;
+	u32 inc_sequence;
+	int optionsize;
+
+	optionsize = (tcph->doff << 2) - sizeof(struct tcphdr);
+	inc_sequence = ntohl(tcph->seq);
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_SENT:
+		irdma_cleanup_retrans_entry(cm_node);
+		/* active open */
+		if (irdma_check_syn(cm_node, tcph)) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: check syn fail\n");
+			return;
+		}
+		cm_node->tcp_cntxt.rem_ack_num = ntohl(tcph->ack_seq);
+		/* setup options */
+		err = irdma_handle_tcp_options(cm_node, tcph, optionsize, 0);
+		if (err) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: cm_node=%p tcp_options failed\n",
+				  cm_node);
+			break;
+		}
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->tcp_cntxt.rcv_nxt = inc_sequence + 1;
+		irdma_send_ack(cm_node); /* ACK  for the syn_ack */
+		err = irdma_send_mpa_request(cm_node);
+		if (err) {
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: cm_node=%p irdma_send_mpa_request failed\n",
+				  cm_node);
+			break;
+		}
+		cm_node->state = IRDMA_CM_STATE_MPAREQ_SENT;
+		break;
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+		irdma_passive_open_err(cm_node, true);
+		break;
+	case IRDMA_CM_STATE_LISTENING:
+		cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_CLOSED:
+		cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
+		irdma_cleanup_retrans_entry(cm_node);
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_ESTABLISHED:
+	case IRDMA_CM_STATE_FIN_WAIT1:
+	case IRDMA_CM_STATE_FIN_WAIT2:
+	case IRDMA_CM_STATE_LAST_ACK:
+	case IRDMA_CM_STATE_OFFLOADED:
+	case IRDMA_CM_STATE_CLOSING:
+	case IRDMA_CM_STATE_UNKNOWN:
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+	default:
+		break;
+	}
+}
+
+/**
+ * irdma_handle_ack_pkt - process packet with ACK
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static int irdma_handle_ack_pkt(struct irdma_cm_node *cm_node,
+				struct irdma_puda_buf *rbuf)
+{
+	struct tcphdr *tcph = (struct tcphdr *)rbuf->tcph;
+	u32 inc_sequence;
+	int ret;
+	int optionsize;
+	u32 datasize = rbuf->datalen;
+
+	optionsize = (tcph->doff << 2) - sizeof(struct tcphdr);
+
+	if (irdma_check_seq(cm_node, tcph))
+		return -EINVAL;
+
+	inc_sequence = ntohl(tcph->seq);
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_RCVD:
+		irdma_cleanup_retrans_entry(cm_node);
+		ret = irdma_handle_tcp_options(cm_node, tcph, optionsize, 1);
+		if (ret)
+			return ret;
+		cm_node->tcp_cntxt.rem_ack_num = ntohl(tcph->ack_seq);
+		cm_node->state = IRDMA_CM_STATE_ESTABLISHED;
+		if (datasize) {
+			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
+			irdma_handle_rcv_mpa(cm_node, rbuf);
+		}
+		break;
+	case IRDMA_CM_STATE_ESTABLISHED:
+		irdma_cleanup_retrans_entry(cm_node);
+		if (datasize) {
+			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
+			irdma_handle_rcv_mpa(cm_node, rbuf);
+		}
+		break;
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		cm_node->tcp_cntxt.rem_ack_num = ntohl(tcph->ack_seq);
+		if (datasize) {
+			cm_node->tcp_cntxt.rcv_nxt = inc_sequence + datasize;
+			cm_node->ack_rcvd = false;
+			irdma_handle_rcv_mpa(cm_node, rbuf);
+		} else {
+			cm_node->ack_rcvd = true;
+		}
+		break;
+	case IRDMA_CM_STATE_LISTENING:
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_CLOSED:
+		irdma_cleanup_retrans_entry(cm_node);
+		refcount_inc(&cm_node->refcnt);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_LAST_ACK:
+	case IRDMA_CM_STATE_CLOSING:
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		if (!cm_node->accept_pend)
+			cm_node->cm_id->rem_ref(cm_node->cm_id);
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT1:
+		irdma_cleanup_retrans_entry(cm_node);
+		cm_node->state = IRDMA_CM_STATE_FIN_WAIT2;
+		break;
+	case IRDMA_CM_STATE_SYN_SENT:
+	case IRDMA_CM_STATE_FIN_WAIT2:
+	case IRDMA_CM_STATE_OFFLOADED:
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+	case IRDMA_CM_STATE_UNKNOWN:
+	default:
+		irdma_cleanup_retrans_entry(cm_node);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_process_packet - process cm packet
+ * @cm_node: connection's node
+ * @rbuf: receive buffer
+ */
+static void irdma_process_pkt(struct irdma_cm_node *cm_node,
+			      struct irdma_puda_buf *rbuf)
+{
+	enum irdma_tcpip_pkt_type pkt_type = IRDMA_PKT_TYPE_UNKNOWN;
+	struct tcphdr *tcph = (struct tcphdr *)rbuf->tcph;
+	u32 fin_set = 0;
+	int err;
+
+	if (tcph->rst) {
+		pkt_type = IRDMA_PKT_TYPE_RST;
+	} else if (tcph->syn) {
+		pkt_type = IRDMA_PKT_TYPE_SYN;
+		if (tcph->ack)
+			pkt_type = IRDMA_PKT_TYPE_SYNACK;
+	} else if (tcph->ack) {
+		pkt_type = IRDMA_PKT_TYPE_ACK;
+	}
+	if (tcph->fin)
+		fin_set = 1;
+
+	switch (pkt_type) {
+	case IRDMA_PKT_TYPE_SYN:
+		irdma_handle_syn_pkt(cm_node, rbuf);
+		break;
+	case IRDMA_PKT_TYPE_SYNACK:
+		irdma_handle_synack_pkt(cm_node, rbuf);
+		break;
+	case IRDMA_PKT_TYPE_ACK:
+		err = irdma_handle_ack_pkt(cm_node, rbuf);
+		if (fin_set && !err)
+			irdma_handle_fin_pkt(cm_node);
+		break;
+	case IRDMA_PKT_TYPE_RST:
+		irdma_handle_rst_pkt(cm_node, rbuf);
+		break;
+	default:
+		if (fin_set &&
+		    (!irdma_check_seq(cm_node, (struct tcphdr *)rbuf->tcph)))
+			irdma_handle_fin_pkt(cm_node);
+		break;
+	}
+}
+
+/**
+ * irdma_make_listen_node - create a listen node with params
+ * @cm_core: cm's core
+ * @iwdev: iwarp device structure
+ * @cm_info: quad info for connection
+ */
+static struct irdma_cm_listener *
+irdma_make_listen_node(struct irdma_cm_core *cm_core,
+		       struct irdma_device *iwdev,
+		       struct irdma_cm_info *cm_info)
+{
+	struct irdma_cm_listener *listener;
+	unsigned long flags;
+
+	/* cannot have multiple matching listeners */
+	listener = irdma_find_listener(cm_core, cm_info->loc_addr,
+				       cm_info->loc_port, cm_info->vlan_id,
+				       IRDMA_CM_LISTENER_EITHER_STATE);
+	if (listener &&
+	    listener->listener_state == IRDMA_CM_LISTENER_ACTIVE_STATE) {
+		refcount_dec(&listener->refcnt);
+		return NULL;
+	}
+
+	if (!listener) {
+		/* create a CM listen node
+		 * 1/2 node to compare incoming traffic to
+		 */
+		listener = kzalloc(sizeof(*listener), GFP_KERNEL);
+		if (!listener)
+			return NULL;
+		cm_core->stats_listen_nodes_created++;
+		memcpy(listener->loc_addr, cm_info->loc_addr,
+		       sizeof(listener->loc_addr));
+		listener->loc_port = cm_info->loc_port;
+
+		INIT_LIST_HEAD(&listener->child_listen_list);
+
+		refcount_set(&listener->refcnt, 1);
+	} else {
+		listener->reused_node = 1;
+	}
+
+	listener->cm_id = cm_info->cm_id;
+	listener->ipv4 = cm_info->ipv4;
+	listener->vlan_id = cm_info->vlan_id;
+	atomic_set(&listener->pend_accepts_cnt, 0);
+	listener->cm_core = cm_core;
+	listener->iwdev = iwdev;
+
+	listener->backlog = cm_info->backlog;
+	listener->listener_state = IRDMA_CM_LISTENER_ACTIVE_STATE;
+
+	if (!listener->reused_node) {
+		spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+		list_add(&listener->list, &cm_core->listen_nodes);
+		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+	}
+
+	return listener;
+}
+
+/**
+ * irdma_create_cm_node - make a connection node with params
+ * @cm_core: cm's core
+ * @iwdev: iwarp device structure
+ * @conn_param: connection parameters
+ * @cm_info: quad info for connection
+ * @caller_cm_node: pointer to cm_node structure to return
+ */
+static int irdma_create_cm_node(struct irdma_cm_core *cm_core,
+				struct irdma_device *iwdev,
+				struct iw_cm_conn_param *conn_param,
+				struct irdma_cm_info *cm_info,
+				struct irdma_cm_node **caller_cm_node)
+{
+	struct irdma_cm_node *cm_node;
+	u16 private_data_len = conn_param->private_data_len;
+	const void *private_data = conn_param->private_data;
+
+	/* create a CM connection node */
+	cm_node = irdma_make_cm_node(cm_core, iwdev, cm_info, NULL);
+	if (!cm_node)
+		return -ENOMEM;
+
+	/* set our node side to client (active) side */
+	cm_node->tcp_cntxt.client = 1;
+	cm_node->tcp_cntxt.rcv_wscale = IRDMA_CM_DEFAULT_RCV_WND_SCALE;
+
+	irdma_record_ird_ord(cm_node, conn_param->ird, conn_param->ord);
+
+	cm_node->pdata.size = private_data_len;
+	cm_node->pdata.addr = cm_node->pdata_buf;
+
+	memcpy(cm_node->pdata_buf, private_data, private_data_len);
+	*caller_cm_node = cm_node;
+
+	return 0;
+}
+
+/**
+ * irdma_cm_reject - reject and teardown a connection
+ * @cm_node: connection's node
+ * @pdata: ptr to private data for reject
+ * @plen: size of private data
+ */
+static int irdma_cm_reject(struct irdma_cm_node *cm_node, const void *pdata,
+			   u8 plen)
+{
+	int ret;
+	int passive_state;
+	struct iw_cm_id *cm_id = cm_node->cm_id;
+
+	if (cm_node->tcp_cntxt.client)
+		return 0;
+
+	irdma_cleanup_retrans_entry(cm_node);
+
+	passive_state = atomic_add_return(1, &cm_node->passive_state);
+	if (passive_state == IRDMA_SEND_RESET_EVENT) {
+		cm_node->state = IRDMA_CM_STATE_CLOSED;
+		irdma_rem_ref_cm_node(cm_node);
+		return 0;
+	}
+
+	if (cm_node->state == IRDMA_CM_STATE_LISTENER_DESTROYED) {
+		irdma_rem_ref_cm_node(cm_node);
+		return 0;
+	}
+
+	ret = irdma_send_mpa_reject(cm_node, pdata, plen);
+	if (!ret) {
+		cm_id->add_ref(cm_id);
+		return 0;
+	}
+
+	cm_node->state = IRDMA_CM_STATE_CLOSED;
+	if (irdma_send_reset(cm_node))
+		ibdev_dbg(to_ibdev(cm_node->iwdev), "CM: send reset failed\n");
+	return ret;
+}
+
+/**
+ * irdma_cm_close - close of cm connection
+ * @cm_node: connection's node
+ */
+static int irdma_cm_close(struct irdma_cm_node *cm_node)
+{
+	if (!cm_node)
+		return -EINVAL;
+
+	switch (cm_node->state) {
+	case IRDMA_CM_STATE_SYN_RCVD:
+	case IRDMA_CM_STATE_SYN_SENT:
+	case IRDMA_CM_STATE_ONE_SIDE_ESTABLISHED:
+	case IRDMA_CM_STATE_ESTABLISHED:
+	case IRDMA_CM_STATE_ACCEPTING:
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+		irdma_cleanup_retrans_entry(cm_node);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_CLOSE_WAIT:
+		cm_node->state = IRDMA_CM_STATE_LAST_ACK;
+		irdma_send_fin(cm_node);
+		break;
+	case IRDMA_CM_STATE_FIN_WAIT1:
+	case IRDMA_CM_STATE_FIN_WAIT2:
+	case IRDMA_CM_STATE_LAST_ACK:
+	case IRDMA_CM_STATE_TIME_WAIT:
+	case IRDMA_CM_STATE_CLOSING:
+		return -1;
+	case IRDMA_CM_STATE_LISTENING:
+		irdma_cleanup_retrans_entry(cm_node);
+		irdma_send_reset(cm_node);
+		break;
+	case IRDMA_CM_STATE_MPAREJ_RCVD:
+	case IRDMA_CM_STATE_UNKNOWN:
+	case IRDMA_CM_STATE_INITED:
+	case IRDMA_CM_STATE_CLOSED:
+	case IRDMA_CM_STATE_LISTENER_DESTROYED:
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	case IRDMA_CM_STATE_OFFLOADED:
+		if (cm_node->send_entry)
+			ibdev_dbg(to_ibdev(cm_node->iwdev),
+				  "CM: CM send_entry in OFFLOADED state\n");
+		irdma_rem_ref_cm_node(cm_node);
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_receive_ilq - recv an ETHERNET packet, and process it
+ * through CM
+ * @vsi: VSI structure of dev
+ * @rbuf: receive buffer
+ */
+void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf)
+{
+	struct irdma_cm_node *cm_node;
+	struct irdma_cm_listener *listener;
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcph;
+	struct irdma_cm_info cm_info = {};
+	struct irdma_device *iwdev = vsi->back_vsi;
+	struct irdma_cm_core *cm_core = &iwdev->cm_core;
+	struct vlan_ethhdr *ethh;
+	u16 vtag;
+
+	/* if vlan, then maclen = 18 else 14 */
+	iph = (struct iphdr *)rbuf->iph;
+	irdma_debug_buf(vsi->dev, IRDMA_DEBUG_ILQ, "RECEIVE ILQ BUFFER",
+			rbuf->mem.va, rbuf->totallen);
+	if (iwdev->rf->sc_dev.hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1) {
+		if (rbuf->vlan_valid) {
+			vtag = rbuf->vlan_id;
+			cm_info.user_pri = (vtag & VLAN_PRIO_MASK) >>
+					   VLAN_PRIO_SHIFT;
+			cm_info.vlan_id = vtag & VLAN_VID_MASK;
+		} else {
+			cm_info.vlan_id = 0xFFFF;
+		}
+	} else {
+		ethh = rbuf->mem.va;
+
+		if (ethh->h_vlan_proto == htons(ETH_P_8021Q)) {
+			vtag = ntohs(ethh->h_vlan_TCI);
+			cm_info.user_pri = (vtag & VLAN_PRIO_MASK) >>
+					   VLAN_PRIO_SHIFT;
+			cm_info.vlan_id = vtag & VLAN_VID_MASK;
+			ibdev_dbg(to_ibdev(cm_core->iwdev),
+				  "CM: vlan_id=%d\n", cm_info.vlan_id);
+		} else {
+			cm_info.vlan_id = 0xFFFF;
+		}
+	}
+	tcph = (struct tcphdr *)rbuf->tcph;
+
+	if (rbuf->ipv4) {
+		cm_info.loc_addr[0] = ntohl(iph->daddr);
+		cm_info.rem_addr[0] = ntohl(iph->saddr);
+		cm_info.ipv4 = true;
+		cm_info.tos = iph->tos;
+	} else {
+		ip6h = (struct ipv6hdr *)rbuf->iph;
+		irdma_copy_ip_ntohl(cm_info.loc_addr,
+				    ip6h->daddr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(cm_info.rem_addr,
+				    ip6h->saddr.in6_u.u6_addr32);
+		cm_info.ipv4 = false;
+		cm_info.tos = (ip6h->priority << 4) | (ip6h->flow_lbl[0] >> 4);
+	}
+	cm_info.loc_port = ntohs(tcph->dest);
+	cm_info.rem_port = ntohs(tcph->source);
+	cm_node = irdma_find_node(cm_core, cm_info.rem_port, cm_info.rem_addr,
+				  cm_info.loc_port, cm_info.loc_addr, true,
+				  false);
+
+	if (!cm_node) {
+		/* Only type of packet accepted are for the
+		 * PASSIVE open (syn only)
+		 */
+		if (!tcph->syn || tcph->ack)
+			return;
+
+		listener = irdma_find_listener(cm_core,
+					       cm_info.loc_addr,
+					       cm_info.loc_port,
+					       cm_info.vlan_id,
+					       IRDMA_CM_LISTENER_ACTIVE_STATE);
+		if (!listener) {
+			cm_info.cm_id = NULL;
+			ibdev_dbg(to_ibdev(cm_core->iwdev),
+				  "CM: no listener found\n");
+			return;
+		}
+
+		cm_info.cm_id = listener->cm_id;
+		cm_node = irdma_make_cm_node(cm_core, iwdev, &cm_info,
+					     listener);
+		if (!cm_node) {
+			ibdev_dbg(to_ibdev(cm_core->iwdev),
+				  "CM: allocate node failed\n");
+			refcount_dec(&listener->refcnt);
+			return;
+		}
+
+		if (!tcph->rst && !tcph->fin) {
+			cm_node->state = IRDMA_CM_STATE_LISTENING;
+		} else {
+			irdma_rem_ref_cm_node(cm_node);
+			return;
+		}
+
+		refcount_inc(&cm_node->refcnt);
+	} else if (cm_node->state == IRDMA_CM_STATE_OFFLOADED) {
+		irdma_rem_ref_cm_node(cm_node);
+		return;
+	}
+
+	irdma_process_pkt(cm_node, rbuf);
+	irdma_rem_ref_cm_node(cm_node);
+}
+
+static int irdma_cm_create_ah_nop(struct irdma_cm_node *cm_node, bool wait)
+{
+	return 0;
+}
+
+static void irdma_cm_free_ah_nop(struct irdma_cm_node *cm_node)
+{
+}
+
+/**
+ * irdma_setup_cm_core - setup top level instance of a cm core
+ * @iwdev: iwarp device structure
+ * @rdma_ver: HW version
+ */
+enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev,
+					   u8 rdma_ver)
+{
+	struct irdma_cm_core *cm_core = &iwdev->cm_core;
+
+	cm_core->iwdev = iwdev;
+	cm_core->dev = &iwdev->rf->sc_dev;
+
+	/* Handles CM event work items send to Iwarp core */
+	cm_core->event_wq = alloc_ordered_workqueue("iwarp-event-wq", 0);
+	if (!cm_core->event_wq)
+		return IRDMA_ERR_NO_MEMORY;
+
+	INIT_LIST_HEAD(&cm_core->accelerated_list);
+	INIT_LIST_HEAD(&cm_core->non_accelerated_list);
+	INIT_LIST_HEAD(&cm_core->listen_nodes);
+
+	timer_setup(&cm_core->tcp_timer, irdma_cm_timer_tick, 0);
+
+	spin_lock_init(&cm_core->ht_lock);
+	spin_lock_init(&cm_core->listen_list_lock);
+	spin_lock_init(&cm_core->apbvt_lock);
+
+	switch (rdma_ver) {
+	case IRDMA_GEN_1:
+		cm_core->form_cm_frame = irdma_form_uda_cm_frame;
+		cm_core->cm_create_ah = irdma_cm_create_ah_nop;
+		cm_core->cm_free_ah = irdma_cm_free_ah_nop;
+		break;
+	case IRDMA_GEN_2:
+	default:
+		cm_core->form_cm_frame = irdma_form_ah_cm_frame;
+		cm_core->cm_create_ah = irdma_cm_create_ah;
+		cm_core->cm_free_ah = irdma_cm_free_ah;
+	}
+
+	return 0;
+}
+
+/**
+ * irdma_cleanup_cm_core - deallocate a top level instance of a
+ * cm core
+ * @cm_core: cm's core
+ */
+void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core)
+{
+	unsigned long flags;
+
+	if (!cm_core)
+		return;
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	if (timer_pending(&cm_core->tcp_timer))
+		del_timer_sync(&cm_core->tcp_timer);
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	destroy_workqueue(cm_core->event_wq);
+	cm_core->dev->ws_reset(&cm_core->iwdev->vsi);
+}
+
+/**
+ * irdma_init_tcp_ctx - setup qp context
+ * @cm_node: connection's node
+ * @tcp_info: offload info for tcp
+ * @iwqp: associate qp for the connection
+ */
+static void irdma_init_tcp_ctx(struct irdma_cm_node *cm_node,
+			       struct irdma_tcp_offload_info *tcp_info,
+			       struct irdma_qp *iwqp)
+{
+	tcp_info->ipv4 = cm_node->ipv4;
+	tcp_info->drop_ooo_seg = !iwqp->iwdev->rf->ooo;
+	tcp_info->wscale = true;
+	tcp_info->ignore_tcp_opt = true;
+	tcp_info->ignore_tcp_uns_opt = true;
+	tcp_info->no_nagle = false;
+
+	tcp_info->ttl = IRDMA_DEFAULT_TTL;
+	tcp_info->rtt_var = IRDMA_DEFAULT_RTT_VAR;
+	tcp_info->ss_thresh = IRDMA_DEFAULT_SS_THRESH;
+	tcp_info->rexmit_thresh = IRDMA_DEFAULT_REXMIT_THRESH;
+
+	tcp_info->tcp_state = IRDMA_TCP_STATE_ESTABLISHED;
+	tcp_info->snd_wscale = cm_node->tcp_cntxt.snd_wscale;
+	tcp_info->rcv_wscale = cm_node->tcp_cntxt.rcv_wscale;
+
+	tcp_info->snd_nxt = cm_node->tcp_cntxt.loc_seq_num;
+	tcp_info->snd_wnd = cm_node->tcp_cntxt.snd_wnd;
+	tcp_info->rcv_nxt = cm_node->tcp_cntxt.rcv_nxt;
+	tcp_info->snd_max = cm_node->tcp_cntxt.loc_seq_num;
+
+	tcp_info->snd_una = cm_node->tcp_cntxt.loc_seq_num;
+	tcp_info->cwnd = 2 * cm_node->tcp_cntxt.mss;
+	tcp_info->snd_wl1 = cm_node->tcp_cntxt.rcv_nxt;
+	tcp_info->snd_wl2 = cm_node->tcp_cntxt.loc_seq_num;
+	tcp_info->max_snd_window = cm_node->tcp_cntxt.max_snd_wnd;
+	tcp_info->rcv_wnd = cm_node->tcp_cntxt.rcv_wnd
+			    << cm_node->tcp_cntxt.rcv_wscale;
+
+	tcp_info->flow_label = 0;
+	tcp_info->snd_mss = (u32)cm_node->tcp_cntxt.mss;
+	if (cm_node->vlan_id < VLAN_N_VID) {
+		tcp_info->insert_vlan_tag = true;
+		tcp_info->vlan_tag = cm_node->vlan_id;
+		tcp_info->vlan_tag |= cm_node->user_pri << VLAN_PRIO_SHIFT;
+		tcp_info->tos = cm_node->tos;
+	}
+	if (cm_node->ipv4) {
+		tcp_info->src_port = cm_node->loc_port;
+		tcp_info->dst_port = cm_node->rem_port;
+
+		tcp_info->dest_ip_addr3 = cm_node->rem_addr[0];
+		tcp_info->local_ipaddr3 = cm_node->loc_addr[0];
+		tcp_info->arp_idx = (u16)irdma_arp_table(iwqp->iwdev->rf,
+							 &tcp_info->dest_ip_addr3,
+							 true, NULL,
+							 IRDMA_ARP_RESOLVE);
+	} else {
+		tcp_info->src_port = cm_node->loc_port;
+		tcp_info->dst_port = cm_node->rem_port;
+		tcp_info->dest_ip_addr0 = cm_node->rem_addr[0];
+		tcp_info->dest_ip_addr1 = cm_node->rem_addr[1];
+		tcp_info->dest_ip_addr2 = cm_node->rem_addr[2];
+		tcp_info->dest_ip_addr3 = cm_node->rem_addr[3];
+		tcp_info->local_ipaddr0 = cm_node->loc_addr[0];
+		tcp_info->local_ipaddr1 = cm_node->loc_addr[1];
+		tcp_info->local_ipaddr2 = cm_node->loc_addr[2];
+		tcp_info->local_ipaddr3 = cm_node->loc_addr[3];
+		tcp_info->arp_idx = (u16)irdma_arp_table(iwqp->iwdev->rf,
+							 &tcp_info->dest_ip_addr0,
+							 false, NULL,
+							 IRDMA_ARP_RESOLVE);
+	}
+}
+
+/**
+ * irdma_cm_init_tsa_conn - setup qp for RTS
+ * @iwqp: associate qp for the connection
+ * @cm_node: connection's node
+ */
+static void irdma_cm_init_tsa_conn(struct irdma_qp *iwqp,
+				   struct irdma_cm_node *cm_node)
+{
+	struct irdma_iwarp_offload_info *iwarp_info;
+	struct irdma_qp_host_ctx_info *ctx_info;
+	struct irdma_sc_dev *dev = &iwqp->iwdev->rf->sc_dev;
+
+	iwarp_info = &iwqp->iwarp_info;
+	ctx_info = &iwqp->ctx_info;
+
+	ctx_info->tcp_info = &iwqp->tcp_info;
+	ctx_info->send_cq_num = iwqp->iwscq->sc_cq.cq_uk.cq_id;
+	ctx_info->rcv_cq_num = iwqp->iwrcq->sc_cq.cq_uk.cq_id;
+
+	iwarp_info->ord_size = cm_node->ord_size;
+	iwarp_info->ird_size = irdma_derive_hw_ird_setting(cm_node->ird_size);
+	iwarp_info->rd_en = true;
+	iwarp_info->rdmap_ver = 1;
+	iwarp_info->ddp_ver = 1;
+	iwarp_info->pd_id = iwqp->iwpd->sc_pd.pd_id;
+
+	ctx_info->tcp_info_valid = true;
+	ctx_info->iwarp_info_valid = true;
+	ctx_info->user_pri = cm_node->user_pri;
+
+	irdma_init_tcp_ctx(cm_node, &iwqp->tcp_info, iwqp);
+	if (cm_node->snd_mark_en) {
+		iwarp_info->snd_mark_en = true;
+		iwarp_info->snd_mark_offset = (iwqp->tcp_info.snd_nxt & SNDMARKER_SEQNMASK) +
+					      cm_node->lsmm_size;
+	}
+
+	cm_node->state = IRDMA_CM_STATE_OFFLOADED;
+	iwqp->tcp_info.tcp_state = IRDMA_TCP_STATE_ESTABLISHED;
+	iwqp->tcp_info.src_mac_addr_idx = iwqp->iwdev->mac_ip_table_idx;
+
+	dev->iw_priv_qp_ops->qp_setctx(&iwqp->sc_qp, iwqp->host_ctx.va,
+				       ctx_info);
+
+	/* once tcp_info is set, no need to do it again */
+	ctx_info->tcp_info_valid = false;
+	ctx_info->iwarp_info_valid = false;
+}
+
+/**
+ * irdma_cm_disconn - when a connection is being closed
+ * @iwqp: associated qp for the connection
+ */
+void irdma_cm_disconn(struct irdma_qp *iwqp)
+{
+	struct disconn_work *work;
+	struct irdma_device *iwdev = iwqp->iwdev;
+	unsigned long flags;
+
+	work = kzalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return;
+
+	spin_lock_irqsave(&iwdev->rf->qptable_lock, flags);
+	if (!iwdev->rf->qp_table[iwqp->ibqp.qp_num]) {
+		spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+		ibdev_dbg(to_ibdev(iwdev), "CM: qp_id %d is already freed\n",
+			  iwqp->ibqp.qp_num);
+		kfree(work);
+		return;
+	}
+	irdma_add_ref(&iwqp->ibqp);
+	spin_unlock_irqrestore(&iwdev->rf->qptable_lock, flags);
+
+	work->iwqp = iwqp;
+	INIT_WORK(&work->work, irdma_disconnect_worker);
+	queue_work(iwdev->cleanup_wq, &work->work);
+}
+
+/**
+ * irdma_qp_disconnect - free qp and close cm
+ * @iwqp: associate qp for the connection
+ */
+static void irdma_qp_disconnect(struct irdma_qp *iwqp)
+{
+	struct irdma_device *iwdev = iwqp->iwdev;
+
+	iwqp->active_conn = 0;
+	/* close the CM node down if it is still active */
+	if (iwqp->cm_node) {
+		ibdev_dbg(to_ibdev(iwdev), "CM: Call close API\n");
+		irdma_cm_close(iwqp->cm_node);
+	}
+}
+
+/**
+ * irdma_cm_disconn_true - called by worker thread to disconnect qp
+ * @iwqp: associate qp for the connection
+ */
+static void irdma_cm_disconn_true(struct irdma_qp *iwqp)
+{
+	struct iw_cm_id *cm_id;
+	struct irdma_device *iwdev;
+	struct irdma_sc_qp *qp = &iwqp->sc_qp;
+	u16 last_ae;
+	u8 original_hw_tcp_state;
+	u8 original_ibqp_state;
+	int disconn_status = 0;
+	int issue_disconn = 0;
+	int issue_close = 0;
+	int issue_flush = 0;
+	struct ib_event ibevent;
+	unsigned long flags;
+	int err;
+
+	iwdev = iwqp->iwdev;
+	spin_lock_irqsave(&iwqp->lock, flags);
+	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
+		struct ib_qp_attr attr;
+
+		if (iwqp->flush_issued || iwqp->destroyed) {
+			spin_unlock_irqrestore(&iwqp->lock, flags);
+			return;
+		}
+
+		spin_unlock_irqrestore(&iwqp->lock, flags);
+
+		attr.qp_state = IB_QPS_ERR;
+		irdma_modify_qp_roce(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+		if (iwqp->ibqp.event_handler) {
+			ibevent.device = iwqp->ibqp.device;
+			ibevent.event = IB_EVENT_QP_FATAL;
+			ibevent.element.qp = &iwqp->ibqp;
+			iwqp->ibqp.event_handler(&ibevent,
+						 iwqp->ibqp.qp_context);
+		}
+		return;
+	}
+
+	cm_id = iwqp->cm_id;
+	/* make sure we havent already closed this connection */
+	if (!cm_id) {
+		spin_unlock_irqrestore(&iwqp->lock, flags);
+		return;
+	}
+
+	original_hw_tcp_state = iwqp->hw_tcp_state;
+	original_ibqp_state = iwqp->ibqp_state;
+	last_ae = iwqp->last_aeq;
+
+	if (qp->term_flags) {
+		issue_disconn = 1;
+		issue_close = 1;
+		iwqp->cm_id = NULL;
+		irdma_terminate_del_timer(qp);
+		if (!iwqp->flush_issued) {
+			iwqp->flush_issued = 1;
+			issue_flush = 1;
+		}
+	} else if ((original_hw_tcp_state == IRDMA_TCP_STATE_CLOSE_WAIT) ||
+		   ((original_ibqp_state == IB_QPS_RTS) &&
+		    (last_ae == IRDMA_AE_LLP_CONNECTION_RESET))) {
+		issue_disconn = 1;
+		if (last_ae == IRDMA_AE_LLP_CONNECTION_RESET)
+			disconn_status = -ECONNRESET;
+	}
+
+	if ((original_hw_tcp_state == IRDMA_TCP_STATE_CLOSED ||
+	     original_hw_tcp_state == IRDMA_TCP_STATE_TIME_WAIT ||
+	     last_ae == IRDMA_AE_RDMAP_ROE_BAD_LLP_CLOSE ||
+	     last_ae == IRDMA_AE_BAD_CLOSE ||
+	     last_ae == IRDMA_AE_LLP_CONNECTION_RESET || iwdev->reset)) {
+		issue_close = 1;
+		iwqp->cm_id = NULL;
+		qp->term_flags = 0;
+		if (!iwqp->flush_issued) {
+			iwqp->flush_issued = 1;
+			issue_flush = 1;
+		}
+	}
+
+	spin_unlock_irqrestore(&iwqp->lock, flags);
+	if (issue_flush && !iwqp->destroyed) {
+		irdma_flush_wqes(iwqp, IRDMA_FLUSH_SQ | IRDMA_FLUSH_RQ |
+				 IRDMA_FLUSH_WAIT);
+
+		if (qp->term_flags && iwqp->ibqp.event_handler) {
+			ibevent.device = iwqp->ibqp.device;
+			ibevent.event = (qp->eventtype == TERM_EVENT_QP_FATAL) ?
+						IB_EVENT_QP_FATAL :
+						IB_EVENT_QP_ACCESS_ERR;
+			ibevent.element.qp = &iwqp->ibqp;
+			iwqp->ibqp.event_handler(&ibevent,
+						 iwqp->ibqp.qp_context);
+		}
+	}
+
+	if (!cm_id || !cm_id->event_handler)
+		return;
+	if (issue_disconn) {
+		err = irdma_send_cm_event(NULL, cm_id, IW_CM_EVENT_DISCONNECT,
+					  disconn_status);
+		if (err)
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: disconnect event failed: - cm_id = %p\n",
+				  cm_id);
+	}
+	if (issue_close) {
+		irdma_qp_disconnect(iwqp);
+		cm_id->provider_data = iwqp;
+		err = irdma_send_cm_event(NULL, cm_id, IW_CM_EVENT_CLOSE, 0);
+		if (err)
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: close event failed: - cm_id = %p\n",
+				  cm_id);
+		cm_id->rem_ref(cm_id);
+	}
+}
+
+/**
+ * irdma_disconnect_worker - worker for connection close
+ * @work: points or disconn structure
+ */
+static void irdma_disconnect_worker(struct work_struct *work)
+{
+	struct disconn_work *dwork = container_of(work, struct disconn_work, work);
+	struct irdma_qp *iwqp = dwork->iwqp;
+
+	kfree(dwork);
+	irdma_cm_disconn_true(iwqp);
+	irdma_rem_ref(&iwqp->ibqp);
+}
+
+/**
+ * irdma_free_lsmm_rsrc - free lsmm memory and deregister
+ * @iwqp: associate qp for the connection
+ */
+void irdma_free_lsmm_rsrc(struct irdma_qp *iwqp)
+{
+	struct irdma_device *iwdev;
+
+	iwdev = iwqp->iwdev;
+
+	if (iwqp->ietf_mem.va) {
+		if (iwqp->lsmm_mr)
+			iwdev->ibdev.ops.dereg_mr(iwqp->lsmm_mr, NULL);
+		dma_free_coherent(hw_to_dev(iwdev->rf->sc_dev.hw),
+				  iwqp->ietf_mem.size, iwqp->ietf_mem.va,
+				  iwqp->ietf_mem.pa);
+		iwqp->ietf_mem.va = NULL;
+		iwqp->ietf_mem.va = NULL;
+	}
+}
+
+/**
+ * irdma_accept - registered call for connection to be accepted
+ * @cm_id: cm information for passive connection
+ * @conn_param: accpet parameters
+ */
+int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
+{
+	struct ib_qp *ibqp;
+	struct irdma_qp *iwqp;
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	struct irdma_cm_core *cm_core;
+	struct irdma_cm_node *cm_node;
+	struct ib_qp_attr attr = {};
+	int passive_state;
+	struct ib_mr *ibmr;
+	struct irdma_pd *iwpd;
+	u16 buf_len = 0;
+	struct irdma_kmem_info accept;
+	unsigned long flags;
+	u64 tagged_offset;
+	int wait_ret;
+	int ret = 0;
+
+	ibqp = irdma_get_qp(cm_id->device, conn_param->qpn);
+	if (!ibqp)
+		return -EINVAL;
+
+	iwqp = to_iwqp(ibqp);
+	iwdev = iwqp->iwdev;
+	dev = &iwdev->rf->sc_dev;
+	cm_core = &iwdev->cm_core;
+	cm_node = cm_id->provider_data;
+
+	if (((struct sockaddr_in *)&cm_id->local_addr)->sin_family == AF_INET) {
+		cm_node->ipv4 = true;
+		cm_node->vlan_id = irdma_get_vlan_ipv4(cm_node->loc_addr);
+	} else {
+		cm_node->ipv4 = false;
+		irdma_netdev_vlan_ipv6(cm_node->loc_addr, &cm_node->vlan_id,
+				       NULL);
+	}
+	ibdev_dbg(to_ibdev(iwdev), "CM: Accept vlan_id=%d\n",
+		  cm_node->vlan_id);
+
+	trace_irdma_accept(cm_node, 0, NULL);
+
+	if (cm_node->state == IRDMA_CM_STATE_LISTENER_DESTROYED) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	passive_state = atomic_add_return(1, &cm_node->passive_state);
+	if (passive_state == IRDMA_SEND_RESET_EVENT) {
+		ret = -ECONNRESET;
+		goto error;
+	}
+
+	cm_node->cm_core->stats_accepts++;
+	iwqp->cm_node = cm_node;
+	cm_node->iwqp = iwqp;
+
+	buf_len = conn_param->private_data_len + IRDMA_MAX_IETF_SIZE;
+
+	iwqp->ietf_mem.size = ALIGN(buf_len, 1);
+	iwqp->ietf_mem.va = dma_alloc_coherent(hw_to_dev(dev->hw),
+					       iwqp->ietf_mem.size,
+					       &iwqp->ietf_mem.pa, GFP_KERNEL);
+	if (!iwqp->ietf_mem.va) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	cm_node->pdata.size = conn_param->private_data_len;
+	accept.addr = iwqp->ietf_mem.va;
+	accept.size = irdma_cm_build_mpa_frame(cm_node, &accept, MPA_KEY_REPLY);
+	memcpy(accept.addr + accept.size, conn_param->private_data,
+	       conn_param->private_data_len);
+
+	if (cm_node->dev->ws_add(iwqp->sc_qp.vsi, cm_node->user_pri)) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	irdma_qp_add_qos(&iwqp->sc_qp);
+
+	/* setup our first outgoing iWarp send WQE (the IETF frame response) */
+	iwpd = iwqp->iwpd;
+	tagged_offset = (uintptr_t)iwqp->ietf_mem.va;
+	ibmr = irdma_reg_phys_mr(&iwpd->ibpd, iwqp->ietf_mem.pa, buf_len,
+				 IB_ACCESS_LOCAL_WRITE, &tagged_offset);
+	if (IS_ERR(ibmr)) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	ibmr->pd = &iwpd->ibpd;
+	ibmr->device = iwpd->ibpd.device;
+	iwqp->lsmm_mr = ibmr;
+	if (iwqp->page)
+		iwqp->sc_qp.qp_uk.sq_base = kmap(iwqp->page);
+	dev->iw_priv_qp_ops->qp_send_lsmm(&iwqp->sc_qp,
+					  iwqp->ietf_mem.va,
+					  (accept.size + conn_param->private_data_len),
+					  ibmr->lkey);
+
+	if (iwqp->page)
+		kunmap(iwqp->page);
+
+	iwqp->cm_id = cm_id;
+	cm_node->cm_id = cm_id;
+
+	cm_id->provider_data = iwqp;
+	iwqp->active_conn = 0;
+
+	cm_node->lsmm_size = accept.size + conn_param->private_data_len;
+
+	irdma_cm_init_tsa_conn(iwqp, cm_node);
+	cm_id->add_ref(cm_id);
+	irdma_add_ref(&iwqp->ibqp);
+
+	attr.qp_state = IB_QPS_RTS;
+	cm_node->qhash_set = false;
+	cm_node->cm_core->cm_free_ah(cm_node);
+
+	irdma_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	list_move_tail(&cm_node->list, &cm_core->accelerated_list);
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	if (dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_RTS_AE) {
+		wait_ret = wait_event_interruptible_timeout(iwqp->waitq,
+							    iwqp->rts_ae_rcvd,
+							    IRDMA_MAX_TIMEOUT);
+		if (!wait_ret) {
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: Slow Connection: cm_node=%p, loc_port=%d, rem_port=%d, cm_id=%p\n",
+				  cm_node, cm_node->loc_port,
+				  cm_node->rem_port, cm_node->cm_id);
+			ret = -ECONNRESET;
+			goto error;
+		}
+	}
+
+	cm_node->accelerated = true;
+	irdma_send_cm_event(cm_node, cm_id, IW_CM_EVENT_ESTABLISHED, 0);
+
+	if (cm_node->accept_pend) {
+		atomic_dec(&cm_node->listener->pend_accepts_cnt);
+		cm_node->accept_pend = 0;
+	}
+
+	ibdev_dbg(to_ibdev(iwdev),
+		  "CM: rem_port=0x%04x, loc_port=0x%04x rem_addr=%pI4 loc_addr=%pI4 cm_node=%p cm_id=%p qp_id = %d\n\n",
+		  cm_node->rem_port, cm_node->loc_port, cm_node->rem_addr,
+		  cm_node->loc_addr, cm_node, cm_id, ibqp->qp_num);
+
+	return 0;
+error:
+	irdma_free_lsmm_rsrc(iwqp);
+	irdma_rem_ref_cm_node(cm_node);
+
+	return ret;
+}
+
+/**
+ * irdma_reject - registered call for connection to be rejected
+ * @cm_id: cm information for passive connection
+ * @pdata: private data to be sent
+ * @pdata_len: private data length
+ */
+int irdma_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
+{
+	struct irdma_device *iwdev;
+	struct irdma_cm_node *cm_node;
+
+	cm_node = cm_id->provider_data;
+	cm_node->cm_id = cm_id;
+	cm_node->pdata.size = pdata_len;
+
+	trace_irdma_reject(cm_node, 0, NULL);
+
+	iwdev = to_iwdev(cm_id->device);
+	if (!iwdev)
+		return -EINVAL;
+
+	cm_node->cm_core->stats_rejects++;
+
+	if (pdata_len + sizeof(struct ietf_mpa_v2) > IRDMA_MAX_CM_BUF)
+		return -EINVAL;
+
+	return irdma_cm_reject(cm_node, pdata, pdata_len);
+}
+
+/**
+ * irdma_connect - registered call for connection to be established
+ * @cm_id: cm information for passive connection
+ * @conn_param: Information about the connection
+ */
+int irdma_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
+{
+	struct ib_qp *ibqp;
+	struct irdma_qp *iwqp;
+	struct irdma_device *iwdev;
+	struct irdma_cm_node *cm_node;
+	struct irdma_cm_info cm_info;
+	struct sockaddr_in *laddr;
+	struct sockaddr_in *raddr;
+	struct sockaddr_in6 *laddr6;
+	struct sockaddr_in6 *raddr6;
+	int ret = 0;
+
+	ibqp = irdma_get_qp(cm_id->device, conn_param->qpn);
+	if (!ibqp)
+		return -EINVAL;
+	iwqp = to_iwqp(ibqp);
+	if (!iwqp)
+		return -EINVAL;
+	iwdev = iwqp->iwdev;
+	if (!iwdev)
+		return -EINVAL;
+
+	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
+	raddr = (struct sockaddr_in *)&cm_id->m_remote_addr;
+	laddr6 = (struct sockaddr_in6 *)&cm_id->m_local_addr;
+	raddr6 = (struct sockaddr_in6 *)&cm_id->m_remote_addr;
+
+	if (!(laddr->sin_port) || !(raddr->sin_port))
+		return -EINVAL;
+
+	iwqp->active_conn = 1;
+	iwqp->cm_id = NULL;
+	cm_id->provider_data = iwqp;
+
+	/* set up the connection params for the node */
+	if (cm_id->remote_addr.ss_family == AF_INET) {
+		if (iwdev->vsi.mtu < IRDMA_MIN_MTU_IPV4)
+			return -EINVAL;
+
+		cm_info.ipv4 = true;
+		memset(cm_info.loc_addr, 0, sizeof(cm_info.loc_addr));
+		memset(cm_info.rem_addr, 0, sizeof(cm_info.rem_addr));
+		cm_info.loc_addr[0] = ntohl(laddr->sin_addr.s_addr);
+		cm_info.rem_addr[0] = ntohl(raddr->sin_addr.s_addr);
+		cm_info.loc_port = ntohs(laddr->sin_port);
+		cm_info.rem_port = ntohs(raddr->sin_port);
+		cm_info.vlan_id = irdma_get_vlan_ipv4(cm_info.loc_addr);
+	} else {
+		if (iwdev->vsi.mtu < IRDMA_MIN_MTU_IPV6)
+			return -EINVAL;
+
+		cm_info.ipv4 = false;
+		irdma_copy_ip_ntohl(cm_info.loc_addr,
+				    laddr6->sin6_addr.in6_u.u6_addr32);
+		irdma_copy_ip_ntohl(cm_info.rem_addr,
+				    raddr6->sin6_addr.in6_u.u6_addr32);
+		cm_info.loc_port = ntohs(laddr6->sin6_port);
+		cm_info.rem_port = ntohs(raddr6->sin6_port);
+		irdma_netdev_vlan_ipv6(cm_info.loc_addr, &cm_info.vlan_id,
+				       NULL);
+	}
+	cm_info.cm_id = cm_id;
+	cm_info.qh_qpid = iwdev->vsi.ilq->qp_id;
+	cm_info.tos = cm_id->tos;
+	cm_info.user_pri = rt_tos2priority(cm_id->tos);
+
+	if (iwqp->sc_qp.dev->ws_add(iwqp->sc_qp.vsi, cm_info.user_pri))
+		return -ENOMEM;
+	irdma_qp_add_qos(&iwqp->sc_qp);
+
+	ibdev_dbg(to_ibdev(iwdev), "DCB: TOS:[%d] UP:[%d]\n", cm_id->tos,
+		  cm_info.user_pri);
+
+	trace_irdma_dcb_tos(iwdev, cm_id->tos, cm_info.user_pri);
+
+	cm_id->add_ref(cm_id);
+	ret = irdma_create_cm_node(&iwdev->cm_core, iwdev, conn_param, &cm_info,
+				   &cm_node);
+	if (ret) {
+		cm_id->rem_ref(cm_id);
+		return ret;
+	}
+	ret = cm_node->cm_core->cm_create_ah(cm_node, true);
+	if (ret)
+		goto err;
+	if (irdma_manage_qhash(iwdev, &cm_info,
+			       IRDMA_QHASH_TYPE_TCP_ESTABLISHED,
+			       IRDMA_QHASH_MANAGE_TYPE_ADD, NULL, true)) {
+		ret = -EINVAL;
+		goto err;
+	}
+	cm_node->qhash_set = true;
+
+	if (irdma_manage_apbvt(iwdev, cm_info.loc_port,
+			       IRDMA_MANAGE_APBVT_ADD)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	cm_node->apbvt_set = true;
+	iwqp->cm_node = cm_node;
+	cm_node->iwqp = iwqp;
+	iwqp->cm_id = cm_id;
+	irdma_add_ref(&iwqp->ibqp);
+
+	if (cm_node->state != IRDMA_CM_STATE_OFFLOADED) {
+		cm_node->state = IRDMA_CM_STATE_SYN_SENT;
+		ret = irdma_send_syn(cm_node, 0);
+		if (ret)
+			goto err;
+	}
+
+	ibdev_dbg(to_ibdev(iwdev),
+		  "CM: rem_port=0x%04x, loc_port=0x%04x rem_addr=%pI4 loc_addr=%pI4 cm_node=%p cm_id=%p qp_id = %d\n\n",
+		  cm_node->rem_port, cm_node->loc_port, cm_node->rem_addr,
+		  cm_node->loc_addr, cm_node, cm_id, ibqp->qp_num);
+
+	trace_irdma_connect(cm_node, 0, NULL);
+
+	return 0;
+
+err:
+	if (cm_info.ipv4)
+		ibdev_dbg(to_ibdev(iwdev),
+			  "CM: connect() FAILED: dest addr=%pI4",
+			  cm_info.rem_addr);
+	else
+		ibdev_dbg(to_ibdev(iwdev),
+			  "CM: connect() FAILED: dest addr=%pI6",
+			  cm_info.rem_addr);
+	irdma_rem_ref_cm_node(cm_node);
+	cm_id->rem_ref(cm_id);
+	iwdev->cm_core.stats_connect_errs++;
+
+	return ret;
+}
+
+/**
+ * irdma_create_listen - registered call creating listener
+ * @cm_id: cm information for passive connection
+ * @backlog: to max accept pending count
+ */
+int irdma_create_listen(struct iw_cm_id *cm_id, int backlog)
+{
+	struct irdma_device *iwdev;
+	struct irdma_cm_listener *cm_listen_node;
+	struct irdma_cm_info cm_info = {};
+	enum irdma_status_code err;
+	struct sockaddr_in *laddr;
+	struct sockaddr_in6 *laddr6;
+	bool wildcard = false;
+
+	iwdev = to_iwdev(cm_id->device);
+	if (!iwdev)
+		return -EINVAL;
+
+	laddr = (struct sockaddr_in *)&cm_id->m_local_addr;
+	laddr6 = (struct sockaddr_in6 *)&cm_id->m_local_addr;
+	cm_info.qh_qpid = iwdev->vsi.ilq->qp_id;
+
+	if (laddr->sin_family == AF_INET) {
+		if (iwdev->vsi.mtu < IRDMA_MIN_MTU_IPV4)
+			return -EINVAL;
+
+		cm_info.ipv4 = true;
+		cm_info.loc_addr[0] = ntohl(laddr->sin_addr.s_addr);
+		cm_info.loc_port = ntohs(laddr->sin_port);
+
+		if (laddr->sin_addr.s_addr != htonl(INADDR_ANY)) {
+			cm_info.vlan_id = irdma_get_vlan_ipv4(cm_info.loc_addr);
+		} else {
+			cm_info.vlan_id = 0xFFFF;
+			wildcard = true;
+		}
+	} else {
+		if (iwdev->vsi.mtu < IRDMA_MIN_MTU_IPV6)
+			return -EINVAL;
+
+		cm_info.ipv4 = false;
+		irdma_copy_ip_ntohl(cm_info.loc_addr,
+				    laddr6->sin6_addr.in6_u.u6_addr32);
+		cm_info.loc_port = ntohs(laddr6->sin6_port);
+		if (ipv6_addr_type(&laddr6->sin6_addr) != IPV6_ADDR_ANY) {
+			irdma_netdev_vlan_ipv6(cm_info.loc_addr,
+					       &cm_info.vlan_id, NULL);
+		} else {
+			cm_info.vlan_id = 0xFFFF;
+			wildcard = true;
+		}
+	}
+
+	if (cm_info.vlan_id >= VLAN_N_VID && iwdev->dcb)
+		cm_info.vlan_id = 0;
+	cm_info.backlog = backlog;
+	cm_info.cm_id = cm_id;
+
+	trace_irdma_create_listen(iwdev, &cm_info);
+
+	cm_listen_node = irdma_make_listen_node(&iwdev->cm_core, iwdev,
+						&cm_info);
+	if (!cm_listen_node) {
+		ibdev_dbg(to_ibdev(iwdev), "CM: cm_listen_node == NULL\n");
+		return -ENOMEM;
+	}
+
+	cm_id->provider_data = cm_listen_node;
+
+	cm_listen_node->tos = cm_id->tos;
+	cm_listen_node->user_pri = rt_tos2priority(cm_id->tos);
+	cm_info.user_pri = cm_listen_node->user_pri;
+	if (!cm_listen_node->reused_node) {
+		if (wildcard) {
+			if (cm_info.ipv4)
+				err = irdma_add_mqh_4(iwdev, &cm_info,
+						      cm_listen_node);
+			else
+				err = irdma_add_mqh_6(iwdev, &cm_info,
+						      cm_listen_node);
+			if (err)
+				goto error;
+
+			err = irdma_manage_apbvt(iwdev, cm_info.loc_port,
+						 IRDMA_MANAGE_APBVT_ADD);
+
+			if (err)
+				goto error;
+		} else {
+			err = irdma_manage_qhash(iwdev, &cm_info,
+						 IRDMA_QHASH_TYPE_TCP_SYN,
+						 IRDMA_QHASH_MANAGE_TYPE_ADD,
+						 NULL, true);
+			if (err)
+				goto error;
+
+			cm_listen_node->qhash_set = true;
+			err = irdma_manage_apbvt(iwdev, cm_info.loc_port,
+						 IRDMA_MANAGE_APBVT_ADD);
+			if (err)
+				goto error;
+		}
+	}
+	cm_id->add_ref(cm_id);
+	cm_listen_node->cm_core->stats_listen_created++;
+	return 0;
+
+error:
+
+	irdma_cm_del_listen(&iwdev->cm_core, cm_listen_node, false);
+
+	return -EINVAL;
+}
+
+/**
+ * irdma_destroy_listen - registered call to destroy listener
+ * @cm_id: cm information for passive connection
+ */
+int irdma_destroy_listen(struct iw_cm_id *cm_id)
+{
+	struct irdma_device *iwdev;
+
+	iwdev = to_iwdev(cm_id->device);
+	if (cm_id->provider_data)
+		irdma_cm_del_listen(&iwdev->cm_core, cm_id->provider_data,
+				    true);
+	else
+		ibdev_dbg(to_ibdev(iwdev),
+			  "CM: cm_id->provider_data was NULL\n");
+
+	cm_id->rem_ref(cm_id);
+
+	return 0;
+}
+
+/**
+ * irdma_cm_event_connected - handle connected active node
+ * @event: the info for cm_node of connection
+ */
+static void irdma_cm_event_connected(struct irdma_cm_event *event)
+{
+	struct irdma_qp *iwqp;
+	struct irdma_device *iwdev;
+	struct irdma_cm_core *cm_core;
+	struct irdma_cm_node *cm_node;
+	struct irdma_sc_dev *dev;
+	struct ib_qp_attr attr = {};
+	struct iw_cm_id *cm_id;
+	unsigned long flags;
+	int status;
+	bool read0;
+	int wait_ret = 0;
+
+	cm_node = event->cm_node;
+	cm_id = cm_node->cm_id;
+	iwqp = cm_id->provider_data;
+	iwdev = iwqp->iwdev;
+	dev = &iwdev->rf->sc_dev;
+	cm_core = &iwdev->cm_core;
+
+	if (iwqp->destroyed) {
+		status = -ETIMEDOUT;
+		goto error;
+	}
+
+	irdma_cm_init_tsa_conn(iwqp, cm_node);
+	read0 = (cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO);
+	if (iwqp->page)
+		iwqp->sc_qp.qp_uk.sq_base = kmap(iwqp->page);
+	dev->iw_priv_qp_ops->qp_send_rtt(&iwqp->sc_qp, read0);
+	if (iwqp->page)
+		kunmap(iwqp->page);
+
+	attr.qp_state = IB_QPS_RTS;
+	cm_node->qhash_set = false;
+	irdma_modify_qp(&iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	list_move_tail(&cm_node->list, &cm_core->accelerated_list);
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	if (dev->hw_attrs.uk_attrs.feature_flags & IRDMA_FEATURE_RTS_AE) {
+		wait_ret = wait_event_interruptible_timeout(iwqp->waitq,
+							    iwqp->rts_ae_rcvd,
+							    IRDMA_MAX_TIMEOUT);
+		if (!wait_ret)
+			ibdev_dbg(to_ibdev(iwdev),
+				  "CM: Slow Connection: cm_node=%p, loc_port=%d, rem_port=%d, cm_id=%p\n",
+				  cm_node, cm_node->loc_port,
+				  cm_node->rem_port, cm_node->cm_id);
+	}
+
+	cm_node->accelerated = true;
+	irdma_send_cm_event(cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY, 0);
+	cm_node->cm_core->cm_free_ah(cm_node);
+	return;
+
+error:
+	iwqp->cm_id = NULL;
+	cm_id->provider_data = NULL;
+	irdma_send_cm_event(event->cm_node, cm_id, IW_CM_EVENT_CONNECT_REPLY,
+			    status);
+	cm_id->rem_ref(cm_id);
+	irdma_rem_ref_cm_node(event->cm_node);
+}
+
+/**
+ * irdma_cm_event_reset - handle reset
+ * @event: the info for cm_node of connection
+ */
+static void irdma_cm_event_reset(struct irdma_cm_event *event)
+{
+	struct irdma_cm_node *cm_node = event->cm_node;
+	struct iw_cm_id *cm_id = cm_node->cm_id;
+	struct irdma_qp *iwqp;
+
+	if (!cm_id)
+		return;
+
+	iwqp = cm_id->provider_data;
+	if (!iwqp)
+		return;
+
+	ibdev_dbg(to_ibdev(cm_node->iwdev),
+		  "CM: reset event %p - cm_id = %p\n", event->cm_node, cm_id);
+	iwqp->cm_id = NULL;
+
+	irdma_send_cm_event(cm_node, cm_node->cm_id, IW_CM_EVENT_DISCONNECT,
+			    -ECONNRESET);
+	irdma_send_cm_event(cm_node, cm_node->cm_id, IW_CM_EVENT_CLOSE, 0);
+}
+
+/**
+ * irdma_cm_event_handler - send event to cm upper layer
+ * @work: pointer of cm event info.
+ */
+static void irdma_cm_event_handler(struct work_struct *work)
+{
+	struct irdma_cm_event *event = container_of(work, struct irdma_cm_event, event_work);
+	struct irdma_cm_node *cm_node;
+
+	if (!event || !event->cm_node || !event->cm_node->cm_core)
+		return;
+
+	cm_node = event->cm_node;
+	trace_irdma_cm_event_handler(cm_node, event->type, NULL);
+
+	switch (event->type) {
+	case IRDMA_CM_EVENT_MPA_REQ:
+		irdma_send_cm_event(cm_node, cm_node->cm_id,
+				    IW_CM_EVENT_CONNECT_REQUEST, 0);
+		break;
+	case IRDMA_CM_EVENT_RESET:
+		irdma_cm_event_reset(event);
+		break;
+	case IRDMA_CM_EVENT_CONNECTED:
+		if (!event->cm_node->cm_id ||
+		    event->cm_node->state != IRDMA_CM_STATE_OFFLOADED)
+			break;
+		irdma_cm_event_connected(event);
+		break;
+	case IRDMA_CM_EVENT_MPA_REJECT:
+		if (!event->cm_node->cm_id ||
+		    cm_node->state == IRDMA_CM_STATE_OFFLOADED)
+			break;
+		irdma_send_cm_event(cm_node, cm_node->cm_id,
+				    IW_CM_EVENT_CONNECT_REPLY, -ECONNREFUSED);
+		break;
+	case IRDMA_CM_EVENT_ABORTED:
+		if (!event->cm_node->cm_id ||
+		    event->cm_node->state == IRDMA_CM_STATE_OFFLOADED)
+			break;
+		irdma_event_connect_error(event);
+		break;
+	default:
+		ibdev_dbg(to_ibdev(cm_node->iwdev),
+			  "CM: bad event type = %d\n", event->type);
+		break;
+	}
+
+	event->cm_info.cm_id->rem_ref(event->cm_info.cm_id);
+	irdma_rem_ref_cm_node(event->cm_node);
+	kfree(event);
+}
+
+/**
+ * irdma_cm_post_event - queue event request for worker thread
+ * @event: cm node's info for up event call
+ */
+static void irdma_cm_post_event(struct irdma_cm_event *event)
+{
+	refcount_inc(&event->cm_node->refcnt);
+	event->cm_info.cm_id->add_ref(event->cm_info.cm_id);
+	INIT_WORK(&event->event_work, irdma_cm_event_handler);
+	queue_work(event->cm_node->cm_core->event_wq, &event->event_work);
+}
+
+/**
+ * irdma_qhash_ctrl - enable/disable qhash for list
+ * @iwdev: device pointer
+ * @parent_listen_node: parent listen node
+ * @nfo: cm info node
+ * @ipaddr: Pointer to IPv4 or IPv6 address
+ * @ipv4: flag indicating IPv4 when true
+ * @ifup: flag indicating interface up when true
+ *
+ * Enables or disables the qhash for the node in the child
+ * listen list that matches ipaddr. If no matching IP was found
+ * it will allocate and add a new child listen node to the
+ * parent listen node. The listen_list_lock is assumed to be
+ * held when called.
+ */
+static void irdma_qhash_ctrl(struct irdma_device *iwdev,
+			     struct irdma_cm_listener *parent_listen_node,
+			     struct irdma_cm_info *nfo, u32 *ipaddr, bool ipv4,
+			     bool ifup)
+{
+	struct list_head *child_listen_list = &parent_listen_node->child_listen_list;
+	struct irdma_cm_listener *child_listen_node;
+	struct list_head *pos, *tpos;
+	enum irdma_status_code err;
+	bool node_allocated = false;
+	enum irdma_quad_hash_manage_type op = ifup ?
+					      IRDMA_QHASH_MANAGE_TYPE_ADD :
+					      IRDMA_QHASH_MANAGE_TYPE_DELETE;
+
+	list_for_each_safe (pos, tpos, child_listen_list) {
+		child_listen_node = list_entry(pos, struct irdma_cm_listener,
+					       child_listen_list);
+		if (!memcmp(child_listen_node->loc_addr, ipaddr, ipv4 ? 4 : 16))
+			goto set_qhash;
+	}
+
+	/* if not found then add a child listener if interface is going up */
+	if (!ifup)
+		return;
+	child_listen_node = kmemdup(parent_listen_node,
+				    sizeof(*child_listen_node), GFP_ATOMIC);
+	if (!child_listen_node)
+		return;
+
+	node_allocated = true;
+	memcpy(child_listen_node->loc_addr, ipaddr, ipv4 ? 4 : 16);
+
+set_qhash:
+	memcpy(nfo->loc_addr, child_listen_node->loc_addr,
+	       sizeof(nfo->loc_addr));
+	nfo->vlan_id = child_listen_node->vlan_id;
+	err = irdma_manage_qhash(iwdev, nfo, IRDMA_QHASH_TYPE_TCP_SYN, op, NULL,
+				 false);
+	if (!err) {
+		child_listen_node->qhash_set = ifup;
+		if (node_allocated)
+			list_add(&child_listen_node->child_listen_list,
+				 &parent_listen_node->child_listen_list);
+	} else if (node_allocated) {
+		kfree(child_listen_node);
+	}
+}
+
+/**
+ * irdma_cm_teardown_connections - teardown QPs
+ * @iwdev: device pointer
+ * @ipaddr: Pointer to IPv4 or IPv6 address
+ * @nfo: Connection info
+ * @disconnect_all: flag indicating disconnect all QPs
+ *
+ * teardown QPs where source or destination addr matches ip addr
+ */
+void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
+				   struct irdma_cm_info *nfo,
+				   bool disconnect_all)
+{
+	struct irdma_cm_core *cm_core = &iwdev->cm_core;
+	struct list_head *list_core_temp;
+	struct list_head *list_node;
+	struct irdma_cm_node *cm_node;
+	struct list_head teardown_list;
+	struct ib_qp_attr attr;
+	struct irdma_sc_vsi *vsi = &iwdev->vsi;
+	struct irdma_sc_qp *sc_qp;
+	struct irdma_qp *qp;
+	int i;
+	unsigned long flags;
+
+	INIT_LIST_HEAD(&teardown_list);
+
+	spin_lock_irqsave(&cm_core->ht_lock, flags);
+	list_for_each_safe (list_node, list_core_temp,
+			    &cm_core->accelerated_list) {
+		cm_node = container_of(list_node, struct irdma_cm_node, list);
+		if (disconnect_all ||
+		    (nfo->vlan_id == cm_node->vlan_id &&
+		     !memcmp(cm_node->loc_addr, ipaddr, nfo->ipv4 ? 4 : 16))) {
+			refcount_inc(&cm_node->refcnt);
+			list_add(&cm_node->teardown_entry, &teardown_list);
+		}
+	}
+	list_for_each_safe (list_node, list_core_temp,
+			    &cm_core->non_accelerated_list) {
+		cm_node = container_of(list_node, struct irdma_cm_node, list);
+		if (disconnect_all ||
+		    (nfo->vlan_id == cm_node->vlan_id &&
+		     !memcmp(cm_node->loc_addr, ipaddr, nfo->ipv4 ? 4 : 16))) {
+			refcount_inc(&cm_node->refcnt);
+			list_add(&cm_node->teardown_entry, &teardown_list);
+		}
+	}
+	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+
+	list_for_each_safe (list_node, list_core_temp, &teardown_list) {
+		cm_node = container_of(list_node, struct irdma_cm_node,
+				       teardown_entry);
+		attr.qp_state = IB_QPS_ERR;
+		irdma_modify_qp(&cm_node->iwqp->ibqp, &attr, IB_QP_STATE, NULL);
+		if (iwdev->reset)
+			irdma_cm_disconn(cm_node->iwqp);
+		irdma_rem_ref_cm_node(cm_node);
+	}
+	if (!iwdev->roce_mode)
+		return;
+
+	INIT_LIST_HEAD(&teardown_list);
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		spin_lock_irqsave(&vsi->qos[i].lock, flags);
+		list_for_each_safe (list_node, list_core_temp,
+				    &vsi->qos[i].qplist) {
+			u32 qp_ip[4];
+
+			sc_qp = container_of(list_node, struct irdma_sc_qp,
+					     list);
+			if (sc_qp->qp_type != IRDMA_QP_TYPE_ROCE_RC)
+				continue;
+
+			qp = sc_qp->qp_uk.back_qp;
+			if (!disconnect_all) {
+				if (nfo->ipv4)
+					qp_ip[0] = qp->udp_info.local_ipaddr3;
+				else
+					memcpy(qp_ip,
+					       &qp->udp_info.local_ipaddr0,
+					       sizeof(qp_ip));
+			}
+
+			if (disconnect_all ||
+			    (nfo->vlan_id == (qp->udp_info.vlan_tag & VLAN_VID_MASK) &&
+			     !memcmp(qp_ip, ipaddr, nfo->ipv4 ? 4 : 16))) {
+				spin_lock(&iwdev->rf->qptable_lock);
+				if (iwdev->rf->qp_table[sc_qp->qp_uk.qp_id]) {
+					irdma_add_ref(&qp->ibqp);
+					list_add(&qp->teardown_entry,
+						 &teardown_list);
+				}
+				spin_unlock(&iwdev->rf->qptable_lock);
+			}
+		}
+		spin_unlock_irqrestore(&vsi->qos[i].lock, flags);
+	}
+
+	list_for_each_safe (list_node, list_core_temp, &teardown_list) {
+		qp = container_of(list_node, struct irdma_qp, teardown_entry);
+		attr.qp_state = IB_QPS_ERR;
+		irdma_modify_qp_roce(&qp->ibqp, &attr, IB_QP_STATE, NULL);
+		irdma_rem_ref(&qp->ibqp);
+	}
+}
+
+/**
+ * irdma_ifdown_notify - process an ifdown on an interface
+ * @iwdev: device pointer
+ * @netdev: network device structure
+ * @ipaddr: Pointer to IPv4 or IPv6 address
+ * @ipv4: flag indicating IPv4 when true
+ * @ifup: flag indicating interface up when true
+ */
+void irdma_if_notify(struct irdma_device *iwdev, struct net_device *netdev,
+		     u32 *ipaddr, bool ipv4, bool ifup)
+{
+	struct irdma_cm_core *cm_core = &iwdev->cm_core;
+	unsigned long flags;
+	struct irdma_cm_listener *listen_node;
+	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
+	struct irdma_cm_info nfo;
+	u16 vlan_id = rdma_vlan_dev_vlan_id(netdev);
+	enum irdma_quad_hash_manage_type op = ifup ?
+					      IRDMA_QHASH_MANAGE_TYPE_ADD :
+					      IRDMA_QHASH_MANAGE_TYPE_DELETE;
+
+	nfo.vlan_id = vlan_id;
+	nfo.ipv4 = ipv4;
+
+	/* Disable or enable qhash for listeners */
+	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
+	list_for_each_entry (listen_node, &cm_core->listen_nodes, list) {
+		if (vlan_id != listen_node->vlan_id ||
+		    (memcmp(listen_node->loc_addr, ipaddr, ipv4 ? 4 : 16) &&
+		     memcmp(listen_node->loc_addr, ip_zero, ipv4 ? 4 : 16)))
+			continue;
+
+		memcpy(nfo.loc_addr, listen_node->loc_addr,
+		       sizeof(nfo.loc_addr));
+		nfo.loc_port = listen_node->loc_port;
+		nfo.user_pri = listen_node->user_pri;
+		if (!list_empty(&listen_node->child_listen_list)) {
+			irdma_qhash_ctrl(iwdev, listen_node, &nfo, ipaddr, ipv4,
+					 ifup);
+		} else if (memcmp(listen_node->loc_addr, ip_zero,
+				  ipv4 ? 4 : 16)) {
+			if (!irdma_manage_qhash(iwdev, &nfo,
+						IRDMA_QHASH_TYPE_TCP_SYN, op,
+						NULL, false))
+				listen_node->qhash_set = ifup;
+		}
+	}
+	spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
+
+	/* disconnect any connected qp's on ifdown */
+	if (!ifup)
+		irdma_cm_teardown_connections(iwdev, ipaddr, &nfo, false);
+}
diff --git a/drivers/infiniband/hw/irdma/cm.h b/drivers/infiniband/hw/irdma/cm.h
new file mode 100644
index 000000000000..37ea0b672d7d
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/cm.h
@@ -0,0 +1,413 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_CM_H
+#define IRDMA_CM_H
+
+#define IRDMA_MANAGE_APBVT_DEL	0
+#define IRDMA_MANAGE_APBVT_ADD	1
+
+#define IRDMA_MPA_REQUEST_ACCEPT	1
+#define IRDMA_MPA_REQUEST_REJECT	2
+
+/* IETF MPA -- defines */
+#define IEFT_MPA_KEY_REQ	"MPA ID Req Frame"
+#define IEFT_MPA_KEY_REP	"MPA ID Rep Frame"
+#define IETF_MPA_KEY_SIZE	16
+#define IETF_MPA_VER		1
+#define IETF_MAX_PRIV_DATA_LEN	512
+#define IETF_MPA_FRAME_SIZE	20
+#define IETF_RTR_MSG_SIZE	4
+#define IETF_MPA_V2_FLAG	0x10
+#define SNDMARKER_SEQNMASK	0x000001ff
+#define IRDMA_MAX_IETF_SIZE	32
+
+/* IETF RTR MSG Fields */
+#define IETF_PEER_TO_PEER	0x8000
+#define IETF_FLPDU_ZERO_LEN	0x4000
+#define IETF_RDMA0_WRITE	0x8000
+#define IETF_RDMA0_READ		0x4000
+#define IETF_NO_IRD_ORD		0x3fff
+
+/* HW-supported IRD sizes*/
+#define	IRDMA_HW_IRD_SETTING_2		2
+#define	IRDMA_HW_IRD_SETTING_4		4
+#define	IRDMA_HW_IRD_SETTING_8		8
+#define	IRDMA_HW_IRD_SETTING_16		16
+#define	IRDMA_HW_IRD_SETTING_32		32
+#define	IRDMA_HW_IRD_SETTING_64		64
+#define	IRDMA_HW_IRD_SETTING_128	128
+
+#define MAX_PORTS	65536
+
+#define IRDMA_PASSIVE_STATE_INDICATED	0
+#define IRDMA_DO_NOT_SEND_RESET_EVENT	1
+#define IRDMA_SEND_RESET_EVENT		2
+
+#define MAX_IRDMA_IFS	4
+
+#define SET_ACK		1
+#define SET_SYN		2
+#define SET_FIN		4
+#define SET_RST		8
+
+#define TCP_OPTIONS_PADDING	3
+
+#define IRDMA_DEFAULT_RETRYS	64
+#define IRDMA_DEFAULT_RETRANS	8
+#define IRDMA_DEFAULT_TTL		0x40
+#define IRDMA_DEFAULT_RTT_VAR		6
+#define IRDMA_DEFAULT_SS_THRESH		0x3fffffff
+#define IRDMA_DEFAULT_REXMIT_THRESH	8
+
+#define IRDMA_RETRY_TIMEOUT	HZ
+#define IRDMA_SHORT_TIME	10
+#define IRDMA_LONG_TIME		(2 * HZ)
+#define IRDMA_MAX_TIMEOUT	((unsigned long)(12 * HZ))
+
+#define IRDMA_CM_HASHTABLE_SIZE		1024
+#define IRDMA_CM_TCP_TIMER_INTERVAL	3000
+#define IRDMA_CM_DEFAULT_MTU		1540
+#define IRDMA_CM_DEFAULT_FRAME_CNT	10
+#define IRDMA_CM_THREAD_STACK_SIZE	256
+#define IRDMA_CM_DEFAULT_RCV_WND	64240
+#define IRDMA_CM_DEFAULT_RCV_WND_SCALED	0x3fffc
+#define IRDMA_CM_DEFAULT_RCV_WND_SCALE	2
+#define IRDMA_CM_DEFAULT_FREE_PKTS	10
+#define IRDMA_CM_FREE_PKT_LO_WATERMARK	2
+#define IRDMA_CM_DEFAULT_MSS		536
+#define IRDMA_CM_DEFAULT_MPA_VER	2
+#define IRDMA_CM_DEFAULT_SEQ		0x159bf75f
+#define IRDMA_CM_DEFAULT_LOCAL_ID	0x3b47
+#define IRDMA_CM_DEFAULT_SEQ2		0x18ed5740
+#define IRDMA_CM_DEFAULT_LOCAL_ID2	0xb807
+#define IRDMA_MAX_CM_BUF		(IRDMA_MAX_IETF_SIZE + IETF_MAX_PRIV_DATA_LEN)
+
+enum ietf_mpa_flags {
+	IETF_MPA_FLAGS_REJECT  = 0x20,
+	IETF_MPA_FLAGS_CRC     = 0x40,
+	IETF_MPA_FLAGS_MARKERS = 0x80,
+};
+
+enum irdma_timer_type {
+	IRDMA_TIMER_TYPE_SEND,
+	IRDMA_TIMER_TYPE_CLOSE,
+};
+
+enum option_nums {
+	OPTION_NUM_EOL,
+	OPTION_NUM_NONE,
+	OPTION_NUM_MSS,
+	OPTION_NUM_WINDOW_SCALE,
+	OPTION_NUM_SACK_PERM,
+	OPTION_NUM_SACK,
+	OPTION_NUM_WRITE0 = 0xbc,
+};
+
+/* cm node transition states */
+enum irdma_cm_node_state {
+	IRDMA_CM_STATE_UNKNOWN,
+	IRDMA_CM_STATE_INITED,
+	IRDMA_CM_STATE_LISTENING,
+	IRDMA_CM_STATE_SYN_RCVD,
+	IRDMA_CM_STATE_SYN_SENT,
+	IRDMA_CM_STATE_ONE_SIDE_ESTABLISHED,
+	IRDMA_CM_STATE_ESTABLISHED,
+	IRDMA_CM_STATE_ACCEPTING,
+	IRDMA_CM_STATE_MPAREQ_SENT,
+	IRDMA_CM_STATE_MPAREQ_RCVD,
+	IRDMA_CM_STATE_MPAREJ_RCVD,
+	IRDMA_CM_STATE_OFFLOADED,
+	IRDMA_CM_STATE_FIN_WAIT1,
+	IRDMA_CM_STATE_FIN_WAIT2,
+	IRDMA_CM_STATE_CLOSE_WAIT,
+	IRDMA_CM_STATE_TIME_WAIT,
+	IRDMA_CM_STATE_LAST_ACK,
+	IRDMA_CM_STATE_CLOSING,
+	IRDMA_CM_STATE_LISTENER_DESTROYED,
+	IRDMA_CM_STATE_CLOSED,
+};
+
+enum mpa_frame_ver {
+	IETF_MPA_V1 = 1,
+	IETF_MPA_V2 = 2,
+};
+
+enum mpa_frame_key {
+	MPA_KEY_REQUEST,
+	MPA_KEY_REPLY,
+};
+
+enum send_rdma0 {
+	SEND_RDMA_READ_ZERO  = 1,
+	SEND_RDMA_WRITE_ZERO = 2,
+};
+
+enum irdma_tcpip_pkt_type {
+	IRDMA_PKT_TYPE_UNKNOWN,
+	IRDMA_PKT_TYPE_SYN,
+	IRDMA_PKT_TYPE_SYNACK,
+	IRDMA_PKT_TYPE_ACK,
+	IRDMA_PKT_TYPE_FIN,
+	IRDMA_PKT_TYPE_RST,
+};
+
+enum irdma_cm_listener_state {
+	IRDMA_CM_LISTENER_PASSIVE_STATE = 1,
+	IRDMA_CM_LISTENER_ACTIVE_STATE  = 2,
+	IRDMA_CM_LISTENER_EITHER_STATE  = 3,
+};
+
+/* CM event codes */
+enum irdma_cm_event_type {
+	IRDMA_CM_EVENT_UNKNOWN,
+	IRDMA_CM_EVENT_ESTABLISHED,
+	IRDMA_CM_EVENT_MPA_REQ,
+	IRDMA_CM_EVENT_MPA_CONNECT,
+	IRDMA_CM_EVENT_MPA_ACCEPT,
+	IRDMA_CM_EVENT_MPA_REJECT,
+	IRDMA_CM_EVENT_MPA_ESTABLISHED,
+	IRDMA_CM_EVENT_CONNECTED,
+	IRDMA_CM_EVENT_RESET,
+	IRDMA_CM_EVENT_ABORTED,
+};
+
+struct irdma_bth { /* Base Trasnport Header */
+	u8 opcode;
+	u8 flags;
+	__be16 pkey;
+	__be32 qpn;
+	__be32 apsn;
+};
+
+struct ietf_mpa_v1 {
+	u8 key[IETF_MPA_KEY_SIZE];
+	u8 flags;
+	u8 rev;
+	__be16 priv_data_len;
+	u8 priv_data[0];
+};
+
+struct ietf_rtr_msg {
+	__be16 ctrl_ird;
+	__be16 ctrl_ord;
+};
+
+struct ietf_mpa_v2 {
+	u8 key[IETF_MPA_KEY_SIZE];
+	u8 flags;
+	u8 rev;
+	__be16 priv_data_len;
+	struct ietf_rtr_msg rtr_msg;
+	u8 priv_data[0];
+};
+
+struct option_base {
+	u8 optionnum;
+	u8 len;
+};
+
+struct option_mss {
+	u8 optionnum;
+	u8 len;
+	__be16 mss;
+};
+
+struct option_windowscale {
+	u8 optionnum;
+	u8 len;
+	u8 shiftcount;
+};
+
+union all_known_options {
+	char eol;
+	struct option_base base;
+	struct option_mss mss;
+	struct option_windowscale windowscale;
+};
+
+struct irdma_timer_entry {
+	struct list_head list;
+	unsigned long timetosend; /* jiffies */
+	struct irdma_puda_buf *sqbuf;
+	u32 type;
+	u32 retrycount;
+	u32 retranscount;
+	u32 context;
+	u32 send_retrans;
+	int close_when_complete;
+};
+
+/* CM context params */
+struct irdma_cm_tcp_context {
+	u8 client;
+	u32 loc_seq_num;
+	u32 loc_ack_num;
+	u32 rem_ack_num;
+	u32 rcv_nxt;
+	u32 loc_id;
+	u32 rem_id;
+	u32 snd_wnd;
+	u32 max_snd_wnd;
+	u32 rcv_wnd;
+	u32 mss;
+	u8 snd_wscale;
+	u8 rcv_wscale;
+};
+
+struct irdma_cm_listener {
+	struct list_head list;
+	struct iw_cm_id *cm_id;
+	struct irdma_cm_core *cm_core;
+	struct irdma_device *iwdev;
+	struct list_head child_listen_list;
+	enum irdma_cm_listener_state listener_state;
+	refcount_t refcnt;
+	atomic_t pend_accepts_cnt;
+	u32 loc_addr[4];
+	u32 reused_node;
+	int backlog;
+	u16 loc_port;
+	u16 vlan_id;
+	u8 loc_mac[ETH_ALEN];
+	u8 user_pri;
+	u8 tos;
+	bool qhash_set:1;
+	bool ipv4:1;
+};
+
+struct irdma_kmem_info {
+	void *addr;
+	u32 size;
+};
+
+struct irdma_cm_node {
+	struct irdma_qp *iwqp;
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	struct irdma_cm_tcp_context tcp_cntxt;
+	struct irdma_cm_core *cm_core;
+	struct irdma_timer_entry *send_entry;
+	struct irdma_timer_entry *close_entry;
+	struct irdma_cm_listener *listener;
+	struct list_head timer_entry;
+	struct list_head reset_entry;
+	struct list_head teardown_entry;
+	struct irdma_kmem_info pdata;
+	struct irdma_sc_ah *ah;
+	union {
+		struct ietf_mpa_v1 mpa_frame;
+		struct ietf_mpa_v2 mpa_v2_frame;
+	};
+	struct irdma_kmem_info mpa_hdr;
+	struct iw_cm_id *cm_id;
+	struct list_head list;
+	spinlock_t retrans_list_lock; /* protect CM node rexmit updates*/
+	atomic_t passive_state;
+	refcount_t refcnt;
+	enum irdma_cm_node_state state;
+	enum send_rdma0 send_rdma0_op;
+	enum mpa_frame_ver mpa_frame_rev;
+	u32 loc_addr[4], rem_addr[4];
+	u16 loc_port, rem_port;
+	int apbvt_set;
+	int accept_pend;
+	u16 vlan_id;
+	u16 ird_size;
+	u16 ord_size;
+	u16 mpav2_ird_ord;
+	u16 lsmm_size;
+	u8 pdata_buf[IETF_MAX_PRIV_DATA_LEN];
+	u8 loc_mac[ETH_ALEN];
+	u8 rem_mac[ETH_ALEN];
+	u8 user_pri;
+	u8 tos;
+	bool ack_rcvd:1;
+	bool qhash_set:1;
+	bool ipv4:1;
+	bool snd_mark_en:1;
+	bool do_lpb:1;
+	bool accelerated:1;
+};
+
+/* Used by internal CM APIs to pass CM information*/
+struct irdma_cm_info {
+	struct iw_cm_id *cm_id;
+	u16 loc_port;
+	u16 rem_port;
+	u32 loc_addr[4];
+	u32 rem_addr[4];
+	u32 qh_qpid;
+	u16 vlan_id;
+	int backlog;
+	u8 user_pri;
+	u8 tos;
+	bool ipv4;
+};
+
+struct irdma_cm_event {
+	enum irdma_cm_event_type type;
+	struct irdma_cm_info cm_info;
+	struct work_struct event_work;
+	struct irdma_cm_node *cm_node;
+};
+
+struct irdma_cm_core {
+	struct irdma_device *iwdev;
+	struct irdma_sc_dev *dev;
+	struct list_head listen_nodes;
+	struct list_head accelerated_list;
+	struct list_head non_accelerated_list;
+	struct timer_list tcp_timer;
+	struct workqueue_struct *event_wq;
+	spinlock_t ht_lock; /* protect CM node (active side) list */
+	spinlock_t listen_list_lock; /* protect listener list */
+	spinlock_t apbvt_lock; /*serialize apbvt add/del entries*/
+	unsigned long ports_in_use[BITS_TO_LONGS(MAX_PORTS)];
+	u64 stats_nodes_created;
+	u64 stats_nodes_destroyed;
+	u64 stats_listen_created;
+	u64 stats_listen_destroyed;
+	u64 stats_listen_nodes_created;
+	u64 stats_listen_nodes_destroyed;
+	u64 stats_lpbs;
+	u64 stats_accepts;
+	u64 stats_rejects;
+	u64 stats_connect_errs;
+	u64 stats_passive_errs;
+	u64 stats_pkt_retrans;
+	u64 stats_backlog_drops;
+	struct irdma_puda_buf *(*form_cm_frame)(struct irdma_cm_node *cm_node,
+						struct irdma_kmem_info *options,
+						struct irdma_kmem_info *hdr,
+						struct irdma_kmem_info *pdata,
+						u8 flags);
+	int (*cm_create_ah)(struct irdma_cm_node *cm_node, bool wait);
+	void (*cm_free_ah)(struct irdma_cm_node *cm_node);
+};
+
+int irdma_schedule_cm_timer(struct irdma_cm_node *cm_node,
+			    struct irdma_puda_buf *sqbuf,
+			    enum irdma_timer_type type, int send_retrans,
+			    int close_when_complete);
+int irdma_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param);
+int irdma_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len);
+int irdma_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param);
+int irdma_create_listen(struct iw_cm_id *cm_id, int backlog);
+int irdma_destroy_listen(struct iw_cm_id *cm_id);
+void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
+				   struct irdma_cm_info *nfo,
+				   bool disconnect_all);
+int irdma_cm_start(struct irdma_device *dev);
+int irdma_cm_stop(struct irdma_device *dev);
+bool irdma_ipv4_is_lpb(u32 loc_addr, u32 rem_addr);
+bool irdma_ipv6_is_lpb(u32 *loc_addr, u32 *rem_addr);
+int irdma_arp_table(struct irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
+		    u8 *mac_addr, u32 action);
+int irdma_add_arp(struct irdma_pci_f *rf, u32 *ip, bool ipv4, u8 *mac);
+void irdma_if_notify(struct irdma_device *iwdev, struct net_device *netdev,
+		     u32 *ipaddr, bool ipv4, bool ifup);
+bool irdma_port_in_use(struct irdma_cm_core *cm_core, u16 port);
+void irdma_send_ack(struct irdma_cm_node *cm_node);
+void irdma_lpb_nop(struct irdma_sc_qp *qp);
+u8 irdma_derive_hw_ird_setting(u16 cm_ird);
+#endif /* IRDMA_CM_H */
-- 
2.25.2

