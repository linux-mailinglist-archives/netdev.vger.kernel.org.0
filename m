Return-Path: <netdev+bounces-5744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A44D47129EA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCEFE281894
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34B1271FA;
	Fri, 26 May 2023 15:49:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1630742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:49:08 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74961F3;
	Fri, 26 May 2023 08:49:06 -0700 (PDT)
Received: from [10.10.2.69] (unknown [10.10.2.69])
	by mail.ispras.ru (Postfix) with ESMTPSA id DA3C740D403D;
	Fri, 26 May 2023 15:49:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru DA3C740D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1685116144;
	bh=fsLtNHBtFtwFOYzTTQmMXCsNw20n0V/OiOBvSrHj84A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q1uRzQE0EXe9eFbOLVdLJxa2Qt1JP1PRcNsWRgdm26itI1dw7U4fTtPru3DdQq30Q
	 XZM9qx8wvS1XqzZ1dGIqBR7r5AUQrNXjzfQT9n+gIaXSU5eZR4kK8LBIxjWO9OnfGr
	 W27AXFq1OW2byOOrTL5KE6+SEHjmxOo0NPbm7LTY=
Message-ID: <dd9915aa-8fdb-8f37-669c-7715e44e0abd@ispras.ru>
Date: Fri, 26 May 2023 18:49:04 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
Content-Language: ru
To: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
 <CANn89i+p7_UB8Z5FQ+iWg4G_caAnUf9W4P-t+VOzigUuJo+qRw@mail.gmail.com>
From: =?UTF-8?B?0JXRhNCw0L3QvtCyINCS0LvQsNC00LjRgdC70LDQsiDQkNC70LXQutGB0LA=?=
 =?UTF-8?B?0L3QtNGA0L7QstC40Yc=?= <vefanov@ispras.ru>
In-Reply-To: <CANn89i+p7_UB8Z5FQ+iWg4G_caAnUf9W4P-t+VOzigUuJo+qRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Eric,

Here is the full report:

==================================================================
BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2018
Read of size 8 at addr ffff88814c2cc8c0 by task syz-executor.5/22717

CPU: 1 PID: 22717 Comm: syz-executor.5 Not tainted 5.10.179-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x107/0x167 lib/dump_stack.c:118
  print_address_description.constprop.0+0x1e/0x250 mm/kasan/report.c:384
  __kasan_report mm/kasan/report.c:584 [inline]
  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:601
  sk_setup_caps+0x621/0x690 net/core/sock.c:2018
  ip6_dst_store include/net/ip6_route.h:234 [inline]
  ip6_sk_dst_store_flow+0x2c9/0x7b0 net/ipv6/route.c:2852
  ip6_datagram_dst_update+0x801/0xe30 net/ipv6/datagram.c:107
  __ip6_datagram_connect+0x5f2/0x1360 net/ipv6/datagram.c:248
  ip6_datagram_connect+0x2b/0x50 net/ipv6/datagram.c:272
  inet_dgram_connect+0x150/0x2e0 net/ipv4/af_inet.c:577
  __sys_connect_file+0x15c/0x1a0 net/socket.c:1846
  __sys_connect+0x165/0x1a0 net/socket.c:1863
  __do_sys_connect net/socket.c:1873 [inline]
  __se_sys_connect net/socket.c:1870 [inline]
  __x64_sys_connect+0x6e/0xb0 net/socket.c:1870
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x61/0xc6
RIP: 0033:0x469fe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6b6e7e0c08 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 000000000056c030 RCX: 0000000000469fe9
RDX: 000000000000001c RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000056c030 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdd98ee44f R14: 00007f6b6e7e1700 R15: 0000000000000001

