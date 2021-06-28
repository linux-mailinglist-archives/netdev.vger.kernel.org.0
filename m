Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5014A3B58CD
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhF1F5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:30 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40966 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhF1F5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:57:24 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id D7AD7800055;
        Mon, 28 Jun 2021 07:54:57 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:54:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:54:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B775E318064D; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 17/17] xfrm: replay: remove last replay indirection
Date:   Mon, 28 Jun 2021 07:45:22 +0200
Message-ID: <20210628054522.1718786-18-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This replaces the overflow indirection with the new xfrm_replay_overflow
helper.  After this, the 'repl' pointer in xfrm_state is no longer
needed and can be removed as well.

xfrm_replay_overflow() is added in two incarnations, one is used
when the kernel is compiled with xfrm hardware offload support enabled,
the other when its disabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.25.1

