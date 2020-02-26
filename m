Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E8716FD52
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBZLTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:19:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60190 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbgBZLTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 06:19:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582715975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nRHbt6Gjj3vcAWDNXSRZFzVMPUDRYlSD6m+EQdovA4g=;
        b=gZ9JEM7B5iOz1ZgeHAQVJkpPcjxJzKcEZ6ldXNCBqSbzDGkaDvychJcY0WgoWjQVfUkAiL
        PfRq1fzjXFhZ8xTo0Bn1E/Qf+gM+myLkfuPVq2geuwMSyMrWlhCvlH5FMcOrYUWB0JCmfj
        EpUcie9+dkFoipGYlydMGlY+nP6GbQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-Hat5XWfIMOKCG8kIg_Uk3Q-1; Wed, 26 Feb 2020 06:19:33 -0500
X-MC-Unique: Hat5XWfIMOKCG8kIg_Uk3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60A178017CC;
        Wed, 26 Feb 2020 11:19:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-20.ams2.redhat.com [10.36.117.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C2415C54A;
        Wed, 26 Feb 2020 11:19:29 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, paul@paul-moore.com,
        syzkaller-bugs@googlegroups.com, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] mptcp: add dummy icsk_sync_mss()
Date:   Wed, 26 Feb 2020 12:19:03 +0100
Message-Id: <3b06c9fdc9d0e00a8a6eaef4dc08eeb9322be4a0.1582715453.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot noted that the master MPTCP socket lacks the icsk_sync_mss
callback, and was able to trigger a null pointer dereference:

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 8e171067 P4D 8e171067 PUD 93fa2067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8984 Comm: syz-executor066 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc900020b7b80 EFLAGS: 00010246
RAX: 1ffff110124ba600 RBX: 0000000000000000 RCX: ffff88809fefa600
RDX: ffff8880994cdb18 RSI: 0000000000000000 RDI: ffff8880925d3140
RBP: ffffc900020b7bd8 R08: ffffffff870225be R09: fffffbfff140652a
R10: fffffbfff140652a R11: 0000000000000000 R12: ffff8880925d35d0
R13: ffff8880925d3140 R14: dffffc0000000000 R15: 1ffff110124ba6ba
FS:  0000000001a0b880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a6d6f000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cipso_v4_sock_setattr+0x34b/0x470 net/ipv4/cipso_ipv4.c:1888
 netlbl_sock_setattr+0x2a7/0x310 net/netlabel/netlabel_kapi.c:989
 smack_netlabel security/smack/smack_lsm.c:2425 [inline]
 smack_inode_setsecurity+0x3da/0x4a0 security/smack/smack_lsm.c:2716
 security_inode_setsecurity+0xb2/0x140 security/security.c:1364
 __vfs_setxattr_noperm+0x16f/0x3e0 fs/xattr.c:197
 vfs_setxattr fs/xattr.c:224 [inline]
 setxattr+0x335/0x430 fs/xattr.c:451
 __do_sys_fsetxattr fs/xattr.c:506 [inline]
 __se_sys_fsetxattr+0x130/0x1b0 fs/xattr.c:495
 __x64_sys_fsetxattr+0xbf/0xd0 fs/xattr.c:495
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440199
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcadc19e48 EFLAGS: 00000246 ORIG_RAX: 00000000000000be
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440199
RDX: 0000000020000200 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000003 R09: 00000000004002c8
R10: 0000000000000009 R11: 0000000000000246 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: 0000000000000000

Address the issue adding a dummy icsk_sync_mss callback.
To properly sync the subflows mss and options list we need some
additional infrastructure, which will land to net-next.

Reported-by: syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com
Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e9aa6807b5be..3c19a8efdcea 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -543,6 +543,11 @@ static void __mptcp_close_ssk(struct sock *sk, struc=
t sock *ssk,
 	}
 }
=20
+static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
+{
+	return 0;
+}
+
 static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk =3D mptcp_sk(sk);
@@ -551,6 +556,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
=20
 	msk->first =3D NULL;
+	inet_csk(sk)->icsk_sync_mss =3D mptcp_sync_mss;
=20
 	return 0;
 }
--=20
2.21.1

