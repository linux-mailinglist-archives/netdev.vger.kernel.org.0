Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7318D6EA769
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjDUJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjDUJoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0664B77F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f8a3f1961so6617167b3.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070246; x=1684662246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTFxuo2UmHuay79kd6xwvkE2D+pcGvHJZ3guw7iCQig=;
        b=mthQnW+H2PPQQ8y8OZF+FbtQWQx70ZhaKFdtnbrK5s7ZRHUooUv2DUWr4EPc+pSIV9
         fqsR1dGAf77QdtvszmaavlxklUR/xYRtmCVIu+1L17XS7WafPxYlpCv89CrnH4COklMC
         2+L+zbO7TT4nHC4zzyl+Z/AZ5g1U5lL/EFXGAAd4g5K1zl8hI1tfOC/yHXCYXcYmmTW2
         WAZGODYiWrdI0MavGId0H2qcs4t3oCQDBVEyBlKqyNtonXMTMB1QHR2ByvOBjLzOSIwY
         BXVjVmgAZnVo6pCmM4H6spvICfqrKGqk7xY+2ldpntEQK9kO32+xr7dF8Cpjyan0F139
         Riwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070246; x=1684662246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTFxuo2UmHuay79kd6xwvkE2D+pcGvHJZ3guw7iCQig=;
        b=KaKKT7YWM3T9ZfEwfxMvUG/IK2AOROGBSdYu8c+lqNMAnwUiUcFKxWgpcWz/DEkW3z
         3W29jwgb+K9kcM7fWwx3JbIuFLxPWzrPfYY4WNXCPUDLArT7wFQiu0X8Hrbp/FyvxnHu
         xULPHQRiWjVEXushOk0b9LLmKf6W/aMwNcMSC2DqIap8N+9jkXpK1MVP2xoQbxJauwXW
         rJlXHwJhClvFrq2go5mjQwdfhQNU1YPGvhJYfRBsytcKxEvGtcltyOpgDRbiDiX3ijI9
         LNuZmA/c1lZLFwlk8npf/pMtfsz9v3Xa7X2rqKwmO7rqAF9gXl9s0FckZ9d482L+D80b
         +0ug==
X-Gm-Message-State: AAQBX9c2nznMVSUmKJTDlQJ2yQiDfpuTk/+pw8LNxv1veYdm8Z+qHFEw
        vDx2qPawBydFKS1Z1FWzZgDCnn479EHw+w==
X-Google-Smtp-Source: AKy350ZqEqs7K8sAfAR1QC0ZFvvY7v1s6qB0O2rfJA+Z9xDszlHlxOBpyOK8LlK9bGh/YvXjxiqYUB/yVy0Uww==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:70c:b0:54e:8b9a:65be with SMTP
 id bs12-20020a05690c070c00b0054e8b9a65bemr1009101ywb.6.1682070245907; Fri, 21
 Apr 2023 02:44:05 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:55 +0000
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-4-edumazet@google.com>
Subject: [PATCH net-next 3/5] net: move skb_defer_free_flush() up
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

We plan using skb_defer_free_flush() from napi_threaded_poll()
in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d15568f5a44f1a397941bd5fca3873ee4d7d0e48..81ded215731bdbb3a025fe40ed9638123d97a347 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6598,6 +6598,27 @@ static int napi_thread_wait(struct napi_struct *napi)
 	return -1;
 }
 
+static void skb_defer_free_flush(struct softnet_data *sd)
+{
+	struct sk_buff *skb, *next;
+
+	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
+	if (!READ_ONCE(sd->defer_list))
+		return;
+
+	spin_lock(&sd->defer_lock);
+	skb = sd->defer_list;
+	sd->defer_list = NULL;
+	sd->defer_count = 0;
+	spin_unlock(&sd->defer_lock);
+
+	while (skb != NULL) {
+		next = skb->next;
+		napi_consume_skb(skb, 1);
+		skb = next;
+	}
+}
+
 static int napi_threaded_poll(void *data)
 {
 	struct napi_struct *napi = data;
@@ -6624,27 +6645,6 @@ static int napi_threaded_poll(void *data)
 	return 0;
 }
 
-static void skb_defer_free_flush(struct softnet_data *sd)
-{
-	struct sk_buff *skb, *next;
-
-	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
-	if (!READ_ONCE(sd->defer_list))
-		return;
-
-	spin_lock(&sd->defer_lock);
-	skb = sd->defer_list;
-	sd->defer_list = NULL;
-	sd->defer_count = 0;
-	spin_unlock(&sd->defer_lock);
-
-	while (skb != NULL) {
-		next = skb->next;
-		napi_consume_skb(skb, 1);
-		skb = next;
-	}
-}
-
 static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
-- 
2.40.0.634.g4ca3ef3211-goog

