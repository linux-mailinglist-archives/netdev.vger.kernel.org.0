Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD744FDBB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 04:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbhKODxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 22:53:40 -0500
Received: from asix.com.tw ([113.196.140.82]:60850 "EHLO asix.com.tw"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237326AbhKODxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 22:53:24 -0500
Received: from localhost.localdomain (unknown [10.1.2.57])
        by asix.com.tw (Postfix) with ESMTPA id 9F6AA1008C143;
        Mon, 15 Nov 2021 11:50:09 +0800 (CST)
From:   Jacky Chou <jackychou@asix.com.tw>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        louis@asix.com.tw, jackychou@asix.com.tw
Subject: [PATCH] net: usb: ax88179_178a: add TSO feature
Date:   Mon, 15 Nov 2021 11:49:41 +0800
Message-Id: <20211115034941.793347-1-jackychou@asix.com.tw>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On low-effciency embedded platforms, transmission performance is poor
due to on Bulk-out with single packet.
Adding TSO feature improves the transmission performance and reduces
the number of interrupt caused by Bulk-out complete.

Reference to module, net: usb: aqc111.

Signed-off-by: Jacky Chou <jackychou@asix.com.tw>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index c13167183..f78f48d89 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1377,11 +1377,12 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
+	dev->net->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
+			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | NETIF_F_TSO;
 
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
+	dev->net->hw_features |= dev->net->features;
+
+	netif_set_gso_max_size(dev->net, 16384);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
@@ -1526,17 +1527,19 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 {
 	u32 tx_hdr1, tx_hdr2;
 	int frame_size = dev->maxpacket;
-	int mss = skb_shinfo(skb)->gso_size;
 	int headroom;
 	void *ptr;
 
 	tx_hdr1 = skb->len;
-	tx_hdr2 = mss;
+	tx_hdr2 = skb_shinfo(skb)->gso_size; /* Set TSO mss */
 	if (((skb->len + 8) % frame_size) == 0)
 		tx_hdr2 |= 0x80008000;	/* Enable padding */
 
 	headroom = skb_headroom(skb) - 8;
 
+	if ((dev->net->features & NETIF_F_SG) && skb_linearize(skb))
+		return NULL;
+
 	if ((skb_header_cloned(skb) || headroom < 0) &&
 	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {
 		dev_kfree_skb_any(skb);
@@ -1547,6 +1550,8 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	put_unaligned_le32(tx_hdr1, ptr);
 	put_unaligned_le32(tx_hdr2, ptr + 4);
 
+	usbnet_set_skb_tx_stats(skb, (skb_shinfo(skb)->gso_segs ?: 1), 0);
+
 	return skb;
 }
 
-- 
2.25.1

