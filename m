Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2623290CCA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405853AbgJPUhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:37:31 -0400
Received: from mailout02.rmx.de ([62.245.148.41]:51600 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390952AbgJPUhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 16:37:31 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 16:37:30 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4CCcbX32BVzNlxv;
        Fri, 16 Oct 2020 22:06:00 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCcZY4RpQz2xPF;
        Fri, 16 Oct 2020 22:05:09 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 22:04:30 +0200
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
Subject: [PATCH net-next 3/3] net: dsa: trailer: don't allocate additional memory for padding/tagging
Date:   Fri, 16 Oct 2020 22:02:26 +0200
Message-ID: <20201016200226.23994-4-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016200226.23994-1-ceggers@arri.de>
References: <20201016200226.23994-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201016-220513-4CCcZY4RpQz2xPF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 net/dsa/tag_trailer.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 3a1cc24a4f0a..5b97ede56a0f 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -13,42 +13,15 @@
 static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
-	int padlen;
 	u8 *trailer;
 
-	/*
-	 * We have to make sure that the trailer ends up as the very
-	 * last 4 bytes of the packet.  This means that we have to pad
-	 * the packet to the minimum ethernet frame size, if necessary,
-	 * before adding the trailer.
-	 */
-	padlen = 0;
-	if (skb->len < 60)
-		padlen = 60 - skb->len;
-
-	nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 4, GFP_ATOMIC);
-	if (!nskb)
-		return NULL;
-	skb_reserve(nskb, NET_IP_ALIGN);
-
-	skb_reset_mac_header(nskb);
-	skb_set_network_header(nskb, skb_network_header(skb) - skb->head);
-	skb_set_transport_header(nskb, skb_transport_header(skb) - skb->head);
-	skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-	consume_skb(skb);
-
-	if (padlen) {
-		skb_put_zero(nskb, padlen);
-	}
-
-	trailer = skb_put(nskb, 4);
+	trailer = skb_put(skb, 4);
 	trailer[0] = 0x80;
 	trailer[1] = 1 << dp->index;
 	trailer[2] = 0x10;
 	trailer[3] = 0x00;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

