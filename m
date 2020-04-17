Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6661AE378
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgDQRNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbgDQRNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:13:35 -0400
IronPort-SDR: QD8kB1goyoW6MB3O6ujyRicJU9hu5bGz+D41qWIfRCF3PivpVjWbfw5zvlnMwXZBZxL40gy7I8
 RhM2EFH2ytaA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:58 -0700
IronPort-SDR: M+exMgXlgjzuyTvZ1i6DtLlTSeq9p8bj5WMvBpQ5nuOXZsOuWDx0PvT/KXgqAaXb7gIKETeObc
 w3OEldG0S+pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383746"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:58 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 13/16] RDMA/irdma: Add dynamic tracing for CM
Date:   Fri, 17 Apr 2020 10:12:48 -0700
Message-Id: <20200417171251.1533371-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>

Add dynamic tracing functionality to debug connection
management issues.

Signed-off-by: "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/trace.c    | 112 ++++++
 drivers/infiniband/hw/irdma/trace.h    |   3 +
 drivers/infiniband/hw/irdma/trace_cm.h | 458 +++++++++++++++++++++++++
 3 files changed, 573 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/trace.c
 create mode 100644 drivers/infiniband/hw/irdma/trace.h
 create mode 100644 drivers/infiniband/hw/irdma/trace_cm.h

