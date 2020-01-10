Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF11376C3
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgAJTOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:14:04 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:47201 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgAJTOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:14:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 35C14674013E;
        Fri, 10 Jan 2020 20:14:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1578683637; x=1580498038; bh=mhfd0WLRJB
        SwVW5UKYt7ItvCkPprQpYFWOpPlBXdZyM=; b=NDeLR+IkKvbkt+SVVpA0MLUJC1
        YVUylOHUmZZ1k8cYZBWUyiPk/JK7Jy8Og0upsq6OOvoPDgk30QporcHPr/cK1qkQ
        ZNur9TXsrMPo+KUMM3A0/RpVThsp5q8qQl2Q3I22CsLYVKh++qwlejs7fTNXImFn
        KkQK0wG4R7Of3TjCk=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 10 Jan 2020 20:13:57 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 7CBCE674013D;
        Fri, 10 Jan 2020 20:13:56 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2414B2140B; Fri, 10 Jan 2020 20:13:56 +0100 (CET)
Date:   Fri, 10 Jan 2020 20:13:56 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Cong Wang <xiyou.wangcong@gmail.com>
cc:     syzbot <syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com>,
        Arvid Brodin <arvid.brodin@alten.se>, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>, florent.fourcot@wifirst.fr,
        Florian Westphal <fw@strlen.de>, jeremy@azazel.net,
        Johannes Berg <johannes.berg@intel.com>, kadlec@netfilter.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in bitmap_port_ext_cleanup
In-Reply-To: <CAM_iQpWz+ivP2vS50rY94DiR6qSh1W0WKjqgBNKYpUH_VFPgGw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.2001102012430.21802@blackhole.kfki.hu>
References: <000000000000f744e0059bcd8216@google.com> <CAM_iQpWz+ivP2vS50rY94DiR6qSh1W0WKjqgBNKYpUH_VFPgGw@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 10 Jan 2020, Cong Wang wrote:

> On Fri, Jan 10, 2020 at 10:44 AM syzbot
> <syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com> wrote:
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    b07f636f Merge tag 'tpmdd-next-20200108' of git://git.infr..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16c03259e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4c3cc6dbe7259dbf9054
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > userspace arch: i386
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c365c6e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117df9e1e00000
> >
> > The bug was bisected to:
> >
> > commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
> > Author: Cong Wang <xiyou.wangcong@gmail.com>
> > Date:   Thu Jul 4 00:21:13 2019 +0000
> >
> >      hsr: implement dellink to clean up resources
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118759e1e00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=138759e1e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=158759e1e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
> > Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in test_bit
> > include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
> > BUG: KASAN: use-after-free in bitmap_port_ext_cleanup+0xe6/0x2a0
> > net/netfilter/ipset/ip_set_bitmap_gen.h:51
> > Read of size 8 at addr ffff8880a87a47c0 by task syz-executor559/9563
> >
> > CPU: 0 PID: 9563 Comm: syz-executor559 Not tainted 5.5.0-rc5-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x197/0x210 lib/dump_stack.c:118
> >   print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
> >   __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> >   kasan_report+0x12/0x20 mm/kasan/common.c:639
> >   check_memory_region_inline mm/kasan/generic.c:185 [inline]
> >   check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
> >   __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
> >   test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
> >   bitmap_port_ext_cleanup+0xe6/0x2a0
> 
> map->members is freed by ip_set_free() right before using it in
> mtype_ext_cleanup() again. So I think probably we just have to
> move it down:

Yes, exactly. As you suggested, could you submit a patch?

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h
> b/net/netfilter/ipset/ip_set_bitmap_gen.h
> index 1abd6f0dc227..077a2cb65fcb 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@ -60,9 +60,9 @@ mtype_destroy(struct ip_set *set)
>         if (SET_WITH_TIMEOUT(set))
>                 del_timer_sync(&map->gc);
> 
> -       ip_set_free(map->members);
>         if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
>                 mtype_ext_cleanup(set);
> +       ip_set_free(map->members);
>         ip_set_free(map);
> 
>         set->data = NULL;
> 
> Thanks.
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