Allocated by task 22717:
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track mm/kasan/common.c:56 [inline]
  __kasan_kmalloc.constprop.0+0xc9/0xd0 mm/kasan/common.c:461
  slab_post_alloc_hook mm/slab.h:532 [inline]
  slab_alloc_node mm/slub.c:2896 [inline]
  slab_alloc mm/slub.c:2904 [inline]
  kmem_cache_alloc+0x146/0x2e0 mm/slub.c:2909
  dst_alloc+0xa0/0x660 net/core/dst.c:93
  ip6_blackhole_route+0x61/0x550 net/ipv6/route.c:2535
  make_blackhole net/xfrm/xfrm_policy.c:3019 [inline]
  xfrm_lookup_route net/xfrm/xfrm_policy.c:3212 [inline]
  xfrm_lookup_route+0x109/0x200 net/xfrm/xfrm_policy.c:3203
  ip6_dst_lookup_flow+0x159/0x1d0 net/ipv6/ip6_output.c:1235
  ip6_datagram_dst_update+0x5d5/0xe30 net/ipv6/datagram.c:89
  __ip6_datagram_connect+0x5f2/0x1360 net/ipv6/datagram.c:248
  ip6_datagram_connect+0x2b/0x50 net/ipv6/datagram.c:272
  inet_dgram_connect+0x150/0x2e0 net/ipv4/af_inet.c:577
  __sys_connect_file+0x15c/0x1a0 net/socket.c:1846
  __sys_connect+0x165/0x1a0 net/socket.c:1863
  __do_sys_connect net/socket.c:1873 [inline]
  __se_sys_connect net/socket.c:1870 [inline]
  __x64_sys_connect+0x6e/0xb0 net/socket.c:1870
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x61/0xc6

Freed by task 5512:
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
  __kasan_slab_free+0x112/0x170 mm/kasan/common.c:422
  slab_free_hook mm/slub.c:1542 [inline]
  slab_free_freelist_hook+0xb8/0x1b0 mm/slub.c:1576
  slab_free mm/slub.c:3149 [inline]
  kmem_cache_free+0xaa/0x2e0 mm/slub.c:3165
  dst_destroy+0x2c1/0x3c0 net/core/dst.c:129
  rcu_do_batch kernel/rcu/tree.c:2492 [inline]
  rcu_core+0x649/0x1310 kernel/rcu/tree.c:2733
  __do_softirq+0x1d4/0x8d3 kernel/softirq.c:298

Last call_rcu():
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_record_aux_stack+0xad/0xc0 mm/kasan/generic.c:346
  __call_rcu kernel/rcu/tree.c:2974 [inline]
  call_rcu+0xb6/0x950 kernel/rcu/tree.c:3048
  dst_release net/core/dst.c:179 [inline]
  dst_release+0x7e/0xe0 net/core/dst.c:169
  sk_dst_set include/net/sock.h:2024 [inline]
  sk_setup_caps+0x95/0x690 net/core/sock.c:2017
  ip6_dst_store include/net/ip6_route.h:234 [inline]
  ip6_sk_dst_store_flow+0x2c9/0x7b0 net/ipv6/route.c:2852
  ip6_sk_dst_lookup_flow+0x641/0x9a0 net/ipv6/ip6_output.c:1269
  udpv6_sendmsg+0x183f/0x2d10 net/ipv6/udp.c:1522
  inet6_sendmsg+0x105/0x140 net/ipv6/af_inet6.c:651
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0xf2/0x190 net/socket.c:671
  ____sys_sendmsg+0x32e/0x870 net/socket.c:2356
  ___sys_sendmsg+0x100/0x170 net/socket.c:2410
  __sys_sendmmsg+0x192/0x460 net/socket.c:2496
  __do_sys_sendmmsg net/socket.c:2525 [inline]
  __se_sys_sendmmsg net/socket.c:2522 [inline]
  __x64_sys_sendmmsg+0x98/0x100 net/socket.c:2522
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x61/0xc6

