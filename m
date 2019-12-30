Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD41612D379
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 19:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfL3SoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 13:44:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41522 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbfL3SoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 13:44:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so33468177wrw.8;
        Mon, 30 Dec 2019 10:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aEXa88L0kRuP5gotOzXyyrfFcAc/gBTFiuKfEoutSbA=;
        b=jVOC/J42X6gqNNYzqn6CchuFXLSAJvvZYCAnKWiusvr2AjnN+RG4RIL9vzIeOO8yVL
         bdQY04CeLVt5R4NPgpxBMgb3bsaIp/Mbb8NPvAX9fAgb8bGwbd8G8mRRWtTsCl/nVPfV
         JWDPsLRIOgeBemIYZoXPTnXVPzq9hYbnKz+aB8FXYu55olH3y+o+VmQvuQubR7IQpMhk
         OG5fBqYKoN1iXuRolm67s/VUp4IQaFuiWo/TtLEYT9KvDOfWc3LjrbPeSRj4JCBsFWzJ
         xZdR8+oXaam1o6yevuW7mKbHcW0kXfbu+uJ98QC7+KMrJ35TWPDPHOkWFYlDjD2Dhqow
         0GGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aEXa88L0kRuP5gotOzXyyrfFcAc/gBTFiuKfEoutSbA=;
        b=SX4abnawRRgpD8abXTtqYcmxgFhur3VSPv2DA49FTW7wKwDMbGle8hP54pOZ7aYour
         780cftKdJkVTf7jgwheQrq9v6hzp179wYJvjKpSPTagTFVO0e++p34epCcBK6CzoYpfF
         sVVcite6bE/T+rEGrXXgBtCLW8dZvj5Eq0mh1q2YaiOx7+0RPW5ifxWiIlWMTNwGKEh4
         xKuyooqBvWmSQswDlx6JJ2quduus1FWtrhqwSPcvw2evYAlnKK0qSBf/MVst0w1TasMT
         V7Ov4pLGcNHCc8hMnxUGN5xh5tsNiNbeyg4DNnFyiiUGArRAvADoNjP7wVo9FwdZtbLg
         Fc5w==
X-Gm-Message-State: APjAAAU6Mb0lNrmBrxc4OCfyoxxVvuqXKCs6pge0iC98/9leS0dt0Mvy
        xKG2blqV1QcR37LtCZq21HnUWUFG
X-Google-Smtp-Source: APXvYqzTveRQa/61w63Vzt39bwhFzs296eXFxp28ecmRDGkQUGGqMdlOb+0Ck7QADkwI2944QtMUPQ==
X-Received: by 2002:a5d:6ac5:: with SMTP id u5mr68008926wrw.271.1577731450020;
        Mon, 30 Dec 2019 10:44:10 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b137sm260692wme.26.2019.12.30.10.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:44:09 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alobakin@dlink.ru, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [RFC net-next] net: dsa: Remove indirect function call for flow dissection
Date:   Mon, 30 Dec 2019 10:44:00 -0800
Message-Id: <20191230184402.9455-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need "static" information to be given for DSA flow dissection,
replace the call to .flow_dissect() with an unsigned integer given us
the offset into the packet that we must de-reference to obtain the
protocol number.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Alexander,

This should probably require us to fix all DSA taggers to provide a
valid proto_off otherwise we would be incorrectly dissecting a flow, but
that still sounds like an improvement to me.

Thanks!

 include/net/dsa.h         |  3 +--
 net/core/flow_dissector.c | 13 ++++++++-----
 net/dsa/tag_dsa.c         | 10 +---------
 net/dsa/tag_edsa.c        | 10 +---------
 net/dsa/tag_mtk.c         | 11 +----------
 net/dsa/tag_qca.c         | 11 +----------
 6 files changed, 13 insertions(+), 45 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 6767dc3f66c0..8e3e1fa06d75 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -70,14 +70,13 @@ struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
-	int (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
-			    int *offset);
 	/* Used to determine which traffic should match the DSA filter in
 	 * eth_type_trans, and which, if any, should bypass it and be processed
 	 * as regular on the master net device.
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
+	unsigned int proto_off;
 	const char *name;
 	enum dsa_tag_protocol proto;
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index d524a693e00f..9037ebdddac1 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -972,13 +972,16 @@ bool __skb_flow_dissect(const struct net *net,
 		if (unlikely(skb->dev && netdev_uses_dsa(skb->dev) &&
 			     proto == htons(ETH_P_XDSA))) {
 			const struct dsa_device_ops *ops;
-			int offset = 0;
+			unsigned int overhead;
+			unsigned int proto_off;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
-			if (ops->flow_dissect &&
-			    !ops->flow_dissect(skb, &proto, &offset)) {
-				hlen -= offset;
-				nhoff += offset;
+			overhead = ops->overhead;
+			proto_off = ops->proto_off;
+			if (overhead && likely(proto_off < skb->len)) {
+				hlen -= overhead;
+				nhoff += overhead;
+				proto = ((__be16 *)skb->data)[proto_off];
 			}
 		}
 #endif
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7ddec9794477..4a970e959fef 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,21 +142,13 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-	return 0;
-}
-
 static const struct dsa_device_ops dsa_netdev_ops = {
 	.name	= "dsa",
 	.proto	= DSA_TAG_PROTO_DSA,
 	.xmit	= dsa_xmit,
 	.rcv	= dsa_rcv,
-	.flow_dissect   = dsa_tag_flow_dissect,
 	.overhead = DSA_HLEN,
+	.proto_off = 1,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index e8eaa804ccb9..c7cb0df17287 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -161,21 +161,13 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = 8;
-	*proto = ((__be16 *)skb->data)[3];
-	return 0;
-}
-
 static const struct dsa_device_ops edsa_netdev_ops = {
 	.name	= "edsa",
 	.proto	= DSA_TAG_PROTO_EDSA,
 	.xmit	= edsa_xmit,
 	.rcv	= edsa_rcv,
-	.flow_dissect   = edsa_tag_flow_dissect,
 	.overhead = EDSA_HLEN,
+	.proto_off = 3,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index b5705cba8318..c96354f12317 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -89,22 +89,13 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-
-	return 0;
-}
-
 static const struct dsa_device_ops mtk_netdev_ops = {
 	.name		= "mtk",
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
-	.flow_dissect	= mtk_tag_flow_dissect,
 	.overhead	= MTK_HDR_LEN,
+	.proto_off	= 1,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index c95885215525..a88849d211f0 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -90,22 +90,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static int qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-                                int *offset)
-{
-	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
-
-	return 0;
-}
-
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
-	.flow_dissect = qca_tag_flow_dissect,
 	.overhead = QCA_HDR_LEN,
+	.proto_offset = 0,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.17.1

