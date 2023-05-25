Return-Path: <netdev+bounces-5371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 268CC710F35
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC5372812EF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F49171D6;
	Thu, 25 May 2023 15:11:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473B171B2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:11:30 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90B610C9
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685027460; x=1716563460;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hLZvXPWi/u1omHEer48+pN595lyCCnrPKo26S8d4NmY=;
  b=aIzTNFPQE6jzms+CM8CB8Q5caqA8cZbLRBlQBku+W4YZ0PWvT0wa27Mv
   88dUJCVl1yTyEJUWYTs491PcLJyVhakUyGRcR2j2v6/pWDgPeWDq4qwnu
   YL/+R+/ypJT/Rbny2q5lkxDM+KUdI5Prdyi8TOG82sXEE0R9SHtdE2GjI
   Y=;
X-IronPort-AV: E=Sophos;i="6.00,191,1681171200"; 
   d="scan'208";a="335674516"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 15:10:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id 77F0840DD1;
	Thu, 25 May 2023 15:10:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 May 2023 15:10:21 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.54) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 25 May 2023 15:10:19 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <pabeni@redhat.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
	<syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com>
Subject: Re: [PATCH v1 net] udplite: Fix NULL pointer dereference in __sk_mem_raise_allocated().
Date: Thu, 25 May 2023 08:10:11 -0700
Message-ID: <20230525151011.84390-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <048c84aacfe650e6602c266ff52625798fbcaa62.camel@redhat.com>
References: <048c84aacfe650e6602c266ff52625798fbcaa62.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.54]
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 25 May 2023 10:59:09 +0200
> On Tue, 2023-05-23 at 09:33 -0700, Kuniyuki Iwashima wrote:
> > syzbot reported [0] a null-ptr-deref in sk_get_rmem0() while using
> > IPPROTO_UDPLITE (0x88):
> > 
> >   14:25:52 executing program 1:
> >   r0 = socket$inet6(0xa, 0x80002, 0x88)
> > 
> > We had a similar report [1] for probably sk_memory_allocated_add()
> > in __sk_mem_raise_allocated(), and commit c915fe13cbaa ("udplite: fix
> > NULL pointer dereference") fixed it by setting .memory_allocated for
> > udplite_prot and udplitev6_prot.
> > 
> > To fix the variant, we need to set either .sysctl_wmem_offset or
> > .sysctl_rmem.
> > 
> > Now UDP and UDPLITE share the same value for .memory_allocated, so we
> > use the same .sysctl_wmem_offset for UDP and UDPLITE.
> > 
> > [0]:
> > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 0 PID: 6829 Comm: syz-executor.1 Not tainted 6.4.0-rc2-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
> > RIP: 0010:sk_get_rmem0 include/net/sock.h:2907 [inline]
> > RIP: 0010:__sk_mem_raise_allocated+0x806/0x17a0 net/core/sock.c:3006
> > Code: c1 ea 03 80 3c 02 00 0f 85 23 0f 00 00 48 8b 44 24 08 48 8b 98 38 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 03 38 d0 0f 8d 6f 0a 00 00 8b
> > RSP: 0018:ffffc90005d7f450 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90004d92000
> > RDX: 0000000000000000 RSI: ffffffff88066482 RDI: ffffffff8e2ccbb8
> > RBP: ffff8880173f7000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000030000
> > R13: 0000000000000001 R14: 0000000000000340 R15: 0000000000000001
> > FS:  0000000000000000(0000) GS:ffff8880b9800000(0063) knlGS:00000000f7f1cb40
> > CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> > CR2: 000000002e82f000 CR3: 0000000034ff0000 CR4: 00000000003506f0
> > Call Trace:
> >  <TASK>
> >  __sk_mem_schedule+0x6c/0xe0 net/core/sock.c:3077
> >  udp_rmem_schedule net/ipv4/udp.c:1539 [inline]
> >  __udp_enqueue_schedule_skb+0x776/0xb30 net/ipv4/udp.c:1581
> >  __udpv6_queue_rcv_skb net/ipv6/udp.c:666 [inline]
> >  udpv6_queue_rcv_one_skb+0xc39/0x16c0 net/ipv6/udp.c:775
> >  udpv6_queue_rcv_skb+0x194/0xa10 net/ipv6/udp.c:793
> >  __udp6_lib_mcast_deliver net/ipv6/udp.c:906 [inline]
> >  __udp6_lib_rcv+0x1bda/0x2bd0 net/ipv6/udp.c:1013
> >  ip6_protocol_deliver_rcu+0x2e7/0x1250 net/ipv6/ip6_input.c:437
> >  ip6_input_finish+0x150/0x2f0 net/ipv6/ip6_input.c:482
> >  NF_HOOK include/linux/netfilter.h:303 [inline]
> >  NF_HOOK include/linux/netfilter.h:297 [inline]
> >  ip6_input+0xa0/0xd0 net/ipv6/ip6_input.c:491
> >  ip6_mc_input+0x40b/0xf50 net/ipv6/ip6_input.c:585
> >  dst_input include/net/dst.h:468 [inline]
> >  ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
> >  NF_HOOK include/linux/netfilter.h:303 [inline]
> >  NF_HOOK include/linux/netfilter.h:297 [inline]
> >  ipv6_rcv+0x250/0x380 net/ipv6/ip6_input.c:309
> >  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5491
> >  __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5605
> >  netif_receive_skb_internal net/core/dev.c:5691 [inline]
> >  netif_receive_skb+0x133/0x7a0 net/core/dev.c:5750
> >  tun_rx_batched+0x4b3/0x7a0 drivers/net/tun.c:1553
> >  tun_get_user+0x2452/0x39c0 drivers/net/tun.c:1989
> >  tun_chr_write_iter+0xdf/0x200 drivers/net/tun.c:2035
> >  call_write_iter include/linux/fs.h:1868 [inline]
> >  new_sync_write fs/read_write.c:491 [inline]
> >  vfs_write+0x945/0xd50 fs/read_write.c:584
> >  ksys_write+0x12b/0x250 fs/read_write.c:637
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
> >  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
> >  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
> >  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> > RIP: 0023:0xf7f21579
> > Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> > RSP: 002b:00000000f7f1c590 EFLAGS: 00000282 ORIG_RAX: 0000000000000004
> > RAX: ffffffffffffffda RBX: 00000000000000c8 RCX: 0000000020000040
> > RDX: 0000000000000083 RSI: 00000000f734e000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> >  </TASK>
> > Modules linked in:
> > 
> > Link: https://lore.kernel.org/netdev/CANaxB-yCk8hhP68L4Q2nFOJht8sqgXGGQO2AftpHs0u1xyGG5A@mail.gmail.com/ [1]
> > Fixes: 850cbaddb52d ("udp: use it's own memory accounting schema")
> 
> Thanks for addressing this issue!
> 
> The patch LGTM. 
> 
> Side note: the blamed commit is almost 7y old and the oops should not
> that hard to reproduce by a real app using UDP-lite, but only syzkaller
> stumbled upon it.
> 
> The above looks like a serious hint UDP-lite is not used by anyone
> anymore ?!? Perhaps we could consider deprecating and dropping it? It
> could simplify the UDP code a bit removing a bunch of conditionals in
> fast-path, and that  nowadays would be possibly more relevant?!?

Yes, that crossed my mind too :)

Maybe we can do like this (or drop it immediately now) and see if someone
complains ?

---8<---
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 56d94d23b9e0..39b82082b68f 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -22,6 +22,7 @@ static int udplite_sk_init(struct sock *sk)
 {
 	udp_init_sock(sk);
 	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	pr_warn("IPPROTO_UDPLITE will be deprecated at the end of 2024\n");
 	return 0;
 }
 
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 3bab0cc13697..54828f08926f 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -8,6 +8,9 @@
  *  Changes:
  *  Fixes:
  */
+
+#define pr_fmt(fmt) "UDPLite6: " fmt
+
 #include <linux/export.h>
 #include <linux/proc_fs.h>
 #include "udp_impl.h"
@@ -16,6 +19,7 @@ static int udplitev6_sk_init(struct sock *sk)
 {
 	udpv6_init_sock(sk);
 	udp_sk(sk)->pcflag = UDPLITE_BIT;
+	pr_warn("IPPROTO_UDPLITE will be deprecated at the end of 2024\n");
 	return 0;
 }
 
---8<---

