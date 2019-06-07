Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD039570
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfFGTVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:06 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51138 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfFGTVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:05 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ9-0004YF-Lp; Fri, 07 Jun 2019 21:21:01 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: [PATCH v2 net-next 6/7] tg3: Use napi_alloc_frag()
Date:   Fri,  7 Jun 2019 21:20:39 +0200
Message-Id: <20190607192040.19367-7-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tg3_alloc_rx_data() uses netdev_alloc_frag() for skb allocation. All
callers of tg3_alloc_rx_data() either hold tp->lock (which is held with
BH disabled) or run in NAPI context.

Use napi_alloc_frag() for skb allocations.

Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6d1f9c822548e..4c404d2213f98 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6710,7 +6710,7 @@ static int tg3_alloc_rx_data(struct tg3 *tp, struct tg3_rx_prodring_set *tpr,
 	skb_size = SKB_DATA_ALIGN(data_size + TG3_RX_OFFSET(tp)) +
 		   SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	if (skb_size <= PAGE_SIZE) {
-		data = netdev_alloc_frag(skb_size);
+		data = napi_alloc_frag(skb_size);
 		*frag_size = skb_size;
 	} else {
 		data = kmalloc(skb_size, GFP_ATOMIC);
-- 
2.20.1

