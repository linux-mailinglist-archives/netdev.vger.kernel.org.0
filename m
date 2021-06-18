Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C13ACCCB
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhFRNyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhFRNyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778FC061767
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:52:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1luEvA-0006wU-Ot; Fri, 18 Jun 2021 15:52:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, sd@queasysnail.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 5/5] xfrm: replay: remove last replay indirection
Date:   Fri, 18 Jun 2021 15:52:00 +0200
Message-Id: <20210618135200.14420-6-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618135200.14420-1-fw@strlen.de>
References: <20210618135200.14420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces the overflow indirection with the new xfrm_replay_overflow
helper.  After this, the 'repl' pointer in xfrm_state is no longer
needed and can be removed as well.

xfrm_replay_overflow() is added in two incarnations, one is used
when the kernel is compiled with xfrm hardware offload support enabled,
the other when its disabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  8 +------
 net/xfrm/xfrm_output.c |  2 +-
 net/xfrm/xfrm_replay.c | 51 +++++++++++++++++++++---------------------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 0206d80ec291..d2a0559c255f 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -221,9 +221,6 @@ struct xfrm_state {
 	struct xfrm_replay_state preplay;
 	struct xfrm_replay_state_esn *preplay_esn;
 
-	/* The functions for replay detection. */
-	const struct xfrm_replay *repl;
-
 	/* replay detection mode */
 	enum xfrm_replay_mode    repl_mode;
 	/* internal flag that only holds state for delayed aevent at the
@@ -305,10 +302,6 @@ struct km_event {
 	struct net *net;
 };
 
-struct xfrm_replay {
-	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
-};
-
 struct xfrm_if_cb {
 	struct xfrm_if	*(*decode_session)(struct sk_buff *skb,
 					   unsigned short family);
@@ -1718,6 +1711,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
+int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
 static inline int xfrm_aevent_is_on(struct net *net)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 0b2975ef0668..527da58464f3 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -525,7 +525,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 			goto error;
 		}
 
-		err = x->repl->overflow(x, skb);
+		err = xfrm_replay_overflow(x, skb);
 		if (err) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATESEQERROR);
 			goto error;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index e8703aa8d06a..9277d81b344c 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -95,7 +95,7 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
 		x->xflags &= ~XFRM_TIME_DEFER;
 }
 
-static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
+static int __xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = 0;
 	struct net *net = xs_net(x);
@@ -617,7 +617,7 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 	__u32 oseq = x->replay.oseq;
 
 	if (!xo)
-		return xfrm_replay_overflow(x, skb);
+		return __xfrm_replay_overflow(x, skb);
 
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		if (!skb_is_gso(skb)) {
@@ -737,29 +737,33 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 	return err;
 }
 
-static const struct xfrm_replay xfrm_replay_legacy = {
-	.overflow	= xfrm_replay_overflow_offload,
-};
-
-static const struct xfrm_replay xfrm_replay_bmp = {
-	.overflow	= xfrm_replay_overflow_offload_bmp,
-};
+int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
+{
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		return xfrm_replay_overflow_offload_bmp(x, skb);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_overflow_offload_esn(x, skb);
+	}
 
-static const struct xfrm_replay xfrm_replay_esn = {
-	.overflow	= xfrm_replay_overflow_offload_esn,
-};
+	return xfrm_replay_overflow_offload(x, skb);
+}
 #else
-static const struct xfrm_replay xfrm_replay_legacy = {
-	.overflow	= xfrm_replay_overflow,
-};
-
-static const struct xfrm_replay xfrm_replay_bmp = {
-	.overflow	= xfrm_replay_overflow_bmp,
-};
+int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
+{
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		return xfrm_replay_overflow_bmp(x, skb);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_overflow_esn(x, skb);
+	}
 
-static const struct xfrm_replay xfrm_replay_esn = {
-	.overflow	= xfrm_replay_overflow_esn,
-};
+	return __xfrm_replay_overflow(x, skb);
+}
 #endif
 
 int xfrm_init_replay(struct xfrm_state *x)
@@ -774,14 +778,11 @@ int xfrm_init_replay(struct xfrm_state *x)
 		if (x->props.flags & XFRM_STATE_ESN) {
 			if (replay_esn->replay_window == 0)
 				return -EINVAL;
-			x->repl = &xfrm_replay_esn;
 			x->repl_mode = XFRM_REPLAY_MODE_ESN;
 		} else {
-			x->repl = &xfrm_replay_bmp;
 			x->repl_mode = XFRM_REPLAY_MODE_BMP;
 		}
 	} else {
-		x->repl = &xfrm_replay_legacy;
 		x->repl_mode = XFRM_REPLAY_MODE_LEGACY;
 	}
 
-- 
2.31.1

