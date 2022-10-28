Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74316112C6
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiJ1NbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiJ1Naw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:30:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F31E099B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368e6c449f2so44047977b3.5
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 06:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mAhikDCYsTVoykDfFXufN3qfUUCZU6VugouuIlfHJYM=;
        b=reTALZZtmpImpkSoaPsgD1wZmofRxe7ov7ejP58f5tD82GU6aQQV4STXPFUZBsC5TE
         ncwU7bSL2hOHQGEfm8lpCtCTvQyd25uIO+WN7Hm92Z9dSRHVbEo992mEUhHf4lOQPjBy
         el7JpNNpw8hPBAQj10dVzRN2/dB2Exrjr12S5baYcwPp9Dy0w9qu7g6v+6zakhKN63ue
         BYRr77iJBDvQbIG6U/UQtvpnkXjSlHAAjgBoEFYYpmV+2Ori9VV6Ivsj6hnpFQnyW/kT
         pQ4zHCvuQucB7X0Vj7/HDGHsBhniLlEbEw5HzUh+0QklEbkb3RiQPjLHlIx7y8ZvE4xI
         HgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAhikDCYsTVoykDfFXufN3qfUUCZU6VugouuIlfHJYM=;
        b=I9h/kIEtBokPR1AH3A0gHCa/6WsVIgINCczugqkNb9cyogKCt2azmrLIvnv/5aJms1
         MhlZfC8bgVrDGJsyC+3np8r0GAVaqatspcWB03vvs7XiQ9h5JM9/mMmbdxu7n48gcujo
         S27pzJ9D3dOdDDTtbet+rdATIpqhSRmNw6O7KFb9sEESQ5T4oqainLYHedxW3WssgE4X
         aHkPqm5qjGl730lAYBgdi04Qli40Mur6YnuTXrvQHAXgSf7iHYEYvXpRkYT4O4o4azq7
         q9A2wzag/l94J3aZeTZrbuAkKDF2jdPTzx1o9OBBOshPXHdeiEG4M5e9f8eUEsUQr9Jp
         Qi1w==
X-Gm-Message-State: ACrzQf3fNa1kl4NNI+4tWDFNgqZwUoHWbe5X72rV06XE1HRNUV/N9CFB
        R6pzTSxvofnTRF11X4cnj71TP+cpNuy+IA==
X-Google-Smtp-Source: AMsMyM6gmsYqn6MFSKfmtL+zAYsveJLsAOCIaiITrlN4k1b2ZFt3u6kD9owZab8CpHaJFViYLZZhVutwRx5xSA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9b47:0:b0:6bd:1f01:774f with SMTP id
 u7-20020a259b47000000b006bd1f01774fmr1ybo.602.1666963849536; Fri, 28 Oct 2022
 06:30:49 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:30:39 +0000
In-Reply-To: <20221028133043.2312984-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221028133043.2312984-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221028133043.2312984-2-edumazet@google.com>
Subject: [PATCH net-next 1/5] net: dropreason: add SKB_CONSUMED reason
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

This will allow to simply use in the future:

	kfree_skb_reason(skb, reason);

Instead of repeating sequences like:

	if (dropped)
	    kfree_skb_reason(skb, reason);
	else
	    consume_skb(skb);

For instance, following patch in the series is adding
@reason to skb_release_data() and skb_release_all(),
so that we can propagate a meaningful @reason whenever
consume_skb()/kfree_skb() have to take care of a potential frag_list.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 2 ++
 net/core/skbuff.c        | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c1cbcdbaf1492c6bd5a18b9af0a0e0beb071c674..0bd18c14dae0a570a150c31eeea99fe85bc734b0 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -80,6 +80,8 @@ enum skb_drop_reason {
 	 * @SKB_NOT_DROPPED_YET: skb is not dropped yet (used for no-drop case)
 	 */
 	SKB_NOT_DROPPED_YET = 0,
+	/** @SKB_CONSUMED: packet has been consumed */
+	SKB_CONSUMED,
 	/** @SKB_DROP_REASON_NOT_SPECIFIED: drop reason is not specified */
 	SKB_DROP_REASON_NOT_SPECIFIED,
 	/** @SKB_DROP_REASON_NO_SOCKET: socket not found */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d84a17eada502cf0f650d261cc7de5f020afb63..7ce797cd121f395062b61b33371fb638f51e8c99 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
 #undef FN
 #define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
 const char * const drop_reasons[] = {
+	[SKB_CONSUMED] = "CONSUMED",
 	DEFINE_DROP_REASON(FN, FN)
 };
 EXPORT_SYMBOL(drop_reasons);
@@ -894,7 +895,10 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 
 	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
 
-	trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	if (reason == SKB_CONSUMED)
+		trace_consume_skb(skb);
+	else
+		trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
-- 
2.38.1.273.g43a17bfeac-goog

