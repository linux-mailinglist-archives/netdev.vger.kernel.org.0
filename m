Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6692912BD6C
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 12:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL1LT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 06:19:58 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfL1LT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 06:19:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ilA8M-00073P-9l; Sat, 28 Dec 2019 12:19:50 +0100
Date:   Sat, 28 Dec 2019 12:19:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in nf_ct_netns_do_get
Message-ID: <20191228111950.GJ795@breakpoint.cc>
References: <20191228110316.4400-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191228110316.4400-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:
> > RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
> > RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
> > RIP: 0010:nf_ct_netns_do_get+0xd2/0x7e0  
> > net/netfilter/nf_conntrack_proto.c:449
> > Code: 22 22 fb 45 84 f6 0f 84 5c 03 00 00 e8 07 21 22 fb 49 8d bc 24 68 13  
> > 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
> > 85 9f 06 00 00 4d 8b b4 24 68 13 00 00 e8 47 59 0e
> > RSP: 0018:ffffc90001f177a8 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000003 RCX: ffffffff86531056
> > RDX: 000000000000026d RSI: ffffffff86530ce9 RDI: 0000000000001368
> > RBP: ffffc90001f177e8 R08: ffff88808fd96200 R09: ffffed1015d0703d
> > R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
> > R13: 000000000000002a R14: 0000000000000001 R15: 0000000000000003
> > FS:  00000000009fd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000200008a0 CR3: 0000000093cc3000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   nf_ct_netns_get+0x41/0x150 net/netfilter/nf_conntrack_proto.c:601
> >   connmark_tg_check+0x61/0xe0 net/netfilter/xt_connmark.c:106
> >   xt_check_target+0x283/0x690 net/netfilter/x_tables.c:1019
> >   check_target net/ipv4/netfilter/arp_tables.c:399 [inline]
> >   find_check_entry net/ipv4/netfilter/arp_tables.c:422 [inline]
> >   translate_table+0x1005/0x1d70 net/ipv4/netfilter/arp_tables.c:572
> >   do_replace net/ipv4/netfilter/arp_tables.c:977 [inline]
> >   do_arpt_set_ctl+0x310/0x640 net/ipv4/netfilter/arp_tables.c:1456
> >   nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
> >   nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
> >   ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
> >   ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
> >   udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
> >   sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
> >   __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
> >   __do_sys_setsockopt net/socket.c:2133 [inline]
> >   __se_sys_setsockopt net/socket.c:2130 [inline]
> >   __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
> >   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> 
> Get net namespace unless @net is invalid.
> 
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -582,6 +582,9 @@ int nf_ct_netns_get(struct net *net, u8
>  {
>  	int err;
>  
> +	if (!net)
> +		return -EINVAL;
> +

We should not have a NULL netns pointer to begin with, see:

http://patchwork.ozlabs.org/patch/1215593/
