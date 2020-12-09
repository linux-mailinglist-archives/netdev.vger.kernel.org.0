Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC96E2D40A2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgLILFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:05:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbgLILFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V2ZS1sz+le5NJqH/xxEJc7q87F6tODN9+WCmHvs6nOI=;
        b=HonsfoAYs41OPJWj9gA93HCrVREdVR6KjgrMqfFLOMDx1xABQQ1xvtM8sbKP2yQ34/BblW
        5+ra1AEDGwgBFikazXDF8+tEZy4fOdO5Rc3/r5hzQgfUr3sFH/Cj3rGUwxylLCLTWFo0RM
        YyKR+2uvW1ZUUaWo1vfGd/JMPtJVElU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-iTLUdSrAN6S80QxhLqZbUw-1; Wed, 09 Dec 2020 06:03:44 -0500
X-MC-Unique: iTLUdSrAN6S80QxhLqZbUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1A01015C80;
        Wed,  9 Dec 2020 11:03:43 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0A1219C78;
        Wed,  9 Dec 2020 11:03:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 1/3] mptcp: link MPC subflow into msk only after accept
Date:   Wed,  9 Dec 2020 12:03:29 +0100
Message-Id: <b3850c50fffcac42c5788d82ac0445c066fcd2e5.1607508810.git.pabeni@redhat.com>
In-Reply-To: <cover.1607508810.git.pabeni@redhat.com>
References: <cover.1607508810.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph reported the following splat:

WARNING: CPU: 0 PID: 4615 at net/ipv4/inet_connection_sock.c:1031 inet_csk_listen_stop+0x8e8/0xad0 net/ipv4/inet_connection_sock.c:1031
Modules linked in:
CPU: 0 PID: 4615 Comm: syz-executor.4 Not tainted 5.9.0 #37
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:inet_csk_listen_stop+0x8e8/0xad0 net/ipv4/inet_connection_sock.c:1031
Code: 03 00 00 00 e8 79 b2 3d ff e9 ad f9 ff ff e8 1f 76 ba fe be 02 00 00 00 4c 89 f7 e8 62 b2 3d ff e9 14 f9 ff ff e8 08 76 ba fe <0f> 0b e9 97 f8 ff ff e8 fc 75 ba fe be 03 00 00 00 4c 89 f7 e8 3f
RSP: 0018:ffffc900037f7948 EFLAGS: 00010293
RAX: ffff88810a349c80 RBX: ffff888114ee1b00 RCX: ffffffff827b14cd
RDX: 0000000000000000 RSI: ffffffff827b1c38 RDI: 0000000000000005
RBP: ffff88810a2a8000 R08: ffff88810a349c80 R09: fffff520006fef1f
R10: 0000000000000003 R11: fffff520006fef1e R12: ffff888114ee2d00
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff888114ee1d68
FS:  00007f2ac1945700(0000) GS:ffff88811b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd44798bc0 CR3: 0000000109810002 CR4: 0000000000170ef0
Call Trace:
 __tcp_close+0xd86/0x1110 net/ipv4/tcp.c:2433
 __mptcp_close_ssk+0x256/0x430 net/mptcp/protocol.c:1761
 __mptcp_destroy_sock+0x49b/0x770 net/mptcp/protocol.c:2127
 mptcp_close+0x62d/0x910 net/mptcp/protocol.c:2184
 inet_release+0xe9/0x1f0 net/ipv4/af_inet.c:434
 __sock_release+0xd2/0x280 net/socket.c:596
 sock_close+0x15/0x20 net/socket.c:1277
 __fput+0x276/0x960 fs/file_table.c:281
 task_work_run+0x109/0x1d0 kernel/task_work.c:151
 get_signal+0xe8f/0x1d40 kernel/signal.c:2561
 arch_do_signal+0x88/0x1b60 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x9b/0xf0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x22/0x150 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f2ac1254469
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007f2ac1944dc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffbf RBX: 000000000069bf00 RCX: 00007f2ac1254469
RDX: 0000000000000000 RSI: 0000000000008982 RDI: 0000000000000003
RBP: 000000000069bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000069bf0c
R13: 00007ffeb53f178f R14: 00000000004668b0 R15: 0000000000000003

