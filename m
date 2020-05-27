Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F241E38D1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgE0GIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:08:36 -0400
Received: from ozlabs.org ([203.11.71.1]:44889 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0GIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 02:08:36 -0400
Received: by ozlabs.org (Postfix, from userid 1023)
        id 49X0kp299jz9sSW; Wed, 27 May 2020 16:08:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590559714; bh=hZQnCgxdydb3gtmG6TGmUAu7vpiPMlaiiu7ud8Cr4g8=;
        h=From:To:Cc:Subject:Date:From;
        b=uZD3sEtaHFDW7AR+fp2QDCso9T9AJ2LnrpvpFPuRrtIadGrL+pJPUa56Xu8jNoppx
         JSdTi4N9LCG4E8kTDKA0yJPTeMyJ8qQwxReVSQmpPblIMz8SU9/r/TmbMNMn0YQ9JQ
         Yvnk8i5ItsjHywqhO4+17K5cuQq4r47/UmkdC60CcsJmua1t8Gj+hnNCDXsRU99zuY
         HzW46ZEg7lna+PxfUeWVRglRMOXlXk/6axcxSPHBZ2ulrYnFnNfbE605/V/kw07aEJ
         TaneuAGcxKTrgXHlXXiXz7kZ8GiH70SKyxhIIB6hS2EtgVA3i2dq/IXUpYre7gEh6q
         uuuRoQrIsWafg==
From:   Jeremy Kerr <jk@ozlabs.org>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Freddy Xin <freddy@asix.com.tw>, Peter Fink <pfink@christ-es.de>,
        Allan Chou <allan@asix.com.tw>
Subject: [RFC PATCH] net: usb: ax88179_178a: fix packet alignment padding
Date:   Wed, 27 May 2020 14:03:34 +0800
Message-Id: <20200527060334.19441-1-jk@ozlabs.org>
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
RFC: I don't have access to docs for this hardware, so this is all based
on observed behaviour of the reported packet length.
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

