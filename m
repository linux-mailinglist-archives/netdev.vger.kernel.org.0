Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4C6A47F1
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjB0RaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjB0RaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:01 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2863220575
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:59 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c18so4733138wmr.3
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xwuLbzzjRRAh6S1DAVgsmzERI5QGCnConEd5TaEfo4=;
        b=SWimbnPLiF1N/GlRQ5/q8E8L5dN00xq57D8orIk66VcANRv25R9CLGh9/3zQ6qS3RA
         h1KExRW90aAa7e//nAsveFPi4/XeOfJ7ebcq8oaKd43K0tRxAaeft3F+0882qiOBGzzI
         sk5mtoF1w+Gs0z6RhDjjUiGIvT4vjj2V5I6m4iQa2E7FO9jHSDh2EBYyMYHuBaIG1lcd
         nkZw36Mg5zRuL9XJ3EKewvSc/ANORQ1FRw5HhuTJmtHb/V7KSvrnHeoH+xr/4PIkYt95
         ox9Tzw0hMVkamcfs0HyLM5NYVyY3Sf0Rt5Xjr/X+IWKlLm93tlpo1M5bR3Y/9DcS+rZp
         3yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+xwuLbzzjRRAh6S1DAVgsmzERI5QGCnConEd5TaEfo4=;
        b=4vREtqa/VIaY/uN1epMO+NnHWRM9sA/wScqyEbLoJSIHGKKm6EO+jzciD5gU1W3WqB
         UXJB0oXketDIZwfJxCVMEYSGbpRV45mgOIFeTrvH/JvJ/vfoZGejs1MG5OmIjZI3g1iO
         4eaU1dfTQctWLzQDP3zt8HUpbO8KcMqxx6TDEeDxnFYp0uCiJ/bkySbWetrsgqeiGDar
         q7/r7LpJaFOuj4prn4wjEaw3mHhrZKfU+zBNRc0xcerTMJGYfOK+kTHXscFdv1M8bvek
         v+7icmK2Ps1M6V1SLWxx4RalQR1kndS5dFLizaOVcBKJiBvlD591y2wg39/Zl/atVLon
         TdDQ==
X-Gm-Message-State: AO0yUKUFHSJLea9XxTPg5lRy9roeUv/br4uu/W7J3mu+7wVRLZWjZFe8
        JsfQaqLi+l8KiSEdQrw7zYHG8w==
X-Google-Smtp-Source: AK7set9Clk/FM2QwxcSEAPA5qm1nnCc2bIYe6BTRBKFPrx5I7r52bjQObZ9AV9NQu5ivfTKg00SakA==
X-Received: by 2002:a05:600c:4d26:b0:3ea:e4bb:33ef with SMTP id u38-20020a05600c4d2600b003eae4bb33efmr10833906wmp.9.1677518997551;
        Mon, 27 Feb 2023 09:29:57 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:29:57 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:25 +0100
Subject: [PATCH net 2/7] mptcp: refactor passive socket initialization
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-2-070e30ae4a8e@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5109;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=tbFi78t3ZJmGgmk77mV71qPhyEiu8592XCXi0Sgwm/E=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiRMixVhjQITtEfa8+FE1hs0nnPrY7e2/glP
 5zeMGcvplmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 c2ABEACE47Ez3BM0QOq9aru05LBJ3HdJpAJ6NmkQApWR68gK5pffFSZTXaJx1I8nHUMnbjY9vJ8
 TwyC72pxDM585GbcFrQ0P4e7VR1I18eVlsvbFssAW27Z+Aa/8sSa9Mif3kIdhC7gNRBEs4erGW2
 cPm7jVJPVq/zubehF3IxPSfUETdQyJKMM1IDVYKTtlQVakk+LOONQtS1cDJm2DWJUXGpnrBSIoq
 EMlNzU+8rqphpKiDdD4iXe5nFtmj6mF3+bSyzIp81gtuLprPLWol3CK3SHXqvAPelD5fXq986Ov
 Q2iDRxUDlvoQR05P0yhHzhO0cW/vm0Zk/Eu3voy6hGtsg1O7DYsbKY+gQc7Ca0haxh1J4H52aIf
 ZT0fhdyPL+RUPQWmzg1ElAQ0sp2g9OGShUNTHY6A5dn2i0XLVrrsXequ36M3ojMMX1oJQDI6F7N
 /exmEZiJKupvpWs3jfdKLJv9sO1im7790CdFF62U/KryYLS1c//kE09MBfgjU3kzB3udwfaCfvK
 TKJDH2WflZN7U0RLqOJjoe1S6qGClKWT31+Vlcvzam4l5duTEwWQCUcRmmYovNsHeRMqgUn8/a4
 NhmD1dpy61IG1YouwZ59oP6T3OGQOlR8C/fOq5AFMVhTbQUTNu2Iaf7WC0UpAcotVEDuANhLWP+
 179QYpvncDR3vbw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Cc: stable@vger.kernel.org # v6.0+
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
2.38.1

