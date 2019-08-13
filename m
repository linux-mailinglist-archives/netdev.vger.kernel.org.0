Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC34B8AD38
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 05:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfHMDmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 23:42:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39390 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMDmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 23:42:38 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7D3gbgn011963, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7D3gbgn011963
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 13 Aug 2019 11:42:37 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Tue, 13 Aug 2019
 11:42:35 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 1/5] r8152: separate the rx buffer size
Date:   Tue, 13 Aug 2019 11:42:05 +0800
Message-ID: <1394712342-15778-296-albertk@realtek.com>
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

The different chips may accept different rx buffer sizes. The RTL8152
supports 16K bytes, and RTL8153 support 32K bytes.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0cc03a9ff545..94da79028a65 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -749,6 +749,7 @@ struct r8152 {
 	u32 msg_enable;
 	u32 tx_qlen;
 	u32 coalesce;
+	u32 rx_buf_sz;
 	u16 ocp_base;
 	u16 speed;
 	u8 *intr_buff;
@@ -1516,13 +1517,13 @@ static int alloc_all_mem(struct r8152 *tp)
 	skb_queue_head_init(&tp->rx_queue);
 
 	for (i = 0; i < RTL8152_MAX_RX; i++) {
-		buf = kmalloc_node(agg_buf_sz, GFP_KERNEL, node);
+		buf = kmalloc_node(tp->rx_buf_sz, GFP_KERNEL, node);
 		if (!buf)
 			goto err1;
 
 		if (buf != rx_agg_align(buf)) {
 			kfree(buf);
-			buf = kmalloc_node(agg_buf_sz + RX_ALIGN, GFP_KERNEL,
+			buf = kmalloc_node(tp->rx_buf_sz + RX_ALIGN, GFP_KERNEL,
 					   node);
 			if (!buf)
 				goto err1;
@@ -2113,7 +2114,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 		return 0;
 
 	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
-			  agg->head, agg_buf_sz,
+			  agg->head, tp->rx_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
 
 	ret = usb_submit_urb(agg->urb, mem_flags);
@@ -2447,7 +2448,7 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 
 static void r8153_set_rx_early_size(struct r8152 *tp)
 {
-	u32 ocp_data = agg_buf_sz - rx_reserved_size(tp->netdev->mtu);
+	u32 ocp_data = tp->rx_buf_sz - rx_reserved_size(tp->netdev->mtu);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5115,6 +5116,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8152_in_nway;
 		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl_runtime_suspend_enable;
+		tp->rx_buf_sz		= 16 * 1024;
 		break;
 
 	case RTL_VER_03:
@@ -5132,6 +5134,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
+		tp->rx_buf_sz		= 32 * 1024;
 		break;
 
 	case RTL_VER_08:
@@ -5147,6 +5150,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
+		tp->rx_buf_sz		= 32 * 1024;
 		break;
 
 	default:
-- 
2.21.0

