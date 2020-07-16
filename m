Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279D9222D45
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGPUwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:52:45 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:21122 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgGPUwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:52:45 -0400
Received: from localhost.localdomain ([93.22.39.121])
        by mwinf5d12 with ME
        id 3wsi2300F2cqCS503wsidg; Thu, 16 Jul 2020 22:52:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 16 Jul 2020 22:52:43 +0200
X-ME-IP: 93.22.39.121
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, jes@trained-monkey.org
Cc:     linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: alteon: Avoid some useless memset
Date:   Thu, 16 Jul 2020 22:52:42 +0200
Message-Id: <20200716205242.326486-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a memset after a call to 'dma_alloc_coherent()'.
This is useless since
commit 518a2f1925c3 ("dma-mapping: zero memory returned from dma_alloc_*")

Replace a kmalloc+memset with a corresponding kzalloc.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/alteon/acenic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 99431c9a899b..ac86fcae1582 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1151,7 +1151,7 @@ static int ace_init(struct net_device *dev)
 	/*
 	 * Get the memory for the skb rings.
 	 */
-	if (!(ap->skb = kmalloc(sizeof(struct ace_skb), GFP_KERNEL))) {
+	if (!(ap->skb = kzalloc(sizeof(struct ace_skb), GFP_KERNEL))) {
 		ecode = -EAGAIN;
 		goto init_error;
 	}
@@ -1172,9 +1172,6 @@ static int ace_init(struct net_device *dev)
 	ap->last_mini_rx = 0;
 #endif
 
-	memset(ap->info, 0, sizeof(struct ace_info));
-	memset(ap->skb, 0, sizeof(struct ace_skb));
-
 	ecode = ace_load_firmware(dev);
 	if (ecode)
 		goto init_error;
-- 
2.25.1

