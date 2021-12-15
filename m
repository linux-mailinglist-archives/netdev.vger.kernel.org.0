Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA51475695
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhLOKlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLOKlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:41:13 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A180CC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:41:13 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v138so53984281ybb.8
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5XYcWIYZsZ5hmMh+IBCGUH2F5ZU0hOe7c7M1zYiVUA=;
        b=XKid1E2j8fKNaafATKv/TuR6Wm3rASbiPxd+FSPl/DFprgbQuPyqCIqhBS4ItO1Leu
         8d27echCHDGRRxR4Q/ZY2fR48bgTHyaLSSpDzxhj48iJKgwrEpo39QCTbC/ezmz6f3+A
         ig0f7/CaKpmCGbBzvlTT0jnQHpnUtHqJmWa2e8glaFDltd59nwgPvBeI4WPl88dHU76t
         sDn6z9h0HUzViTOzPi0mYnrwPbu+3ZqtFGYM99IJJd5s7ms2QgsX8JlC81HvRHPcKRNm
         ppMU5f4qT61CO2xek3Vcu9OPWEJ/VCRykieSKyO1sK5y3h+dv3LzWzVJyFVQpEcilz4l
         g+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5XYcWIYZsZ5hmMh+IBCGUH2F5ZU0hOe7c7M1zYiVUA=;
        b=FAQhRN2DxeOnFYOYaPlq/eS6glxZ2MZRqk18P00sRP8N4csKbPYAQjLDGK6EmFVExd
         VbMLuWQqE3b1tGNnX2t7LPY1VtlBxxlsvvCPJjycI/HEKeVDNnr7SyyOsuq0yEvikHQW
         8UBolt7JAhkfMo/srkATjsSj3d6w0sFdlDvYP2PjoBmC6pTQL+4y0JCCOD6AfNGT9JzG
         1GevZqQJv05zpHyqwco/wwmn+1ipJROkQtiQPs5hBbkStOPnmUMFmUSfqI7c3s+Mz3XE
         M3yH8guYnZgNEUgWE3U4f1DClKzvhNXw7y4r2Rmc60R5KOg4Xv1RsB4HDdLavYWEWqCJ
         Pl2Q==
X-Gm-Message-State: AOAM530ZGMln5n0UF1BD8NzsAxzrbeNGoIErTcfW6/dqFNjnVQG8N0u3
        YkKfMgDUhnIVVjafDK0U4BjooP21qe7wI+5TcRs2Rg==
X-Google-Smtp-Source: ABdhPJyaMcIYPvV83BRsRn0sN7KKRhpOik7jJOobThFbyAXcdLMMlGyr1DYsXU67hh4rjv4mcJItpXQqGzVODMwQBUw=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr5266105ybp.383.1639564872500;
 Wed, 15 Dec 2021 02:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com> <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
 <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
In-Reply-To: <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Dec 2021 02:41:01 -0800
Message-ID: <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking infrastructure
To:     Jiri Slaby <jirislaby@gmail.com>, Vlastimil Babka <vbabka@suse.cz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 2:38 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Dec 15, 2021 at 2:18 AM Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> > On 05. 12. 21, 5:21, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > It can be hard to track where references are taken and released.
> > >
> > > In networking, we have annoying issues at device or netns dismantles,
> > > and we had various proposals to ease root causing them.
> > ...
> > > --- a/lib/Kconfig
> > > +++ b/lib/Kconfig
> > > @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
> > >        Select the hash size as a power of 2 for the stackdepot hash table.
> > >        Choose a lower value to reduce the memory impact.
> > >
> > > +config REF_TRACKER
> > > +     bool
> > > +     depends on STACKTRACE_SUPPORT
> > > +     select STACKDEPOT
> >
> > Hi,
> >
> > I have to:
> > +       select STACKDEPOT_ALWAYS_INIT
> > here. Otherwise I see this during boot:
> >
>
> Thanks, I am adding Vlastimil Babka to the CC
>
> This stuff has been added in
> commit e88cc9f5e2e7a5d28a1adf12615840fab4cbebfd
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date:   Tue Dec 14 21:50:42 2021 +0000
>
>     lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()
>
>

(This is a problem because this patch is not yet in net-next, so I really do
not know how this issue should be handled)

