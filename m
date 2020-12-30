Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAD2E75A7
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 03:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgL3CRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 21:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgL3CRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 21:17:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23350207BC;
        Wed, 30 Dec 2020 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609294586;
        bh=oUNmX9K1sjX1Pd+53+tCljU6M3XP2N9ahjtoaXNssA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WITC0uptGLEVI+E+JXB+ZuYOeSnC4i7dmNEc/9SOLW+gNNoIX5cT1hZHWhPZf/fv8
         P4vEi8RyI5a/28E4s3byfszyUI7FfdC/izY8TuVm3wmePPYWXP9Sk/TYpMpTv4Ui0l
         v451Fx2Iff+EyWiTIuxyaOOJoBkjtN1dQKvcvHyIWKT+5lLyysYXkVDNJiyLvAZvHo
         AoeC8SIZupGouJ1pg99nQ5aMai4O5ZfipsyDf+XyC1J3r0Malvmc4BmtftHvL/qKa9
         CoyUefOBtnP0mGQ7wxpPK3TLxh5AycQ2yzc8/+idB5ilHGJ1SLOj1aaPXYe/pCl8i9
         9qMZzMA3Z42Gw==
Date:   Tue, 29 Dec 2020 18:16:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tom Herbert <tom@herbertland.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: inconsistent lock state in ila_xlat_nl_cmd_add_mapping
Message-ID: <20201229181625.219a9693@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUzEgWYzW4BAih9M0JnPjZs+hESpCv-gkEKWc4s1SMV2A@mail.gmail.com>
References: <000000000000b14d8c05735dcdf8@google.com>
        <20201229173730.65f74253@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUzEgWYzW4BAih9M0JnPjZs+hESpCv-gkEKWc4s1SMV2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Dec 2020 17:52:56 -0800 Cong Wang wrote:
> On Tue, Dec 29, 2020 at 5:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 13 Aug 2018 21:40:03 -0700 syzbot wrote:  
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    78cbac647e61 Merge branch 'ip-faster-in-order-IP-fragments'
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14df4828400000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9100338df26ab75
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=eaaf6c4a6a8cb1869d86
> > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=13069ad2400000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+eaaf6c4a6a8cb1869d86@syzkaller.appspotmail.com  
> >
> > #syz invalid
> >
> > Hard to track down what fixed this, but the lockdep splat is mixing up
> > locks from two different hashtables, so there was never a real issue
> > here.  
> 
> This one is probably fixed by:
> 
> commit ff93bca769925a2d8fd7f910cdf543d992e17f07
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Tue Aug 14 15:21:31 2018 -0700
> 
>     ila: make lockdep happy again
> 
> given the time of last reproducing...

Ah, yes, matches perfectly! I didn't look for fixes in spinlock.h.

Thanks!
