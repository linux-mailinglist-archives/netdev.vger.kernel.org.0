Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18BD2E7EE
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfE2WPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:15:39 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49960 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbfE2WPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:15:34 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.89)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1hW6r5-0008F3-Mg; Thu, 30 May 2019 00:15:32 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Subject: [PATCH net-next 6/7] tg3: Use napi_alloc_frag()
Date:   Thu, 30 May 2019 00:15:22 +0200
Message-Id: <20190529221523.22399-7-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529221523.22399-1-bigeasy@linutronix.de>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,HEADER_FROM_DIFFERENT_DOMAINS=0.001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tg3_alloc_rx_data() uses netdev_alloc_frag() for sbk allocation. All
callers of tg3_alloc_rx_data() either hold the tp->lock lock (which is
held with BH disabled) or run in NAPI context.

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

