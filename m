Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63430691B45
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjBJJ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjBJJ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:27:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF634020
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 01:27:08 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pQPgI-0003Uq-2o; Fri, 10 Feb 2023 10:26:58 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQPg9-003w64-Pf; Fri, 10 Feb 2023 10:26:50 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQPg9-002tIF-VJ; Fri, 10 Feb 2023 10:26:49 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] wifi: rtw88: usb: Fix urbs with size multiple of bulkout_size
Date:   Fri, 10 Feb 2023 10:26:42 +0100
Message-Id: <20230210092642.685905-3-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230210092642.685905-1-s.hauer@pengutronix.de>
References: <20230210092642.685905-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware can't handle urbs with a data size of multiple of
bulkout_size. With such a packet the endpoint gets stuck and only
replugging the hardware helps.

Fix this by moving the header eight bytes down, thus making the packet
eight bytes bigger. The same is done in rtw_usb_write_data_rsvd_page()
already, but not yet for the tx data.

Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/tx.h  |  2 ++
 drivers/net/wireless/realtek/rtw88/usb.c | 34 +++++++++++++++---------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index a2f3ac326041b..38ce9c7ae62ed 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -75,6 +75,8 @@
 	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(15, 0))
 #define SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)				\
 	le32p_replace_bits((__le32 *)(txdesc) + 0x07, value, GENMASK(31, 24))
+#define GET_TX_DESC_OFFSET(txdesc)	                                      \
+	le32_get_bits(*((__le32 *)(txdesc) + 0x00), GENMASK(23, 16))
 #define GET_TX_DESC_PKT_OFFSET(txdesc)						\
 	le32_get_bits(*((__le32 *)(txdesc) + 0x01), GENMASK(28, 24))
 #define GET_TX_DESC_QSEL(txdesc)						\
diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index d9e995544e405..08cd480958b6b 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -281,6 +281,7 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
 static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list)
 {
 	struct rtw_dev *rtwdev = rtwusb->rtwdev;
+	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_usb_txcb *txcb;
 	struct sk_buff *skb_head;
 	struct sk_buff *skb_iter;
@@ -299,16 +300,11 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 
 	skb_iter = skb_dequeue(list);
 
-	if (skb_queue_empty(list)) {
-		skb_head = skb_iter;
-		goto queue;
-	}
-
 	skb_head = dev_alloc_skb(RTW_USB_MAX_XMITBUF_SZ);
-	if (!skb_head) {
-		skb_head = skb_iter;
-		goto queue;
-	}
+	if (!skb_head)
+		return false;
+
+	skb_reserve(skb_head, RTW_USB_PACKET_OFFSET_SZ);
 
 	while (skb_iter) {
 		unsigned long flags;
@@ -326,17 +322,31 @@ static bool rtw_usb_tx_agg_skb(struct rtw_usb *rtwusb, struct sk_buff_head *list
 
 		skb_iter = skb_peek(list);
 
-		if (skb_iter && skb_iter->len + skb_head->len <= RTW_USB_MAX_XMITBUF_SZ)
+		if (skb_iter && skb_iter->len + skb_head->len <=
+		    RTW_USB_MAX_XMITBUF_SZ - RTW_USB_PACKET_OFFSET_SZ)
 			__skb_unlink(skb_iter, list);
 		else
 			skb_iter = NULL;
 		spin_unlock_irqrestore(&list->lock, flags);
 	}
 
-	if (agg_num > 1)
+	if (skb_head->len % rtwusb->bulkout_size == 0) {
+		unsigned int offset;
+
+		skb_push(skb_head, RTW_USB_PACKET_OFFSET_SZ);
+
+		memmove(skb_head->data, skb_head->data + 8, chip->tx_pkt_desc_sz);
+
+		offset = GET_TX_DESC_OFFSET(skb_head->data);
+		offset += RTW_USB_PACKET_OFFSET_SZ;
+		SET_TX_DESC_OFFSET(skb_head->data, offset);
+
+		SET_TX_DESC_PKT_OFFSET(skb_head->data, 1);
+		rtw_usb_fill_tx_checksum(rtwusb, skb_head, agg_num);
+	} else if (agg_num > 1) {
 		rtw_usb_fill_tx_checksum(rtwusb, skb_head, agg_num);
+	}
 
-queue:
 	skb_queue_tail(&txcb->tx_ack_queue, skb_head);
 
 	rtw_usb_write_port(rtwdev, GET_TX_DESC_QSEL(skb_head->data), skb_head,
-- 
2.30.2

