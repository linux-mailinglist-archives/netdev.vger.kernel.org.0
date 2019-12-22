Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8B5128E10
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 14:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfLVNYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 08:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfLVNYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 08:24:02 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF2F206D3;
        Sun, 22 Dec 2019 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577021040;
        bh=483rbuBN6u8s6eQHgpawXUOLSB7wNwqu6dfS1IVBUTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCcjH9yc8u/Vu1a+J6ffdhdH2EQVw5nD3NYhUbwC2GUSnm6xSh3uwn+/F9m4ilyzx
         lTmfUsU/ZGfq6BBNKcYt9vWVR3mQLngV7t/V1RQWwq/9eKi8XawAM/+XuBwJ0m9BKE
         mbbyx0jewMth0tRdvRaxLLJjjH32G6FGxmP5fBCg=
Date:   Sun, 22 Dec 2019 15:23:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Ran Rozenstein <ranro@mellanox.com>
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
Message-ID: <20191222132357.GF13335@unreal>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
 <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
 <20191219210743.GN17227@ziepe.ca>
 <20191220182939.GA10944@unreal>
 <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1001a5fc-a71d-9c0f-1090-546c4913d8a2@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 03:54:55PM -0800, John Hubbard wrote:
> On 12/20/19 10:29 AM, Leon Romanovsky wrote:
> ...
> >> $ ./build.sh
> >> $ build/bin/run_tests.py
> >>
> >> If you get things that far I think Leon can get a reproduction for you
> >
> > I'm not so optimistic about that.
> >
>
> OK, I'm going to proceed for now on the assumption that I've got an overflow
> problem that happens when huge pages are pinned. If I can get more information,
> great, otherwise it's probably enough.
>
> One thing: for your repro, if you know the huge page size, and the system
> page size for that case, that would really help. Also the number of pins per
> page, more or less, that you'd expect. Because Jason says that only 2M huge
> pages are used...
>
> Because the other possibility is that the refcount really is going negative,
> likely due to a mismatched pin/unpin somehow.
>
> If there's not an obvious repro case available, but you do have one (is it easy
> to repro, though?), then *if* you have the time, I could point you to a github
> branch that reduces GUP_PIN_COUNTING_BIAS by, say, 4x, by applying this:
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bb44c4d2ada7..8526fd03b978 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1077,7 +1077,7 @@ static inline void put_page(struct page *page)
>   * get_user_pages and page_mkclean and other calls that race to set up page
>   * table entries.
>   */
> -#define GUP_PIN_COUNTING_BIAS (1U << 10)
> +#define GUP_PIN_COUNTING_BIAS (1U << 8)
>
>  void unpin_user_page(struct page *page);
>  void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
>
> If that fails to repro, then we would be zeroing in on the root cause.
>
> The branch is here (I just tested it and it seems healthy):
>
> git@github.com:johnhubbard/linux.git  pin_user_pages_tracking_v11_with_diags

Hi,

We tested the following branch and here comes results:
[root@server consume_mtts]# (master) $ grep foll_pin /proc/vmstat
nr_foll_pin_requested 0
nr_foll_pin_returned 0

