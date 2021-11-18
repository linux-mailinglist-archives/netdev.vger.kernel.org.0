Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830CD45598C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbhKRLFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:05:23 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:31074 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343489AbhKRLFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:05:19 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id CE89D921363;
        Thu, 18 Nov 2021 11:02:15 +0000 (UTC)
Received: from ares.krystal.co.uk (unknown [127.0.0.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 90EAB921107;
        Thu, 18 Nov 2021 11:02:13 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk ([TEMPUNAVAIL]. [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.109.250.31 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:15 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Relation-Soft: 23762c64577521ab_1637233334641_384205255
X-MC-Loop-Signature: 1637233334641:2283243983
X-MC-Ingress-Time: 1637233334640
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jSxX6rCP+e2B8vbRjIh0qSOEV24VWOWzpjb9WISNY7I=; b=tqFM3qDispMMbnIE7He5N5hsy+
        rN/YVk0eEuonPcJTtM/wuIa0ybZ7fpQRVd1lSr7YVrMnSdrOlYVstMWxyHjIAaIZSWeIMmzB+MQ5k
        NGl9Xljl2JBCxCJNsakeNap2rT9rW/Z32OjINi5gKoxu8JE0yPX5Rm1OBvJkXD1vDPyEioywlg2dr
        ShkLTx7BYVNGsx1q/N0JYxcY5gby2U0k9eJ6AlW3I0JuNmkl02+u2erpeLIBagNfjN17HDZ3BRcUM
        hksewi62LYMiJKkOEWKYcuXszQ7Ap63jhwCaNhk9k2ts7wjPtfxGY58xwk+zxj5ecUv01MHqaDULP
        sRhEn7pw==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBD-004NG9-O8; Thu, 18 Nov 2021 11:02:09 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 5/6] lan78xx: Remove hardware-specific header update
Date:   Thu, 18 Nov 2021 11:01:38 +0000
Message-Id: <20211118110139.7321-6-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
References: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove hardware-specific header length adjustment as it is no longer
required. It also breaks generic receive offload (GRO) processing of
received TCP frames that results in a TCP ACK being sent for each
received frame.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 51 ++++++++++++---------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index ebd3d9fc5c41..64f60cf6c911 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -67,7 +67,6 @@
 #define DEFAULT_TSO_CSUM_ENABLE		(true)
 #define DEFAULT_VLAN_FILTER_ENABLE	(true)
 #define DEFAULT_VLAN_RX_OFFLOAD		(true)
-#define TX_OVERHEAD			(8)
 #define TX_ALIGNMENT			(4)
 #define RXW_PADDING			2
 
@@ -120,6 +119,10 @@
 #define TX_SKB_MIN_LEN			(TX_CMD_LEN + ETH_HLEN)
 #define LAN78XX_TSO_SIZE(dev)		((dev)->tx_urb_size - TX_SKB_MIN_LEN)
 
+#define RX_CMD_LEN			10
+#define RX_SKB_MIN_LEN			(RX_CMD_LEN + ETH_HLEN)
+#define RX_MAX_FRAME_LEN(mtu)		((mtu) + ETH_HLEN + VLAN_HLEN)
+
 /* USB related defines */
 #define BULK_IN_PIPE			1
 #define BULK_OUT_PIPE			2
@@ -440,8 +443,6 @@ struct lan78xx_net {
 	struct mutex		phy_mutex; /* for phy access */
 	unsigned int		pipe_in, pipe_out, pipe_intr;
 
-	u32			hard_mtu;	/* count any extra framing */
-
 	unsigned int		bulk_in_delay;
 	unsigned int		burst_cap;
 
@@ -2536,37 +2537,24 @@ static int unlink_urbs(struct lan78xx_net *dev, struct sk_buff_head *q)
 static int lan78xx_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct lan78xx_net *dev = netdev_priv(netdev);
-	int ll_mtu = new_mtu + netdev->hard_header_len;
-	int old_hard_mtu = dev->hard_mtu;
-	int old_rx_urb_size = dev->rx_urb_size;
+	int max_frame_len = RX_MAX_FRAME_LEN(new_mtu);
 	int ret;
 
 	/* no second zero-length packet read wanted after mtu-sized packets */
-	if ((ll_mtu % dev->maxpacket) == 0)
+	if ((max_frame_len % dev->maxpacket) == 0)
 		return -EDOM;
 
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
 		return ret;
 
-	lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
-
-	netdev->mtu = new_mtu;
-
-	dev->hard_mtu = netdev->mtu + netdev->hard_header_len;
-	if (dev->rx_urb_size == old_hard_mtu) {
-		dev->rx_urb_size = dev->hard_mtu;
-		if (dev->rx_urb_size > old_rx_urb_size) {
-			if (netif_running(dev->net)) {
-				unlink_urbs(dev, &dev->rxq);
-				tasklet_schedule(&dev->bh);
-			}
-		}
-	}
+	ret = lan78xx_set_rx_max_frame_length(dev, max_frame_len);
+	if (!ret)
+		netdev->mtu = new_mtu;
 
 	usb_autopm_put_interface(dev->intf);
 
-	return 0;
+	return ret;
 }
 
 static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
@@ -3084,7 +3072,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		return ret;
 
 	ret = lan78xx_set_rx_max_frame_length(dev,
-					      dev->net->mtu + VLAN_ETH_HLEN);
+					      RX_MAX_FRAME_LEN(dev->net->mtu));
 
 	return ret;
 }
@@ -3489,9 +3477,6 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 		goto out1;
 	}
 
-	dev->net->hard_header_len += TX_OVERHEAD;
-	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-
 	/* Init all registers */
 	ret = lan78xx_reset(dev);
 	if (ret) {
@@ -3592,7 +3577,7 @@ static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
 
 static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb)
 {
-	if (skb->len < dev->net->hard_header_len)
+	if (skb->len < RX_SKB_MIN_LEN)
 		return 0;
 
 	while (skb->len > 0) {
@@ -3699,7 +3684,7 @@ static void rx_complete(struct urb *urb)
 
 	switch (urb_status) {
 	case 0:
-		if (skb->len < dev->net->hard_header_len) {
+		if (skb->len < RX_SKB_MIN_LEN) {
 			state = rx_cleanup;
 			dev->net->stats.rx_errors++;
 			dev->net->stats.rx_length_errors++;
@@ -4343,6 +4328,9 @@ static int lan78xx_probe(struct usb_interface *intf,
 	if (ret < 0)
 		goto out3;
 
+	/* MTU range: 68 - 9000 */
+	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
+
 	netif_set_gso_max_size(netdev, LAN78XX_TSO_SIZE(dev));
 
 	tasklet_setup(&dev->bh, lan78xx_bh);
@@ -4390,13 +4378,6 @@ static int lan78xx_probe(struct usb_interface *intf,
 	if (ret < 0)
 		goto out4;
 
-	if (netdev->mtu > (dev->hard_mtu - netdev->hard_header_len))
-		netdev->mtu = dev->hard_mtu - netdev->hard_header_len;
-
-	/* MTU range: 68 - 9000 */
-	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
-	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
-
 	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr, 0);
 	buf = kmalloc(maxp, GFP_KERNEL);
-- 
2.25.1

