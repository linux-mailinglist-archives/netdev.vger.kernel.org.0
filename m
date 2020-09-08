Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0726181A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbgIHRsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731884AbgIHRqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:46:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2383C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:46:18 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id l4so16245393ilq.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ief9qYIX7AmW5AiU4JY+79MW/uPDxfsLVWdFYk6OIo0=;
        b=Hhay4758A74oCIS80go2NuPMW+9ONulkkWqVk4bOEXEBfTQEIicaspDyVF8ZlGPh3L
         BD0ED2cwsE/EyzVUKWoabVtDl7Nd/E3zuadESSfPhUW2aQuFqDJWwcFoXgrPrcAGrGun
         GePATTd2qFqVrLi/ZIheBA/KxO7/iDBCei8hE28Rp7WqZz63hk96lfdA5aIE0u90+yes
         h7RiTUYhsuONh/LPdCsG7/Nxd+w//jp6gP8FVVMCdmR7aXqMaRRt+izyU7wEGW858xen
         aOf4QYuJsXWSix4zeYO2VdLy8SxXeeOTQTpif8cPvVqCBcqnRMX5LU8s2Eam8uzugEpT
         JAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ief9qYIX7AmW5AiU4JY+79MW/uPDxfsLVWdFYk6OIo0=;
        b=f6CFZwbAVW27f1roHcA+WExEiJPOBJe3qbqWOfFPA7X8Ec7VeZBVceWczfqx2xDyuv
         bKyIiWvAIJoqRTyZeDuZ3FWW5dVa15sc0j3XXGKwzCxWKF2Vp6a2NQCTTBT5OEKAWzSC
         1BhrGxIlrCvJyaRfpOZY/ARbv46DwG9MU54wSZyQ+oKa5y5Pmt6ufUwL05x/qmdxR2UO
         MRx2xn1PnvVamIcmm6wy5Bm3P4LHCvvHBHkh/CBqbHHZDGcFh8mbeih8Zw3PYLXY0rCA
         bt/UpDuo4xtberIEHTbL15+2PL+GwVjPm4cOYV8dhHTLrFtAOZ0De5tA/vdShCJcXc3g
         zpvA==
X-Gm-Message-State: AOAM532+CHQheqQRC9ujpsb+2qsrGK/A1KliQdfz5cVbubzzte5xmRUQ
        wy8QkBQxmRhXO7sy0Y4+ommiJenaj55b+hSY6gCIuA==
X-Google-Smtp-Source: ABdhPJyMNGZijJmUD19Wshc/KKxzL508lFARn0D/Qi4KcjItXdpHBwNesTxYak3FzDKfQ33pj20OoK55gOVFv8sEpRE=
X-Received: by 2002:a92:9996:: with SMTP id t22mr23501050ilk.216.1599587178090;
 Tue, 08 Sep 2020 10:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200908082023.3690438-1-edumazet@google.com> <7f56f2d0-e741-bc24-c671-14e53607be2b@gmail.com>
 <CANn89iLxQB7HQRq7fFBp7DoypkzbTeR-=p_04FoUn9uw-s+jig@mail.gmail.com> <5f95d746-27d0-a7c9-9cff-0cc60b7c1c73@gmail.com>
In-Reply-To: <5f95d746-27d0-a7c9-9cff-0cc60b7c1c73@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Sep 2020 19:46:05 +0200
Message-ID: <CANn89i+p7mN9zzc-wG_2rbK4ozpNGWbMVchY8ahucHK7cm3j9Q@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 7:41 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/8/20 11:06 AM, Eric Dumazet wrote:
> > On Tue, Sep 8, 2020 at 6:50 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 9/8/20 2:20 AM, Eric Dumazet wrote:
> >>> syzbot reported twice a lockdep issue in fib6_del() [1]
> >>> which I think is caused by net->ipv6.fib6_null_entry
> >>> having a NULL fib6_table pointer.
> >>>
> >>> fib6_del() already checks for fib6_null_entry special
> >>> case, we only need to return earlier.
> >>>
> >>> Bug seems to occur very rarely, I have thus chosen
> >>> a 'bug origin' that makes backports not too complex.
> >>>
> >>> [1]
> >>> WARNING: suspicious RCU usage
> >>> 5.9.0-rc4-syzkaller #0 Not tainted
> >>> -----------------------------
> >>> net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!
> >>>
> >>> other info that might help us debug this:
> >>>
> >>> rcu_scheduler_active = 2, debug_locks = 1
> >>> 4 locks held by syz-executor.5/8095:
> >>>  #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
> >>>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
> >>>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
> >>>  #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
> >>>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
> >>>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245
> >>>
> >>> stack backtrace:
> >>> CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
> >>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >>> Call Trace:
> >>>  __dump_stack lib/dump_stack.c:77 [inline]
> >>>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
> >>>  fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
> >>>  fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
> >>>  fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
> >>>  fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
> >>>  fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
> >>>  __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246
> >>
> >> This is walking a table and __fib6_clean_all takes the lock for the
> >> table (and you can see that above), so puzzling how fib6_del can be
> >> called for an entry with NULL fib6_table.
> >
> > So you think the test for  (rt == net->ipv6.fib6_null_entry)
> > should be replaced by
> >
> > BUG_ON(rt == net->ipv6.fib6_null_entry); ?
> >
>
> BUG_ON does not seem right.

Yes, currently we return -ENOENT, which looks reasonable.


>
> Backing out to the callers, why does fib6_clean_node not catch that it
> is the root of the table and abort the walk or at least not try to
> remove the root? This might be related to the problem Ben has complained
> about many times.
>
> If syzbot has only triggered it a few times then I presume no reproducer.

No repro, only occurred twice...
