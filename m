Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841ED14CCD1
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgA2OzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:55:12 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42576 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbgA2OzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:55:11 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iwokI-00078a-Bv; Wed, 29 Jan 2020 15:55:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net 3/4] mptcp: avoid a lockdep splat when mcast group was joined
Date:   Wed, 29 Jan 2020 15:54:45 +0100
Message-Id: <20200129145446.26425-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129145446.26425-1-fw@strlen.de>
References: <20200129145446.26425-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot triggered following lockdep splat:

ffffffff82d2cd40 (rtnl_mutex){+.+.}, at: ip_mc_drop_socket+0x52/0x180
but task is already holding lock:
ffff8881187a2310 (sk_lock-AF_INET){+.+.}, at: mptcp_close+0x18/0x30

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #1 (sk_lock-AF_INET){+.+.}:
       lock_acquire+0xee/0x230
       lock_sock_nested+0x89/0xc0
       do_ip_setsockopt.isra.0+0x335/0x22f0
       ip_setsockopt+0x35/0x60
       tcp_setsockopt+0x5d/0x90
       __sys_setsockopt+0xf3/0x190
       __x64_sys_setsockopt+0x61/0x70
       do_syscall_64+0x72/0x300
       entry_SYSCALL_64_after_hwframe+0x49/0xbe
-> #0 (rtnl_mutex){+.+.}:
       check_prevs_add+0x2b7/0x1210
       __lock_acquire+0x10b6/0x1400
       lock_acquire+0xee/0x230
       __mutex_lock+0x120/0xc70
       ip_mc_drop_socket+0x52/0x180
       inet_release+0x36/0xe0
       __sock_release+0xfd/0x130
       __mptcp_close+0xa8/0x1f0
       inet_release+0x7f/0xe0
       __sock_release+0x69/0x130
       sock_close+0x18/0x20
       __fput+0x179/0x400
       task_work_run+0xd5/0x110
       do_exit+0x685/0x1510
       do_group_exit+0x7e/0x170
       __x64_sys_exit_group+0x28/0x30
       do_syscall_64+0x72/0x300
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

The trigger is:
  socket(AF_INET, SOCK_STREAM, 0x106 /* IPPROTO_MPTCP */) = 4
  setsockopt(4, SOL_IP, MCAST_JOIN_GROUP, {gr_interface=7, gr_group={sa_family=AF_INET, sin_port=htons(20003), sin_addr=inet_addr("224.0.0.2")}}, 136) = 0
  exit(0)

Which results in a call to rtnl_lock while we are holding
the parent mptcp socket lock via
mptcp_close -> lock_sock(msk) -> inet_release -> ip_mc_drop_socket -> rtnl_lock().

From lockdep point of view we thus have both
'rtnl_lock; lock_sock' and 'lock_sock; rtnl_lock'.

Fix this by stealing the msk conn_list and doing the subflow close
without holding the msk lock.

Fixes: cec37a6e41aae7bf ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 07ebff6396cd..73c192d8c158 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -644,17 +644,21 @@ static void __mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	LIST_HEAD(conn_list);
 
 	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+	list_splice_init(&msk->conn_list, &conn_list);
+
+	release_sock(sk);
+
+	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
-	release_sock(sk);
 	sk_common_release(sk);
 }
 
-- 
2.24.1

