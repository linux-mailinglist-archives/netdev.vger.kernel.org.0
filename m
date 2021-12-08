Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977BC46D899
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhLHQju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhLHQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:39:50 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CDDC0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:36:18 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 133so2484462pgc.12
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Od81uDOA/1cOoeC9gPpV4qTKebptvhRPMM2Rpb89jFU=;
        b=xzv/CyrtFCNKAtk9Zzs8eIuoSdJIwWUrcJmWTac+uDtZB9bTYxU/lXeaQNN/Vl/W3M
         9gH/u14/A8JcWkv1QL5XxplCsFCzmd3Ia0w6XdOR5mH2jwVOSrEACHqo5T2eINgAsltd
         fwVD8hgnIijACC2cVsb9gleOOzXva+8hueE1DxFcyTRemcB5knsmEOKIFaPCO8fHiqr1
         8+A5YcUuGG7A2qdUklLS+BdeLQM1KXlDt1MAaREDxQS3eDSMTR0rCFiwFP+1QHzpSS/7
         0bNkUxpc75Ic7L/oAM3bef6WGkLplEonygTWAoAVxc29FQjqvcon49cRIKg1lzXUbD3x
         4AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Od81uDOA/1cOoeC9gPpV4qTKebptvhRPMM2Rpb89jFU=;
        b=4DmBhgJq5UeToTT2fyMTnXWZ8PzQwy4Tkr42A9mmXkz74DgKS+vmFDvdigDFQwfNc5
         6aL4K3UiVJ9+3TXxogBRNG6O5T4HH/kZHBny5quwIC6I3asVtSGcpBt2RpTz9aHOWNXY
         CNnLe8ch5wzTNU62WDT6H+DuI9kjH7dKLkIoig/ZSOZJCVMBXiz7qGLMYpTx4ktrYZGb
         bVixBlM0Ji7mHtDQueEAn9WFlmGp+79/39zd7kTPxRoQUOpZF/VzkkQL4xnjAKKC+Zwn
         cRmfXB4zYgmBnglnx1eXmN8MGuRt03X2qsHsZUGAn8h3DolvAkfvHhookxbSIEJzzH8D
         ukZw==
X-Gm-Message-State: AOAM532txxIijOQPwh0P+72jTy2Hz8thjWfPtPi1cqRMDAwYcCrgwEhj
        LsTkQ7GZ7t/Z6w/xhMBXLACbhQ==
X-Google-Smtp-Source: ABdhPJxYEPxb6kjcNjXdQgqINcuRgy2AxuFUZJQFXrlqz4C16F7nxJqXp7PlV3r3xAnPt/OprJj2Hw==
X-Received: by 2002:a63:fd13:: with SMTP id d19mr21932588pgh.501.1638981377778;
        Wed, 08 Dec 2021 08:36:17 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j16sm4845015pfj.16.2021.12.08.08.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:36:17 -0800 (PST)
Date:   Wed, 8 Dec 2021 08:36:14 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Message-ID: <20211208083614.61f386ad@hermes.local>
In-Reply-To: <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
        <YbDR/JStiIco3HQS@kroah.com>
        <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 11:29:47 -0500
George Kennedy <george.kennedy@oracle.com> wrote:

