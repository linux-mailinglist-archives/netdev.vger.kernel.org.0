Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C57B7BB2C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfGaIGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:06:45 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:32102 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726248AbfGaIGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:06:45 -0400
Received: from localhost.localdomain ([176.167.166.146])
        by mwinf5d75 with ME
        id jL6i2000J39qjAg03L6j45; Wed, 31 Jul 2019 10:06:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 31 Jul 2019 10:06:43 +0200
X-ME-IP: 176.167.166.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jcliburn@gmail.com, davem@davemloft.net, chris.snook@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] net: ag71xx: Use GFP_KERNEL instead of GFP_ATOMIC in 'ag71xx_rings_init()'
Date:   Wed, 31 Jul 2019 10:06:48 +0200
Message-Id: <75ee52ae065ce9cb1f32d88939b166773316dc45.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
References: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to use GFP_ATOMIC here, GFP_KERNEL should be enough.
The 'kcalloc()' just a few lines above, already uses GFP_KERNEL.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I've done my best to check if a spinlock can be hold when reaching this
code. Apparently it is never the case.
But double check to be sure that it is not the kcalloc that should use
GFP_ATOMIC.
---
 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 40a8717f51b1..7548247455d7 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1141,7 +1141,7 @@ static int ag71xx_rings_init(struct ag71xx *ag)
 
 	tx->descs_cpu = dma_alloc_coherent(&ag->pdev->dev,
 					   ring_size * AG71XX_DESC_SIZE,
-					   &tx->descs_dma, GFP_ATOMIC);
+					   &tx->descs_dma, GFP_KERNEL);
 	if (!tx->descs_cpu) {
 		kfree(tx->buf);
 		tx->buf = NULL;
-- 
2.20.1

