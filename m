Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E98C6CA149
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjC0KYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbjC0KYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:24:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7234B5FEF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:24:17 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p34so4723816wms.3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679912656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DfQGO7HiqyLcIeH5zAb3xpz7XHJxCFOLCtkr4OjpBrA=;
        b=qbm/CSXnVXbWDqbgODWpPaBsxqFt3z34w/7tLjhROyOiubX4ezUpsucQfRdacUsjUS
         kr71dcencw7qgtZl+hupvEv36vCSfxIEfmWORFs2c/UGElooMwfrWSnKYzBLV2FzZ5m6
         oMwKC9Dwt95HbVSxJVEBP9wBjdlH1qXXmPTYZgLhYOoLNxryK24KKOGAYx8A/Qci7oEj
         6DGQpqMIPINiQxp26q4L7bj3PK7BI9enu7MZtF3ojiNbLgZGPm8937ZnZeuo6eXV7jAU
         SPCiZFiVwOab3SUd2bjQP+zsd1WLCFQO0qRp2ev2Fb7KyktXQiPrRDF7cGQDL75tZAyX
         t9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679912656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfQGO7HiqyLcIeH5zAb3xpz7XHJxCFOLCtkr4OjpBrA=;
        b=n1ngcqI/9xt7mKqzgYqu+/fnHTs80bf9mrf7FPiuOjVSjXkfjApFW9Ccqus34lcM+X
         si20jU38pa01oZIEK+qHZvGuGdAM/06RAoQZDXBg4qiylFYZpJM2YilPC/9d2SaFH5HN
         Et6aqZAjZ6+77ur8MmVVSFA1T9ZAgbXxWF4pwpuG8ZH8LtqGOU4UKgCRAfPd8h5cr0hV
         IoZIJlFQ2qXQqP2o8oOyYu3sqvNN2HiNmf7U9iASR3EKWLss2GzxnQELL/evibmsQa3w
         TmtlicutEz+fxioDqpad5o8zs7atg3aO2IK94aHtstZgo3eKpJj3fmaWFw59OS3ski5Z
         gBig==
X-Gm-Message-State: AO0yUKVgGy0bWIy27pmwY53IoyfbRaQrfreJIQWt2+qhfN9ECiYspoEQ
        IBxO4G8+IQG+SpE9iW7kAgxwow==
X-Google-Smtp-Source: AK7set+2LWfvun1lFN/LOFYWA7WY1qZ+fMem3xIvdcaRE8DjsuVs3cc677iWP/8xU4RPjxX6PQSEMw==
X-Received: by 2002:a7b:ca58:0:b0:3ed:93de:49ff with SMTP id m24-20020a7bca58000000b003ed93de49ffmr8564400wml.0.1679912655781;
        Mon, 27 Mar 2023 03:24:15 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c358500b003ef6f87118dsm2220615wmq.42.2023.03.27.03.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 03:24:15 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Mar 2023 12:22:22 +0200
Subject: [PATCH net-next v2 2/4] mptcp: simplify subflow_syn_recv_sock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v2-2-fca1471efbaa@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v2-0-fca1471efbaa@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4024;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=7uLks6etvBHmX3D/9NEd2CCNOkTvJiV0jtPxB4Im3Xk=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkIW7NUpTMbB/3pGtBJC452VKUDrNAqwyYxaBgK
 s232IPVO7CJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZCFuzQAKCRD2t4JPQmmg
 c6GJD/sGbRZlwUczkfNaaBiyIjErGLVMA2faVXaO+YpC+bwsiZyhC5/RzFWfk1LnL3Zm0qEEAgu
 KI1o4dTCft1F/g/+C1ktD42gg/14glZpuF00s6LlaR1kRJLoCrM7UU1HkJi2kShFiEmXOX9WX7a
 wjCASMQMtucVE7XuYJthSNJ/E6DOFMhSoXvgWVPKldoB7uw/hoyq0GU+h0rGTsHzG9m7DtYd9ue
 BrxOHictK9/EGWt0u+LUu88PIqaSXzHsZt+TVBS9tQ67RHBohL/lJoV0WHfRtrKTBBQHk2+PyTi
 4FGc20VxbsK5q5TP1cqTl0pP0Vm7BmTMOhgNgePUn8QgCfrK1VvkVGZ95K94irclqs9mOo09pFb
 4P0KmvSqK0X2fti4Tq3pHvIf4kLNdJqoLRfj0S6DNLmKIExjQUaPrvNevMKaA5ZLR4rrvKvXlqS
 0hIlAZKnEu+dKH3G+5wBr8bpuSdybhQxOapTVRmKCIC3qaaj4pcuZpJ17uxwp5Z04WzCHIQ1CD3
 Kuqttw0ITNnNwJNPaFbqUeO746eefWUzo/F7AYQnGBh0ufcWih6NWmaKXYhWE0gpUYdisZKoCxc
 N+uvrFvSq3OHcsY1jjfxBzk+eh1qiVXffi52YNRNRS7eNUU6T2nwoCFpcT7yHzi486Lqg3HUIjH
 H+xjoZW/oCB/HXA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Postpone the msk cloning to the child process creation
