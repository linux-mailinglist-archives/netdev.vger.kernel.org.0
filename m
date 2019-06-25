Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CD8557B8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfFYTUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:20:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35392 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfFYTUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:20:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hfqzX-0004NW-8X; Tue, 25 Jun 2019 21:20:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH net] net: make skb_dst_force return false when dst was cleared
Date:   Tue, 25 Jun 2019 21:22:09 +0200
Message-Id: <20190625192209.6250-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM and netfilter don't expect that skb_dst_force() can cause skb to lose
its dst entry.

I got a bug report with a skb->dst NULL dereference in netfilter
output path.  The backtrace contains nf_reinject(), so the dst
might have been cleared when skb got queued to userspace.

The xfrm part of this change was done after code inspection,
it looks like similar crash could happen here too.

One way to fix this is to add a skb_dst() check right after
skb_dst_force() call, but I think its preferable to make the
'dst might get cleared' part of the function explicit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/dst.h        | 6 +++++-
 net/netfilter/nf_queue.c | 6 +++++-
 net/xfrm/xfrm_policy.c   | 5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 12b31c602cb0..42cd53d51364 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -302,8 +302,9 @@ static inline bool dst_hold_safe(struct dst_entry *dst)
  * @skb: buffer
  *
  * If dst is not yet refcounted and not destroyed, grab a ref on it.
+ * Returns false if skb had a destroyed dst.
  */
-static inline void skb_dst_force(struct sk_buff *skb)
+static inline bool skb_dst_force(struct sk_buff *skb)
 {
 	if (skb_dst_is_noref(skb)) {
 		struct dst_entry *dst = skb_dst(skb);
@@ -313,7 +314,10 @@ static inline void skb_dst_force(struct sk_buff *skb)
 			dst = NULL;
 
 		skb->_skb_refdst = (unsigned long)dst;
+		return dst != NULL;
 	}
+
+	return true;
 }
 
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index b5b2be55ca82..dc8628a919a5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -190,6 +190,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
+	if (!skb_dst_force(skb)) {
+		status = -ENETDOWN;
+		goto err;
+	}
+
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.state	= *state,
@@ -198,7 +203,6 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	};
 
 	nf_queue_entry_get_refs(entry);
-	skb_dst_force(skb);
 
 	switch (entry->state.pf) {
 	case AF_INET:
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b1694d5d15d3..5c66c18d5ff5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2842,7 +2842,10 @@ static int xdst_queue_output(struct net *net, struct sock *sk, struct sk_buff *s
 		return -EAGAIN;
 	}
 
-	skb_dst_force(skb);
+	if (!skb_dst_force(skb)) {
+		kfree_skb(skb);
+		return -ENETDOWN;
+	}
 
 	spin_lock_bh(&pq->hold_queue.lock);
 
-- 
2.21.0

