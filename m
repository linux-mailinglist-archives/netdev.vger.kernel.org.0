Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486946EA76A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDUJok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjDUJo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B9FA5FF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b98f3ca02b5so1213496276.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070247; x=1684662247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8j0kxBgS+/MUBZt2OJJRW1WvP7uZRfrThAKIRjzdqSs=;
        b=tKZ598lyr7kHwSZGuF1X9FoTwdcuNKFra6Jv8/2DpZLVUcCoH8sOuwSQPqDlMNHDp2
         sv6m6HSuHeRlr/vlwfIFkleWHXRho8EIirsJroMLVeU36VN7XMsVORIg1sAZ0zJrd2t7
         esz0LECPT8b7jAd8N8LmlapflbvvAKEyukR6xzO3yUZC4NhonXycVCAyxuyaE7YJJdpV
         QXpV+OcTNa4X6Aqt8v5ObsqaaigXb5srKg0bGLf/Hoi3bI7jG/DoQRAMiZjMOFpk4YMf
         YqOBbXX6jSBj+H7w9h/voEa7Cq9nHWUprsI737qFdvhwjyvq9eQoYbxOeWqvRyIilO3Y
         gYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070247; x=1684662247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8j0kxBgS+/MUBZt2OJJRW1WvP7uZRfrThAKIRjzdqSs=;
        b=hzq2m0bBKUhTTFMuyMv5RJ6MyvTL8CEHSSiByN+H2JTFbhDETnzWMBf7EaFJ2ef4rx
         aShTPhWMxkDL4rb0V/zslEooHoL4fag6F7qzBWycFSCOXFR8TmGTUOFiP503hnwCtATy
         vUX0eKtYpT9BfAGm11Iv+k9/PINcKz5EXP9GMTHK+LFQc7GU4eaUVWRqX8i2sn4kbBS3
         wwP3codj5R9xd6FE6qqj+BzTJAmTf1fMRFIIc5CdV6gv3Q10/VtJng5+ELeSwG14HvLD
         9bL2/O2Mozkz7E3nIUDN0KJN6usSiW6QtgjnnTQ1UulTkbUmti8FRmK2AXo/hajUv831
         kYrQ==
X-Gm-Message-State: AAQBX9f3PlBxAF4+8AYiL/bhqlBRw3hcoebuFJdJWmctDLz07sP7d08q
        dEiL8znvU49kEHIrWVf7aD+lf2H+YMiiOw==
X-Google-Smtp-Source: AKy350b+oYKV1igO0PlgkY8dz0Qldh3VOX8RJnN0ZA4rlYrHz7Bnly6NcwCFaX/m07DqTSXjLWXxcvkBnBxJ3Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:bc4a:0:b0:b33:531b:3dd4 with SMTP id
 d10-20020a25bc4a000000b00b33531b3dd4mr980546ybk.1.1682070247698; Fri, 21 Apr
 2023 02:44:07 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:56 +0000
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-5-edumazet@google.com>
Subject: [PATCH net-next 4/5] net: make napi_threaded_poll() aware of sd->defer_list
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

If we call skb_defer_free_flush() from napi_threaded_poll(),
we can avoid to raise IPI from skb_attempt_defer_free()
when the list becomes too big.

This allows napi_threaded_poll() to rely less on softirqs,
and lowers latency caused by a too big list.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 81ded215731bdbb3a025fe40ed9638123d97a347..7d9ec23f97c6ec80ec9f971f740a9da747f78ceb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6622,6 +6622,7 @@ static void skb_defer_free_flush(struct softnet_data *sd)
 static int napi_threaded_poll(void *data)
 {
 	struct napi_struct *napi = data;
+	struct softnet_data *sd;
 	void *have;
 
 	while (!napi_thread_wait(napi)) {
@@ -6629,11 +6630,13 @@ static int napi_threaded_poll(void *data)
 			bool repoll = false;
 
 			local_bh_disable();
+			sd = this_cpu_ptr(&softnet_data);
 
 			have = netpoll_poll_lock(napi);
 			__napi_poll(napi, &repoll);
 			netpoll_poll_unlock(have);
 
+			skb_defer_free_flush(sd);
 			local_bh_enable();
 
 			if (!repoll)
-- 
2.40.0.634.g4ca3ef3211-goog