so that we can avoid a bunch of conditionals.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/61
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/subflow.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a11f4c525e01..33dd27765116 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -696,14 +696,6 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 	return !crypto_memneq(hmac, mp_opt->hmac, MPTCPOPT_HMAC_LEN);
 }
 
-static void mptcp_force_close(struct sock *sk)
-{
-	/* the msk is not yet exposed to user-space, and refcount is 2 */
-	inet_sk_state_store(sk, TCP_CLOSE);
-	sk_common_release(sk);
-	sock_put(sk);
-}
-
 static void subflow_ulp_fallback(struct sock *sk,
 				 struct mptcp_subflow_context *old_ctx)
 {
@@ -755,7 +747,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_subflow_request_sock *subflow_req;
 	struct mptcp_options_received mp_opt;
 	bool fallback, fallback_is_fatal;
-	struct sock *new_msk = NULL;
 	struct mptcp_sock *owner;
 	struct sock *child;
 
@@ -784,14 +775,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * options.
 		 */
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC)) {
+		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPC))
 			fallback = true;
-			goto create_child;
-		}
 
-		new_msk = mptcp_sk_clone(listener->conn, &mp_opt, req);
-		if (!new_msk)
-			fallback = true;
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ) ||
@@ -820,21 +806,23 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				subflow_add_reset_reason(skb, MPTCP_RST_EMPTCP);
 				goto dispose_child;
 			}
-
-			mptcp_subflow_drop_ctx(child);
-			goto out;
+			goto fallback;
 		}
 
 		/* ssk inherits options of listener sk */
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
-			owner = mptcp_sk(new_msk);
+			ctx->conn = mptcp_sk_clone(listener->conn, &mp_opt, req);
+			if (!ctx->conn)
+				goto fallback;
+
+			owner = mptcp_sk(ctx->conn);
 
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
 			 */
-			inet_sk_state_store((void *)new_msk, TCP_ESTABLISHED);
+			inet_sk_state_store(ctx->conn, TCP_ESTABLISHED);
 
 			/* record the newly created socket as the first msk
 			 * subflow, but don't link it yet into conn_list
@@ -844,11 +832,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
-			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
+			owner->setsockopt_seq = ctx->setsockopt_seq;
 			mptcp_pm_new_connection(owner, child, 1);
 			mptcp_token_accept(subflow_req, owner);
-			ctx->conn = new_msk;
-			new_msk = NULL;
 
 			/* set msk addresses early to ensure mptcp_pm_get_local_id()
 			 * uses the correct data
@@ -898,11 +884,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		}
 	}
 
-out:
-	/* dispose of the left over mptcp master, if any */
-	if (unlikely(new_msk))
-		mptcp_force_close(new_msk);
-
 	/* check for expected invariant - should never trigger, just help
 	 * catching eariler subtle bugs
 	 */
@@ -920,6 +901,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	/* The last child reference will be released by the caller */
 	return child;
+
+fallback:
+	mptcp_subflow_drop_ctx(child);
+	return child;
 }
 
 static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;

-- 
2.39.2

