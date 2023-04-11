Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E76DE590
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDKUSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDKUSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EA210F0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A7C6627B9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AF9C433D2;
        Tue, 11 Apr 2023 20:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681244299;
        bh=QOc8Os8E1JEhiYCFcInBmNKWMBpYvdkJIoGymc9Jgvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qodTFmzT5XrugEwz7kBa+g4XwrdnVrw6lmrbrK+CTp7O1Rr0QtXxVHxzvebn+/YxH
         R8udONgEYMcKTZdrriR7m/ZLlyzk/oahyMN2FF+SMUsk1J6YMlCtagvtqvj7aTIjpK
         Km1HcnAkYNK/HT0vvZhb0CrGAzKsxr6J4R/hi2YX/1x1Sl6Gz6CIHNCgEZrR/I9I56
         Ld2a281WQmDxW1xTuUN8DYkuHfsRJ9HHqamXAovrag3IRSvbtB33WlmrWQLkJNIJsa
         Y7AFxn+Qi2UbA8mYf4bQN7RLVa2Uoxt1wdn+J6Q63dRFq4DyZo4pX9immvWrz3JuWl
         MIjC9DDeeHjUA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] net: skb: plumb napi state thru skb freeing paths
Date:   Tue, 11 Apr 2023 13:17:58 -0700
Message-Id: <20230411201800.596103-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411201800.596103-1-kuba@kernel.org>
References: <20230411201800.596103-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We maintain a NAPI-local cache of skbs which is fed by napi_consume_skb().
Going forward we will also try to cache head and data pages.
Plumb the "are we in a normal NAPI context" information thru
deeper into the freeing path, up to skb_release_data() and
skb_free_head()/skb_pp_recycle().

Use "bool in_normal_napi" rather than bare "int budget",
the further we get from NAPI the more confusing the budget
argument may seem (particularly whether 0 or MAX is the
correct value to pass in when not in NAPI).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v1:
 - feed the cache in __kfree_skb_defer(), it's in NAPI
 - s/in_normal_napi/napi_safe/
---
 net/core/skbuff.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..b2092166f7e2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -839,7 +839,7 @@ static void skb_clone_fraglist(struct sk_buff *skb)
 		skb_get(list);
 }
 
-static bool skb_pp_recycle(struct sk_buff *skb, void *data)
+static bool skb_pp_recycle(struct sk_buff *skb, void *data, bool napi_safe)
 {
 	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
 		return false;
@@ -856,12 +856,12 @@ static void skb_kfree_head(void *head, unsigned int end_offset)
 		kfree(head);
 }
 
-static void skb_free_head(struct sk_buff *skb)
+static void skb_free_head(struct sk_buff *skb, bool napi_safe)
 {
 	unsigned char *head = skb->head;
 
 	if (skb->head_frag) {
-		if (skb_pp_recycle(skb, head))
+		if (skb_pp_recycle(skb, head, napi_safe))
 			return;
 		skb_free_frag(head);
 	} else {
@@ -869,7 +869,8 @@ static void skb_free_head(struct sk_buff *skb)
 	}
 }
 
-static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
+static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason,
+			     bool napi_safe)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	int i;
@@ -894,7 +895,7 @@ static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 	if (shinfo->frag_list)
 		kfree_skb_list_reason(shinfo->frag_list, reason);
 
-	skb_free_head(skb);
+	skb_free_head(skb, napi_safe);
 exit:
 	/* When we clone an SKB we copy the reycling bit. The pp_recycle
 	 * bit is only set on the head though, so in order to avoid races
@@ -955,11 +956,12 @@ void skb_release_head_state(struct sk_buff *skb)
 }
 
 /* Free everything but the sk_buff shell. */
-static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
+static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason,
+			    bool napi_safe)
 {
 	skb_release_head_state(skb);
 	if (likely(skb->head))
-		skb_release_data(skb, reason);
+		skb_release_data(skb, reason, napi_safe);
 }
 
 /**
@@ -973,7 +975,7 @@ static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
 
 void __kfree_skb(struct sk_buff *skb)
 {
-	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, false);
 	kfree_skbmem(skb);
 }
 EXPORT_SYMBOL(__kfree_skb);
@@ -1027,7 +1029,7 @@ static void kfree_skb_add_bulk(struct sk_buff *skb,
 		return;
 	}
 
-	skb_release_all(skb, reason);
+	skb_release_all(skb, reason, false);
 	sa->skb_array[sa->skb_count++] = skb;
 
 	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
@@ -1201,7 +1203,7 @@ EXPORT_SYMBOL(consume_skb);
 void __consume_stateless_skb(struct sk_buff *skb)
 {
 	trace_consume_skb(skb, __builtin_return_address(0));
-	skb_release_data(skb, SKB_CONSUMED);
+	skb_release_data(skb, SKB_CONSUMED, false);
 	kfree_skbmem(skb);
 }
 
@@ -1226,7 +1228,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 
 void __kfree_skb_defer(struct sk_buff *skb)
 {
-	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED, true);
 	napi_skb_cache_put(skb);
 }
 
@@ -1264,7 +1266,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
-	skb_release_all(skb, SKB_CONSUMED);
+	skb_release_all(skb, SKB_CONSUMED, !!budget);
 	napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
@@ -1395,7 +1397,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
  */
 struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
 {
-	skb_release_all(dst, SKB_CONSUMED);
+	skb_release_all(dst, SKB_CONSUMED, false);
 	return __skb_clone(dst, src);
 }
 EXPORT_SYMBOL_GPL(skb_morph);
@@ -2018,9 +2020,9 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
 
-		skb_release_data(skb, SKB_CONSUMED);
+		skb_release_data(skb, SKB_CONSUMED, false);
 	} else {
-		skb_free_head(skb);
+		skb_free_head(skb, false);
 	}
 	off = (data + nhead) - skb->head;
 
@@ -6389,12 +6391,12 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
-		skb_release_data(skb, SKB_CONSUMED);
+		skb_release_data(skb, SKB_CONSUMED, false);
 	} else {
 		/* we can reuse existing recount- all we did was
 		 * relocate values
 		 */
-		skb_free_head(skb);
+		skb_free_head(skb, false);
 	}
 
 	skb->head = data;
@@ -6529,7 +6531,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		skb_kfree_head(data, size);
 		return -ENOMEM;
 	}
-	skb_release_data(skb, SKB_CONSUMED);
+	skb_release_data(skb, SKB_CONSUMED, false);
 
 	skb->head = data;
 	skb->head_frag = 0;
-- 
2.39.2

