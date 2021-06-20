Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2093ADEE5
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhFTNpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 09:45:47 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:48708 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhFTNpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 09:45:46 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d33 with ME
        id KRjW2500A21Fzsu03RjWtS; Sun, 20 Jun 2021 15:43:31 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 20 Jun 2021 15:43:31 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, shacharr@microsoft.com, gustavoars@kernel.org
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: mana: Fix a memory leak in an error handling path in 'mana_create_txq()'
Date:   Sun, 20 Jun 2021 15:43:28 +0200
Message-Id: <578bcaa1a9d6916c86aaecf65f205492affb6fc8.1624196430.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this test fails we must free some resources as in all the other error
handling paths of this function.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 46aee2c49f1b..fff78900fc8a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1230,8 +1230,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		cq->gdma_id = cq->gdma_cq->id;
 
-		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs))
-			return -EINVAL;
+		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-- 
2.30.2

