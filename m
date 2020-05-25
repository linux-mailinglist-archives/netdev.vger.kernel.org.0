Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B591E10AF
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390956AbgEYOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:39:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390944AbgEYOjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:39:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8y6LgzpDcy+higjH8fKzh+gq838yut+tYVPgxe7jH0s=;
        b=IakaFqX9cSK7crqKV8R6+U9W/7vJKtpzSMimL7+DH9R1x7d0aMrjlUetEIcewBQoa9+LxJ
        SPYpg9rBE56kMnfXdry85nJ3RuIDH6wBZnbrpldTnMpdGmMgLP/YhTab/1WTM+FpHj1BD7
        DrTBj+vBd8/fYDUVVTwontQU8a4Y0Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-7lzFFZ-9Mr2WFfWSwvdIkw-1; Mon, 25 May 2020 10:39:12 -0400
X-MC-Unique: 7lzFFZ-9Mr2WFfWSwvdIkw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB637107ACCD;
        Mon, 25 May 2020 14:39:10 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-122.ams2.redhat.com [10.36.114.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB6DF19930;
        Mon, 25 May 2020 14:39:08 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] mptcp: avoid NULL-ptr derefence on fallback
Date:   Mon, 25 May 2020 16:38:47 +0200
Message-Id: <d7d7f946ab9c43e96720d97e68645e38fb8b233c.1590417507.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the MPTCP receive path we must cope with TCP fallback
on blocking recvmsg(). Currently in such code path we detect
the fallback condition, but we don't fetch the struct socket
required for fallback.

The above allowed syzkaller to trigger a NULL pointer
dereference:

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 7226 Comm: syz-executor523 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sock_recvmsg_nosec net/socket.c:886 [inline]
RIP: 0010:sock_recvmsg+0x92/0x110 net/socket.c:904
Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 6c 24 04 e8 53 18 1d fb 4d 8d 6f 20 4c 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ef e8 20 12 5b fb bd a0 00 00 00 49 03 6d
RSP: 0018:ffffc90001077b98 EFLAGS: 00010202
RAX: 0000000000000004 RBX: ffffc90001077dc0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff86565e59 R09: ffffed10115afeaa
R10: ffffed10115afeaa R11: 0000000000000000 R12: 1ffff9200020efbc
R13: 0000000000000020 R14: ffffc90001077de0 R15: 0000000000000000
FS:  00007fc6a3abe700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d0050 CR3: 00000000969f0000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mptcp_recvmsg+0x18d5/0x19b0 net/mptcp/protocol.c:891
 inet_recvmsg+0xf6/0x1d0 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 __sys_recvfrom+0x2f3/0x470 net/socket.c:2057
 __do_sys_recvfrom net/socket.c:2075 [inline]
 __se_sys_recvfrom net/socket.c:2071 [inline]
 __x64_sys_recvfrom+0xda/0xf0 net/socket.c:2071
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Address the issue initializing the struct socket reference
before entering the fallback code.

Reported-and-tested-by: syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com
Suggested-by: Ondrej Mosnacek <omosnace@redhat.com>
Fixes: 8ab183deb26a ("mptcp: cope with later TCP fallback")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1f52a0fa31ed..69b66423305b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -954,7 +954,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		pr_debug("block timeout %ld", timeo);
 		mptcp_wait_data(sk, &timeo);
-		if (unlikely(__mptcp_tcp_fallback(msk)))
+		ssock = __mptcp_tcp_fallback(msk);
+		if (unlikely(ssock))
 			goto fallback;
 	}
 
-- 
2.21.3

