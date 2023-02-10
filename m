Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A846925B7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbjBJSre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjBJSrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:47:25 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CE47D898
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:14 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id t5-20020a05622a180500b003b9c03cd525so3633320qtc.20
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676054834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zP517xtgWaoJxdYeRLEvdEli+c30xjEA1+SvKM2r2ec=;
        b=U6/vREUkx11O6XM6dMayAnWtz+lBQdCX6ZdEJ5LAAigTt1Z4bnh1b6wty0VGi2VTlj
         LQS/2U/8yPFF1ngVTSdWaFqO8AuGki8JSq3hRtRGz0uEAsMmW4QsBflrtkh+/l/HZQRK
         rRBXR39DFvyop3j/NfJZiFAxvKf1sEge8OCHzPRn086AgWV4m9VFkIxwBuOVik6vIIas
         wDyCvA3bP/hnOEDfDMzRn5v6ws2fFm/LMtk8GXEP3JLkVWAPZpif5WjXmrlhEHkAu4OJ
         gH2qsPl9M/hzVQsUlDgm3JMoy1eAcNVkmv9a44Z8fc3NAqxK5HmJcKv7hKbZdxW+GwLB
         Lbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676054834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zP517xtgWaoJxdYeRLEvdEli+c30xjEA1+SvKM2r2ec=;
        b=7wFo8IgUzbtZlteoNKImrIM0JIddUxMX+jLHmq64+7mBZE/XQW2n00wFHxyNdtPY2c
         rwHxbdydONGn6Z9HBxiWZ+u+3/ynGtt4nuvteOmbLZrfHOcV5U2+3xc5hiZGvuoftQ+8
         ChcWCQqQiiHR9fm6qUrrjf84UtJ4L6jFIDxRJGmPxEHu4iILONbMd70TiuZp03qEEuod
         lxxSUUFhyk1y/AaIT+O+YQAgKt0c5KV2ANZQHe12NptS0KpKqueqHu2QAIS1OtkoHC7r
         KDvL0oajs01vzGptA8N4Erfakg3hGJ2vNSDizeDp+PkA28/4Fu/V0YbP96ivrHblaK2A
         sDGA==
X-Gm-Message-State: AO0yUKVWwaf6DN4OTGKw1QI7FS3H0C1hrmFayYLUhjpjHF/CGY2W/9/o
        SrsWYAvtMbrtPzMKjiugflGtWFAd0+65eg==
X-Google-Smtp-Source: AK7set8/nzSwq1rgwsVeE7t66rZsKC+27vu2rAQFDY5dYxy/O7AFfuS5nHNz0aQoyf5eYDlAMrgStCQu7aiyOA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0c:e209:0:b0:56c:2040:98e7 with SMTP id
 q9-20020a0ce209000000b0056c204098e7mr802631qvl.73.1676054833896; Fri, 10 Feb
 2023 10:47:13 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:47:06 +0000
In-Reply-To: <20230210184708.2172562-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230210184708.2172562-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210184708.2172562-3-edumazet@google.com>
Subject: [PATCH net-next 2/4] net: add pskb_may_pull_reason() helper
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

pskb_may_pull() can fail for two different reasons.

Provide pskb_may_pull_reason() helper to distinguish
between these reasons.

It returns:

SKB_NOT_DROPPED_YET           : Success
SKB_DROP_REASON_PKT_TOO_SMALL : packet too small
SKB_DROP_REASON_NOMEM         : skb->head could not be resized

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 47ab28a37f2f1f9fb25e575fffe2db1cfd884f65..d5602b15c714fa3bd67d56793857b2bb5c21542e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2631,13 +2631,24 @@ void *skb_pull_data(struct sk_buff *skb, size_t len);
 
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
-static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
+static inline enum skb_drop_reason
+pskb_may_pull_reason(struct sk_buff *skb, unsigned int len)
 {
 	if (likely(len <= skb_headlen(skb)))
-		return true;
+		return SKB_NOT_DROPPED_YET;
+
 	if (unlikely(len > skb->len))
-		return false;
-	return __pskb_pull_tail(skb, len - skb_headlen(skb)) != NULL;
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
+
+	if (unlikely(!__pskb_pull_tail(skb, len - skb_headlen(skb))))
+		return SKB_DROP_REASON_NOMEM;
+
+	return SKB_NOT_DROPPED_YET;
+}
+
+static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
+{
+	return pskb_may_pull_reason(skb, len) == SKB_NOT_DROPPED_YET;
 }
 
 static inline void *pskb_pull(struct sk_buff *skb, unsigned int len)
-- 
2.39.1.581.gbfd45094c4-goog

