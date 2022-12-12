Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A3564995D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiLLHMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiLLHMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:12:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE12E1D0
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15FFDB80A53
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2749FC433D2;
        Mon, 12 Dec 2022 07:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670829154;
        bh=ox//7Y5mFzqX4iwBgsRA8/WmDcgzh6bVqwaRxYIjlSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKm4M2bIda8KVnuFvat8jtUNhkDEYhxBpAq5yuwF/ZtQ/89ibKOD6zj2Q1MMVKvEX
         m6K2DnCtb2cVHscqSrF74EqrJ7OqFkpwrWoOzUXx27W74pHW/kP5T699hBjrFd5AZp
         qRD+o0sBGRtTd4Cnah1Da1Tj2LeVOeffD3KXomHMAY08vsN7zGNCyPWAvHv7soU4b4
         ARKvssjmB3W6yafaIwIUZi/Xgwh/S3ALY91PAtxRjrp9EZb0sJRgOFWkkNknil3icg
         Ws2vVRm0av6iMwrZ0uDwzpLSs+0PXVsOCAiuP12Jh4worFx1Ubu1NGTEVUTUBqv0QY
         pg8v1tCBA4ZVg==
Date:   Mon, 12 Dec 2022 09:12:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Nir Levy <bhr166@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: atm: Fix use-after-free bug in
 atm_dev_register()
