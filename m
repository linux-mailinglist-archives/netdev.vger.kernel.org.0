Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CAD612449
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiJ2Ppd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJ2Ppa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:45:30 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A64C631F5
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:29 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id bq21-20020a05622a1c1500b0039cdae506e6so5087889qtb.10
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xf1IqAkHnBlgERzJ+GODqp6iHzNJM3F35pgHGdmZlvk=;
        b=khZE/voogYTeuW5/F1Y2cyifckcJVjPd9EfFw1cghSvY1ZffOhfgXVmejAEDIF6zmY
         RbN7OsK9EHAQo3jP2BG4eHKWTUB7KkWXToF43ddSN6M42F7Kroe4kJd5Mnjycq8Vi6HI
         /hqbRRGq6LLtT66zDqIcB9yOooQp0SjnXmKCCaHfUfKlnARptcLFvqus8KXTEsqsMOFH
         Kf9AJ9dpasFm0TRwigxn5/eJArYSHdXX7Zxnb0Py0AmLFOKWyPqrDtRVlBmklN9yfwim
         s+F588HhsEUhiRopIeWwKJbk23iclXeYHAX1YruPpYorcdCIK+FNGRpSEUEanuPeCvof
         66vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xf1IqAkHnBlgERzJ+GODqp6iHzNJM3F35pgHGdmZlvk=;
        b=fg25crMmvHaQEVR6lcLsah2/1rhNBcDO15aqf44oc+o3yucTBwVmXWhbHDXrFnj4CH
         h7aU3XSyBlLsR8x2dC+QZBwYYpLLfo3zS0WgOkcorRfjgYUr8AW7WDPUcr00vWg66W/y
         iODz6rpmZGWkpFS4h649We9zfFUhzDmwxiSzUSwITTC+QRi5O2tO3NPagWzO8B4lhSIi
         b1LNES3CHzUIIA4tMEbRQecap/XmNTSDOIttmgw3WTOPh8qyDK0co5/HdO+QBAvbA5Tc
         uhk4/gf7CegLYKKkoFfNhgVFUh7aAbwEFJTo6f+rokbA4kBcoUiruqrxYYOeagcfTZft
         zwVA==
X-Gm-Message-State: ACrzQf1RsLMe3BjMB5DTt0OWsIBQChsoPGdkRjQLvgUVgT//0Jn8CLYk
        geijW2dS/m3LiQmnO+ikU5x9dt6WWF3sZQ==
X-Google-Smtp-Source: AMsMyM6HMLESl1ywgbWs7UXG4J3o6QTz0A89W4gfWAH6P40z0Gftkv2kIRY3vJmR3s6ikJ4lOwNWZ0gupg1hGQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0c:f193:0:b0:4bb:92f5:bc20 with SMTP id
 m19-20020a0cf193000000b004bb92f5bc20mr4287057qvl.52.1667058328643; Sat, 29
 Oct 2022 08:45:28 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:45:17 +0000
In-Reply-To: <20221029154520.2747444-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221029154520.2747444-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029154520.2747444-3-edumazet@google.com>
Subject: [PATCH v2 net-next 2/5] net: dropreason: propagate drop_reason to skb_release_data()
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

