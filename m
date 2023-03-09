Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE47E6B27DA
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjCIOxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCIOw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:52:28 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D73DD594
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:50:36 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1763e201bb4so2564851fac.1
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373435;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Axm/mEYsFxl88X8LxAlaC741Co4mFhokJO1H5zDTC1A=;
        b=zo+zvy/eR8rvYN8U6vA3WCW/8G9ZTGoFt5OdaQAB9KYAZ9u/MvpCyv5YYaqs24IMCu
         X21Y02MemMy4MF+VLA+cQaMZ7eS2QiVudFZCuOS6vGvril8CAIvEYNsPP6deN0vX7V6r
         RSciDtkWMHtNYqErgjAZfxhHBKvzBtj/nnBpy/1DTfCQNdTIz9YyU3BEr15KXsyi01VG
         FE4HqlZQ92gfKYN3DQCN9jbVBiKhCEz9yl1Hw+fVDISOnZoqirwSXf92ftkDUVRxD/NU
         NUcg9/fN7G47/LrDZqmwZQ7Z18HEye8KasvSS9sGi9k9dU9KxAjgmDZXkdZ/yB3AXOaX
         PFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373435;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Axm/mEYsFxl88X8LxAlaC741Co4mFhokJO1H5zDTC1A=;
        b=6ODhAUXDyOkb/LyJuvWfQOoFk9NRnyGhZBy2cE+fquKOnWeIwCyk4/9dmZilRejb2h
         K7XUCgHt5aI3zsMD9HuJ5zJ+ZuVPjGaKTMhOsbhxgNsx5+BwaxUnRhDUoI+jyKSE98w4
         NgiIQKxhYsebUSZh55qOHXGz9ckbMEOepj6WsnuIc74Krs3Te7upp3px61LmNM88/bFW
         XtJfz7zcQuaCUE53Ij3DQNLYGqTNf1xgKVTbQY2reWsaeZpjqvi7KZBhZ2we/MAzAQUq
         iVfvmAvKxoVsX1fjVr/Htblg5D/2AInbKkv589DTOLJUJ8rqJpwqtGZrzTsm/aPGWJ7U
         0ZdQ==
X-Gm-Message-State: AO0yUKVEnigLoKyWWpW8XxWLvXHxNhhECUWjQ2QN0MESJEPcjF8Gjt+b
        BnYuMbv67aRB5KKLLWpELqjSig==
X-Google-Smtp-Source: AK7set9juLhEoEB1xSU9mBYPmwAnG6JJNXp3wN/PuEWT7REYhe3oHgqS9gJVsbpvcKbaIZHttoiiYw==
X-Received: by 2002:a05:6870:82a9:b0:16e:223b:1922 with SMTP id q41-20020a05687082a900b0016e223b1922mr12985082oae.15.1678373435231;
        Thu, 09 Mar 2023 06:50:35 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:50:34 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:49:58 +0100
Subject: [PATCH net v2 2/8] mptcp: refactor passive socket initialization
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-2-47c2e95eada9@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5101;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ver9M0p/LeGtx9UIbzbhioiM0gxqrJ/KIvxjL/g/J6o=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhsDZDaZWYi9As+hGXqc0WzNSDKUQxICz2p
 zrcih1ESUyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c26aEAC81nEv5iyWLUuzRiz/oUj3dHjVdWTC1E8hH1V2CTPFJD/UDFToSGq2AVanRXd0A5srCnd
 HyQWhITDG79fuYoT2qFjqm+xC5UT1Arm0fM+jjYbjBJZMumtv39X86LSo/sDRKCg0zR4THjVpgV
 pp1zotcEPYVM/1XT34wmldimJPe4NxhoDLwtU/aq9qeJoW20b83bGv8Kdo4IkyCb89vRTxBQwct
 /ikV4zkt+RFEHRo1B2Ym2yNm4iSv/t/FVnGn6hjxTN8OkPLYFOAuZ2+XIDU5pdgrh8i6hBsI+Ea
 BJSyN8iB7VN5AhtfJ0g5GaJiJe0Pc2T2BV/iKwlXoqy1qme7PZk6wkH+BQLeBDzVWOe8LSP5gtQ
 pDpZky1PGmrYp1L06F/VYf+TMOdRr0Cr/vavBjLHGpsdjTyS9DABle+va1pn0ktKSHvoK7a6kZk
 Vod9KzV47JlJOGtmwo2NIq7xXBjXwbFgtP31kpsRSsLghUI6VukVURRYi88FQWHOU90m1x1pLez
 Fpfc8v35Nmm4+nUwqdAVq1MTeHf3ZHMKoHFvVo6ZW2EPmdzF4lIMmzGVhBFLiEzwBF67QmJr+PJ
 8ZwRGeas1QOJ5KIhpwo6upYn0YZDsw3Q7FTTiqPslTnGh84ST1OP1qTh2BTjlhhZc6Gv7u88hTj
 HlCBtB80Et7RP5w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After commit 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
