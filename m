Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35B6E4A8A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjDQOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDQOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:01:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181EE86B5
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-2f917585b26so1168981f8f.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681740048; x=1684332048;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JECxeUvbZZ9hPC67/NBq3Rp9Ecy2taTHWsGgErXwgyw=;
        b=rsFUEkJNTPdoWA3ngIXvX25jPGQXK8mZVD0ka+QLLS0ur2GOmKndxdETaxHM24MZN9
         ztxVqRUbYS9yzNb0RJQMYeJHlQoGOKGppUd6HRD7Fo2jJvDauCj6UQ1xljdZ5eVU4f15
         OsdBg1ifgxgHZQsmPUQo0nEHVAikeZTXrb1aA6ggcGa3mOYBMBi2sj9V6LXu+R6UlyEl
         X9t7qurBpI++QP7MIyt+cbQi1cqRojzi/Qi9LihC/r/UL7gruTMn59yWVdefy8rs70OK
         Nb0WH2W7x8HMYcINQhWp+9uhcL0G0mLIWwVUtaa1Vu8EQwhfnNwGIv9yxQtel981+SMX
         e7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740048; x=1684332048;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JECxeUvbZZ9hPC67/NBq3Rp9Ecy2taTHWsGgErXwgyw=;
        b=NXJspiohmSnED66AuloPf50djQaMJsYSicQheF8KEm650djDmnuvcFH3WH9irKJjMn
         hG3HCz+MPwDopZyTwIIQrQaz+7mDhezIW7Uvei7Sji+VABxW9pHF6G+G2Ms18GLtW09V
         O9qsnaRIE7SeU22QyXirziGSeuU6o5KPrQdV9kin8aQk9gOeOlbsYUIK7T3tcvl36yfJ
         umOWUQ2IbXD/NqRdTv33MbxVrmeNCCZy4PtT72KU9heEGqW+Moj+8jRQ9/k8T13KVXQA
         LU0V4c7EUPKywBYVot2QfCmwQOKYgHidLkBzMl5LJdrA+YN3Kzn++bga/YQ7SjKLI6Xl
         L6tg==
X-Gm-Message-State: AAQBX9d4SfSic3QBipMP+6acsb6HXDZa0zJctpXTNLsSl09OFiHB8KNG
        BZrLAcN++mzRu8MoVIycONAzGQ==
X-Google-Smtp-Source: AKy350bjE2lDVPFubc56b7mkm7Hd90KrUgxe2gvIc0O+YxHKRyaKY9IYHvbnEZI8/NKhOyfpe8ljKA==
X-Received: by 2002:adf:fecd:0:b0:2f4:867e:efaa with SMTP id q13-20020adffecd000000b002f4867eefaamr5822335wrs.53.1681740047595;
        Mon, 17 Apr 2023 07:00:47 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id x12-20020adff0cc000000b002d64fcb362dsm10580652wro.111.2023.04.17.07.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:00:47 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 17 Apr 2023 16:00:40 +0200
Subject: [PATCH net 1/2] mptcp: stops worker on unaccepted sockets at
 listener close
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-1-1d2ecf6d1ae4@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7659;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=fZWjtR2Z8eW4quBYJeeppwFrIvT7hTOBQxtUcq0nMOg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkPVENNG4Q+UmKrUkSHtnWHXcFCBj47LjAHBO97
 7XQz30IE2yJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZD1RDQAKCRD2t4JPQmmg
 c9VBD/9/DyBTfq3DEJkUGmiZR2VdsTFQK0NhqM2y9qFYLt9oXIN6ECo6KKEqrRXJSgSgG8hYix+
 7VIEUprSTAjC6EmLEZqbReVG9rAHzJjCp7zMa2i4lL+4qkrTg0Zr4d2Gp/KG8urb6b6FFPNCNyW
 PiCFfGmQ1Kr3odp7OBlPSc0DZDkPD4HtOqhQvYeZyF1lxUYBF2UgAJleEa8DsjPnvyrV1Il9j7p
 A24L0e3Vb3E/dkx+zG1M8IKLpIb6pXVyysaafXzy44kXk6xfDdN5MMQx1vbPIkxJADrwQBGwlWW
 M4yQVy2HQSWyllDhacoa0Wvnl7lFzBhNeuvLgWExldsWLyV52Vr9Vng4ZTdboE7Y5NNOJAq3hoN
 wq6HkmadBwUhe4yMGfmx6+UZPrITpYvQP6CBEAyGhgxlUoJPXRGyE0KuuiJb59It9YVL1O8zly1
 lq6s9m5BfMx+M8a952rDRkMyy8mq5/f2UlTllAtXb7meRcbtsjcudh0R9QIPjg95nvyPBv/WX/A
 ZcsZ9MiyUdyK4d9PRAVOz94zoKJ4mK7fFKKJ0lADCZU/r5WNGnLRkgpnRqakm9WZTPthi94//1b
 lGVZ4UWHnzEifmYw2kRPcOBGmIcKW4KjyN5PgbIBG/arpRbdqILujs0qOjkOM8rclymArCS9vGb
 gbw2dDy9pc09aNA==
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

This is a partial revert of the blamed commit, with a relevant
change: mptcp_subflow_queue_clean() now just change the msk
socket status and stop the worker, so that the UaF issue addressed
by the blamed commit is not re-introduced.

