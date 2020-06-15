Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4181F8C5B
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 04:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFOCzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 22:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgFOCzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 22:55:32 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D807CC061A0E;
        Sun, 14 Jun 2020 19:55:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1023)
        id 49lbYG1cQRz9sRW; Mon, 15 Jun 2020 12:55:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1592189730; bh=CPzKsT3Ce4QgyxpJFIvrEYxYN/4fT8HyoGm1GkPOq/k=;
        h=From:To:Cc:Subject:Date:From;
        b=dbhPbwHTbzM69QaCKvQJPdbrZ9PSijUXbvj6p4sI9Uew/9CR7JahGy0qrlnUvpI0n
         CZAQ286o86G+YOCl7nIRWWwxLZt908xA1kI6k4SKK74ctLRKJNPKBhbETPwlTDn2Mq
         TgA57B6ZgK95wzes9fTs/kN8FmXdp2T/5f0aKNwYwoofYO0pQlS6/spBXOkg/r8jUw
         DxKed12QQ6TJhYVWDy4k1rd7wQz9y/IeT7a50/4wiGfYi1CvnVf1AXH89jXFG5sNLN
         SVplfQZSZfWwW+gilLw3/18b/Z9jfrr6YtHac1IKGO4vrNSROASsJsw4EirmIKN8VK
         fvarf9XLrhS8g==
From:   Jeremy Kerr <jk@ozlabs.org>
To:     netdev@vger.kernel.org
Cc:     Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>,
        Peter Fink <pfink@christ-es.de>, linux-usb@vger.kernel.org
Subject: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
Date:   Mon, 15 Jun 2020 10:54:56 +0800
Message-Id: <20200615025456.30219-1-jk@ozlabs.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using a AX88179 device (0b95:1790), I see two bytes of appended data on
every RX packet. For example, this 48-byte ping, using 0xff as a
payload byte:

  04:20:22.528472 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 2447, seq 1, length 64
	0x0000:  000a cd35 ea50 000a cd35 ea4f 0800 4500
	0x0010:  0054 c116 4000 4001 f63e c0a8 0101 c0a8
	0x0020:  0102 0800 b633 098f 0001 87ea cd5e 0000
	0x0030:  0000 dcf2 0600 0000 0000 ffff ffff ffff
	0x0040:  ffff ffff ffff ffff ffff ffff ffff ffff
	0x0050:  ffff ffff ffff ffff ffff ffff ffff ffff
	0x0060:  ffff 961f

Those last two bytes - 96 1f - aren't part of the original packet.

In the ax88179 RX path, the usbnet rx_fixup function trims a 2-byte
'alignment pseudo header' from the start of the packet, and sets the
length from a per-packet field populated by hardware. It looks like that
length field *includes* the 2-byte header; the current driver assumes
that it's excluded.

This change trims the 2-byte alignment header after we've set the packet
length, so the resulting packet length is correct. While we're moving
the comment around, this also fixes the spelling of 'pseudo'.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
---
 drivers/net/usb/ax88179_178a.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 93044cf1417a..1fe4cc28d154 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1414,10 +1414,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		if (pkt_cnt == 0) {
-			/* Skip IP alignment psudo header */
-			skb_pull(skb, 2);
 			skb->len = pkt_len;
-			skb_set_tail_pointer(skb, pkt_len);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+			skb_set_tail_pointer(skb, skb->len);
 			skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(skb, pkt_hdr);
 			return 1;
@@ -1426,8 +1426,9 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		ax_skb = skb_clone(skb, GFP_ATOMIC);
 		if (ax_skb) {
 			ax_skb->len = pkt_len;
-			ax_skb->data = skb->data + 2;
-			skb_set_tail_pointer(ax_skb, pkt_len);
+			/* Skip IP alignment pseudo header */
+			skb_pull(ax_skb, 2);
+			skb_set_tail_pointer(ax_skb, ax_skb->len);
 			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(ax_skb, pkt_hdr);
 			usbnet_skb_return(dev, ax_skb);
-- 
2.17.1

