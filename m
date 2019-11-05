Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E32EF98C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfKEJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:41 -0500
Received: from simonwunderlich.de ([79.140.42.25]:35574 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730759AbfKEJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:36 -0500
Received: from kero.packetmixer.de (p200300C5970F5D00F0ACF07C9CF9C7D8.dip0.t-ipconnect.de [IPv6:2003:c5:970f:5d00:f0ac:f07c:9cf9:c7d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 502526205B;
        Tue,  5 Nov 2019 10:35:34 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/5] batman-adv: Simplify 'batadv_v_ogm_aggr_list_free()'
Date:   Tue,  5 Nov 2019 10:35:28 +0100
Message-Id: <20191105093531.11398-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105093531.11398-1-sw@simonwunderlich.de>
References: <20191105093531.11398-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Use 'skb_queue_purge()' instead of re-implementing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_ogm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 8033f24f506c..76b732e2f31c 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -178,13 +178,9 @@ static bool batadv_v_ogm_queue_left(struct sk_buff *skb,
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

