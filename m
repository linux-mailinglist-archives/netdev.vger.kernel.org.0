Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0470265275B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiLTTwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbiLTTwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:52:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559411A3BE
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671565953; x=1703101953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PcMXCtBoJtXT7wfJ6r6A2Au6F+ur7TgEqO8J5bGQY40=;
  b=idLoad2WcqlAqu4E4TKN0i+FKwq1X61apSaqCZ4APlmmVhd6YcEPfX6c
   OdfDYmMIFUBsoJtGz7Hhap3scoGbwDDsCGf1bXxhglje9UUPbUpjtqbZ/
   dLmZdtSFSAkPMBvCxg/vdTSQmB759E6GYpqh6Ff88SWAqtR9YGNBbgbdU
   vKlEZW8LKFZnj1mMu3EiqS4bHHVHKGwxf9l5wucWhpjSRL1gwSYHvk+jo
   8mQY3Cx1nud9TsUmG4lnIetVsTU6EqzJvB0twc0r4EO8VTMEOuIJeMFyq
   DGdyuok8V2U56NI+AFt9yIsqyARpWQaox6r60VF9Yx2QAjXMqVxrYkIZW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299376688"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299376688"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681780964"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="681780964"
Received: from mdaugher-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.232.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 11:52:21 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, imagedong@tencent.com,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: fix deadlock in fastopen error path
Date:   Tue, 20 Dec 2022 11:52:14 -0800
Message-Id: <20221220195215.238353-2-mathew.j.martineau@linux.intel.com>
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

MatM reported a deadlock at fastopening time:

INFO: task syz-executor.0:11454 blocked for more than 143 seconds.
      Tainted: G S                 6.1.0-rc5-03226-gdb0157db5153 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:25104 pid:11454 ppid:424    flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x5c2/0x1550 kernel/sched/core.c:6503
 schedule+0xe8/0x1c0 kernel/sched/core.c:6579
 __lock_sock+0x142/0x260 net/core/sock.c:2896
 lock_sock_nested+0xdb/0x100 net/core/sock.c:3466
 __mptcp_close_ssk+0x1a3/0x790 net/mptcp/protocol.c:2328
 mptcp_destroy_common+0x16a/0x650 net/mptcp/protocol.c:3171
 mptcp_disconnect+0xb8/0x450 net/mptcp/protocol.c:3019
 __inet_stream_connect+0x897/0xa40 net/ipv4/af_inet.c:720
 tcp_sendmsg_fastopen+0x3dd/0x740 net/ipv4/tcp.c:1200
 mptcp_sendmsg_fastopen net/mptcp/protocol.c:1682 [inline]
 mptcp_sendmsg+0x128a/0x1a50 net/mptcp/protocol.c:1721
 inet6_sendmsg+0x11f/0x150 net/ipv6/af_inet6.c:663
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xf7/0x190 net/socket.c:734
 ____sys_sendmsg+0x336/0x970 net/socket.c:2476
 ___sys_sendmsg+0x122/0x1c0 net/socket.c:2530
 __sys_sendmmsg+0x18d/0x460 net/socket.c:2616
 __do_sys_sendmmsg net/socket.c:2645 [inline]
 __se_sys_sendmmsg net/socket.c:2642 [inline]
 __x64_sys_sendmmsg+0x9d/0x110 net/socket.c:2642
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5920a75e7d
RSP: 002b:00007f59201e8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f5920bb4f80 RCX: 00007f5920a75e7d
RDX: 0000000000000001 RSI: 0000000020002940 RDI: 0000000000000005
RBP: 00007f5920ae7593 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020004050 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f5920bb4f80 R15: 00007f59201c8000
 </TASK>

In the error path, tcp_sendmsg_fastopen() ends-up calling
mptcp_disconnect(), and the latter tries to close each
subflow, acquiring the socket lock on each of them.

At fastopen time, we have a single subflow, and such subflow
socket lock is already held by the called, causing the deadlock.

We already track the 'fastopen in progress' status inside the msk
socket. Use it to address the issue, making mptcp_disconnect() a
no op when invoked from the fastopen (error) path and doing the
relevant cleanup after releasing the subflow socket lock.

While at the above, rename the fastopen status bit to something
more meaningful.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/321
Fixes: fa9e57468aa1 ("mptcp: fix abba deadlock on fastopen")
Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 18 +++++++++++++++---
 net/mptcp/protocol.h |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f6f93957275b..907b435e2984 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1662,6 +1662,8 @@ static void mptcp_set_nospace(struct sock *sk)
 	set_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags);
 }
 
+static int mptcp_disconnect(struct sock *sk, int flags);
+
 static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msghdr *msg,
 				  size_t len, int *copied_syn)
 {
@@ -1672,9 +1674,9 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 	lock_sock(ssk);
 	msg->msg_flags |= MSG_DONTWAIT;
 	msk->connect_flags = O_NONBLOCK;
-	msk->is_sendmsg = 1;
+	msk->fastopening = 1;
 	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, len, NULL);
-	msk->is_sendmsg = 0;
+	msk->fastopening = 0;
 	msg->msg_flags = saved_flags;
 	release_sock(ssk);
 
@@ -1688,6 +1690,8 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct sock *ssk, struct msgh
 		 */
 		if (ret && ret != -EINPROGRESS && ret != -ERESTARTSYS && ret != -EINTR)
 			*copied_syn = 0;
+	} else if (ret && ret != -EINPROGRESS) {
+		mptcp_disconnect(sk, 0);
 	}
 
 	return ret;
@@ -2989,6 +2993,14 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	/* We are on the fastopen error path. We can't call straight into the
+	 * subflows cleanup code due to lock nesting (we are already under
+	 * msk->firstsocket lock). Do nothing and leave the cleanup to the
+	 * caller.
+	 */
+	if (msk->fastopening)
+		return 0;
+
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	mptcp_stop_timer(sk);
@@ -3532,7 +3544,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	/* if reaching here via the fastopen/sendmsg path, the caller already
 	 * acquired the subflow socket lock, too.
 	 */
-	if (msk->is_sendmsg)
+	if (msk->fastopening)
 		err = __inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags, 1);
 	else
 		err = inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 955fb3d88eb3..f47d3e4018b5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -295,7 +295,7 @@ struct mptcp_sock {
 	u8		recvmsg_inq:1,
 			cork:1,
 			nodelay:1,
-			is_sendmsg:1;
+			fastopening:1;
 	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
-- 
2.39.0

