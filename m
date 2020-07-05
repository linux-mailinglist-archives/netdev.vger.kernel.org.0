Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B30214EE2
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgGETa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:30:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgGETaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:30:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsALD-003jRj-RO; Sun, 05 Jul 2020 21:30:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/5] net: dsa: tag_mtk: Fix warnings for __be16
Date:   Sun,  5 Jul 2020 21:30:07 +0200
Message-Id: <20200705193008.889623-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/dsa/tag_mtk.c:84:13: warning: incorrect type in assignment (different base types)
net/dsa/tag_mtk.c:84:13:    expected restricted __be16 [usertype] hdr
net/dsa/tag_mtk.c:84:13:    got int
net/dsa/tag_mtk.c:94:17: warning: restricted __be16 degrades to integer

The result of a ntohs() is not __be16, but u16.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/tag_mtk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index d6619edd53e5..f602fc758d68 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -67,8 +67,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
+	u16 hdr;
 	int port;
-	__be16 *phdr, hdr;
+	__be16 *phdr;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
-- 
2.27.0.rc2

