Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AD3537A6
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 11:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhDDJpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 05:45:20 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:31545 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229530AbhDDJpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 05:45:19 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d76 with ME
        id oZlD2400B3g7mfN03ZlDM8; Sun, 04 Apr 2021 11:45:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Apr 2021 11:45:14 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sfc: Use 'skb_add_rx_frag()' instead of hand coding it
Date:   Sun,  4 Apr 2021 11:45:11 +0200
Message-Id: <6fadc5ae05b05d9d8ab545e51ee3dcbdaa561393.1617529446.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some lines of code can be merged into an equivalent 'skb_add_rx_frag()'
call which is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
UNTESTED. Compile tested only

The 'skb->truesize' computation is likely to be slightly slower (n
additions hidden in 'skb_add_rx_frag' instead of 1 multiplication), but I
don't think that it is an issue here.
---
 drivers/net/ethernet/sfc/rx.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 89c5c75f479f..17b8119c48e5 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -94,12 +94,11 @@ static struct sk_buff *efx_rx_mk_skb(struct efx_channel *channel,
 		rx_buf->len -= hdr_len;
 
 		for (;;) {
-			skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
-					   rx_buf->page, rx_buf->page_offset,
-					   rx_buf->len);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					rx_buf->page, rx_buf->page_offset,
+					rx_buf->len, efx->rx_buffer_truesize);
 			rx_buf->page = NULL;
-			skb->len += rx_buf->len;
-			skb->data_len += rx_buf->len;
+
 			if (skb_shinfo(skb)->nr_frags == n_frags)
 				break;
 
@@ -111,8 +110,6 @@ static struct sk_buff *efx_rx_mk_skb(struct efx_channel *channel,
 		n_frags = 0;
 	}
 
-	skb->truesize += n_frags * efx->rx_buffer_truesize;
-
 	/* Move past the ethernet header */
 	skb->protocol = eth_type_trans(skb, efx->net_dev);
 
-- 
2.27.0

