Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654698AD44
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 05:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfHMDmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 23:42:43 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39393 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfHMDmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 23:42:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7D3geD9011971, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7D3geD9011971
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 13 Aug 2019 11:42:40 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 13 Aug 2019
 11:42:39 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 3/5] r8152: use alloc_pages for rx buffer
Date:   Tue, 13 Aug 2019 11:42:07 +0800
Message-ID: <1394712342-15778-298-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-295-albertk@realtek.com>
References: <1394712342-15778-289-Taiwan-albertk@realtek.com>
 <1394712342-15778-295-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace kmalloc_node() with alloc_pages() for rx buffer.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d063c9b358e5..f41cb728e999 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -698,8 +698,8 @@ struct rx_agg {
 	struct list_head list, info_list;
 	struct urb *urb;
 	struct r8152 *context;
+	struct page *page;
 	void *buffer;
-	void *head;
 };
 
 struct tx_agg {
@@ -1476,7 +1476,7 @@ static void free_rx_agg(struct r8152 *tp, struct rx_agg *agg)
 	list_del(&agg->info_list);
 
 	usb_free_urb(agg->urb);
-	kfree(agg->buffer);
+	__free_pages(agg->page, get_order(tp->rx_buf_sz));
 	kfree(agg);
 
 	atomic_dec(&tp->rx_count);
@@ -1486,28 +1486,19 @@ static struct rx_agg *alloc_rx_agg(struct r8152 *tp, gfp_t mflags)
 {
 	struct net_device *netdev = tp->netdev;
 	int node = netdev->dev.parent ? dev_to_node(netdev->dev.parent) : -1;
+	unsigned int order = get_order(tp->rx_buf_sz);
 	struct rx_agg *rx_agg;
 	unsigned long flags;
-	u8 *buf;
 
 	rx_agg = kmalloc_node(sizeof(*rx_agg), mflags, node);
 	if (!rx_agg)
 		return NULL;
 
-	buf = kmalloc_node(tp->rx_buf_sz, mflags, node);
-	if (!buf)
+	rx_agg->page = alloc_pages(mflags, order);
+	if (!rx_agg->page)
 		goto free_rx;
 
-	if (buf != rx_agg_align(buf)) {
-		kfree(buf);
-		buf = kmalloc_node(tp->rx_buf_sz + RX_ALIGN, mflags,
-				   node);
-		if (!buf)
-			goto free_rx;
-	}
-
-	rx_agg->buffer = buf;
-	rx_agg->head = rx_agg_align(buf);
+	rx_agg->buffer = page_address(rx_agg->page);
 
 	rx_agg->urb = usb_alloc_urb(0, mflags);
 	if (!rx_agg->urb)
@@ -1526,7 +1517,7 @@ static struct rx_agg *alloc_rx_agg(struct r8152 *tp, gfp_t mflags)
 	return rx_agg;
 
 free_buf:
-	kfree(rx_agg->buffer);
+	__free_pages(rx_agg->page, order);
 free_rx:
 	kfree(rx_agg);
 	return NULL;
@@ -2003,8 +1994,8 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		if (urb->actual_length < ETH_ZLEN)
 			goto submit;
 
-		rx_desc = agg->head;
-		rx_data = agg->head;
+		rx_desc = agg->buffer;
+		rx_data = agg->buffer;
 		len_used += sizeof(struct rx_desc);
 
 		while (urb->actual_length > len_used) {
@@ -2051,7 +2042,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 find_next_rx:
 			rx_data = rx_agg_align(rx_data + pkt_len + ETH_FCS_LEN);
 			rx_desc = (struct rx_desc *)rx_data;
-			len_used = (int)(rx_data - (u8 *)agg->head);
+			len_used = (int)(rx_data - (u8 *)agg->buffer);
 			len_used += sizeof(struct rx_desc);
 		}
 
@@ -2162,7 +2153,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 		return 0;
 
 	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
-			  agg->head, tp->rx_buf_sz,
+			  agg->buffer, tp->rx_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
 
 	ret = usb_submit_urb(agg->urb, mem_flags);
-- 
2.21.0

