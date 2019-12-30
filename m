Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2189112D0B0
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfL3OcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:32:06 -0500
Received: from mail.dlink.ru ([178.170.168.18]:40340 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3OcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:32:06 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 71A021B218C1; Mon, 30 Dec 2019 17:32:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 71A021B218C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716322; bh=MElnUAXdbAsEzuA8MGuhZyEpxZHkJL0ydPnsBAYspiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=C4aV7rgfFXr5QsMg7oqpLS4ALpkd9o2n+e/WwLsFyq73/uRzUH5oN5oyry0PGrlDQ
         5Zx6RS3V9MpUS73C0zeclYiN/o3RhvPGKQX3T+FWn9sOq8ViuJnCXrLrhQ83+17YgG
         MeRsQUQW6Biic7lR4PuSbJsmHDF9k+iML/vxjoCQ=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 0C2421B207EB;
        Mon, 30 Dec 2019 17:31:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 0C2421B207EB
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id C6D2A1B229CB;
        Mon, 30 Dec 2019 17:31:08 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:08 +0300 (MSK)
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
Subject: [PATCH RFC net-next 04/19] net: dsa: tag_ar9331: split out common tag accessors
Date:   Mon, 30 Dec 2019 17:30:12 +0300
Message-Id: <20191230143028.27313-5-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They will be reused in upcoming GRO callbacks.
(Almost) no functional changes except less informative error string.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_ar9331.c | 46 +++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 399ca21ec03b..c22c1b515e02 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -24,6 +24,25 @@
 #define AR9331_HDR_RESERVED_MASK	GENMASK(5, 4)
 #define AR9331_HDR_PORT_NUM_MASK	GENMASK(3, 0)
 
+static inline bool ar9331_tag_sanity_check(const u8 *data)
+{
+	u16 hdr = le16_to_cpup((__le16 *)(data - ETH_HLEN));
+
+	return FIELD_GET(AR9331_HDR_VERSION_MASK, hdr) == AR9331_HDR_VERSION &&
+	       !(hdr & AR9331_HDR_FROM_CPU);
+}
+
+static inline int ar9331_tag_source_port(const u8 *data)
+{
+	/* hdr comes in LE byte order, so srcport field is in the first byte */
+	return FIELD_GET(AR9331_HDR_PORT_NUM_MASK, *(data - ETH_HLEN));
+}
+
+static inline __be16 ar9331_tag_encap_proto(const u8 *data)
+{
+	return *(__be16 *)data;
+}
+
 static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 				       struct net_device *dev)
 {
@@ -50,36 +69,27 @@ static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
 				      struct net_device *ndev,
 				      struct packet_type *pt)
 {
-	u8 ver, port;
-	u16 hdr;
+	int port;
 
 	if (unlikely(!pskb_may_pull(skb, AR9331_HDR_LEN)))
 		return NULL;
 
-	hdr = le16_to_cpu(*(__le16 *)skb_mac_header(skb));
-
-	ver = FIELD_GET(AR9331_HDR_VERSION_MASK, hdr);
-	if (unlikely(ver != AR9331_HDR_VERSION)) {
-		netdev_warn_once(ndev, "%s:%i wrong header version 0x%2x\n",
-				 __func__, __LINE__, hdr);
-		return NULL;
-	}
-
-	if (unlikely(hdr & AR9331_HDR_FROM_CPU)) {
-		netdev_warn_once(ndev, "%s:%i packet should not be from cpu 0x%2x\n",
-				 __func__, __LINE__, hdr);
+	if (unlikely(!ar9331_tag_sanity_check(skb->data))) {
+		netdev_warn_once(ndev,
+				 "%s:%i wrong header version or source port\n",
+				 __func__, __LINE__);
 		return NULL;
 	}
 
-	skb_pull_rcsum(skb, AR9331_HDR_LEN);
-
 	/* Get source port information */
-	port = FIELD_GET(AR9331_HDR_PORT_NUM_MASK, hdr);
+	port = ar9331_tag_source_port(skb->data);
 
 	skb->dev = dsa_master_find_slave(ndev, 0, port);
 	if (!skb->dev)
 		return NULL;
 
+	skb_pull_rcsum(skb, AR9331_HDR_LEN);
+
 	return skb;
 }
 
@@ -87,7 +97,7 @@ static void ar9331_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				    int *offset)
 {
 	*offset = AR9331_HDR_LEN;
-	*proto = *(__be16 *)skb->data;
+	*proto = ar9331_tag_encap_proto(skb->data);
 }
 
 static const struct dsa_device_ops ar9331_netdev_ops = {
-- 
2.24.1

