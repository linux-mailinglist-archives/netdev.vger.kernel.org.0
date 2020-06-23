Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC02205C1F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgFWTs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387490AbgFWTs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:48:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A1CC061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 12:48:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jnoue-0000ZM-1v; Tue, 23 Jun 2020 21:48:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 1/6] xfrm: replay: avoid xfrm replay notify indirection
Date:   Tue, 23 Jun 2020 21:48:38 +0200
Message-Id: <20200623194843.19612-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623194843.19612-1-fw@strlen.de>
References: <20200623194843.19612-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

replay protection is implemented using a callback structure and then
called via

   x->repl->notify(), x->repl->recheck(), and so on.

all the differect functions are always built-in, so this could be direct
calls instead.

This first patch prepares for removal of the x->repl structure.
Add an enum with the three available replay modes to the xfrm_state
structure and then replace all x->repl->notify() calls by the new
xfrm_replay_notify() helper.

The helper checks the enum internally to adapt behaviour as needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     | 11 ++++++++++-
 net/xfrm/xfrm_replay.c | 45 ++++++++++++++++++++++++++----------------
 net/xfrm/xfrm_state.c  |  2 +-
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e20b2b27ec48..ed105257c5a8 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -144,6 +144,12 @@ enum {
 	XFRM_MODE_FLAG_TUNNEL = 1,
 };
 
+enum xfrm_replay_mode {
+	XFRM_REPLAY_MODE_LEGACY,
+	XFRM_REPLAY_MODE_BMP,
+	XFRM_REPLAY_MODE_ESN,
+};
+
 /* Full description of state of transformer. */
 struct xfrm_state {
 	possible_net_t		xs_net;
@@ -216,6 +222,8 @@ struct xfrm_state {
 	/* The functions for replay detection. */
 	const struct xfrm_replay *repl;
 
+	/* replay detection mode */
+	enum xfrm_replay_mode    repl_mode;
 	/* internal flag that only holds state for delayed aevent at the
 	 * moment
 	*/
@@ -303,7 +311,6 @@ struct xfrm_replay {
 	int	(*recheck)(struct xfrm_state *x,
 			   struct sk_buff *skb,
 			   __be32 net_seq);
-	void	(*notify)(struct xfrm_state *x, int event);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
@@ -1712,6 +1719,8 @@ static inline int xfrm_policy_id2dir(u32 index)
 }
 
 #ifdef CONFIG_XFRM
+void xfrm_replay_notify(struct xfrm_state *x, int event);
+
 static inline int xfrm_aevent_is_on(struct net *net)
 {
 	struct sock *nlsk;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 98943f8d01aa..e42a7afb8ee5 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -34,8 +34,11 @@ u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq)
 	return seq_hi;
 }
 EXPORT_SYMBOL(xfrm_replay_seqhi);
-;
-static void xfrm_replay_notify(struct xfrm_state *x, int event)
+
+static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event);
+static void xfrm_replay_notify_esn(struct xfrm_state *x, int event);
+
+void xfrm_replay_notify(struct xfrm_state *x, int event)
 {
 	struct km_event c;
 	/* we send notify messages in case
@@ -48,6 +51,17 @@ static void xfrm_replay_notify(struct xfrm_state *x, int event)
 	 *  The state structure must be locked!
 	 */
 
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		xfrm_replay_notify_bmp(x, event);
+		return;
+	case XFRM_REPLAY_MODE_ESN:
+		xfrm_replay_notify_esn(x, event);
+		return;
+	}
+
 	switch (event) {
 	case XFRM_REPLAY_UPDATE:
 		if (!x->replay_maxdiff ||
@@ -97,7 +111,7 @@ static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 			return err;
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -156,7 +170,7 @@ static void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
 	}
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
@@ -176,7 +190,7 @@ static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
 			return err;
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -271,7 +285,7 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
@@ -414,7 +428,7 @@ static int xfrm_replay_overflow_esn(struct xfrm_state *x, struct sk_buff *skb)
 			}
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -546,7 +560,7 @@ static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -582,7 +596,7 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 		x->replay.oseq = oseq;
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -621,7 +635,7 @@ static int xfrm_replay_overflow_offload_bmp(struct xfrm_state *x, struct sk_buff
 		}
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -670,7 +684,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 		replay_esn->oseq = oseq;
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -680,7 +694,6 @@ static const struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
-	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow_offload,
 };
 
@@ -688,7 +701,6 @@ static const struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
-	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_offload_bmp,
 };
 
@@ -696,7 +708,6 @@ static const struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
-	.notify		= xfrm_replay_notify_esn,
 	.overflow	= xfrm_replay_overflow_offload_esn,
 };
 #else
@@ -704,7 +715,6 @@ static const struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
-	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow,
 };
 
@@ -712,7 +722,6 @@ static const struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
-	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
 
@@ -720,7 +729,6 @@ static const struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
-	.notify		= xfrm_replay_notify_esn,
 	.overflow	= xfrm_replay_overflow_esn,
 };
 #endif
@@ -738,11 +746,14 @@ int xfrm_init_replay(struct xfrm_state *x)
 			if (replay_esn->replay_window == 0)
 				return -EINVAL;
 			x->repl = &xfrm_replay_esn;
+			x->repl_mode = XFRM_REPLAY_MODE_ESN;
 		} else {
 			x->repl = &xfrm_replay_bmp;
+			x->repl_mode = XFRM_REPLAY_MODE_BMP;
 		}
 	} else {
 		x->repl = &xfrm_replay_legacy;
+		x->repl_mode = XFRM_REPLAY_MODE_LEGACY;
 	}
 
 	return 0;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 8be2d926acc2..c51bbcc263c7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2110,7 +2110,7 @@ static void xfrm_replay_timer_handler(struct timer_list *t)
 
 	if (x->km.state == XFRM_STATE_VALID) {
 		if (xfrm_aevent_is_on(xs_net(x)))
-			x->repl->notify(x, XFRM_REPLAY_TIMEOUT);
+			xfrm_replay_notify(x, XFRM_REPLAY_TIMEOUT);
 		else
 			x->xflags |= XFRM_TIME_DEFER;
 	}
-- 
2.26.2

