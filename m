Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF3E12D0B3
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfL3OcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:21 -0500
Received: from mail.dlink.ru ([178.170.168.18]:40748 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfL3OcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:18 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D42DD1B2194E; Mon, 30 Dec 2019 17:32:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D42DD1B2194E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716335; bh=omc8QrcNvP8pME1zDqBdaSM8dT/TdIR/78ZE/IJu6BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=b88+1mXk3AaqAKo5cHXojM8Z9FBeCQYwTsQ12ohRqbDqgjeny47cYSKO8Yr+cYZJV
         NjbHt8cg+BFN05lMnlGwswFArEKZd6MFsnMm10h8/V2iRbBoqq6kVElCR/hZWwTaP3
         NvQK8y1+7ajTw3719vsL7KFvMswIHA1393Qr+sUk=
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 041281B21829;
        Mon, 30 Dec 2019 17:31:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 041281B21829
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 3A52F1B229CB;
        Mon, 30 Dec 2019 17:31:29 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:29 +0300 (MSK)
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
Subject: [PATCH RFC net-next 14/19] net: dsa: tag_mtk: split out common tag accessors
Date:   Mon, 30 Dec 2019 17:30:22 +0300
Message-Id: <20191230143028.27313-15-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc: fix identation of MTK_HDR_LEN and make use of it in
mtk_tag_flow_dissect() instead of open-coded value.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_mtk.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index c3ad7b7b142a..b926ffdf5fb5 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -10,12 +10,27 @@
 
 #include "dsa_priv.h"
 
-#define MTK_HDR_LEN		4
+#define MTK_HDR_LEN			4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 
+static inline int mtk_tag_source_port(const u8 *data)
+{
+	/* The MTK header is added by the switch between src addr
+	 * and ethertype at this point, skb->data points to 2 bytes
+	 * after src addr so header should be 2 bytes right before.
+	 * The source port field is in the second byte of the tag.
+	 */
+	return *(data - 1) & MTK_HDR_RECV_SOURCE_PORT_MASK;
+}
+
+static inline __be16 mtk_tag_encap_proto(const u8 *data)
+{
+	return *(__be16 *)(data + 2);
+}
+
 static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -60,17 +75,15 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
 	int port;
-	__be16 *phdr, hdr;
 
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
 
-	/* The MTK header is added by the switch between src addr
-	 * and ethertype at this point, skb->data points to 2 bytes
-	 * after src addr so header should be 2 bytes right before.
-	 */
-	phdr = (__be16 *)(skb->data - 2);
-	hdr = ntohs(*phdr);
+	port = mtk_tag_source_port(skb->data);
+
+	skb->dev = dsa_master_find_slave(dev, 0, port);
+	if (!skb->dev)
+		return NULL;
 
 	/* Remove MTK tag and recalculate checksum. */
 	skb_pull_rcsum(skb, MTK_HDR_LEN);
@@ -79,21 +92,14 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb->data - ETH_HLEN - MTK_HDR_LEN,
 		2 * ETH_ALEN);
 
-	/* Get source port information */
-	port = (hdr & MTK_HDR_RECV_SOURCE_PORT_MASK);
-
-	skb->dev = dsa_master_find_slave(dev, 0, port);
-	if (!skb->dev)
-		return NULL;
-
 	return skb;
 }
 
 static void mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				 int *offset)
 {
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
+	*offset = MTK_HDR_LEN;
+	*proto = mtk_tag_encap_proto(skb->data);
 }
 
 static const struct dsa_device_ops mtk_netdev_ops = {
-- 
2.24.1

