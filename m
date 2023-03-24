Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF556C8303
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjCXRML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCXRMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:12:07 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1B72195F
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:05 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o32so1564188wms.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679677924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DfQGO7HiqyLcIeH5zAb3xpz7XHJxCFOLCtkr4OjpBrA=;
        b=kKcSWMFoxwby6OrPI6KELDITY73iVQMqwa0lfgDhsmjI/9A+9FwCjhlhdlOXJMpJnC
         aMGepOrv+MaYS5YrJ/g6i+kkoNY13J18hVzRUgnoZJkVM5LQLGfwHSalEK5fWveEmfBH
         tkpxU2ymfum5OzOxXNZ3O/auWacVlFPHHXzgWwBdb+1hzJ9sBdvdNtIpRmBKCSu4XDYU
         O5dcVkMMCoRKEyDj3T658tQajxqzcp6IXdLsQWgWPjR/QIxjZ2o4HTkOGBh/GMY+QlpB
         siZzOl8PatNHYscJmNXNjGH1Y393we6Z4jx/agYGWE+UZXD5lnowVUoDkuX4PHClzM44
         feOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfQGO7HiqyLcIeH5zAb3xpz7XHJxCFOLCtkr4OjpBrA=;
        b=nD/QxceuNH7SaVrZbzlDqI1jPygSQ+9B1eqSZ704/WY8l98h/Qx+25thMiP3JUkvSh
         HqYPWYiiWq+FxzwB4qMIUL5v9r3UxYxYP+sDecI4+12NwJht+QORLvlpP7jn3kvjy2DZ
         5r0Jgx59w+ehevOXLK+Rengzu30QUm/W5GlCi4cs2NPyR+FDbAUxV4CcvaKmMPely6oB
         kluHQ4eDxM1uPLMplUWOziledPsiQl+FpQ3AynSDJZ8gQm9k91clzoX8eQ6a1oYdNo+h
         j/LpI4LgLnYC6RjP4zw5D2H9BOE4f7I48LAMa7M9hTdZ3Q58jn45eVeVzsS8IxvN1qzM
         /tUw==
X-Gm-Message-State: AO0yUKWHEBfWzlGRUx5lWn7FyaJEhnciKmZQ5un/NJvnH/mUolQlpvl8
        9tlh2CFBjW0IwddiX4QAVeRNig==
X-Google-Smtp-Source: AK7set/D1Rxo5g5pMFN+Xc9mWokf4E90DNym99N8IThncqYtr4RGToLXtWzjaxRELroBbAwXQteRGw==
X-Received: by 2002:a7b:c84e:0:b0:3db:8de:6993 with SMTP id c14-20020a7bc84e000000b003db08de6993mr2608646wml.4.1679677923996;
        Fri, 24 Mar 2023 10:12:03 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003edf2dc7ca3sm5336285wmc.34.2023.03.24.10.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:12:03 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 24 Mar 2023 18:11:31 +0100
Subject: [PATCH net-next 2/4] mptcp: simplify subflow_syn_recv_sock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v1-2-5a29154592bd@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
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
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHdnhEi6SS1AGw2zqAuFABFUg/oBXMs9PA7F9/
 JFx/ONUwrGJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZB3Z4QAKCRD2t4JPQmmg
 cxWPEADZvswakigKFQDqyOHzImBZyfmfPeNF72nKbAVFj8xtOMPMWPs9tgzW4go+Ynl3EhZaM5c
 GG9L9s0UhVQGGqop3CtKZEv8I+Q/LSaEvZ5dpKGPDkmOZB2Q+CnV532P26nzdpCjvPmxpjVimkD
 oNOyf2aXQt4/+x47Y3IbiGgnJ0BkfnqrnDJJbIAHyMJpuh72vl+qVAB9HwPzKIdKKlMVgVI+C+j
 J4V2od8jADQb64qjVd15EZPDBCU0qXWk6CvKGd5kwEGI8jNnKIC4cQRaBwp2/oxjbU8u6/3vjJr
 G9hqwSL4lk/npUaNSOwlN1TN1/7Xz7lxI1slzKQzrmdYhRvjRxKFHbhXGimGsUzRPHuB0HT+0ZF
 I1NG0NPOpDFOochYF5tmzcu3PUXx10JPGg/dBVJ8CF7dAKyIS389vslZL2ymSA+L2LuT92xjwJg
 pt20egKoWqc7G/n1Y0bBGYJGCYAP9n4FyWHZoUPuF3jmhe55xFbvinvrDMFEk1it4p46NpBywiA
 vKJe7OPtCERT8UEPltGYf3GrsKSG//JVHRxFxf2/3qFI1floGTpoSOthXA3BOT6Skfr/JozxexJ
 dFoUC9nbrZTfm2j4ycG2ifrQQ4R+I6zqC8vPbktlGMWFOwpG0UNlrIjZGr/9pberY2fH+RgXZVd
 HeGrEZ44Mxu69fQ==
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

