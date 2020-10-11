Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46EF28A6A0
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 11:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgJKJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 05:24:37 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:12731 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgJKJYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 05:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602408271;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=UbwdJKIu04DpstILP8vrMSGdlv6Tj0HaYo4rxqnwV5o=;
        b=IEobbbGbB0xpJzTfhEjoE4S/QubSqBZTQdk3hp+xmHDp3LJlhKtdRC6BLghc45nKh/
        xymsoylCH+eHhXmVi5ONvBcTWrJETOmAAVNAO9rCU60GqF+JvzREl8sCPsVjebhrXFdd
        UyLGdefVFkw7rQyoUF7F9/xqp5QiLppz+hGSySo6NLqUsTLLg8teA6wflNhHS2B8DDhu
        ykZlAoZhnzCkSh29Q/A+2zH4Skbr84M98qclh9nLSN53ysNSNr3TQ6D8pLQu//7THM7W
        cRboTIcfU4ulNQP+8/Hsyh3mdcfAkjzju5zHLJaFN0iHZ4jzMBxv4cL8opQV4Ei2sD9d
        CNvQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS5ke8I08fc+Yum5KVO"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id D0b41cw9B9OOMme
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 11 Oct 2020 11:24:24 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     kuba@kernel.org, netdev@vger.kernel.org
Cc:     mkl@pengutronix.de, davem@davemloft.net, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next v2 1/2] can-isotp: implement cleanups / improvements from review
Date:   Sun, 11 Oct 2020 11:24:07 +0200
Message-Id: <20201011092408.1766-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Jakub Kicinski here:
http://lore.kernel.org/r/20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
this patch addresses the remarked issues:

- remove empty line in comment
- remove default=y for CAN_ISOTP in Kconfig
- make use of pr_notice_once()
- use GFP_KERNEL instead of gfp_any() in soft hrtimer context
- make use of pr_fmt() [suggested my Marc Kleine-Budde]

The version strings in the CAN subsystem are removed by a separate patch.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/uapi/linux/can/isotp.h |  1 -
 net/can/Kconfig                |  3 ++-
 net/can/isotp.c                | 19 ++++++++++---------
 3 files changed, 12 insertions(+), 11 deletions(-)

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
index e6ff032b5426..22187669c5c9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -79,6 +79,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 MODULE_ALIAS("can-proto-6");
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define SINGLE_MASK(id) (((id) & CAN_EFF_FLAG) ? \
 			 (CAN_EFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG) : \
 			 (CAN_SFF_MASK | CAN_EFF_FLAG | CAN_RTR_FLAG))
@@ -222,8 +224,8 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
-		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-			    __func__, can_send_ret);
+		pr_notice_once("%s: can_send_ret %d\n",
+			       __func__, can_send_ret);
 
 	dev_put(dev);
 
@@ -769,7 +771,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 isotp_tx_burst:
 		skb = alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
-				gfp_any());
+				GFP_KERNEL);
 		if (!skb) {
 			dev_put(dev);
 			break;
@@ -798,8 +800,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 		can_send_ret = can_send(skb, 1);
 		if (can_send_ret)
-			printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-				    __func__, can_send_ret);
+			pr_notice_once("%s: can_send_ret %d\n",
+				       __func__, can_send_ret);
 
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
@@ -942,8 +944,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
-		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
-			    __func__, err);
+		pr_notice_once("%s: can_send_ret %d\n", __func__, err);
 		return err;
 	}
 
@@ -1408,11 +1409,11 @@ static __init int isotp_module_init(void)
 {
 	int err;
 
-	pr_info("can: isotp protocol (rev " CAN_ISOTP_VERSION ")\n");
+	pr_info("isotp protocol (rev " CAN_ISOTP_VERSION ")\n");
 
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
-		pr_err("can: registration of isotp protocol failed\n");
+		pr_err("registration of isotp protocol failed\n");
 
 	return err;
 }
-- 
2.28.0

