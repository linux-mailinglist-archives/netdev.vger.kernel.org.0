Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498EA29004D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 10:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405258AbgJPI6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 04:58:24 -0400
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:49622 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405247AbgJPI6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 04:58:23 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id DD9FC181D337B;
        Fri, 16 Oct 2020 08:58:21 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:69:355:379:599:960:966:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2640:2828:2898:2914:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:4250:4321:4385:4605:5007:6119:7875:7904:8957:10004:10848:11026:11232:11233:11473:11657:11658:11914:12043:12294:12296:12297:12438:12555:12683:12740:12760:12895:12986:13439:14096:14097:14196:14659:21080:21433:21451:21627:21740:21966:21987:21990:30046:30054:30070:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: club46_5c0ac3b2721b
X-Filterd-Recvd-Size: 16059
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Fri, 16 Oct 2020 08:58:19 +0000 (UTC)
Message-ID: <4676eb63d9aa5b9e532b580bd491527d9ed08535.camel@perches.com>
Subject: Re: [PATCH] [v4] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Fri, 16 Oct 2020 01:58:18 -0700
In-Reply-To: <20201016063444.29822-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20201016063444.29822-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-16 at 12:04 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.

Suggested neatening patch on top of this:

o Use include "usb.h" instead of direct extern
o Prefix purelifi to speed and send_packet_from_data_queue functions
  to remove generic global function naming
o Use enum instead of macro defines for MODULATION_RATE_<foo>
o Simplify the (mac->chip->)usb->tx. uses with a temporary
o Use continue in loops instead of extra indentation
o Remove unnecessary %hx printf formatting, use %x

---
 drivers/net/wireless/purelifi/chip.c |  4 +-
 drivers/net/wireless/purelifi/mac.c  | 60 +++++++++++--------------
 drivers/net/wireless/purelifi/mac.h  | 22 ++++-----
 drivers/net/wireless/purelifi/usb.c  | 86 ++++++++++++++++--------------------
 drivers/net/wireless/purelifi/usb.h  |  4 +-
 5 files changed, 80 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
index 9ad2664b7542..cca03697cb06 100644
--- a/drivers/net/wireless/purelifi/chip.c
+++ b/drivers/net/wireless/purelifi/chip.c
@@ -42,12 +42,12 @@ int purelifi_chip_init_hw(struct purelifi_chip *chip)
 	u8 *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
 	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
 
-	pr_info("purelifi chip %02hx:%02hx v%02hx  %02x-%02x-%02x %s\n",
+	pr_info("purelifi chip %02x:%02x v%02x  %02x-%02x-%02x %s\n",
 		le16_to_cpu(udev->descriptor.idVendor),
 		le16_to_cpu(udev->descriptor.idProduct),
 		le16_to_cpu(udev->descriptor.bcdDevice),
 		addr[0], addr[1], addr[2],
-		speed(udev->speed));
+		purelifi_speed(udev->speed));
 
 	return purelifi_set_beacon_interval(chip, 100, 0, 0);
 }
diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
index 6920a1dfd599..09b7c2c0050d 100644
--- a/drivers/net/wireless/purelifi/mac.c
+++ b/drivers/net/wireless/purelifi/mac.c
@@ -10,6 +10,7 @@
 
 #include "chip.h"
 #include "mac.h"
+#include "usb.h"
 
 #ifndef IEEE80211_BAND_2GHZ
 #define IEEE80211_BAND_2GHZ NL80211_BAND_2GHZ
@@ -332,7 +333,6 @@ static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)
 	return 0;
 }
 
