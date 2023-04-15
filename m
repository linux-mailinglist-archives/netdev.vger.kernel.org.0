Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78856E3356
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 21:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjDOToW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 15:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjDOToV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 15:44:21 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04AE2127;
        Sat, 15 Apr 2023 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681587860; x=1713123860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ES0TViuyfvwlUpsYbgR0QQdAyUmlTMNsPZdKkqX8r3Y=;
  b=o2sZsTJwbtXm/wGFqWCMNS7WZUK4dOcmo7SiaOhyIJjJxm5t67aG4CI4
   EcSlOull86MpT6nZpvNQu5nHBiKwJx62oX0slueOnOMk3O6iL5aCFjZtQ
   A4a5bMxYTlIfvMGLbpVYzU2h6dUG8X/798qLf7ZbJpjMwGRUcreewnVZn
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,200,1677542400"; 
   d="scan'208";a="204759072"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2023 19:44:17 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 38C8D81342;
        Sat, 15 Apr 2023 19:44:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sat, 15 Apr 2023 19:44:13 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.26) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 15 Apr 2023 19:44:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <oswalpalash@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller-bugs@googlegroups.com>, <kuniyu@amazon.com>
Subject: Re: kernel BUG in fou_build_udp
Date:   Sat, 15 Apr 2023 12:44:01 -0700
Message-ID: <20230415194401.56577-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com>
References: <CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.26]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for reporting the issue.

From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Thu, 13 Apr 2023 20:35:52 -0700
> Hello,
> I found the following issue using syzkaller with enriched corpus on:
> HEAD commit : 0bcc4025550403ae28d2984bddacafbca0a2f112
> git tree: linux
> 
> C Reproducer : https://gist.github.com/oswalpalash/2a4bdb639c605ec80dbeec220e09603c
> Kernel .config :
> https://gist.github.com/oswalpalash/d9580b0bfce202b37445fa5fd426e41f
> syz-repro :
> r0 = socket$inet6(0xa, 0x2, 0x0)
> r1 = socket$nl_route(0x10, 0x3, 0x0)
> r2 = socket(0x10, 0x803, 0x0)
> sendmsg$nl_route(r2, &(0x7f0000000380)={0x0, 0x0,
> &(0x7f0000000340)={0x0, 0x14}}, 0x0)
> getsockname$packet(r2, &(0x7f0000000100)={0x11, 0x0, <r3=>0x0, 0x1,
> 0x0, 0x6, @broadcast}, &(0x7f00000000c0)=0x14)
> sendmsg$nl_route(r1, &(0x7f0000000080)={0x0, 0x0,
> &(0x7f0000000500)={&(0x7f0000000180)=@newlink={0x60, 0x10, 0x439, 0x0,
> 0x0, {0x0, 0x0, 0x0, 0x0, 0x9801}, [@IFLA_LINKINFO={0x40, 0x12, 0x0,
> 0x1, @sit={{0x8}, {0x34, 0x2, 0x0, 0x1, [@IFLA_IPTUN_LINK={0x8, 0x1,
> r3}, @IFLA_IPTUN_ENCAP_TYPE={0x6, 0xf, 0x2},
> @IFLA_IPTUN_ENCAP_SPORT={0x6, 0x11, 0x4e21},
> @IFLA_IPTUN_ENCAP_SPORT={0x6, 0x11, 0x4e24}, @IFLA_IPTUN_LOCAL={0x8,
> 0x2, @dev={0xac, 0x14, 0x14, 0x16}}, @IFLA_IPTUN_ENCAP_FLAGS={0x6,
> 0x10, 0xfff}]}}}]}, 0x60}}, 0x20048894)
> sendmmsg$inet(r0, &(0x7f00000017c0)=[{{&(0x7f0000000040)={0x2, 0x4e20,
> @multicast1}, 0x10, 0x0, 0x0, &(0x7f0000000000)=[@ip_pktinfo={{0x1c,
> 0x0, 0x8, {r3, @empty, @remote}}}], 0x20}}], 0x1, 0x0)
> 
> 
> Console log:
> 
> skbuff: skb_under_panic: text:ffffffff88a09da0 len:48 put:8
> head:ffff88801e4be680 data:ffff88801e4be67c tail:0x2c end:0x140
> dev:sit1
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:150!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 10068 Comm: syz-executor.3 Not tainted
> 6.3.0-rc6-pasta-00035-g0bcc40255504 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:skb_panic+0x152/0x1d0
> Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48
> c7 c7 80 b3 5b 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 ae 15 6c f9 <0f> 0b
> 4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 69 1f d8 f9 4c
> RSP: 0018:ffffc900029bead0 EFLAGS: 00010282
> RAX: 0000000000000084 RBX: ffff88801d1c3d00 RCX: ffffc9000d863000
> RDX: 0000000000000000 RSI: ffffffff816695cc RDI: 0000000000000005
> RBP: ffffffff8b5bc1e0 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000400 R11: 0000000000000000 R12: ffffffff88a09da0
> R13: 0000000000000008 R14: ffff8880306b8000 R15: 0000000000000140
> FS:  00007f1dae5ed700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564f403b7d10 CR3: 0000000117f1c000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  skb_push+0xc8/0xe0
>  fou_build_udp+0x30/0x370

