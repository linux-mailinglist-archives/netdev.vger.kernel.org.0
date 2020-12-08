Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4063D2D3188
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgLHRzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:55:49 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:42059 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgLHRzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 12:55:48 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0B8HsS0D019221
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 8 Dec 2020 18:54:29 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] vrf: handle CONFIG_IPV6 not set for vrf_add_mac_header_if_unset()
Date:   Tue,  8 Dec 2020 18:52:10 +0100
Message-Id: <20201208175210.8906-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vrf_add_mac_header_if_unset() is defined within a conditional
compilation block which depends on the CONFIG_IPV6 macro.
However, the vrf_add_mac_header_if_unset() needs to be called also by IPv4
related code and when the CONFIG_IPV6 is not set, this function is missing.
As a consequence, the build process stops reporting the error:

 ERROR: implicit declaration of function 'vrf_add_mac_header_if_unset'

The problem is solved by *only* moving functions
vrf_add_mac_header_if_unset() and vrf_prepare_mac_header() out of the
conditional block.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 0489390882202 ("vrf: add mac header for tunneled packets when sniffer is attached")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 drivers/net/vrf.c | 110 +++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 259d5cbacf2c..571bd03ebd81 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1237,6 +1237,61 @@ static struct sk_buff *vrf_rcv_nfhook(u8 pf, unsigned int hook,
 	return skb;
 }
 
+static int vrf_prepare_mac_header(struct sk_buff *skb,
+				  struct net_device *vrf_dev, u16 proto)
+{
+	struct ethhdr *eth;
+	int err;
+
+	/* in general, we do not know if there is enough space in the head of
+	 * the packet for hosting the mac header.
+	 */
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(vrf_dev));
+	if (unlikely(err))
+		/* no space in the skb head */
+		return -ENOBUFS;
+
+	__skb_push(skb, ETH_HLEN);
+	eth = (struct ethhdr *)skb->data;
+
+	skb_reset_mac_header(skb);
+
+	/* we set the ethernet destination and the source addresses to the
+	 * address of the VRF device.
+	 */
+	ether_addr_copy(eth->h_dest, vrf_dev->dev_addr);
+	ether_addr_copy(eth->h_source, vrf_dev->dev_addr);
+	eth->h_proto = htons(proto);
+
+	/* the destination address of the Ethernet frame corresponds to the
+	 * address set on the VRF interface; therefore, the packet is intended
+	 * to be processed locally.
+	 */
+	skb->protocol = eth->h_proto;
+	skb->pkt_type = PACKET_HOST;
+
+	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
+
+	skb_pull_inline(skb, ETH_HLEN);
+
+	return 0;
+}
+
+/* prepare and add the mac header to the packet if it was not set previously.
+ * In this way, packet sniffers such as tcpdump can parse the packet correctly.
+ * If the mac header was already set, the original mac header is left
+ * untouched and the function returns immediately.
+ */
+static int vrf_add_mac_header_if_unset(struct sk_buff *skb,
+				       struct net_device *vrf_dev,
+				       u16 proto)
+{
+	if (skb_mac_header_was_set(skb))
+		return 0;
+
+	return vrf_prepare_mac_header(skb, vrf_dev, proto);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 /* neighbor handling is done with actual device; do not want
  * to flip skb->dev for those ndisc packets. This really fails
@@ -1310,61 +1365,6 @@ static void vrf_ip6_input_dst(struct sk_buff *skb, struct net_device *vrf_dev,
 	skb_dst_set(skb, &rt6->dst);
 }
 
-static int vrf_prepare_mac_header(struct sk_buff *skb,
-				  struct net_device *vrf_dev, u16 proto)
-{
-	struct ethhdr *eth;
-	int err;
-
-	/* in general, we do not know if there is enough space in the head of
-	 * the packet for hosting the mac header.
-	 */
-	err = skb_cow_head(skb, LL_RESERVED_SPACE(vrf_dev));
-	if (unlikely(err))
-		/* no space in the skb head */
-		return -ENOBUFS;
-
-	__skb_push(skb, ETH_HLEN);
-	eth = (struct ethhdr *)skb->data;
-
-	skb_reset_mac_header(skb);
-
-	/* we set the ethernet destination and the source addresses to the
-	 * address of the VRF device.
-	 */
-	ether_addr_copy(eth->h_dest, vrf_dev->dev_addr);
-	ether_addr_copy(eth->h_source, vrf_dev->dev_addr);
-	eth->h_proto = htons(proto);
-
-	/* the destination address of the Ethernet frame corresponds to the
-	 * address set on the VRF interface; therefore, the packet is intended
-	 * to be processed locally.
-	 */
-	skb->protocol = eth->h_proto;
-	skb->pkt_type = PACKET_HOST;
-
-	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-
-	skb_pull_inline(skb, ETH_HLEN);
-
-	return 0;
-}
-
-/* prepare and add the mac header to the packet if it was not set previously.
- * In this way, packet sniffers such as tcpdump can parse the packet correctly.
- * If the mac header was already set, the original mac header is left
- * untouched and the function returns immediately.
- */
-static int vrf_add_mac_header_if_unset(struct sk_buff *skb,
-				       struct net_device *vrf_dev,
-				       u16 proto)
-{
-	if (skb_mac_header_was_set(skb))
-		return 0;
-
-	return vrf_prepare_mac_header(skb, vrf_dev, proto);
-}
-
 static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 				   struct sk_buff *skb)
 {
-- 
2.20.1