>
> > > BUG: unable to handle page fault for address: 00000000001e6f80
> > > #PF: supervisor read access in kernel mode
> > > #PF: error_code(0x0000) - not-present page
> > > PGD 0 P4D 0
> > > Oops: 0000 [#1] PREEMPT SMP PTI
> > > CPU: 1 PID: 1 Comm: swapper/0 Tainted: G          I       5.16.0-rc5-next-20211214-vanilla+ #46 2756e36611a8c8a8271884ae04571fc88e1cb566
> > > Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> > > RIP: 0010:__stack_depot_save (lib/stackdepot.c:373)
> > > Code: 04 31 fb 83 fe 03 77 97 83 fe 02 74 7a 83 fe 03 74 72 83 fe 01 74 73 48 8b 05 45 ec 11 02 89 d9 81 e1 ff ff 0f 00 48 8d 0c c8 <48> 8b 29 48 85 ed 75 12 e9 9f 00 00 00 48 8b 6d 00 48 85 ed 0f 84
> > > All code
> > > ========
> > >    0: 04 31                   add    $0x31,%al
> > >    2: fb                      sti
> > >    3: 83 fe 03                cmp    $0x3,%esi
> > >    6: 77 97                   ja     0xffffffffffffff9f
> > >    8: 83 fe 02                cmp    $0x2,%esi
> > >    b: 74 7a                   je     0x87
> > >    d: 83 fe 03                cmp    $0x3,%esi
> > >   10: 74 72                   je     0x84
> > >   12: 83 fe 01                cmp    $0x1,%esi
> > >   15: 74 73                   je     0x8a
> > >   17: 48 8b 05 45 ec 11 02    mov    0x211ec45(%rip),%rax        # 0x211ec63
> > >   1e: 89 d9                   mov    %ebx,%ecx
> > >   20: 81 e1 ff ff 0f 00       and    $0xfffff,%ecx
> > >   26: 48 8d 0c c8             lea    (%rax,%rcx,8),%rcx
> > >   2a:*        48 8b 29                mov    (%rcx),%rbp              <-- trapping instruction
> > >   2d: 48 85 ed                test   %rbp,%rbp
> > >   30: 75 12                   jne    0x44
> > >   32: e9 9f 00 00 00          jmp    0xd6
> > >   37: 48 8b 6d 00             mov    0x0(%rbp),%rbp
> > >   3b: 48 85 ed                test   %rbp,%rbp
> > >   3e: 0f                      .byte 0xf
> > >   3f: 84                      .byte 0x84
> > >
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0: 48 8b 29                mov    (%rcx),%rbp
> > >    3: 48 85 ed                test   %rbp,%rbp
> > >    6: 75 12                   jne    0x1a
> > >    8: e9 9f 00 00 00          jmp    0xac
> > >    d: 48 8b 6d 00             mov    0x0(%rbp),%rbp
> > >   11: 48 85 ed                test   %rbp,%rbp
> > >   14: 0f                      .byte 0xf
> > >   15: 84                      .byte 0x84
> > > RSP: 0000:ffffb3f700027b78 EFLAGS: 00010206
> > > RAX: 0000000000000000 RBX: 000000004ea3cdf0 RCX: 00000000001e6f80
> > > RDX: 000000000000000d RSI: 0000000000000002 RDI: 00000000793ec676
> > > RBP: ffff8b578094f4d0 R08: 0000000043abc8c3 R09: 000000000000000d
> > > R10: 0000000000000015 R11: 000000000000001c R12: 0000000000000001
> > > R13: 0000000000000cc0 R14: ffffb3f700027bd8 R15: 000000000000000d
> > > FS:  0000000000000000(0000) GS:ffff8b5845c80000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00000000001e6f80 CR3: 0000000199410000 CR4: 00000000000006e0
> > > Call Trace:
> > > <TASK>
> > > ref_tracker_alloc (lib/ref_tracker.c:84)
> > > net_rx_queue_update_kobjects (net/core/net-sysfs.c:1049 net/core/net-sysfs.c:1101)
> > > netdev_register_kobject (net/core/net-sysfs.c:1761 net/core/net-sysfs.c:2012)
> > > register_netdevice (net/core/dev.c:9660)
> > > register_netdev (net/core/dev.c:9784)
> > > loopback_net_init (drivers/net/loopback.c:217)
> > > ops_init (net/core/net_namespace.c:140)
> > > register_pernet_operations (net/core/net_namespace.c:1148 net/core/net_namespace.c:1217)
> > > register_pernet_device (net/core/net_namespace.c:1304)
> > > net_dev_init (net/core/dev.c:11014)
> > > ? sysctl_core_init (net/core/dev.c:10958)
> > > do_one_initcall (init/main.c:1303)
> > > kernel_init_freeable (init/main.c:1377 init/main.c:1394 init/main.c:1413 init/main.c:1618)
> > > ? rest_init (init/main.c:1499)
> > > kernel_init (init/main.c:1509)
> > > ret_from_fork (arch/x86/entry/entry_64.S:301)
> > > </TASK>
> > > Modules linked in:
> > > CR2: 00000000001e6f80
> > > ---[ end trace 0000000000000000 ]---
> > > RIP: 0010:__stack_depot_save (lib/stackdepot.c:373)
> > > Code: 04 31 fb 83 fe 03 77 97 83 fe 02 74 7a 83 fe 03 74 72 83 fe 01 74 73 48 8b 05 45 ec 11 02 89 d9 81 e1 ff ff 0f 00 48 8d 0c c8 <48> 8b 29 48 85 ed 75 12 e9 9f 00 00 00 48 8b 6d 00 48 85 ed 0f 84
> > > All code
> > > ========
> > >    0: 04 31                   add    $0x31,%al
> > >    2: fb                      sti
> > >    3: 83 fe 03                cmp    $0x3,%esi
> > >    6: 77 97                   ja     0xffffffffffffff9f
> > >    8: 83 fe 02                cmp    $0x2,%esi
> > >    b: 74 7a                   je     0x87
> > >    d: 83 fe 03                cmp    $0x3,%esi
> > >   10: 74 72                   je     0x84
> > >   12: 83 fe 01                cmp    $0x1,%esi
> > >   15: 74 73                   je     0x8a
> > >   17: 48 8b 05 45 ec 11 02    mov    0x211ec45(%rip),%rax        # 0x211ec63
> > >   1e: 89 d9                   mov    %ebx,%ecx
> > >   20: 81 e1 ff ff 0f 00       and    $0xfffff,%ecx
> > >   26: 48 8d 0c c8             lea    (%rax,%rcx,8),%rcx
> > >   2a:*        48 8b 29                mov    (%rcx),%rbp              <-- trapping instruction
> > >   2d: 48 85 ed                test   %rbp,%rbp
> > >   30: 75 12                   jne    0x44
> > >   32: e9 9f 00 00 00          jmp    0xd6
> > >   37: 48 8b 6d 00             mov    0x0(%rbp),%rbp
> > >   3b: 48 85 ed                test   %rbp,%rbp
> > >   3e: 0f                      .byte 0xf
> > >   3f: 84                      .byte 0x84
> > >
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0: 48 8b 29                mov    (%rcx),%rbp
> > >    3: 48 85 ed                test   %rbp,%rbp
> > >    6: 75 12                   jne    0x1a
> > >    8: e9 9f 00 00 00          jmp    0xac
> > >    d: 48 8b 6d 00             mov    0x0(%rbp),%rbp
> > >   11: 48 85 ed                test   %rbp,%rbp
> > >   14: 0f                      .byte 0xf
> > >   15: 84                      .byte 0x84
> > > RSP: 0000:ffffb3f700027b78 EFLAGS: 00010206
> > > RAX: 0000000000000000 RBX: 000000004ea3cdf0 RCX: 00000000001e6f80
> > > RDX: 000000000000000d RSI: 0000000000000002 RDI: 00000000793ec676
> > > RBP: ffff8b578094f4d0 R08: 0000000043abc8c3 R09: 000000000000000d
> > > R10: 0000000000000015 R11: 000000000000001c R12: 0000000000000001
> > > R13: 0000000000000cc0 R14: ffffb3f700027bd8 R15: 000000000000000d
> > > FS:  0000000000000000(0000) GS:ffff8b5845c80000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00000000001e6f80 CR3: 0000000199410000 CR4: 00000000000006e0
> >
> > regards,
> > --
> > js
