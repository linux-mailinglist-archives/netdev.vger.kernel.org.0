Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC6D331E0A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 05:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCIEpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 23:45:30 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:51694 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230058AbhCIEpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 23:45:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UR1RlrC_1615265117;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UR1RlrC_1615265117)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Mar 2021 12:45:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: add net namespace inode for all net_dev events
Date:   Tue,  9 Mar 2021 12:43:50 +0800
Message-Id: <20210309044349.6605-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are lots of net namespaces on the host runs containers like k8s.
It is very common to see the same interface names among different net
namespaces, such as eth0. It is not possible to distinguish them without
net namespace inode.

This adds net namespace inode for all net_dev events, help us
distinguish between different net devices.

Output:
  <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/net.h | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 2399073c3afc..a52f90d83411 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -35,6 +35,7 @@ TRACE_EVENT(net_dev_start_xmit,
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_segs	)
 		__field(	u16,			gso_type	)
+		__field(	unsigned int,		net_inum	)
 	),
 
 	TP_fast_assign(
@@ -56,10 +57,12 @@ TRACE_EVENT(net_dev_start_xmit,
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->net_inum = dev_net(skb->dev)->ns.inum;
 	),
 
-	TP_printk("dev=%s queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x",
-		  __get_str(name), __entry->queue_mapping, __entry->skbaddr,
+	TP_printk("net_inum=%u dev=%s queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x",
+		  __entry->net_inum, __get_str(name), __entry->queue_mapping,
+		  __entry->skbaddr,
 		  __entry->vlan_tagged, __entry->vlan_proto, __entry->vlan_tci,
 		  __entry->protocol, __entry->ip_summed, __entry->len,
 		  __entry->data_len,
@@ -82,6 +85,7 @@ TRACE_EVENT(net_dev_xmit,
 		__field(	unsigned int,	len		)
 		__field(	int,		rc		)
 		__string(	name,		dev->name	)
+		__field(	unsigned int,	net_inum	)
 	),
 
 	TP_fast_assign(
@@ -89,10 +93,12 @@ TRACE_EVENT(net_dev_xmit,
 		__entry->len = skb_len;
 		__entry->rc = rc;
 		__assign_str(name, dev->name);
+		__entry->net_inum = dev_net(skb->dev)->ns.inum;
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
-		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
+	TP_printk("net_inum=%u dev=%s skbaddr=%p len=%u rc=%d",
+		__entry->net_inum, __get_str(name), __entry->skbaddr,
+		__entry->len, __entry->rc)
 );
 
 TRACE_EVENT(net_dev_xmit_timeout,
@@ -106,16 +112,19 @@ TRACE_EVENT(net_dev_xmit_timeout,
 		__string(	name,		dev->name	)
 		__string(	driver,		netdev_drivername(dev))
 		__field(	int,		queue_index	)
+		__field(	unsigned int,	net_inum	)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, dev->name);
 		__assign_str(driver, netdev_drivername(dev));
 		__entry->queue_index = queue_index;
+		__entry->net_inum = dev_net(dev)->ns.inum;
 	),
 
-	TP_printk("dev=%s driver=%s queue=%d",
-		__get_str(name), __get_str(driver), __entry->queue_index)
+	TP_printk("net_inum=%u dev=%s driver=%s queue=%d",
+		__entry->net_inum, __get_str(name), __get_str(driver),
+		__entry->queue_index)
 );
 
 DECLARE_EVENT_CLASS(net_dev_template,
@@ -128,16 +137,19 @@ DECLARE_EVENT_CLASS(net_dev_template,
 		__field(	void *,		skbaddr		)
 		__field(	unsigned int,	len		)
 		__string(	name,		skb->dev->name	)
+		__field(	unsigned int,	net_inum	)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->len = skb->len;
 		__assign_str(name, skb->dev->name);
+		__entry->net_inum = dev_net(skb->dev)->ns.inum;
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u",
-		__get_str(name), __entry->skbaddr, __entry->len)
+	TP_printk("net_inum=%u dev=%s skbaddr=%p len=%u",
+		__entry->net_inum, __get_str(name), __entry->skbaddr,
+		__entry->len)
 )
 
 DEFINE_EVENT(net_dev_template, net_dev_queue,
@@ -187,6 +199,7 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 		__field(	unsigned char,		nr_frags	)
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_type	)
+		__field(	unsigned int,		net_inum	)
 	),
 
 	TP_fast_assign(
@@ -213,10 +226,12 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->net_inum = dev_net(skb->dev)->ns.inum;
 	),
 
-	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
-		  __get_str(name), __entry->napi_id, __entry->queue_mapping,
+	TP_printk("net_inum=%u dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
+		  __entry->net_inum, __get_str(name), __entry->napi_id,
+		  __entry->queue_mapping,
 		  __entry->skbaddr, __entry->vlan_tagged, __entry->vlan_proto,
 		  __entry->vlan_tci, __entry->protocol, __entry->ip_summed,
 		  __entry->hash, __entry->l4_hash, __entry->len,
-- 
2.19.1.6.gb485710b

