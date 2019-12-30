Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6212D0C4
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfL3OdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:33:11 -0500
Received: from fd.dlink.ru ([178.170.168.18]:41874 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbfL3OdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:33:09 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 6BCE91B217AA; Mon, 30 Dec 2019 17:33:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 6BCE91B217AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716387; bh=E3wS4CWwlylImJof0eomCAHaPV4aLBnqVAQ7xnSqdyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Qftev2ueaGIVY4zzEYCsME+eo1cGckqntBGIumT1i/W04+E3S6EimJDK3QKF8PxpU
         hBufEmJZN3rih6dRIIzSX8nC0Zvwr+Jm+nx9SkQYTd/H41//GFItsicC8EcqrVuL4l
         Qt6hZzuiYbVuymQdu8plQk79S1tZholmTCiR0eyk=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 70CB51B21845;
        Mon, 30 Dec 2019 17:31:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 70CB51B21845
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 4683B1B229D0;
        Mon, 30 Dec 2019 17:31:35 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:35 +0300 (MSK)
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
Subject: [PATCH RFC net-next 17/19] net: dsa: tag_qca: switch to bitfield helpers
Date:   Mon, 30 Dec 2019 17:30:25 +0300
Message-Id: <20191230143028.27313-18-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make code look cleaner and more readable by using bitfield macros.
Misc: fix several macro identation and phdr type in qca_tag_xmit().

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 net/dsa/tag_qca.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index e1c4dd04734a..8939abce36d7 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -3,15 +3,15 @@
  * Copyright (c) 2015, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/bitfield.h>
 #include <linux/etherdevice.h>
 
 #include "dsa_priv.h"
 
-#define QCA_HDR_LEN	2
-#define QCA_HDR_VERSION	0x2
+#define QCA_HDR_LEN			2
+#define QCA_HDR_VERSION			0x2
 
-#define QCA_HDR_RECV_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_RECV_VERSION_S		14
+#define QCA_HDR_RECV_VERSION(tag)	FIELD_GET(GENMASK(15, 14), tag)
 #define QCA_HDR_RECV_PRIORITY_MASK	GENMASK(13, 11)
 #define QCA_HDR_RECV_PRIORITY_S		11
 #define QCA_HDR_RECV_TYPE_MASK		GENMASK(10, 6)
@@ -19,19 +19,20 @@
 #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
 #define QCA_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 
-#define QCA_HDR_XMIT_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_XMIT_VERSION_S		14
+#define QCA_HDR_XMIT_VERSION		FIELD_PREP(GENMASK(15, 14), \
+						   QCA_HDR_VERSION)
 #define QCA_HDR_XMIT_PRIORITY_MASK	GENMASK(13, 11)
 #define QCA_HDR_XMIT_PRIORITY_S		11
 #define QCA_HDR_XMIT_CONTROL_MASK	GENMASK(10, 8)
 #define QCA_HDR_XMIT_CONTROL_S		8
 #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
-#define QCA_HDR_XMIT_DP_BIT_MASK	GENMASK(6, 0)
+#define QCA_HDR_XMIT_DP(port)		FIELD_PREP(GENMASK(6, 0), BIT(port))
 
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u16 *phdr, hdr;
+	const struct dsa_port *dp = dsa_slave_to_port(dev);
+	__be16 *phdr;
+	u16 hdr;
 
 	if (skb_cow_head(skb, 0) < 0)
 		return NULL;
@@ -39,11 +40,11 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-	phdr = (u16 *)(skb->data + 2 * ETH_ALEN);
+	phdr = (__be16 *)(skb->data + 2 * ETH_ALEN);
 
 	/* Set the version field, and set destination port information */
-	hdr = QCA_HDR_VERSION << QCA_HDR_XMIT_VERSION_S |
-		QCA_HDR_XMIT_FROM_CPU | BIT(dp->index);
+	hdr = QCA_HDR_XMIT_VERSION | QCA_HDR_XMIT_FROM_CPU |
+	      QCA_HDR_XMIT_DP(dp->index);
 
 	*phdr = htons(hdr);
 
@@ -53,7 +54,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
-	u8 ver;
 	int port;
 	__be16 *phdr, hdr;
 
@@ -68,8 +68,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	hdr = ntohs(*phdr);
 
 	/* Make sure the version is correct */
-	ver = (hdr & QCA_HDR_RECV_VERSION_MASK) >> QCA_HDR_RECV_VERSION_S;
-	if (unlikely(ver != QCA_HDR_VERSION))
+	if (unlikely(QCA_HDR_RECV_VERSION(hdr) != QCA_HDR_VERSION))
 		return NULL;
 
 	/* Remove QCA tag and recalculate checksum */
-- 
2.24.1