unaccepted msk sockets go throu complete shutdown, we don't need anymore
to delay inserting the first subflow into the subflow lists.

The reference counting deserve some extra care, as __mptcp_close() is
unaware of the request socket linkage to the first subflow.

Please note that this is more a refactoring than a fix but because this
modification is needed to include other corrections, see the following
commits. Then a Fixes tag has been added here to help the stable team.

Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 17 -----------------
 net/mptcp/subflow.c  | 27 +++++++++++++++++++++------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3ad9c46202fc..447641d34c2c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -825,7 +825,6 @@ static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 	if (sk->sk_socket && !ssk->sk_socket)
 		mptcp_sock_graft(ssk, sk->sk_socket);
 
-	mptcp_propagate_sndbuf((struct sock *)msk, ssk);
 	mptcp_sockopt_sync_locked(msk, ssk);
 	return true;
 }
@@ -3708,22 +3707,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 		lock_sock(newsk);
 
-		/* PM/worker can now acquire the first subflow socket
-		 * lock without racing with listener queue cleanup,
-		 * we can notify it, if needed.
-		 *
-		 * Even if remote has reset the initial subflow by now
-		 * the refcnt is still at least one.
-		 */
-		subflow = mptcp_subflow_ctx(msk->first);
-		list_add(&subflow->node, &msk->conn_list);
-		sock_hold(msk->first);
-		if (mptcp_is_fully_established(newsk))
-			mptcp_pm_fully_established(msk, msk->first, GFP_KERNEL);
-
-		mptcp_rcv_space_init(msk, msk->first);
-		mptcp_propagate_sndbuf(newsk, msk->first);
-
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5070dc33675d..a631a5e6fc7b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -397,6 +397,12 @@ void mptcp_subflow_reset(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
+	/* mptcp_mp_fail_no_response() can reach here on an already closed
+	 * socket
+	 */
+	if (ssk->sk_state == TCP_CLOSE)
+		return;
+
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
@@ -750,6 +756,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_options_received mp_opt;
 	bool fallback, fallback_is_fatal;
 	struct sock *new_msk = NULL;
+	struct mptcp_sock *owner;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
@@ -824,6 +831,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		ctx->setsockopt_seq = listener->setsockopt_seq;
 
 		if (ctx->mp_capable) {
+			owner = mptcp_sk(new_msk);
+
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
 			 */
@@ -832,14 +841,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* record the newly created socket as the first msk
 			 * subflow, but don't link it yet into conn_list
 			 */
-			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
+			WRITE_ONCE(owner->first, child);
 
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
 			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
-			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
-			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
+			mptcp_pm_new_connection(owner, child, 1);
+			mptcp_token_accept(subflow_req, owner);
 			ctx->conn = new_msk;
 			new_msk = NULL;
 
@@ -847,15 +856,21 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 * uses the correct data
 			 */
 			mptcp_copy_inaddrs(ctx->conn, child);
+			mptcp_propagate_sndbuf(ctx->conn, child);
+
+			mptcp_rcv_space_init(owner, child);
+			list_add(&ctx->node, &owner->conn_list);
+			sock_hold(child);
 
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			if (mp_opt.suboptions & OPTION_MPTCP_MPC_ACK)
+			if (mp_opt.suboptions & OPTION_MPTCP_MPC_ACK) {
 				mptcp_subflow_fully_established(ctx, &mp_opt);
+				mptcp_pm_fully_established(owner, child, GFP_ATOMIC);
+				ctx->pm_notified = 1;
+			}
 		} else if (ctx->mp_join) {
-			struct mptcp_sock *owner;
-
 			owner = subflow_req->msk;
 			if (!owner) {
 				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);

-- 
2.39.2

