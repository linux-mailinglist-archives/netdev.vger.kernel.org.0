Return-Path: <netdev+bounces-5845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A803713219
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3B3C2819CF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6A6394;
	Sat, 27 May 2023 03:16:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80378389
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D88C433D2;
	Sat, 27 May 2023 03:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685157369;
	bh=3TvlZajfZPaHV65YP39++ZWIaGtlXAIr6DNEKSy4BYA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JWUGd3C+zrcSth6i4xmL2ULqytidMgYLclfdTKle+iGwL08mXyblnjDJmJL4obme5
	 e745SrBGHdOxoTm3kNLgBp6LUfcIjVpHoopqJxk0+dZ+s5wcAlkvtdutdvLM9XQaHW
	 BbZUfG4RwYUhSxe1LtW3V+AWvuSwDx/IlpAgpNiEP2JAgNnqaqiYM/YDmR4r6V3hC8
	 8lxYGDH22aGvezzlX96IycgPb5w6wFHXEnpADazF1knwfFyzPz/dr2MRbmqRBgHUGw
	 K/zmTzQ5EC43KygiuDE46/r2tZuK90oZlMylWxEF6cEfLim7f5wIkgj/rmWrvqb7ga
	 uGJAfVntkuwhg==
Date: Fri, 26 May 2023 20:16:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, Netdev
 <netdev@vger.kernel.org>, linux-stable <stable@vger.kernel.org>,
 lkft-triage@lists.linaro.org, "David S. Miller" <davem@davemloft.net>, Xin
 Long <lucien.xin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Dan Carpenter
 <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: selftests: net: udpgso_bench.sh: RIP: 0010:lookup_reuseport
Message-ID: <20230526201607.54655398@kernel.org>
In-Reply-To: <CA+G9fYsbr-kTpw3fEF-XEJWv2PHRZ9kaxOrF_OzVkfpLnk3r1A@mail.gmail.com>
References: <CA+G9fYsbr-kTpw3fEF-XEJWv2PHRZ9kaxOrF_OzVkfpLnk3r1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 13:24:15 +0530 Naresh Kamboju wrote:
> While running selftests: net: udpgso_bench.sh on qemu-x86_64 the following
> kernel crash noticed on stable rc 6.3.4-rc2 kernel.

Can you repro this or it's just a one-off?

Adding some experts to CC.

