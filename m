Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99B474E7B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhLNXQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:16:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:9338 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238184AbhLNXQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:16:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225961177"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="225961177"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="518491439"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Maxim Galaganov <max@internet.ru>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/4] mptcp: fix deadlock in __mptcp_push_pending()
Date:   Tue, 14 Dec 2021 15:16:03 -0800
Message-Id: <20211214231604.211016-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
References: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Galaganov <max@internet.ru>

__mptcp_push_pending() may call mptcp_flush_join_list() with subflow
socket lock held. If such call hits mptcp_sockopt_sync_all() then
subsequently __mptcp_sockopt_sync() could try to lock the subflow
socket for itself, causing a deadlock.

sysrq: Show Blocked State
task:ss-server       state:D stack:    0 pid:  938 ppid:     1 flags:0x00000000
Call Trace:
 <TASK>
 __schedule+0x2d6/0x10c0
 ? __mod_memcg_state+0x4d/0x70
 ? csum_partial+0xd/0x20
 ? _raw_spin_lock_irqsave+0x26/0x50
 schedule+0x4e/0xc0
 __lock_sock+0x69/0x90
 ? do_wait_intr_irq+0xa0/0xa0
 __lock_sock_fast+0x35/0x50
 mptcp_sockopt_sync_all+0x38/0xc0
 __mptcp_push_pending+0x105/0x200
 mptcp_sendmsg+0x466/0x490
 sock_sendmsg+0x57/0x60
 __sys_sendto+0xf0/0x160
 ? do_wait_intr_irq+0xa0/0xa0
 ? fpregs_restore_userregs+0x12/0xd0
 __x64_sys_sendto+0x20/0x30
 do_syscall_64+0x38/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9ba546c2d0
RSP: 002b:00007ffdc3b762d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f9ba56c8060 RCX: 00007f9ba546c2d0
RDX: 000000000000077a RSI: 0000000000e5e180 RDI: 0000000000000234
RBP: 0000000000cc57f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ba56c8060
R13: 0000000000b6ba60 R14: 0000000000cc7840 R15: 41d8685b1d7901b8
 </TASK>

Fix the issue by using __mptcp_flush_join_list() instead of plain
mptcp_flush_join_list() inside __mptcp_push_pending(), as suggested by
Florian. The sockopt sync will be deferred to the workqueue.

Fixes: 1b3e7ede1365 ("mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/244
Suggested-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Maxim Galaganov <max@internet.ru>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6dc1ff07994c..54613f5b7521 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1524,7 +1524,7 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			int ret = 0;
 
 			prev_ssk = ssk;
-			mptcp_flush_join_list(msk);
+			__mptcp_flush_join_list(msk);
 			ssk = mptcp_subflow_get_send(msk);
 
 			/* First check. If the ssk has changed since
-- 
2.34.1

