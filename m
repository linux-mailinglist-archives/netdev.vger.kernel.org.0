Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD91B3ACCC6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhFRNy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhFRNy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CC7C061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:52:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1luEut-0006vL-NM; Fri, 18 Jun 2021 15:52:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, sd@queasysnail.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 1/5] xfrm: replay: avoid xfrm replay notify indirection
Date:   Fri, 18 Jun 2021 15:51:56 +0200
Message-Id: <20210618135200.14420-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618135200.14420-1-fw@strlen.de>
References: <20210618135200.14420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 3a01570410ab..9a79e41defa7 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -145,6 +145,12 @@ enum {
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
@@ -218,6 +224,8 @@ struct xfrm_state {
 	/* The functions for replay detection. */
 	const struct xfrm_replay *repl;
 
+	/* replay detection mode */
+	enum xfrm_replay_mode    repl_mode;
 	/* internal flag that only holds state for delayed aevent at the
 	 * moment
 	*/
@@ -305,7 +313,6 @@ struct xfrm_replay {
 	int	(*recheck)(struct xfrm_state *x,
 			   struct sk_buff *skb,
 			   __be32 net_seq);
-	void	(*notify)(struct xfrm_state *x, int event);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
@@ -1715,6 +1722,8 @@ static inline int xfrm_policy_id2dir(u32 index)
 }
 
 #ifdef CONFIG_XFRM
+void xfrm_replay_notify(struct xfrm_state *x, int event);
+
 static inline int xfrm_aevent_is_on(struct net *net)
 {
 	struct sock *nlsk;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index c6a4338a0d08..5feeb65f00b3 100644
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
@@ -98,7 +112,7 @@ static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 			return err;
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -157,7 +171,7 @@ static void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
 	}
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
@@ -178,7 +192,7 @@ static int xfrm_replay_overflow_bmp(struct xfrm_state *x, struct sk_buff *skb)
 			return err;
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -273,7 +287,7 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
@@ -416,7 +430,7 @@ static int xfrm_replay_overflow_esn(struct xfrm_state *x, struct sk_buff *skb)
 			}
 		}
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -548,7 +562,7 @@ static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 	replay_esn->bmp[nr] |= (1U << bitnr);
 
 	if (xfrm_aevent_is_on(xs_net(x)))
-		x->repl->notify(x, XFRM_REPLAY_UPDATE);
+		xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 }
 
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -585,7 +599,7 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 		x->replay.oseq = oseq;
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -625,7 +639,7 @@ static int xfrm_replay_overflow_offload_bmp(struct xfrm_state *x, struct sk_buff
 		}
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -674,7 +688,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 		replay_esn->oseq = oseq;
 
 		if (xfrm_aevent_is_on(net))
-			x->repl->notify(x, XFRM_REPLAY_UPDATE);
+			xfrm_replay_notify(x, XFRM_REPLAY_UPDATE);
 	}
 
 	return err;
@@ -684,7 +698,6 @@ static const struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
-	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow_offload,
 };
 
@@ -692,7 +705,6 @@ static const struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
-	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_offload_bmp,
 };
 
@@ -700,7 +712,6 @@ static const struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
-	.notify		= xfrm_replay_notify_esn,
 	.overflow	= xfrm_replay_overflow_offload_esn,
 };
 #else
@@ -708,7 +719,6 @@ static const struct xfrm_replay xfrm_replay_legacy = {
 	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
-	.notify		= xfrm_replay_notify,
 	.overflow	= xfrm_replay_overflow,
 };
 
@@ -716,7 +726,6 @@ static const struct xfrm_replay xfrm_replay_bmp = {
 	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
-	.notify		= xfrm_replay_notify_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
 
@@ -724,7 +733,6 @@ static const struct xfrm_replay xfrm_replay_esn = {
 	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
-	.notify		= xfrm_replay_notify_esn,
 	.overflow	= xfrm_replay_overflow_esn,
 };
 #endif
@@ -742,11 +750,14 @@ int xfrm_init_replay(struct xfrm_state *x)
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
index 8f6058e56f7f..c2ce1e6f4760 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2177,7 +2177,7 @@ static void xfrm_replay_timer_handler(struct timer_list *t)
 
 	if (x->km.state == XFRM_STATE_VALID) {
 		if (xfrm_aevent_is_on(xs_net(x)))
-			x->repl->notify(x, XFRM_REPLAY_TIMEOUT);
+			xfrm_replay_notify(x, XFRM_REPLAY_TIMEOUT);
 		else
 			x->xflags |= XFRM_TIME_DEFER;
 	}
-- 
2.31.1

