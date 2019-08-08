Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344D2862A4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732912AbfHHNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:10:23 -0400
Received: from packetmixer.de ([79.140.42.25]:58708 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732645AbfHHNKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 09:10:23 -0400
Received: from kero.packetmixer.de (p200300C5971AA600F539B63C8CCC72B7.dip0.t-ipconnect.de [IPv6:2003:c5:971a:a600:f539:b63c:8ccc:72b7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id AF4BD6206D;
        Thu,  8 Aug 2019 15:02:10 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/2] batman-adv: Fix deletion of RTR(4|6) mcast list entries
Date:   Thu,  8 Aug 2019 15:02:08 +0200
Message-Id: <20190808130208.2124-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808130208.2124-1-sw@simonwunderlich.de>
References: <20190808130208.2124-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The multicast code uses the lists bat_priv->mcast.want_all_rtr*_list to
store all all originator nodes which don't have the flag no-RTR4 or no-RTR6
set. When an originator is purged, it has to be removed from these lists.

Since all entries without the BATADV_MCAST_WANT_NO_RTR4/6 are stored in
these lists, they have to be handled like entries which have these flags
set to force the update routines to remove them from the lists when purging
the originator.

Not doing so will leave a pointer to a freed memory region inside the list.
Trying to operate on these lists will then cause an use-after-free error:

  BUG: KASAN: use-after-free in batadv_mcast_want_rtr4_update+0x335/0x3a0 [batman_adv]
  Write of size 8 at addr ffff888007b41a38 by task swapper/0/0

Fixes: 61caf3d109f5 ("batman-adv: mcast: detect, distribute and maintain multicast router presence")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index a3488cfb3d1e..1d5bdf3a4b65 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -2420,8 +2420,10 @@ void batadv_mcast_purge_orig(struct batadv_orig_node *orig)
 	batadv_mcast_want_unsnoop_update(bat_priv, orig, BATADV_NO_FLAGS);
 	batadv_mcast_want_ipv4_update(bat_priv, orig, BATADV_NO_FLAGS);
 	batadv_mcast_want_ipv6_update(bat_priv, orig, BATADV_NO_FLAGS);
-	batadv_mcast_want_rtr4_update(bat_priv, orig, BATADV_NO_FLAGS);
-	batadv_mcast_want_rtr6_update(bat_priv, orig, BATADV_NO_FLAGS);
+	batadv_mcast_want_rtr4_update(bat_priv, orig,
+				      BATADV_MCAST_WANT_NO_RTR4);
+	batadv_mcast_want_rtr6_update(bat_priv, orig,
+				      BATADV_MCAST_WANT_NO_RTR6);
 
 	spin_unlock_bh(&orig->mcast_handler_lock);
 }
-- 
2.20.1

