Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AA3B066A
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhFVOFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:05:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229988AbhFVOFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624370583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C2iLY2DgXPTa30aukfioKM+h3MLlyzYQ7HRuUz0Mm3Y=;
        b=IOtT/TcZQWS/rLscSr7WoyLkkMa0WIgJGm8kuwxG6kN2vl8NerY+wEQ2qGsYcHlPtmDLrF
        ym9FHeVHM52rM6uqkqhm08UVebZ83dL0JEs+i9/a8njIQEIkRnHmQZrODgAH/HzfkuuFH8
        s+lm+26P7ydbbK2T9fRSSIGOdJxh8og=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Sb4oO8kTMCuKeUgMWO6XMA-1; Tue, 22 Jun 2021 10:02:42 -0400
X-MC-Unique: Sb4oO8kTMCuKeUgMWO6XMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB5D1800D55;
        Tue, 22 Jun 2021 14:02:40 +0000 (UTC)
Received: from RHTPC1VM0NT.lan (ovpn-113-104.rdu2.redhat.com [10.10.113.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7258D60BF1;
        Tue, 22 Jun 2021 14:02:39 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Dumitru Ceara <dceara@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next] openvswitch: add trace points
Date:   Tue, 22 Jun 2021 10:02:33 -0400
Message-Id: <20210622140233.282345-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes openvswitch module use the event tracing framework
to log the upcall interface and action execution pipeline.  When
using openvswitch as the packet forwarding engine, some types of
debugging are made possible simply by using the ovs-vswitchd's
ofproto/trace command.  However, such a command has some
limitations:

  1. When trying to trace packets that go through the CT action,
     the state of the packet can't be determined, and probably
     would be potentially wrong.

  2. Deducing problem packets can sometimes be difficult as well
     even if many of the flows are known

  3. It's possible to use the openvswitch module even without
     the ovs-vswitchd (although, not common use).

Introduce the event tracing points here to make it possible for
working through these problems in kernel space.  The style is
copied from the mac80211 driver-trace / trace code for
consistency - this creates some checkpatch splats, but the
official 'guide' for adding tracepoints, as well as the existing
examples all add the same splats so it seems acceptable.

Signed-off-by: Aaron Conole <aconole@redhat.com>
---
RFC: https://lore.kernel.org/netdev/20210527191532.376414-1-aconole@redhat.com/
     - renamed trace point functions
     - added fields to the trace point argument

 net/openvswitch/Makefile            |   3 +
 net/openvswitch/actions.c           |   4 +
 net/openvswitch/datapath.c          |   4 +
 net/openvswitch/openvswitch_trace.c |  10 ++
 net/openvswitch/openvswitch_trace.h | 158 ++++++++++++++++++++++++++++
 5 files changed, 179 insertions(+)
 create mode 100644 net/openvswitch/openvswitch_trace.c
 create mode 100644 net/openvswitch/openvswitch_trace.h

diff --git a/net/openvswitch/Makefile b/net/openvswitch/Makefile
index 41109c326f3a..28982630bef3 100644
--- a/net/openvswitch/Makefile
+++ b/net/openvswitch/Makefile
@@ -13,6 +13,7 @@ openvswitch-y := \
 	flow_netlink.o \
 	flow_table.o \
 	meter.o \
+	openvswitch_trace.o \
 	vport.o \
 	vport-internal_dev.o \
 	vport-netdev.o
@@ -24,3 +25,5 @@ endif
 obj-$(CONFIG_OPENVSWITCH_VXLAN)+= vport-vxlan.o
 obj-$(CONFIG_OPENVSWITCH_GENEVE)+= vport-geneve.o
 obj-$(CONFIG_OPENVSWITCH_GRE)	+= vport-gre.o
+
+CFLAGS_openvswitch_trace.o = -I$(src)
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 77d924ab8cdb..ef15d9eb4774 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -30,6 +30,7 @@
 #include "conntrack.h"
 #include "vport.h"
 #include "flow_netlink.h"
+#include "openvswitch_trace.h"
 
 struct deferred_action {
 	struct sk_buff *skb;
@@ -1242,6 +1243,9 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 	     a = nla_next(a, &rem)) {
 		int err = 0;
 
+		if (trace_ovs_do_execute_action_enabled())
+			trace_ovs_do_execute_action(dp, skb, key, a, rem);
+
 		switch (nla_type(a)) {
 		case OVS_ACTION_ATTR_OUTPUT: {
 			int port = nla_get_u32(a);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9d6ef6cb9b26..bc164b35e67d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -43,6 +43,7 @@
 #include "flow_table.h"
 #include "flow_netlink.h"
 #include "meter.h"
+#include "openvswitch_trace.h"
 #include "vport-internal_dev.h"
 #include "vport-netdev.h"
 
@@ -275,6 +276,9 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 	struct dp_stats_percpu *stats;
 	int err;
 
+	if (trace_ovs_dp_upcall_enabled())
+		trace_ovs_dp_upcall(dp, skb, key, upcall_info);
+
 	if (upcall_info->portid == 0) {
 		err = -ENOTCONN;
 		goto err;
diff --git a/net/openvswitch/openvswitch_trace.c b/net/openvswitch/openvswitch_trace.c
new file mode 100644
index 000000000000..62c5f7d6f023
--- /dev/null
+++ b/net/openvswitch/openvswitch_trace.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+/* bug in tracepoint.h, it should include this */
+#include <linux/module.h>
+
+/* sparse isn't too happy with all macros... */
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "openvswitch_trace.h"
+
+#endif
diff --git a/net/openvswitch/openvswitch_trace.h b/net/openvswitch/openvswitch_trace.h
new file mode 100644
index 000000000000..3eb35d9eb700
--- /dev/null
+++ b/net/openvswitch/openvswitch_trace.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM openvswitch
+
+#if !defined(_TRACE_OPENVSWITCH_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_OPENVSWITCH_H
+
+#include <linux/tracepoint.h>
+
+#include "datapath.h"
+
+TRACE_EVENT(ovs_do_execute_action,
+
+	TP_PROTO(struct datapath *dp, struct sk_buff *skb,
+		 struct sw_flow_key *key, const struct nlattr *a, int rem),
+
+	TP_ARGS(dp, skb, key, a, rem),
+
+	TP_STRUCT__entry(
+		__field(	void *,		dpaddr			)
+		__string(	dp_name,	ovs_dp_name(dp)		)
+		__string(	dev_name,	skb->dev->name		)
+		__field(	void *,		skbaddr			)
+		__field(	unsigned int,	len			)
+		__field(	unsigned int,	data_len		)
+		__field(	unsigned int,	truesize		)
+		__field(	u8,		nr_frags		)
+		__field(	u16,		gso_size		)
+		__field(	u16,		gso_type		)
+		__field(	u32,		ovs_flow_hash		)
+		__field(	u32,		recirc_id		)
+		__field(	void *,		keyaddr			)
+		__field(	u16,		key_eth_type		)
+		__field(	u8,		key_ct_state		)
+		__field(	u8,		key_ct_orig_proto	)
+		__field(	u16,		key_ct_zone		)
+		__field(	unsigned int,	flow_key_valid		)
+		__field(	u8,		action_type		)
+		__field(	unsigned int,	action_len		)
+		__field(	void *,		action_data		)
+		__field(	u8,		is_last			)
+	),
+
+	TP_fast_assign(
+		__entry->dpaddr = dp;
+		__assign_str(dp_name, ovs_dp_name(dp));
+		__assign_str(dev_name, skb->dev->name);
+		__entry->skbaddr = skb;
+		__entry->len = skb->len;
+		__entry->data_len = skb->data_len;
+		__entry->truesize = skb->truesize;
+		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
+		__entry->gso_size = skb_shinfo(skb)->gso_size;
+		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->ovs_flow_hash = key->ovs_flow_hash;
+		__entry->recirc_id = key->recirc_id;
+		__entry->keyaddr = key;
+		__entry->key_eth_type = key->eth.type;
+		__entry->key_ct_state = key->ct_state;
+		__entry->key_ct_orig_proto = key->ct_orig_proto;
+		__entry->key_ct_zone = key->ct_zone;
+		__entry->flow_key_valid = !(key->mac_proto & SW_FLOW_KEY_INVALID);
+		__entry->action_type = nla_type(a);
+		__entry->action_len = nla_len(a);
+		__entry->action_data = nla_data(a);
+		__entry->is_last = nla_is_last(a, rem);
+	),
+
+	TP_printk("dpaddr=%p dp_name=%s dev=%s skbaddr=%p len=%u data_len=%u truesize=%u nr_frags=%d gso_size=%d gso_type=%#x ovs_flow_hash=0x%08x recirc_id=0x%08x keyaddr=%p eth_type=0x%04x ct_state=%02x ct_orig_proto=%02x ct_Zone=%04x flow_key_valid=%d action_type=%u action_len=%u action_data=%p is_last=%d",
+		  __entry->dpaddr, __get_str(dp_name), __get_str(dev_name),
+		  __entry->skbaddr, __entry->len, __entry->data_len,
+		  __entry->truesize, __entry->nr_frags, __entry->gso_size,
+		  __entry->gso_type, __entry->ovs_flow_hash,
+		  __entry->recirc_id, __entry->keyaddr, __entry->key_eth_type,
+		  __entry->key_ct_state, __entry->key_ct_orig_proto,
+		  __entry->key_ct_zone,
+		  __entry->flow_key_valid,
+		  __entry->action_type, __entry->action_len,
+		  __entry->action_data, __entry->is_last)
+);
+
+TRACE_EVENT(ovs_dp_upcall,
+
+	TP_PROTO(struct datapath *dp, struct sk_buff *skb,
+		 const struct sw_flow_key *key,
+		 const struct dp_upcall_info *upcall_info),
+
+	TP_ARGS(dp, skb, key, upcall_info),
+
+	TP_STRUCT__entry(
+		__field(	void *,		dpaddr			)
+		__string(	dp_name,	ovs_dp_name(dp)		)
+		__string(	dev_name,	skb->dev->name		)
+		__field(	void *,		skbaddr			)
+		__field(	unsigned int,	len			)
+		__field(	unsigned int,	data_len		)
+		__field(	unsigned int,	truesize		)
+		__field(	u8,		nr_frags		)
+		__field(	u16,		gso_size		)
+		__field(	u16,		gso_type		)
+		__field(	u32,		ovs_flow_hash		)
+		__field(	u32,		recirc_id		)
+		__field(	const void *,	keyaddr			)
+		__field(	u16,		key_eth_type		)
+		__field(	u8,		key_ct_state		)
+		__field(	u8,		key_ct_orig_proto	)
+		__field(	u16,		key_ct_zone		)
+		__field(	unsigned int,	flow_key_valid		)
+		__field(	u8,		upcall_cmd		)
+		__field(	u32,		upcall_port		)
+		__field(	u16,		upcall_mru		)
+	),
+
+	TP_fast_assign(
+		__entry->dpaddr = dp;
+		__assign_str(dp_name, ovs_dp_name(dp));
+		__assign_str(dev_name, skb->dev->name);
+		__entry->skbaddr = skb;
+		__entry->len = skb->len;
+		__entry->data_len = skb->data_len;
+		__entry->truesize = skb->truesize;
+		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
+		__entry->gso_size = skb_shinfo(skb)->gso_size;
+		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->ovs_flow_hash = key->ovs_flow_hash;
+		__entry->recirc_id = key->recirc_id;
+		__entry->keyaddr = key;
+		__entry->key_eth_type = key->eth.type;
+		__entry->key_ct_state = key->ct_state;
+		__entry->key_ct_orig_proto = key->ct_orig_proto;
+		__entry->key_ct_zone = key->ct_zone;
+		__entry->flow_key_valid =  !(key->mac_proto & SW_FLOW_KEY_INVALID);
+		__entry->upcall_cmd = upcall_info->cmd;
+		__entry->upcall_port = upcall_info->portid;
+		__entry->upcall_mru = upcall_info->mru;
+	),
+
+	TP_printk("dpaddr=%p dp_name=%s dev=%s skbaddr=%p len=%u data_len=%u truesize=%u nr_frags=%d gso_size=%d gso_type=%#x ovs_flow_hash=0x%08x recirc_id=0x%08x keyaddr=%p eth_type=0x%04x ct_state=%02x ct_orig_proto=%02x ct_zone=%04x flow_key_valid=%d upcall_cmd=%u upcall_port=%u upcall_mru=%u",
+		  __entry->dpaddr, __get_str(dp_name), __get_str(dev_name),
+		  __entry->skbaddr, __entry->len, __entry->data_len,
+		  __entry->truesize, __entry->nr_frags, __entry->gso_size,
+		  __entry->gso_type, __entry->ovs_flow_hash,
+		  __entry->recirc_id, __entry->keyaddr, __entry->key_eth_type,
+		  __entry->key_ct_state, __entry->key_ct_orig_proto,
+		  __entry->key_ct_zone,
+		  __entry->flow_key_valid,
+		  __entry->upcall_cmd, __entry->upcall_port,
+		  __entry->upcall_mru)
+);
+
+#endif /* _TRACE_OPENVSWITCH_H */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE openvswitch_trace
+#include <trace/define_trace.h>
-- 
2.31.1