-extern void send_packet_from_data_queue(struct purelifi_usb *usb);
 /**
  * purelifi_op_tx - transmits a network frame to the device
  *
@@ -366,16 +366,15 @@ static void purelifi_op_tx(struct ieee80211_hw *hw,
 		u8 dst_mac[ETH_ALEN];
 		u8 sidx;
 		bool found = false;
+		struct purelifi_usb_tx *tx = &usb->tx;
 
 		memcpy(dst_mac, &skb->data[28], ETH_ALEN);
 		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
-			if (usb->tx.station[sidx].flag &
-					STATION_CONNECTED_FLAG) {
-				if (!memcmp(usb->tx.station[sidx].mac,
-					    dst_mac, ETH_ALEN)) {
-					found = true;
-					break;
-				}
+			if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+				continue;
+			if (!memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN)) {
+				found = true;
+				break;
 			}
 		}
 
@@ -384,13 +383,13 @@ static void purelifi_op_tx(struct ieee80211_hw *hw,
 			sidx = STA_BROADCAST_INDEX;
 
 		/* Stop OS from sending packets, if the queue is half full */
-		if (skb_queue_len(&usb->tx.station[sidx].data_list) > 60)
-			block_queue(usb, usb->tx.station[sidx].mac, true);
+		if (skb_queue_len(&tx->station[sidx].data_list) > 60)
+			block_queue(usb, tx->station[sidx].mac, true);
 
 		/* Schedule packet for transmission if queue is not full */
-		if (skb_queue_len(&usb->tx.station[sidx].data_list) < 256) {
-			skb_queue_tail(&usb->tx.station[sidx].data_list, skb);
-			send_packet_from_data_queue(usb);
+		if (skb_queue_len(&tx->station[sidx].data_list) < 256) {
+			skb_queue_tail(&tx->station[sidx].data_list, skb);
+			purelifi_send_packet_from_data_queue(usb);
 		} else {
 			dev_kfree_skb(skb);
 		}
@@ -487,6 +486,7 @@ int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
 	static unsigned short int min_exp_seq_nmb;
 	u32 crc_error_cnt_low, crc_error_cnt_high;
 	int sidx;
+	struct purelifi_usb_tx *tx;
 
 	/* Packet blockade during disabled interface. */
 	if (!mac->vif)
@@ -530,33 +530,25 @@ int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
 	fc = get_unaligned((__le16 *)buffer);
 	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
 
+	tx = &mac->chip.usb.tx;
+
 	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
-		if (!memcmp(&buffer[10],
-			    mac->chip.usb.tx.station[sidx].mac,
-					ETH_ALEN)) {
-			if (mac->chip.usb.tx.station[sidx].flag &
-					STATION_CONNECTED_FLAG) {
-				mac->chip.usb.tx.station[sidx].flag |=
-					STATION_HEARTBEAT_FLAG;
-				break;
-			}
+		if (memcmp(&buffer[10], tx->station[sidx].mac, ETH_ALEN))
+			continue;
+		if (tx->station[sidx].flag & STATION_CONNECTED_FLAG) {
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
 		}
 	}
 
 	if (sidx == MAX_STA_NUM - 1) {
 		for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
-			if (!(mac->chip.usb.tx.station[sidx].flag &
-						STATION_CONNECTED_FLAG
-			     )) {
-				memcpy(mac->chip.usb.tx.station[sidx].mac,
-				       &buffer[10],
-						ETH_ALEN);
-				mac->chip.usb.tx.station[sidx].flag |=
-					STATION_CONNECTED_FLAG;
-				mac->chip.usb.tx.station[sidx].flag |=
-					STATION_HEARTBEAT_FLAG;
-				break;
-			}
+			if (tx->station[sidx].flag & STATION_CONNECTED_FLAG)
+				continue;
+			memcpy(tx->station[sidx].mac, &buffer[10], ETH_ALEN);
+			tx->station[sidx].flag |= STATION_CONNECTED_FLAG;
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
 		}
 	}
 
diff --git a/drivers/net/wireless/purelifi/mac.h b/drivers/net/wireless/purelifi/mac.h
index 35e28cc4dffb..cca1e70a6416 100644
--- a/drivers/net/wireless/purelifi/mac.h
+++ b/drivers/net/wireless/purelifi/mac.h
@@ -37,16 +37,18 @@
 #define PURELIFI_RX_ERROR		0x80
 #define PURELIFI_RX_CRC32_ERROR		0x10
 
