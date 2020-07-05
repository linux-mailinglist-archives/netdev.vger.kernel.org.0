Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A33214EE0
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgGETaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgGETaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRd-PC; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/5] net: dsa: tag_ksz: Fix __be16 warnings
Date:   Sun,  5 Jul 2020 21:30:05 +0200
Message-Id: <20200705193008.889623-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpu_to_be16 returns a __be16 value. So what it is assigned to needs to
have the same type to avoid warnings.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_ksz.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 90d055c4df9e..bd1a3158d79a 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -156,8 +156,9 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct sk_buff *nskb;
-	u16 *tag;
+	__be16 *tag;
 	u8 *addr;
+	u16 val;
 
 	nskb = ksz_common_xmit(skb, dev, KSZ9477_INGRESS_TAG_LEN);
 	if (!nskb)
@@ -167,12 +168,12 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	tag = skb_put(nskb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(nskb);
 
-	*tag = BIT(dp->index);
+	val = BIT(dp->index);
 
 	if (is_link_local_ether_addr(addr))
-		*tag |= KSZ9477_TAIL_TAG_OVERRIDE;
+		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
-	*tag = cpu_to_be16(*tag);
+	*tag = cpu_to_be16(val);
 
 	return nskb;
 }
-- 
2.27.0.rc2

