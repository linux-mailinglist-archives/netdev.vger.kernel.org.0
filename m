Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01678445378
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhKDNDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:03:48 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:23106 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhKDNDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:03:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uv1XvRz_1636030867;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uv1XvRz_1636030867)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Nov 2021 21:01:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: Add net_cookie to distinguish devices in tracepoints
Date:   Thu,  4 Nov 2021 20:56:00 +0800
Message-Id: <20211104125559.49035-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is common to see that there are net devices with the same name (like
eth0, eth1) in different net namespaces, especially the host runs lots
of containers. It is hard to distinguish which net namespace it belongs
to in tracepoints.

This adds net_cookie for all net_dev events which print dev name. The
net_cookie is granted to be unique and not be reused in different net
namespaces. Userspace applications can get net_cookie by getsockopt()
with SO_NETNS_COOKIE.

Link: https://www.spinics.net/lists/netdev/msg726327.html
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/trace/events/net.h | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 78c448c6ab4c..365f3193ab78 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -35,6 +35,7 @@ TRACE_EVENT(net_dev_start_xmit,
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_segs	)
 		__field(	u16,			gso_type	)
+		__field(	u64,			net_cookie	)
 	),
 
 	TP_fast_assign(
@@ -56,16 +57,18 @@ TRACE_EVENT(net_dev_start_xmit,
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->net_cookie = dev_net(dev)->net_cookie;
 	),
 
-	TP_printk("dev=%s queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x",
+	TP_printk("dev=%s queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d len=%u data_len=%u network_offset=%d transport_offset_valid=%d transport_offset=%d tx_flags=%d gso_size=%d gso_segs=%d gso_type=%#x net_cookie=%llu",
 		  __get_str(name), __entry->queue_mapping, __entry->skbaddr,
 		  __entry->vlan_tagged, __entry->vlan_proto, __entry->vlan_tci,
 		  __entry->protocol, __entry->ip_summed, __entry->len,
 		  __entry->data_len,
 		  __entry->network_offset, __entry->transport_offset_valid,
 		  __entry->transport_offset, __entry->tx_flags,
-		  __entry->gso_size, __entry->gso_segs, __entry->gso_type)
+		  __entry->gso_size, __entry->gso_segs, __entry->gso_type,
+		  __entry->net_cookie)
 );
 
 TRACE_EVENT(net_dev_xmit,
@@ -82,6 +85,7 @@ TRACE_EVENT(net_dev_xmit,
 		__field(	unsigned int,	len		)
 		__field(	int,		rc		)
 		__string(	name,		dev->name	)
+		__field(	u64,		net_cookie	)
 	),
 
 	TP_fast_assign(
@@ -89,10 +93,12 @@ TRACE_EVENT(net_dev_xmit,
 		__entry->len = skb_len;
 		__entry->rc = rc;
 		__assign_str(name, dev->name);
+		__entry->net_cookie = dev_net(dev)->net_cookie;
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
-		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
+	TP_printk("dev=%s skbaddr=%p len=%u rc=%d net_cookie=%llu",
+		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc,
+		__entry->net_cookie)
 );
 
 TRACE_EVENT(net_dev_xmit_timeout,
@@ -106,16 +112,19 @@ TRACE_EVENT(net_dev_xmit_timeout,
 		__string(	name,		dev->name	)
 		__string(	driver,		netdev_drivername(dev))
 		__field(	int,		queue_index	)
+		__field(	u64,		net_cookie	)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, dev->name);
 		__assign_str(driver, netdev_drivername(dev));
 		__entry->queue_index = queue_index;
+		__entry->net_cookie = dev_net(dev)->net_cookie;
 	),
 
-	TP_printk("dev=%s driver=%s queue=%d",
-		__get_str(name), __get_str(driver), __entry->queue_index)
+	TP_printk("dev=%s driver=%s queue=%d net_cookie=%llu",
+		__get_str(name), __get_str(driver), __entry->queue_index,
+		__entry->net_cookie)
 );
 
 DECLARE_EVENT_CLASS(net_dev_template,
@@ -128,16 +137,19 @@ DECLARE_EVENT_CLASS(net_dev_template,
 		__field(	void *,		skbaddr		)
 		__field(	unsigned int,	len		)
 		__string(	name,		skb->dev->name	)
+		__field(	u64,		net_cookie	)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->len = skb->len;
 		__assign_str(name, skb->dev->name);
+		__entry->net_cookie = dev_net(skb->dev)->net_cookie;
 	),
 
-	TP_printk("dev=%s skbaddr=%px len=%u",
-		__get_str(name), __entry->skbaddr, __entry->len)
+	TP_printk("dev=%s skbaddr=%px len=%u net_cookie=%llu",
+		__get_str(name), __entry->skbaddr, __entry->len,
+		__entry->net_cookie)
 )
 
 DEFINE_EVENT(net_dev_template, net_dev_queue,
@@ -187,6 +199,7 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 		__field(	unsigned char,		nr_frags	)
 		__field(	u16,			gso_size	)
 		__field(	u16,			gso_type	)
+		__field(	u64,			net_cookie	)
 	),
 
 	TP_fast_assign(
@@ -213,16 +226,18 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
 		__entry->gso_size = skb_shinfo(skb)->gso_size;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->net_cookie = dev_net(skb->dev)->net_cookie;
 	),
 
-	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x",
+	TP_printk("dev=%s napi_id=%#x queue_mapping=%u skbaddr=%p vlan_tagged=%d vlan_proto=0x%04x vlan_tci=0x%04x protocol=0x%04x ip_summed=%d hash=0x%08x l4_hash=%d len=%u data_len=%u truesize=%u mac_header_valid=%d mac_header=%d nr_frags=%d gso_size=%d gso_type=%#x net_cookie=%llu",
 		  __get_str(name), __entry->napi_id, __entry->queue_mapping,
 		  __entry->skbaddr, __entry->vlan_tagged, __entry->vlan_proto,
 		  __entry->vlan_tci, __entry->protocol, __entry->ip_summed,
 		  __entry->hash, __entry->l4_hash, __entry->len,
 		  __entry->data_len, __entry->truesize,
 		  __entry->mac_header_valid, __entry->mac_header,
-		  __entry->nr_frags, __entry->gso_size, __entry->gso_type)
+		  __entry->nr_frags, __entry->gso_size, __entry->gso_type,
+		  __entry->net_cookie)
 );
 
 DEFINE_EVENT(net_dev_rx_verbose_template, napi_gro_frags_entry,
-- 
2.19.1.6.gb485710b