Message-ID: <Y5bUXjhM3mvUkwNL@unreal>
References: <20221211124943.3004-1-bhr166@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221211124943.3004-1-bhr166@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 02:49:43PM +0200, Nir Levy wrote:
> Failure of device_register() in atm_register_sysfs causes to error
> unwind in atm_dev_register. The last function will kfree the device,
> while the comment above device_register() says that put_device() needs
> to be used to give up the reference in the error path.
> 
> The use of kfree instead triggers a UAF, as shown by the following KASAN report,
> obtained by trying to access adev->class_dev.
> 
> KASAN report details as below:
> 
> [   94.341664] BUG: KASAN: use-after-free in sysfs_kf_seq_show+0x306/0x440
> [   94.341674] Read of size 8 at addr ffff88819a8a30e8 by task systemd-udevd/484
> 
> [   94.341680] CPU: 3 PID: 484 Comm: systemd-udevd Tainted: G            E      6.1.0-rc1+ #1
> [   94.341684] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
> [   94.341703] Call Trace:
> [   94.341705]  <TASK>
> [   94.341707]  dump_stack_lvl+0x49/0x63
> [   94.341713]  print_report+0x177/0x46e
> [   94.341717]  ? kasan_complete_mode_report_info+0x7c/0x210
> [   94.341720]  ? sysfs_kf_seq_show+0x306/0x440
> [   94.341753]  kasan_report+0xb0/0x140
> [   94.341757]  ? sysfs_kf_seq_show+0x306/0x440
> [   94.341760]  __asan_report_load8_noabort+0x14/0x20
> [   94.341763]  sysfs_kf_seq_show+0x306/0x440
> [   94.341766]  kernfs_seq_show+0x145/0x1b0
> [   94.341769]  seq_read_iter+0x408/0x1080
> [   94.341774]  kernfs_fop_read_iter+0x3d5/0x540
> [   94.341794]  vfs_read+0x542/0x800
> [   94.341797]  ? kernel_read+0x130/0x130
> [   94.341800]  ? __kasan_check_read+0x11/0x20
> [   94.341824]  ? get_nth_filter.part.0+0x200/0x200
> [   94.341828]  ksys_read+0x116/0x220
> [   94.341831]  ? __ia32_sys_pwrite64+0x1f0/0x1f0
> [   94.341849]  ? __secure_computing+0x17c/0x2d0
> [   94.341852]  __x64_sys_read+0x72/0xb0
> [   94.341875]  do_syscall_64+0x59/0x90
> [   94.341878]  ? exc_page_fault+0x72/0xf0
> [   94.341881]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   94.341885] RIP: 0033:0x7fc391f14992
> [   94.341888] Code: c0 e9 b2 fe ff ff 50 48 8d 3d fa b2 0c 00 e8 c5 1d 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
> [   94.341891] RSP: 002b:00007ffe33fed818 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [   94.341896] RAX: ffffffffffffffda RBX: 0000000000001018 RCX: 00007fc391f14992
> [   94.341898] RDX: 0000000000001018 RSI: 0000558a696b0880 RDI: 000000000000000e
> [   94.341900] RBP: 0000558a696b0880 R08: 0000000000000000 R09: 0000558a696b0880
> [   94.341902] R10: 00007fc39201a300 R11: 0000000000000246 R12: 000000000000000e
> [   94.341904] R13: 0000000000001017 R14: 0000000000000002 R15: 00007ffe33fed840
> [   94.341908]  </TASK>
> 
> [   94.341911] Allocated by task 2613:
> [   94.341914]  kasan_save_stack+0x26/0x50
> [   94.341932]  kasan_set_track+0x25/0x40
> [   94.341934]  kasan_save_alloc_info+0x1e/0x30
> [   94.341936]  __kasan_kmalloc+0xb4/0xc0
> [   94.341938]  kmalloc_trace+0x4a/0xb0
> [   94.341941]  atm_dev_register+0x5d/0x700 [atm]
> [   94.341949]  atmtcp_create+0x77/0x1f0 [atmtcp]
> [   94.341953]  atmtcp_ioctl+0x12d/0xb9f [atmtcp]
> [   94.341957]  do_vcc_ioctl+0xfe/0x640 [atm]
> [   94.341962]  vcc_ioctl+0x10/0x20 [atm]
> [   94.341968]  svc_ioctl+0x587/0x6c0 [atm]
> [   94.341973]  sock_do_ioctl+0xd7/0x1e0
> [   94.341977]  sock_ioctl+0x1b5/0x560
> [   94.341979]  __x64_sys_ioctl+0x132/0x1b0
> [   94.341981]  do_syscall_64+0x59/0x90
> [   94.341983]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [   94.341986] Freed by task 2613:
> [   94.341988]  kasan_save_stack+0x26/0x50
> [   94.341991]  kasan_set_track+0x25/0x40
> [   94.341993]  kasan_save_free_info+0x2e/0x50
> [   94.341995]  ____kasan_slab_free+0x174/0x1e0
> [   94.341997]  __kasan_slab_free+0x12/0x20
> [   94.342000]  slab_free_freelist_hook+0xd0/0x1a0
> [   94.342002]  __kmem_cache_free+0x193/0x2c0
> [   94.342005]  kfree+0x79/0x120
> [   94.342007]  atm_dev_register.cold+0x46/0x64 [atm]
> [   94.342013]  atmtcp_create+0x77/0x1f0 [atmtcp]
> [   94.342016]  atmtcp_ioctl+0x12d/0xb9f [atmtcp]
> [   94.342020]  do_vcc_ioctl+0xfe/0x640 [atm]
> [   94.342077]  vcc_ioctl+0x10/0x20 [atm]
> [   94.342083]  svc_ioctl+0x587/0x6c0 [atm]
> [   94.342088]  sock_do_ioctl+0xd7/0x1e0
> [   94.342091]  sock_ioctl+0x1b5/0x560
> [   94.342093]  __x64_sys_ioctl+0x132/0x1b0
> [   94.342095]  do_syscall_64+0x59/0x90
> [   94.342098]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [   94.342102] The buggy address belongs to the object at ffff88819a8a3000 which belongs to the cache kmalloc-1k of size 1024
> [   94.342105] The buggy address is located 232 bytes inside of 1024-byte region [ffff88819a8a3000, ffff88819a8a3400)
> 
> [   94.342109] The buggy address belongs to the physical page:
> [   94.342111] page:0000000099993f0a refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x19a8a0
> [   94.342114] head:0000000099993f0a order:3 compound_mapcount:0 compound_pincount:0
> [   94.342116] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> [   94.342136] raw: 0017ffffc0010200 dead000000000100 dead000000000122 ffff888100042dc0
> [   94.342138] raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> [   94.342139] page dumped because: kasan: bad access detected
> 
> [   94.342141] Memory state around the buggy address:
> [   94.342143]  ffff88819a8a2f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   94.342145]  ffff88819a8a3000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   94.342147] >ffff88819a8a3080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   94.342148]                                                           ^
> [   94.342150]  ffff88819a8a3100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   94.342152]  ffff88819a8a3180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> Fixes: 656d98b09d57 ([ATM]: basic sysfs support for ATM devices)
> Signed-off-by: Nir Levy <bhr166@gmail.com>
> ---
> v2: Call put_device in atm_register_sysfs instead of atm_dev_register.
> ---
>  net/atm/atm_sysfs.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
