Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0312712D0AA
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 15:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfL3Obi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 09:31:38 -0500
Received: from fd.dlink.ru ([178.170.168.18]:39574 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfL3Obi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 09:31:38 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id CC7B41B21836; Mon, 30 Dec 2019 17:31:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru CC7B41B21836
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1577716293; bh=L55d4XdjAtvKL0l9HxmdxPvldFzgURGS4JiXQm8SXdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mF95+ayjq0zPIcEQSB1FEez6ZDvINbvzYO3CSeoG6RFJNruhxeoyeLh09U3gfsQza
         YdcpYgteE2a0tAvF8SGGwkDCWonmM8OPFQVkZ7lvKg7IBM7Gy0RzTgsIbNkBQLjmnv
         9AQkbrYqtw8Y1jfa43jj34h4mzJuKY3ra/maXCCc=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 83F871B20206;
        Mon, 30 Dec 2019 17:31:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 83F871B20206
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id C95A91B229D0;
        Mon, 30 Dec 2019 17:31:03 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 30 Dec 2019 17:31:03 +0300 (MSK)
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
Subject: [PATCH RFC net-next 01/19] net: dsa: make .flow_dissect() callback returning void
Date:   Mon, 30 Dec 2019 17:30:09 +0300
Message-Id: <20191230143028.27313-2-alobakin@dlink.ru>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191230143028.27313-1-alobakin@dlink.ru>
References: <20191230143028.27313-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no tag protocols which return non-zero values from
flow_dissect() callback. Remove it to simplify code and save some
object size.
If a particular tagger can't calculate offset and proto for some
reason, it can simply leave the original values untouched.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 include/net/dsa.h         | 5 ++---
 net/core/flow_dissector.c | 8 ++++----
 net/dsa/tag_dsa.c         | 5 ++---
 net/dsa/tag_edsa.c        | 5 ++---
 net/dsa/tag_mtk.c         | 6 ++----
 net/dsa/tag_qca.c         | 6 ++----
 6 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..633d9894ab87 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -72,8 +72,8 @@ struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
-	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
-			    int *offset);
+	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
+			     int *offset);
 	/* Used to determine which traffic should match the DSA filter in
 	 * eth_type_trans, and which, if any, should bypass it and be processed
 	 * as regular on the master net device.
@@ -774,4 +774,3 @@ static struct dsa_tag_driver *dsa_tag_driver_array[] =	{		\
 };									\
 module_dsa_tag_drivers(dsa_tag_driver_array)
 #endif
-
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2dbbb030fbed..2c9d8c7c76b3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -971,12 +971,12 @@ bool __skb_flow_dissect(const struct net *net,
 #if IS_ENABLED(CONFIG_NET_DSA)
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
 			     proto == htons(ETH_P_XDSA))) {
-			const struct dsa_device_ops *ops;
+			typeof_member(struct dsa_device_ops, flow_dissect) fd;
 			int offset = 0;
 
-			ops = skb->dev->dsa_ptr->tag_ops;
-			if (ops->flow_dissect &&
-			    !ops->flow_dissect(skb, &proto, &offset)) {
+			fd = skb->dev->dsa_ptr->tag_ops->flow_dissect;
+			if (fd) {
+				fd(skb, &proto, &offset);
 				hlen -= offset;
 				nhoff += offset;
 			}
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..ef15aee58dfc 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,12 +142,11 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
+static void dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = 4;
 	*proto = ((__be16 *)skb->data)[1];
-	return 0;
 }
 
 static const struct dsa_device_ops dsa_netdev_ops = {
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index e8eaa804ccb9..37a99254b411 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -161,12 +161,11 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
+static void edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				  int *offset)
 {
 	*offset = 8;
 	*proto = ((__be16 *)skb->data)[3];
-	return 0;
 }
 
 static const struct dsa_device_ops edsa_netdev_ops = {
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index b5705cba8318..c3ad7b7b142a 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -89,13 +89,11 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
+static void mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = 4;
 	*proto = ((__be16 *)skb->data)[1];
-
-	return 0;
 }
 
 static const struct dsa_device_ops mtk_netdev_ops = {
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c95885215525..8e2dbaaffe59 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -90,13 +90,11 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-                                int *offset)
+static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
 {
 	*offset = QCA_HDR_LEN;
 	*proto = ((__be16 *)skb->data)[0];
-
-	return 0;
 }
 
 static const struct dsa_device_ops qca_netdev_ops = {
-- 
2.24.1

