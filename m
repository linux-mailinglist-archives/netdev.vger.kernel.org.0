Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3188A108DD4
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKYM2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:28:23 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37057 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKYM2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:28:23 -0500
Received: by mail-lj1-f193.google.com with SMTP id d5so15622084ljl.4
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 04:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=inHvDeBT9sUP8CZpHgcs2JN0V5pw7oSvGV4CG4Amh1I=;
        b=JYLXuYYBlOuRC9heyk4cMp912nDZj3P3Ctwn5a+zbbXZzNm0IZusObuQF/RZ1CawNB
         XaC5A/3EQ4U/F+1b6L2Xj3r3sGP7vXj2cjWnIcxlI1BE6eugiS2PX1l21D5zgNNEFg2d
         aYYJ7INkSde/9YkJ8DC6SXWK+Q/nNqTMkH4ryMCg2diN46W21p9igclg+fB7ULNdd+Fk
         RyE24pXHLv2BakNFejV5YTijfRuc4NCXHvWLsUpKPM+EfXyoAyp6IFiyj9/TaH8yoAJ5
         w3hbI3IPB5QjT1r0O+XORCLlgXU0ntKNaQycoHl5dnnV2yEh/9vhimP+t62hBOBljjyu
         Wb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=inHvDeBT9sUP8CZpHgcs2JN0V5pw7oSvGV4CG4Amh1I=;
        b=uYl3vXHDR3oWLHpvtJBQr00o+4G+Nl7c5y+FSO5WD1WaRLp/5kuGQby6GRTe1MF1H0
         y0BUwTe/c44AmjiCCqcwflh/HsDO/ApjzvhnT+2O85cOkqTPMG8Nbe4k4RDKzEbQsfGl
         rhY2v1mWAOWDUROau9PQNcFFpj5fDD7nnhiHY0Qc53nPDDY1li4HkfYSfu60zUoen/0Q
         OlW/gz0OamIALbW+8QqXM8966bJNxinMX9D/J0XIoelkxwz5etvg9PFhEwwH3duyVc7W
         4kGx/XGryMuUOGaqdkbd60OdMalN0+3UAQMb6SYQGMzFOKQTGPFRkvTkRpAdoEKaCrSQ
         KOAg==
X-Gm-Message-State: APjAAAWVOa14mrwsGUvAhT7HwM45VDdR/KpOR0fgDWhtlnOprWe88b06
        vz7ZSogRjvjpKXJKPZXKo6zenA==
X-Google-Smtp-Source: APXvYqxjOJ4D4W+qfdg+YnJInPmB/NLHZUX8b8JJKT2YKwQxqm9jaRYqvsehm9hlpd5N1ztG30HP1A==
X-Received: by 2002:a2e:9904:: with SMTP id v4mr22093525lji.211.1574684901157;
        Mon, 25 Nov 2019 04:28:21 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id s11sm3844065ljo.42.2019.11.25.04.28.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Nov 2019 04:28:20 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] slip: Fix use-after-free Read in slip_open
References: <20191125122343.17904-1-jouni.hogander@unikie.com>
Date:   Mon, 25 Nov 2019 14:28:14 +0200
In-Reply-To: <20191125122343.17904-1-jouni.hogander@unikie.com> (jouni
        hogander's message of "Mon, 25 Nov 2019 14:23:43 +0200")
Message-ID: <87sgmcqgwx.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

jouni.hogander@unikie.com writes:

> From: Jouni Hogander <jouni.hogander@unikie.com>
>
> Slip_open doesn't clean-up device which registration failed from the
> slip_devs device list. On next open after failure this list is iterated
> and freed device is accessed. Fix this by calling sl_free_netdev in error
> path.
>
> Here is the trace from the Syzbot:
>
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x197/0x210 lib/dump_stack.c:118
> print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:3=
74
> __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> kasan_report+0x12/0x20 mm/kasan/common.c:634
> __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
> sl_sync drivers/net/slip/slip.c:725 [inline]
> slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
> tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
> tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
> tiocsetd drivers/tty/tty_io.c:2334 [inline]
> tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
> vfs_ioctl fs/ioctl.c:46 [inline]
> file_ioctl fs/ioctl.c:509 [inline]
> do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
> ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> __do_sys_ioctl fs/ioctl.c:720 [inline]
> __se_sys_ioctl fs/ioctl.c:718 [inline]
> __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Fixes: 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
> Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com

Unfortunately I'm not able to reproduce this by myself. But to my
understanding scenario described above is possible path to this
use-after-free bug.

> Cc: David Miller <davem@davemloft.net>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> ---
>  drivers/net/slip/slip.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 4d479e3c817d..2a91c192659f 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -855,6 +855,7 @@ static int slip_open(struct tty_struct *tty)
>  	sl->tty =3D NULL;
>  	tty->disc_data =3D NULL;
>  	clear_bit(SLF_INUSE, &sl->flags);
> +	sl_free_netdev(sl->dev);
>  	free_netdev(sl->dev);
>=20=20
>  err_exit:

BR,

Jouni H=C3=B6gander
