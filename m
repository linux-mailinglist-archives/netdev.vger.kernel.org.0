Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94520353789
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 10:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhDDIyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 04:54:50 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:25308 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229587AbhDDIyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 04:54:49 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d76 with ME
        id oYuf240093g7mfN03YufPL; Sun, 04 Apr 2021 10:54:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Apr 2021 10:54:43 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        drt@linux.ibm.com, ljp@linux.ibm.com, sukadev@linux.ibm.com,
        tlfalcon@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ibmvnic: Use 'skb_frag_address()' instead of hand coding it
Date:   Sun,  4 Apr 2021 10:54:37 +0200
Message-Id: <1638085135ee32d5699983981b6a54a11c49ff23.1617526369.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'page_address(skb_frag_page()) + skb_frag_off()' can be replaced by an
equivalent 'skb_frag_address()' which is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9c6438d3b3a5..473411542911 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1678,9 +1678,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-			memcpy(dst + cur,
-			       page_address(skb_frag_page(frag)) +
-			       skb_frag_off(frag), skb_frag_size(frag));
+			memcpy(dst + cur, skb_frag_address(frag),
+			       skb_frag_size(frag));
 			cur += skb_frag_size(frag);
 		}
 	} else {
-- 
2.27.0