-#define MODULATION_RATE_BPSK_1_2  0
-#define MODULATION_RATE_BPSK_3_4  (MODULATION_RATE_BPSK_1_2  + 1)
-#define MODULATION_RATE_QPSK_1_2  (MODULATION_RATE_BPSK_3_4  + 1)
-#define MODULATION_RATE_QPSK_3_4  (MODULATION_RATE_QPSK_1_2  + 1)
-#define MODULATION_RATE_QAM16_1_2 (MODULATION_RATE_QPSK_3_4  + 1)
-#define MODULATION_RATE_QAM16_3_4 (MODULATION_RATE_QAM16_1_2 + 1)
-#define MODULATION_RATE_QAM64_1_2 (MODULATION_RATE_QAM16_3_4 + 1)
-#define MODULATION_RATE_QAM64_3_4 (MODULATION_RATE_QAM64_1_2 + 1)
-#define MODULATION_RATE_AUTO      (MODULATION_RATE_QAM64_3_4 + 1)
-#define MODULATION_RATE_NUM       (MODULATION_RATE_AUTO      + 1)
+enum {
+	MODULATION_RATE_BPSK_1_2 = 0,
+	MODULATION_RATE_BPSK_3_4,
+	MODULATION_RATE_QPSK_1_2,
+	MODULATION_RATE_QPSK_3_4,
+	MODULATION_RATE_QAM16_1_2,
+	MODULATION_RATE_QAM16_3_4,
+	MODULATION_RATE_QAM64_1_2,
+	MODULATION_RATE_QAM64_3_4,
+	MODULATION_RATE_AUTO,
+	MODULATION_RATE_NUM
+};
 
 #define purelifi_mac_dev(mac) (purelifi_chip_dev(&(mac)->chip))
 
diff --git a/drivers/net/wireless/purelifi/usb.c b/drivers/net/wireless/purelifi/usb.c
index 730adbf786da..1354c8734d44 100644
--- a/drivers/net/wireless/purelifi/usb.c
+++ b/drivers/net/wireless/purelifi/usb.c
@@ -71,38 +71,32 @@ static inline u16 get_bcd_device(const struct usb_device *udev)
 
 #define urb_dev(urb) (&(urb)->dev->dev)
 
-void send_packet_from_data_queue(struct purelifi_usb *usb)
+void purelifi_send_packet_from_data_queue(struct purelifi_usb *usb)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
 	static u8 sidx;
 	u8 last_served_sidx;
+	struct purelifi_usb_tx *tx = &usb->tx;
 
-	spin_lock_irqsave(&usb->tx.lock, flags);
+	spin_lock_irqsave(&tx->lock, flags);
 	last_served_sidx = sidx;
 	do {
 		sidx = (sidx + 1) % MAX_STA_NUM;
-		if ((usb->tx.station[sidx].flag &
-					STATION_CONNECTED_FLAG)) {
-			if (!(usb->tx.station[sidx].flag &
-						STATION_FIFO_FULL_FLAG)) {
-				skb = skb_peek(&usb->tx.station
-						[sidx].data_list);
-			}
-		}
+		if (!tx->station[sidx].flag & STATION_CONNECTED_FLAG)
+			continue;
+		if (!(tx->station[sidx].flag & STATION_FIFO_FULL_FLAG))
+			skb = skb_peek(&tx->station[sidx].data_list);
 	} while ((sidx != last_served_sidx) && (!skb));
 
 	if (skb) {
-		skb = skb_dequeue(&usb->tx.station[sidx].data_list);
+		skb = skb_dequeue(&tx->station[sidx].data_list);
 		usb_write_req_async(usb, skb->data, skb->len, USB_REQ_DATA_TX,
 				    tx_urb_complete, skb);
-		if (skb_queue_len(&usb->tx.station[sidx].data_list)
-				<= 60) {
-			block_queue(usb, usb->tx.station[sidx].mac,
-				    false);
-		}
+		if (skb_queue_len(&tx->station[sidx].data_list) <= 60)
+			block_queue(usb, tx->station[sidx].mac, false);
 	}
