Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E6D6E87C1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjDTCBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjDTCAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:00:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB383AA0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 444796446B
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B46CC433D2;
        Thu, 20 Apr 2023 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681956008;
        bh=Cb2ZOKUEmU35EceaK+yDIldtN2L34FVMbgWgQqY8jdM=;
        h=From:To:Cc:Subject:Date:From;
        b=D1Fry2kCDaqAeM8se+FPs0LtFwF3fQIg9Ob2mhfHXrGX6+pcZaw3MvI31iGSL3BMb
         RVI4/vLK6OyIH0o5TTbABBFAPnbe3WWAwbh3AuQVd5k0Wxu6ZKvCXDs8trdQ4EqObj
         p7YC4zYa3k4lHQrif9XKmTMqaZMIBdN5P9Jn7d+PioN9I8L74t8jrK8zHdWTiN4Cco
         k+9TLuZDEJikul23CQ4PhPhZRotQJLYxZY0xPUMsKJx0ecoffWuWZ2qDt658D1/Qf1
         f1CxmirjhLmBLYzSPawQead21mTQHQctS9LeHFRxQJWiL8O5CbeYwXhags1i8YvyOz
         yrrT8IpK21SeA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: skbuff: update and rename __kfree_skb_defer()
Date:   Wed, 19 Apr 2023 19:00:05 -0700
Message-Id: <20230420020005.815854-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__kfree_skb_defer() uses the old naming where "defer" meant
slab bulk free/alloc APIs. In the meantime we also made
__kfree_skb_defer() feed the per-NAPI skb cache, which
implies bulk APIs. So take away the 'defer' and add 'napi'.

While at it add a drop reason. This only matters on the
tx_action path, if the skb has a frag_list. But getting
rid of a SKB_DROP_REASON_NOT_SPECIFIED seems like a net
benefit so why not.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 2 +-
 net/core/dev.c         | 3 ++-
 net/core/gro.c         | 2 +-
 net/core/skbuff.c      | 4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5f120bbab9da..6a77652ddd7e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3252,7 +3252,7 @@ static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,
 void napi_consume_skb(struct sk_buff *skb, int budget);
 
 void napi_skb_free_stolen_head(struct sk_buff *skb);
-void __kfree_skb_defer(struct sk_buff *skb);
+void __napi_kfree_skb(struct sk_buff *skb, enum skb_drop_reason reason);
 
 /**
  * __dev_alloc_pages - allocate page for network Rx
diff --git a/net/core/dev.c b/net/core/dev.c
index 3fc4dba71f9d..1551aabac343 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5040,7 +5040,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
 			else
-				__kfree_skb_defer(skb);
+				__napi_kfree_skb(skb,
+						 get_kfree_skb_cb(skb)->reason);
 		}
 	}
 
diff --git a/net/core/gro.c b/net/core/gro.c
index a606705a0859..2d84165cb4f1 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -633,7 +633,7 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 			__kfree_skb(skb);
 		else
-			__kfree_skb_defer(skb);
+			__napi_kfree_skb(skb, SKB_CONSUMED);
 		break;
 
 	case GRO_HELD:
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 768f9d04911f..8764653bede7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1226,9 +1226,9 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 	}
 }
 
-void __kfree_skb_defer(struct sk_buff *skb)
+void __napi_kfree_skb(struct sk_buff *skb, enum skb_drop_reason reason)
 {
-	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, true);
+	skb_release_all(skb, reason, true);
 	napi_skb_cache_put(skb);
 }
 
-- 
2.39.2

