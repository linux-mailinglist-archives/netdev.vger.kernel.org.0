Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21129570D4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFZSjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:39:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42848 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZSjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:39:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hgCpU-0004N0-Pz; Wed, 26 Jun 2019 20:39:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     eric.dumazet@gmail.com, <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net v2] net: make skb_dst_force return true when dst is refcounted
Date:   Wed, 26 Jun 2019 20:40:45 +0200
Message-Id: <20190626184045.2922-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netfilter did not expect that skb_dst_force() can cause skb to lose its
dst entry.

I got a bug report with a skb->dst NULL dereference in netfilter
output path.  The backtrace contains nf_reinject(), so the dst might have
been cleared when skb got queued to userspace.

Other users were fixed via
if (skb_dst(skb)) {
	skb_dst_force(skb);
	if (!skb_dst(skb))
		goto handle_err;
}

But I think its preferable to make the 'dst might be cleared' part
of the function explicit.

In netfilter case, skb with a null dst is expected when queueing in
prerouting hook, so drop skb for the other hooks.

v2:
 v1 of this patch returned true in case skb had no dst entry.
 Eric said:
   Say if we have two skb_dst_force() calls for some reason
   on the same skb, only the first one will return false.

 This now returns false even when skb had no dst, as per Erics
 suggestion, so callers might need to check skb_dst() first before
 skb_dst_force().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/dst.h        | 5 ++++-
 net/netfilter/nf_queue.c | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

 Alternatively this could be routed via netfilter tree, let me
 know your preference.

 I've submitted a nfqueue testcase to nf-devel@ , it still passes after
 this change.

diff --git a/include/net/dst.h b/include/net/dst.h
index 12b31c602cb0..f8206d3fed2f 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -302,8 +302,9 @@ static inline bool dst_hold_safe(struct dst_entry *dst)
  * @skb: buffer
  *
  * If dst is not yet refcounted and not destroyed, grab a ref on it.
+ * Returns true if dst is refcounted.
  */
-static inline void skb_dst_force(struct sk_buff *skb)
+static inline bool skb_dst_force(struct sk_buff *skb)
 {
 	if (skb_dst_is_noref(skb)) {
 		struct dst_entry *dst = skb_dst(skb);
@@ -314,6 +315,8 @@ static inline void skb_dst_force(struct sk_buff *skb)
 
 		skb->_skb_refdst = (unsigned long)dst;
 	}
+
+	return skb->_skb_refdst != 0UL;
 }
 
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index b5b2be55ca82..2c440015ff0c 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -190,6 +190,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
+	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
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
-- 
2.21.0

