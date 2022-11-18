Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9081762ECE8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiKREiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiKREix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:38:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3725C4D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:38:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a5-20020a25af05000000b006e450a5e507so3559314ybh.22
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 20:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RoUc7dP0RXfISFU7AKB7lYqLgTf31EwetHS4oqxqHjM=;
        b=OD3DZxV/YuDyLUvfhy7pPFQBJgVGwb6Z5zrHTSs3Pt/3p18YsqUphoyFvJ6+8gUOZ1
         xjqFaLxl/Ed1XLMUL0ce7XnFE57qXMDMHhjp4dy93Q0rnWjil/VLDnu5Nu6Bh1+wqYPY
         D18+O23RyJlsYUFneYlQXQ3bA09KPKpjibRO2Cga5qgWGgHLH3GP2VgHxMwadc5+tSVC
         aydEKoHhIjAnpggRFhKOaWyoWx6LlGYMEAJf2NQA5bdikAVHQkO48oe3xjkgkd/EWejn
         tX5LviQrBqSIcRjsBSR+HlmPl/cJKgQ/bAdsCjKDBDuq0wx3pITpCmL/z39jyN9d/8UQ
         CLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RoUc7dP0RXfISFU7AKB7lYqLgTf31EwetHS4oqxqHjM=;
        b=IgZTP7I+A1Lrl7cOjT1hS4exoUOqI/thsy+pD5OKacfrPLQsCPm/qAFcmEpzuOvRQP
         /JqVy2ph7NmPomiov7otgsDijsZx3pSjUsoH8aJanwe8s0vTANXDiA9iJPxZhEehwKi6
         mC1iO8r+YlZL+kJOc1CbS02GMIcnlG4XJEZBnA1WT86Oq1L2VpcnFLD1K7T2BRZRvPhZ
         cde82uqhyACBbt+1j22CXL5uzm+ge60IRMYX79ppwwRzdos6j3BFxdC7aUoxJUvzf7v+
         exTNdwhHtp9b66nxNcwllWhsU9rQtOm1800NGs+JIvONaRIAT7tf/fCITjj2v60B+5Sg
         y1Lw==
X-Gm-Message-State: ANoB5plq9SpnvkgiAdFQEUgPqv1glXdatSR3ujsqeuU+QanPvAhlubx6
        QDzpvgoXeM4jTzSb3ighNaMtsi0ORQVuTA==
X-Google-Smtp-Source: AA0mqf4FnAIxWHuin4dUlFK5hxdbtHN7hWqTYnqdk/CkmG+ql9OpjzKldgB7vwVsVTwpEQPNh68Zj16L+Iv0Qg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:f80f:0:b0:38e:e541:d8ca with SMTP id
 z15-20020a81f80f000000b0038ee541d8camr4841853ywm.283.1668746331622; Thu, 17
 Nov 2022 20:38:51 -0800 (PST)
Date:   Fri, 18 Nov 2022 04:38:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221118043843.3703186-1-edumazet@google.com>
Subject: [PATCH net-next] net: fix __sock_gen_cookie()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>
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

I was mistaken how atomic64_try_cmpxchg(&sk_cookie, &res, new)
is working.

I was assuming @res would contain the final sk_cookie value,
regardless of the success of our cmpxchg()

We could do something like:

if (atomic64_try_cmpxchg(&sk_cookie, &res, new)
	res = new;

But we can avoid a conditional and read sk_cookie again.

atomic64_cmpxchg(&sk_cookie, res, new);
res = atomic64_read(&sk_cookie);

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527347 ("Error handling issues")
Fixes: 4ebf802cf1c6 ("net: __sock_gen_cookie() cleanup")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock_diag.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index b11593cae5a09b15a10d6ba35bccc22263cb8fc8..b1e29e18d1d60cb5c87c884652f547c083ba81cd 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -30,7 +30,10 @@ u64 __sock_gen_cookie(struct sock *sk)
 	if (!res) {
 		u64 new = gen_cookie_next(&sock_cookie);
 
-		atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
+		atomic64_cmpxchg(&sk->sk_cookie, res, new);
+
+		/* Another thread might have changed sk_cookie before us. */
+		res = atomic64_read(&sk->sk_cookie);
 	}
 	return res;
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

