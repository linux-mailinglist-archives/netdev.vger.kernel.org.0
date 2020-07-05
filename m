Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22EA214EDF
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGETaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgGETaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRm-SV; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 5/5] net: dsa: tag_qca.c: Fix warning for __be16 vs u16
Date:   Sun,  5 Jul 2020 21:30:08 +0200
Message-Id: <20200705193008.889623-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dsa/tag_qca.c:48:15: warning: incorrect type in assignment (different base types)
net/dsa/tag_qca.c:48:15:    expected unsigned short [usertype]
net/dsa/tag_qca.c:48:15:    got restricted __be16 [usertype]
net/dsa/tag_qca.c:68:13: warning: incorrect type in assignment (different base types)
net/dsa/tag_qca.c:68:13:    expected restricted __be16 [usertype] hdr
net/dsa/tag_qca.c:68:13:    got int
net/dsa/tag_qca.c:71:16: warning: restricted __be16 degrades to integer
net/dsa/tag_qca.c:81:17: warning: restricted __be16 degrades to integer

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_qca.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 70db7c909f74..7066f5e697d7 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -31,7 +31,8 @@
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u16 *phdr, hdr;
+	__be16 *phdr;
+	u16 hdr;
 
 	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
 		return NULL;
@@ -39,7 +40,7 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-	phdr = (u16 *)(skb->data + 2 * ETH_ALEN);
+	phdr = (__be16 *)(skb->data + 2 * ETH_ALEN);
 
 	/* Set the version field, and set destination port information */
 	hdr = QCA_HDR_VERSION << QCA_HDR_XMIT_VERSION_S |
@@ -54,8 +55,9 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
 	u8 ver;
+	u16  hdr;
 	int port;
-	__be16 *phdr, hdr;
+	__be16 *phdr;
 
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
-- 
2.27.0.rc2