> Test run log:
> =========
> 
> <12>[   38.049122] kselftest: Running tests in net
> TAP version 13
> 1..16
> # selftests: net: udpgso_bench.sh
> # ipv4
> # tcp
> # tcp tx:    230 MB/s     3905 calls/s   3905 msg/s
[...]
> # tcp tx:    191 MB/s     3254 calls/s   3254 msg/s
> # udp
> <4>[   88.821235] int3: 0000 [#1] PREEMPT SMP PTI
> <4>[   88.821491] CPU: 1 PID: 561 Comm: udpgso_bench_tx Not tainted 6.3.4-rc2 #1
> <4>[   88.821576] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.14.0-2 04/01/2014
> <4>[   88.821685] RIP: 0010:lookup_reuseport+0x4a/0x200
> <4>[   88.822122] Code: 74 0b 49 89 f6 0f b6 46 12 3c 01 75 07 31 c0
> e9 ed 00 00 00 4d 89 cf 44 89 c5 49 89 cd 49 89 fc 0f 1f 44 00 00 8b
> 5c 24 50 0f <1f> 44 00 00 41 8b 45 04 41 33 45 00 8b 0d b0 c5 ed 00 44
> 8d 04 08
> <4>[   88.822175] RSP: 0018:ffffa95c800c0b90 EFLAGS: 00000206
> <4>[   88.822215] RAX: 0000000000000007 RBX: 0000000000001f40 RCX:
> ffff966c02b66020
> <4>[   88.822228] RDX: ffff966c01a9aa00 RSI: ffff966c02801500 RDI:
> ffff966c03ae2e80
> <4>[   88.822241] RBP: 00000000000093bf R08: 00000000000093bf R09:
> ffffffffb0b2c8a0
> <4>[   88.822254] R10: 0000000042388386 R11: 00000000000093bf R12:
> ffff966c03ae2e80
> <4>[   88.822266] R13: ffff966c02b66020 R14: ffff966c02801500 R15:
> ffffffffb0b2c8a0
> <4>[   88.822312] FS:  00007f4e6ede4740(0000)
> GS:ffff966c7bd00000(0000) knlGS:0000000000000000
> <4>[   88.822330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[   88.822343] CR2: 000055a1c0b90bf0 CR3: 0000000103b0e000 CR4:
> 00000000000006e0
> <4>[   88.822438] Call Trace:
> <4>[   88.823080]  <IRQ>
> <4>[   88.823274]  udp6_lib_lookup2+0xf8/0x1c0
> <4>[   88.823368]  __udp6_lib_lookup+0x113/0x3c0
> <4>[   88.823382]  ? __wake_up_common_lock+0x79/0x190
> <4>[   88.823403]  __udp6_lib_lookup_skb+0x76/0x90
> <4>[   88.823426]  __udp6_lib_rcv+0x295/0x400
> <4>[   88.823440]  ip6_protocol_deliver_rcu+0x34e/0x5c0
> <4>[   88.823483]  ip6_input+0x60/0x110
> <4>[   88.823496]  ? ip6_rcv_core+0x311/0x450
> <4>[   88.823509]  ipv6_rcv+0x47/0xf0
> <4>[   88.823523]  __netif_receive_skb+0x65/0x170
> <4>[   88.823539]  process_backlog+0xd7/0x180
> <4>[   88.823553]  __napi_poll+0x2c/0x1b0
> <4>[   88.823565]  net_rx_action+0x178/0x2e0
> <4>[   88.823580]  __do_softirq+0xc4/0x274
> <4>[   88.823595]  do_softirq+0x7e/0xb0
> <4>[   88.823751]  </IRQ>
> <4>[   88.823769]  <TASK>
> <4>[   88.823773]  __local_bh_enable_ip+0x6e/0x70
> <4>[   88.823786]  ip6_finish_output2+0x3fc/0x560
> <4>[   88.823803]  ip6_finish_output+0x1ab/0x320
> <4>[   88.823816]  ip6_output+0x6b/0x130
> <4>[   88.823827]  ? __pfx_ip6_finish_output+0x10/0x10
> <4>[   88.823839]  ip6_send_skb+0x1e/0x80
> <4>[   88.823850]  udp_v6_send_skb+0x26e/0x400
> <4>[   88.823865]  udpv6_sendmsg+0xb33/0xc60
> <4>[   88.823879]  ? __pfx_ip_generic_getfrag+0x10/0x10
> <4>[   88.823902]  sock_sendmsg+0x42/0xa0
> <4>[   88.823915]  __sys_sendto+0x281/0x2f0
> <4>[   88.823938]  __x64_sys_sendto+0x21/0x30
> <4>[   88.823949]  do_syscall_64+0x48/0xa0
> <4>[   88.823969]  ? exit_to_user_mode_prepare+0x2a/0x80
> <4>[   88.823981]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> <4>[   88.824104] RIP: 0033:0x7f4e6eef1973
> <4>[   88.824267] Code: 8b 15 91 74 0c 00 f7 d8 64 89 02 48 c7 c0 ff
> ff ff ff eb b8 0f 1f 00 80 3d 71 fc 0c 00 00 41 89 ca 74 14 b8 2c 00
> 00 00 0f 05 <48> 3d 00 f0 ff ff 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44
> 89 4c 24
> <4>[   88.824276] RSP: 002b:00007ffc3a3d79f8 EFLAGS: 00000202
> ORIG_RAX: 000000000000002c
> <4>[   88.824293] RAX: ffffffffffffffda RBX: 00005596927cf110 RCX:
> 00007f4e6eef1973
> <4>[   88.824298] RDX: 00000000000005ac RSI: 00005596927cf110 RDI:
> 0000000000000005
> <4>[   88.824304] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000000
> <4>[   88.824309] R10: 0000000000000000 R11: 0000000000000202 R12:
> 0000000000000002
> <4>[   88.824313] R13: 0000000000000005 R14: 000000000000e628 R15:
> 00000000000005ac
> <4>[   88.824335]  </TASK>
> <4>[   88.824377] Modules linked in: mptcp_diag tcp_diag inet_diag
> ip_tables x_tables
> <4>[   88.845108] ---[ end trace 0000000000000000 ]---
> <4>[   88.845178] RIP: 0010:lookup_reuseport+0x4a/0x200
> <4>[   88.845216] Code: 74 0b 49 89 f6 0f b6 46 12 3c 01 75 07 31 c0
> e9 ed 00 00 00 4d 89 cf 44 89 c5 49 89 cd 49 89 fc 0f 1f 44 00 00 8b
> 5c 24 50 0f <1f> 44 00 00 41 8b 45 04 41 33 45 00 8b 0d b0 c5 ed 00 44
> 8d 04 08
> <4>[   88.845232] RSP: 0018:ffffa95c800c0b90 EFLAGS: 00000206
> <4>[   88.845249] RAX: 0000000000000007 RBX: 0000000000001f40 RCX:
> ffff966c02b66020
> <4>[   88.845257] RDX: ffff966c01a9aa00 RSI: ffff966c02801500 RDI:
> ffff966c03ae2e80
> <4>[   88.845266] RBP: 00000000000093bf R08: 00000000000093bf R09:
> ffffffffb0b2c8a0
> <4>[   88.845273] R10: 0000000042388386 R11: 00000000000093bf R12:
> ffff966c03ae2e80
> <4>[   88.845281] R13: ffff966c02b66020 R14: ffff966c02801500 R15:
> ffffffffb0b2c8a0
> <4>[   88.845290] FS:  00007f4e6ede4740(0000)
> GS:ffff966c7bd00000(0000) knlGS:0000000000000000
> <4>[   88.845302] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[   88.845311] CR2: 000055a1c0b90bf0 CR3: 0000000103b0e000 CR4:
> 00000000000006e0
> <0>[   88.845862] Kernel panic - not syncing: Fatal exception in interrupt
> <0>[   88.848258] Kernel Offset: 0x2e800000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)



