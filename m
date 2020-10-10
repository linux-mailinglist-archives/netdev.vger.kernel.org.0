Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CBE28A3B0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390166AbgJJW4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:46 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:25288 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388233AbgJJUzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 16:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602363338;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=RfRl8LEsL90bZVT/vnSK+cUBa8J9DjYbPGdWhQ3vRg0=;
        b=SwpGm+PMApiCQvyeK16bFoSqrCyGgwxrWTaGCTgNUSOxipCqylxG5rcs86W2tV387e
        7vHV6PBbdDfr+qVSP8L9g8YGqGgZHsjuS2bJYwEDtTrQ7MdysAQ3P7rCBJh6fJ/gsRo5
        muk5AmExGlLM7ZJhBOoZMHFn71B9CqsxWP4/EMCmqJhrMi7UK67a18DnrrBPGHpvWaxv
        e/f+6mV9+HCka+0OfwHMVB1KJjeGfJPfJhPF54Cq/F45OBHB+lKHqvNSDuw2XPQJtu5L
        uWEOuW3XnX135hBlPvjkclMkX+ykGXO/hO866AeBZ45ulBcfvSkko0wugoVKYbwR5ycX
        tbeg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lu8GW2/7Zq6MBXY="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9AKnbMGS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 10 Oct 2020 22:49:37 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     mkl@pengutronix.de, davem@davemloft.net, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next 1/2] can-isotp: implement cleanups / improvements from review
Date:   Sat, 10 Oct 2020 22:49:08 +0200
Message-Id: <20201010204909.2059-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Jakub Kicinski here:
https://marc.info/?l=linux-can&m=160229286216008
this patch addresses the remarked issues:

- remove empty lines in comment
- remove default=y for CAN_ISOTP in Kconfig
- make use of pr_notice_once()
- use GFP_KERNEL instead of gfp_any() in soft hrtimer context

The version strings in the CAN subsystem are removed by a separate patch.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/uapi/linux/can/isotp.h |  4 +---
 net/can/Kconfig                |  3 ++-
 net/can/isotp.c                | 14 +++++++-------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 553006509f4e..accf0efa46f4 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -151,8 +151,7 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
 #define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
 
-/*
- * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
+/* Remark on CAN_ISOTP_DEFAULT_RECV_* values:
  *
  * We can strongly assume, that the Linux Kernel implementation of
  * CAN_ISOTP is capable to run with BS=0, STmin=0 and WFTmax=0.
@@ -160,7 +159,6 @@ struct can_isotp_ll_options {
  * these default settings can be changed via sockopts.
  * For that reason the STmin value is intentionally _not_ checked for
  * consistency and copied directly into the flow control (FC) frame.
- *
  */
 
 #endif /* !_UAPI_CAN_ISOTP_H */
diff --git a/net/can/Kconfig b/net/can/Kconfig
index 021fe03a8ed6..224e5e0283a9 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -57,7 +57,6 @@ source "net/can/j1939/Kconfig"
 
 config CAN_ISOTP
 	tristate "ISO 15765-2:2016 CAN transport protocol"
-	default y
 	help
 	  CAN Transport Protocols offer support for segmented Point-to-Point
 	  communication between CAN nodes via two defined CAN Identifiers.
@@ -67,6 +66,8 @@ config CAN_ISOTP
 	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
 	  This protocol driver implements data transfers according to
 	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
+	  If you want to perform automotive vehicle diagnostic services (UDS),
+	  say 'y'.
 
 source "drivers/net/can/Kconfig"
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index e6ff032b5426..bc3a722c200b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -222,8 +222,8 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
-		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-			    __func__, can_send_ret);
+		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
+			       __func__, can_send_ret);
 
 	dev_put(dev);
 
@@ -769,7 +769,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 isotp_tx_burst:
 		skb = alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
-				gfp_any());
+				GFP_KERNEL);
 		if (!skb) {
 			dev_put(dev);
 			break;
@@ -798,8 +798,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 		can_send_ret = can_send(skb, 1);
 		if (can_send_ret)
-			printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-				    __func__, can_send_ret);
+			pr_notice_once("can-isotp: %s: can_send_ret %d\n",
+				       __func__, can_send_ret);
 
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
@@ -942,8 +942,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
-		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-			    __func__, err);
+		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
+			       __func__, err);
 		return err;
 	}
 
-- 
2.28.0

