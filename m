Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68C231CFAE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBPRyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:54:38 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:52136 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhBPRyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 12:54:13 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2021 12:54:13 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613497606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EeUD0/Hrmkha1vgSjrxHXQGMMGTIAxd3b5RgI7gY5e4=;
        b=ipxFek+CTX1D/JoUVERmSDJlmYeA4+Y38dsHRKibMiaiDM396nBUW6wAAAqN9RXQE44SAH
        c38acytS63tsoIpYLXnl8L+ZP7qQTypLTPonbP12/lDrj5vlQDFvfx4mCR0LI4PF8K5/UO
        d3nn2yPgFxWYIiXNic1ircpgLM5208c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id adf77641 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 16 Feb 2021 17:46:45 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id r127so1847143ybr.1;
        Tue, 16 Feb 2021 09:46:45 -0800 (PST)
X-Gm-Message-State: AOAM5327vN98YWUTtVb+x60s79EznA5bjiHmQzk1AIjXLb6SCboEhJaD
        vkRsbVsRLyrMjCzkFzwtZ+oPaNAlvjwg2cX+ztQ=
X-Google-Smtp-Source: ABdhPJwhVsAUHKbqej3N09bli7Ip3Grj1LPSZWD38TPvdzb+CintSD1ow5bBZyachx1edPauzqXd/cvVVNds1A+cBKQ=
X-Received: by 2002:a25:80c9:: with SMTP id c9mr31610024ybm.279.1613497604734;
 Tue, 16 Feb 2021 09:46:44 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000be4d705bb68dfa7@google.com> <20210216172817.GA14978@arm.com>
In-Reply-To: <20210216172817.GA14978@arm.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 16 Feb 2021 18:46:34 +0100
X-Gmail-Original-Message-ID: <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
Message-ID: <CAHmME9q2-wbRmE-VgSoW5fxjGQ9kkafYH-X5gSVvgWESo5rm4Q@mail.gmail.com>
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

Hi Catalin,

On Tue, Feb 16, 2021 at 6:28 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> Adding Jason and Ard. It may be a use-after-free in the wireguard
> driver.

Thanks for sending this my way. Note: to my knowledge, Ard doesn't
work on wireguard.

> >  hlist_add_head include/linux/list.h:883 [inline]
> >  enqueue_timer+0x18/0xc0 kernel/time/timer.c:581
> >  mod_timer+0x14/0x20 kernel/time/timer.c:1106
> >  mod_peer_timer drivers/net/wireguard/timers.c:37 [inline]
> >  wg_timers_any_authenticated_packet_traversal+0x68/0x90 drivers/net/wireguard/timers.c:215

The line of hlist_add_head that it's hitting is:

static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
{
       struct hlist_node *first = h->first;
       WRITE_ONCE(n->next, first);
       if (first)

So that means it's the dereferencing of h that's a problem. That comes from:

static void enqueue_timer(struct timer_base *base, struct timer_list *timer,
                         unsigned int idx, unsigned long bucket_expiry)
{

       hlist_add_head(&timer->entry, base->vectors + idx);

That means it concerns base->vectors + idx, not the timer_list object
that wireguard manages. That's confusing. Could that imply that the
bug is in freeing a previous timer without removing it from the timer
lists, so that it winds up being in base->vectors?

The allocation and deallocation backtrace is confusing

> >  alloc_netdev_mqs+0x5c/0x3bc net/core/dev.c:10546
> >  rtnl_create_link+0xc8/0x2b0 net/core/rtnetlink.c:3171
> >  __rtnl_newlink+0x5bc/0x800 net/core/rtnetlink.c:3433

This suggests it's part of the `ip link add wg0 type wireguard` nelink
call, during it's allocation of the netdevice's private area. For
this, the wg_device struct is used. It has no timer_list structures in
it!

Similarly,

> >  netdev_freemem+0x18/0x2c net/core/dev.c:10500
> >  netdev_release+0x30/0x44 net/core/net-sysfs.c:1828
> >  device_release+0x34/0x90 drivers/base/core.c:1980

That smells like `ip link del wg0 type wireguard`. But again,
wg_device doesn't have any timer_lists in it.

So what's happening here exactly? I'm not really sure yet...

It'd be nice to have a reproducer.


Jason
