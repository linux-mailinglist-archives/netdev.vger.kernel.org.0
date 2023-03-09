Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1956B27E3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjCIOxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjCIOwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:52:44 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3DAEBD84
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:50:54 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-17683b570b8so2492724fac.13
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DxqskVtJzbIDGhzu4xtaacI8mLtuQFfHH0D65SJmQ6Q=;
        b=pArBNs6h4QTYazYH+8c9+6JnBPZgnyIhg1ZSIqF04ep0j9xmjSIoSjc36Qycsn5EpL
         2ttfrlU7mmksQomKTjSLcyRClbUvjmXgHETuIazaTfi/JQDPl1JxPSYrXaWNYMkOzW4B
         eFAoSt41BqwV9Mbyz7Y+nDtpGL+lQxTOkAr8tJtMqy8NfOaBA4uKMx+An4ijxzYBDs6C
         tg4EC7scAn/SzfY/9oEVCIAwDG7Nwun39g3dJ7/zS2RUDLE6yRwKBorfyFBG9l8zvT9r
         2O/y45kQzGOX4YCUdtAPgMz2hfN9r9g/XXr1Zrub1YcsC9Ii3SBrVa1TT8tu+Omfqnsq
         uT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DxqskVtJzbIDGhzu4xtaacI8mLtuQFfHH0D65SJmQ6Q=;
        b=MoyGoUAUIUs69MRr8VcQDIsLuUqOO1eoOjBP9OIhi3WXOidvpiMn9F74E+79L1CF9W
         vbZCWovVhyK5gLbxD85pxXiJEzSnclQ1HnToVsqKcYQdqP7wHCQ3WuTcCHuhsWdbbqf1
         T2/2g3bYYviC4avdN0Ef4rFAF0dDvHLN/6j3Fdaq8MRx8nV3LjVZUlHaMClvzPeIFj2h
         l6py9q1f7H49EwRJYmEzyRUflCpUoXMoQa8jrcLBuX7PL7SqTaUdy1lM8UlM57O+LaKo
         q/pPal5BWni/xhB5kcoRCHEtAgifRxrXEBSDAxYZZ2xsWuyh3KukbMZ8mCu7sLrqcr12
         AnbQ==
X-Gm-Message-State: AO0yUKXWp2pQPObNTjHj/VP4HHOiYLdwr7LUHVbqjQ/6xcxfQVUfOCoi
        PtKua25VDLywvOXjDk9N1FdmSA==
X-Google-Smtp-Source: AK7set9IJUNm2y2ShEgf1fjwo+Dgv5UjmgWBSgKsrwzJdGz2QXRBI5g6tH5cZYXbIAXdiqK1fKiKkQ==
X-Received: by 2002:a05:6870:5703:b0:172:7220:a9eb with SMTP id k3-20020a056870570300b001727220a9ebmr12734986oap.8.1678373451935;
        Thu, 09 Mar 2023 06:50:51 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:50:51 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Mar 2023 15:50:00 +0100
Subject: [PATCH net v2 4/8] mptcp: fix UaF in listener shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-4-47c2e95eada9@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6328;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=TJIewReJ/yOGpWt8keCbB5zXjaxYZOxSV1Zl9q3p0x0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhBXsVeZCD4caj3mT+fPvYXxeBAkoAALrYI
 VKKDez3LnaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c434D/4ikPybhwE5pZT5G2x9W5cfhIZMvjQZCPWoFP/zVpZzEwfsvhO9MrQJWFYQp7MvVYoAQTb
 eaRCqSZ+A2wTz5lTrEncsw8gy9/HpkActlxZd+FDGQtzC62dOaSjfDrlorYTwRfSRlPNxTotccl
 mYqyZ4lypkVi33xZ4HjoJCEfrG9s7l6UYMB7tD8LW4Dpq2MmIxhO/YfWwTa+ZMhv8beOQLP2JdR
 wIk+4h/h6DP8amWByt6W0YwCjf9Uv5T2s1NdpQiB5oD/5KJVSeB0jWZeTi9Tx5aeuYP7YC1NrLK
 xL10fq7FUkBuYaxK/IrZCUx4Dtu02utlbIqdW9ikCiQ4PYqsyFsXqMxTEFklkg+MqqEnldZA6K0
 5JtD+pvuxHnGxmZc0R8Dw5CXS/2k1fYWcRNcIabqA5LNnq/UNJctAYX6RUTkWMEXXANT6QzSMXc
 sbGfPwtdihdqt9qkJtCC1Y2BUlxPOwpvPM9p4EF0Y3roAfCMFTmC+wm5MqzXPYqL+ls19+/UsIs
 ziaYhAG2T4VNHjUVMRQSFHZtSaD+kMuBbFI06CQxvXmkD2XA6TamC7G5D1EMcZx/mOqz7x9oxFt
 YmJRKONECgBspQvh4DkBigKPENXh76Jc1jWQre0P1rK9udR/M17ZvDDbSr3o9N8a6h8LNnKfhqn
 3bFby3ULhxVe1oQ==
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

