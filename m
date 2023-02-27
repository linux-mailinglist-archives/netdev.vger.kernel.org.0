Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE0C6A47F7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjB0RaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjB0RaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:30:18 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E08E206A7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:00 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r7so7055124wrz.6
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7VFmRYD7EMVth9E5zOKW4RQmSSmpk/PjXvKOxVcGjvs=;
        b=Uc7yvnl/x4ikM4FRLzPpSs6CsEU1ZmU1wkGsIpewMOjhz2ofpnNc20AeRT0iJuMwF7
         W1QxQZAQs4ZzV2Yx0vsSnJy1tncFofoh51ULcVA+pR+Topyd3n1b+3WXygPWhXE/sD5a
         3MqWwr3CrsB1E4xJa0eszQDW2384WgsZy3Csu+lHdXBkO1WELFYgdXrC5IUD8g1zGR54
         qpShOhELEyVaKapUdhG74FwpX5ZVwg3ViKEEzlxbb62edaqok5JXnz9FYIkianJ96C0U
         KdKIJQEYxg/RjFSQSrKRM8HdznbJS1Y98pY6+gSZjQUjkufE89e1IgNLe+yycafwMnPK
         bb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VFmRYD7EMVth9E5zOKW4RQmSSmpk/PjXvKOxVcGjvs=;
        b=SR6IeShG0sNuOQCA0kJ9rEZnIvzwOt/KhC2rcTJNxdjtx7WnEp7YlqdQAkB+D2I9ph
         +wi5ECaChVVflPS/RzpgOZQ4XYeNNdWBOp0J/oFr1UZrM1maBh96ayzsob6LBG3CDpfS
         xZS94VrM8UM9UehZD4s2mm+isc9yRpdfQokamoTqyRxeEOQ7ojAzOXV3CgQALRtGkwRJ
         fRZDkrTkEViNd1LLut5YN9RskkURa0opHrlIlKYdTz548sMTnWcWF/Lii1aBMNeAW43l
         MW2YNhIXVy1DRByFgFnaApkmPV22kibtC5WPmKyh0W9JBMhv3SkUrHPTbYHHxTcji26s
         W4YA==
X-Gm-Message-State: AO0yUKU8ey9nv1QY7HSotud9JEeDLREt34ystA1Pe6YVF1bXelVm2CZQ
        WkVVkJh2h6qV/9oresRJYrWWGQ==
X-Google-Smtp-Source: AK7set+qpVc8BvDfv4WWS1dTyIJUimUAFi8acYYMQcTA/cgxBnpPZ//DJZsLHgd8sWlnwnUlTZgUKg==
X-Received: by 2002:adf:e7cc:0:b0:2c5:9eaa:831 with SMTP id e12-20020adfe7cc000000b002c59eaa0831mr22545456wrn.69.1677518999737;
        Mon, 27 Feb 2023 09:29:59 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b002c70a68111asm7763689wrw.83.2023.02.27.09.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:29:59 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 27 Feb 2023 18:29:27 +0100
Subject: [PATCH net 4/7] mptcp: fix UaF in listener shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v1-4-070e30ae4a8e@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6163;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=P3ZnFzItTouH4bjDWHh+dFhxtMTdGvUTAOmm2ipU+Ao=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj/OiRtH9klLpvPTITZ839UJHIRGw61XNnHsv0M
 sUcTkZrT2KJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY/zokQAKCRD2t4JPQmmg
 cw7kEACwVNGO0U7QzVbA0TjPNo7s/gzmLNeF4c3IYY+4QvRZUpfTnxH/xNQxsE4tJatKDeexlY5
 YJoQq1cbUHEs0Kj57LbW9X93wynffXAAecZP5BtuIpdCVuS7qTZC7SvshSB0A+PZOyH+OPHVsLj
 ugw+4WcS+aPFLNIEkZy2yLc473uHOJxhYGYgfWrSgkkcb8M9LYMTNwQSD/WJGRLqvgtBHbEErXv
 LGHRsA1zM5dmjuG5BAECLw0tEI9jtM3Pdkp1uBB6TJQJzhA+hteWWJu792bp6cy+qLfLFFtSpEK
 xWWgYjPh9vBObjAsQzS5yPXx+diixBHGj77Ym25sVWmejWw1En+IYxZ9YiFGQ1Trvsr2WBSPbIT
 Vntf0BIM3E7sF54/aSygyyMIdBr7rYd3MuPiZLEa4AgfcjUAxev7bak62r67i5ee4teb1cPoniY
 uMCEvRHzHEVkfB4qPxpfbaEFAxnKeUoP/bT8FPav4OKRltcgVARkl3iAHTSQWWu7ykhvVhyj4g+
 Sj1S6KLI/69f10GDAQg9kvvt/kpFK5Br79LUxIEIdFFSGfvb8JqZ7J5AZB9t9KIoHCdVufy2foK
 DkBb6HC+mT6j9rBmb43Bwc9TcbbZxzzH5G059pezUdwmwiJkFbWQ0LW7OxWwqJ2tG+TVzI9k7RI
 znq2okMUlA6YuVQ==
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
Cc: stable@vger.kernel.org # v6.0+
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/346
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c |  1 -
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 72 ----------------------------------------------------
 3 files changed, 74 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b7014f939236..420d6616da7d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2355,7 +2355,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		if (ssk->sk_state == TCP_LISTEN) {
 			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(sk, ssk);
 			inet_csk_listen_stop(ssk);
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
 		}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 901c9da8fe66..bda5ad723d38 100644
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
index 9d5bf2a020ef..5a3b17811b6b 100644
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
2.38.1

