Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30674EAA80
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfJaFz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:55:27 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:36769 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJaFz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:55:27 -0400
Received: from localhost.localdomain ([93.23.12.90])
        by mwinf5d87 with ME
        id L5vM2100A1waAWt035vNi3; Thu, 31 Oct 2019 06:55:25 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 31 Oct 2019 06:55:25 +0100
X-ME-IP: 93.23.12.90
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, vishal@chelsio.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] cxgb4/l2t: Simplify 't4_l2e_free()' and '_t4_l2e_free()'
Date:   Thu, 31 Oct 2019 06:53:45 +0100
Message-Id: <20191031055345.32487-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use '__skb_queue_purge()' instead of re-implementing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/chelsio/cxgb4/l2t.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/l2t.c b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
index 1a407d3c1d67..e9e45006632d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/l2t.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/l2t.c
@@ -351,15 +351,13 @@ static struct l2t_entry *find_or_alloc_l2e(struct l2t_data *d, u16 vlan,
 static void _t4_l2e_free(struct l2t_entry *e)
 {
 	struct l2t_data *d;
-	struct sk_buff *skb;
 
 	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		if (e->neigh) {
 			neigh_release(e->neigh);
 			e->neigh = NULL;
 		}
-		while ((skb = __skb_dequeue(&e->arpq)) != NULL)
-			kfree_skb(skb);
+		__skb_queue_purge(&e->arpq);
 	}
 
 	d = container_of(e, struct l2t_data, l2tab[e->idx]);
@@ -370,7 +368,6 @@ static void _t4_l2e_free(struct l2t_entry *e)
 static void t4_l2e_free(struct l2t_entry *e)
 {
 	struct l2t_data *d;
-	struct sk_buff *skb;
 
 	spin_lock_bh(&e->lock);
 	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
@@ -378,8 +375,7 @@ static void t4_l2e_free(struct l2t_entry *e)
 			neigh_release(e->neigh);
 			e->neigh = NULL;
 		}
-		while ((skb = __skb_dequeue(&e->arpq)) != NULL)
-			kfree_skb(skb);
+		__skb_queue_purge(&e->arpq);
 	}
 	spin_unlock_bh(&e->lock);
 
-- 
2.20.1

