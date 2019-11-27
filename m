Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9B10AAA9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 07:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfK0G1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 01:27:41 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44915 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfK0G1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 01:27:40 -0500
Received: by mail-io1-f65.google.com with SMTP id j20so23457774ioo.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 22:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uOaaFx9BijN3oRGoikP42pmSRVP9k4AtwliF5KEt1cw=;
        b=JDwjT0zUwJyLVEzo8+TrELStnLNUrmVRo8pwACqNWWnMhFedLuT5ZkoJQzeaBqlVjC
         KMljZQvVcjBAzYDMyQHgEkS5UIsKNNG0wz9bndVtIzCjDTtACqSi61xSIF+i235gQqDe
         3BLoBBHIyRmi8AuajVrUwIb+cphikg8bJjp7UNw/OCmDyNE21hztyqDpj//c6sqFkxis
         vi/9nKb0ZOIUd601SK/wOO9UDUP5D4ppU19tNdw9DLCbEzSoQv2nMp6DZUqH9dMfgSON
         Qbl+zRpU53hUodN3O2hqDUtbCOQ15zPnIM0eej5DggKAgcqhKAIJBw47KfUJNjSRgr/W
         qNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uOaaFx9BijN3oRGoikP42pmSRVP9k4AtwliF5KEt1cw=;
        b=EQfgTXhAWTenJmoRN3AB7DakVSUbY9MVbyZRn47gDcF3/JPQKaasEKJhB6Hl0OKS31
         h/ucA+mEsjQsooX8rAJ8VZds3SAL8EADAyF6PKMUVFdu1/OcTO88HkSdtt64aV9xmjiQ
         bCtbSP7/Jwp9C06EkYKunIe3y4l3BOswuPSrqp6AcCiM468nQkVdbtsz+uPM7t3Ro1j4
         fp4MivTywbSUN78TzvX51jJWobh4jN676yAGQgkF5gr+BZLjokPfcxEwOwtddgRZk9nU
         W/S2N6ANRp5C/qpX/W6QaS033IYypKr8Ks1/yBlK+MDtX8jG91kVWHypC9LAKkh4hz8e
         o4mg==
X-Gm-Message-State: APjAAAWaJIwWyPTL8iqDInZSwR1t1TO5Qrl6PTNx5fSMCeF90P588is7
        2sBdLLROARk4wiymvM9vX2F8SlFcor/482JlLLo=
X-Google-Smtp-Source: APXvYqwUOqyoYezq08CmmBoDVlnoRagy/XYWKVC1AL25ncll7M17Y9H+1YTArY54luhmWSPTzGlj/zfyNCQh4jYQKz8=
X-Received: by 2002:a02:3f10:: with SMTP id d16mr2648091jaa.139.1574836059762;
 Tue, 26 Nov 2019 22:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20191125122343.17904-1-jouni.hogander@unikie.com> <87sgmcqgwx.fsf@unikie.com>
In-Reply-To: <87sgmcqgwx.fsf@unikie.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Wed, 27 Nov 2019 07:27:30 +0100
Message-ID: <CAKXUXMwcdUPKsBZ6RNwjrsmiO7z3wWvOMBPvUaWhTrFZ6C6esA@mail.gmail.com>
Subject: Re: [PATCH] slip: Fix use-after-free Read in slip_open
To:     =?UTF-8?Q?Jouni_H=C3=B6gander?= <jouni.hogander@unikie.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 1:28 PM Jouni H=C3=B6gander
<jouni.hogander@unikie.com> wrote:
>
> jouni.hogander@unikie.com writes:
>
> > From: Jouni Hogander <jouni.hogander@unikie.com>
> >
> > Slip_open doesn't clean-up device which registration failed from the
> > slip_devs device list. On next open after failure this list is iterated
> > and freed device is accessed. Fix this by calling sl_free_netdev in err=
or
> > path.
> >
> > Here is the trace from the Syzbot:
> >
> > __dump_stack lib/dump_stack.c:77 [inline]
> > dump_stack+0x197/0x210 lib/dump_stack.c:118
> > print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c=
:374
> > __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> > kasan_report+0x12/0x20 mm/kasan/common.c:634
> > __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> > sl_sync drivers/net/slip/slip.c:725 [inline]
> > slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
> > tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
> > tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
> > tiocsetd drivers/tty/tty_io.c:2334 [inline]
> > tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
> > vfs_ioctl fs/ioctl.c:46 [inline]
> > file_ioctl fs/ioctl.c:509 [inline]
> > do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
> > ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> > __do_sys_ioctl fs/ioctl.c:720 [inline]
> > __se_sys_ioctl fs/ioctl.c:718 [inline]
> > __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> > do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
> > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Fixes: 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
> > Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com
>
> Unfortunately I'm not able to reproduce this by myself. But to my
> understanding scenario described above is possible path to this
> use-after-free bug.
>

As slcan copies some parts from slip, would this use-after-free bug
also occur with the sclan_open function?

The err_free_chan error path in slcan_open does exactly the same as in
slip, so would we also need to add sl_free_netdev(sl->dev) there,
right?

Jouni, could you submit an additional patch to slcan?


Lukas