After commit 0397c6d85f9c ("mptcp: keep unaccepted MPC subflow into
join list"), the msk's workqueue and/or PM can touch the MPC
subflow - and acquire its socket lock - even if it's still unaccepted.

If the above event races with the relevant listener socket close, we
can end-up with the above splat.

This change addresses the issue delaying the MPC socket insertion
in conn_list at accept time - that is, partially reverting the
blamed commit.

We must additionally ensure that mptcp_pm_fully_established()
happens after accept() time, or the PM will not be able to
handle properly such event - conn_list could be empty otherwise.

In the receive path, we check the subflow list node to ensure
it is out of the listener queue. Be sure client subflows do
not match transiently such condition moving them into the join
list earlier at creation time.

Since we now have multiple mptcp_pm_fully_established() call sites
from different code-paths, said helper can now race with itself.
Use an additional PM status bit to avoid multiple notifications.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/103
Fixes: 0397c6d85f9c ("mptcp: keep unaccepted MPC subflow into join list"),
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  |  7 ++++++-
 net/mptcp/pm.c       |  8 +++++++-
 net/mptcp/protocol.c | 11 +++++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 14 ++++++++++----
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 6b7b4b67f18c..b63f26bf348f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -797,7 +797,12 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	mptcp_subflow_fully_established(subflow, mp_opt);
 
 fully_established:
-	if (likely(subflow->pm_notified))
+	/* if the subflow is not already linked into the conn_list, we can't
+	 * notify the PM: this subflow is still on the listener queue
+	 * and the PM possibly acquiring the subflow lock could race with
+	 * the listener close
+	 */
+	if (likely(subflow->pm_notified) || list_empty(&subflow->node))
 		return true;
 
 	subflow->pm_notified = 1;
diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 75c5040e8d5d..74ccc76a11cd 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -111,8 +111,14 @@ void mptcp_pm_fully_established(struct mptcp_sock *msk)
 
 	spin_lock_bh(&pm->lock);
 
-	if (READ_ONCE(pm->work_pending))
+	/* mptcp_pm_fully_established() can be invoked by multiple
+	 * racing paths - accept() and check_fully_established()
+	 * be sure to serve this event only once.
+	 */
+	if (READ_ONCE(pm->work_pending) &&
+	    !(msk->pm.status & BIT(MPTCP_PM_ALREADY_ESTABLISHED)))
 		mptcp_pm_schedule_work(msk, MPTCP_PM_ESTABLISHED);
+	msk->pm.status |= BIT(MPTCP_PM_ALREADY_ESTABLISHED);
 
 	spin_unlock_bh(&pm->lock);
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 57213ff60f78..4e29dcf17ecd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3208,6 +3208,17 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		bool slowpath;
 
 		slowpath = lock_sock_fast(newsk);
+
+		/* PM/worker can now acquire the first subflow socket
+		 * lock without racing with listener queue cleanup,
+		 * we can notify it, if needed.
+		 */
+		subflow = mptcp_subflow_ctx(msk->first);
+		list_add(&subflow->node, &msk->conn_list);
+		sock_hold(msk->first);
+		if (mptcp_is_fully_established(newsk))
+			mptcp_pm_fully_established(msk);
+
 		mptcp_copy_inaddrs(newsk, msk->first);
 		mptcp_rcv_space_init(msk, msk->first);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fc56e730fb35..4db8c905b0db 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -165,6 +165,7 @@ enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_SEND_ACK,
 	MPTCP_PM_RM_ADDR_RECEIVED,
 	MPTCP_PM_ESTABLISHED,
+	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 };
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5f5815a1665f..9b5a966b0041 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -614,8 +614,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 */
 			inet_sk_state_store((void *)new_msk, TCP_ESTABLISHED);
 
-			/* link the newly created socket to the msk */
-			mptcp_add_pending_subflow(mptcp_sk(new_msk), ctx);
+			/* record the newly created socket as the first msk
+			 * subflow, but don't link it yet into conn_list
+			 */
 			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
 
 			/* new mpc subflow takes ownership of the newly
@@ -1148,13 +1149,18 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->request_bkup = !!(loc->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	mptcp_info2sockaddr(remote, &addr);
 
+	mptcp_add_pending_subflow(msk, subflow);
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
 	if (err && err != -EINPROGRESS)
-		goto failed;
+		goto failed_unlink;
 
-	mptcp_add_pending_subflow(msk, subflow);
 	return err;
 
+failed_unlink:
+	spin_lock_bh(&msk->join_list_lock);
+	list_del(&subflow->node);
+	spin_unlock_bh(&msk->join_list_lock);
+
 failed:
 	subflow->disposable = 1;
 	sock_release(sf);
-- 
2.26.2

