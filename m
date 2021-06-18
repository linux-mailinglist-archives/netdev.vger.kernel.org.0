Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0420B3ACCCA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhFRNyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhFRNyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:54:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23708C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 06:52:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1luEv6-0006wH-F1; Fri, 18 Jun 2021 15:52:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, sd@queasysnail.net,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 4/5] xfrm: replay: avoid replay indirection
Date:   Fri, 18 Jun 2021 15:51:59 +0200
Message-Id: <20210618135200.14420-5-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618135200.14420-1-fw@strlen.de>
References: <20210618135200.14420-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add and use xfrm_replay_check helper instead of indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  4 +---
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 27 ++++++++++++++++++---------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3a219b34cb8c..0206d80ec291 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -306,9 +306,6 @@ struct km_event {
 };
 
 struct xfrm_replay {
-	int	(*check)(struct xfrm_state *x,
-			 struct sk_buff *skb,
-			 __be32 net_seq);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
@@ -1719,6 +1716,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 
 #ifdef CONFIG_XFRM
 void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
+int xfrm_replay_check(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
 int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 8046ef1a6680..3df0861d4390 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -612,7 +612,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop_unlock;
 		}
 
-		if (x->repl->check(x, skb, seq)) {
+		if (xfrm_replay_check(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 59391dc80fa3..e8703aa8d06a 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -118,8 +118,8 @@ static int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static int xfrm_replay_check(struct xfrm_state *x,
-		      struct sk_buff *skb, __be32 net_seq)
+static int xfrm_replay_check_legacy(struct xfrm_state *x,
+				    struct sk_buff *skb, __be32 net_seq)
 {
 	u32 diff;
 	u32 seq = ntohl(net_seq);
@@ -507,6 +507,21 @@ static int xfrm_replay_check_esn(struct xfrm_state *x,
 	return -EINVAL;
 }
 
+int xfrm_replay_check(struct xfrm_state *x,
+		      struct sk_buff *skb, __be32 net_seq)
+{
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		return xfrm_replay_check_bmp(x, skb, net_seq);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_check_esn(x, skb, net_seq);
+	}
+
+	return xfrm_replay_check_legacy(x, skb, net_seq);
+}
+
 static int xfrm_replay_recheck_esn(struct xfrm_state *x,
 				   struct sk_buff *skb, __be32 net_seq)
 {
@@ -532,7 +547,7 @@ int xfrm_replay_recheck(struct xfrm_state *x,
 		return xfrm_replay_recheck_esn(x, skb, net_seq);
 	}
 
-	return xfrm_replay_check(x, skb, net_seq);
+	return xfrm_replay_check_legacy(x, skb, net_seq);
 }
 
 static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
@@ -723,32 +738,26 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 }
 
 static const struct xfrm_replay xfrm_replay_legacy = {
-	.check		= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow_offload,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
-	.check		= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_offload_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
-	.check		= xfrm_replay_check_esn,
 	.overflow	= xfrm_replay_overflow_offload_esn,
 };
 #else
 static const struct xfrm_replay xfrm_replay_legacy = {
-	.check		= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
-	.check		= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
-	.check		= xfrm_replay_check_esn,
 	.overflow	= xfrm_replay_overflow_esn,
 };
 #endif
-- 
2.31.1

