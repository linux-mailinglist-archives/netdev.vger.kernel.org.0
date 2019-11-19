Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6F0102028
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSJXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:23:23 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40829 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKSJXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:23:22 -0500
Received: by mail-lf1-f65.google.com with SMTP id v24so5502393lfi.7
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=vEC81GcLttEcJAjNdIB9ExJmxUvRup+AThBWqWVUKJs=;
        b=JUpcFk6rJA46S/I6GusqCj/PQ985nXzbFTn8a30qh1FMxth5gfELLgoZq+Pob+6xmS
         Z1HAEmAracreUslwnirYP1yIk5BxCHQs1oqfoio1ewjc8Cg/RU8OsYjupMiThdakA5Ai
         tQdl5CtF9bsJxqfMioyKPQjyV0i6tAJ1sK0P8NV25UeeAya592YGtHGgDRAQ/CoMkLp9
         8WSK93TRciKx3CXPKI2b5Q8+drPFt4S8+1vfwvlWZLWf3P7UsZ1ugnnwVI5m5PRpesv2
         fS6IQtmwBiRCDUwjHx1+n+BHpq6fooRIgUTRt8OXRHi6EqdPYWzlks5nWnEGekI6IZ96
         25cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=vEC81GcLttEcJAjNdIB9ExJmxUvRup+AThBWqWVUKJs=;
        b=qwbHoFCB9d/ygzmufjAXrZuhvsAGbhkJwpBo5CxBbbPV6kdRLWcMDkCMbXi3Wpni/0
         T8CUCBS+CyVBecw1IIyiLzDiyLeN+1dcI/6njXvwRFcyQCuxyE1DNjoniUeoQMJHkwmm
         6U5DhoYqiPZelJGCZwcYDyv0lk6z4HE4giCe2kYvoNEfFrLhCNhfbJI8uXhNRrBD6aAJ
         U9JbMUh7UAwIozSaMl2msHC/DpmffubyvXByVOTKZ+ImXRsUUU9TtD11hKfXzOPBi316
         iSNqj0dl6BODTQY0yyCnbSxM5xuke+Agid35igedWYfdcCGWQmQtlo8iE3Qn8ZLDfdf5
         p6HA==
X-Gm-Message-State: APjAAAUMIOd9sE6A9tlbfFJuuC7xQ6Hc7DiN8HrkQX930rnBSOFYbD0M
        xYieLSrHnMQ68CVS1zZ8SJ0+Fg==
X-Google-Smtp-Source: APXvYqz+znk21ZeWTGR59C/2gLajA7W6WAiuVbp81pij031nrln0Ps4u4OLZy+4wn9735BBEeKkj2w==
X-Received: by 2002:a19:5e06:: with SMTP id s6mr2933229lfb.176.1574155400032;
        Tue, 19 Nov 2019 01:23:20 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id w20sm9947665lff.46.2019.11.19.01.23.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 01:23:19 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] net-sysfs: Fix memory leak in register_queue_kobjects
References: <20191114111325.2027-1-jouni.hogander@unikie.com>
Date:   Tue, 19 Nov 2019 11:23:18 +0200
In-Reply-To: <20191114111325.2027-1-jouni.hogander@unikie.com> (jouni
        hogander's message of "Thu, 14 Nov 2019 13:13:25 +0200")
Message-ID: <871ru4rzi1.fsf@unikie.com>
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
> net_rx_queue_update_kobjects and netdev_queue_update_kobjects are
> leaking memory in their error paths. Leak was originally reported
> by Syzkaller:
>
> BUG: memory leak
> unreferenced object 0xffff8880679f8b08 (size 8):
>   comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
>   hex dump (first 8 bytes):
>     72 78 2d 30 00 36 20 d4                          rx-0.6 .
>   backtrace:
>     [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
>     [<000000001f2e4e49>] kvasprintf+0xb1/0x140
>     [<000000007f313394>] kvasprintf_const+0x56/0x160
>     [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
>     [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
>     [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
>     [<000000006be5f104>] netdev_register_kobject+0x210/0x380
>     [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
>     [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
>     [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
>     [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
>     [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
>     [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
>     [<0000000038d946e5>] do_syscall_64+0x16f/0x580
>     [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [<00000000285b3d1a>] 0xffffffffffffffff
>
> Cc: David Miller <davem@davemloft.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
> ---
>  net/core/net-sysfs.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 865ba6ca16eb..2f44c6a3bcae 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -923,20 +923,25 @@ static int rx_queue_add_kobject(struct net_device *=
dev, int index)
>  	error =3D kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
>  				     "rx-%u", index);
>  	if (error)
> -		return error;
> +		goto err_init_and_add;
>=20=20
>  	dev_hold(queue->dev);
>=20=20
>  	if (dev->sysfs_rx_queue_group) {
>  		error =3D sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
> -		if (error) {
> -			kobject_put(kobj);
> -			return error;
> -		}
> +		if (error)
> +			goto err_sysfs_create;
>  	}
>=20=20
>  	kobject_uevent(kobj, KOBJ_ADD);
>=20=20
> +	return error;
> +
> +err_sysfs_create:
> +	kobject_put(kobj);
> +err_init_and_add:
> +	kfree_const(kobj->name);
> +
>  	return error;
>  }
>  #endif /* CONFIG_SYSFS */
> @@ -968,6 +973,7 @@ net_rx_queue_update_kobjects(struct net_device *dev, =
int old_num, int new_num)
>  		if (dev->sysfs_rx_queue_group)
>  			sysfs_remove_group(kobj, dev->sysfs_rx_queue_group);
>  		kobject_put(kobj);
> +		kfree_const(kobj->name);
>  	}
>=20=20
>  	return error;
> @@ -1461,21 +1467,28 @@ static int netdev_queue_add_kobject(struct net_de=
vice *dev, int index)
>  	error =3D kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>  				     "tx-%u", index);
>  	if (error)
> -		return error;
> +		goto err_init_and_add;
>=20=20
>  	dev_hold(queue->dev);
>=20=20
>  #ifdef CONFIG_BQL
>  	error =3D sysfs_create_group(kobj, &dql_group);
> -	if (error) {
> -		kobject_put(kobj);
> -		return error;
> -	}
> +	if (error)
> +		goto err_sysfs_create;
>  #endif
>=20=20
>  	kobject_uevent(kobj, KOBJ_ADD);
>=20=20
>  	return 0;
> +
> +#ifdef CONFIG_BQL
> +err_sysfs_create:
> +	kobject_put(kobj);
> +#endif
> +err_init_and_add:
> +	kfree_const(kobj->name);
> +
> +	return error;
>  }
>  #endif /* CONFIG_SYSFS */
>=20=20
> @@ -1503,6 +1516,7 @@ netdev_queue_update_kobjects(struct net_device *dev=
, int old_num, int new_num)
>  		sysfs_remove_group(&queue->kobj, &dql_group);
>  #endif
>  		kobject_put(&queue->kobj);
> +		kfree_const(queue->kobj.name);
>  	}
>=20=20
>  	return error;

This patch should be ignored. Rootcause for this memory leak is
reference count leak. I will upload another patch.

BR,

Jouni H=C3=B6gander