As reported by Christoph after having refactored the passive
socket initialization, the mptcp listener shutdown path is prone
to an UaF issue.

  BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x73/0xe0
  Write of size 4 at addr ffff88810cb23098 by task syz-executor731/1266

  CPU: 1 PID: 1266 Comm: syz-executor731 Not tainted 6.2.0-rc59af4eaa31c1f6c00c8f1e448ed99a45c66340dd5 #6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6e/0x91
   print_report+0x16a/0x46f
   kasan_report+0xad/0x130
   kasan_check_range+0x14a/0x1a0
   _raw_spin_lock_bh+0x73/0xe0
   subflow_error_report+0x6d/0x110
   sk_error_report+0x3b/0x190
   tcp_disconnect+0x138c/0x1aa0
   inet_child_forget+0x6f/0x2e0
   inet_csk_listen_stop+0x209/0x1060
   __mptcp_close_ssk+0x52d/0x610
   mptcp_destroy_common+0x165/0x640
   mptcp_destroy+0x13/0x80
   __mptcp_destroy_sock+0xe7/0x270
   __mptcp_close+0x70e/0x9b0
   mptcp_close+0x2b/0x150
   inet_release+0xe9/0x1f0
   __sock_release+0xd2/0x280
   sock_close+0x15/0x20
   __fput+0x252/0xa20
   task_work_run+0x169/0x250
   exit_to_user_mode_prepare+0x113/0x120
   syscall_exit_to_user_mode+0x1d/0x40
   do_syscall_64+0x48/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

The msk grace period can legitly expire in between the last
reference count dropped in mptcp_subflow_queue_clean() and
the later eventual access in inet_csk_listen_stop()

After the previous patch we don't need anymore special-casing
msk listener socket cleanup: the mptcp worker will process each
of the unaccepted msk sockets.

Just drop the now unnecessary code.

Please note this commit depends on the two parent ones:

  mptcp: refactor passive socket initialization
  mptcp: use the workqueue to destroy unaccepted sockets

Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/346
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c |  7 ++---
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 72 ----------------------------------------------------
 3 files changed, 2 insertions(+), 78 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2a2093d61835..60b23b2716c4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2365,12 +2365,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN) {
-			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(sk, ssk);
-			inet_csk_listen_stop(ssk);
+		if (ssk->sk_state == TCP_LISTEN)
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
-		}
+
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3a2db1b862dd..339a6f072989 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -629,7 +629,6 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 932a3e0eb22d..9c57575df84c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1826,78 +1826,6 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
-{
-	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
-	struct mptcp_sock *msk, *next, *head = NULL;
-	struct request_sock *req;
-
-	/* build a list of all unaccepted mptcp sockets */
-	spin_lock_bh(&queue->rskq_lock);
-	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *ssk = req->sk;
-		struct mptcp_sock *msk;
-
-		if (!sk_is_mptcp(ssk))
-			continue;
-
-		subflow = mptcp_subflow_ctx(ssk);
-		if (!subflow || !subflow->conn)
-			continue;
-
-		/* skip if already in list */
-		msk = mptcp_sk(subflow->conn);
-		if (msk->dl_next || msk == head)
-			continue;
-
-		msk->dl_next = head;
-		head = msk;
-	}
-	spin_unlock_bh(&queue->rskq_lock);
-	if (!head)
-		return;
-
-	/* can't acquire the msk socket lock under the subflow one,
-	 * or will cause ABBA deadlock
-	 */
-	release_sock(listener_ssk);
-
-	for (msk = head; msk; msk = next) {
-		struct sock *sk = (struct sock *)msk;
-		bool do_cancel_work;
-
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-		next = msk->dl_next;
-		msk->first = NULL;
-		msk->dl_next = NULL;
-
-		do_cancel_work = __mptcp_close(sk, 0);
-		release_sock(sk);
-		if (do_cancel_work) {
-			/* lockdep will report a false positive ABBA deadlock
-			 * between cancel_work_sync and the listener socket.
-			 * The involved locks belong to different sockets WRT
-			 * the existing AB chain.
-			 * Using a per socket key is problematic as key
-			 * deregistration requires process context and must be
-			 * performed at socket disposal time, in atomic
-			 * context.
-			 * Just tell lockdep to consider the listener socket
-			 * released here.
-			 */
-			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
-			mptcp_cancel_work(sk);
-			mutex_acquire(&listener_sk->sk_lock.dep_map,
-				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
-		}
-		sock_put(sk);
-	}
-
-	/* we are still under the listener msk socket lock */
-	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
-}
-
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);

-- 
2.39.2

