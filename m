Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45015470667
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbhLJQ4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:56:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240694AbhLJQ4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639155150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FDltKr+tc0V3tb+BTPpB3I0XwCBKsqwfBPRpJqCwhM8=;
        b=RkQM6vvmkKILgi5CcKDzlX1OyjZ+PfhqFoUYvYO5PCQbmi7p0UMXY7ptyI/SuRLS463d+0
        phJQ27lYA9mcKKhrPrO4oeV8sGtALECrsiQzt2O5qRAP8//KMU+bodfH3k5F6tm28HFlqY
        Ue00mfhAPtIPsmYo72B5BJGWErTF8XE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-xw1dsxRZPLOpgUipgeOZvA-1; Fri, 10 Dec 2021 11:52:27 -0500
X-MC-Unique: xw1dsxRZPLOpgUipgeOZvA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FD0A801B0F;
        Fri, 10 Dec 2021 16:52:26 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1314160622;
        Fri, 10 Dec 2021 16:52:24 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH net] mptcp: fix NULL ptr dereference in inet_csk_accept()
Date:   Fri, 10 Dec 2021 17:51:52 +0100
Message-Id: <299865ffd73315ea549ed4a8026783633203a237.1639155048.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 740d798e8767 ("mptcp: remove id 0 address"), the PM
can remove the MPTCP first subflow in response to the netlink DEL_ADDR
command. At subflow removal time, the TCP subflow socket is orphaned.

If the relevant MPTCP socket is in listening status and such
operation races with an accept(), the kernel will access a NULL wait
queue, as reported by syzbot:

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 6550 Comm: syz-executor122 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
Code: 0f 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 69 cc 0f 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 20 75 17 8f 0f 84 52 f3 ff
RSP: 0018:ffffc90001f2f818 EFLAGS: 00010016
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
R13: ffff88801b98d700 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f177cd3d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f177cd1b268 CR3: 000000001dd55000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 finish_wait+0xc0/0x270 kernel/sched/wait.c:400
 inet_csk_wait_for_connect net/ipv4/inet_connection_sock.c:464 [inline]
 inet_csk_accept+0x7de/0x9d0 net/ipv4/inet_connection_sock.c:497
 mptcp_accept+0xe5/0x500 net/mptcp/protocol.c:2865
 inet_accept+0xe4/0x7b0 net/ipv4/af_inet.c:739
 mptcp_stream_accept+0x2e7/0x10e0 net/mptcp/protocol.c:3345
 do_accept+0x382/0x510 net/socket.c:1773
 __sys_accept4_file+0x7e/0xe0 net/socket.c:1816
 __sys_accept4+0xb0/0x100 net/socket.c:1846
 __do_sys_accept net/socket.c:1864 [inline]
 __se_sys_accept net/socket.c:1861 [inline]
 __x64_sys_accept+0x71/0xb0 net/socket.c:1861
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f177cd8b8e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f177cd3d308 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: ffffffffffffffda RBX: 00007f177ce13408 RCX: 00007f177cd8b8e9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f177ce13400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f177ce1340c
R13: 00007f177cde1004 R14: 6d705f706374706d R15: 0000000000022000
 </TASK>

Fix the issue explicitly preventing the PM from closing subflows
of MPTCP socket in listener status.

Reported-and-tested-by: syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com
Fixes: 740d798e8767 ("mptcp: remove id 0 address")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/pm_netlink.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7b96be1e9f14..afd4c6ddad0c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1275,10 +1275,16 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 		}
 
 		lock_sock(sk);
+		/* don't touch subflows for listener sockets */
+		if (sk->sk_state == TCP_LISTEN)
+			goto unlock_next;
+
 		remove_subflow = lookup_subflow_by_saddr(&msk->conn_list, addr);
 		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow);
 		if (remove_subflow)
 			mptcp_pm_remove_subflow(msk, &list);
+
+unlock_next:
 		release_sock(sk);
 
 next:
@@ -1318,10 +1324,16 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
 			goto next;
 
 		lock_sock(sk);
+		/* don't touch subflows for listener sockets */
+		if (sk->sk_state == TCP_LISTEN)
+			goto unlock_next;
+
 		spin_lock_bh(&msk->pm.lock);
 		mptcp_pm_remove_addr(msk, &list);
 		mptcp_pm_nl_rm_subflow_received(msk, &list);
 		spin_unlock_bh(&msk->pm.lock);
+
+unlock_next:
 		release_sock(sk);
 
 next:
-- 
2.33.1

