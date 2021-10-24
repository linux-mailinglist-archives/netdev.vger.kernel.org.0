Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD93438BF3
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhJXUrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhJXUrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43ACC061224
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMS-0006Q1-51
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CD52B69C618
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DA85269C5A3;
        Sun, 24 Oct 2021 20:43:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9816c2ca;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/15] can: peak_usb: CANFD: store 64-bits hw timestamps
Date:   Sun, 24 Oct 2021 22:43:23 +0200
Message-Id: <20211024204325.3293425-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

This patch allows to use the whole 64-bit timestamps received from the
CAN-FD device (expressed in µs) rather than only its low part, in the
hwtstamp structure of the skb transferred to the network layer, when a
CAN/CANFD frame has been received.

Link: https://lore.kernel.org/all/20210930094603.23134-1-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 13 +++++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |  1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |  9 ++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index e8f43ed90b72..6107fef9f4a0 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -205,6 +205,19 @@ int peak_usb_netif_rx(struct sk_buff *skb,
 	return netif_rx(skb);
 }
 
+/* post received skb with native 64-bit hw timestamp */
+int peak_usb_netif_rx_64(struct sk_buff *skb, u32 ts_low, u32 ts_high)
+{
+	struct skb_shared_hwtstamps *hwts = skb_hwtstamps(skb);
+	u64 ns_ts;
+
+	ns_ts = (u64)ts_high << 32 | ts_low;
+	ns_ts *= NSEC_PER_USEC;
+	hwts->hwtstamp = ns_to_ktime(ns_ts);
+
+	return netif_rx(skb);
+}
+
 /*
  * callback for bulk Rx urb
  */
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index b00a4811bf61..daa19f57e742 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -143,6 +143,7 @@ void peak_usb_set_ts_now(struct peak_time_ref *time_ref, u32 ts_now);
 void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *tv);
 int peak_usb_netif_rx(struct sk_buff *skb,
 		      struct peak_time_ref *time_ref, u32 ts_low);
+int peak_usb_netif_rx_64(struct sk_buff *skb, u32 ts_low, u32 ts_high);
 void peak_usb_async_complete(struct urb *urb);
 void peak_usb_restart_complete(struct peak_usb_device *dev);
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 09029a3bad1a..6bd12549f101 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -515,7 +515,8 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cfd->len;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(rm->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(rm->ts_low),
+			     le32_to_cpu(rm->ts_high));
 
 	return 0;
 }
@@ -579,7 +580,8 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += cf->len;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(sm->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(sm->ts_low),
+			     le32_to_cpu(sm->ts_high));
 
 	return 0;
 }
@@ -629,7 +631,8 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
 	cf->can_id |= CAN_ERR_CRTL;
 	cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
 
-	peak_usb_netif_rx(skb, &usb_if->time_ref, le32_to_cpu(ov->ts_low));
+	peak_usb_netif_rx_64(skb, le32_to_cpu(ov->ts_low),
+			     le32_to_cpu(ov->ts_high));
 
 	netdev->stats.rx_over_errors++;
 	netdev->stats.rx_errors++;
-- 
2.33.0


