Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2186293F2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiKOJLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbiKOJLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:15 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393225D5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:14 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3697bd55974so129510717b3.15
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Q+NBgnsxBhbS8CdFydsv9HAeIB1Hf47gnOOENdaeoQ=;
        b=n/68GvE/xJTi1O94gN97zg2kEVBihz3YWx8HhowtfmcpH+n722ApCBaD3BvaP05wth
         IX8FBJ5a58oDDqhGFlC+yuGpnHW/+wP3oRJADDbl+Kosc1rhtogQoQuNfyYMvVKH+Aq9
         MFMpMzQvzVRFRLI48fw0TiBnfDYsQ8Jjh8QGr8ktBL9wy6jEOiV5Xbha5iWpmMgESa44
         Q4u14/1xOVc2TFP5sbNS2MlhSKqzuODjXYeHg9+FNKpVcap1WmrIhmkzRz8w3DeXW4xt
         3CG65c3OsRcH7JjoIJG7bxXN1kD3p87Jyciqm3S/R6gfeR+taz/yuqpSxwZiGx3Mhs0z
         wprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Q+NBgnsxBhbS8CdFydsv9HAeIB1Hf47gnOOENdaeoQ=;
        b=tmJc8MiBFvUS27pKveIvXk6Jj0KX+SBbGJjcEpOw/TGEstufa+Ihjwvd9KBd1cmIZc
         61oOku78gsyxyuLQzrBcdi5Q+UDFcsHpOJQFJgJ67RH1GsujhX6YCb/uGxjbhH0q3bsK
         S352vF3ih0VCH5qZfhkU1Q3FjHu1ZeJ1SigEGOlZESgYuADxQ+arrgVQfLJJkxwjGNy/
         RdFOiBbDV/FTiJRL/dIebSfCWHtIY7fjmRXFP6u5whmc5wN7ghhFxmZa1bAaZWZwBkNe
         HwwJCsz7WeVsLxUuTFaQCLfWhR35URaf6K+KGfvJfAYnbZcuRhOYC/23OfZpBxsI2hxM
         UDAQ==
X-Gm-Message-State: ANoB5pkQZsyfs3on/W9KEu0xqom3/sR5dSd9OJRftZg9W2ibX7IdWfMS
        2n+f3S5wGQVt902rhJkrGm90uNA0tfeOdA==
X-Google-Smtp-Source: AA0mqf6hfIbyWf4NvjQSVZGDwH85zXS/sFcauG4+1nxuHmvcDRGtIS1VeSWrpscs9CVsS9AadQ1tVFcBQLmakA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:604:0:b0:6dd:cf4b:9040 with SMTP id
 d4-20020a5b0604000000b006ddcf4b9040mr14934620ybq.223.1668503474245; Tue, 15
 Nov 2022 01:11:14 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:11:01 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-7-edumazet@google.com>
Subject: [PATCH net-next 6/6] net: __sock_gen_cookie() cleanup
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

Adopt atomic64_try_cmpxchg() and remove the loop,
to make the intent more obvious.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock_diag.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index f7cf74cdd3db1f7f0783db88fc28fd876fbac4b6..b11593cae5a09b15a10d6ba35bccc22263cb8fc8 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -25,14 +25,14 @@ DEFINE_COOKIE(sock_cookie);
 
 u64 __sock_gen_cookie(struct sock *sk)
 {
-	while (1) {
-		u64 res = atomic64_read(&sk->sk_cookie);
+	u64 res = atomic64_read(&sk->sk_cookie);
 
-		if (res)
-			return res;
-		res = gen_cookie_next(&sock_cookie);
-		atomic64_cmpxchg(&sk->sk_cookie, 0, res);
+	if (!res) {
+		u64 new = gen_cookie_next(&sock_cookie);
+
+		atomic64_try_cmpxchg(&sk->sk_cookie, &res, new);
 	}
+	return res;
 }
 
 int sock_diag_check_cookie(struct sock *sk, const __u32 *cookie)
-- 
2.38.1.431.g37b22c650d-goog