The above prevents the mptcp worker from running concurrently with
inet_csk_listen_stop(), as such race would trigger a warning, as
reported by Christoph:

RSP: 002b:00007f784fe09cd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
WARNING: CPU: 0 PID: 25807 at net/ipv4/inet_connection_sock.c:1387 inet_csk_listen_stop+0x664/0x870 net/ipv4/inet_connection_sock.c:1387
RAX: ffffffffffffffda RBX: 00000000006bc050 RCX: 00007f7850afd6a9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000004
Modules linked in:
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006bc05c
R13: fffffffffffffea8 R14: 00000000006bc050 R15: 000000000001fe40

 </TASK>
CPU: 0 PID: 25807 Comm: syz-executor.7 Not tainted 6.2.0-g778e54711659 #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:inet_csk_listen_stop+0x664/0x870 net/ipv4/inet_connection_sock.c:1387
RAX: 0000000000000000 RBX: ffff888100dfbd40 RCX: 0000000000000000
RDX: ffff8881363aab80 RSI: ffffffff81c494f4 RDI: 0000000000000005
RBP: ffff888126dad080 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888100dfe040
R13: 0000000000000001 R14: 0000000000000000 R15: ffff888100dfbdd8
FS:  00007f7850a2c800(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32d26000 CR3: 000000012fdd8006 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 __tcp_close+0x5b2/0x620 net/ipv4/tcp.c:2875
 __mptcp_close_ssk+0x145/0x3d0 net/mptcp/protocol.c:2427
 mptcp_destroy_common+0x8a/0x1c0 net/mptcp/protocol.c:3277
 mptcp_destroy+0x41/0x60 net/mptcp/protocol.c:3304
 __mptcp_destroy_sock+0x56/0x140 net/mptcp/protocol.c:2965
 __mptcp_close+0x38f/0x4a0 net/mptcp/protocol.c:3057
 mptcp_close+0x24/0xe0 net/mptcp/protocol.c:3072
 inet_release+0x53/0xa0 net/ipv4/af_inet.c:429
 __sock_release+0x4e/0xf0 net/socket.c:651
 sock_close+0x15/0x20 net/socket.c:1393
 __fput+0xff/0x420 fs/file_table.c:321
 task_work_run+0x8b/0xe0 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x113/0x120 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:296
 do_syscall_64+0x46/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f7850af70dc
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7850af70dc
RDX: 00007f7850a2c800 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 00000000006bd980 R08: 0000000000000000 R09: 00000000000018a0
R10: 00000000316338a4 R11: 0000000000000293 R12: 0000000000211e31
R13: 00000000006bc05c R14: 00007f785062c000 R15: 0000000000211af0

Fixes: 0a3f4f1f9c27 ("mptcp: fix UaF in listener shutdown")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/371
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c |  6 ++++-
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 06c5872e3b00..5181fb91595b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2365,8 +2365,12 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN)
+		if (ssk->sk_state == TCP_LISTEN) {
+			tcp_set_state(ssk, TCP_CLOSE);
+			mptcp_subflow_queue_clean(sk, ssk);
+			inet_csk_listen_stop(ssk);
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
+		}
 
 		__tcp_close(ssk, 0);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 339a6f072989..3a2db1b862dd 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -629,6 +629,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d34588850545..bf5e5c72b5ee 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1819,6 +1819,78 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
+void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
+{
+	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
+	struct mptcp_sock *msk, *next, *head = NULL;
+	struct request_sock *req;
+
+	/* build a list of all unaccepted mptcp sockets */
+	spin_lock_bh(&queue->rskq_lock);
+	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *ssk = req->sk;
+
+		if (!sk_is_mptcp(ssk))
+			continue;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		if (!subflow || !subflow->conn)
+			continue;
+
+		/* skip if already in list */
+		msk = mptcp_sk(subflow->conn);
+		if (msk->dl_next || msk == head)
+			continue;
+
+		sock_hold(subflow->conn);
+		msk->dl_next = head;
+		head = msk;
+	}
+	spin_unlock_bh(&queue->rskq_lock);
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
+
+	for (msk = head; msk; msk = next) {
+		struct sock *sk = (struct sock *)msk;
+
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+		next = msk->dl_next;
+		msk->dl_next = NULL;
+
+		/* prevent the stack from later re-schedule the worker for
+		 * this socket
+		 */
+		inet_sk_state_store(sk, TCP_CLOSE);
+		release_sock(sk);
+
+		/* lockdep will report a false positive ABBA deadlock
+		 * between cancel_work_sync and the listener socket.
+		 * The involved locks belong to different sockets WRT
+		 * the existing AB chain.
+		 * Using a per socket key is problematic as key
+		 * deregistration requires process context and must be
+		 * performed at socket disposal time, in atomic
+		 * context.
+		 * Just tell lockdep to consider the listener socket
+		 * released here.
+		 */
+		mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
+		mptcp_cancel_work(sk);
+		mutex_acquire(&listener_sk->sk_lock.dep_map, 0, 0, _RET_IP_);
+
+		sock_put(sk);
+	}
+
+	/* we are still under the listener msk socket lock */
+	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);

-- 
2.39.2

