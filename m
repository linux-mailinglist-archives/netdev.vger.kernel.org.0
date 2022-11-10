Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A79E624893
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiKJRsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKJRse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:48:34 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E98C25EA6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:48:33 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-373569200ceso22410397b3.4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lHOLyRwZk+Y2P6TpUgsfMgSw6FwOJhKVMz1wcjVhRHs=;
        b=RH2W6YpTgz2/EIEAgaxfiQrTOPLPe6zdDm0Df8TBvLHiLKSudg3isb7dAXEiAqu2Vn
         /DxOmeCKH8Gka/AySoSWdTuvyNmC7FTbMk8tsECMZTXh5++H7BkQdcw37jlva9TShyDX
         c93ZErH8Z9LC6XGPoxCZ3fzd55jrNIELNTBLodjaPyajG38JSzBooPgVlxnO8Xkdfi6P
         S+Kt9CAr84xnJ2NkZCIn1HOesbIV5i8r9g6GBgNEIaY/augeFPIB4V1uLITR/yri/XkZ
         czi4GxsT6E6Ri2b0TgJ6+pdOrYnp+oBjukiB2PinFu7Yi3DvJJKTqliBGxuPMlMxIaDG
         /bCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lHOLyRwZk+Y2P6TpUgsfMgSw6FwOJhKVMz1wcjVhRHs=;
        b=mb5DIrnGizgY8G//QwtpA84ZVD/IoPMTIElyE+afgzlLnzqPLoC8rXdTdcxDp2kZeY
         3pSySh7n5XKvv/c0N2warc3xq23mk0Ld18k6mn8gL0MP7LBkDEeUrvlQmc3J0JY2ADOm
         q9ABfivPcqoT/X4v5V+Lq4eCODioT4STwfoDef+ytr/USjEPrWnoe/I+nxbyew3E2tLK
         2FmEh3qyTKiCSyoJYSd7IXjbXbD4iFT3GLBqjEKAI416H4hfoy+FIDYgfAsQXZHEa6NV
         SwSAQTECBH60aWexxWEPZxLLFUwlQZLj+NVtF6HTEW2Q4yGAdmCL6kaaJ9lGus6c8cE4
         8SIw==
X-Gm-Message-State: ANoB5plcmxyR+VwBdMG61p6+lqSTWMWsAcxeSxkzN+ycwxjglcG9PJV4
        f8QQ4YdZqc0poEY1HFkaHMGV82vkM9ncMA==
X-Google-Smtp-Source: AA0mqf6iqi72yGLt5Z8RThVCfJ26D0oRFJkHJca9X+5W6Hfo44Cl3NLDoZ7t5PbY/a/ICgN1y4zkP385OcywGw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1381:b0:6d4:84c5:8549 with SMTP
 id x1-20020a056902138100b006d484c58549mr978209ybu.376.1668102512658; Thu, 10
 Nov 2022 09:48:32 -0800 (PST)
Date:   Thu, 10 Nov 2022 17:48:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110174829.3403442-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: adopt try_cmpxchg() in tcp_release_cb()
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

try_cmpxchg() is slighly more efficient (at least on x86),
and smp_load_acquire(&sk->sk_tsq_flags) could avoid a KCSAN report.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c69f4d966024ce2c37dae63f7be94fe79c7dd648..d1cb1ecf8f216dc810ca08ea35ae752fd19ba706 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1077,15 +1077,15 @@ static void tcp_tasklet_func(struct tasklet_struct *t)
  */
 void tcp_release_cb(struct sock *sk)
 {
-	unsigned long flags, nflags;
+	unsigned long flags = smp_load_acquire(&sk->sk_tsq_flags);
+	unsigned long nflags;
 
 	/* perform an atomic operation only if at least one flag is set */
 	do {
-		flags = sk->sk_tsq_flags;
 		if (!(flags & TCP_DEFERRED_ALL))
 			return;
 		nflags = flags & ~TCP_DEFERRED_ALL;
-	} while (cmpxchg(&sk->sk_tsq_flags, flags, nflags) != flags);
+	} while (!try_cmpxchg(&sk->sk_tsq_flags, &flags, nflags));
 
 	if (flags & TCPF_TSQ_DEFERRED) {
 		tcp_tsq_write(sk);
-- 
2.38.1.431.g37b22c650d-goog