> On 12/8/2021 10:40 AM, Greg KH wrote:
> > On Wed, Dec 08, 2021 at 09:43:25AM -0500, George Kennedy wrote: =20
> >> Avoid double free in tun_free_netdev() by clearing tun->security
> >> after free and using it to indicate that free has already been done.
> >>
> >> BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_securi=
ty+0x1a/0x20 security/selinux/hooks.c:5605
> >>
> >> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
> >> Hardware name: Red Hat KVM, BIOS
> >> Call Trace:
> >>   <TASK>
> >>   __dump_stack lib/dump_stack.c:88 [inline]
> >>   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
> >>   print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:2=
47
> >>   kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
> >>   ____kasan_slab_free mm/kasan/common.c:346 [inline]
> >>   __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
> >>   kasan_slab_free include/linux/kasan.h:235 [inline]
> >>   slab_free_hook mm/slub.c:1723 [inline]
> >>   slab_free_freelist_hook mm/slub.c:1749 [inline]
> >>   slab_free mm/slub.c:3513 [inline]
> >>   kfree+0xac/0x2d0 mm/slub.c:4561
> >>   selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
> >>   security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
> >>   tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
> >>   netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
> >>   rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
> >>   __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
> >>   tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
> >>   vfs_ioctl fs/ioctl.c:51 [inline]
> >>   __do_sys_ioctl fs/ioctl.c:874 [inline]
> >>   __se_sys_ioctl fs/ioctl.c:860 [inline]
> >>   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
> >>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
> >>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >> Reported-by: syzkaller <syzkaller@googlegroups.com>
> >> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> >> ---
> >>   drivers/net/tun.c | 11 +++++++++--
> >>   1 file changed, 9 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index 1572878..617c71f 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *=
dev)
> >>   	dev->tstats =3D NULL;
> >>  =20
> >>   	tun_flow_uninit(tun);
> >> -	security_tun_dev_free_security(tun->security);
> >> +	if (tun->security) {
> >> +		security_tun_dev_free_security(tun->security);
> >> +		tun->security =3D NULL;
> >> +	}
> >>   	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
> >>   	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
> >>   }
> >> @@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct =
file *file, struct ifreq *ifr)
> >>  =20
> >>   err_free_flow:
> >>   	tun_flow_uninit(tun);
> >> -	security_tun_dev_free_security(tun->security);
> >> +	if (tun->security) {
> >> +		security_tun_dev_free_security(tun->security);
> >> +		/* Let tun_free_netdev() know the free has already been done. */
> >> +		tun->security =3D NULL; =20
> > What protects this from racing with tun_free_netdev()? =20
> tun_free_netdev() is called after err_free_flow has already done the=20
> free. rtnl_lock() and rtnl_unlock() prevent the race.
>=20
> Here is the full KASAN report:
>=20
> Syzkaller hit 'KASAN: invalid-free in selinux_tun_dev_free_security' bug.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: double-free or invalid-free in=20
> selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>=20
> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29=20
> 04/01/2014
> Call Trace:
>  =C2=A0<TASK>
>  =C2=A0__dump_stack lib/dump_stack.c:88 [inline]
>  =C2=A0dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>  =C2=A0print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c=
:247
>  =C2=A0kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>  =C2=A0____kasan_slab_free mm/kasan/common.c:346 [inline]
>  =C2=A0__kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>  =C2=A0kasan_slab_free include/linux/kasan.h:235 [inline]
>  =C2=A0slab_free_hook mm/slub.c:1723 [inline]
>  =C2=A0slab_free_freelist_hook mm/slub.c:1749 [inline]
>  =C2=A0slab_free mm/slub.c:3513 [inline]
>  =C2=A0kfree+0xac/0x2d0 mm/slub.c:4561
>  =C2=A0selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5=
605
>  =C2=A0security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>  =C2=A0tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>  =C2=A0netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>  =C2=A0rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>  =C2=A0__tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>  =C2=A0tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  =C2=A0vfs_ioctl fs/ioctl.c:51 [inline]
>  =C2=A0__do_sys_ioctl fs/ioctl.c:874 [inline]
>  =C2=A0__se_sys_ioctl fs/ioctl.c:860 [inline]
>  =C2=A0__x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  =C2=A0do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  =C2=A0do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  =C2=A0entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd496f4c289
> Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89=20
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01=20
> f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007fd497632e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000603190 RCX: 00007fd496f4c289
> RDX: 0000000020000240 RSI: 00000000400454ca RDI: 0000000000000003
> RBP: 0000000000603198 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060319c
> R13: 0000000000021000 R14: 0000000000000000 R15: 00007fd497633700
>  =C2=A0</TASK>
>=20
> Allocated by task 25750:
>  =C2=A0kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>  =C2=A0kasan_set_track mm/kasan/common.c:46 [inline]
>  =C2=A0set_alloc_info mm/kasan/common.c:434 [inline]
>  =C2=A0____kasan_kmalloc mm/kasan/common.c:513 [inline]
>  =C2=A0__kasan_kmalloc+0x8d/0xb0 mm/kasan/common.c:522
>  =C2=A0kasan_kmalloc include/linux/kasan.h:269 [inline]
>  =C2=A0kmem_cache_alloc_trace+0x18a/0x2d0 mm/slub.c:3261
>  =C2=A0kmalloc include/linux/slab.h:590 [inline]
>  =C2=A0kzalloc include/linux/slab.h:724 [inline]
>  =C2=A0selinux_tun_dev_alloc_security+0x50/0x180 security/selinux/hooks.c=
:5594
>  =C2=A0security_tun_dev_alloc_security+0x51/0xb0 security/security.c:2336
>  =C2=A0tun_set_iff.constprop.66+0x107f/0x1d10 drivers/net/tun.c:2727
>  =C2=A0__tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>  =C2=A0tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  =C2=A0vfs_ioctl fs/ioctl.c:51 [inline]
>  =C2=A0__do_sys_ioctl fs/ioctl.c:874 [inline]
>  =C2=A0__se_sys_ioctl fs/ioctl.c:860 [inline]
>  =C2=A0__x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  =C2=A0do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  =C2=A0do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  =C2=A0entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> Freed by task 25750:
>  =C2=A0kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>  =C2=A0kasan_set_track+0x25/0x30 mm/kasan/common.c:46
>  =C2=A0kasan_set_free_info+0x24/0x40 mm/kasan/generic.c:370
>  =C2=A0____kasan_slab_free mm/kasan/common.c:366 [inline]
>  =C2=A0____kasan_slab_free mm/kasan/common.c:328 [inline]
>  =C2=A0__kasan_slab_free+0xe8/0x120 mm/kasan/common.c:374
>  =C2=A0kasan_slab_free include/linux/kasan.h:235 [inline]
>  =C2=A0slab_free_hook mm/slub.c:1723 [inline]
>  =C2=A0slab_free_freelist_hook mm/slub.c:1749 [inline]
>  =C2=A0slab_free mm/slub.c:3513 [inline]
>  =C2=A0kfree+0xac/0x2d0 mm/slub.c:4561
>  =C2=A0selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5=
605
>  =C2=A0security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>  =C2=A0tun_set_iff.constprop.66+0x9f9/0x1d10 drivers/net/tun.c:2782
>  =C2=A0__tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>  =C2=A0tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  =C2=A0vfs_ioctl fs/ioctl.c:51 [inline]
>  =C2=A0__do_sys_ioctl fs/ioctl.c:874 [inline]
>  =C2=A0__se_sys_ioctl fs/ioctl.c:860 [inline]
>  =C2=A0__x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  =C2=A0do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  =C2=A0do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  =C2=A0entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> The buggy address belongs to the object at ffff888066b87370
>  =C2=A0which belongs to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes inside of
>  =C2=A08-byte region [ffff888066b87370, ffff888066b87378)
> The buggy address belongs to the page:
> page:0000000003b0639d refcount:1 mapcount:0 mapping:0000000000000000=20
> index:0x0 pfn:0x66b87
> flags: 0xfffffc0000200(slab|node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> raw: 000fffffc0000200 dead000000000100 dead000000000122 ffff888100042280
> raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>=20
> Memory state around the buggy address:
>  =C2=A0ffff888066b87200: fc fb fc fc fc fc 00 fc fc fc fc fa fc fc fc fc
>  =C2=A0ffff888066b87280: fa fc fc fc fc fa fc fc fc fc fb fc fc fc fc fa
>  >ffff888066b87300: fc fc fc fc 00 fc fc fc fc fb fc fc fc fc fa fc =20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
>  =C2=A0ffff888066b87380: fc fc fc fa fc fc fc fc 00 fc fc fc fc fa fc fc
>  =C2=A0ffff888066b87400: fc fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> >
> > And why can't security_tun_dev_free_security() handle a NULL value? =20
>=20
> security_tun_dev_free_security() could be modified to handle the NULL val=
ue.

It looks like a lot of the problem is duplicate unwind.
Why does err_free_flow, err_free_stat etc unwinds need to exist if
the free_netdev is going to do same thing.

