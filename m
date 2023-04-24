Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD0F6E4A8E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjDQOB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjDQOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:01:24 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B61AA5F1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v10so7212322wmn.5
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681740049; x=1684332049;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D52vofLjnfZaTVpipN6o3AfEismD0CTamOv8IiipLHM=;
        b=cbs+C2gpws7+EdYV4iTgIHMFrcAvRvDCrk406haReBykYygJOwzsg4CYYZZ2lgLur1
         O38iHQueCy/c6ix4DFqdnHYKcREnwcjOBjpezH2QwjoOEvuNxBMe773vO/41pJpdoPvG
         tn7JTmcZyM+UvgbKlcpcT0w3vATxfxg9RqZbVQ/a0iA7dlS5Cg630t2p6LAo3Yzuyhf/
         ZT0J3YEMNCH1w/zVoOZuv0dHdhAIZScODksoRSBhmy2Z7vDsAW/mYqc1Ar9xVV/6XIO6
         xLDMKde/J0NcYUOMNzhRkD4a+Tsa9dpql7Ws9gG2/cfhx6xXOE3K9Z+sAMqfifqlqUiw
         8fWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740049; x=1684332049;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D52vofLjnfZaTVpipN6o3AfEismD0CTamOv8IiipLHM=;
        b=luxCKVepjTN5b3fjxRXaVjxwk0KTaO88qeFLKxcHih15o0zRq8c+pK1RD9+dsXDBfI
         vPyKPmZnCq6wlQ0AB+ZAvG39CZYuaavc2DiGg364s3vNiqB5tj66Zd1PZy1brKxem7Ip
         CFwRh6Wl9LZRzUsk6tHckPvqaWDB++OpdHgtBoYmnW9Vk5lrDbgs3QEwCsfij8Fsohuj
         jCkpyUaO0LtA1R2k/jO3msz/oiQtyXpiemKcqOgf5lofVV8Z0TbdHQItXAVzuBwq5EKW
         PcuQjy8Kb9Jh12rvf4zbIqUDA6XrVT06RUm/H2qaiIW35HI42U8uZbdft5X+WuyB8xyG
         MaKA==
X-Gm-Message-State: AAQBX9ej6b38NchlNF69EHfASrSa/UqwFE1qptF1QtTwNfyY8PeHc/b7
        h8V/jVaCnKDxC9ElehqK3SlwgQ==
X-Google-Smtp-Source: AKy350YnwvGOZreXTX4JbM9b1wd4PTkFGnDOE2noZLZMTzMNeXit1IQC+yDooCepU4faeGnT2+HFaQ==
X-Received: by 2002:a05:600c:20d:b0:3f0:9cc6:daf0 with SMTP id 13-20020a05600c020d00b003f09cc6daf0mr11106702wmi.27.1681740048597;
        Mon, 17 Apr 2023 07:00:48 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id x12-20020adff0cc000000b002d64fcb362dsm10580652wro.111.2023.04.17.07.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:00:48 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 17 Apr 2023 16:00:41 +0200
