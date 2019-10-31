Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F66EAB16
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfJaHnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:43:14 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:22948 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJaHnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 03:43:14 -0400
Received: from localhost.localdomain ([93.23.12.90])
        by mwinf5d87 with ME
        id L7j9210091waAWt037j9B8; Thu, 31 Oct 2019 08:43:12 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 31 Oct 2019 08:43:12 +0100
X-ME-IP: 93.23.12.90
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] batman-adv: Simplify 'batadv_v_ogm_aggr_list_free()'
Date:   Thu, 31 Oct 2019 08:42:55 +0100
Message-Id: <20191031074255.3234-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'skb_queue_purge()' instead of re-implementing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
BTW, I don't really see the need of 'aggr_list_lock'. I think that the code
could be refactored to drop 'aggr_list_lock' and use the already existing
'aggr_list.lock'.
This would require to use the lock-free __skb_... variants when working on
'aggr_list'.

As far as I understand, the use of 'aggr_list' and 'aggr_list_lock' is
limited to bat_v_ogm.c'. So the impact would be limited.
This would avoid a useless locking that never fails, so the performance
gain should be really limited.

So, I'm not sure this would be more readable and/or future proof, so
I just note it here to open the discussion.

If interested, I have a (compiled tested only) patch that implements this
change.
---
 net/batman-adv/bat_v_ogm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index dc4f7430cb5a..b841c83d9c3b 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -177,13 +177,9 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
  */
 static void batadv_v_ogm_aggr_list_free(struct batadv_hard_iface *hard_iface)
 {
-	struct sk_buff *skb;
-
 	lockdep_assert_held(&hard_iface->bat_v.aggr_list_lock);
 
-	while ((skb = skb_dequeue(&hard_iface->bat_v.aggr_list)))
-		kfree_skb(skb);
-
+	skb_queue_purge(&hard_iface->bat_v.aggr_list);
 	hard_iface->bat_v.aggr_len = 0;
 }
 
-- 
2.20.1

