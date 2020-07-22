Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C032295D2
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgGVKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:17:10 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:21223 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731472AbgGVKRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:17:09 -0400
Received: from localhost.localdomain ([93.23.199.134])
        by mwinf5d52 with ME
        id 6AH32300b2uUVcV03AH4tY; Wed, 22 Jul 2020 12:17:06 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 22 Jul 2020 12:17:06 +0200
X-ME-IP: 93.23.199.134
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] ipw2100: Use GFP_KERNEL instead of GFP_ATOMIC in some memory allocation
Date:   Wed, 22 Jul 2020 12:17:01 +0200
Message-Id: <20200722101701.26126-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_tx_allocate

No lock is taken in the between.
So it is safe to use GFP_KERNEL in 'ipw2100_tx_allocate()'.

BTW, 'ipw2100_queues_allocate()' also calls 'ipw2100_msg_allocate()' which
already allocates some memory using GFP_KERNEL.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 83d2f2acc0de..699deca745a2 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -4430,7 +4430,7 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 
 	priv->tx_buffers = kmalloc_array(TX_PENDED_QUEUE_LENGTH,
 					 sizeof(struct ipw2100_tx_packet),
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!priv->tx_buffers) {
 		bd_queue_free(priv, &priv->tx_queue);
 		return -ENOMEM;
-- 
2.25.1

