Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF131CFC1
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhBPR6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:58:02 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:52248 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhBPR54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 12:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613497832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x6vLcN+xqMivEhRJClR/OiRKsu8E4NuYns8fLQSOv1Q=;
        b=XSd24Z36dyguJIhuYmlHtrumRpIqSyube+ePKhS94bbrycLZSLS/oO1xt/ajCZ6TDSlMnU
        idpOeGvX7pZQQNyb+NgpYjwfzvtYlIljIb+Noy2b8AU6WxPfQLa7JSmbgt+K8k2gcDpSAw
        Q5n96xcd5w6uVbC4svIBFEyy+H4dSZo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 005f1d5a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 16 Feb 2021 17:50:32 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id p193so11271825yba.4;
        Tue, 16 Feb 2021 09:50:32 -0800 (PST)
X-Gm-Message-State: AOAM532VHOSnLXsQDktJSZmQIFjiGQQ1H2gYJ2X/aMlPdQhaz0C881HC
        Y1tViwk/TzEgbipL5W80iLR5wgJIrm1WWiWea/8=
X-Google-Smtp-Source: ABdhPJwHt58xFP7YNMEve7qalwe99uM3eNJOjQyTF4f4AMRjItfs/mCB7J7f54GmIkOIxJqYe9dl3LeVEr9k0RC2Z58=
X-Received: by 2002:a25:b74c:: with SMTP id e12mr34153553ybm.20.1613497831569;
 Tue, 16 Feb 2021 09:50:31 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000be4d705bb68dfa7@google.com> <20210216172817.GA14978@arm.com>
 <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
In-Reply-To: <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 16 Feb 2021 18:50:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com>
Message-ID: <CAHmME9ob9g-pcsKU2=n2SOzjNwyGh9+dL-WGpQn4Da+DD4dPzA@mail.gmail.com>
Subject: Re: KASAN: invalid-access Write in enqueue_timer
To:     Netdev <netdev@vger.kernel.org>
Cc:     syzbot <syzbot+95c862be69e37145543f@syzkaller.appspotmail.com>,
        Mark Brown <broonie@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, mbenes@suse.cz,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Catalin,
>
> On Tue, Feb 16, 2021 at 6:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Adding Jason and Ard. It may be a use-after-free in the wireguard
> > driver.
>
> Thanks for sending this my way. Note: to my knowledge, Ard doesn't
> work on wireguard.
>
> > >  hlist_add_head include/linux/list.h:883 [inline]
> > >  enqueue_timer+0x18/0xc0 kernel/time/timer.c:581
> > >  mod_timer+0x14/0x20 kernel/time/timer.c:1106
> > >  mod_peer_timer drivers/net/wireguard/timers.c:37 [inline]
> > >  wg_timers_any_authenticated_packet_traversal+0x68/0x90 drivers/net/wireguard/timers.c:215
>
> The line of hlist_add_head that it's hitting is:
>
> static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
> {
>        struct hlist_node *first = h->first;
>        WRITE_ONCE(n->next, first);
>        if (first)
>
> So that means it's the dereferencing of h that's a problem. That comes from:
>
> static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
>                          unsigned int idx, unsigned long bucket_expiry)
> {
>
>        hlist_add_head(&timer->entry, base->vectors + idx);
>
> That means it concerns base->vectors + idx, not the timer_list object
> that wireguard manages. That's confusing. Could that imply that the
> bug is in freeing a previous timer without removing it from the timer
> lists, so that it winds up being in base->vectors?
>
> The allocation and deallocation backtrace is confusing
>
> > >  alloc_netdev_mqs+0x5c/0x3bc net/core/dev.c:10546
> > >  rtnl_create_link+0xc8/0x2b0 net/core/rtnetlink.c:3171
> > >  __rtnl_newlink+0x5bc/0x800 net/core/rtnetlink.c:3433
>
> This suggests it's part of the `ip link add wg0 type wireguard` nelink
> call, during it's allocation of the netdevice's private area. For
> this, the wg_device struct is used. It has no timer_list structures in
> it!
>
> Similarly,
>
> > >  netdev_freemem+0x18/0x2c net/core/dev.c:10500
> > >  netdev_release+0x30/0x44 net/core/net-sysfs.c:1828
> > >  device_release+0x34/0x90 drivers/base/core.c:1980
>
> That smells like `ip link del wg0 type wireguard`. But again,
> wg_device doesn't have any timer_lists in it.
>
> So what's happening here exactly? I'm not really sure yet...
>
> It'd be nice to have a reproducer.
>
>
> Jason


Digging around on syzkaller, it looks like there's a similar bug on
jbd2, concerning iptunnels's allocation:

https://syzkaller.appspot.com/text?tag=CrashReport&x=13afb19cd00000

And one from ext4:

https://syzkaller.appspot.com/text?tag=CrashReport&x=17685330d00000

And from from ext4 with fddup:

https://syzkaller.appspot.com/text?tag=CrashReport&x=17685330d00000
https://syzkaller.appspot.com/text?tag=CrashReport&x=12d326e8d00000

It might not actually be a wireguard bug?
