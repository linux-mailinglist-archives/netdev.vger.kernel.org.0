Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD57787C
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 13:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfG0LkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 07:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfG0LkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 07:40:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5C842082E;
        Sat, 27 Jul 2019 11:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564227604;
        bh=TYNJ1YsSH65sXPDM7fG4T/T4XSM5LGIykM1kF9l2qh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0lmmf3USQeflX1ETKKdgyMqeLJ3DnGchN4sqwjN7J6yZ/TQERPjpn/GUyOkOoeM/W
         9bamC46vEGVH+amKq7Kk+dsG/KKVlcy6ZKgsGDX8jSoWmLPX93ws7b/tzTJiMwiL8Z
         fUWJulYEVZC6ID/6q5vWGoWCOZ0GYY6rH7TTpr5c=
Date:   Sat, 27 Jul 2019 13:40:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     maowenan <maowenan@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
Message-ID: <20190727114001.GA6685@kroah.com>
References: <20190724091715.137033-1-maowenan@huawei.com>
 <20190724110524.GA4472@kroah.com>
 <a5965aac-7de2-3c3f-349d-8894ae1b897b@huawei.com>
 <495c2d12-2c18-3498-52a0-71e9e8a05576@huawei.com>
 <02a3860d-4ad8-0ba9-e488-9a149de55b3b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02a3860d-4ad8-0ba9-e488-9a149de55b3b@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 07:22:30PM +0800, maowenan wrote:
> 
> 
> On 2019/7/27 18:44, maowenan wrote:
> > 
> > 
> > On 2019/7/24 20:13, maowenan wrote:
> >>
> >>
> >> On 2019/7/24 19:05, Greg KH wrote:
> >>> On Wed, Jul 24, 2019 at 05:17:15PM +0800, Mao Wenan wrote:
> >>>> There is one report about tcp_write_xmit use-after-free with version 4.4.136:
> >>>>
> >>>> BUG: KASAN: use-after-free in tcp_skb_pcount include/net/tcp.h:796 [inline]
> >>>> BUG: KASAN: use-after-free in tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
> >>>> BUG: KASAN: use-after-free in tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
> >>>> Read of size 2 at addr ffff8801d6fc87b0 by task syz-executor408/4195
> >>>>
> >>>> CPU: 0 PID: 4195 Comm: syz-executor408 Not tainted 4.4.136-gfb7e319 #59
> >>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >>>>  0000000000000000 7d8f38ecc03be946 ffff8801d73b7710 ffffffff81e0edad
> >>>>  ffffea00075bf200 ffff8801d6fc87b0 0000000000000000 ffff8801d6fc87b0
> >>>>  dffffc0000000000 ffff8801d73b7748 ffffffff815159b6 ffff8801d6fc87b0
> >>>> Call Trace:
> >>>>  [<ffffffff81e0edad>] __dump_stack lib/dump_stack.c:15 [inline]
> >>>>  [<ffffffff81e0edad>] dump_stack+0xc1/0x124 lib/dump_stack.c:51
> >>>>  [<ffffffff815159b6>] print_address_description+0x6c/0x216 mm/kasan/report.c:252
> >>>>  [<ffffffff81515cd5>] kasan_report_error mm/kasan/report.c:351 [inline]
> >>>>  [<ffffffff81515cd5>] kasan_report.cold.7+0x175/0x2f7 mm/kasan/report.c:408
> >>>>  [<ffffffff814f9784>] __asan_report_load2_noabort+0x14/0x20 mm/kasan/report.c:427
> >>>>  [<ffffffff83286582>] tcp_skb_pcount include/net/tcp.h:796 [inline]
> >>>>  [<ffffffff83286582>] tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
> >>>>  [<ffffffff83286582>] tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
> >>>>  [<ffffffff83287a40>] __tcp_push_pending_frames+0xa0/0x290 net/ipv4/tcp_output.c:2307
> >>>>  [<ffffffff8328e966>] tcp_send_fin+0x176/0xab0 net/ipv4/tcp_output.c:2883
> >>>>  [<ffffffff8324c0d0>] tcp_close+0xca0/0xf70 net/ipv4/tcp.c:2112
> >>>>  [<ffffffff832f8d0f>] inet_release+0xff/0x1d0 net/ipv4/af_inet.c:435
> >>>>  [<ffffffff82f1a156>] sock_release+0x96/0x1c0 net/socket.c:586
> >>>>  [<ffffffff82f1a296>] sock_close+0x16/0x20 net/socket.c:1037
> >>>>  [<ffffffff81522da5>] __fput+0x235/0x6f0 fs/file_table.c:208
> >>>>  [<ffffffff815232e5>] ____fput+0x15/0x20 fs/file_table.c:244
> >>>>  [<ffffffff8118bd7f>] task_work_run+0x10f/0x190 kernel/task_work.c:115
> >>>>  [<ffffffff81135285>] exit_task_work include/linux/task_work.h:21 [inline]
> >>>>  [<ffffffff81135285>] do_exit+0x9e5/0x26b0 kernel/exit.c:759
> >>>>  [<ffffffff8113b1d1>] do_group_exit+0x111/0x330 kernel/exit.c:889
> >>>>  [<ffffffff8115e5cc>] get_signal+0x4ec/0x14b0 kernel/signal.c:2321
> >>>>  [<ffffffff8100e02b>] do_signal+0x8b/0x1d30 arch/x86/kernel/signal.c:712
> >>>>  [<ffffffff8100360a>] exit_to_usermode_loop+0x11a/0x160 arch/x86/entry/common.c:248
> >>>>  [<ffffffff81006535>] prepare_exit_to_usermode arch/x86/entry/common.c:283 [inline]
> >>>>  [<ffffffff81006535>] syscall_return_slowpath+0x1b5/0x1f0 arch/x86/entry/common.c:348
> >>>>  [<ffffffff838c29b5>] int_ret_from_sys_call+0x25/0xa3
> >>>>
> >>>> Allocated by task 4194:
> >>>>  [<ffffffff810341d6>] save_stack_trace+0x26/0x50 arch/x86/kernel/stacktrace.c:63
> >>>>  [<ffffffff814f8873>] save_stack+0x43/0xd0 mm/kasan/kasan.c:512
> >>>>  [<ffffffff814f8b57>] set_track mm/kasan/kasan.c:524 [inline]
> >>>>  [<ffffffff814f8b57>] kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:616
> >>>>  [<ffffffff814f9122>] kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:554
> >>>>  [<ffffffff814f4c1e>] slab_post_alloc_hook mm/slub.c:1349 [inline]
> >>>>  [<ffffffff814f4c1e>] slab_alloc_node mm/slub.c:2615 [inline]
> >>>>  [<ffffffff814f4c1e>] slab_alloc mm/slub.c:2623 [inline]
> >>>>  [<ffffffff814f4c1e>] kmem_cache_alloc+0xbe/0x2a0 mm/slub.c:2628
> >>>>  [<ffffffff82f380a6>] kmem_cache_alloc_node include/linux/slab.h:350 [inline]
> >>>>  [<ffffffff82f380a6>] __alloc_skb+0xe6/0x600 net/core/skbuff.c:218
> >>>>  [<ffffffff832466c3>] alloc_skb_fclone include/linux/skbuff.h:856 [inline]
> >>>>  [<ffffffff832466c3>] sk_stream_alloc_skb+0xa3/0x5d0 net/ipv4/tcp.c:833
> >>>>  [<ffffffff83249164>] tcp_sendmsg+0xd34/0x2b00 net/ipv4/tcp.c:1178
> >>>>  [<ffffffff83300ef3>] inet_sendmsg+0x203/0x4d0 net/ipv4/af_inet.c:755
> >>>>  [<ffffffff82f1e1fc>] sock_sendmsg_nosec net/socket.c:625 [inline]
> >>>>  [<ffffffff82f1e1fc>] sock_sendmsg+0xcc/0x110 net/socket.c:635
> >>>>  [<ffffffff82f1eedc>] SYSC_sendto+0x21c/0x370 net/socket.c:1665
> >>>>  [<ffffffff82f21560>] SyS_sendto+0x40/0x50 net/socket.c:1633
> >>>>  [<ffffffff838c2825>] entry_SYSCALL_64_fastpath+0x22/0x9e
> >>>>
> >>>> Freed by task 4194:
> >>>>  [<ffffffff810341d6>] save_stack_trace+0x26/0x50 arch/x86/kernel/stacktrace.c:63
> >>>>  [<ffffffff814f8873>] save_stack+0x43/0xd0 mm/kasan/kasan.c:512
> >>>>  [<ffffffff814f91a2>] set_track mm/kasan/kasan.c:524 [inline]
> >>>>  [<ffffffff814f91a2>] kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:589
> >>>>  [<ffffffff814f632e>] slab_free_hook mm/slub.c:1383 [inline]
> >>>>  [<ffffffff814f632e>] slab_free_freelist_hook mm/slub.c:1405 [inline]
> >>>>  [<ffffffff814f632e>] slab_free mm/slub.c:2859 [inline]
> >>>>  [<ffffffff814f632e>] kmem_cache_free+0xbe/0x340 mm/slub.c:2881
> >>>>  [<ffffffff82f3527f>] kfree_skbmem+0xcf/0x100 net/core/skbuff.c:635
> >>>>  [<ffffffff82f372fd>] __kfree_skb+0x1d/0x20 net/core/skbuff.c:676
> >>>>  [<ffffffff83288834>] sk_wmem_free_skb include/net/sock.h:1447 [inline]
> >>>>  [<ffffffff83288834>] tcp_write_queue_purge include/net/tcp.h:1460 [inline]
> >>>>  [<ffffffff83288834>] tcp_connect_init net/ipv4/tcp_output.c:3122 [inline]
> >>>>  [<ffffffff83288834>] tcp_connect+0xb24/0x30c0 net/ipv4/tcp_output.c:3261
> >>>>  [<ffffffff8329b991>] tcp_v4_connect+0xf31/0x1890 net/ipv4/tcp_ipv4.c:246
> >>>>  [<ffffffff832f9ca9>] __inet_stream_connect+0x2a9/0xc30 net/ipv4/af_inet.c:615
> >>>>  [<ffffffff832fa685>] inet_stream_connect+0x55/0xa0 net/ipv4/af_inet.c:676
> >>>>  [<ffffffff82f1eb78>] SYSC_connect+0x1b8/0x300 net/socket.c:1557
> >>>>  [<ffffffff82f214b4>] SyS_connect+0x24/0x30 net/socket.c:1538
> >>>>  [<ffffffff838c2825>] entry_SYSCALL_64_fastpath+0x22/0x9e
> >>>>
> >>>> Syzkaller reproducer():
> >>>> r0 = socket$packet(0x11, 0x3, 0x300)
> >>>> r1 = socket$inet_tcp(0x2, 0x1, 0x0)
> >>>> bind$inet(r1, &(0x7f0000000300)={0x2, 0x4e21, @multicast1}, 0x10)
> >>>> connect$inet(r1, &(0x7f0000000140)={0x2, 0x1000004e21, @loopback}, 0x10)
> >>>> recvmmsg(r1, &(0x7f0000001e40)=[{{0x0, 0x0, &(0x7f0000000100)=[{&(0x7f00000005c0)=""/88, 0x58}], 0x1}}], 0x1, 0x40000000, 0x0)
> >>>> sendto$inet(r1, &(0x7f0000000000)="e2f7ad5b661c761edf", 0x9, 0x8080, 0x0, 0x0)
> >>>> r2 = fcntl$dupfd(r1, 0x0, r0)
> >>>> connect$unix(r2, &(0x7f00000001c0)=@file={0x0, './file0\x00'}, 0x6e)
> >>>>
> >>>> C repro link: https://syzkaller.appspot.com/text?tag=ReproC&x=14db474f800000
> >>>>
> >>>> This is because when tcp_connect_init call tcp_write_queue_purge, it will
> >>>> kfree all the skb in the write_queue, but the sk->sk_send_head forget to set NULL,
> >>>> then tcp_write_xmit try to send skb, which has freed in tcp_write_queue_purge, UAF happens.
> >>>>
> >>>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> >>>> ---
> >>>>  include/net/tcp.h | 1 +
> >>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/include/net/tcp.h b/include/net/tcp.h
> >>>> index bf8a0dae977a..8f8aace28cf8 100644
> >>>> --- a/include/net/tcp.h
> >>>> +++ b/include/net/tcp.h
> >>>> @@ -1457,6 +1457,7 @@ static inline void tcp_write_queue_purge(struct sock *sk)
> >>>>  
> >>>>  	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
> >>>>  		sk_wmem_free_skb(sk, skb);
> >>>> +	sk->sk_send_head = NULL;
> >>>>  	sk_mem_reclaim(sk);
> >>>>  	tcp_clear_all_retrans_hints(tcp_sk(sk));
> >>>>  	inet_csk(sk)->icsk_backoff = 0;
> >>>
> >>> Does this corrispond with a specific commit that is already in Linus's
> >>> tree?  If not, why, did we change/mess something up when doing
> >>> backports, or is the code just that different?
> >>>
> >>> Also, is this needed in 4.9.y, 4.14.y, 4.19.y, and/or 5.2.y?  Why just
> >>> 4.4.y?
> > 
> > Greg,
> > 
> > I have tested latest stable tree
> > 4.4.186 oops
> > 4.9.151 oops
> > 4.14.106 NO oops
> > 
> > This patch can simple fix them.
> 
> I have checked 4.14.y it has already existed the same fix as mine, this is the reason why 4.14.106 is NO oops.
> commit dbbf2d1e4077bab0c65ece2765d3fc69cf7d610f
> Author: Soheil Hassas Yeganeh <soheil@google.com>
> Date:   Thu Mar 15 12:09:13 2018 -0400
> 
>     tcp: reset sk_send_head in tcp_write_queue_purge
> 

So if this patch is backported to 4.4.y and 4.9.y all will be fine?

thanks,

greg k-h