-	spin_unlock_irqrestore(&usb->tx.lock, flags);
+	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
 static void handle_rx_packet(struct purelifi_usb *usb, const u8 *buffer,
@@ -179,18 +173,16 @@ static void rx_urb_complete(struct urb *urb)
 		dev_info(&usb->intf->dev,
 			 "FIFO full not packet receipt\n");
 		tx->mac_fifo_full = 1;
-		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
-			usb->tx.station[sidx].flag |=
-				STATION_FIFO_FULL_FLAG;
-		}
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			tx->station[sidx].flag |= STATION_FIFO_FULL_FLAG;
 		break;
 	case STATION_FIFO_ALMOST_FULL_MESSAGE:
 		dev_info(&usb->intf->dev, "FIFO full packet receipt\n");
 
 		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
-			usb->tx.station[sidx].flag &= 0xFD;
+			tx->station[sidx].flag &= 0xFD;
 
-		send_packet_from_data_queue(usb);
+		purelifi_send_packet_from_data_queue(usb);
 		break;
 	case STATION_CONNECT_MESSAGE:
 		fpga_link_connection_f = 1;
@@ -435,7 +427,7 @@ void tx_urb_complete(struct urb *urb)
 	}
 
 	purelifi_mac_tx_to_dev(skb, urb->status);
-	send_packet_from_data_queue(usb);
+	purelifi_send_packet_from_data_queue(usb);
 	usb_free_urb(urb);
 }
 
@@ -537,7 +529,7 @@ void purelifi_usb_release(struct purelifi_usb *usb)
 	/* FIXME: usb_interrupt, usb_tx, usb_rx? */
 }
 
