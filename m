Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9F7BACC
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfGaHin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 03:38:43 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:29887 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726169AbfGaHin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 03:38:43 -0400
Received: from localhost.localdomain ([176.167.166.146])
        by mwinf5d75 with ME
        id jKec2000i39qjAg03KedzC; Wed, 31 Jul 2019 09:38:39 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 31 Jul 2019 09:38:39 +0200
X-ME-IP: 176.167.166.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mark.einon@gmail.com, davem@davemloft.net, willy@infradead.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: ethernet: et131x: Use GFP_KERNEL instead of GFP_ATOMIC when allocating tx_ring->tcb_ring
Date:   Wed, 31 Jul 2019 09:38:42 +0200
Message-Id: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no good reason to use GFP_ATOMIC here. Other memory allocations
are performed with GFP_KERNEL (see other 'dma_alloc_coherent()' below and
'kzalloc()' in 'et131x_rx_dma_memory_alloc()')

Use GFP_KERNEL which should be enough.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/agere/et131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index e43d922f043e..174344c450af 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2362,7 +2362,7 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Allocate memory for the TCB's (Transmit Control Block) */
 	tx_ring->tcb_ring = kcalloc(NUM_TCB, sizeof(struct tcb),
-				    GFP_ATOMIC | GFP_DMA);
+				    GFP_KERNEL | GFP_DMA);
 	if (!tx_ring->tcb_ring)
 		return -ENOMEM;
 
-- 
2.20.1

