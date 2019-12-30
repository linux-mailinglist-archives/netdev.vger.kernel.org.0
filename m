Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6DB12D0C8
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfL3OdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:33:07 -0500
Received: from mail.dlink.ru ([178.170.168.18]:41828 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfL3OdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:33:07 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id D8C511B219B4; Mon, 30 Dec 2019 17:33:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D8C511B219B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716383; bh=vMMdZPRhhDCtnbuTLqLyjTW+Dv/ebEhvjE+SEn3R/dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=q+4eCZKXbiwuHnSky7eu3NnhSbbj/By887r1ZTyr1ZBZG/H/YMJWL3FDkyz0wpoOm
         HlC7hxvNbCiDhdIiK8GdyFqiIKpVw9fTFg5E3Qsv0wetzhbXuDH8HGZcGqFyEIuE7E
         e0lWIr2TnhmhhHvxF02fhyDdiHn5T1yI9bLq8DbQ=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id DD1001B21836;
        Mon, 30 Dec 2019 17:31:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru DD1001B21836
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 6D13F1B229CB;
        Mon, 30 Dec 2019 17:31:37 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:37 +0300 (MSK)
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
Subject: [PATCH RFC net-next 18/19] net: dsa: tag_qca: split out common tag accessors
Date:   Mon, 30 Dec 2019 17:30:26 +0300
Message-Id: <20191230143028.27313-19-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...to make them available for the upcoming GRO callbacks.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_qca.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 8939abce36d7..bee2788e034d 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -28,6 +28,27 @@
 #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
 #define QCA_HDR_XMIT_DP(port)		FIELD_PREP(GENMASK(6, 0), BIT(port))
 
+static inline bool qca_tag_sanity_check(const u8 *data)
+{
+	/* The QCA header is added by the switch between src addr and Ethertype
+	 * At this point, skb->data points to ethertype so header should be
+	 * right before
+	 */
+	u16 hdr = ntohs(*(__be16 *)(data - 2));
+
+	return QCA_HDR_RECV_VERSION(hdr) == QCA_HDR_VERSION;
+}
+
+static inline int qca_tag_source_port(const u8 *data)
+{
+	return *(data - 1) & QCA_HDR_RECV_SOURCE_PORT_MASK;
+}
+
+static inline __be16 qca_tag_encap_proto(const u8 *data)
+{
+	return *(__be16 *)data;
+}
+
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	const struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -55,34 +76,26 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
 	int port;
-	__be16 *phdr, hdr;
 
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
-	/* The QCA header is added by the switch between src addr and Ethertype
-	 * At this point, skb->data points to ethertype so header should be
-	 * right before
-	 */
-	phdr = (__be16 *)(skb->data - 2);
-	hdr = ntohs(*phdr);
-
 	/* Make sure the version is correct */
-	if (unlikely(QCA_HDR_RECV_VERSION(hdr) != QCA_HDR_VERSION))
+	if (unlikely(!qca_tag_sanity_check(skb->data)))
 		return NULL;
 
-	/* Remove QCA tag and recalculate checksum */
-	skb_pull_rcsum(skb, QCA_HDR_LEN);
-	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - QCA_HDR_LEN,
-		ETH_HLEN - QCA_HDR_LEN);
-
 	/* Get source port information */
-	port = (hdr & QCA_HDR_RECV_SOURCE_PORT_MASK);
+	port = qca_tag_source_port(skb->data);
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev)
 		return NULL;
 
+	/* Remove QCA tag and recalculate checksum */
+	skb_pull_rcsum(skb, QCA_HDR_LEN);
+	memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - QCA_HDR_LEN,
+		ETH_HLEN - QCA_HDR_LEN);
+
 	return skb;
 }
 
@@ -90,7 +103,7 @@ static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 				 int *offset)
 {
 	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
+	*proto = qca_tag_encap_proto(skb->data);
 }
 
 static const struct dsa_device_ops qca_netdev_ops = {
-- 
2.24.1

