Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D94290C91
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393356AbgJPUE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:04:28 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:45644 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393334AbgJPUE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 16:04:27 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4CCcYf61nmz9vB2;
        Fri, 16 Oct 2020 22:04:22 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCcXr0CzYz2xPF;
        Fri, 16 Oct 2020 22:03:40 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 22:03:25 +0200
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
Subject: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to drivers xmit function
Date:   Fri, 16 Oct 2020 22:02:24 +0200
Message-ID: <20201016200226.23994-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016200226.23994-1-ceggers@arri.de>
References: <20201016200226.23994-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201016-220340-4CCcXr0CzYz2xPF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the skb is not cloned and has enough tail room for the tail
tag. This code will be removed from the drivers in the next commits.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 net/dsa/dsa_priv.h |  3 +++
 net/dsa/slave.c    | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12998bf04e55..975001c625b1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -77,6 +77,9 @@ struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
 					struct net_device *dev);
+	/* same for tail_tag and overhead */
+	bool tail_tag;
+	unsigned int overhead;
 
 	struct pcpu_sw_netstats	__percpu *stats64;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..49a19a3b0736 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -553,6 +553,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct pcpu_sw_netstats *s;
 	struct sk_buff *nskb;
+	int padlen;
 
 	s = this_cpu_ptr(p->stats64);
 	u64_stats_update_begin(&s->syncp);
@@ -567,6 +568,41 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	dsa_skb_tx_timestamp(p, skb);
 
+	/* We have to pad he packet to the minimum Ethernet frame size,
+	 * if necessary, before adding the trailer (tail tagging only).
+	 */
+	padlen = (skb->len >= ETH_ZLEN) ? 0 : ETH_ZLEN - skb->len;
+
+	/* To keep the slave's xmit() methods simple, don't pass cloned skbs to
+	 * them. Additionally ensure, that suitable room for tail tagging is
+	 * available.
+	 */
+	if (skb_cloned(skb) ||
+	    (p->tail_tag && skb_tailroom(skb) < (padlen + p->overhead))) {
+		struct sk_buff *nskb;
+
+		nskb = alloc_skb(NET_IP_ALIGN + skb->len +
+				 padlen + p->overhead, GFP_ATOMIC);
+		if (!nskb) {
+			kfree_skb(skb);
+			return NETDEV_TX_OK;
+		}
+		skb_reserve(nskb, NET_IP_ALIGN);
+
+		skb_reset_mac_header(nskb);
+		skb_set_network_header(nskb,
+				       skb_network_header(skb) - skb->head);
+		skb_set_transport_header(nskb,
+					 skb_transport_header(skb) - skb->head);
+		skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
+		consume_skb(skb);
+
+		if (padlen)
+			skb_put_zero(nskb, padlen);
+
+		skb = nskb;
+	}
+
 	/* Transmit function may have to reallocate the original SKB,
 	 * in which case it must have freed it. Only free it here on error.
 	 */
@@ -1814,6 +1850,8 @@ int dsa_slave_create(struct dsa_port *port)
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
 	p->xmit = cpu_dp->tag_ops->xmit;
+	p->tail_tag = cpu_dp->tag_ops->tail_tag;
+	p->overhead = cpu_dp->tag_ops->overhead;
 	port->slave = slave_dev;
 
 	rtnl_lock();
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

