Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8517D29D802
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbgJ1W2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39294 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387434AbgJ1W2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:28:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 52DDA205DD;
        Wed, 28 Oct 2020 11:43:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 15e7rofYhZ7s; Wed, 28 Oct 2020 11:43:03 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4DF6C205DB;
        Wed, 28 Oct 2020 11:43:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 28 Oct 2020 11:43:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 28 Oct
 2020 11:43:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 74103318136E;
 Wed, 28 Oct 2020 11:43:02 +0100 (CET)
Date:   Wed, 28 Oct 2020 11:43:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hillf Danton <hdanton@sina.com>, Dmitry Safonov <dima@arista.com>
CC:     syzbot <syzbot+c43831072e7df506a646@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: slab-out-of-bounds Write in xfrm_attr_cpy32
Message-ID: <20201028104302.GA8805@gauss3.secunet.de>
References: <000000000000f1a42205b2528067@google.com>
 <20201028090022.2757-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201028090022.2757-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dimitry, you added this code, can you please look into
that?

Thanks!

On Wed, Oct 28, 2020 at 05:00:22PM +0800, Hillf Danton wrote:
> On Fri, 23 Oct 2020 01:38:23 -0700
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    c4d6fe73 Merge tag 'xarray-5.9' of git://git.infradead.org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1117ff78500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5e8379456358b93c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c43831072e7df506a646
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > userspace arch: i386
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com
> > 
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:384 [inline]
> > BUG: KASAN: slab-out-of-bounds in xfrm_attr_cpy32+0x15a/0x1d0 net/xfrm/xfrm_compat.c:393
> > Write of size 4 at addr ffff88801c57e6c0 by task syz-executor.0/9498
> > 
> > CPU: 1 PID: 9498 Comm: syz-executor.0 Not tainted 5.9.0-syzkaller #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x107/0x163 lib/dump_stack.c:118
> >  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
> >  __kasan_report mm/kasan/report.c:545 [inline]
> >  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
> >  check_memory_region_inline mm/kasan/generic.c:186 [inline]
> >  check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
> >  memset+0x20/0x40 mm/kasan/common.c:84
> >  memset include/linux/string.h:384 [inline]
> >  xfrm_attr_cpy32+0x15a/0x1d0 net/xfrm/xfrm_compat.c:393
> >  xfrm_xlate32_attr net/xfrm/xfrm_compat.c:426 [inline]
> >  xfrm_xlate32 net/xfrm/xfrm_compat.c:525 [inline]
> >  xfrm_user_rcv_msg_compat+0x76b/0x1040 net/xfrm/xfrm_compat.c:570
> >  xfrm_user_rcv_msg+0x55b/0x8b0 net/xfrm/xfrm_user.c:2714
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
> >  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
> >  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
> >  sock_sendmsg_nosec net/socket.c:651 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:671
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
> >  __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
> >  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
> >  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> > RIP: 0023:0xf7f86549
> > Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
> > RSP: 002b:00000000f55800bc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000200001c0
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > 
> > Allocated by task 9498:
> >  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
> >  kasan_set_track mm/kasan/common.c:56 [inline]
> >  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
> >  kmalloc_node include/linux/slab.h:577 [inline]
> >  kvmalloc_node+0x61/0xf0 mm/util.c:575
> >  kvmalloc include/linux/mm.h:765 [inline]
> >  xfrm_user_rcv_msg_compat+0x3cd/0x1040 net/xfrm/xfrm_compat.c:566
> >  xfrm_user_rcv_msg+0x55b/0x8b0 net/xfrm/xfrm_user.c:2714
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
> >  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
> >  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
> >  sock_sendmsg_nosec net/socket.c:651 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:671
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
> >  __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
> >  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
> >  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> > 
> > Last call_rcu():
> >  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
> >  kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
> >  __call_rcu kernel/rcu/tree.c:2953 [inline]
> >  call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
> >  nf_hook_entries_free net/netfilter/core.c:88 [inline]
> >  nf_hook_entries_free net/netfilter/core.c:75 [inline]
> >  __nf_register_net_hook+0x2aa/0x610 net/netfilter/core.c:424
> >  nf_register_net_hook+0x114/0x170 net/netfilter/core.c:541
> >  nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
> >  ip6t_register_table+0x235/0x2f0 net/ipv6/netfilter/ip6_tables.c:1757
> >  ip6table_security_table_init net/ipv6/netfilter/ip6table_security.c:58 [inline]
> >  ip6table_security_table_init+0x82/0xc0 net/ipv6/netfilter/ip6table_security.c:47
> >  xt_find_table_lock+0x2d4/0x540 net/netfilter/x_tables.c:1223
> >  xt_request_find_table_lock+0x27/0xf0 net/netfilter/x_tables.c:1253
> >  get_info+0x16a/0x740 net/ipv6/netfilter/ip6_tables.c:980
> >  do_ip6t_get_ctl+0x152/0xa10 net/ipv6/netfilter/ip6_tables.c:1660
> >  nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
> >  ipv6_getsockopt+0x1be/0x270 net/ipv6/ipv6_sockglue.c:1486
> >  tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:3880
> >  __sys_getsockopt+0x219/0x4c0 net/socket.c:2173
> >  __do_compat_sys_socketcall+0x513/0x660 net/compat.c:495
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
> >  __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
> >  do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
> >  entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
> > 
> > The buggy address belongs to the object at ffff88801c57e600
> >  which belongs to the cache kmalloc-192 of size 192
> > The buggy address is located 0 bytes to the right of
> >  192-byte region [ffff88801c57e600, ffff88801c57e6c0)
> > The buggy address belongs to the page:
> > page:00000000d5f129f9 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88801c57eb00 pfn:0x1c57e
> > flags: 0xfff00000000200(slab)
> > raw: 00fff00000000200 ffff888010041140 ffffea00008066c8 ffff888010040000
> > raw: ffff88801c57eb00 ffff88801c57e000 000000010000000b 0000000000000000
> > page dumped because: kasan: bad access detected
> > 
> > Memory state around the buggy address:
> >  ffff88801c57e580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> >  ffff88801c57e600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >ffff88801c57e680: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >                                            ^
> >  ffff88801c57e700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff88801c57e780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> > ==================================================================
> 
> Check bound after updating pos and before clearing memory.
> 
> --- a/net/xfrm/xfrm_compat.c
> +++ b/net/xfrm/xfrm_compat.c
> @@ -376,6 +376,7 @@ static int xfrm_attr_cpy32(void *dst, si
>  {
>  	struct nlmsghdr *nlmsg = dst;
>  	struct nlattr *nla;
> +	int len;
>  
>  	if (WARN_ON_ONCE(copy_len > payload))
>  		copy_len = payload;
> @@ -390,7 +391,10 @@ static int xfrm_attr_cpy32(void *dst, si
>  	*pos += nla_attr_size(payload);
>  	nlmsg->nlmsg_len += nla->nla_len;
>  
> -	memset(dst + *pos, 0, payload - copy_len);
> +	len = payload - copy_len;
> +	if (size - *pos < len)
> +		len = size - *pos;
> +	memset(dst + *pos, 0, len);
>  	*pos += payload - copy_len;
>  
>  	return 0;
