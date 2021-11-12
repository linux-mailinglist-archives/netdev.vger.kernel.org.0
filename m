Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B8F44E0DD
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 04:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhKLDmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:42:35 -0500
Received: from asix.com.tw ([113.196.140.82]:59498 "EHLO asix.com.tw"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhKLDme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 22:42:34 -0500
Received: from localhost.localdomain (unknown [10.1.2.57])
        by asix.com.tw (Postfix) with ESMTPA id 8204A101BCB66;
        Fri, 12 Nov 2021 11:33:31 +0800 (CST)
From:   Jacky Chou <jackychou@asix.com.tw>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw,
        jackychou@asix.com.tw
Subject: [PATCH] net: usb: ax88179_178a: add TSO feature
Date:   Fri, 12 Nov 2021 11:33:22 +0800
Message-Id: <20211112033322.741974-1-jackychou@asix.com.tw>
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
 drivers/net/usb/ax88179_178a.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index c13167183..866954155 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1368,6 +1368,9 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->needed_headroom = 8;
 	dev->net->max_mtu = 4088;
 
+	if (usb_device_no_sg_constraint(dev->udev))
+		dev->can_dma_sg = 1;
+
 	/* Initialize MII structure */
 	dev->mii.dev = dev->net;
 	dev->mii.mdio_read = ax88179_mdio_read;
@@ -1377,11 +1380,14 @@ static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->mii.phy_id = 0x03;
 	dev->mii.supports_gmii = 1;
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
+	dev->net->features |= NETIF_F_SG | NETIF_F_IP_CSUM |
+			      NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM | NETIF_F_TSO;
 
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
+	dev->net->hw_features |= NETIF_F_SG | NETIF_F_IP_CSUM |
+				 NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
+				 NETIF_F_TSO;
+
+	netif_set_gso_max_size(dev->net, 16384);
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
@@ -1537,6 +1543,10 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 
 	headroom = skb_headroom(skb) - 8;
 
+	if (!dev->can_dma_sg && (dev->net->features & NETIF_F_SG) &&
+	    skb_linearize(skb))
+		return NULL;
+
 	if ((skb_header_cloned(skb) || headroom < 0) &&
 	    pskb_expand_head(skb, headroom < 0 ? 8 : 0, 0, GFP_ATOMIC)) {
 		dev_kfree_skb_any(skb);
-- 
2.25.1