Subject: [PATCH net 2/2] mptcp: fix accept vs worker race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-2-1d2ecf6d1ae4@tessares.net>
References: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-0-1d2ecf6d1ae4@tessares.net>
In-Reply-To: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-0-1d2ecf6d1ae4@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=11154;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=QrFuLM4+lcB9wzHunslsI97c5O8C23TWBj0dwT25Muo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkPVENAL8bY1v67Q5Vn6bgvQXkeJPK0Bbqopi9n
 1yETsxZ9C6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZD1RDQAKCRD2t4JPQmmg
 c3zuEACtTSKwTwhStYuM8jHrKAFPBhKdW4gtW67/M9ppnsTYuKb9vY9g+u7uxuC15qH0RrZQmNe
 dSlLoHSP+T7Cd/Iabxe23KKssWG0ZGuVQUeFpQM1fmO0tji7Sp/WymDzoCWVK8sjDcEq7A8t6nc
 LZaHmFsORWUwuFPRI2txMyMCQiHkEFWWUn4OSwHG98nqoCXB3vo9rmW7UEhnyRAkqqUWEyYzXPo
 rPSxOzjt2+9ouXY1mpIXI+kZOkISa5kkElCkoxTQAERlEi412d/jVk4uDaccqQkVWZPu9djFFoi
 /qL+h6JWMHDS6mYNA9MwwlObyY9FhQujAHax7F9HbdVf4pRRNxczS2fuKQPC2zLtsxc1SyYAnFr
 FdeTSwwRNPHYOjCHCpuEbqkIDaZIws6tJ1SKEzdAQdNS96ksMb5usPsTvE3Z4F/cibwpJbXY5gg
 UVlMdVKWNKUm7utDBn6VDxBzAlZl0pMQi3Sy4o8drjjBZxnLlFosQMQFvUkYXhuFvxQQcHOR0ch
 9dfPNdGu5G1rHxGfKRyM+xokGoF2kK0wQGUO4USaU6R3ITja7cKw2Xa/1beLJuC08n0spcX1dxK
 6v5JfUCglaldVSQHDHop4m4nzZBlbXt1YpzmT2c+lI6F2JuKX3o76952IV29GNWELxB3mMmf1FE
 UXmAGUDcm3rihug==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The mptcp worker and mptcp_accept() can race, as reported by Christoph:

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 14351 at lib/refcount.c:25 refcount_warn_saturate+0x105/0x1b0 lib/refcount.c:25
Modules linked in:
CPU: 1 PID: 14351 Comm: syz-executor.2 Not tainted 6.3.0-rc1-gde5e8fd0123c #11
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:refcount_warn_saturate+0x105/0x1b0 lib/refcount.c:25
Code: 02 31 ff 89 de e8 1b f0 a7 ff 84 db 0f 85 6e ff ff ff e8 3e f5 a7 ff 48 c7 c7 d8 c7 34 83 c6 05 6d 2d 0f 02 01 e8 cb 3d 90 ff <0f> 0b e9 4f ff ff ff e8 1f f5 a7 ff 0f b6 1d 54 2d 0f 02 31 ff 89
RSP: 0018:ffffc90000a47bf8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802eae98c0 RSI: ffffffff81097d4f RDI: 0000000000000001
RBP: ffff88802e712180 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88802eaea148 R12: ffff88802e712100
R13: ffff88802e712a88 R14: ffff888005cb93a8 R15: ffff88802e712a88
FS:  0000000000000000(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f277fd89120 CR3: 0000000035486002 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:775 [inline]
 __mptcp_close+0x4c6/0x4d0 net/mptcp/protocol.c:3051
 mptcp_close+0x24/0xe0 net/mptcp/protocol.c:3072
 inet_release+0x56/0xa0 net/ipv4/af_inet.c:429
 __sock_release+0x51/0xf0 net/socket.c:653
 sock_close+0x18/0x20 net/socket.c:1395
 __fput+0x113/0x430 fs/file_table.c:321
 task_work_run+0x96/0x100 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x4fc/0x10c0 kernel/exit.c:869
 do_group_exit+0x51/0xf0 kernel/exit.c:1019
 get_signal+0x12b0/0x1390 kernel/signal.c:2859
 arch_do_signal_or_restart+0x25/0x260 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x131/0x1a0 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x40 kernel/entry/common.c:296
 do_syscall_64+0x46/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7fec4b4926a9
Code: Unable to access opcode bytes at 0x7fec4b49267f.
RSP: 002b:00007fec49f9dd78 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006bc058 RCX: 00007fec4b4926a9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006bc058
RBP: 00000000006bc050 R08: 00000000007df998 R09: 00000000007df998
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006bc05c
R13: fffffffffffffea8 R14: 000000000000000b R15: 000000000001fe40
 </TASK>

The root cause is that the worker can force fallback to TCP the first
mptcp subflow, actually deleting the unaccepted msk socket.

We can explicitly prevent the race delaying the unaccepted msk deletion
at listener shutdown time. In case the closed subflow is later accepted,
just drop the mptcp context and let the user-space deal with the
paired mptcp socket.

Fixes: b6985b9b8295 ("mptcp: use the workqueue to destroy unaccepted sockets")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/375
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 68 ++++++++++++++++++++++++++++++++++------------------
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 22 +++++++++--------
 3 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5181fb91595b..b998e9df53ce 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2315,7 +2315,26 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 			      unsigned int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	bool need_push, dispose_it;
+	bool dispose_it, need_push = false;
+
+	/* If the first subflow moved to a close state before accept, e.g. due
+	 * to an incoming reset, mptcp either:
+	 * - if either the subflow or the msk are dead, destroy the context
+	 *   (the subflow socket is deleted by inet_child_forget) and the msk
+	 * - otherwise do nothing at the moment and take action at accept and/or
+	 *   listener shutdown - user-space must be able to accept() the closed
+	 *   socket.
+	 */
+	if (msk->in_accept_queue && msk->first == ssk) {
+		if (!sock_flag(sk, SOCK_DEAD) && !sock_flag(ssk, SOCK_DEAD))
+			return;
+
+		/* ensure later check in mptcp_worker() will dispose the msk */
+		sock_set_flag(sk, SOCK_DEAD);
+		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
+		mptcp_subflow_drop_ctx(ssk);
+		goto out_release;
+	}
 
 	dispose_it = !msk->subflow || ssk != msk->subflow->sk;
 	if (dispose_it)
@@ -2351,18 +2370,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (!inet_csk(ssk)->icsk_ulp_ops) {
 		WARN_ON_ONCE(!sock_flag(ssk, SOCK_DEAD));
 		kfree_rcu(subflow, rcu);
-	} else if (msk->in_accept_queue && msk->first == ssk) {
-		/* if the first subflow moved to a close state, e.g. due to
-		 * incoming reset and we reach here before inet_child_forget()
-		 * the TCP stack could later try to close it via
-		 * inet_csk_listen_stop(), or deliver it to the user space via
-		 * accept().
-		 * We can't delete the subflow - or risk a double free - nor let
-		 * the msk survive - or will be leaked in the non accept scenario:
-		 * fallback and let TCP cope with the subflow cleanup.
-		 */
-		WARN_ON_ONCE(sock_flag(ssk, SOCK_DEAD));
-		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		if (ssk->sk_state == TCP_LISTEN) {
@@ -2377,6 +2384,8 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		/* close acquired an extra ref */
 		__sock_put(ssk);
 	}
+
+out_release:
 	release_sock(ssk);
 
 	sock_put(ssk);
@@ -2431,21 +2440,14 @@ static void __mptcp_close_subflow(struct sock *sk)
 		mptcp_close_ssk(sk, ssk, subflow);
 	}
 
-	/* if the MPC subflow has been closed before the msk is accepted,
-	 * msk will never be accept-ed, close it now
-	 */
-	if (!msk->first && msk->in_accept_queue) {
-		sock_set_flag(sk, SOCK_DEAD);
-		inet_sk_state_store(sk, TCP_CLOSE);
-	}
 }
 