It seems we need skb_cow_head() before skb_push().
I'll take a deeper look on the repro.

---8<---
diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index cafec9b4eee0..24c751f1dbc4 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -1013,10 +1013,15 @@ EXPORT_SYMBOL(__gue_build_header);
 
 #ifdef CONFIG_NET_FOU_IP_TUNNELS
 
-static void fou_build_udp(struct sk_buff *skb, struct ip_tunnel_encap *e,
-			  struct flowi4 *fl4, u8 *protocol, __be16 sport)
+static int fou_build_udp(struct sk_buff *skb, struct ip_tunnel_encap *e,
+			 struct flowi4 *fl4, u8 *protocol, __be16 sport)
 {
 	struct udphdr *uh;
+	int err;
+
+	err = skb_cow_head(skb, sizeof(*uh));
+	if (err)
+		return err;
 
 	skb_push(skb, sizeof(struct udphdr));
 	skb_reset_transport_header(skb);
@@ -1030,6 +1035,8 @@ static void fou_build_udp(struct sk_buff *skb, struct ip_tunnel_encap *e,
 		     fl4->saddr, fl4->daddr, skb->len);
 
 	*protocol = IPPROTO_UDP;
+
+	return 0;
 }
 
 static int fou_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
@@ -1044,9 +1051,7 @@ static int fou_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 	if (err)
 		return err;
 
-	fou_build_udp(skb, e, fl4, protocol, sport);
-
-	return 0;
+	return fou_build_udp(skb, e, fl4, protocol, sport);
 }
 
 static int gue_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
@@ -1061,9 +1066,7 @@ static int gue_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 	if (err)
 		return err;
 
-	fou_build_udp(skb, e, fl4, protocol, sport);
-
-	return 0;
+	return fou_build_udp(skb, e, fl4, protocol, sport);
 }
 
 static int gue_err_proto_handler(int proto, struct sk_buff *skb, u32 info)
---8<---

Thanks,
Kuniyuki


>  gue_build_header+0xfb/0x150
>  ip_tunnel_xmit+0x66e/0x3150
>  sit_tunnel_xmit__.isra.0+0xe7/0x150
>  sit_tunnel_xmit+0xf7e/0x28e0
>  dev_hard_start_xmit+0x187/0x700
>  __dev_queue_xmit+0x2ce4/0x3c40
>  neigh_connected_output+0x3c2/0x550
>  ip_finish_output2+0x78a/0x22e0
>  __ip_finish_output+0x396/0x650
>  ip_finish_output+0x31/0x280
>  ip_mc_output+0x21f/0x710
>  ip_send_skb+0xd8/0x260
>  udp_send_skb+0x73a/0x1480
>  udp_sendmsg+0x1bb2/0x2840
>  udpv6_sendmsg+0x1710/0x2c20
>  inet6_sendmsg+0x9d/0xe0
>  sock_sendmsg+0xde/0x190
>  ____sys_sendmsg+0x334/0x900
>  ___sys_sendmsg+0x110/0x1b0
>  __sys_sendmmsg+0x18f/0x460
>  __x64_sys_sendmmsg+0x9d/0x100
>  do_syscall_64+0x39/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f1dad88eacd
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1dae5ecbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f1dad9bbf80 RCX: 00007f1dad88eacd
> RDX: 0000000000000001 RSI: 00000000200017c0 RDI: 0000000000000003
> RBP: 00007f1dad8fcb05 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fff4922802f R14: 00007fff492281d0 R15: 00007f1dae5ecd80
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:skb_panic+0x152/0x1d0
> Code: 0f b6 04 01 84 c0 74 04 3c 03 7e 20 8b 4b 70 41 56 45 89 e8 48
> c7 c7 80 b3 5b 8b 41 57 56 48 89 ee 52 4c 89 e2 e8 ae 15 6c f9 <0f> 0b
> 4c 89 4c 24 10 48 89 54 24 08 48 89 34 24 e8 69 1f d8 f9 4c
> RSP: 0018:ffffc900029bead0 EFLAGS: 00010282
> RAX: 0000000000000084 RBX: ffff88801d1c3d00 RCX: ffffc9000d863000
> RDX: 0000000000000000 RSI: ffffffff816695cc RDI: 0000000000000005
> RBP: ffffffff8b5bc1e0 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000400 R11: 0000000000000000 R12: ffffffff88a09da0
> R13: 0000000000000008 R14: ffff8880306b8000 R15: 0000000000000140
> FS:  00007f1dae5ed700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000564f403b7d10 CR3: 0000000117f1c000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
