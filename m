Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B57214EE3
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgGETab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgGETaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRg-QI; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/5] net: dsa: tag_lan9303: Fix __be16 warnings
Date:   Sun,  5 Jul 2020 21:30:06 +0200
Message-Id: <20200705193008.889623-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dsa/tag_lan9303.c:76:24: warning: incorrect type in assignment (different base types)
net/dsa/tag_lan9303.c:76:24:    expected unsigned short [usertype]
net/dsa/tag_lan9303.c:76:24:    got restricted __be16 [usertype]
net/dsa/tag_lan9303.c:80:24: warning: incorrect type in assignment (different base types)
net/dsa/tag_lan9303.c:80:24:    expected unsigned short [usertype]
net/dsa/tag_lan9303.c:80:24:    got restricted __be16 [usertype]
net/dsa/tag_lan9303.c:106:31: warning: restricted __be16 degrades to integer
net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16

Make use of __be16 where appropriate to fix these warnings.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_lan9303.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index eb0e7a32e53d..ccfb6f641bbf 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -55,7 +55,8 @@ static int lan9303_xmit_use_arl(struct dsa_port *dp, u8 *dest_addr)
 static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u16 *lan9303_tag;
+	__be16 *lan9303_tag;
+	u16 tag;
 
 	/* insert a special VLAN tag between the MAC addresses
 	 * and the current ethertype field.
@@ -72,12 +73,12 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* make room between MACs and Ether-Type */
 	memmove(skb->data, skb->data + LAN9303_TAG_LEN, 2 * ETH_ALEN);
 
-	lan9303_tag = (u16 *)(skb->data + 2 * ETH_ALEN);
+	lan9303_tag = (__be16 *)(skb->data + 2 * ETH_ALEN);
+	tag = lan9303_xmit_use_arl(dp, skb->data) ?
+		LAN9303_TAG_TX_USE_ALR :
+		dp->index | LAN9303_TAG_TX_STP_OVERRIDE;
 	lan9303_tag[0] = htons(ETH_P_8021Q);
-	lan9303_tag[1] = lan9303_xmit_use_arl(dp, skb->data) ?
-				LAN9303_TAG_TX_USE_ALR :
-				dp->index | LAN9303_TAG_TX_STP_OVERRIDE;
-	lan9303_tag[1] = htons(lan9303_tag[1]);
+	lan9303_tag[1] = htons(tag);
 
 	return skb;
 }
@@ -85,7 +86,7 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
-	u16 *lan9303_tag;
+	__be16 *lan9303_tag;
 	u16 lan9303_tag1;
 	unsigned int source_port;
 
@@ -101,7 +102,7 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	 *                           ^
 	 *                        ->data
 	 */
-	lan9303_tag = (u16 *)(skb->data - 2);
+	lan9303_tag = (__be16 *)(skb->data - 2);
 
 	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
 		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
-- 
2.27.0.rc2

