Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFF3134F31
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgAHV7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:23 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:47029 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgAHV7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 16:59:22 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7eb23fa1;
        Wed, 8 Jan 2020 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=18gJNF/AcuWnp8xII6OI2UY5v
        sY=; b=2RMGlEZ5GTugMgUxDlLRgZx73t85PcCsLDQkmiQyaOw+J2LuPPgykqRGw
        UqYXsRRPNkN10/ZLgbBdBCPNWJgTaaH8VpFFjj/n9qaw5YupYvoj7qmUjoWDhhWe
        n0agWpsEaHciC4KtYcwWwuRKzFAsSyJoR8XGi2Pg1cHeYVVm+DmBSfg225nzEj3o
        xPZjLI1Zd9AM/W7ToD8+F+sg9+qYHigNfr6fwY/1Bjw1cDiWjZ4O+YKcs9QsqqFS
        lDJEeqaUJZKvGSMuBaoI6aJQSkjvk5EALku2BTV6YWEUlNSIH20Wz1JlqaOeXgVP
        NVz7KDmeWSwz+zBYDhoDIku8JcU6g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fe5cb9f5 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jan 2020 21:00:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        siva.kallam@broadcom.com, christopher.lee@cspi.com,
        ecree@solarflare.com, johannes.berg@intel.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 1/8] net: introduce skb_list_walk_safe for skb segment walking
Date:   Wed,  8 Jan 2020 16:59:02 -0500
Message-Id: <20200108215909.421487-2-Jason@zx2c4.com>
In-Reply-To: <20200108215909.421487-1-Jason@zx2c4.com>
References: <20200108215909.421487-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the continual effort to remove direct usage of skb->next and
skb->prev, this patch adds a helper for iterating through the
singly-linked variant of skb lists, which are used for lists of GSO
packet. The name "skb_list_..." has been chosen to match the existing
function, "kfree_skb_list, which also operates on these singly-linked
lists, and the "..._walk_safe" part is the same idiom as elsewhere in
the kernel.

This patch removes the helper from wireguard and puts it into
linux/skbuff.h, while making it a bit more robust for general usage. In
particular, parenthesis are added around the macro argument usage, and it
now accounts for trying to iterate through an already-null skb pointer,
which will simply run the iteration zero times. This latter enhancement
means it can be used to replace both do { ... } while and while (...)
open-coded idioms.

This should take care of these three possible usages, which match all
current methods of iterations.

skb_list_walk_safe(segs, skb, next) { ... }
skb_list_walk_safe(skb, skb, next) { ... }
skb_list_walk_safe(segs, skb, segs) { ... }

Gcc appears to generate efficient code for each of these.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.h | 8 --------
 include/linux/skbuff.h         | 5 +++++
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index c91f3051c5c7..b15a8be9d816 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -62,12 +62,4 @@ struct wg_device {
 int wg_device_init(void);
 void wg_device_uninit(void);
 
-/* Later after the dust settles, this can be moved into include/linux/skbuff.h,
- * where virtually all code that deals with GSO segs can benefit, around ~30
- * drivers as of writing.
- */
-#define skb_list_walk_safe(first, skb, next)                                   \
-	for (skb = first, next = skb->next; skb;                               \
-	     skb = next, next = skb ? skb->next : NULL)
-
 #endif /* _WG_DEVICE_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e9133bcf0544..64e5b1be9ff5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1478,6 +1478,11 @@ static inline void skb_mark_not_on_list(struct sk_buff *skb)
 	skb->next = NULL;
 }
 
+/* Iterate through singly-linked GSO fragments of an skb. */
+#define skb_list_walk_safe(first, skb, next)                                   \
+	for ((skb) = (first), (next) = (skb) ? (skb)->next : NULL; (skb);      \
+	     (skb) = (next), (next) = (skb) ? (skb)->next : NULL)
+
 static inline void skb_list_del_init(struct sk_buff *skb)
 {
 	__list_del_entry(&skb->list);
-- 
2.24.1

