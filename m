Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E565275A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiLTTwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiLTTwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:52:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656811A392
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671565954; x=1703101954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uFjJt54zA4AcZJG3xfNcULjZA/lfb3hNecw8HMpysd0=;
  b=PxZBdBj9jKQu+rATZTOQAp7XJcQYLTr7e6KF2eaQWap+cZYivU2bOOou
   rnSjhmvrD0sFVjFZAXQqnP3GoM2D0usMjSNItjaENHaFibraYFDsWsfA9
   nkjwySvuJ/pH+7vi1HSr/vX2MDiUxdQL8I+RZQAHkkFJ0hI46t+/49jDd
   LnZxyA/wOXVznrWpNAVtrHeDp0bQgoldFtZqOwdZ7+IqhRU0LgCoVoOx5
   z76SerX0UonOmFjMk+skTfXaDvZSSOfpCcrC7Y/+6lPjAE5qpVDzji8hi
   clHw1ONjQwfMVJ57+Ozyu2mMKcurBfJpZ4rBMi7CCOyQXB4GO7dBTOsjR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299376696"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299376696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681780965"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="681780965"
Received: from mdaugher-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.232.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, imagedong@tencent.com,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] mptcp: fix lockdep false positive
Date:   Tue, 20 Dec 2022 11:52:15 -0800
Message-Id: <20221220195215.238353-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221220195215.238353-1-mathew.j.martineau@linux.intel.com>
References: <20221220195215.238353-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

MattB reported a lockdep splat in the mptcp listener code cleanup:

 WARNING: possible circular locking dependency detected
 packetdrill/14278 is trying to acquire lock:
 ffff888017d868f0 ((work_completion)(&msk->work)){+.+.}-{0:0}, at: __flush_work (kernel/workqueue.c:3069)

 but task is already holding lock:
 ffff888017d84130 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close (net/mptcp/protocol.c:2973)

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (sk_lock-AF_INET){+.+.}-{0:0}:
        __lock_acquire (kernel/locking/lockdep.c:5055)
        lock_acquire (kernel/locking/lockdep.c:466)
        lock_sock_nested (net/core/sock.c:3463)
        mptcp_worker (net/mptcp/protocol.c:2614)
        process_one_work (kernel/workqueue.c:2294)
        worker_thread (include/linux/list.h:292)
        kthread (kernel/kthread.c:376)
        ret_from_fork (arch/x86/entry/entry_64.S:312)

 -> #0 ((work_completion)(&msk->work)){+.+.}-{0:0}:
        check_prev_add (kernel/locking/lockdep.c:3098)
        validate_chain (kernel/locking/lockdep.c:3217)
        __lock_acquire (kernel/locking/lockdep.c:5055)
        lock_acquire (kernel/locking/lockdep.c:466)
        __flush_work (kernel/workqueue.c:3070)
        __cancel_work_timer (kernel/workqueue.c:3160)
        mptcp_cancel_work (net/mptcp/protocol.c:2758)
        mptcp_subflow_queue_clean (net/mptcp/subflow.c:1817)
        __mptcp_close_ssk (net/mptcp/protocol.c:2363)
        mptcp_destroy_common (net/mptcp/protocol.c:3170)
        mptcp_destroy (include/net/sock.h:1495)
        __mptcp_destroy_sock (net/mptcp/protocol.c:2886)
        __mptcp_close (net/mptcp/protocol.c:2959)
        mptcp_close (net/mptcp/protocol.c:2974)
        inet_release (net/ipv4/af_inet.c:432)
        __sock_release (net/socket.c:651)
        sock_close (net/socket.c:1367)
        __fput (fs/file_table.c:320)
        task_work_run (kernel/task_work.c:181 (discriminator 1))
        exit_to_user_mode_prepare (include/linux/resume_user_mode.h:49)
        syscall_exit_to_user_mode (kernel/entry/common.c:130)
        do_syscall_64 (arch/x86/entry/common.c:87)
        entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(sk_lock-AF_INET);
                                lock((work_completion)(&msk->work));
                                lock(sk_lock-AF_INET);
   lock((work_completion)(&msk->work));

  *** DEADLOCK ***

The report is actually a false positive, since the only existing lock
nesting is the msk socket lock acquired by the mptcp work.
cancel_work_sync() is invoked without the relevant socket lock being
held, but under a different (the msk listener) socket lock.

We could silence the splat adding a per workqueue dynamic lockdep key,
but that looks overkill. Instead just tell lockdep the msk socket lock
is not held around cancel_work_sync().

--
v1 -> v2:
 - fix a few typos (MatM)

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/322
Fixes: 30e51b923e43 ("mptcp: fix unreleased socket in accept queue")
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  2 +-
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  | 19 +++++++++++++++++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 907b435e2984..b7ad030dfe89 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2357,7 +2357,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		if (ssk->sk_state == TCP_LISTEN) {
 			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(ssk);
+			mptcp_subflow_queue_clean(sk, ssk);
 			inet_csk_listen_stop(ssk);
 			mptcp_event_pm_listener(ssk, MPTCP_EVENT_LISTENER_CLOSED);
 		}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f47d3e4018b5..a0d1658ce59e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -628,7 +628,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d1d32a66ae3f..bd387d4b5a38 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1791,7 +1791,7 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_ssk)
+void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
 {
 	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
 	struct mptcp_sock *msk, *next, *head = NULL;
@@ -1840,8 +1840,23 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 
 		do_cancel_work = __mptcp_close(sk, 0);
 		release_sock(sk);
-		if (do_cancel_work)
+		if (do_cancel_work) {
+			/* lockdep will report a false positive ABBA deadlock
+			 * between cancel_work_sync and the listener socket.
+			 * The involved locks belong to different sockets WRT
+			 * the existing AB chain.
+			 * Using a per socket key is problematic as key
+			 * deregistration requires process context and must be
+			 * performed at socket disposal time, in atomic
+			 * context.
+			 * Just tell lockdep to consider the listener socket
+			 * released here.
+			 */
+			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
 			mptcp_cancel_work(sk);
+			mutex_acquire(&listener_sk->sk_lock.dep_map,
+				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
+		}
 		sock_put(sk);
 	}
 
-- 
2.39.0