-static bool mptcp_check_close_timeout(const struct sock *sk)
+static bool mptcp_should_close(const struct sock *sk)
 {
 	s32 delta = tcp_jiffies32 - inet_csk(sk)->icsk_mtup.probe_timestamp;
 	struct mptcp_subflow_context *subflow;
 
-	if (delta >= TCP_TIMEWAIT_LEN)
+	if (delta >= TCP_TIMEWAIT_LEN || mptcp_sk(sk)->in_accept_queue)
 		return true;
 
 	/* if all subflows are in closed status don't bother with additional
@@ -2653,7 +2655,7 @@ static void mptcp_worker(struct work_struct *work)
 	 * even if it is orphaned and in FIN_WAIT2 state
 	 */
 	if (sock_flag(sk, SOCK_DEAD)) {
-		if (mptcp_check_close_timeout(sk)) {
+		if (mptcp_should_close(sk)) {
 			inet_sk_state_store(sk, TCP_CLOSE);
 			mptcp_do_fastclose(sk);
 		}
@@ -2899,6 +2901,14 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sock_put(sk);
 }
 
+void __mptcp_unaccepted_force_close(struct sock *sk)
+{
+	sock_set_flag(sk, SOCK_DEAD);
+	inet_sk_state_store(sk, TCP_CLOSE);
+	mptcp_do_fastclose(sk);
+	__mptcp_destroy_sock(sk);
+}
+
 static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
 {
 	/* Concurrent splices from sk_receive_queue into receive_queue will
@@ -3737,6 +3747,18 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			if (!ssk->sk_socket)
 				mptcp_sock_graft(ssk, newsock);
 		}
+
+		/* Do late cleanup for the first subflow as necessary. Also
+		 * deal with bad peers not doing a complete shutdown.
+		 */
+		if (msk->first &&
+		    unlikely(inet_sk_state_load(msk->first) == TCP_CLOSE)) {
+			__mptcp_close_ssk(newsk, msk->first,
+					  mptcp_subflow_ctx(msk->first), 0);
+			if (unlikely(list_empty(&msk->conn_list)))
+				inet_sk_state_store(newsk, TCP_CLOSE);
+		}
+
 		release_sock(newsk);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3a2db1b862dd..d6469b6ab38e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -634,6 +634,7 @@ void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
 void mptcp_cancel_work(struct sock *sk);
+void __mptcp_unaccepted_force_close(struct sock *sk);
 void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bf5e5c72b5ee..281c1cc8dc8d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -723,9 +723,12 @@ void mptcp_subflow_drop_ctx(struct sock *ssk)
 	if (!ctx)
 		return;
 
-	subflow_ulp_fallback(ssk, ctx);
-	if (ctx->conn)
-		sock_put(ctx->conn);
+	list_del(&mptcp_subflow_ctx(ssk)->node);
+	if (inet_csk(ssk)->icsk_ulp_ops) {
+		subflow_ulp_fallback(ssk, ctx);
+		if (ctx->conn)
+			sock_put(ctx->conn);
+	}
 
 	kfree_rcu(ctx, rcu);
 }
@@ -1824,6 +1827,7 @@ void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_s
 	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
 	struct mptcp_sock *msk, *next, *head = NULL;
 	struct request_sock *req;
+	struct sock *sk;
 
 	/* build a list of all unaccepted mptcp sockets */
 	spin_lock_bh(&queue->rskq_lock);
@@ -1839,11 +1843,12 @@ void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_s
 			continue;
 
 		/* skip if already in list */
-		msk = mptcp_sk(subflow->conn);
+		sk = subflow->conn;
+		msk = mptcp_sk(sk);
 		if (msk->dl_next || msk == head)
 			continue;
 
-		sock_hold(subflow->conn);
+		sock_hold(sk);
 		msk->dl_next = head;
 		head = msk;
 	}
@@ -1857,16 +1862,13 @@ void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_s
 	release_sock(listener_ssk);
 
 	for (msk = head; msk; msk = next) {
-		struct sock *sk = (struct sock *)msk;
+		sk = (struct sock *)msk;
 
 		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 		next = msk->dl_next;
 		msk->dl_next = NULL;
 
-		/* prevent the stack from later re-schedule the worker for
-		 * this socket
-		 */
-		inet_sk_state_store(sk, TCP_CLOSE);
+		__mptcp_unaccepted_force_close(sk);
 		release_sock(sk);
 
 		/* lockdep will report a false positive ABBA deadlock

-- 
2.39.2

