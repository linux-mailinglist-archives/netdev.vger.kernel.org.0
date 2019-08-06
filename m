Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37EF8308B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732871AbfHFLTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:19:21 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57488 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731281AbfHFLTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:19:02 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x76BJ0Yj023727, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x76BJ0Yj023727
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 6 Aug 2019 19:19:00 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 19:18:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 4/5] r8152: support skb_add_rx_frag
Date:   Tue, 6 Aug 2019 19:18:03 +0800
Message-ID: <1394712342-15778-293-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-289-albertk@realtek.com>
References: <1394712342-15778-289-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_add_rx_frag() to reduce the memory copy for rx data.

Use a new list of rx_used to store the rx buffer which couldn't be
reused yet.

Besides, the total number of rx buffer may be increased or decreased
dynamically. And it is limited by RTL8152_MAX_RX_AGG.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 122 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 108 insertions(+), 14 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 401e56112365..1615900c8592 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -584,6 +584,9 @@ enum rtl_register_content {
 #define TX_ALIGN		4
 #define RX_ALIGN		8
 
+#define RTL8152_MAX_RX_AGG	(10 * RTL8152_MAX_RX)
+#define RTL8152_RXFG_HEADSZ	256
+
 #define INTR_LINK		0x0004
 
 #define RTL8152_REQT_READ	0xc0
@@ -720,7 +723,7 @@ struct r8152 {
 	struct net_device *netdev;
 	struct urb *intr_urb;
 	struct tx_agg tx_info[RTL8152_MAX_TX];
-	struct list_head rx_info;
+	struct list_head rx_info, rx_used;
 	struct list_head rx_done, tx_free;
 	struct sk_buff_head tx_queue, rx_queue;
 	spinlock_t rx_lock, tx_lock;
@@ -1476,7 +1479,7 @@ static void free_rx_agg(struct r8152 *tp, struct rx_agg *agg)
 	list_del(&agg->info_list);
 
 	usb_free_urb(agg->urb);
-	__free_pages(agg->page, get_order(tp->rx_buf_sz));
+	put_page(agg->page);
 	kfree(agg);
 
 	atomic_dec(&tp->rx_count);
@@ -1493,7 +1496,7 @@ static struct rx_agg *alloc_rx_agg(struct r8152 *tp, gfp_t mflags)
 	if (rx_agg) {
 		unsigned long flags;
 
-		rx_agg->page = alloc_pages(mflags, order);
+		rx_agg->page = alloc_pages(mflags | __GFP_COMP, order);
 		if (!rx_agg->page)
 			goto free_rx;
 
@@ -1951,6 +1954,50 @@ static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
 	return checksum;
 }
 
+static inline bool rx_count_exceed(struct r8152 *tp)
+{
+	return atomic_read(&tp->rx_count) > RTL8152_MAX_RX;
+}
+
+static inline int agg_offset(struct rx_agg *agg, void *addr)
+{
+	return (int)(addr - agg->buffer);
+}
+
+static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
+{
+	struct list_head *cursor, *next;
+	struct rx_agg *agg_free = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->rx_lock, flags);
+
+	list_for_each_safe(cursor, next, &tp->rx_used) {
+		struct rx_agg *agg;
+
+		agg = list_entry(cursor, struct rx_agg, list);
+
+		if (page_count(agg->page) == 1) {
+			if (!agg_free) {
+				list_del_init(cursor);
+				agg_free = agg;
+				continue;
+			} else if (rx_count_exceed(tp)) {
+				list_del_init(cursor);
+				free_rx_agg(tp, agg);
+			}
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&tp->rx_lock, flags);
+
+	if (!agg_free && atomic_read(&tp->rx_count) < RTL8152_MAX_RX_AGG)
+		agg_free = alloc_rx_agg(tp, mflags);
+
+	return agg_free;
+}
+
 static int rx_bottom(struct r8152 *tp, int budget)
 {
 	unsigned long flags;
@@ -1986,7 +2033,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 
 	list_for_each_safe(cursor, next, &rx_queue) {
 		struct rx_desc *rx_desc;
-		struct rx_agg *agg;
+		struct rx_agg *agg, *agg_next;
 		int len_used = 0;
 		struct urb *urb;
 		u8 *rx_data;
@@ -1998,6 +2045,8 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		if (urb->actual_length < ETH_ZLEN)
 			goto submit;
 
+		agg_next = rtl_get_free_rx(tp, GFP_ATOMIC);
+
 		rx_desc = agg->buffer;
 		rx_data = agg->buffer;
 		len_used += sizeof(struct rx_desc);
@@ -2005,7 +2054,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		while (urb->actual_length > len_used) {
 			struct net_device *netdev = tp->netdev;
 			struct net_device_stats *stats = &netdev->stats;
-			unsigned int pkt_len;
+			unsigned int pkt_len, rx_frag_head_sz;
 			struct sk_buff *skb;
 
 			/* limite the skb numbers for rx_queue */
@@ -2023,22 +2072,37 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			pkt_len -= ETH_FCS_LEN;
 			rx_data += sizeof(struct rx_desc);
 
-			skb = napi_alloc_skb(napi, pkt_len);
+			if (!agg_next || RTL8152_RXFG_HEADSZ > pkt_len)
+				rx_frag_head_sz = pkt_len;
+			else
+				rx_frag_head_sz = RTL8152_RXFG_HEADSZ;
+
+			skb = napi_alloc_skb(napi, rx_frag_head_sz);
 			if (!skb) {
 				stats->rx_dropped++;
 				goto find_next_rx;
 			}
 
 			skb->ip_summed = r8152_rx_csum(tp, rx_desc);
-			memcpy(skb->data, rx_data, pkt_len);
-			skb_put(skb, pkt_len);
+			memcpy(skb->data, rx_data, rx_frag_head_sz);
+			skb_put(skb, rx_frag_head_sz);
+			pkt_len -= rx_frag_head_sz;
+			rx_data += rx_frag_head_sz;
+			if (pkt_len) {
+				skb_add_rx_frag(skb, 0, agg->page,
+						agg_offset(agg, rx_data),
+						pkt_len,
+						SKB_DATA_ALIGN(pkt_len));
+				get_page(agg->page);
+			}
+
 			skb->protocol = eth_type_trans(skb, netdev);
 			rtl_rx_vlan_tag(rx_desc, skb);
 			if (work_done < budget) {
 				napi_gro_receive(napi, skb);
 				work_done++;
 				stats->rx_packets++;
-				stats->rx_bytes += pkt_len;
+				stats->rx_bytes += skb->len;
 			} else {
 				__skb_queue_tail(&tp->rx_queue, skb);
 			}
@@ -2046,10 +2110,24 @@ static int rx_bottom(struct r8152 *tp, int budget)
 find_next_rx:
 			rx_data = rx_agg_align(rx_data + pkt_len + ETH_FCS_LEN);
 			rx_desc = (struct rx_desc *)rx_data;
-			len_used = (int)(rx_data - (u8 *)agg->buffer);
+			len_used = agg_offset(agg, rx_data);
 			len_used += sizeof(struct rx_desc);
 		}
 
+		WARN_ON(!agg_next && page_count(agg->page) > 1);
+
+		if (agg_next) {
+			spin_lock_irqsave(&tp->rx_lock, flags);
+			if (page_count(agg->page) == 1) {
+				list_add(&agg_next->list, &tp->rx_used);
+			} else {
+				list_add_tail(&agg->list, &tp->rx_used);
+				agg = agg_next;
+				urb = agg->urb;
+			}
+			spin_unlock_irqrestore(&tp->rx_lock, flags);
+		}
+
 submit:
 		if (!ret) {
 			ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
@@ -2376,13 +2454,14 @@ static int rtl_start_rx(struct r8152 *tp)
 {
 	struct list_head *cursor, *next, tmp_list;
 	unsigned long flags;
-	int ret = 0;
+	int ret = 0, i = 0;
 
 	INIT_LIST_HEAD(&tmp_list);
 
 	spin_lock_irqsave(&tp->rx_lock, flags);
 
 	INIT_LIST_HEAD(&tp->rx_done);
+	INIT_LIST_HEAD(&tp->rx_used);
 
 	list_splice_init(&tp->rx_info, &tmp_list);
 
@@ -2394,10 +2473,18 @@ static int rtl_start_rx(struct r8152 *tp)
 		agg = list_entry(cursor, struct rx_agg, info_list);
 		INIT_LIST_HEAD(&agg->list);
 
-		if (ret < 0)
+		/* Only RTL8152_MAX_RX rx_agg need to be submitted. */
+		if (++i > RTL8152_MAX_RX) {
+			spin_lock_irqsave(&tp->rx_lock, flags);
+			list_add_tail(&agg->list, &tp->rx_used);
+			spin_unlock_irqrestore(&tp->rx_lock, flags);
+		} else if (unlikely(ret < 0)) {
+			spin_lock_irqsave(&tp->rx_lock, flags);
 			list_add_tail(&agg->list, &tp->rx_done);
-		else
+			spin_unlock_irqrestore(&tp->rx_lock, flags);
+		} else {
 			ret = r8152_submit_rx(tp, agg, GFP_KERNEL);
+		}
 	}
 
 	spin_lock_irqsave(&tp->rx_lock, flags);
@@ -2429,7 +2516,14 @@ static int rtl_stop_rx(struct r8152 *tp)
 		struct rx_agg *agg;
 
 		agg = list_entry(cursor, struct rx_agg, info_list);
-		usb_kill_urb(agg->urb);
+
+		/* At least RTL8152_MAX_RX rx_agg have the page_count being
+		 * equal to 1, so the other ones could be freed safely.
+		 */
+		if (page_count(agg->page) > 1)
+			free_rx_agg(tp, agg);
+		else
+			usb_kill_urb(agg->urb);
 	}
 
 	/* Move back the list of temp to the rx_info */
-- 
2.21.0

