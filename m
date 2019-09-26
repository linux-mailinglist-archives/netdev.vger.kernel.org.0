Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85EBF930
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfIZSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:30:03 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46984 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbfIZSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:30:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iDYWf-0005G8-GW; Thu, 26 Sep 2019 20:30:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, paulb@mellanox.com,
        vladbu@mellanox.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net] sk_buff: drop all skb extensions on free and skb scrubbing
Date:   Thu, 26 Sep 2019 20:37:05 +0200
Message-Id: <20190926183705.16951-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a 3rd extension, add a new helper that drops the
extension space and use it when we need to scrub an sk_buff.

At this time, scrubbing clears secpath and bridge netfilter data, but
retains the tc skb extension, after this patch all three get cleared.

NAPI reuse/free assumes we can only have a secpath attached to skb, but
it seems better to clear all extensions there as well.

v2: add unlikely hint (Eric Dumazet)

Fixes: 95a7233c452a ("net: openvswitch: Set OvS recirc_id from tc chain index")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h | 9 +++++++++
 net/core/dev.c         | 4 ++--
 net/core/skbuff.c      | 2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 907209c0794e..e7d3b1a513ef 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4144,8 +4144,17 @@ static inline void *skb_ext_find(const struct sk_buff *skb, enum skb_ext_id id)
 
 	return NULL;
 }
+
+static inline void skb_ext_reset(struct sk_buff *skb)
+{
+	if (unlikely(skb->active_extensions)) {
+		__skb_ext_put(skb->extensions);
+		skb->active_extensions = 0;
+	}
+}
 #else
 static inline void skb_ext_put(struct sk_buff *skb) {}
+static inline void skb_ext_reset(struct sk_buff *skb) {}
 static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
 static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
diff --git a/net/core/dev.c b/net/core/dev.c
index 71b18e80389f..bf3ed413abaf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5666,7 +5666,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
 static void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
 	skb_dst_drop(skb);
-	secpath_reset(skb);
+	skb_ext_put(skb);
 	kmem_cache_free(skbuff_head_cache, skb);
 }
 
@@ -5733,7 +5733,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
-	secpath_reset(skb);
+	skb_ext_reset(skb);
 
 	napi->skb = skb;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f12e8a050edb..01d65206f4fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5119,7 +5119,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->skb_iif = 0;
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
-	secpath_reset(skb);
+	skb_ext_reset(skb);
 	nf_reset(skb);
 	nf_reset_trace(skb);
 
-- 
2.21.0

