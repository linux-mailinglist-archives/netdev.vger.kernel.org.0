Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34FB28B040
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgJLI1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgJLI1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:27:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1A8C0613CE
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 01:27:39 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kRtBB-0004Ow-Af; Mon, 12 Oct 2020 10:27:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 1/2] can: isotp: implement cleanups / improvements from review
Date:   Mon, 12 Oct 2020 10:27:26 +0200
Message-Id: <20201012082727.2338859-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012082727.2338859-1-mkl@pengutronix.de>
References: <20201012082727.2338859-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

As pointed out by Jakub Kicinski here:
http://lore.kernel.org/r/20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
this patch addresses the remarked issues:

- remove empty line in comment
- remove default=y for CAN_ISOTP in Kconfig
- make use of pr_notice_once()
- use GFP_ATOMIC instead of gfp_any() in soft hrtimer context

The version strings in the CAN subsystem are removed by a separate patch.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201012074354.25839-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/isotp.h |  1 -
 net/can/Kconfig                |  3 ++-
 net/can/isotp.c                | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 553006509f4e..7793b26aa154 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -160,7 +160,6 @@ struct can_isotp_ll_options {
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
index e6ff032b5426..ca63061bb932 100644
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
+				GFP_ATOMIC);
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

