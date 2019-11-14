Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F7FC0B7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 08:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKNHZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 02:25:27 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44874 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNHZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 02:25:27 -0500
Received: by mail-lj1-f196.google.com with SMTP id g3so5466022ljl.11
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 23:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=1yYV0bPUSlqHOeI0zl/lEy2SN8LGudYiXF9DAXrq+dI=;
        b=ScqPq9qTgZ0Knk9hpX+AW4jufTbEG7TF3ESilpLKi/HzEQkPM9PvB8Edqryu/hi/FA
         b3nkVctagUtvIq48VsJzv9S5eTVy72ZuPQyk9o3XBDLO3dKpyxwdzxdqc3h2i+B8PtjN
         /Y1b/1Krc7mb8pt+GG4jp3C0nnYU5fHiQiSGc3gwIb9xu57MV1D6F4TRGmryyAuyWjbd
         Cf3bW+7uWawhPJWLIoOILKQGx3YynTr6qB6Y/0N8oilrFNP442x4gShj2aSbwAE7SnhW
         nP915zaOK7ELdq879nLfuqkPUkOanDEx/jpDdgmjsqKy6fVMrVbeWhnMN+2WvJnw11Ia
         Nv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=1yYV0bPUSlqHOeI0zl/lEy2SN8LGudYiXF9DAXrq+dI=;
        b=L+HDkQhdrwjAYz8pbd8dD3s1YbBtgGVJ3d34PIIc4KiAuLzH0CO6jWPKM3/R3+ZAuf
         PavtOPW63/saAPDNAPY+9VJdapXdcwvjQffsSfntxkZ03+Hg+nfnBzxhCkptn6VblGav
         IZep89gCEYXpcJe0LTe+H5/QVwEsVhL1CFBG4qqMEwqAamqNj2/rPqRTECG1QNg6x4gU
         hSapdZ+EI8nEcPEuwYmo1Hd0iu0ntv5Otci2X4Ctw87vnIyElJhs82WXMzPSoz3+ZFcX
         xSA8hd968vzSFa3rCfqcIIa07QV8fR9Z+pnGJmxQg30n9qjVY4k/B8CkUSGVVl0mQEBr
         GQiw==
X-Gm-Message-State: APjAAAWLPftFc7GEFCu4LZjCawb4u7BHRqFs0/kjDhmN8oToM4JHz59e
        TFOv3/qF7jFu4/KzERBM2f8LJg==
X-Google-Smtp-Source: APXvYqxeqV6QEFg4iKDxprWWj2SjNXyDJMtoO9/I0BfNJfRAKRzZb17q5boNkQU6TFHKEoAqF7cYBA==
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr5388833lja.28.1573716325100;
        Wed, 13 Nov 2019 23:25:25 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id e27sm2229127lfb.79.2019.11.13.23.25.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Nov 2019 23:25:24 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] slip: Fix memory leak in slip_open error path
References: <20191113114502.22462-1-jouni.hogander@unikie.com>
Date:   Thu, 14 Nov 2019 09:25:23 +0200
In-Reply-To: <20191113114502.22462-1-jouni.hogander@unikie.com> (jouni
        hogander's message of "Wed, 13 Nov 2019 13:45:02 +0200")
Message-ID: <87sgmqapi4.fsf@unikie.com>
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
> Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
> by Syzkaller in slcan. Same issue exists in slip.c and this patch is
> addressing the leak in slip.c.
>
> Here is the slcan memory leak trace reported by Syzkaller:
>
> BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
>   comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
>   hex dump (first 32 bytes):
>     73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>   backtrace:
>     [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
>     [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
>     [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
>     [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
>     [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
>     [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
>     [<000000004de5a617>] tty_ioctl+0x48d/0x1590
>     [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
>     [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
>     [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
>     [<0000000053d0332e>] do_syscall_64+0x16f/0x580
>     [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<000000008ea75434>] 0xfffffffffffffff
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> ---
>  drivers/net/slip/slip.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index cac64b96d545..4d479e3c817d 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -855,6 +855,7 @@ static int slip_open(struct tty_struct *tty)
>  	sl->tty =3D NULL;
>  	tty->disc_data =3D NULL;
>  	clear_bit(SLF_INUSE, &sl->flags);
> +	free_netdev(sl->dev);
>=20=20
>  err_exit:
>  	rtnl_unlock();

Observed panic in another error path in my overnight Syzkaller run with
this patch. Better not to apply it. Sorry for inconvenience.

BR,

Jouni H=C3=B6gander
