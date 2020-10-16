Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4CF290C94
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393388AbgJPUFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:05:15 -0400
Received: from mailout11.rmx.de ([94.199.88.76]:52900 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393318AbgJPUFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 16:05:14 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4CCcZY4Tysz45jn;
        Fri, 16 Oct 2020 22:05:09 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCcYf5z4qz2xDT;
        Fri, 16 Oct 2020 22:04:22 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 22:04:00 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
CC:     "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next 2/3] net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
Date:   Fri, 16 Oct 2020 22:02:25 +0200
Message-ID: <20201016200226.23994-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016200226.23994-1-ceggers@arri.de>
References: <20201016200226.23994-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201016-220424-4CCcYf5z4qz2xDT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 net/dsa/tag_ksz.c | 73 ++++++-----------------------------------------
 1 file changed, 9 insertions(+), 64 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0a5aa982c60d..4820dbcedfa2 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -14,46 +14,6 @@
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
 
-static struct sk_buff *ksz_common_xmit(struct sk_buff *skb,
-				       struct net_device *dev, int len)
-{
-	struct sk_buff *nskb;
-	int padlen;
-
-	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
-
-	if (skb_tailroom(skb) >= padlen + len) {
-		/* Let dsa_slave_xmit() free skb */
-		if (__skb_put_padto(skb, skb->len + padlen, false))
-			return NULL;
-
-		nskb = skb;
-	} else {
-		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
-				 padlen + len, GFP_ATOMIC);
-		if (!nskb)
-			return NULL;
-		skb_reserve(nskb, NET_IP_ALIGN);
-
-		skb_reset_mac_header(nskb);
-		skb_set_network_header(nskb,
-				       skb_network_header(skb) - skb->head);
-		skb_set_transport_header(nskb,
-					 skb_transport_header(skb) - skb->head);
-		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-
-		/* Let skb_put_padto() free nskb, and let dsa_slave_xmit() free
-		 * skb
-		 */
-		if (skb_put_padto(nskb, nskb->len + padlen))
-			return NULL;
-
-		consume_skb(skb);
-	}
-
-	return nskb;
-}
-
 static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 				      struct net_device *dev,
 				      unsigned int port, unsigned int len)
@@ -90,23 +50,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *tag;
 	u8 *addr;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = 1 << dp->index;
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -156,18 +111,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ9477_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	val = BIT(dp->index);
 
@@ -176,7 +126,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -213,24 +163,19 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
 	u8 *addr;
 	u8 *tag;
 
-	nskb = ksz_common_xmit(skb, dev, KSZ_INGRESS_TAG_LEN);
-	if (!nskb)
-		return NULL;
-
 	/* Tag encoding */
-	tag = skb_put(nskb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(nskb);
+	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
+	addr = skb_mac_header(skb);
 
 	*tag = BIT(dp->index);
 
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return nskb;
+	return skb;
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

