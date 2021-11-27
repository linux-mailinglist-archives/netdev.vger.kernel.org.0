Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A6945FFBC
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244636AbhK0PY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:24:28 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57049 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbhK0PW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:22:28 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id qzTnmWicnUujjqzTomVrmB; Sat, 27 Nov 2021 16:19:12 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 27 Nov 2021 16:19:12 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: spider_net: Use non-atomic bitmap API when applicable
Date:   Sat, 27 Nov 2021 16:18:59 +0100
Message-Id: <3de0792f5088f00d135c835df6c19e63ae95f5d2.1638026251.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No concurrent access is possible when a bitmap is local to a function.
So prefer the non-atomic functions to save a few cycles.
   - replace a 'for' loop by an equivalent non-atomic 'bitmap_fill()' call
   - use '__set_bit()'

While at it, clear the 'bitmask' bitmap only when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is *not* compile tested. I don't have the needed cross compiling
tool chain.
---
 drivers/net/ethernet/toshiba/spider_net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index f50f9a43d3ea..f47b8358669d 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -595,24 +595,24 @@ spider_net_set_multi(struct net_device *netdev)
 	int i;
 	u32 reg;
 	struct spider_net_card *card = netdev_priv(netdev);
-	DECLARE_BITMAP(bitmask, SPIDER_NET_MULTICAST_HASHES) = {};
+	DECLARE_BITMAP(bitmask, SPIDER_NET_MULTICAST_HASHES);
 
 	spider_net_set_promisc(card);
 
 	if (netdev->flags & IFF_ALLMULTI) {
-		for (i = 0; i < SPIDER_NET_MULTICAST_HASHES; i++) {
-			set_bit(i, bitmask);
-		}
+		bitmap_fill(bitmask, SPIDER_NET_MULTICAST_HASHES);
 		goto write_hash;
 	}
 
+	bitmap_zero(bitmask, SPIDER_NET_MULTICAST_HASHES);
+
 	/* well, we know, what the broadcast hash value is: it's xfd
 	hash = spider_net_get_multicast_hash(netdev, netdev->broadcast); */
-	set_bit(0xfd, bitmask);
+	__set_bit(0xfd, bitmask);
 
 	netdev_for_each_mc_addr(ha, netdev) {
 		hash = spider_net_get_multicast_hash(netdev, ha->addr);
-		set_bit(hash, bitmask);
+		__set_bit(hash, bitmask);
 	}
 
 write_hash:
-- 
2.30.2

