Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1431CFCD
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 19:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBPSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 13:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhBPSC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 13:02:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0EF064DA1;
        Tue, 16 Feb 2021 18:01:46 +0000 (UTC)
Date:   Tue, 16 Feb 2021 18:01:44 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+95c862be69e37145543f@syzkaller.appspotmail.com>,
        Mark Brown <broonie@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, mbenes@suse.cz,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: KASAN: invalid-access Write in enqueue_timer
Message-ID: <20210216180143.GB14978@arm.com>
References: <0000000000000be4d705bb68dfa7@google.com>
 <20210216172817.GA14978@arm.com>
 <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
 <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 06:50:20PM +0100, Jason A. Donenfeld wrote:
> On Tue, Feb 16, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On Tue, Feb 16, 2021 at 6:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > >  hlist_add_head include/linux/list.h:883 [inline]
> > > >  enqueue_timer+0x18/0xc0 kernel/time/timer.c:581
> > > >  mod_timer+0x14/0x20 kernel/time/timer.c:1106
> > > >  mod_peer_timer drivers/net/wireguard/timers.c:37 [inline]
> > > >  wg_timers_any_authenticated_packet_traversal+0x68/0x90 drivers/net/wireguard/timers.c:215
> >
> > The line of hlist_add_head that it's hitting is:
> >
> > static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
> > {
> >        struct hlist_node *first = h->first;
> >        WRITE_ONCE(n->next, first);
> >        if (first)
> >
> > So that means it's the dereferencing of h that's a problem. That comes from:
> >
> > static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
> >                          unsigned int idx, unsigned long bucket_expiry)
> > {
> >
> >        hlist_add_head(&timer->entry, base->vectors + idx);
> >
> > That means it concerns base->vectors + idx, not the timer_list object
> > that wireguard manages. That's confusing. Could that imply that the
> > bug is in freeing a previous timer without removing it from the timer
> > lists, so that it winds up being in base->vectors?

Good point, it's indeed likely that the timer list is messed up already,
just an unlucky encounter in the wireguard code.

> Digging around on syzkaller, it looks like there's a similar bug on
> jbd2, concerning iptunnels's allocation:
> 
> https://syzkaller.appspot.com/text?tag=CrashReport&x=13afb19cd00000
[...]
> It might not actually be a wireguard bug?

I wonder whether syzbot reported similar issues with
CONFIG_KASAN_SW_TAGS. It shouldn't be that different from the HW_TAGS
but at least we can rule out qemu bugs with the MTE emulation.

-- 
Catalin
