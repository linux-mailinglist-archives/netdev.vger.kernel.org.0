Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289BD6A47F5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjB0RaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjB0RaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:02 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1E42068D
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:00 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id j2so7042529wrh.9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9GAyEl4C9LnoVvjZlnA+Dugg3thSow4Nn5Pvy+ljcg=;
        b=z2YscE1HF1nyhdu76M8ShTWxbvnfPVOhE+bAk5dsEHiBEmWF2C+IUBeJYYYJim78jR
         lSkxA1b3hB9p4MazbhcemYEIq/y8cadBJgrnt2kdHIy/gDtn9qpiGbxp0ygMmBLxFT9K
         kPYAU3u4+tMEb5fWyp8ayOjqJaz/dY24wINt/fpOI6vziHabCExEHdqkAmPI2q3WQgM7
         qljASj0gX1vgE6TlgK96lLCV/5/gegjlLql3ELqZqX+SCe9WYm5XXk2ZkTDIBO1PtmY2
         0Yzu76ukXLP0/d+NXZHBx1vjLLgBInUtoCRSPw9k17NVscWoBrsdbzJkWSOnMVtzc8bA
         CHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i9GAyEl4C9LnoVvjZlnA+Dugg3thSow4Nn5Pvy+ljcg=;
        b=Xzr8cIww7KsAfNycFuDWKODqunhxPq2h7pDPJGLTwEIWrWChq2VhtDtsNNonHpgcU6
         FrI6/4oPgBB5LQxBz52mbKq1qf7EEQk3UeS7RLydeWwbCJ6A4f5W0w4S2JNHN0x+ScA6
         o5TFY7sYiVsNlrwl7z/TNWegJrGhvC042qgVAHz71b/+m02hDSHdGuDvQPdD/+k+hcBj
         al86+7ulWuwagGFXBAZW+Culz3kYdkmPNYfsxaapODOE2bbGwzs5MW49HdXuBvwfBuHA
         7ZrRqxGS0lISyh10QNDakuNGt3WEEt2u96B2LrLhBMOyLCwd+HWOILkJRCf/XK+uk0i0
         SunQ==
X-Gm-Message-State: AO0yUKUQT7/a6Ug97M1XPchlkPDD/qxlffJlyqWuw0seh8FTMigIaxQO
        XkhCwTLX2xZVLostBn1YR4eYAw==
X-Google-Smtp-Source: AK7set9vUiz8NZ0pTcZiJrkRVRm+/qi90uWNf+1p81Dn7o1cG6dKUHYDXKo1xygqzhUYiVBjASSzIg==
X-Received: by 2002:a5d:66ce:0:b0:2c5:c71:4a84 with SMTP id k14-20020a5d66ce000000b002c50c714a84mr19019574wrw.68.1677518998639;
        Mon, 27 Feb 2023 09:29:58 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:29:58 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:26 +0100
Subject: [PATCH net 3/7] mptcp: use the workqueue to destroy unaccepted
 sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-3-070e30ae4a8e@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6857;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=309aB02I4occX7z9b72eaeFVfr8MkhEIbsSJWdCuxCs=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiRb6ItuVn+gwOomDlkQV+IcngyV+LdEmFHC
 4vSLDDcRlSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 c6UVD/wJqMv0Xswv8nzWWoMs80prU8GVnJzDLy5zxpPH70HsPiS6fOB0HaJ/SkCsnDCHFKlOMTG
 dSoqWE1gllVDL6iiduYqV9QBw0xdMbYl7VXWe1cdrFHzFE+r4HeSFlAiWJHY+r2SU6RAxM4lVag
 Q6jUy1wVhJ030zIbgzzPrkf4fe51y4QHK+K6+GthRQRKYZZCmYNIpZoz5JP1z3jZXSeBcvVjPZs
 QSY/4LEnrRjA4Kt4JXYbSQZ6tl6aSQ3C37rmLUpVhOuPoAmFiOLCzc+B3F+zSp5lHEy4HcTIIPG
 q3STm0dGfi4XybOjibwBRR6FkY8dKhPoczM5X/FW+jyqg8icxpvKM23Jmgp1U0PhE/CJxkNbMb9
 9DY7/Ro0p5MoChxAZ9E3ML2RoPCXIT1CWFnOSkU8TOis4j/010pSEnNi9c0iowsiI1PFUniZxdl
 rXHLe1VQk0l5LMzrGr0X7cEINmXSI5gnEqRKvnETe4y+RqtA8BAZV1JAPze5LQQ94B78KrJsWSB
 /XidsejUOiUrLk114oDt0Mej0ZFbkQ3EbvGpfHaQzPe4kDYFutmqYTzm1YZU/lc1wyQJKkEk3Uo
 A9ILF5KisjdHWDeQeXYauIQ+/JkGfXAYS8UM69yWManBBtGTyuz+1sZ6IQ22AwCFWL7rnvUZjDg
 TSDrt1eAqp0h9YA==
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

