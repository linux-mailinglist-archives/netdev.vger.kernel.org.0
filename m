Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94B68E02E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBGShr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjBGShn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:37:43 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E651BD4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675795063; x=1707331063;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7RB5aM15FSgUhyfWMDWmdh9C6AG+ILU1etiBgcTIXvU=;
  b=Cw6z02fJGAW5auphpeGd/m9N8dXvay+WkSA5WgaqYJ63+O1WY1qCGbce
   yrWWqpGJ08fNCGNma4QzsSXbE6xR7fVsCTrErxjIYOT2QJwSYNFHwGHiX
   ogMDDj9rQi0GChzKuKdGXkRdJmzGIeT1QVkmc0rRtGnXVf21agjinAHtM
   8=;
X-IronPort-AV: E=Sophos;i="5.97,278,1669075200"; 
   d="scan'208";a="308523916"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 18:37:37 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id C703B81A60;
        Tue,  7 Feb 2023 18:37:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Feb 2023 18:37:34 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 7 Feb 2023 18:37:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        "Christoph Paasch" <christophpaasch@icloud.com>
Subject: [PATCH v1 net] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
Date:   Tue, 7 Feb 2023 10:37:18 -0800
Message-ID: <20230207183718.54520-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in
sk->sk_prot->destroy()."), we delay freeing some IPv6 resources
from sk->destroy() to sk->sk_destruct().

Christoph Paasch reported the commit started triggering
WARN_ON_ONCE(sk->sk_forward_alloc) in sk_stream_kill_queues()
(See [0 - 2]).

For example, if inet6_sk(sk)->rxopt is not zero by setting
IPV6_RECVPKTINFO or its friends, tcp_v6_do_rcv() clones a skb
and calls skb_set_owner_r(), which charges it to sk.  The skb
has not been uncharged in inet_csk_destroy_sock(), thus, calling
sk_stream_kill_queues() there triggers the WARN_ON_ONCE().

The same check has been in inet_sock_destruct() from at least
v2.6.  Since only CAIF is not calling inet_sock_destruct() among
the users of sk_stream_kill_queues(), we remove the WARN_ON_ONCE()
from sk_stream_kill_queues() and add it to caif_sock_destructor().

[0]: https://lore.kernel.org/netdev/39725AB4-88F1-41B3-B07F-949C5CAEFF4F@icloud.com/
[1]: https://github.com/multipath-tcp/mptcp_net-next/issues/341
[2]:
WARNING: CPU: 0 PID: 3232 at net/core/stream.c:212 sk_stream_kill_queues+0x2f9/0x3e0
Modules linked in:
CPU: 0 PID: 3232 Comm: syz-executor.0 Not tainted 6.2.0-rc5ab24eb4698afbe147b424149c529e2a43ec24eb5 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:sk_stream_kill_queues+0x2f9/0x3e0
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ec 00 00 00 8b ab 08 01 00 00 e9 60 ff ff ff e8 d0 5f b6 fe 0f 0b eb 97 e8 c7 5f b6 fe <0f> 0b eb a0 e8 be 5f b6 fe 0f 0b e9 6a fe ff ff e8 02 07 e3 fe e9
RSP: 0018:ffff88810570fc68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888101f38f40 RSI: ffffffff8285e529 RDI: 0000000000000005
RBP: 0000000000000ce0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000ce0 R11: 0000000000000001 R12: ffff8881009e9488
R13: ffffffff84af2cc0 R14: 0000000000000000 R15: ffff8881009e9458
FS:  00007f7fdfbd5800(0000) GS:ffff88811b600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32923000 CR3: 00000001062fc006 CR4: 0000000000170ef0
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x1a1/0x320
 __tcp_close+0xab6/0xe90
 tcp_close+0x30/0xc0
 inet_release+0xe9/0x1f0
 inet6_release+0x4c/0x70
 __sock_release+0xd2/0x280
 sock_close+0x15/0x20
 __fput+0x252/0xa20
 task_work_run+0x169/0x250
 exit_to_user_mode_prepare+0x113/0x120
 syscall_exit_to_user_mode+0x1d/0x40
 do_syscall_64+0x48/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f7fdf7ae28d
Code: c1 20 00 00 75 10 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00000000007dfbb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7fdf7ae28d
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000007f338e0f R09: 0000000000000e0f
R10: 000000007f338e13 R11: 0000000000000293 R12: 00007f7fdefff000
R13: 00007f7fdefffcd8 R14: 00007f7fdefffce0 R15: 00007f7fdefffcd8
 </TASK>

Fixes: b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Christoph Paasch <christophpaasch@icloud.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/caif/caif_socket.c | 1 +
 net/core/stream.c      | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 748be7253248..78c9729a6057 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1015,6 +1015,7 @@ static void caif_sock_destructor(struct sock *sk)
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON_ONCE(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
diff --git a/net/core/stream.c b/net/core/stream.c
index cd06750dd329..434446ab14c5 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	sk_mem_reclaim_final(sk);
 
 	WARN_ON_ONCE(sk->sk_wmem_queued);
-	WARN_ON_ONCE(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
-- 
2.30.2

