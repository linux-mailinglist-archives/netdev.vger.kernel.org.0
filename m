Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF74D3B58D0
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhF1F5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:34 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40994 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbhF1F5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:57:25 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id B8894800058;
        Mon, 28 Jun 2021 07:54:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:54:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:54:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id ADBAC31805DC; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 15/17] xfrm: replay: remove recheck indirection
Date:   Mon, 28 Jun 2021 07:45:20 +0200
Message-ID: <20210628054522.1718786-16-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Adds new xfrm_replay_recheck() helper and calls it from
xfrm input path instead of the indirection.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  4 +---
 net/xfrm/xfrm_input.c  |  2 +-
 net/xfrm/xfrm_replay.c | 22 ++++++++++++++++------
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a7f997b13198..3a219b34cb8c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -309,9 +309,6 @@ struct xfrm_replay {
 	int	(*check)(struct xfrm_state *x,
 			 struct sk_buff *skb,
 			 __be32 net_seq);
-	int	(*recheck)(struct xfrm_state *x,
-			   struct sk_buff *skb,
-			   __be32 net_seq);
 	int	(*overflow)(struct xfrm_state *x, struct sk_buff *skb);
 };
 
@@ -1723,6 +1720,7 @@ static inline int xfrm_policy_id2dir(u32 index)
 #ifdef CONFIG_XFRM
 void xfrm_replay_advance(struct xfrm_state *x, __be32 net_seq);
 void xfrm_replay_notify(struct xfrm_state *x, int event);
+int xfrm_replay_recheck(struct xfrm_state *x, struct sk_buff *skb, __be32 net_seq);
 
 static inline int xfrm_aevent_is_on(struct net *net)
 {
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index c8971e4b33ab..8046ef1a6680 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -660,7 +660,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
-		if (x->repl->recheck(x, skb, seq)) {
+		if (xfrm_replay_recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9565b0f7d380..59391dc80fa3 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -519,6 +519,22 @@ static int xfrm_replay_recheck_esn(struct xfrm_state *x,
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
@@ -708,37 +724,31 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 
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
2.25.1

