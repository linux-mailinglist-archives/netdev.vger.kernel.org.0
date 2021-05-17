Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797983837F6
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhEQPr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:47:57 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56117 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbhEQPpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:45:51 -0400
Received: by mail-io1-f69.google.com with SMTP id p2-20020a5d98420000b029043b3600ac76so839580ios.22
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=mrMkioD6vzRM2yujSYnUXKviNRlAqk6XqzwbtXOea+E=;
        b=XhLf+9TM2LcbTYRPNaO/pqc13pZNgDfNah7HAn2mtWDWiONaq58PEuhGybB7si9gyi
         waMrOZF4W+mawZcONf3k9UmOpmm4tkvc1nbzk5/nsj0Y/+LpZ0z14kpu2OYK3Tl7HaX+
         FmguSDyQnWSekR0glHuIiu5+RuhXJmiGRTBbh0c3CQBAh4HjPX2u52VJvv1pEkZ48qxN
         rA7Aik2BQRMQyqUHlnD5uM3v4QoNUugS/yEgyYlYFp5K+Wf+wnT6Mwa48ZPPFto7wnL9
         iaQIxxTgkGUER8i2JizWdwZh7+NI/Txn3vkg2TshRS8c5VpsNkoXKqNz3e6XwztO6Hvl
         K1Ng==
X-Gm-Message-State: AOAM531NYRuI7z6ZnbrfuatbQysqFHL9fSvln7moNSzrSVRBiTc1Y+zx
        3SLhwsHEaoWb5LGknFM4EcRDuLlzAmpg2Pnm8uoKR4CkNB1l
X-Google-Smtp-Source: ABdhPJx7kbgg5SvchWqwdM8rKoTdxZY9XnSePVnH5SXoaosvpgPhr54ajFNYu/0NmuPEzWPK1L//gTi2QEmup+/CDD/QTk6NMaXW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr291275ilv.184.1621266272712;
 Mon, 17 May 2021 08:44:32 -0700 (PDT)
Date:   Mon, 17 May 2021 08:44:32 -0700
In-Reply-To: <CACT4Y+afi_p-w1BYHZNdkuz-Cnp0aScdoQQj1yEyxR3ZKd3HnA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000457cb105c28878fd@google.com>
Subject: Re: [syzbot] KMSAN: uninit-value in virtio_net_hdr_to_skb
From:   syzbot <syzbot+106457891e3cf3b273a9@syzkaller.appspotmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dvyukov@google.com,
        glider@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tannerlove@google.com,
        willemdebruijn.kernel@gmail.com, xie.he.0141@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, May 17, 2021 at 5:13 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> On Mon, May 17, 2021 at 10:57 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>> >