Christoph reported a UaF at token lookup time after having
refactored the passive socket initialization part:

  BUG: KASAN: use-after-free in __token_bucket_busy+0x253/0x260
  Read of size 4 at addr ffff88810698d5b0 by task syz-executor653/3198

  CPU: 1 PID: 3198 Comm: syz-executor653 Not tainted 6.2.0-rc59af4eaa31c1f6c00c8f1e448ed99a45c66340dd5 #6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6e/0x91
   print_report+0x16a/0x46f
   kasan_report+0xad/0x130
   __token_bucket_busy+0x253/0x260
   mptcp_token_new_connect+0x13d/0x490
   mptcp_connect+0x4ed/0x860
   __inet_stream_connect+0x80e/0xd90
   tcp_sendmsg_fastopen+0x3ce/0x710
   mptcp_sendmsg+0xff1/0x1a20
   inet_sendmsg+0x11d/0x140
   __sys_sendto+0x405/0x490
   __x64_sys_sendto+0xdc/0x1b0
   do_syscall_64+0x3b/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

We need to properly clean-up all the paired MPTCP-level
resources and be sure to release the msk last, even when
the unaccepted subflow is destroyed by the TCP internals
via inet_child_forget().

We can re-use the existing MPTCP_WORK_CLOSE_SUBFLOW infra,
explicitly checking that for the critical scenario: the
closed subflow is the MPC one, the msk is not accepted and
eventually going through full cleanup.

With such change, __mptcp_destroy_sock() is always called
on msk sockets, even on accepted ones. We don't need anymore
to transiently drop one sk reference at msk clone time.

Please note this commit depends on the parent one:

  mptcp: refactor passive socket initialization

Fixes: 58b09919626b ("mptcp: create msk early")
Cc: stable@vger.kernel.org # v6.0+
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/347
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 26 +++++++++++++++++---------
 net/mptcp/protocol.h |  3 ++-
 net/mptcp/subflow.c  | 11 +++++++++--
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 447641d34c2c..b7014f939236 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2398,9 +2398,10 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
-static void __mptcp_close_subflow(struct mptcp_sock *msk)
+static void __mptcp_close_subflow(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	might_sleep();
 
@@ -2414,7 +2415,15 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 		if (!skb_queue_empty_lockless(&ssk->sk_receive_queue))
 			continue;
 
-		mptcp_close_ssk((struct sock *)msk, ssk, subflow);
+		mptcp_close_ssk(sk, ssk, subflow);
+	}
+
+	/* if the MPC subflow has been closed before the msk is accepted,
+	 * msk will never be accept-ed, close it now
+	 */
+	if (!msk->first && msk->in_accept_queue) {
+		sock_set_flag(sk, SOCK_DEAD);
+		inet_sk_state_store(sk, TCP_CLOSE);
 	}
 }
 
@@ -2623,6 +2632,9 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(sk);
+
 	/* There is no point in keeping around an orphaned sk timedout or
 	 * closed, but we need the msk around to reply to incoming DATA_FIN,
 	 * even if it is orphaned and in FIN_WAIT2 state
@@ -2638,9 +2650,6 @@ static void mptcp_worker(struct work_struct *work)
 		}
 	}
 
-	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-		__mptcp_close_subflow(msk);
-
 	if (test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		__mptcp_retrans(sk);
 
@@ -3078,6 +3087,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
+	msk->in_accept_queue = 1;
 	WRITE_ONCE(msk->fully_established, false);
 	if (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD)
 		WRITE_ONCE(msk->csum_enabled, true);
@@ -3095,8 +3105,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	security_inet_csk_clone(nsk, req);
 	bh_unlock_sock(nsk);
 
-	/* keep a single reference */
-	__sock_put(nsk);
+	/* note: the newly allocated socket refcount is 2 now */
 	return nsk;
 }
 
@@ -3152,8 +3161,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			goto out;
 		}
 
-		/* acquire the 2nd reference for the owning socket */
-		sock_hold(new_mptcp_sock);
 		newsk = new_mptcp_sock;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 	} else {
@@ -3704,6 +3711,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		struct sock *newsk = newsock->sk;
 
 		set_bit(SOCK_CUSTOM_SOCKOPT, &newsock->flags);
+		msk->in_accept_queue = 0;
 
 		lock_sock(newsk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 61fd8eabfca2..901c9da8fe66 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -295,7 +295,8 @@ struct mptcp_sock {
 	u8		recvmsg_inq:1,
 			cork:1,
 			nodelay:1,
-			fastopening:1;
+			fastopening:1,
+			in_accept_queue:1;
 	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a631a5e6fc7b..9d5bf2a020ef 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -699,9 +699,10 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 
 static void mptcp_force_close(struct sock *sk)
 {
-	/* the msk is not yet exposed to user-space */
+	/* the msk is not yet exposed to user-space, and refcount is 2 */
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk_common_release(sk);
+	sock_put(sk);
 }
 
 static void subflow_ulp_fallback(struct sock *sk,
@@ -1866,7 +1867,6 @@ void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_s
 		struct sock *sk = (struct sock *)msk;
 		bool do_cancel_work;
 
-		sock_hold(sk);
 		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		next = msk->dl_next;
 		msk->first = NULL;
@@ -1954,6 +1954,13 @@ static void subflow_ulp_release(struct sock *ssk)
 		 * when the subflow is still unaccepted
 		 */
 		release = ctx->disposable || list_empty(&ctx->node);
+
+		/* inet_child_forget() does not call sk_state_change(),
+		 * explicitly trigger the socket close machinery
+		 */
+		if (!release && !test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW,
+						  &mptcp_sk(sk)->flags))
+			mptcp_schedule_work(sk);
 		sock_put(sk);
 	}
 

-- 
2.38.1

