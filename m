Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923D312D0BE
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfL3OcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:17 -0500
Received: from mail.dlink.ru ([178.170.168.18]:40682 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3OcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:17 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D3AEB1B21931; Mon, 30 Dec 2019 17:32:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D3AEB1B21931
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716333; bh=K9IglDMfo6fAz8oDQ8Cy06HvYvmttudvu1VgNCQnFXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=qJIC8vezW0CT/vTGRMA6+/uDOBnYmq5DvI2uzElLicNNnROsynCLwKx6/5v0TwV2K
         Evrqb7oMuu61H5mj88wT1Dq6dGlhCouT1Po/aapUQkzrZy3nK6zMZ3u/By/+xLyjth
         IeKgMTm5eYOelpTgn83ZgI1+QLjvJH7RgTn84Ug4=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 615FD1B21809;
        Mon, 30 Dec 2019 17:31:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 615FD1B21809
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 5C76B1B229CB;
        Mon, 30 Dec 2019 17:31:25 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:25 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 12/19] net: dsa: tag_lan9303: split out common tag accessors
Date:   Mon, 30 Dec 2019 17:30:20 +0300
Message-Id: <20191230143028.27313-13-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...as they will be needed in the upcoming GRO callbacks.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_lan9303.c | 46 +++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index d328a44381a9..ba03502986a4 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -38,6 +38,32 @@
 # define LAN9303_TAG_RX_TRAPPED_TO_CPU (LAN9303_TAG_RX_IGMP | \
 					LAN9303_TAG_RX_STP)
 
+static inline bool lan9303_sanity_check(const u8 *data)
+{
+	/* '->data' points into the middle of our special VLAN tag information:
+	 *
+	 * ~ MAC src   | 0x81 | 0x00 | 0xyy | 0xzz | ether type
+	 *                           ^
+	 *                        ->data
+	 */
+	return *(__be16 *)(data - 2) == htons(ETH_P_8021Q);
+}
+
+static inline bool lan9303_trapped_to_cpu(const u8 *data)
+{
+	return *(data + 1) & LAN9303_TAG_RX_TRAPPED_TO_CPU;
+}
+
+static inline int lan9303_source_port(const u8 *data)
+{
+	return *(data + 1) & GENMASK(1, 0);
+}
+
+static inline __be16 lan9303_encap_proto(const u8 *data)
+{
+	return *(__be16 *)(data + 2);
+}
+
 /* Decide whether to transmit using ALR lookup, or transmit directly to
  * port using tag. ALR learning is performed only when using ALR lookup.
  * If the two external ports are bridged and the frame is unicast,
@@ -85,8 +111,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
-	u16 *lan9303_tag;
-	u16 lan9303_tag1;
 	unsigned int source_port;
 
 	if (unlikely(!pskb_may_pull(skb, LAN9303_TAG_LEN))) {
@@ -95,21 +119,12 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 		return NULL;
 	}
 
-	/* '->data' points into the middle of our special VLAN tag information:
-	 *
-	 * ~ MAC src   | 0x81 | 0x00 | 0xyy | 0xzz | ether type
-	 *                           ^
-	 *                        ->data
-	 */
-	lan9303_tag = (u16 *)(skb->data - 2);
-
-	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
+	if (!lan9303_sanity_check(skb->data)) {
 		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
 		return NULL;
 	}
 
-	lan9303_tag1 = ntohs(lan9303_tag[1]);
-	source_port = lan9303_tag1 & 0x3;
+	source_port = lan9303_source_port(skb->data);
 
 	skb->dev = dsa_master_find_slave(dev, 0, source_port);
 	if (!skb->dev) {
@@ -117,13 +132,14 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 		return NULL;
 	}
 
+	skb->offload_fwd_mark = !lan9303_trapped_to_cpu(skb->data);
+
 	/* remove the special VLAN tag between the MAC addresses
 	 * and the current ethertype field.
 	 */
 	skb_pull_rcsum(skb, 2 + 2);
 	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
 		2 * ETH_ALEN);
-	skb->offload_fwd_mark = !(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU);
 
 	return skb;
 }
@@ -132,7 +148,7 @@ static void lan9303_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				 int *offset)
 {
 	*offset = LAN9303_TAG_LEN;
-	*proto = *(__be16 *)(skb->data + 2);
+	*proto = lan9303_encap_proto(skb->data);
 }
 
 static const struct dsa_device_ops lan9303_netdev_ops = {
-- 
2.24.1