diff --git a/drivers/infiniband/hw/irdma/trace.c b/drivers/infiniband/hw/irdma/trace.c
new file mode 100644
index 000000000000..b5133f4137e0
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/trace.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019 Intel Corporation */
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+const char *print_ip_addr(struct trace_seq *p, u32 *addr, u16 port, bool ipv4)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+
+	if (ipv4) {
+		__be32 myaddr = htonl(*addr);
+
+		trace_seq_printf(p, "%pI4:%d", &myaddr, htons(port));
+	} else {
+		trace_seq_printf(p, "%pI6:%d", addr, htons(port));
+	}
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
+const char *parse_iw_event_type(enum iw_cm_event_type iw_type)
+{
+	switch (iw_type) {
+	case IW_CM_EVENT_CONNECT_REQUEST:
+		return "IwRequest";
+	case IW_CM_EVENT_CONNECT_REPLY:
+		return "IwReply";
+	case IW_CM_EVENT_ESTABLISHED:
+		return "IwEstablished";
+	case IW_CM_EVENT_DISCONNECT:
+		return "IwDisconnect";
+	case IW_CM_EVENT_CLOSE:
+		return "IwClose";
+	}
+
+	return "Unknown";
+}
+
+const char *parse_cm_event_type(enum irdma_cm_event_type cm_type)
+{
+	switch (cm_type) {
+	case IRDMA_CM_EVENT_ESTABLISHED:
+		return "CmEstablished";
+	case IRDMA_CM_EVENT_MPA_REQ:
+		return "CmMPA_REQ";
+	case IRDMA_CM_EVENT_MPA_CONNECT:
+		return "CmMPA_CONNECT";
+	case IRDMA_CM_EVENT_MPA_ACCEPT:
+		return "CmMPA_ACCEPT";
+	case IRDMA_CM_EVENT_MPA_REJECT:
+		return "CmMPA_REJECT";
+	case IRDMA_CM_EVENT_MPA_ESTABLISHED:
+		return "CmMPA_ESTABLISHED";
+	case IRDMA_CM_EVENT_CONNECTED:
+		return "CmConnected";
+	case IRDMA_CM_EVENT_RESET:
+		return "CmReset";
+	case IRDMA_CM_EVENT_ABORTED:
+		return "CmAborted";
+	case IRDMA_CM_EVENT_UNKNOWN:
+		return "none";
+	}
+	return "Unknown";
+}
+
+const char *parse_cm_state(enum irdma_cm_node_state state)
+{
+	switch (state) {
+	case IRDMA_CM_STATE_UNKNOWN:
+		return "UNKNOWN";
+	case IRDMA_CM_STATE_INITED:
+		return "INITED";
+	case IRDMA_CM_STATE_LISTENING:
+		return "LISTENING";
+	case IRDMA_CM_STATE_SYN_RCVD:
+		return "SYN_RCVD";
+	case IRDMA_CM_STATE_SYN_SENT:
+		return "SYN_SENT";
+	case IRDMA_CM_STATE_ONE_SIDE_ESTABLISHED:
+		return "ONE_SIDE_ESTABLISHED";
+	case IRDMA_CM_STATE_ESTABLISHED:
+		return "ESTABLISHED";
+	case IRDMA_CM_STATE_ACCEPTING:
+		return "ACCEPTING";
+	case IRDMA_CM_STATE_MPAREQ_SENT:
+		return "MPAREQ_SENT";
+	case IRDMA_CM_STATE_MPAREQ_RCVD:
+		return "MPAREQ_RCVD";
+	case IRDMA_CM_STATE_MPAREJ_RCVD:
+		return "MPAREJ_RECVD";
+	case IRDMA_CM_STATE_OFFLOADED:
+		return "OFFLOADED";
+	case IRDMA_CM_STATE_FIN_WAIT1:
+		return "FIN_WAIT1";
+	case IRDMA_CM_STATE_FIN_WAIT2:
+		return "FIN_WAIT2";
+	case IRDMA_CM_STATE_CLOSE_WAIT:
+		return "CLOSE_WAIT";
+	case IRDMA_CM_STATE_TIME_WAIT:
+		return "TIME_WAIT";
+	case IRDMA_CM_STATE_LAST_ACK:
+		return "LAST_ACK";
+	case IRDMA_CM_STATE_CLOSING:
+		return "CLOSING";
+	case IRDMA_CM_STATE_LISTENER_DESTROYED:
+		return "LISTENER_DESTROYED";
+	case IRDMA_CM_STATE_CLOSED:
+		return "CLOSED";
+	}
+	return ("Bad state");
+}
diff --git a/drivers/infiniband/hw/irdma/trace.h b/drivers/infiniband/hw/irdma/trace.h
new file mode 100644
index 000000000000..702e4efb018d
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/trace.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#include "trace_cm.h"
diff --git a/drivers/infiniband/hw/irdma/trace_cm.h b/drivers/infiniband/hw/irdma/trace_cm.h
new file mode 100644
index 000000000000..9ca6ee4efd77
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/trace_cm.h
@@ -0,0 +1,458 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2019 Intel Corporation */
+#if !defined(__TRACE_CM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __TRACE_CM_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include "main.h"
+
+const char *print_ip_addr(struct trace_seq *p, u32 *addr, u16 port, bool ivp4);
+const char *parse_iw_event_type(enum iw_cm_event_type iw_type);
+const char *parse_cm_event_type(enum irdma_cm_event_type cm_type);
+const char *parse_cm_state(enum irdma_cm_node_state);
+#define __print_ip_addr(addr, port, ipv4) print_ip_addr(p, addr, port, ipv4)
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irdma_cm
+
+TRACE_EVENT(irdma_create_listen,
+	    TP_PROTO(struct irdma_device *iwdev, struct irdma_cm_info *cm_info),
+	    TP_ARGS(iwdev, cm_info),
+	    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+			     __dynamic_array(u32, laddr, 4)
+			     __field(u16, lport)
+			     __field(bool, ipv4)
+		    ),
+	    TP_fast_assign(__entry->iwdev = iwdev;
+			   __entry->lport = cm_info->loc_port;
+			   __entry->ipv4 = cm_info->ipv4;
+			   memcpy(__get_dynamic_array(laddr),
+				  cm_info->loc_addr, 4);
+		    ),
+	    TP_printk("iwdev=%p  loc: %s",
+		      __entry->iwdev,
+		      __print_ip_addr(__get_dynamic_array(laddr),
+				      __entry->lport, __entry->ipv4)
+		    )
+);
+
+TRACE_EVENT(irdma_dec_refcnt_listen,
+	    TP_PROTO(struct irdma_cm_listener *listener, void *caller),
+	    TP_ARGS(listener, caller),
+	    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+		    __field(u32, refcnt)
+		    __dynamic_array(u32, laddr, 4)
+		    __field(u16, lport)
+		    __field(bool, ipv4)
+		    __field(void *, caller)
+		    ),
+	    TP_fast_assign(__entry->iwdev = listener->iwdev;
+			   __entry->lport = listener->loc_port;
+			   __entry->ipv4 = listener->ipv4;
+			   memcpy(__get_dynamic_array(laddr),
+				  listener->loc_addr, 4);
+		    ),
+	    TP_printk("iwdev=%p  caller=%pS  loc: %s",
+		      __entry->iwdev,
+		      __entry->caller,
+		      __print_ip_addr(__get_dynamic_array(laddr),
+				      __entry->lport, __entry->ipv4)
+		    )
+);
+
+DECLARE_EVENT_CLASS(listener_template,
+		    TP_PROTO(struct irdma_cm_listener *listener),
+		    TP_ARGS(listener),
+		    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+				     __field(u16, lport)
+				     __field(u16, vlan_id)
+				     __field(bool, ipv4)
+				     __field(enum irdma_cm_listener_state,
+					     state)
+				     __dynamic_array(u32, laddr, 4)
+			    ),
+		    TP_fast_assign(__entry->iwdev = listener->iwdev;
+				   __entry->lport = listener->loc_port;
+				   __entry->vlan_id = listener->vlan_id;
+				   __entry->ipv4 = listener->ipv4;
+				   __entry->state = listener->listener_state;
+				   memcpy(__get_dynamic_array(laddr),
+					  listener->loc_addr, 4);
+			    ),
+		    TP_printk("iwdev=%p  vlan=%d  loc: %s",
+			      __entry->iwdev,
+			      __entry->vlan_id,
+			      __print_ip_addr(__get_dynamic_array(laddr),
+					      __entry->lport, __entry->ipv4)
+			    )
+);
+
+DEFINE_EVENT(listener_template, irdma_find_listener,
+	     TP_PROTO(struct irdma_cm_listener *listener),
+	     TP_ARGS(listener));
+
+DEFINE_EVENT(listener_template, irdma_del_multiple_qhash,
+	     TP_PROTO(struct irdma_cm_listener *listener),
+	     TP_ARGS(listener));
+
+TRACE_EVENT(irdma_negotiate_mpa_v2,
+	    TP_PROTO(struct irdma_cm_node *cm_node),
+	    TP_ARGS(cm_node),
+	    TP_STRUCT__entry(__field(struct irdma_cm_node *, cm_node)
+			     __field(u16, ord_size)
+			     __field(u16, ird_size)
+		    ),
+	    TP_fast_assign(__entry->cm_node = cm_node;
+			   __entry->ord_size = cm_node->ord_size;
+			   __entry->ird_size = cm_node->ird_size;
+		    ),
+	    TP_printk("MPVA2 Negotiated cm_node=%p ORD:[%d], IRD:[%d]",
+		      __entry->cm_node,
+		      __entry->ord_size,
+		      __entry->ird_size
+		    )
+);
+
+DECLARE_EVENT_CLASS(tos_template,
+		    TP_PROTO(struct irdma_device *iwdev, u8 tos, u8 user_pri),
+		    TP_ARGS(iwdev, tos, user_pri),
+		    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+				     __field(u8, tos)
+				     __field(u8, user_pri)
+			    ),
+		    TP_fast_assign(__entry->iwdev = iwdev;
+				   __entry->tos = tos;
+				   __entry->user_pri = user_pri;
+			    ),
+		    TP_printk("iwdev=%p  TOS:[%d]  UP:[%d]",
+			      __entry->iwdev,
+			      __entry->tos,
+			      __entry->user_pri
+			    )
+);
+
+DEFINE_EVENT(tos_template, irdma_listener_tos,
+	     TP_PROTO(struct irdma_device *iwdev, u8 tos, u8 user_pri),
+	     TP_ARGS(iwdev, tos, user_pri));
+
+DEFINE_EVENT(tos_template, irdma_dcb_tos,
+	     TP_PROTO(struct irdma_device *iwdev, u8 tos, u8 user_pri),
+	     TP_ARGS(iwdev, tos, user_pri));
+
+DECLARE_EVENT_CLASS(qhash_template,
+		    TP_PROTO(struct irdma_device *iwdev,
+			     struct irdma_cm_listener *listener,
+			     char *dev_addr),
+		    TP_ARGS(iwdev, listener, dev_addr),
+		    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+				     __field(u16, lport)
+				     __field(u16, vlan_id)
+				     __field(bool, ipv4)
+				     __dynamic_array(u32, laddr, 4)
+				     __dynamic_array(u32, mac, ETH_ALEN)
+			    ),
+		    TP_fast_assign(__entry->iwdev = iwdev;
+				   __entry->lport = listener->loc_port;
+				   __entry->vlan_id = listener->vlan_id;
+				   __entry->ipv4 = listener->ipv4;
+				   memcpy(__get_dynamic_array(laddr),
+					  listener->loc_addr, 4);
+				   ether_addr_copy(__get_dynamic_array(mac),
+						   dev_addr);
+			    ),
+		    TP_printk("iwdev=%p  vlan=%d  MAC=%pM  loc: %s",
+			      __entry->iwdev,
+			      __entry->vlan_id,
+			      __get_dynamic_array(mac),
+			      __print_ip_addr(__get_dynamic_array(laddr),
+					      __entry->lport, __entry->ipv4)
+		    )
+);
+
+DEFINE_EVENT(qhash_template, irdma_add_mqh_6,
+	     TP_PROTO(struct irdma_device *iwdev,
+		      struct irdma_cm_listener *listener, char *dev_addr),
+	     TP_ARGS(iwdev, listener, dev_addr));
+
+DEFINE_EVENT(qhash_template, irdma_add_mqh_4,
+	     TP_PROTO(struct irdma_device *iwdev,
+		      struct irdma_cm_listener *listener, char *dev_addr),
+	     TP_ARGS(iwdev, listener, dev_addr));
+
+TRACE_EVENT(irdma_addr_resolve,
+	    TP_PROTO(struct irdma_device *iwdev, char *dev_addr),
+	    TP_ARGS(iwdev, dev_addr),
+	    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+		    __dynamic_array(u8, mac, ETH_ALEN)
+		    ),
+	    TP_fast_assign(__entry->iwdev = iwdev;
+		    ether_addr_copy(__get_dynamic_array(mac), dev_addr);
+		    ),
+	    TP_printk("iwdev=%p   MAC=%pM", __entry->iwdev,
+		      __get_dynamic_array(mac)
+		    )
+);
+
+TRACE_EVENT(irdma_send_cm_event,
+	    TP_PROTO(struct irdma_cm_node *cm_node, struct iw_cm_id *cm_id,
+		     enum iw_cm_event_type type, int status, void *caller),
+	    TP_ARGS(cm_node, cm_id, type, status, caller),
+	    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+			     __field(struct irdma_cm_node *, cm_node)
+			     __field(struct iw_cm_id *, cm_id)
+			     __field(u32, refcount)
+			     __field(u16, lport)
+			     __field(u16, rport)
+			     __field(enum irdma_cm_node_state, state)
+			     __field(bool, ipv4)
+			     __field(u16, vlan_id)
+			     __field(int, accel)
+			     __field(enum iw_cm_event_type, type)
+			     __field(int, status)
+			     __field(void *, caller)
+			     __dynamic_array(u32, laddr, 4)
+			     __dynamic_array(u32, raddr, 4)
+		    ),
+	    TP_fast_assign(__entry->iwdev = cm_node->iwdev;
+			   __entry->cm_node = cm_node;
+			   __entry->cm_id = cm_id;
+			   __entry->refcount = refcount_read(&cm_node->refcnt);
+			   __entry->state = cm_node->state;
+			   __entry->lport = cm_node->loc_port;
+			   __entry->rport = cm_node->rem_port;
+			   __entry->ipv4 = cm_node->ipv4;
+			   __entry->vlan_id = cm_node->vlan_id;
+			   __entry->accel = cm_node->accelerated;
+			   __entry->type = type;
+			   __entry->status = status;
+			   __entry->caller = caller;
+			   memcpy(__get_dynamic_array(laddr),
+				  cm_node->loc_addr, 4);
+			   memcpy(__get_dynamic_array(raddr),
+				  cm_node->rem_addr, 4);
+		    ),
+	    TP_printk("iwdev=%p  caller=%pS  cm_id=%p  node=%p  refcnt=%d  vlan_id=%d  accel=%d  state=%s  event_type=%s  status=%d  loc: %s  rem: %s",
+		      __entry->iwdev,
+		      __entry->caller,
+		      __entry->cm_id,
+		      __entry->cm_node,
+		      __entry->refcount,
+		      __entry->vlan_id,
+		      __entry->accel,
+		      parse_cm_state(__entry->state),
+		      parse_iw_event_type(__entry->type),
+		      __entry->status,
+		      __print_ip_addr(__get_dynamic_array(laddr),
+				      __entry->lport, __entry->ipv4),
+		      __print_ip_addr(__get_dynamic_array(raddr),
+				      __entry->rport, __entry->ipv4)
+		    )
+);
+
+TRACE_EVENT(irdma_send_cm_event_no_node,
+	    TP_PROTO(struct iw_cm_id *cm_id, enum iw_cm_event_type type,
+		     int status, void *caller),
+	    TP_ARGS(cm_id, type, status, caller),
+	    TP_STRUCT__entry(__field(struct iw_cm_id *, cm_id)
+			     __field(enum iw_cm_event_type, type)
+			     __field(int, status)
+			     __field(void *, caller)
+		    ),
+	    TP_fast_assign(__entry->cm_id = cm_id;
+			   __entry->type = type;
+			   __entry->status = status;
+			   __entry->caller = caller;
+		    ),
+	    TP_printk("cm_id=%p  caller=%pS  event_type=%s  status=%d",
+		      __entry->cm_id,
+		      __entry->caller,
+		      parse_iw_event_type(__entry->type),
+		      __entry->status
+		    )
+);
+
+DECLARE_EVENT_CLASS(cm_node_template,
+		    TP_PROTO(struct irdma_cm_node *cm_node,
+			     enum irdma_cm_event_type type, void *caller),
+		    TP_ARGS(cm_node, type, caller),
+		    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+				     __field(struct irdma_cm_node *, cm_node)
+				     __field(u32, refcount)
+				     __field(u16, lport)
+				     __field(u16, rport)
+				     __field(enum irdma_cm_node_state, state)
+				     __field(bool, ipv4)
+				     __field(u16, vlan_id)
+				     __field(int, accel)
+				     __field(enum irdma_cm_event_type, type)
+				     __field(void *, caller)
+				     __dynamic_array(u32, laddr, 4)
+				     __dynamic_array(u32, raddr, 4)
+			    ),
+		    TP_fast_assign(__entry->iwdev = cm_node->iwdev;
+				   __entry->cm_node = cm_node;
+				   __entry->refcount = refcount_read(&cm_node->refcnt);
+				   __entry->state = cm_node->state;
+				   __entry->lport = cm_node->loc_port;
+				   __entry->rport = cm_node->rem_port;
+				   __entry->ipv4 = cm_node->ipv4;
+				   __entry->vlan_id = cm_node->vlan_id;
+				   __entry->accel = cm_node->accelerated;
+				   __entry->type = type;
+				   __entry->caller = caller;
+				   memcpy(__get_dynamic_array(laddr),
+					  cm_node->loc_addr, 4);
+				   memcpy(__get_dynamic_array(raddr),
+					  cm_node->rem_addr, 4);
+			    ),
+		    TP_printk("iwdev=%p  caller=%pS  node=%p  refcnt=%d  vlan_id=%d  accel=%d  state=%s  event_type=%s  loc: %s  rem: %s",
+			      __entry->iwdev,
+			      __entry->caller,
+			      __entry->cm_node,
+			      __entry->refcount,
+			      __entry->vlan_id,
+			      __entry->accel,
+			      parse_cm_state(__entry->state),
+			      parse_cm_event_type(__entry->type),
+			      __print_ip_addr(__get_dynamic_array(laddr),
+					      __entry->lport, __entry->ipv4),
+			      __print_ip_addr(__get_dynamic_array(raddr),
+					      __entry->rport, __entry->ipv4)
+		    )
+);
+
+DEFINE_EVENT(cm_node_template, irdma_create_event,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_accept,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_connect,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_reject,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_find_node,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_send_reset,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_rem_ref_cm_node,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+DEFINE_EVENT(cm_node_template, irdma_cm_event_handler,
+	     TP_PROTO(struct irdma_cm_node *cm_node,
+		      enum irdma_cm_event_type type, void *caller),
+	     TP_ARGS(cm_node, type, caller));
+
+TRACE_EVENT(open_err_template,
+	    TP_PROTO(struct irdma_cm_node *cm_node, bool reset, void *caller),
+	    TP_ARGS(cm_node, reset, caller),
+	    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+			     __field(struct irdma_cm_node *, cm_node)
+			     __field(enum irdma_cm_node_state, state)
+			     __field(bool, reset)
+			     __field(void *, caller)
+		    ),
+	    TP_fast_assign(__entry->iwdev = cm_node->iwdev;
+			   __entry->cm_node = cm_node;
+			   __entry->state = cm_node->state;
+			   __entry->reset = reset;
+			   __entry->caller = caller;
+		    ),
+	    TP_printk("iwdev=%p  caller=%pS  node%p reset=%d  state=%s",
+		      __entry->iwdev,
+		      __entry->caller,
+		      __entry->cm_node,
+		      __entry->reset,
+		      parse_cm_state(__entry->state)
+		    )
+);
+
+DEFINE_EVENT(open_err_template, irdma_active_open_err,
+	     TP_PROTO(struct irdma_cm_node *cm_node, bool reset, void *caller),
+	     TP_ARGS(cm_node, reset, caller));
+
+DEFINE_EVENT(open_err_template, irdma_passive_open_err,
+	     TP_PROTO(struct irdma_cm_node *cm_node, bool reset, void *caller),
+	     TP_ARGS(cm_node, reset, caller));
+
+DECLARE_EVENT_CLASS(cm_node_ah_template,
+		    TP_PROTO(struct irdma_cm_node *cm_node),
+		    TP_ARGS(cm_node),
+		    TP_STRUCT__entry(__field(struct irdma_device *, iwdev)
+				     __field(struct irdma_cm_node *, cm_node)
+				     __field(struct irdma_sc_ah *, ah)
+				     __field(u32, refcount)
+				     __field(u16, lport)
+				     __field(u16, rport)
+				     __field(enum irdma_cm_node_state, state)
+				     __field(bool, ipv4)
+				     __field(u16, vlan_id)
+				     __field(int, accel)
+				     __dynamic_array(u32, laddr, 4)
+				     __dynamic_array(u32, raddr, 4)
+			    ),
+		    TP_fast_assign(__entry->iwdev = cm_node->iwdev;
+				   __entry->cm_node = cm_node;
+				   __entry->ah = cm_node->ah;
+				   __entry->refcount = refcount_read(&cm_node->refcnt);
+				   __entry->lport = cm_node->loc_port;
+				   __entry->rport = cm_node->rem_port;
+				   __entry->state = cm_node->state;
+				   __entry->ipv4 = cm_node->ipv4;
+				   __entry->vlan_id = cm_node->vlan_id;
+				   __entry->accel = cm_node->accelerated;
+				   memcpy(__get_dynamic_array(laddr),
+					  cm_node->loc_addr, 4);
+				   memcpy(__get_dynamic_array(raddr),
+					  cm_node->rem_addr, 4);
+			    ),
+		    TP_printk("iwdev=%p  node=%p  ah=%p  refcnt=%d  vlan_id=%d  accel=%d  state=%s loc: %s  rem: %s",
+			      __entry->iwdev,
+			      __entry->cm_node,
+			      __entry->ah,
+			      __entry->refcount,
+			      __entry->vlan_id,
+			      __entry->accel,
+			      parse_cm_state(__entry->state),
+			      __print_ip_addr(__get_dynamic_array(laddr),
+					      __entry->lport, __entry->ipv4),
+			      __print_ip_addr(__get_dynamic_array(raddr),
+					      __entry->rport, __entry->ipv4)
+		    )
+);
+
+DEFINE_EVENT(cm_node_ah_template, irdma_cm_free_ah,
+	     TP_PROTO(struct irdma_cm_node *cm_node),
+	     TP_ARGS(cm_node));
+
+DEFINE_EVENT(cm_node_ah_template, irdma_create_ah,
+	     TP_PROTO(struct irdma_cm_node *cm_node),
+	     TP_ARGS(cm_node));
+
+#endif  /* __TRACE_CM_H */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_cm
+#include <trace/define_trace.h>
-- 
2.25.2