Second to last call_rcu():
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_record_aux_stack+0xad/0xc0 mm/kasan/generic.c:346
  __call_rcu kernel/rcu/tree.c:2974 [inline]
  call_rcu+0xb6/0x950 kernel/rcu/tree.c:3048
  dst_release net/core/dst.c:179 [inline]
  dst_release+0x7e/0xe0 net/core/dst.c:169
  rawv6_sendmsg+0xf73/0x3cf0 net/ipv6/raw.c:964
  inet_sendmsg+0x11d/0x140 net/ipv4/af_inet.c:817
  sock_sendmsg_nosec net/socket.c:651 [inline]
  sock_sendmsg+0x13c/0x190 net/socket.c:671
  ____sys_sendmsg+0x32e/0x870 net/socket.c:2356
  ___sys_sendmsg+0x100/0x170 net/socket.c:2410
  __sys_sendmmsg+0x192/0x460 net/socket.c:2496
  __do_sys_sendmmsg net/socket.c:2525 [inline]
  __se_sys_sendmmsg net/socket.c:2522 [inline]
  __x64_sys_sendmmsg+0x98/0x100 net/socket.c:2522
  do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x61/0xc6

The buggy address belongs to the object at ffff88814c2cc8c0
  which belongs to the cache ip6_dst_cache of size 232
The buggy address is located 0 bytes inside of
  232-byte region [ffff88814c2cc8c0, ffff88814c2cc9a8)
The buggy address belongs to the page:
page:000000009e9a5247 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14c2cc
head:000000009e9a5247 order:1 compound_mapcount:0
flags: 0x57ffe0000010200(slab|head)
raw: 057ffe0000010200 dead000000000100 dead000000000122 ffff888019cc8dc0
raw: 0000000000000000 0000000080190019 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88814c2cc780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88814c2cc800: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>ffff88814c2cc880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                            ^
  ffff88814c2cc900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88814c2cc980: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
==================================================================


Best regards,

Vlad.


On 26.05.2023 18:29, Eric Dumazet wrote:
> On Fri, May 26, 2023 at 5:08 PM Vladislav Efanov <VEfanov@ispras.ru> wrote:
>> Syzkaller got the following report:
>> BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2018
>> Read of size 8 at addr ffff888027f82780 by task syz-executor276/3255
> Please include a full report.
>
>> The function sk_setup_caps (called by ip6_sk_dst_store_flow->
>> ip6_dst_store) referenced already freed memory as this memory was
>> freed by parallel task in udpv6_sendmsg->ip6_sk_dst_lookup_flow->
>> sk_dst_check.
>>
>>            task1 (connect)              task2 (udp6_sendmsg)
>>          sk_setup_caps->sk_dst_set |
>>                                    |  sk_dst_check->
>>                                    |      sk_dst_set
>>                                    |      dst_release
>>          sk_setup_caps references  |
>>          to already freed dst_entry|
>
>> The reason for this race condition is: udp6_sendmsg() calls
>> ip6_sk_dst_lookup() without lock for sock structure and tries to
>> allocate/add dst_entry structure to sock structure in parallel with
>> "connect" task.
>>
>> Found by Linux Verification Center (linuxtesting.org) with syzkaller.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> This is a bogus Fixes: tag
>
> In old times, UDP sendmsg() was using the socket lock.
>
> Then, in linux-4.0 Vlad Yasevich made UDP v6 sendmsg() lockless (and
> racy in many points)
>
>
>> Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
>> ---
>>   net/ipv6/udp.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
>> index e5a337e6b970..a5ecd5d93b0a 100644
>> --- a/net/ipv6/udp.c
>> +++ b/net/ipv6/udp.c
>> @@ -1563,12 +1563,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>
>>          fl6->flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel);
>>
>> +       lock_sock(sk);
>>          dst = ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
>>          if (IS_ERR(dst)) {
>>                  err = PTR_ERR(dst);
>>                  dst = NULL;
>> +               release_sock(sk);
>>                  goto out;
>>          }
>> +       release_sock(sk);
>>
>>          if (ipc6.hlimit < 0)
>>                  ipc6.hlimit = ip6_sk_dst_hoplimit(np, fl6, dst);
>> --
>> 2.34.1
>>
> There must be another way really.
> You just killed UDP performance.

