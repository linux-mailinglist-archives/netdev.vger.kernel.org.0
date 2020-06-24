Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5680206EAC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390330AbgFXII3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387732AbgFXII1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:08:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C39C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 01:08:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jo0SI-00068x-0n; Wed, 24 Jun 2020 10:08:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 4/6] xfrm: replay: remove recheck indirection
Date:   Wed, 24 Jun 2020 10:08:02 +0200
Message-Id: <20200624080804.7480-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624080804.7480-1-fw@strlen.de>
References: <20200624080804.7480-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds new xfrm_replay_recheck() helper and calls it from
xfrm input path instead of the indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  4 +---
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 22 ++++++++++++++++------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 78bbfd370e34..7c0b69e00128 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -307,9 +307,6 @@ struct xfrm_replay {
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
-	int	(*recheck)(struct xfrm_state *x,
-			   struct sk_buff *skb,
-			   __be32 net_seq);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
@@ -1720,6 +1717,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 #ifdef CONFIG_XFRM
 void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
+int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
 static inline int xfrm_aevent_is_on(struct net *net)
 {
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b4b559b35cf1..005d8e9c5df4 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -658,7 +658,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
-		if (async && x->repl->recheck(x, skb, seq)) {
+		if (async && xfrm_replay_recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 460f438bd138..60608b51b2d9 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -503,6 +503,22 @@ static int xfrm_replay_recheck_esn(struct xfrm_state *x,
 	return xfrm_replay_check_esn(x, skb, net_seq);
 }
 
+int xfrm_replay_recheck(struct xfrm_state *x,
+			struct sk_buff *skb, __be32 net_seq)
+{
+	switch (x->repl_mode) {
+	case XFRM_REPLAY_MODE_LEGACY:
+		break;
+	case XFRM_REPLAY_MODE_BMP:
+		/* no special recheck treatment */
+		return xfrm_replay_check_bmp(x, skb, net_seq);
+	case XFRM_REPLAY_MODE_ESN:
+		return xfrm_replay_recheck_esn(x, skb, net_seq);
+	}
+
+	return xfrm_replay_check(x, skb, net_seq);
+}
+
 static void xfrm_replay_advance_esn(struct xfrm_state *x, __be32 net_seq)
 {
 	unsigned int bitnr, nr, i;
@@ -690,37 +706,31 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 
 static const struct xfrm_replay xfrm_replay_legacy = {
 	.check		= xfrm_replay_check,
-	.recheck	= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow_offload,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
 	.check		= xfrm_replay_check_bmp,
-	.recheck	= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_offload_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
 	.check		= xfrm_replay_check_esn,
-	.recheck	= xfrm_replay_recheck_esn,
 	.overflow	= xfrm_replay_overflow_offload_esn,
 };
 #else
 static const struct xfrm_replay xfrm_replay_legacy = {
 	.check		= xfrm_replay_check,
-	.recheck	= xfrm_replay_check,
 	.overflow	= xfrm_replay_overflow,
 };
 
 static const struct xfrm_replay xfrm_replay_bmp = {
 	.check		= xfrm_replay_check_bmp,
-	.recheck	= xfrm_replay_check_bmp,
 	.overflow	= xfrm_replay_overflow_bmp,
 };
 
 static const struct xfrm_replay xfrm_replay_esn = {
 	.check		= xfrm_replay_check_esn,
-	.recheck	= xfrm_replay_recheck_esn,
 	.overflow	= xfrm_replay_overflow_esn,
 };
 #endif
-- 
2.26.2

