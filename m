Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4EB3ACCC8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhFRNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhFRNya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B18C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:52:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1luEux-0006vZ-To; Fri, 18 Jun 2021 15:52:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, sd@queasysnail.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 2/5] xfrm: replay: remove advance indirection
Date:   Fri, 18 Jun 2021 15:51:57 +0200
Message-Id: <20210618135200.14420-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618135200.14420-1-fw@strlen.de>
References: <20210618135200.14420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to other patches: add a new helper to avoid
an indirection.

v2: fix 'net/xfrm/xfrm_replay.c:519:13: warning: 'seq' may be used
uninitialized in this function' warning.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  2 +-
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 24 +++++++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9a79e41defa7..a7f997b13198 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -306,7 +306,6 @@ struct km_event {
 };
 
 struct xfrm_replay {
-	void	(*advance)(struct xfrm_state *x, __be32 net_seq);
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
@@ -1722,6 +1721,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 }
 
 #ifdef CONFIG_XFRM
+void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
 
 static inline int xfrm_aevent_is_on(struct net *net)
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 1158cd0311d7..c8971e4b33ab 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -665,7 +665,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop_unlock;
 		}
 
-		x->repl->advance(x, seq);
+		xfrm_replay_advance(x, seq);
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 5feeb65f00b3..9565b0f7d380 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -150,14 +150,26 @@ static int xfrm_replay_check(struct xfrm_state *x,
 	return -EINVAL;
 }
 
-static void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
+static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq);
+static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq);
+
+void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq)
 {
-	u32 diff;
-	u32 seq = ntohl(net_seq);
+	u32 diff, seq;
+
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		return xfrm_replay_advance_bmp(x, net_seq);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_advance_esn(x, net_seq);
+	}
 
 	if (!x->props.replay_window)
 		return;
 
+	seq = ntohl(net_seq);
 	if (seq > x->replay.seq) {
 		diff = seq - x->replay.seq;
 		if (diff < x->props.replay_window)
@@ -695,42 +707,36 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
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
2.31.1

