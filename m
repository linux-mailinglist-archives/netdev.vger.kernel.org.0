Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E112E01CD
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 22:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLUVJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 16:09:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgLUVJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 16:09:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608584866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Tx18mp9v4B2r39J0YYvmVCl7t6UEuYsHm4CFtxAruBk=;
        b=hL1E/fFNc2d+n33/Bsq4lSn6PGQ66l62HqvFbfGJOQujX439/FrH20rb+C8/6QIeEY59Jf
        tCvwDXEWgPTCRrVHXHEXVnbrkYgoTZUg+GBO8Ikaq3FKRFQTE3IF0naIa/VfHIjBsCQqHM
        w5Ybw3lm0OCayV8WNHB81z5mJswDGwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-jsxpdfRFOfq-doB6P9iOgQ-1; Mon, 21 Dec 2020 16:07:42 -0500
X-MC-Unique: jsxpdfRFOfq-doB6P9iOgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3141B8015C6;
        Mon, 21 Dec 2020 21:07:41 +0000 (UTC)
Received: from new-host-6.station (unknown [10.40.193.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC32620D7;
        Mon, 21 Dec 2020 21:07:39 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>, mptcp@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH net] net: mptcp: cap forward allocation to 1M
Date:   Mon, 21 Dec 2020 22:07:25 +0100
Message-Id: <3334d00d8b2faecafdfab9aa593efcbf61442756.1608584474.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following syzkaller reproducer:

 r0 = socket$inet_mptcp(0x2, 0x1, 0x106)
 bind$inet(r0, &(0x7f0000000080)={0x2, 0x4e24, @multicast2}, 0x10)
 connect$inet(r0, &(0x7f0000000480)={0x2, 0x4e24, @local}, 0x10)
 sendto$inet(r0, &(0x7f0000000100)="f6", 0xffffffe7, 0xc000, 0x0, 0x0)

systematically triggers the following warning:

 WARNING: CPU: 2 PID: 8618 at net/core/stream.c:208 sk_stream_kill_queues+0x3fa/0x580
 Modules linked in:
 CPU: 2 PID: 8618 Comm: syz-executor Not tainted 5.10.0+ #334
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/04
 RIP: 0010:sk_stream_kill_queues+0x3fa/0x580
 Code: df 48 c1 ea 03 0f b6 04 02 84 c0 74 04 3c 03 7e 40 8b ab 20 02 00 00 e9 64 ff ff ff e8 df f0 81 2
 RSP: 0018:ffffc9000290fcb0 EFLAGS: 00010293
 RAX: ffff888011cb8000 RBX: 0000000000000000 RCX: ffffffff86eecf0e
 RDX: 0000000000000000 RSI: ffffffff86eecf6a RDI: 0000000000000005
 RBP: 0000000000000e28 R08: ffff888011cb8000 R09: fffffbfff1f48139
 R10: ffffffff8fa409c7 R11: fffffbfff1f48138 R12: ffff8880215e6220
 R13: ffffffff8fa409c0 R14: ffffc9000290fd30 R15: 1ffff92000521fa2
 FS:  00007f41c78f4800(0000) GS:ffff88802d000000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f95c803d088 CR3: 0000000025ed2000 CR4: 00000000000006f0
 Call Trace:
  __mptcp_destroy_sock+0x4f5/0x8e0
   mptcp_close+0x5e2/0x7f0
  inet_release+0x12b/0x270
  __sock_release+0xc8/0x270
  sock_close+0x18/0x20
  __fput+0x272/0x8e0
  task_work_run+0xe0/0x1a0
  exit_to_user_mode_prepare+0x1df/0x200
  syscall_exit_to_user_mode+0x19/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

userspace programs provide arbitrarily high values of 'len' in sendmsg():
this is causing integer overflow of 'amount'. Cap forward allocation to 1
megabyte: higher values are not really useful.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: e93da92896bc ("mptcp: implement wmem reservation")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 09b19aa2f205..6628d8d74203 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -877,6 +877,9 @@ static void __mptcp_wmem_reserve(struct sock *sk, int size)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	WARN_ON_ONCE(msk->wmem_reserved);
+	if (WARN_ON_ONCE(amount < 0))
+		amount = 0;
+
 	if (amount <= sk->sk_forward_alloc)
 		goto reserve;
 
@@ -1587,7 +1590,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
 
-	mptcp_lock_sock(sk, __mptcp_wmem_reserve(sk, len));
+	mptcp_lock_sock(sk, __mptcp_wmem_reserve(sk, min_t(size_t, 1 << 20, len)));
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
-- 
2.29.2

