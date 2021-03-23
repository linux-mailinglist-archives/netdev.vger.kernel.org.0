Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9364A3459F9
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCWInN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCWImz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:42:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78828C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:42:54 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id o126so15927292lfa.0
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KvXtpgBV+o0JWe0JLX80jWIOlIgv/hChx1EfXJmTnY=;
        b=KfdDw9VWZ0tKw+l8GaukOPXg6ZbEHyoOODvQSgCeIcYYqavYmAOqSenci3vKUFLVNb
         C3bld4+W2qSuYA62ZUiSF5krZWl5kxo/h/ooTc5X7fTiHEaxfDiRRDBIPQ+zb6T2oYWV
         x9IYNJfVUkAT185M0owa10SxtDmL/DS0xSgPHJ/MBkNrb8qgq6xgV/S11vnP2xNvgBwo
         ltbyvOgejpeB/CEOAoF9zBwnsEW4pyw9xm5zWQxz8ebv2tP9Q2knj4Aob3vnaZZIHVEO
         OYYvU9eymYg6E3H+ZBI/DZGtaGkz5tEMMqtwvREKgzY2AVLKLvDwTsgoURDkvBndwN5Q
         3/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KvXtpgBV+o0JWe0JLX80jWIOlIgv/hChx1EfXJmTnY=;
        b=b/JvqNtkMq6LdrIUCP+HZNzsB7+LHtYM4D3jEitRFWSX/0U2WH1FAo4aGhfRMnIcAj
         Maj+Ddn8E/CGpt4KApjqz8XoJmf9jsf+Pxd2xaudsgXErcPEaJyaXKpy/tcTYo5SSkjx
         WMku71y6aCK5LdfkqLF9M1iVzk8/o5Qrq/P1dMQEpcB/AzPuILOVpOr3XZwec+isciUJ
         3sT3f2Orqo9jd5aQZxambEYmBE2vEAPALIRBTR5lsD1/+OTdFfU8oZLotqrt/YU/Vf+J
         7OXX/eac+t+bKKypJiR+cSpwSDsjXgTuGF3tfuuAU7Yt5qRpnW4SHdRiOYc35WTOPStB
         pAVw==
X-Gm-Message-State: AOAM530js1LuIN1ciAJoVN9UibLyZql9yHr0xdOSeIH5dX93xmd1ePeF
        VYen4UKAGikI4wK2JWzR/2wU/pvf6/0/yNKoUH/wRA==
X-Google-Smtp-Source: ABdhPJwcUoeiaX6sIYtYHpkMy8oKnz7DMhqc0vUTMdQp5OfWbSKn+ehdHmCBQSKWTEAZRZdbthEehBXYfvAtA65UElI=
X-Received: by 2002:a19:cd2:: with SMTP id 201mr1943875lfm.451.1616488972619;
 Tue, 23 Mar 2021 01:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210322140046.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
 <559FCF7C-A929-4291-956C-EF776EFAA47D@holtmann.org>
In-Reply-To: <559FCF7C-A929-4291-956C-EF776EFAA47D@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Tue, 23 Mar 2021 16:42:41 +0800
Message-ID: <CAJQfnxEh=xPgXkRu+E3amBKbV=B2+8QevyDDE=gNE8Y-oSmTNw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: check for zapped sk before connecting
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Thanks for your suggestion. I implemented it in v2, please take another look.


On Mon, 22 Mar 2021 at 23:53, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > There is a possibility of receiving a zapped sock on
> > l2cap_sock_connect(). This could lead to interesting crashes, one
> > such case is tearing down an already tore l2cap_sock as is happened
> > with this call trace:
> >
> > __dump_stack lib/dump_stack.c:15 [inline]
> > dump_stack+0xc4/0x118 lib/dump_stack.c:56
> > register_lock_class kernel/locking/lockdep.c:792 [inline]
> > register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
> > __lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
> > lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
> > __raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
> > _raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
> > spin_lock_bh include/linux/spinlock.h:307 [inline]
> > lock_sock_nested+0x44/0xfa net/core/sock.c:2518
> > l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
> > l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
> > l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
> > l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
> > process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
> > worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
> > kthread+0x291/0x2a6 kernel/kthread.c:211
> > ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Reviewed-by: Guenter Roeck <groeck@chromium.org>
> > ---
> >
> > net/bluetooth/l2cap_sock.c | 7 +++++++
> > 1 file changed, 7 insertions(+)
> >
> > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > index f1b1edd0b697..b86fd8cc4dc1 100644
> > --- a/net/bluetooth/l2cap_sock.c
> > +++ b/net/bluetooth/l2cap_sock.c
> > @@ -182,6 +182,13 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
> >
> >       BT_DBG("sk %p", sk);
> >
> > +     lock_sock(sk);
> > +     if (sock_flag(sk, SOCK_ZAPPED)) {
> > +             release_sock(sk);
> > +             return -EINVAL;
> > +     }
> > +     release_sock(sk);
> > +
>
> hmmm. I wonder if this would look better and easy to see that the locking is done correctly.
>
>         lock_sock(sk);
>         zapped = sock_flag(sk, SOCK_ZAPPED);
>         release_sock(sk);
>
>         if (zapped)
>                 return -EINVAL;
>
> Regards
>
> Marcel
>
