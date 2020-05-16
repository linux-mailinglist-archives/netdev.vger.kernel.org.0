Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EBF1D5FC6
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgEPIsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:48:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5F3C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:48:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsUF-0005ue-AL; Sat, 16 May 2020 10:48:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 7/7] net: allow __skb_ext_alloc to sleep
Date:   Sat, 16 May 2020 10:46:23 +0200
Message-Id: <20200516084623.28453-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp calls this from the transmit side, from process context.
Allow a sleeping allocation instead of unconditional GFP_ATOMIC.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/skbuff.h | 2 +-
 net/core/skbuff.c      | 8 +++++---
 net/mptcp/protocol.c   | 4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3000c526f552..531843952809 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4165,7 +4165,7 @@ struct skb_ext {
 	char data[] __aligned(8);
 };
 
-struct skb_ext *__skb_ext_alloc(void);
+struct skb_ext *__skb_ext_alloc(gfp_t flags);
 void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
 		    struct skb_ext *ext);
 void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1bf0c3d278e7..35a133c6d13b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6087,13 +6087,15 @@ static void *skb_ext_get_ptr(struct skb_ext *ext, enum skb_ext_id id)
 /**
  * __skb_ext_alloc - allocate a new skb extensions storage
  *
+ * @flags: See kmalloc().
+ *
  * Returns the newly allocated pointer. The pointer can later attached to a
  * skb via __skb_ext_set().
  * Note: caller must handle the skb_ext as an opaque data.
  */
-struct skb_ext *__skb_ext_alloc(void)
+struct skb_ext *__skb_ext_alloc(gfp_t flags)
 {
-	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
+	struct skb_ext *new = kmem_cache_alloc(skbuff_ext_cache, flags);
 
 	if (new) {
 		memset(new->offset, 0, sizeof(new->offset));
@@ -6188,7 +6190,7 @@ void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
 	} else {
 		newoff = SKB_EXT_CHUNKSIZEOF(*new);
 
-		new = __skb_ext_alloc();
+		new = __skb_ext_alloc(GFP_ATOMIC);
 		if (!new)
 			return NULL;
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index bc950cf818f7..e3a628bea2b8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -367,8 +367,10 @@ static void mptcp_stop_timer(struct sock *sk)
 
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 {
+	const struct sock *sk = (const struct sock *)msk;
+
 	if (!msk->cached_ext)
-		msk->cached_ext = __skb_ext_alloc();
+		msk->cached_ext = __skb_ext_alloc(sk->sk_allocation);
 
 	return !!msk->cached_ext;
 }
-- 
2.26.2

