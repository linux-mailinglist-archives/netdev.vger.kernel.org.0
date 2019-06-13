Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35BA43A61
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbfFMPUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:41 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45434 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732018AbfFMMwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:52:40 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so22323768qtr.12;
        Thu, 13 Jun 2019 05:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=972AR0FOM5jsmMvIUB3SOc7D5NMJy3dqeA7JzYxM/oI=;
        b=mgajSpEkyL5G0mrZguujcQKMNvfOh6xyilTI81HfsYgfOJ8tFmcv8+0FH+HzbEki7l
         ocic2D8qAoOHpTWW06wDdjBzZQpHzc8H3t5FpDwev+06olye2tmTtNKv0ozPkOYq7H49
         /Mvln//EYktlVN6CMG0rVOZKq+GThjTPJfqRs/8VEN96e2sW1dX367Z0gm1VJboauG0e
         uJQgdjfVxM4Cm28WZ3lRu609LQ40uMvNXh9O4rdXA9mGwDJT8xT/UQQ7S5zLnSkptfAO
         9bJk/xmod64LIAwSK7dcsGfBd6D46Z68DjMDLuAT1OwbGAbbKJ8HJ84u/OlDvtVWpGx2
         y/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=972AR0FOM5jsmMvIUB3SOc7D5NMJy3dqeA7JzYxM/oI=;
        b=oGS4hWL1nGhFCTnnRZi9dDev2ogtyzJSd6NVRX+MPSfaKiLwHSjQgAC5DEprVTzvUt
         P5EHVaaMocAi8BZNTRrStToTg4RzjBJbB9YmNR8+0ESCMZ0ZbnpJqyXm54acRLp/sCFS
         ieM2wKoRXufjQw3I4aUP/1aOsKHvtmXZwTXiobW4atDTa+b8pY6MylJ6FTJ2HF0j7hQw
         0+pE5YhESdKqIydOtcrYxs7nVX75Mq0EEJ5fcTVhJdFgDRsA93AzKD9RwaJSg7ilxGgw
         o1IeoceG7qxKEfgU6gWkXhlpzX2Brxrf98X/WX9pLMD5x5dUf2X/7ahjup9yKuzGkl77
         xc0Q==
X-Gm-Message-State: APjAAAXGYO4hzBZgVAZZybYQRWoLpJh9kce8xLib9dHsqStDYR+cKro5
        8UYa3QRNOPeIj+udfXW7DWM=
X-Google-Smtp-Source: APXvYqzbeM2PlP5O2LztCjUkzniWEtr7hoqENVyNHGz0LwIbYfcQ534gtjoVFctFJXPhcbXP8JEY+g==
X-Received: by 2002:ac8:2318:: with SMTP id a24mr73853923qta.60.1560430358649;
        Thu, 13 Jun 2019 05:52:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:278e:68eb:7f4f:8f57:4b3a])
        by smtp.gmail.com with ESMTPSA id o22sm1201087qkk.50.2019.06.13.05.52.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 05:52:37 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2A1F7C1BC7; Thu, 13 Jun 2019 09:52:35 -0300 (-03)
Date:   Thu, 13 Jun 2019 09:52:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>, vyasevich@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Add rcu lock to protect dst entry in
 sctp_transport_route
Message-ID: <20190613125235.GF3436@localhost.localdomain>
References: <1560136800-17961-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190610111209.GA15599@hmswarspite.think-freely.org>
 <08f76a75-9e5b-2434-9175-e5371fa9cb7e@cn.fujitsu.com>
 <20190612131346.GA23166@hmswarspite.think-freely.org>
 <d5d2f354-1358-e8fe-7c80-15d6f5757600@cn.fujitsu.com>
 <20190613113544.GC5381@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613113544.GC5381@hmswarspite.think-freely.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 07:35:44AM -0400, Neil Horman wrote:
> On Thu, Jun 13, 2019 at 10:37:51AM +0800, Su Yanjun wrote:
> > 
> > 在 2019/6/12 21:13, Neil Horman 写道:
> > > On Tue, Jun 11, 2019 at 10:33:17AM +0800, Su Yanjun wrote:
> > > > 在 2019/6/10 19:12, Neil Horman 写道:
> > > > > On Mon, Jun 10, 2019 at 11:20:00AM +0800, Su Yanjun wrote:
> > > > > > syzbot found a crash in rt_cache_valid. Problem is that when more
> > > > > > threads release dst in sctp_transport_route, the route cache can
> > > > > > be freed.
> > > > > > 
> > > > > > As follows,
> > > > > > p1:
> > > > > > sctp_transport_route
> > > > > >     dst_release
> > > > > >     get_dst
> > > > > > 
> > > > > > p2:
> > > > > > sctp_transport_route
> > > > > >     dst_release
> > > > > >     get_dst
> > > > > > ...
> > > > > > 
> > > > > > If enough threads calling dst_release will cause dst->refcnt==0
> > > > > > then rcu softirq will reclaim the dst entry,get_dst then use
> > > > > > the freed memory.
> > > > > > 
> > > > > > This patch adds rcu lock to protect the dst_entry here.
> > > > > > 
> > > > > > Fixes: 6e91b578bf3f("sctp: re-use sctp_transport_pmtu in
> > > > > sctp_transport_route")
> > > > > > Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> > > > > > Reported-by: syzbot+a9e23ea2aa21044c2798@syzkaller.appspotmail.com
> > > > > > ---
> > > > > >    net/sctp/transport.c | 5 +++++
> > > > > >    1 file changed, 5 insertions(+)
> > > > > > 
> > > > > > diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> > > > > > index ad158d3..5ad7e20 100644
> > > > > > --- a/net/sctp/transport.c
> > > > > > +++ b/net/sctp/transport.c
> > > > > > @@ -308,8 +308,13 @@ void sctp_transport_route(struct sctp_transport
> > > > > *transport,
> > > > > >    	struct sctp_association *asoc = transport->asoc;
> > > > > >    	struct sctp_af *af = transport->af_specific;
> > > > > > +	/* When dst entry is being released, route cache may be referred
> > > > > > +	 * again. Add rcu lock here to protect dst entry.
> > > > > > +	 */
> > > > > > +	rcu_read_lock();
> > > > > >    	sctp_transport_dst_release(transport);
> > > > > >    	af->get_dst(transport, saddr, &transport->fl, sctp_opt2sk(opt));
> > > > > > +	rcu_read_unlock();
> > > > > What is the exact error that syzbot reported?  This doesn't seem like it
> > > > > fixes
> > > > BUG: KASAN: slab-out-of-bounds in rt_cache_valid+0x158/0x190
> > > > net/ipv4/route.c:1556
> > > > Read of size 2 at addr ffff8880654f3ac7 by task syz-executor.0/26603
> > > > 
> > > > CPU: 0 PID: 26603 Comm: syz-executor.0 Not tainted 5.2.0-rc2+ #9
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > > Google 01/01/2011
> > > > Call Trace:
> > > >   __dump_stack lib/dump_stack.c:77 [inline]
> > > >   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
> > > >   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
> > > >   __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
> > > >   kasan_report+0x12/0x20 mm/kasan/common.c:614
> > > >   __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
> > > >   rt_cache_valid+0x158/0x190 net/ipv4/route.c:1556
> > > >   __mkroute_output net/ipv4/route.c:2332 [inline]
> > > >   ip_route_output_key_hash_rcu+0x819/0x2d50 net/ipv4/route.c:2564
> > > >   ip_route_output_key_hash+0x1ef/0x360 net/ipv4/route.c:2393
> > > >   __ip_route_output_key include/net/route.h:125 [inline]
> > > >   ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2651
> > > >   ip_route_output_key include/net/route.h:135 [inline]
> > > >   sctp_v4_get_dst+0x467/0x1260 net/sctp/protocol.c:435
> > > >   sctp_transport_route+0x12d/0x360 net/sctp/transport.c:297
> > > >   sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:663
> > > >   sctp_process_param net/sctp/sm_make_chunk.c:2531 [inline]
> > > >   sctp_process_init+0x2491/0x2b10 net/sctp/sm_make_chunk.c:2344
> > > >   sctp_cmd_process_init net/sctp/sm_sideeffect.c:667 [inline]
> > > >   sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1369 [inline]
> > > >   sctp_side_effects net/sctp/sm_sideeffect.c:1179 [inline]
> > > >   sctp_do_sm+0x3a30/0x50e0 net/sctp/sm_sideeffect.c:1150
> > > >   sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1059
> > > >   sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
> > > >   sctp_backlog_rcv+0x196/0xbe0 net/sctp/input.c:339
> > > >   sk_backlog_rcv include/net/sock.h:945 [inline]
> > > >   __release_sock+0x129/0x390 net/core/sock.c:2412
> > > >   release_sock+0x59/0x1c0 net/core/sock.c:2928
> > > >   sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:9039
> > > >   __sctp_connect+0xab2/0xcd0 net/sctp/socket.c:1226
> > > >   __sctp_setsockopt_connectx+0x133/0x1a0 net/sctp/socket.c:1334
> > > >   sctp_setsockopt_connectx_old net/sctp/socket.c:1350 [inline]
> > > >   sctp_setsockopt net/sctp/socket.c:4644 [inline]
> > > >   sctp_setsockopt+0x22c0/0x6d10 net/sctp/socket.c:4608
> > > >   compat_sock_common_setsockopt+0x106/0x140 net/core/sock.c:3137
> > > >   __compat_sys_setsockopt+0x185/0x380 net/compat.c:383
> > > >   __do_compat_sys_setsockopt net/compat.c:396 [inline]
> > > >   __se_compat_sys_setsockopt net/compat.c:393 [inline]
> > > >   __ia32_compat_sys_setsockopt+0xbd/0x150 net/compat.c:393
> > > >   do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
> > > >   do_fast_syscall_32+0x27b/0xd7d arch/x86/entry/common.c:408
> > > >   entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> > > > RIP: 0023:0xf7ff5849
> > > > Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90
> > > > 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90
> > > > 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
> > > > RSP: 002b:00000000f5df10cc EFLAGS: 00000296 ORIG_RAX: 000000000000016e
> > > > RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 0000000000000084
> > > > RDX: 000000000000006b RSI: 000000002055bfe4 RDI: 000000000000001c
> > > > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > > 
> > > > Allocated by task 480:
> > > >   save_stack+0x23/0x90 mm/kasan/common.c:71
> > > >   set_track mm/kasan/common.c:79 [inline]
> > > >   __kasan_kmalloc mm/kasan/common.c:489 [inline]
> > > >   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
> > > >   kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
> > > >   slab_post_alloc_hook mm/slab.h:437 [inline]
> > > >   slab_alloc mm/slab.c:3326 [inline]
> > > >   kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3488
> > > >   dst_alloc+0x10e/0x200 net/core/dst.c:93
> > > >   rt_dst_alloc+0x83/0x3f0 net/ipv4/route.c:1624
> > > >   __mkroute_output net/ipv4/route.c:2337 [inline]
> > > >   ip_route_output_key_hash_rcu+0x8f3/0x2d50 net/ipv4/route.c:2564
> > > >   ip_route_output_key_hash+0x1ef/0x360 net/ipv4/route.c:2393
> > > >   __ip_route_output_key include/net/route.h:125 [inline]
> > > >   ip_route_output_flow+0x28/0xc0 net/ipv4/route.c:2651
> > > >   ip_route_output_key include/net/route.h:135 [inline]
> > > >   sctp_v4_get_dst+0x467/0x1260 net/sctp/protocol.c:435
> > > >   sctp_transport_route+0x12d/0x360 net/sctp/transport.c:297
> > > >   sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:663
> > > >   sctp_process_param net/sctp/sm_make_chunk.c:2531 [inline]
> > > >   sctp_process_init+0x2491/0x2b10 net/sctp/sm_make_chunk.c:2344
> > > >   sctp_sf_do_unexpected_init net/sctp/sm_statefuns.c:1541 [inline]
> > > > 
> > > > sctp_sf_do_unexpected_init.isra.0+0x7cd/0x1350net/sctp/sm_statefuns.c:1441
> > > >   sctp_sf_do_5_2_1_siminit+0x35/0x40 net/sctp/sm_statefuns.c:1670
> > > >   sctp_do_sm+0x121/0x50e0 net/sctp/sm_sideeffect.c:1147
> > > >   sctp_assoc_bh_rcv+0x343/0x660 net/sctp/associola.c:1059
> > > >   sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
> > > >   sctp_backlog_rcv+0x196/0xbe0 net/sctp/input.c:339
> > > >   sk_backlog_rcv include/net/sock.h:945 [inline]
> > > >   __release_sock+0x129/0x390 net/core/sock.c:2412
> > > >   release_sock+0x59/0x1c0 net/core/sock.c:2928
> > > >   sctp_wait_for_connect+0x316/0x540 net/sctp/socket.c:9039
> > > >   __sctp_connect+0xab2/0xcd0 net/sctp/socket.c:1226
> > > >   sctp_connect net/sctp/socket.c:4846 [inline]
> > > >   sctp_inet_connect+0x29c/0x340 net/sctp/socket.c:4862
> > > >   __sys_connect+0x264/0x330 net/socket.c:1834
> > > >   __do_sys_connect net/socket.c:1845 [inline]
> > > >   __se_sys_connect net/socket.c:1842 [inline]
> > > >   __ia32_sys_connect+0x72/0xb0 net/socket.c:1842
> > > >   do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
> > > >   do_fast_syscall_32+0x27b/0xd7d arch/x86/entry/common.c:408
> > > >   entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> > > > 
> > > > Freed by task 9:
> > > >   save_stack+0x23/0x90 mm/kasan/common.c:71
> > > >   set_track mm/kasan/common.c:79 [inline]
> > > >   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
> > > >   kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
> > > >   __cache_free mm/slab.c:3432 [inline]
> > > >   kmem_cache_free+0x86/0x260 mm/slab.c:3698
> > > >   dst_destroy+0x29e/0x3c0 net/core/dst.c:129
> > > >   dst_destroy_rcu+0x16/0x19 net/core/dst.c:142
> > > >   __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
> > > >   rcu_do_batch kernel/rcu/tree.c:2092 [inline]
> > > >   invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
> > > >   rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
> > > >   __do_softirq+0x25c/0x94c kernel/softirq.c:293
> > > > 
> > > > The buggy address belongs to the object at ffff8880654f3a00
> > > >   which belongs to the cache ip_dst_cache of size 176
> > > > The buggy address is located 23 bytes to the right of
> > > >   176-byte region [ffff8880654f3a00, ffff8880654f3ab0)
> > > > The buggy address belongs to the page:
> > > > page:ffffea0001953cc0 refcount:1 mapcount:0 mapping:ffff8880a76ad600
> > > > index:0xffff8880654f3c00
> > > > flags: 0x1fffc0000000200(slab)
> > > > raw: 01fffc0000000200 ffffea00026be808 ffffea000181c088 ffff8880a76ad600
> > > > raw: ffff8880654f3c00 ffff8880654f3000 0000000100000002 0000000000000000
> > > > page dumped because: kasan: bad access detected
> > > > 
> > > > Memory state around the buggy address:
> > > >   ffff8880654f3980: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> > > >   ffff8880654f3a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > > ffff8880654f3a80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> > > >                                             ^
> > > >   ffff8880654f3b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > >   ffff8880654f3b80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> > > > ==================================================================
> > > > > anything.  Based on what you've said above, we have multiple processes
> > > > > looking
> > > > > up and releasing routes in parallel (which IIRC should never happen, as
> > > > > only one
> > > > > process should traverse the sctp state machine for a given association
> > > > > at
> > > > > any
> > > > > one time).
> > > > Looks like multiple process could run into sctp_transport_route.
> > > Yeah, I'm sorry, my previous comment was a bit overstated, you can
> > > definately
> > > have multiple process going through the state machine, but not with the same
> > > packet.
> > > 
> > > That said, this fix still isn't right.  Looking at the code, It appears that
> > > we
> > > are manipulating a route inside __mkroute_output that is in the process of
> > > being
> > > destroyed.  But the destruction occurs from an rcu_callback, and the lookup
> > > process in __mkroute_output is under the protection of the rcu_read_lock
> > > already
> > > (as seen in ip_route_output_key_hash), so the destruction should be delayed
> > > until that _mkroute_output call is complete, and the call in
> > > __mkroute_output
> > > should skip any route that is in-flight to be destroyed, because the
> > > reference
> > > count should be zero (causing dst_hold_safe to return 0).
> > Yes, you are right. __mkroute_output is impossible to cause dst entry to be
> > released.
> > > Basically, it seems like somehow, __mkroute_output has found a route, and
> > > started to dereference parts of it, while it is at the same time being
> > > freed,
> > But dst entry may be  released somewhere.
> > 
> Yes, thats how dst entries get released.
> 
> > As syzbot reports,
> > HEAD commit:    9221dced Merge tag 'for-linus-20190601' of git://git.kerne..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=114cdc0ea00000
> > kernel config: https://syzkaller.appspot.com/x/.config?x=1fa7e451a5cac069
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a9e23ea2aa21044c2798
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > userspace arch: i386
> > 
> > i searched dst_release in sctp code, sctp_transport_dst_release is a big
> > suspicion.
> > If multiple processes calling sctp_transport_dst_release would cause
> > refcnt==0,
> > dst entry will be reclaimed.
> > 
> Yes, that too is clear, but dst_release drops the refcount, and if its zero,
> calls call_rcu(..., dst_destroy_rcu), which only finally frees the dst entry
> after an rcu grace period.
> 
> __mkroute_output is always called under the protection of rcu_read_lock (see
> ip_route_output_key_hash), so any call to dst_release will have the actual free
> until some time after rcu_read_unlock is called, meaning any access made to the
> corresponding dst entry in __mkroute_output is safe.  And if__mkroute_output
> selects a dst entry that is pending deletion from an already registered rcu
> callback will get skipped, because its refcount is zero, and dst_hold_safe will
> return zero (since it uses atomic_inc_not_zero to increment the refcount).
> 
> > __mkroute_output in route.c:
> > prth = raw_cpu_ptr(nh->nh_pcpu_rth_output);
> > rth = rcu_dereference(*prth);
> > it uses *nh_pcpu_rth_output* to refer the route cache. If dst entry has been
> > released, no one
> > sets *nh_pcpu_rth_output* to null, only rt_cache_route updates it with a new
> > one.
> > 
> > anywhere release_dst and get_dst which may access the same dst concurrently
> > should
> > be under rcu lock protection.
> > 
> Yes, and it is, via ip_route_output_key_hash, and that appears in both call
> traces, so we should be under rcu lock protection.
> 
> > I'm not familar with sctp. but looks like a problem  dst_release related.
> Generally speaking, yes, this appears to be an issue in which the rcu callback
> for dst_release is getting called while we are inside __mkroute_output with the
> dst still findable via the ip_route_output_key path.

One other point is that this particular dst entry doesn't "belong" to
a transport or even the sctp subsystem. Dst entries are shared
throughout the system.

  Marcelo

> 
> No idea yet, how thats happening though.
> 
> Neil
> 
> > > which should never happen.  How we are getting into that situation though, I
> > > have no idea yet.
> > > 
> > > Neil
> > > 
> > > > > Protecting the lookup/release operations with a read side rcu
> > > > > lock
> > > > > won't fix that.
> > > > > 
> > > > > Neil
> > > > > 
> > > > > >    	if (saddr)
> > > > > >    		memcpy(&transport->saddr, saddr, sizeof(union sctp_addr));
> > > > > > -- 
> > > > > > 2.7.4
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > 
> > > > 
> > > 
> > 
> > 
> > 
