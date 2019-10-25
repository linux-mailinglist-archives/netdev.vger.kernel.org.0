Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C517CE41BB
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 04:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390715AbfJYCro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 22:47:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:53148 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbfJYCro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 22:47:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x9P2lPkV002163;
        Thu, 24 Oct 2019 21:47:26 -0500
Message-ID: <572a7d510ace5e5a5ba41c4774d330133291c82a.camel@kernel.crashing.org>
Subject: [PATCH] net: ethernet: ftgmac100: Fix DMA coherency issue with SW
 checksum
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vijay Khemka <vijaykhemka@fb.com>, openbmc@lists.ozlabs.org,
        Joel Stanley <joel@jms.id.au>, linux-aspeed@lists.ozlabs.org
Date:   Fri, 25 Oct 2019 13:47:24 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are calling the checksum helper after the dma_map_single()
call to map the packet. This is incorrect as the checksumming
code will touch the packet from the CPU. This means the cache
won't be properly flushes (or the bounce buffering will leave
us with the unmodified packet to DMA).

This moves the calculation of the checksum & vlan tags to
before the DMA mapping.

This also has the side effect of fixing another bug: If the
checksum helper fails, we goto "drop" to drop the packet, which
will not unmap the DMA mapping.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: 05690d633f30 ftgmac100: Upgrade to NETIF_F_HW_CSUM
CC: stable@vger.kernel.org [v4.12+]
---
 drivers/net/ethernet/faraday/ftgmac100.c | 25 ++++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 9b7af94a40bb..96e9565f1e08 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -727,6 +727,18 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	 */
 	nfrags = skb_shinfo(skb)->nr_frags;
 
+	/* Setup HW checksumming */
+	csum_vlan = 0;
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    !ftgmac100_prep_tx_csum(skb, &csum_vlan))
+		goto drop;
+
+	/* Add VLAN tag */
+	if (skb_vlan_tag_present(skb)) {
+		csum_vlan |= FTGMAC100_TXDES1_INS_VLANTAG;
+		csum_vlan |= skb_vlan_tag_get(skb) & 0xffff;
+	}
+
 	/* Get header len */
 	len = skb_headlen(skb);
 
@@ -753,19 +765,6 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	if (nfrags == 0)
 		f_ctl_stat |= FTGMAC100_TXDES0_LTS;
 	txdes->txdes3 = cpu_to_le32(map);
-
-	/* Setup HW checksumming */
-	csum_vlan = 0;
-	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    !ftgmac100_prep_tx_csum(skb, &csum_vlan))
-		goto drop;
-
-	/* Add VLAN tag */
-	if (skb_vlan_tag_present(skb)) {
-		csum_vlan |= FTGMAC100_TXDES1_INS_VLANTAG;
-		csum_vlan |= skb_vlan_tag_get(skb) & 0xffff;
-	}
-
 	txdes->txdes1 = cpu_to_le32(csum_vlan);
 
 	/* Next descriptor */


