Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C0353713
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 08:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhDDGd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 02:33:56 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:34195 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhDDGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 02:33:55 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d04 with ME
        id oWZo240023g7mfN03WZoWv; Sun, 04 Apr 2021 08:33:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Apr 2021 08:33:49 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: ag71xx: Slightly simplify 'ag71xx_rx_packets()'
Date:   Sun,  4 Apr 2021 08:33:44 +0200
Message-Id: <7fadf8e80b7fea5e5bc8ce606f3aec8cd7bd60e8.1617517935.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to use 'list_for_each_entry_safe' here, as nothing is
removed from the list in the 'for' loop.
Use 'list_for_each_entry' instead, it is slightly less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index a60ce9030581..7352f98123c7 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1658,9 +1658,9 @@ static int ag71xx_rx_packets(struct ag71xx *ag, int limit)
 	struct net_device *ndev = ag->ndev;
 	int ring_mask, ring_size, done = 0;
 	unsigned int pktlen_mask, offset;
-	struct sk_buff *next, *skb;
 	struct ag71xx_ring *ring;
 	struct list_head rx_list;
+	struct sk_buff *skb;
 
 	ring = &ag->rx_ring;
 	pktlen_mask = ag->dcfg->desc_pktlen_mask;
@@ -1725,7 +1725,7 @@ static int ag71xx_rx_packets(struct ag71xx *ag, int limit)
 
 	ag71xx_ring_rx_refill(ag);
 
-	list_for_each_entry_safe(skb, next, &rx_list, list)
+	list_for_each_entry(skb, &rx_list, list)
 		skb->protocol = eth_type_trans(skb, ndev);
 	netif_receive_skb_list(&rx_list);
 
-- 
2.27.0

