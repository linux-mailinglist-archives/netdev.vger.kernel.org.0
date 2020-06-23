Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0EE205C22
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgFWTtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387535AbgFWTtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:49:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C3C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 12:49:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jnouj-0000Zi-JS; Tue, 23 Jun 2020 21:49:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 3/6] xfrm: replay: remove advance indirection
Date:   Tue, 23 Jun 2020 21:48:40 +0200
Message-Id: <20200623194843.19612-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623194843.19612-1-fw@strlen.de>
References: <20200623194843.19612-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to other patches: add a new helper to avoid
an indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  2 +-
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 24 ++++++++++++++----------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index ed105257c5a8..78bbfd370e34 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -304,7 +304,6 @@ struct km_event {
 };
 
 struct xfrm_replay {
-	void	(*advance)(struct xfrm_state *x, __be32 net_seq);
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
@@ -1719,6 +1718,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 }
 
 #ifdef CONFIG_XFRM
+void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
 
 static inline int xfrm_aevent_is_on(struct net *net)
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index bd984ff17c2d..b4b559b35cf1 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -663,7 +663,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop_unlock;
 		}
 
-		x->repl->advance(x, seq);
+		xfrm_replay_advance(x, seq);
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index fac2f3af4c1a..8a99316d8d7d 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -151,11 +151,23 @@ static int xfrm_replay_check(struct xfrm_state *x,
 	return -EINVAL;
 }
 
-static void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
+static void xfrm_replay_advance_bmp(struct xfrm_state *x, u32 seq);
+static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq);
+
+void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
 {
 	u32 diff;
 	u32 seq = ntohl(net_seq);
 
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		return xfrm_replay_advance_bmp(x, seq);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_advance_esn(x, net_seq);
+	}
+
 	if (!x->props.replay_window)
 		return;
 
@@ -242,12 +254,11 @@ static int xfrm_replay_check_bmp(struct xfrm_state *x,
 	return -EINVAL;
 }
 
-static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
+static void xfrm_replay_advance_bmp(struct xfrm_state *x, u32 seq)
 {
 	unsigned int bitnr, nr, i;
 	u32 diff;
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
-	u32 seq = ntohl(net_seq);
 	u32 pos;
 
 	if (!replay_esn->replay_window)
@@ -501,7 +512,6 @@ static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 	if (!replay_esn->replay_window)
 		return;
 
-	seq = ntohl(net_seq);
 	pos = (replay_esn->seq - 1) % replay_esn->replay_window;
 	seq_hi = xfrm_replay_seqhi(x, net_seq);
 	wrap = seq_hi - replay_esn->seq_hi;
@@ -677,42 +687,36 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 }
 
 static const struct xfrm_replay xfrm_replay_legacy = {
-	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow_offload,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
-	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_offload_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
-	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
 	.overflow	= xfrm_replay_overflow_offload_esn,
 };
 #else
 static const struct xfrm_replay xfrm_replay_legacy = {
-	.advance	= xfrm_replay_advance,
 	.check		= xfrm_replay_check,
 	.recheck	= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
-	.advance	= xfrm_replay_advance_bmp,
 	.check		= xfrm_replay_check_bmp,
 	.recheck	= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
-	.advance	= xfrm_replay_advance_esn,
 	.check		= xfrm_replay_check_esn,
 	.recheck	= xfrm_replay_recheck_esn,
 	.overflow	= xfrm_replay_overflow_esn,
-- 
2.26.2