>> > On Mon, May 17, 2021 at 4:06 PM Willem de Bruijn
>> > <willemdebruijn.kernel@gmail.com> wrote:
>> > >
>> > > On Mon, May 17, 2021 at 7:27 AM syzbot
>> > > <syzbot+106457891e3cf3b273a9@syzkaller.appspotmail.com> wrote:
>> > > >
>> > > > Hello,
>> > > >
>> > > > syzbot found the following issue on:
>> > > >
>> > > > HEAD commit:    4ebaab5f kmsan: drop unneeded references to kmsan_context_..
>> > > > git tree:       https://github.com/google/kmsan.git master
>> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17ac508ed00000
>> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ab8076fe8508c0d3
>> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=106457891e3cf3b273a9
>> > > > compiler:       Debian clang version 11.0.1-2
>> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138f4972d00000
>> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1624ffced00000
>> > > >
>> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> > > > Reported-by: syzbot+106457891e3cf3b273a9@syzkaller.appspotmail.com
>> > > >
>> > > > =====================================================
>> > > > BUG: KMSAN: uninit-value in virtio_net_hdr_to_skb+0x1414/0x14f0 include/linux/virtio_net.h:86
>> > >
>> > > No answer/fix, just initial investigation.
>> > >
>> > > This is an odd location. Line 86 is the inner if statement. Both
>> > > protocol and skb->protocol are clearly initialized by then. But, that
>> > > is also not the allocation that MSAN reports, see below.
>> > >
>> > >                         if (!skb->protocol) {
>> > >                                 __be16 protocol =
>> > > dev_parse_header_protocol(skb);
>> > >
>> > >                                 virtio_net_hdr_set_proto(skb, hdr);
>> > >                                 if (protocol && protocol != skb->protocol)
>> > >                                         return -EINVAL;
>> > >                         }
>> > >
>> > > The repro itself seems mostly straightforward:
>> > >
>> > > - create a packet socket
>> > > - enable PACKET_VNET_HDR with setsockopt(r3, 0x107, 0xf ..)
>> > > - bind to AF_PACKET (0x11)
>> > >
>> > > - create a pipe
>> > > - write to pipe[1]
>> > > - splice pipe[0] to the packet socket
>> > >
>> > > there are a few other calls that I think are irrelevant and/or would fail.
>> > >
>> > > Perhaps there is some race condition in device refcounting, as bind
>> > > operates on that?
>> > >
>> > > > CPU: 0 PID: 8426 Comm: syz-executor777 Not tainted 5.12.0-rc6-syzkaller #0
>> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> > > > Call Trace:
>> > > >  __dump_stack lib/dump_stack.c:79 [inline]
>> > > >  dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
>> > > >  kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
>> > > >  __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
>> > > >  virtio_net_hdr_to_skb+0x1414/0x14f0 include/linux/virtio_net.h:86
>> > > >  packet_snd net/packet/af_packet.c:2994 [inline]
>> > > >  packet_sendmsg+0x85b8/0x99d0 net/packet/af_packet.c:3031
>> > > >  sock_sendmsg_nosec net/socket.c:654 [inline]
>> > > >  sock_sendmsg net/socket.c:674 [inline]
>> > > >  kernel_sendmsg+0x22c/0x2f0 net/socket.c:694
>> > > >  sock_no_sendpage+0x205/0x2b0 net/core/sock.c:2860
>> > > >  kernel_sendpage+0x47a/0x590 net/socket.c:3631
>> > > >  sock_sendpage+0x161/0x1a0 net/socket.c:947
>> > > >  pipe_to_sendpage+0x3e4/0x520 fs/splice.c:364
>> > > >  splice_from_pipe_feed fs/splice.c:418 [inline]
>> > > >  __splice_from_pipe+0x5e3/0xff0 fs/splice.c:562
>> > > >  splice_from_pipe fs/splice.c:597 [inline]
>> > > >  generic_splice_sendpage+0x1d5/0x2c0 fs/splice.c:746
>> > > >  do_splice_from fs/splice.c:767 [inline]
>> > > >  do_splice+0x23c3/0x2c10 fs/splice.c:1079
>> > > >  __do_splice fs/splice.c:1144 [inline]
>> > > >  __do_sys_splice fs/splice.c:1350 [inline]
>> > > >  __se_sys_splice+0x8fa/0xb50 fs/splice.c:1332
>> > > >  __x64_sys_splice+0x6e/0x90 fs/splice.c:1332
>> > > >  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> > > > RIP: 0033:0x449a39
>> > > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> > > > RSP: 002b:00007f8ed790b2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
>> > > > RAX: ffffffffffffffda RBX: 00000000004cf518 RCX: 0000000000449a39
>> > > > RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
>> > > > RBP: 00000000004cf510 R08: 000000000004ffe0 R09: 0000000000000000
>> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cf51c
>> > > > R13: 000000000049e46c R14: 6d32cc5e8ead0600 R15: 0000000000022000
>> > > >
>> > > > Uninit was created at:
>> > > >  kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:121
>> > > >  kmsan_alloc_page+0xd0/0x1e0 mm/kmsan/kmsan_shadow.c:274
>> > > >  __alloc_pages_nodemask+0x827/0xf90 mm/page_alloc.c:5044
>> > > >  alloc_pages_current+0x7b6/0xb60 mm/mempolicy.c:2277
>> > > >  alloc_pages include/linux/gfp.h:561 [inline]
>> > > >  alloc_slab_page mm/slub.c:1653 [inline]
>> > > >  allocate_slab+0x364/0x1260 mm/slub.c:1793
>> > > >  new_slab mm/slub.c:1856 [inline]
>> > > >  new_slab_objects mm/slub.c:2602 [inline]
>> > > >  ___slab_alloc+0xd42/0x1930 mm/slub.c:2765
>> > > >  __slab_alloc mm/slub.c:2805 [inline]
>> > > >  slab_alloc_node mm/slub.c:2886 [inline]
>> > > >  slab_alloc mm/slub.c:2931 [inline]
>> > > >  kmem_cache_alloc_trace+0xc53/0x1030 mm/slub.c:2948
>> > > >  kmalloc include/linux/slab.h:554 [inline]
>> > > >  kzalloc include/linux/slab.h:684 [inline]
>> > > >  ____ip_mc_inc_group+0x4d7/0x10b0 net/ipv4/igmp.c:1435
>> > >
>> > > This allocates ip_mc_list, but it uses kzalloc. Can that ever count as
>> > > uninitialized?
>> >
>> > Yes, kzalloc should never be a source of uninitialized-ness.
>> > But it's not actually this kzalloc, it's underlying page allocation
>> > (that is allocated uninitialized, so can be source of
>> > uninitialized-ness).
>> > If it would be this kzalloc, then stack would be shorter, along the
>> > lines of kzalloc->kmem_cache_alloc_trace->kmsan_save_stack_with_flags.
>> >
>> > This smells like a wild access in virtio_net_hdr_to_skb, which just
>> > hit a random uninit somewhere.
>> > Searching for virtio_net_hdr_to_skb I found this:
>> >
>> > KASAN: use-after-free Read in eth_header_parse_protocol
>> > https://syzkaller.appspot.com/bug?id=a486048b63065fd224f57b16d5a2fdece2b40eca
>> >
>> > Can it be a dup of that bug?
>>
>> Great find.
>>
>> That commit is not yet present at kmsan.git at 4ebaab5fb428.
>>
>> Certainly sounds plausible.
>
> Then let's consider:
>
> #syz dup: KASAN: use-after-free Read in eth_header_parse_protocol

Can't dup bug to a bug in different reporting (upstream->internal).Please dup syzbot bugs only onto syzbot bugs for the same kernel/reporting.

