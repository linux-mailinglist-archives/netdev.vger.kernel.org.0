Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0351D353814
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhDDMm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 08:42:56 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:24530 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhDDMmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 08:42:54 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d25 with ME
        id ocin2400D3g7mfN03cinKc; Sun, 04 Apr 2021 14:42:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Apr 2021 14:42:49 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] qede: Remove a erroneous ++ in 'qede_rx_build_jumbo()'
Date:   Sun,  4 Apr 2021 14:42:44 +0200
Message-Id: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This ++ is confusing. It looks duplicated with the one already performed in
'skb_fill_page_desc()'.

In fact, it is harmless. 'nr_frags' is written twice with the same value.
Once, because of the nr_frags++, and once because of the 'nr_frags = i + 1'
in 'skb_fill_page_desc()'.

So axe this post-increment to avoid confusion.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 102d0e0808d5..ee3e45e38cb7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1209,7 +1209,7 @@ static int qede_rx_build_jumbo(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, bd->mapping,
 			       PAGE_SIZE, DMA_FROM_DEVICE);
 
-		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags++,
+		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
 				   bd->data, rxq->rx_headroom, cur_size);
 
 		skb->truesize += PAGE_SIZE;
-- 
2.27.0

