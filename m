Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3E6112C7
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJ1NbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiJ1Nay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:30:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42EC106E16
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-368e6c449f2so44048477b3.5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xf1IqAkHnBlgERzJ+GODqp6iHzNJM3F35pgHGdmZlvk=;
        b=qRiQu9W8EnDhl8bvngjDr1Gu6Lodccpbx+k94I9pHjNqgzTRiCmWDzoS5ksofOLL2a
         nkbq+HXMlbLQPdYu8Xbg4ebpEkzfL0zqW0CR6oD8rqZkFGppoCp7e8b9ejWPS2zs7zZt
         FxGEhj2KL97UfLqgUdmyQQhObF6UbYpvSxX3nmNnxWTHqakcCJ4K5iWj4KWqSlI8XWMM
         Qr9+TVShkj0LgPZhMGnhJchhBRZ3iGQvPWyn/BdVgUcRqtMhHEoM6wiOVj1fxv+OJnKP
         TNBPg8xTdICj+B/XI+cMr/R38eODxM+XcIY0n22BEf88gviTCvQnxOPQfn1X8IuhSIc1
         3rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf1IqAkHnBlgERzJ+GODqp6iHzNJM3F35pgHGdmZlvk=;
        b=edYoxbtzYQu7c7XqngK6RsTSEoUwkkoLf4iDKL9vUwCnSrw3QTXNRv+El5TDHgwVR5
         zFJd9FF+OJEBZYS3MqN6q07gGsTjmzdSPBUxlptCkLNzQkH2MnhM70elmukfR7v8N/Wg
         smgVUyq0RXEgyin+p3pcugb3H1ygT03c+ichWtX7v++PZUs3hjNVUS0JxlpDCgLL5+tE
         6aii49d1Yw9TuSgm4CSx1Ej9dKUXLVkHXxPphLsOvyTb/fUH+U2nyxg8PewHH20FX/aD
         IQDPj8AByp7wZHEWyJSRxbYzBIIesNEDLCzEsEZ3MRe2HXpkN02OSzSYO09I3QBYYkYu
         U1bw==
X-Gm-Message-State: ACrzQf2GA7elUqhpnyjqiGl38O4nUYU1+LRicOvIT4tDM8kbVicfFHS8
        pj25v4zCn7UbeE5GlvQheKv5z0dlTVy9fQ==
X-Google-Smtp-Source: AMsMyM7c/BI5fIYpdi5z9pes6uUeNH+HQkdV8rWOlaKlUOlmPKtmdW0MVscsTB2EQvKwWGmquzXjk16H7yoMYg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:6187:0:b0:357:2da6:50c2 with SMTP id
 v129-20020a816187000000b003572da650c2mr1ywb.242.1666963851536; Fri, 28 Oct
 2022 06:30:51 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:30:40 +0000
In-Reply-To: <20221028133043.2312984-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221028133043.2312984-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028133043.2312984-3-edumazet@google.com>
Subject: [PATCH net-next 2/5] net: dropreason: propagate drop_reason to skb_release_data()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an skb with a frag list is consumed, we currently
pretend all skbs in the frag list were dropped.

In order to fix this, add a @reason argument to skb_release_data()
and skb_release_all().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7ce797cd121f395062b61b33371fb638f51e8c99..42a35b59fb1e54e2e4c0ab58a6da016cef622653 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -769,7 +769,7 @@ static void skb_free_head(struct sk_buff *skb)
 	}
 }
 
-static void skb_release_data(struct sk_buff *skb)
+static void skb_release_data(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	int i;
@@ -792,7 +792,7 @@ static void skb_release_data(struct sk_buff *skb)
 
 free_head:
 	if (shinfo->frag_list)
-		kfree_skb_list(shinfo->frag_list);
+		kfree_skb_list_reason(shinfo->frag_list, reason);
 
 	skb_free_head(skb);
 exit:
@@ -855,11 +855,11 @@ void skb_release_head_state(struct sk_buff *skb)
 }
 
 /* Free everything but the sk_buff shell. */
-static void skb_release_all(struct sk_buff *skb)
+static void skb_release_all(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	skb_release_head_state(skb);
 	if (likely(skb->head))
-		skb_release_data(skb);
+		skb_release_data(skb, reason);
 }
 
 /**
@@ -873,7 +873,7 @@ static void skb_release_all(struct sk_buff *skb)
 
 void __kfree_skb(struct sk_buff *skb)
 {
-	skb_release_all(skb);
+	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
 	kfree_skbmem(skb);
 }
 EXPORT_SYMBOL(__kfree_skb);
@@ -1056,7 +1056,7 @@ EXPORT_SYMBOL(consume_skb);
 void __consume_stateless_skb(struct sk_buff *skb)
 {
 	trace_consume_skb(skb);
-	skb_release_data(skb);
+	skb_release_data(skb, SKB_CONSUMED);
 	kfree_skbmem(skb);
 }
 
@@ -1081,7 +1081,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 
 void __kfree_skb_defer(struct sk_buff *skb)
 {
-	skb_release_all(skb);
+	skb_release_all(skb, SKB_DROP_REASON_NOT_SPECIFIED);
 	napi_skb_cache_put(skb);
 }
 
@@ -1119,7 +1119,7 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
-	skb_release_all(skb);
+	skb_release_all(skb, SKB_CONSUMED);
 	napi_skb_cache_put(skb);
 }
 EXPORT_SYMBOL(napi_consume_skb);
@@ -1250,7 +1250,7 @@ EXPORT_SYMBOL_GPL(alloc_skb_for_msg);
  */
 struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src)
 {
-	skb_release_all(dst);
+	skb_release_all(dst, SKB_CONSUMED);
 	return __skb_clone(dst, src);
 }
 EXPORT_SYMBOL_GPL(skb_morph);
@@ -1873,7 +1873,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
 
-		skb_release_data(skb);
+		skb_release_data(skb, SKB_CONSUMED);
 	} else {
 		skb_free_head(skb);
 	}
@@ -6213,7 +6213,7 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
-		skb_release_data(skb);
+		skb_release_data(skb, SKB_CONSUMED);
 	} else {
 		/* we can reuse existing recount- all we did was
 		 * relocate values
@@ -6356,7 +6356,7 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		kfree(data);
 		return -ENOMEM;
 	}
-	skb_release_data(skb);
+	skb_release_data(skb, SKB_CONSUMED);
 
 	skb->head = data;
 	skb->head_frag = 0;
-- 
2.38.1.273.g43a17bfeac-goog

