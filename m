Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8182F46D878
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbhLHQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:37:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44688 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbhLHQhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:37:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B249FB82192;
        Wed,  8 Dec 2021 16:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7124C00446;
        Wed,  8 Dec 2021 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638981211;
        bh=9OYMHuvosQxsr3N5QYHGfqV+5KdYvkegPY+0KP8eklA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vVVItom9vZbAhP8YUVhs3+YqMxNVWyw0RglK/IzOg9Ff3VlEf9yqzX90rGAnWK0Ht
         wGq5nhRGIdGBs6YF1vtEfg6EYKYOiRXAofViK1IM0x/O76Lfyu4HT6adwxfzshySv/
         VAXKDezLKfb2oau7zj+kif3m8d637gQsOI6kyvaw=
Date:   Wed, 8 Dec 2021 17:33:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Message-ID: <YbDeWOnESvNCCX9M@kroah.com>
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
 <YbDR/JStiIco3HQS@kroah.com>
 <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 11:29:47AM -0500, George Kennedy wrote:
> 
> 
> On 12/8/2021 10:40 AM, Greg KH wrote:
> > On Wed, Dec 08, 2021 at 09:43:25AM -0500, George Kennedy wrote:
> > > Avoid double free in tun_free_netdev() by clearing tun->security
> > > after free and using it to indicate that free has already been done.
> > > 
> > > BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
> > > 
> > > CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
> > > Hardware name: Red Hat KVM, BIOS
> > > Call Trace:
> > >   <TASK>
> > >   __dump_stack lib/dump_stack.c:88 [inline]
> > >   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
> > >   print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
> > >   kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
> > >   ____kasan_slab_free mm/kasan/common.c:346 [inline]
> > >   __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
> > >   kasan_slab_free include/linux/kasan.h:235 [inline]
> > >   slab_free_hook mm/slub.c:1723 [inline]
> > >   slab_free_freelist_hook mm/slub.c:1749 [inline]
> > >   slab_free mm/slub.c:3513 [inline]
> > >   kfree+0xac/0x2d0 mm/slub.c:4561
> > >   selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
> > >   security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
> > >   tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
> > >   netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
> > >   rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
> > >   __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
> > >   tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
> > >   vfs_ioctl fs/ioctl.c:51 [inline]
> > >   __do_sys_ioctl fs/ioctl.c:874 [inline]
> > >   __se_sys_ioctl fs/ioctl.c:860 [inline]
> > >   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
> > >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > 
> > > Reported-by: syzkaller <syzkaller@googlegroups.com>
> > > Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> > > ---
> > >   drivers/net/tun.c | 11 +++++++++--
> > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index 1572878..617c71f 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *dev)
> > >   	dev->tstats = NULL;
> > >   	tun_flow_uninit(tun);
> > > -	security_tun_dev_free_security(tun->security);
> > > +	if (tun->security) {
> > > +		security_tun_dev_free_security(tun->security);
> > > +		tun->security = NULL;
> > > +	}
> > >   	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
> > >   	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
> > >   }
> > > @@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
> > >   err_free_flow:
> > >   	tun_flow_uninit(tun);
> > > -	security_tun_dev_free_security(tun->security);
> > > +	if (tun->security) {
> > > +		security_tun_dev_free_security(tun->security);
> > > +		/* Let tun_free_netdev() know the free has already been done. */
> > > +		tun->security = NULL;
> > What protects this from racing with tun_free_netdev()?
> tun_free_netdev() is called after err_free_flow has already done the free.
> rtnl_lock() and rtnl_unlock() prevent the race.

Ok, good, it wasn't obvious from the context here.

> 
> Here is the full KASAN report:
> 
> Syzkaller hit 'KASAN: invalid-free in selinux_tun_dev_free_security' bug.
> 
> ==================================================================
> BUG: KASAN: double-free or invalid-free in
> selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
> 
> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29
> 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>  print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
>  kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>  ____kasan_slab_free mm/kasan/common.c:346 [inline]
>  __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:1723 [inline]
>  slab_free_freelist_hook mm/slub.c:1749 [inline]
>  slab_free mm/slub.c:3513 [inline]
>  kfree+0xac/0x2d0 mm/slub.c:4561
>  selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>  security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>  tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>  netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>  rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>  __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd496f4c289
> Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007fd497632e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000603190 RCX: 00007fd496f4c289
> RDX: 0000000020000240 RSI: 00000000400454ca RDI: 0000000000000003
> RBP: 0000000000603198 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060319c
> R13: 0000000000021000 R14: 0000000000000000 R15: 00007fd497633700
>  </TASK>
> 
> Allocated by task 25750:
>  kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
>  __kasan_kmalloc+0x8d/0xb0 mm/kasan/common.c:522
>  kasan_kmalloc include/linux/kasan.h:269 [inline]
>  kmem_cache_alloc_trace+0x18a/0x2d0 mm/slub.c:3261
>  kmalloc include/linux/slab.h:590 [inline]
>  kzalloc include/linux/slab.h:724 [inline]
>  selinux_tun_dev_alloc_security+0x50/0x180 security/selinux/hooks.c:5594
>  security_tun_dev_alloc_security+0x51/0xb0 security/security.c:2336
>  tun_set_iff.constprop.66+0x107f/0x1d10 drivers/net/tun.c:2727
>  __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Freed by task 25750:
>  kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x24/0x40 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free mm/kasan/common.c:328 [inline]
>  __kasan_slab_free+0xe8/0x120 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:1723 [inline]
>  slab_free_freelist_hook mm/slub.c:1749 [inline]
>  slab_free mm/slub.c:3513 [inline]
>  kfree+0xac/0x2d0 mm/slub.c:4561
>  selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>  security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>  tun_set_iff.constprop.66+0x9f9/0x1d10 drivers/net/tun.c:2782
>  __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The buggy address belongs to the object at ffff888066b87370
>  which belongs to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes inside of
>  8-byte region [ffff888066b87370, ffff888066b87378)
> The buggy address belongs to the page:
> page:0000000003b0639d refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x66b87
> flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
> raw: 000fffffc0000200 dead000000000100 dead000000000122 ffff888100042280
> raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888066b87200: fc fb fc fc fc fc 00 fc fc fc fc fa fc fc fc fc
>  ffff888066b87280: fa fc fc fc fc fa fc fc fc fc fb fc fc fc fc fa
> >ffff888066b87300: fc fc fc fc 00 fc fc fc fc fb fc fc fc fc fa fc
>                                                              ^
>  ffff888066b87380: fc fc fc fa fc fc fc fc 00 fc fc fc fc fa fc fc
>  ffff888066b87400: fc fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc
> ==================================================================
> 
> > 
> > And why can't security_tun_dev_free_security() handle a NULL value?
> 
> security_tun_dev_free_security() could be modified to handle the NULL value.

That's fine, most of this patch would still be needed even if you do
that.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
