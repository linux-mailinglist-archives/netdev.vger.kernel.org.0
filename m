Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071C73B58CA
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhF1F51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:27 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:35574 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhF1F5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:57:23 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id B6D2680004A;
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
        id B2DA031805FE; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 16/17] xfrm: replay: avoid replay indirection
Date:   Mon, 28 Jun 2021 07:45:21 +0200
Message-ID: <20210628054522.1718786-17-steffen.klassert@secunet.com>
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

Add and use xfrm_replay_check helper instead of indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.25.1

