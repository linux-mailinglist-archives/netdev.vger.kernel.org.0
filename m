Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB24D20DE98
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389120AbgF2U1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57622 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389113AbgF2U1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHdcTU88OBHqxaq6FPhno3ONFEavy+uwI066ETqm9AQ=;
        b=JILnGdUHkk5cikIJDDud3wpYu7rn0/g+5BMljV60QOzqyGBP4xWf+6ef5aXNKKGP0g1RWp
        kiwDske/LhtPVO/B1fPUCaTH9xzCt6NAmxv+bhR+n3nCo9Qp5ojKv9fij16aWKhrgP08t9
        SFOSh7EhnvjV6f+kXpWQcjYsAX1e1rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-iAvh-b52MFWzV372mIXB6Q-1; Mon, 29 Jun 2020 16:26:50 -0400
X-MC-Unique: iAvh-b52MFWzV372mIXB6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F87E1932481;
        Mon, 29 Jun 2020 20:26:48 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 019A91C4;
        Mon, 29 Jun 2020 20:26:46 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 2/6] mptcp: fallback in case of simultaneous connect
Date:   Mon, 29 Jun 2020 22:26:21 +0200
Message-Id: <e64ab0baf0f68bc4499201fe5ea7a33d92ee7c08.1593461586.git.dcaratti@redhat.com>
In-Reply-To: <cover.1593461586.git.dcaratti@redhat.com>
References: <cover.1593461586.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when a MPTCP client tries to connect to itself, tcp_finish_connect() is
never reached. Because of this, depending on the socket current state,
multiple faulty behaviours can be observed:

1) a WARN_ON() in subflow_data_ready() is hit
 WARNING: CPU: 2 PID: 882 at net/mptcp/subflow.c:911 subflow_data_ready+0x18b/0x230
 [...]
 CPU: 2 PID: 882 Comm: gh35 Not tainted 5.7.0+ #187
 [...]
 RIP: 0010:subflow_data_ready+0x18b/0x230
 [...]
 Call Trace:
  tcp_data_queue+0xd2f/0x4250
  tcp_rcv_state_process+0xb1c/0x49d3
  tcp_v4_do_rcv+0x2bc/0x790
  __release_sock+0x153/0x2d0
  release_sock+0x4f/0x170
  mptcp_shutdown+0x167/0x4e0
  __sys_shutdown+0xe6/0x180
  __x64_sys_shutdown+0x50/0x70
  do_syscall_64+0x9a/0x370
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

2) client is stuck forever in mptcp_sendmsg() because the socket is not
   TCP_ESTABLISHED

 crash> bt 4847
 PID: 4847   TASK: ffff88814b2fb100  CPU: 1   COMMAND: "gh35"
  #0 [ffff8881376ff680] __schedule at ffffffff97248da4
  #1 [ffff8881376ff778] schedule at ffffffff9724a34f
  #2 [ffff8881376ff7a0] schedule_timeout at ffffffff97252ba0
  #3 [ffff8881376ff8a8] wait_woken at ffffffff958ab4ba
  #4 [ffff8881376ff940] sk_stream_wait_connect at ffffffff96c2d859
  #5 [ffff8881376ffa28] mptcp_sendmsg at ffffffff97207fca
  #6 [ffff8881376ffbc0] sock_sendmsg at ffffffff96be1b5b
  #7 [ffff8881376ffbe8] sock_write_iter at ffffffff96be1daa
  #8 [ffff8881376ffce8] new_sync_write at ffffffff95e5cb52
  #9 [ffff8881376ffe50] vfs_write at ffffffff95e6547f
 #10 [ffff8881376ffe90] ksys_write at ffffffff95e65d26
 #11 [ffff8881376fff28] do_syscall_64 at ffffffff956088ba
 #12 [ffff8881376fff50] entry_SYSCALL_64_after_hwframe at ffffffff9740008c
     RIP: 00007f126f6956ed  RSP: 00007ffc2a320278  RFLAGS: 00000217
     RAX: ffffffffffffffda  RBX: 0000000020000044  RCX: 00007f126f6956ed
     RDX: 0000000000000004  RSI: 00000000004007b8  RDI: 0000000000000003
     RBP: 00007ffc2a3202a0   R8: 0000000000400720   R9: 0000000000400720
     R10: 0000000000400720  R11: 0000000000000217  R12: 00000000004004b0
     R13: 00007ffc2a320380  R14: 0000000000000000  R15: 0000000000000000
     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

3) tcpdump captures show that DSS is exchanged even when MP_CAPABLE handshake
   didn't complete.

 $ tcpdump -tnnr bad.pcap
 IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [S], seq 3208913911, win 65483, options [mss 65495,sackOK,TS val 3291706876 ecr 3291694721,nop,wscale 7,mptcp capable v1], length 0
 IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [S.], seq 3208913911, ack 3208913912, win 65483, options [mss 65495,sackOK,TS val 3291706876 ecr 3291706876,nop,wscale 7,mptcp capable v1], length 0
 IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [.], ack 1, win 512, options [nop,nop,TS val 3291706876 ecr 3291706876], length 0
 IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [F.], seq 1, ack 1, win 512, options [nop,nop,TS val 3291707876 ecr 3291706876,mptcp dss fin seq 0 subseq 0 len 1,nop,nop], length 0
 IP 127.0.0.1.20000 > 127.0.0.1.20000: Flags [.], ack 2, win 512, options [nop,nop,TS val 3291707876 ecr 3291707876], length 0

force a fallback to TCP in these cases, and adjust the main socket
state to avoid hanging in mptcp_sendmsg().

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/35
Reported-by: Christoph Paasch <cpaasch@apple.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.h | 10 ++++++++++
 net/mptcp/subflow.c  | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a709df659ae0..1d05d9841b5c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -490,4 +490,14 @@ static inline void mptcp_do_fallback(struct sock *sk)
 
 #define pr_fallback(a) pr_debug("%s:fallback to TCP (msk=%p)", __func__, a)
 
+static inline bool subflow_simultaneous_connect(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *parent = subflow->conn;
+
+	return sk->sk_state == TCP_ESTABLISHED &&
+	       !mptcp_sk(parent)->pm.server_side &&
+	       !subflow->conn_finished;
+}
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index cb8a42ff4646..548f9e347ff5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1128,6 +1128,16 @@ static void subflow_state_change(struct sock *sk)
 
 	__subflow_state_change(sk);
 
+	if (subflow_simultaneous_connect(sk)) {
+		mptcp_do_fallback(sk);
+		pr_fallback(mptcp_sk(parent));
+		subflow->conn_finished = 1;
+		if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
+			inet_sk_state_store(parent, TCP_ESTABLISHED);
+			parent->sk_state_change(parent);
+		}
+	}
+
 	/* as recvmsg() does not acquire the subflow socket for ssk selection
 	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
 	 * the data available machinery here.
-- 
2.26.2

