Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4432E2C1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfE2RCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:02:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37548 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfE2RCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:02:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id d15so1965552qkl.4
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4i0BYB0elUrQ8nMkTes2DS3sYOQi6/KyXR/BCwwYT64=;
        b=q3jB0g8St1TPhMNuee4ze/CMciZPLAH2B1Q5KfOKrTMxT8tNJawi6zlsPjwRiVR5N0
         T1//I1Si2IAT1o+deBswf4AlIEMQeq8M4KXoUy155Mx2Pd6aSFTzOmGGuaNPVNi9+ty/
         IrqruCykH+hchDKZUHVeVoF0kDwbGJ4Sxml1QJPUhVDuoekECh+lqhXp2dHWma8AfIEJ
         63X6MQ5nYIVfm2BgKcBkTxIdqLD7lKGD3EC6awfHPSeUt/DsyFsWw3OTEN0JtbTVTS9s
         FIovcJk5BW+r0/aN3VoiuyjlelNxgYn5zVHvzsUk72o44yAUklzcviQGbeLcCUe7tUet
         JFVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4i0BYB0elUrQ8nMkTes2DS3sYOQi6/KyXR/BCwwYT64=;
        b=oil9XmnpRUYLKTedMczSbcYrRv2lqZP9FZD8GM0TpFllqA1/Tt7uXe0inSMrpcdSCj
         45D1pRBp0KCMatz6v2xw18nKNtdAvXtLHz6LQNIQHRU39DMgqDiRhcMPNl8bkv9S3dgh
         UqKbeXvSDP4GUHZCXCmQJCu/dbm/RGnZAq+yDOznvd/YkOSWo1CnLo21Y/g5/nLxb4lk
         HXDFxlRTkrCiyb5H+8FqMY6VTeVBlUgmFMbYOWuMKzb52a0A2KNCootj4tuE2R410omL
         incGmWvoBt3YvM2nv8CNtz44QRidhR45fyPkkEPlbUlsA2NlAKEJhU9uKg+ZY89P1fL2
         vcEw==
X-Gm-Message-State: APjAAAVxz0VboLdyZHVhWyWVYE2CeOy9SDPxo8du/d/Z9j0H9APYwg67
        7FOU/YNbZ+DFHM1/T+lu77aY0sJahseCh6KvQQg=
X-Google-Smtp-Source: APXvYqwQ0EX2hPU1Z1utfKYzHe0ctpPrUqZMNUREer2KGJnMC9jI+lDJjoIiYjMGCIq6Sq1kaWk2oyIX8Ut5kQy4+Cs=
X-Received: by 2002:a05:620a:5b0:: with SMTP id q16mr6299544qkq.212.1559149362828;
 Wed, 29 May 2019 10:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190529000113.49334-1-cpaasch@apple.com> <20190529000744.GA12783@kroah.com>
 <20190529001421.GB49807@MacBook-Pro-64.local> <20190529005639.GA16732@kroah.com>
In-Reply-To: <20190529005639.GA16732@kroah.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 29 May 2019 10:02:04 -0700
Message-ID: <CALDO+SZcE9AAbdo4yHz=_=yhOQ5qdRVCbSAjvhfPd_-4YpG6Uw@mail.gmail.com>
Subject: Re: [PATCH v4.14.x] net: erspan: fix use-after-free
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 5:56 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 28, 2019 at 05:14:21PM -0700, Christoph Paasch wrote:
> > On 28/05/19 - 17:07:44, Greg KH wrote:
> > > On Tue, May 28, 2019 at 05:01:13PM -0700, Christoph Paasch wrote:
> > > > When building the erspan header for either v1 or v2, the eth_hdr()
> > > > does not point to the right inner packet's eth_hdr,
> > > > causing kasan report use-after-free and slab-out-of-bouds read.
> > > >
> > > > The patch fixes the following syzkaller issues:
> > > > [1] BUG: KASAN: slab-out-of-bounds in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> > > > [2] BUG: KASAN: slab-out-of-bounds in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> > > > [3] BUG: KASAN: use-after-free in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> > > > [4] BUG: KASAN: use-after-free in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> > > >
> > > > [2] CPU: 0 PID: 3654 Comm: syzkaller377964 Not tainted 4.15.0-rc9+ #185
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > Call Trace:
> > > >  __dump_stack lib/dump_stack.c:17 [inline]
> > > >  dump_stack+0x194/0x257 lib/dump_stack.c:53
> > > >  print_address_description+0x73/0x250 mm/kasan/report.c:252
> > > >  kasan_report_error mm/kasan/report.c:351 [inline]
> > > >  kasan_report+0x25b/0x340 mm/kasan/report.c:409
> > > >  __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:440
> > > >  erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> > > >  erspan_xmit+0x3b8/0x13b0 net/ipv4/ip_gre.c:740
> > > >  __netdev_start_xmit include/linux/netdevice.h:4042 [inline]
> > > >  netdev_start_xmit include/linux/netdevice.h:4051 [inline]
> > > >  packet_direct_xmit+0x315/0x6b0 net/packet/af_packet.c:266
> > > >  packet_snd net/packet/af_packet.c:2943 [inline]
> > > >  packet_sendmsg+0x3aed/0x60b0 net/packet/af_packet.c:2968
> > > >  sock_sendmsg_nosec net/socket.c:638 [inline]
> > > >  sock_sendmsg+0xca/0x110 net/socket.c:648
> > > >  SYSC_sendto+0x361/0x5c0 net/socket.c:1729
> > > >  SyS_sendto+0x40/0x50 net/socket.c:1697
> > > >  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
> > > >  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
> > > >  entry_SYSENTER_compat+0x54/0x63 arch/x86/entry/entry_64_compat.S:129
> > > > RIP: 0023:0xf7fcfc79
> > > > RSP: 002b:00000000ffc6976c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
> > > > RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020011000
> > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020008000
> > > > RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > >
> > > > Commit b423d13c08a6 ("net: erspan: fix use-after-free") fixed the
> > > > use-after-free. The root-cause change (commit 84e54fe0a5ea ("gre:
> > > > introduce native tunnel support for ERSPAN")) made it into 4.14.
> > > >
> > > > Thus, the fix needs to be backported to 4.14 as well.
> > > >
> > > > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> > > > Cc: William Tu <u9012063@gmail.com>
> > > > Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> > > > ---
> > > >
> > > > Notes:
> > > >     This should *only* go into 4.14.
> > >
> > > What is the git commit id of this patch in Linus's tree?
> >
> > It is b423d13c08a6 ("net: erspan: fix use-after-free").
> >
> > The cherry-pick to 4.14 does not work though, which is why I sent this patch
> > here.
>
> Not a problem, I just needed the original git commit id :)
>
> Now queued up, thanks!
>
> greg k-h

Thanks a lot.
William