-const char *speed(enum usb_device_speed speed)
+const char *purelifi_speed(enum usb_device_speed speed)
 {
 	switch (speed) {
 	case USB_SPEED_LOW:
@@ -1050,7 +1042,7 @@ static void slif_data_plane_sap_timer_callb(struct timer_list *t)
 {
 	struct purelifi_usb *usb = from_timer(usb, t, tx.tx_retry_timer);
 
-	send_packet_from_data_queue(usb);
+	purelifi_send_packet_from_data_queue(usb);
 	usb->tx.tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
 	timer_setup(&usb->tx.tx_retry_timer,
 		    slif_data_plane_sap_timer_callb, 0);
@@ -1060,19 +1052,17 @@ static void slif_data_plane_sap_timer_callb(struct timer_list *t)
 static void sta_queue_cleanup_timer_callb(struct timer_list *t)
 {
 	struct purelifi_usb *usb = from_timer(usb, t, sta_queue_cleanup);
+	struct purelifi_usb_tx *tx = &usb->tx;
 	int sidx;
 
 	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
-		if (usb->tx.station[sidx].flag & STATION_CONNECTED_FLAG) {
-			if (usb->tx.station[sidx].flag &
-					STATION_HEARTBEAT_FLAG) {
-				usb->tx.station[sidx].flag ^=
-					STATION_HEARTBEAT_FLAG;
-			} else {
-				memset(usb->tx.station[sidx].mac, 0,
-				       ETH_ALEN);
-				usb->tx.station[sidx].flag = 0;
-			}
+		if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+			continue;
+		if (tx->station[sidx].flag & STATION_HEARTBEAT_FLAG) {
+			tx->station[sidx].flag ^= STATION_HEARTBEAT_FLAG;
+		} else {
+			memset(tx->station[sidx].mac, 0, ETH_ALEN);
+			tx->station[sidx].flag = 0;
 		}
 	}
 	usb->sta_queue_cleanup.expires = jiffies + STA_QUEUE_CLEANUP_JIFF;
@@ -1231,8 +1221,9 @@ static int probe(struct usb_interface *intf,
 		 const struct usb_device_id *id)
 {
 	int r = 0;
-	struct purelifi_usb *usb;
 	struct purelifi_chip *chip;
+	struct purelifi_usb *usb;
+	struct purelifi_usb_tx *tx;
 	struct ieee80211_hw *hw = NULL;
 	static unsigned char hw_address[ETH_ALEN];
 	static unsigned char serial_number[256];
@@ -1250,6 +1241,7 @@ static int probe(struct usb_interface *intf,
 
 	chip = &purelifi_hw_mac(hw)->chip;
 	usb = &chip->usb;
+	tx = &usb->tx;
 
 	r = upload_mac_and_serial_number(intf, hw_address, serial_number);
 	if (r) {
@@ -1284,8 +1276,8 @@ static int probe(struct usb_interface *intf,
 		goto error;
 	}
 
-	usb->tx.mac_fifo_full = 0;
-	spin_lock_init(&usb->tx.lock);
+	tx->mac_fifo_full = 0;
+	spin_lock_init(&tx->lock);
 
 	msleep(200);
 	r = purelifi_usb_init_hw(usb);
@@ -1320,19 +1312,17 @@ static int probe(struct usb_interface *intf,
 	/* Initialise the data plane Tx queue */
 	atomic_set(&data_queue_flag, 1);
 	for (i = 0; i < MAX_STA_NUM; i++) {
-		skb_queue_head_init(&usb->tx.station[i].data_list);
-		usb->tx.station[i].flag = 0;
+		skb_queue_head_init(&tx->station[i].data_list);
+		tx->station[i].flag = 0;
 	}
-	usb->tx.station[STA_BROADCAST_INDEX].flag |=
-		STATION_CONNECTED_FLAG;
+	tx->station[STA_BROADCAST_INDEX].flag |= STATION_CONNECTED_FLAG;
 	for (i = 0; i < ETH_ALEN; i++)
-		usb->tx.station[STA_BROADCAST_INDEX].mac[i] = 0xFF;
+		tx->station[STA_BROADCAST_INDEX].mac[i] = 0xFF;
 	atomic_set(&data_queue_flag, 0);
 
-	timer_setup(&usb->tx.tx_retry_timer,
-		    slif_data_plane_sap_timer_callb, 0);
-	usb->tx.tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
-	add_timer(&usb->tx.tx_retry_timer);
+	timer_setup(&tx->tx_retry_timer, slif_data_plane_sap_timer_callb, 0);
+	tx->tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
+	add_timer(&tx->tx_retry_timer);
 
 	timer_setup(&usb->sta_queue_cleanup,
 		    sta_queue_cleanup_timer_callb, 0);
diff --git a/drivers/net/wireless/purelifi/usb.h b/drivers/net/wireless/purelifi/usb.h
index cc8f67cd7ad0..af37e7e9fa0a 100644
--- a/drivers/net/wireless/purelifi/usb.h
+++ b/drivers/net/wireless/purelifi/usb.h
@@ -136,7 +136,7 @@ static inline struct ieee80211_hw *purelifi_usb_to_hw(struct purelifi_usb
 
 void purelifi_usb_init(struct purelifi_usb *usb, struct ieee80211_hw *hw,
 		       struct usb_interface *intf);
-void send_packet_from_data_queue(struct purelifi_usb *usb);
+void purelifi_send_packet_from_data_queue(struct purelifi_usb *usb);
 void purelifi_usb_release(struct purelifi_usb *usb);
 void purelifi_usb_disable_rx(struct purelifi_usb *usb);
 void purelifi_usb_enable_tx(struct purelifi_usb *usb);
@@ -144,5 +144,5 @@ void purelifi_usb_disable_tx(struct purelifi_usb *usb);
 int purelifi_usb_tx(struct purelifi_usb *usb, struct sk_buff *skb);
 int purelifi_usb_enable_rx(struct purelifi_usb *usb);
 int purelifi_usb_init_hw(struct purelifi_usb *usb);
-const char *speed(enum usb_device_speed speed);
+const char *purelifi_speed(enum usb_device_speed speed);
 #endif


