Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6A6336F24
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 10:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhCKJp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 04:45:59 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46613 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232142AbhCKJpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 04:45:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URT4Fz0_1615455935;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URT4Fz0_1615455935)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 17:45:36 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     rostedt@goodmis.org, eric.dumazet@gmail.com, mingo@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] tracing: remove holes in events
Date:   Thu, 11 Mar 2021 17:44:15 +0800
Message-Id: <20210311094414.12774-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some holes in the event definitions, spaces are wasted. Based
on the analysis result of pahole and event format files, 22 events have
more than one hole. To change less and fix worst, 5 events are picked
up and fixed in this patch according the following rules.

Rules:

  - try not to affect reading habit and understanding of the fields;
  - can be completely fixed (all holes are removed);

NOTES:

  - changing the order of event fields breaks API compatibility,
    programs should parse and determine the real data order at runtime,
    instead of hard-coded the order of fields;
  - reduce holes as much as possible when adding / modifying;

Summary (#event_name #before -> #after):

 1. net_dev_start_xmit
    5 holes (10 bytes) -> 0

 2. net_dev_rx_verbose_template
    6 holes (17 bytes) -> 0

 3. tcp_probe
    3 holes (8 bytes) -> 0

 4. qdisc_dequeue
    2 holes (8 bytes) -> 0

 5. rpc_xdr_alignment
    2 holes (8 bytes) -> 0

Link: https://www.spinics.net/lists/netdev/msg726308.html
Link: https://www.spinics.net/lists/netdev/msg726451.html
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/net.h    | 42 +++++++++++++++++------------------
 include/trace/events/qdisc.h  |  4 ++--
 include/trace/events/sunrpc.h |  4 ++--
 include/trace/events/tcp.h    |  2 +-
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 2399073c3afc..b1db7ab88d4b 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -20,18 +20,18 @@ TRACE_EVENT(net_dev_start_xmit,
 	TP_STRUCT__entry(
 		__string(	name,			dev->name	)
 		__field(	u16,			queue_mapping	)
+		__field(	u16,			protocol	)
 		__field(	const void *,		skbaddr		)
+		__field(	u8,			ip_summed	)
 		__field(	bool,			vlan_tagged	)
 		__field(	u16,			vlan_proto	)
 		__field(	u16,			vlan_tci	)
-		__field(	u16,			protocol	)
-		__field(	u8,			ip_summed	)
+		__field(	bool,			transport_offset_valid)
+		__field(	u8,			tx_flags	)
 		__field(	unsigned int,		len		)
 		__field(	unsigned int,		data_len	)
 		__field(	int,			network_offset	)
-		__field(	bool,			transport_offset_valid)
 		__field(	int,			transport_offset)
-		__field(	u8,			tx_flags	)
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_segs	)
 		__field(	u16,			gso_type	)
@@ -40,19 +40,19 @@ TRACE_EVENT(net_dev_start_xmit,
 	TP_fast_assign(
 		__assign_str(name, dev->name);
 		__entry->queue_mapping = skb->queue_mapping;
+		__entry->protocol = ntohs(skb->protocol);
 		__entry->skbaddr = skb;
+		__entry->ip_summed = skb->ip_summed;
 		__entry->vlan_tagged = skb_vlan_tag_present(skb);
 		__entry->vlan_proto = ntohs(skb->vlan_proto);
 		__entry->vlan_tci = skb_vlan_tag_get(skb);
-		__entry->protocol = ntohs(skb->protocol);
-		__entry->ip_summed = skb->ip_summed;
+		__entry->transport_offset_valid =
+			skb_transport_header_was_set(skb);
+		__entry->tx_flags = skb_shinfo(skb)->tx_flags;
 		__entry->len = skb->len;
 		__entry->data_len = skb->data_len;
 		__entry->network_offset = skb_network_offset(skb);
-		__entry->transport_offset_valid =
-			skb_transport_header_was_set(skb);
 		__entry->transport_offset = skb_transport_offset(skb);
-		__entry->tx_flags = skb_shinfo(skb)->tx_flags;
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
@@ -170,23 +170,23 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 	TP_STRUCT__entry(
 		__string(	name,			skb->dev->name	)
 		__field(	unsigned int,		napi_id		)
-		__field(	u16,			queue_mapping	)
 		__field(	const void *,		skbaddr		)
+		__field(	u16,			queue_mapping	)
+		__field(	u8,			ip_summed	)
 		__field(	bool,			vlan_tagged	)
 		__field(	u16,			vlan_proto	)
 		__field(	u16,			vlan_tci	)
 		__field(	u16,			protocol	)
-		__field(	u8,			ip_summed	)
-		__field(	u32,			hash		)
 		__field(	bool,			l4_hash		)
+		__field(	bool,			mac_header_valid)
+		__field(	int,			mac_header	)
 		__field(	unsigned int,		len		)
 		__field(	unsigned int,		data_len	)
 		__field(	unsigned int,		truesize	)
-		__field(	bool,			mac_header_valid)
-		__field(	int,			mac_header	)
-		__field(	unsigned char,		nr_frags	)
+		__field(	u32,			hash		)
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_type	)
+		__field(	unsigned char,		nr_frags	)
 	),
 
 	TP_fast_assign(
@@ -196,23 +196,23 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 #else
 		__entry->napi_id = 0;
 #endif
-		__entry->queue_mapping = skb->queue_mapping;
 		__entry->skbaddr = skb;
+		__entry->queue_mapping = skb->queue_mapping;
+		__entry->ip_summed = skb->ip_summed;
 		__entry->vlan_tagged = skb_vlan_tag_present(skb);
 		__entry->vlan_proto = ntohs(skb->vlan_proto);
 		__entry->vlan_tci = skb_vlan_tag_get(skb);
 		__entry->protocol = ntohs(skb->protocol);
-		__entry->ip_summed = skb->ip_summed;
-		__entry->hash = skb->hash;
 		__entry->l4_hash = skb->l4_hash;
+		__entry->mac_header_valid = skb_mac_header_was_set(skb);
+		__entry->mac_header = skb_mac_header(skb) - skb->data;
 		__entry->len = skb->len;
 		__entry->data_len = skb->data_len;
 		__entry->truesize = skb->truesize;
-		__entry->mac_header_valid = skb_mac_header_was_set(skb);
-		__entry->mac_header = skb_mac_header(skb) - skb->data;
-		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
+		__entry->hash = skb->hash;
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
 	),
 
 	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 330d32d84485..9e7d00256785 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -22,8 +22,8 @@ TRACE_EVENT(qdisc_dequeue,
 		__field(	struct Qdisc *,		qdisc	)
 		__field(const	struct netdev_queue *,	txq	)
 		__field(	int,			packets	)
-		__field(	void *,			skbaddr	)
 		__field(	int,			ifindex	)
+		__field(	void *,			skbaddr	)
 		__field(	u32,			handle	)
 		__field(	u32,			parent	)
 		__field(	unsigned long,		txq_state)
@@ -34,8 +34,8 @@ TRACE_EVENT(qdisc_dequeue,
 		__entry->qdisc		= qdisc;
 		__entry->txq		= txq;
 		__entry->packets	= skb ? packets : 0;
-		__entry->skbaddr	= skb;
 		__entry->ifindex	= txq->dev ? txq->dev->ifindex : 0;
+		__entry->skbaddr	= skb;
 		__entry->handle		= qdisc->handle;
 		__entry->parent		= qdisc->parent;
 		__entry->txq_state	= txq->state;
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 036eb1f5c133..39f4fdcf4d0f 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -715,8 +715,8 @@ TRACE_EVENT(rpc_xdr_alignment,
 		__field(unsigned int, task_id)
 		__field(unsigned int, client_id)
 		__field(int, version)
-		__field(size_t, offset)
 		__field(unsigned int, copied)
+		__field(size_t, offset)
 		__field(const void *, head_base)
 		__field(size_t, head_len)
 		__field(const void *, tail_base)
@@ -739,8 +739,8 @@ TRACE_EVENT(rpc_xdr_alignment,
 		__entry->version = task->tk_client->cl_vers;
 		__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
 
-		__entry->offset = offset;
 		__entry->copied = copied;
+		__entry->offset = offset;
 		__entry->head_base = xdr->buf->head[0].iov_base,
 		__entry->head_len = xdr->buf->head[0].iov_len,
 		__entry->page_len = xdr->buf->page_len,
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index ba94857eea11..831abc267373 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -248,8 +248,8 @@ TRACE_EVENT(tcp_probe,
 		__field(__u16, sport)
 		__field(__u16, dport)
 		__field(__u16, family)
-		__field(__u32, mark)
 		__field(__u16, data_len)
+		__field(__u32, mark)
 		__field(__u32, snd_nxt)
 		__field(__u32, snd_una)
 		__field(__u32, snd_cwnd)
-- 
2.19.1.6.gb485710b