[root@serer consume_mtts]# (master) $ dmesg
[  425.221459] ------------[ cut here ]------------
[  425.225894] WARNING: CPU: 1 PID: 6738 at mm/gup.c:61 try_grab_compound_head+0x90/0xa0
[  425.228021] Modules linked in: mlx5_ib mlx5_core mlxfw mlx4_ib mlx4_en ptp pps_core mlx4_core bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel rdma_rxe ip6_udp_tunnel udp_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core [last unloaded: mlxfw]
[  425.235266] CPU: 1 PID: 6738 Comm: consume_mtts Tainted: G           O      5.5.0-rc2+ #1
[  425.237480] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  425.239738] RIP: 0010:try_grab_compound_head+0x90/0xa0
[  425.241170] Code: 06 48 8d 4f 34 f0 0f b1 57 34 74 cd 85 c0 74 cf 8d 14 06 f0 0f b1 11 74 c0 eb f1 8d 14 06 f0 0f b1 11 74 b5 85 c0 75 f3 eb b5 <0f> 0b 31 c0 c3 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41
[  425.245739] RSP: 0018:ffffc900006878a8 EFLAGS: 00010082
[  425.247124] RAX: 0000000080000001 RBX: 00007f780488a000 RCX: 0000000000000bb0
[  425.248956] RDX: ffffea000e031087 RSI: 0000000000008a00 RDI: ffffea000dc58000
[  425.250761] RBP: ffffea000e031080 R08: ffffc90000687974 R09: 000fffffffe00000
[  425.252661] R10: 0000000000000000 R11: ffff888362560000 R12: 000000000000008a
[  425.254487] R13: 80000003716000e7 R14: 00007f780488a000 R15: ffffc90000687974
[  425.256309] FS:  00007f780d9d3740(0000) GS:ffff8883b1c80000(0000) knlGS:0000000000000000
[  425.258401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  425.259949] CR2: 0000000002334048 CR3: 000000039c68c001 CR4: 00000000001606a0
[  425.261884] Call Trace:
[  425.262735]  gup_pgd_range+0x517/0x5a0
[  425.263819]  internal_get_user_pages_fast+0x210/0x250
[  425.265193]  ib_umem_get+0x298/0x550 [ib_uverbs]
[  425.266476]  mr_umem_get+0xc9/0x260 [mlx5_ib]
[  425.267699]  mlx5_ib_reg_user_mr+0xcc/0x7e0 [mlx5_ib]
[  425.269134]  ? xas_load+0x8/0x80
[  425.270074]  ? xa_load+0x48/0x90
[  425.271038]  ? lookup_get_idr_uobject.part.10+0x12/0x70 [ib_uverbs]
[  425.272757]  ib_uverbs_reg_mr+0x127/0x280 [ib_uverbs]
[  425.274120]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xc2/0xf0 [ib_uverbs]
[  425.276058]  ib_uverbs_cmd_verbs.isra.6+0x5be/0xbe0 [ib_uverbs]
[  425.277657]  ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
[  425.279155]  ? __alloc_pages_nodemask+0x148/0x2b0
[  425.280445]  ib_uverbs_ioctl+0xc0/0x120 [ib_uverbs]
[  425.281755]  do_vfs_ioctl+0x9d/0x650
[  425.282766]  ksys_ioctl+0x70/0x80
[  425.283745]  __x64_sys_ioctl+0x16/0x20
[  425.284912]  do_syscall_64+0x42/0x130
[  425.285973]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  425.287377] RIP: 0033:0x7f780d2df267
[  425.288449] Code: b3 66 90 48 8b 05 19 3c 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 3b 2c 00 f7 d8 64 89 01 48
[  425.293073] RSP: 002b:00007ffce49a88a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  425.295034] RAX: ffffffffffffffda RBX: 00007ffce49a8938 RCX: 00007f780d2df267
[  425.296895] RDX: 00007ffce49a8920 RSI: 00000000c0181b01 RDI: 0000000000000003
[  425.298689] RBP: 00007ffce49a8900 R08: 0000000000000003 R09: 00007f780d9a1010
[  425.300480] R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f780d9a1150
[  425.302290] R13: 00007ffce49a8900 R14: 00007ffce49a8ad8 R15: 00007f780468a000
[  425.304113] ---[ end trace 1ecbefdb403190dd ]---
[  425.305434] ------------[ cut here ]------------
[  425.307147] WARNING: CPU: 1 PID: 6738 at mm/gup.c:150 try_grab_page+0x56/0x60
[  425.309111] Modules linked in: mlx5_ib mlx5_core mlxfw mlx4_ib mlx4_en ptp pps_core mlx4_core bonding ip6_gre ip6_tunnel tunnel6 ip_gre gre ip_tunnel rdma_rxe ip6_udp_tunnel udp_tunnel rdma_ucm ib_uverbs ib_ipoib ib_umad ib_srp scsi_transport_srp rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core [last unloaded: mlxfw]
[  425.316461] CPU: 1 PID: 6738 Comm: consume_mtts Tainted: G        W  O      5.5.0-rc2+ #1
[  425.318582] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  425.320958] RIP: 0010:try_grab_page+0x56/0x60
[  425.322167] Code: 7e 28 f0 81 47 34 00 01 00 00 c3 48 8b 47 08 48 8d 50 ff a8 01 48 0f 45 fa 8b 47 34 85 c0 7e 0f f0 ff 47 34 b8 01 00 00 00 c3 <0f> 0b 31 c0 c3 0f 0b 31 c0 c3 0f 1f 44 00 00 41 57 41 56 41 55 41
[  425.326814] RSP: 0018:ffffc90000687830 EFLAGS: 00010282
[  425.328226] RAX: 0000000000000001 RBX: ffffea000dc58000 RCX: ffffea000e031087
[  425.330104] RDX: 0000000080000001 RSI: 0000000000040000 RDI: ffffea000dc58000
[  425.331980] RBP: 00007f7804800000 R08: 000ffffffffff000 R09: 80000003716000e7
[  425.333898] R10: ffff88834af80120 R11: ffff8883ac16f000 R12: ffff88834af80120
[  425.335704] R13: ffff88837c0915c0 R14: 0000000000050201 R15: 00007f7804800000
[  425.337638] FS:  00007f780d9d3740(0000) GS:ffff8883b1c80000(0000) knlGS:0000000000000000
[  425.339734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  425.341369] CR2: 0000000002334048 CR3: 000000039c68c001 CR4: 00000000001606a0
[  425.343160] Call Trace:
[  425.343967]  follow_trans_huge_pmd+0x16f/0x2e0
[  425.345263]  follow_p4d_mask+0x51c/0x630
[  425.346344]  __get_user_pages+0x1a1/0x6c0
[  425.347463]  internal_get_user_pages_fast+0x17b/0x250
[  425.348918]  ib_umem_get+0x298/0x550 [ib_uverbs]
[  425.350174]  mr_umem_get+0xc9/0x260 [mlx5_ib]
[  425.351383]  mlx5_ib_reg_user_mr+0xcc/0x7e0 [mlx5_ib]
[  425.352849]  ? xas_load+0x8/0x80
[  425.353776]  ? xa_load+0x48/0x90
[  425.354730]  ? lookup_get_idr_uobject.part.10+0x12/0x70 [ib_uverbs]
[  425.356410]  ib_uverbs_reg_mr+0x127/0x280 [ib_uverbs]
[  425.357843]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xc2/0xf0 [ib_uverbs]
[  425.359749]  ib_uverbs_cmd_verbs.isra.6+0x5be/0xbe0 [ib_uverbs]
[  425.361405]  ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
[  425.362898]  ? __alloc_pages_nodemask+0x148/0x2b0
[  425.364206]  ib_uverbs_ioctl+0xc0/0x120 [ib_uverbs]
[  425.365564]  do_vfs_ioctl+0x9d/0x650
[  425.366567]  ksys_ioctl+0x70/0x80
[  425.367537]  __x64_sys_ioctl+0x16/0x20
[  425.368698]  do_syscall_64+0x42/0x130
[  425.369782]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  425.371117] RIP: 0033:0x7f780d2df267
[  425.372159] Code: b3 66 90 48 8b 05 19 3c 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 3b 2c 00 f7 d8 64 89 01 48
[  425.376774] RSP: 002b:00007ffce49a88a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  425.378740] RAX: ffffffffffffffda RBX: 00007ffce49a8938 RCX: 00007f780d2df267
[  425.380598] RDX: 00007ffce49a8920 RSI: 00000000c0181b01 RDI: 0000000000000003
[  425.382411] RBP: 00007ffce49a8900 R08: 0000000000000003 R09: 00007f780d9a1010
[  425.384312] R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f780d9a1150
[  425.386132] R13: 00007ffce49a8900 R14: 00007ffce49a8ad8 R15: 00007f780468a000
[  425.387964] ---[ end trace 1ecbefdb403190de ]---

Thanks

>
>
>
> thanks,
> --
> John Hubbard
> NVIDIA
