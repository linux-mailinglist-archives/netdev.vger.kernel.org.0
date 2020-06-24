Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817B206EAE
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390342AbgFXIIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387732AbgFXIIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:08:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D709BC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:08:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jo0SQ-00069M-DK; Wed, 24 Jun 2020 10:08:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 6/6] xfrm: replay: remove last replay indirection
Date:   Wed, 24 Jun 2020 10:08:04 +0200
Message-Id: <20200624080804.7480-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624080804.7480-1-fw@strlen.de>
References: <20200624080804.7480-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces the overflow indirection with the new xfrm_replay_overflow
helper.  After this, the 'repl' pointer in xfrm_state is no longer
needed and can be removed as well.

xfrm_replay_overflow() is added in two incarnations, one is used
when the kernel is configured with xfrm offload enabled, the other
when its disabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  8 +------
 net/xfrm/xfrm_output.c |  2 +-
 net/xfrm/xfrm_replay.c | 51 +++++++++++++++++++++---------------------
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 008b564cb126..c0f3e8a3fdd0 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -219,9 +219,6 @@ struct xfrm_state {
 	struct xfrm_replay_state preplay;
 	struct xfrm_replay_state_esn *preplay_esn;
 
-	/* The functions for replay detection. */
-	const struct xfrm_replay *repl;
-
 	/* replay detection mode */
 	enum xfrm_replay_mode    repl_mode;
 	/* internal flag that only holds state for delayed aevent at the
@@ -303,10 +300,6 @@ struct km_event {
 	struct net *net;
 };
 
-struct xfrm_replay {
-	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
-};
-
 struct xfrm_if_cb {
 	struct xfrm_if	*(*decode_session)(struct sk_buff *skb,
 					   unsigned short family);
@@ -1715,6 +1708,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
+int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
 static inline int xfrm_aevent_is_on(struct net *net)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e4c23f69f69f..8893a37690ad 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -448,7 +448,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 			goto error;
 		}
 
-		err = x->repl->overflow(x, skb);
+		err = xfrm_replay_overflow(x, skb);
 		if (err) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATESEQERROR);
 			goto error;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 8c97fcaf17cf..7630d002107b 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -97,7 +97,7 @@ void xfrm_replay_notify(struct xfrm_state *x, int event)
 		x->xflags &= ~XFRM_TIME_DEFER;
 }
 
-static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
+static int __xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err = 0;
 	struct net *net = xs_net(x);
@@ -601,7 +601,7 @@ static int xfrm_replay_overflow_offload(struct xfrm_state *x, struct sk_buff *sk
 	__u32 oseq = x->replay.oseq;
 
 	if (!xo)
-		return xfrm_replay_overflow(x, skb);
+		return __xfrm_replay_overflow(x, skb);
 
 	if (x->type->flags & XFRM_TYPE_REPLAY_PROT) {
 		if (!skb_is_gso(skb)) {
@@ -719,29 +719,33 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
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
@@ -756,14 +760,11 @@ int xfrm_init_replay(struct xfrm_state *x)
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
2.26.2

