Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4313EC7
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfEEKTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52036 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfEEKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id o189so1235111wmb.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OqPIEd+HNAAykiQylcWectHNnZKbQvVu5gDpHaqUvZ0=;
        b=c6kJ1xo7T8BxMIyYVg/HJSLzodQkzKDMi0qLz+RtUZjtFAgE2F4ZDYowJAOxwD1WP5
         CmlBNdi9b8g7j3CDcA07M8S2NAvjUG2zivgdNZynq4tm6ymMn1LKuJdV41/B9+5oA0ep
         H17eb4J2RnPYu36ZH4ID/iIDpVzzQg9Ya/CeHkTS0fPDsyUA7ZllAXiCNQclQvrkIVUI
         LgHarajGtKGlou3Z25NqTZl47Fjg6SqupTNzaG84Tjkgl/PlTtGWzwg4l8ia1jTrx4Fj
         M2qw8SagacFxLztzsTewIez3TV8hiPkfe5Xw8mWVCC34COvJd0MwIkY6JDLcGfgrhaF4
         A0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OqPIEd+HNAAykiQylcWectHNnZKbQvVu5gDpHaqUvZ0=;
        b=E6phIw/d8xXuaW7Mzyfa11TygtrNdyyVbQ4aZSiS4tKcipWfa9YGE55pl8RlZilyQM
         1UgH2u7oBzfh1ymiyjSjru73wTLN1yT2c8aycArtlBezeB/i9Y5cDl7ecjxcTjS7uALS
         ZtTjZVPelgCxnTtY4/P3ODCOGP1u28cKHX60YLcxF57MpiGNzvEN+osowOa+PxDsUXUk
         CuBDNAcZqRV4UavhZABVdPcsSJZStYEKcjjoeMkqlwLHPMq1yUDPa8OuSc9WmEo0I67I
         jjRCqxMrTqvRHlbSkygxi/BWfp/1AhoCs4YZxUWfe1gJfa0FUBmX0hnCH9h5sRQ78hVZ
         X1ow==
X-Gm-Message-State: APjAAAWuOe7P5A/iw9k/upXnys6CKlu3u7WzumWLgI9mQPRtN144pL6i
        P8zyMHzoYnN5i/TPtnd5XDs=
X-Google-Smtp-Source: APXvYqyUT3Wu/Jr2NZKGhTkCeI5yy7pRChEwtXkbiPH6eyWwmpqE71/n1aare6OFA3iAalJ0yqgySg==
X-Received: by 2002:a1c:2986:: with SMTP id p128mr12797511wmp.134.1557051583605;
        Sun, 05 May 2019 03:19:43 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 04/10] net: dsa: Allow drivers to filter packets they can decode source port from
Date:   Sun,  5 May 2019 13:19:23 +0300
Message-Id: <20190505101929.17056-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frames get processed by DSA and redirected to switch port net devices
based on the ETH_P_XDSA multiplexed packet_type handler found by the
network stack when calling eth_type_trans().

The running assumption is that once the DSA .rcv function is called, DSA
is always able to decode the switch tag in order to change the skb->dev
from its master.

However there are tagging protocols (such as the new DSA_TAG_PROTO_SJA1105,
user of DSA_TAG_PROTO_8021Q) where this assumption is not completely
true, since switch tagging piggybacks on the absence of a vlan_filtering
bridge. Moreover, management traffic (BPDU, PTP) for this switch doesn't
rely on switch tagging, but on a different mechanism. So it would make
sense to at least be able to terminate that.

Having DSA receive traffic it can't decode would put it in an impossible
situation: the eth_type_trans() function would invoke the DSA .rcv(),
which could not change skb->dev, then eth_type_trans() would be invoked
again, which again would call the DSA .rcv, and the packet would never
be able to exit the DSA filter and would spiral in a loop until the
whole system dies.

This happens because eth_type_trans() doesn't actually look at the skb
(so as to identify a potential tag) when it deems it as being
ETH_P_XDSA. It just checks whether skb->dev has a DSA private pointer
installed (therefore it's a DSA master) and that there exists a .rcv
callback (everybody except DSA_TAG_PROTO_NONE has that). This is
understandable as there are many switch tags out there, and exhaustively
checking for all of them is far from ideal.

The solution lies in introducing a filtering function for each tagging
protocol. In the absence of a filtering function, all traffic is passed
to the .rcv DSA callback. The tagging protocol should see the filtering
function as a pre-validation that it can decode the incoming skb. The
traffic that doesn't match the filter will bypass the DSA .rcv callback
and be left on the master netdevice, which wasn't previously possible.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:
  - None.

Changes in v2:
  - None.

 include/net/dsa.h  | 15 +++++++++++++++
 net/dsa/dsa2.c     |  1 +
 net/ethernet/eth.c |  6 +++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 69f3714f42ba..c90ceeec7d1f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -69,6 +69,11 @@ struct dsa_device_ops {
 			       struct packet_type *pt);
 	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			    int *offset);
+	/* Used to determine which traffic should match the DSA filter in
+	 * eth_type_trans, and which, if any, should bypass it and be processed
+	 * as regular on the master net device.
+	 */
+	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
 	const char *name;
 	enum dsa_tag_protocol proto;
@@ -148,6 +153,7 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
+	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
@@ -520,6 +526,15 @@ static inline bool netdev_uses_dsa(struct net_device *dev)
 	return false;
 }
 
+static inline bool dsa_can_decode(const struct sk_buff *skb,
+				  struct net_device *dev)
+{
+#if IS_ENABLED(CONFIG_NET_DSA)
+	return !dev->dsa_ptr->filter || dev->dsa_ptr->filter(skb, dev);
+#endif
+	return false;
+}
+
 struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n);
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f1ad80851616..3b5f434cad3f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -586,6 +586,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	}
 
 	dp->type = DSA_PORT_TYPE_CPU;
+	dp->filter = tag_ops->filter;
 	dp->rcv = tag_ops->rcv;
 	dp->tag_ops = tag_ops;
 	dp->master = master;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 0f9863dc4d44..fddcee38c1da 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -185,8 +185,12 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 * at all, so we check here whether one of those tagging
 	 * variants has been configured on the receiving interface,
 	 * and if so, set skb->protocol without looking at the packet.
+	 * The DSA tagging protocol may be able to decode some but not all
+	 * traffic (for example only for management). In that case give it the
+	 * option to filter the packets from which it can decode source port
+	 * information.
 	 */
-	if (unlikely(netdev_uses_dsa(dev)))
+	if (unlikely(netdev_uses_dsa(dev)) && dsa_can_decode(skb, dev))
 		return htons(ETH_P_XDSA);
 
 	if (likely(eth_proto_is_802_3(eth->h_proto)))
-- 
2.17.1

