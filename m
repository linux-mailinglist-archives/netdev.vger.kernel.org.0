Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0CD6EA768
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDUJo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjDUJoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF58B763
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f9af249edso22507677b3.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070244; x=1684662244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7nTSWXSW2Slt1xpqhXD/WEmkRugHqIKnxJwK2HkWrCE=;
        b=xDWezCu8sr3A7WKbf8N3jchLYA13SXNgBKNoeS3D/SBxHY37XHx5lFO4BERChaJGUn
         QVjJmW2vSjsl/Z0h3H/rIjV/BdBRcaBEDEfDpF+EOo1Qi0SljKNPdhj5xAaMFCuYWMsA
         vhyNJwuEoY+JcaF6FhlhDzODXcllNwT3jcTDwSyX7IhMXS3qrbAmj3rnVlmXXcUSheAE
         yFxQZ9NOxs/jz7ePoKEK3EY2BgNzMUQmEUBYdtJCy+ZT6D+7i8ClyIQZNd3LLf5qNk4k
         uPr+s/eODYexSdTRsVRrTrnBOflBBjqvhuo8ZXB8V14HNyoJy3SyQ9oXZhtHXgeqY8He
         rTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070244; x=1684662244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nTSWXSW2Slt1xpqhXD/WEmkRugHqIKnxJwK2HkWrCE=;
        b=IvMH/6WraPdrQCsd+3Z/ZL9dKdatWzFuIqLaFVW7rojtlREG7LUAkCHJ666NHHhdTl
         JULaa3Kncrune0RI66EUcLWa0ekh1gb9X5yBAFvsnMYbzxSvhEG37A9MUgq8bfOjHy+L
         WaR2p7TyvuUY9rHyZo6POR3glcgyunQJH6F/D9YUB8Evg1mi2//rYfzriYbDzzVKKX/u
         QvwVzsbac2poKu+CVYTGi/uAFoKi+Y3UQNtrg/DMACiKl+Ng4DgnlY3csC4YnJEN6Ukf
         kLlSDWMLqfeUETP/Gb04/ggtwBuR0HyAUXqV4y4p9rgi6VmcKoy4ZtSOFlQF3bS6E6ww
         zqDA==
X-Gm-Message-State: AAQBX9c0Peo45FsPCpstah/jghVzT7W+ZFV3TTOv93b+nma11m5Zrfes
        a9qQKrCFXP9ajFuFFWIhP058rqupPv3FDA==
X-Google-Smtp-Source: AKy350YWQ6h09p+/8vAY3xqLiIQgQ/sLsWIb1M1Tln6ZjPmMcD/cV1z99FEk56DuGtfpPc+ra7r1D3rmgufYSQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:706:b0:54f:b27f:286a with SMTP
 id bs6-20020a05690c070600b0054fb27f286amr1002675ywb.5.1682070244312; Fri, 21
 Apr 2023 02:44:04 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:54 +0000
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-3-edumazet@google.com>
Subject: [PATCH net-next 2/5] net: do not provide hard irq safety for sd->defer_lock
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kfree_skb() can be called from hard irq handlers,
but skb_attempt_defer_free() is meant to be used
from process or BH contexts, and skb_defer_free_flush()
is meant to be called from BH contexts.

Not having to mask hard irq can save some cycles.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c    | 4 ++--
 net/core/skbuff.c | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1551aabac3437938566813363d748ac639fb0075..d15568f5a44f1a397941bd5fca3873ee4d7d0e48 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6632,11 +6632,11 @@ static void skb_defer_free_flush(struct softnet_data *sd)
 	if (!READ_ONCE(sd->defer_list))
 		return;
 
-	spin_lock_irq(&sd->defer_lock);
+	spin_lock(&sd->defer_lock);
 	skb = sd->defer_list;
 	sd->defer_list = NULL;
 	sd->defer_count = 0;
-	spin_unlock_irq(&sd->defer_lock);
+	spin_unlock(&sd->defer_lock);
 
 	while (skb != NULL) {
 		next = skb->next;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bd815a00d2affae9be4ea6cdba188423e1122164..304a966164d82600cf196e512f24e3deee0c9bc5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6870,7 +6870,6 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 {
 	int cpu = skb->alloc_cpu;
 	struct softnet_data *sd;
-	unsigned long flags;
 	unsigned int defer_max;
 	bool kick;
 
@@ -6889,7 +6888,7 @@ nodefer:	__kfree_skb(skb);
 	if (READ_ONCE(sd->defer_count) >= defer_max)
 		goto nodefer;
 
-	spin_lock_irqsave(&sd->defer_lock, flags);
+	spin_lock_bh(&sd->defer_lock);
 	/* Send an IPI every time queue reaches half capacity. */
 	kick = sd->defer_count == (defer_max >> 1);
 	/* Paired with the READ_ONCE() few lines above */
@@ -6898,7 +6897,7 @@ nodefer:	__kfree_skb(skb);
 	skb->next = sd->defer_list;
 	/* Paired with READ_ONCE() in skb_defer_free_flush() */
 	WRITE_ONCE(sd->defer_list, skb);
-	spin_unlock_irqrestore(&sd->defer_lock, flags);
+	spin_unlock_bh(&sd->defer_lock);
 
 	/* Make sure to trigger NET_RX_SOFTIRQ on the remote CPU
 	 * if we are unlucky enough (this seems very unlikely).
-- 
2.40.0.634.g4ca3ef3211-goog

