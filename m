Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5783D864D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhG1D4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhG1D4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 23:56:32 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2FAC061757;
        Tue, 27 Jul 2021 20:56:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627444588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9E0nnN668dDZh85+CdDKSKSGySlDjGKSlxvO1PKLsaQ=;
        b=IzKDepchuVgF9VSRh8upQ81qaRKl2+WlNPeX5KMu7GKiH2tnQr79203VKNbGJ7FysTKWNH
        JSG6iS1JwLpZ5Mxn09ebE5pnxEeLhl3GGa51mMLLztmBKwB8mbVuQ2SCgSNZKLHz+SYWbO
        RYGlvR7N+qFB1jo4aDj2p/3fySH+FtY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] Revert "net: Get rid of consume_skb when tracing is off"
Date:   Wed, 28 Jul 2021 11:56:05 +0800
Message-Id: <20210728035605.24510-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit be769db2f95861cc8c7c8fedcc71a8c39b803b10.
There is trace_kfree_skb() in kfree_skb(), the trace_kfree_skb() is
also a trace function.

Fixes: be769db2f958 (net: Get rid of consume_skb when tracing is off)
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/skbuff.h | 9 ---------
 net/core/skbuff.c      | 2 --
 2 files changed, 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f19190820e63..da897d455d58 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1072,16 +1072,7 @@ void kfree_skb(struct sk_buff *skb);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
-
-#ifdef CONFIG_TRACEPOINTS
 void consume_skb(struct sk_buff *skb);
-#else
-static inline void consume_skb(struct sk_buff *skb)
-{
-	return kfree_skb(skb);
-}
-#endif
-
 void __consume_stateless_skb(struct sk_buff *skb);
 void  __kfree_skb(struct sk_buff *skb);
 extern struct kmem_cache *skbuff_head_cache;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fc7942c0dddc..f4c6529ce6b9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -893,7 +893,6 @@ void skb_tx_error(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(skb_tx_error);
 
-#ifdef CONFIG_TRACEPOINTS
 /**
  *	consume_skb - free an skbuff
  *	@skb: buffer to free
@@ -911,7 +910,6 @@ void consume_skb(struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(consume_skb);
-#endif
 
 /**
  *	__consume_stateless_skb - free an skbuff, assuming it is stateless
-- 
2.32.0

