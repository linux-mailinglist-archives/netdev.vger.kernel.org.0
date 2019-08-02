Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8849E7F6DE
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389382AbfHBMc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:32:28 -0400
Received: from mail5.windriver.com ([192.103.53.11]:52936 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfHBMc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 08:32:28 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x72CTOZN001782
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Fri, 2 Aug 2019 05:29:35 -0700
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Fri, 2 Aug
 2019 05:29:13 -0700
Subject: Re: memory leak in tipc_group_create_member
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com>
CC:     <davem@davemloft.net>, <jon.maloy@ericsson.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        <tipc-discussion@lists.sourceforge.net>
References: <000000000000879057058f193fb5@google.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <bbc84761-29aa-b8cc-e50d-dbd6a026f469@windriver.com>
Date:   Fri, 2 Aug 2019 20:18:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <000000000000879057058f193fb5@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 3:44 PM, Hillf Danton wrote:
> 
> On Thu, 01 Aug 2019 19:38:06 -0700
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    a9815a4f Merge branch 'x86-urgent-for-linus' of git://git...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12a6dbf0600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=37c48fb52e3789e6
>> dashboard link: https://syzkaller.appspot.com/bug?extid=f95d90c454864b3b5bc9
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13be3ecc600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c992b4600000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+f95d90c454864b3b5bc9@syzkaller.appspotmail.com
>>
>> executing program
>> BUG: memory leak
>> unreferenced object 0xffff888122bca200 (size 128):
>>    comm "syz-executor232", pid 7065, jiffies 4294943817 (age 8.880s)
>>    hex dump (first 32 bytes):
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>      00 00 00 00 00 00 00 00 18 a2 bc 22 81 88 ff ff  ..........."....
>>    backtrace:
>>      [<000000005bada299>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
>>      [<000000005bada299>] slab_post_alloc_hook mm/slab.h:522 [inline]
>>      [<000000005bada299>] slab_alloc mm/slab.c:3319 [inline]
>>      [<000000005bada299>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
>>      [<00000000e7bcdc9f>] kmalloc include/linux/slab.h:552 [inline]
>>      [<00000000e7bcdc9f>] kzalloc include/linux/slab.h:748 [inline]
>>      [<00000000e7bcdc9f>] tipc_group_create_member+0x3c/0x190  net/tipc/group.c:306
>>      [<0000000005f56f40>] tipc_group_add_member+0x34/0x40  net/tipc/group.c:327
>>      [<0000000044406683>] tipc_nametbl_build_group+0x9b/0xf0  net/tipc/name_table.c:600
>>      [<000000009f71e803>] tipc_sk_join net/tipc/socket.c:2901 [inline]
>>      [<000000009f71e803>] tipc_setsockopt+0x170/0x490 net/tipc/socket.c:3006
>>      [<000000007f61cbc2>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
>>      [<00000000cc630372>] __do_sys_setsockopt net/socket.c:2100 [inline]
>>      [<00000000cc630372>] __se_sys_setsockopt net/socket.c:2097 [inline]
>>      [<00000000cc630372>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
>>      [<00000000ec30be33>] do_syscall_64+0x76/0x1a0  arch/x86/entry/common.c:296
>>      [<00000000271be3e6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>

Acked-by: Ying Xue <ying.xue@windriver.com>

>  
> --- a/net/tipc/group.c
> +++ b/net/tipc/group.c
> @@ -273,7 +273,7 @@ static struct tipc_member *tipc_group_fi
>  	return NULL;
>  }
>  
> -static void tipc_group_add_to_tree(struct tipc_group *grp,
> +static struct tipc_member *tipc_group_add_to_tree(struct tipc_group *grp,
>  				   struct tipc_member *m)
>  {
>  	u64 nkey, key = (u64)m->node << 32 | m->port;
> @@ -282,7 +282,6 @@ static void tipc_group_add_to_tree(struc
>  
>  	n = &grp->members.rb_node;
>  	while (*n) {
> -		tmp = container_of(*n, struct tipc_member, tree_node);
>  		parent = *n;
>  		tmp = container_of(parent, struct tipc_member, tree_node);
>  		nkey = (u64)tmp->node << 32 | tmp->port;
> @@ -291,17 +290,18 @@ static void tipc_group_add_to_tree(struc
>  		else if (key > nkey)
>  			n = &(*n)->rb_right;
>  		else
> -			return;
> +			return tmp;
>  	}
>  	rb_link_node(&m->tree_node, parent, n);
>  	rb_insert_color(&m->tree_node, &grp->members);
> +	return m;
>  }
>  
>  static struct tipc_member *tipc_group_create_member(struct tipc_group *grp,
>  						    u32 node, u32 port,
>  						    u32 instance, int state)
>  {
> -	struct tipc_member *m;
> +	struct tipc_member *m, *n;
>  
>  	m = kzalloc(sizeof(*m), GFP_ATOMIC);
>  	if (!m)
> @@ -315,10 +315,14 @@ static struct tipc_member *tipc_group_cr
>  	m->instance = instance;
>  	m->bc_acked = grp->bc_snd_nxt - 1;
>  	grp->member_cnt++;
> -	tipc_group_add_to_tree(grp, m);
> -	tipc_nlist_add(&grp->dests, m->node);
> -	m->state = state;
> -	return m;
> +	n = tipc_group_add_to_tree(grp, m);
> +	if (n == m) {
> +		tipc_nlist_add(&grp->dests, m->node);
> +		m->state = state;
> +	} else {
> +		kfree(m);
> +	}
> +	return n;
>  }
>  
>  void tipc_group_add_member(struct tipc_group *grp, u32 node,
> --
> 
> 
