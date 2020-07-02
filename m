Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C412211864
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgGBB1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgGBB1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:27:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94022083E;
        Thu,  2 Jul 2020 01:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653251;
        bh=u8GipE7cgwchP3tZ79d2C4HOwxd4TLB+U5Rjdfsk+cA=;
        h=From:To:Cc:Subject:Date:From;
        b=NB5M0FUzte+yPCMSK8e6H4mGlGGAsRWMk7ROf95HZjePHvaFWrwO4goqIebPnocyu
         8MhNGwJLf5efBlpkt1GMNpQMlHtftiXO+DjEVcpa3oDU3o9zZfHrgpIgUVSg/pqxEp
         WXefVeXkyE0OdLEo1LKY9cSaoc1GZ8qKOSgbfLBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Kerr <jk@ozlabs.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/7] net: usb: ax88179_178a: fix packet alignment padding
Date:   Wed,  1 Jul 2020 21:27:23 -0400
Message-Id: <20200702012729.2702141-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit e869e7a17798d85829fa7d4f9bbe1eebd4b2d3f6 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e3f2e6098db40..2dcc8a039d42e 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1396,10 +1396,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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
@@ -1408,8 +1408,9 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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
2.25.1

