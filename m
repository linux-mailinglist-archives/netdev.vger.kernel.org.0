Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0251082CA
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfKXKH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfKXKH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 05:07:29 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA1E20706;
        Sun, 24 Nov 2019 10:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574590047;
        bh=BJMGRs1XYftgtUMKhvra6gtv6uRg1ZhFWlQXdwHzCoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pNp+8xfj63Jbod/7Q6BMJC7bh7fn74QyYqI1+bpJ59cMWIPyEGmkuVa1qSTxk7aNf
         MXTmIELmKXeDFRia6f1i62DK4/MvkvjxgRFu2xnPQR4U2bZAnRNsobZ8ZUg8F1BJVE
         3nZm//vw0mzoQqA7Gxrwa0lRP23syTvP5yHucMO4=
Date:   Sun, 24 Nov 2019 12:07:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 07/24] IB/umem: use get_user_pages_fast() to pin DMA
 pages
Message-ID: <20191124100724.GH136476@unreal>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-8-jhubbard@nvidia.com>
 <20191121080746.GC30991@infradead.org>
 <20191121143643.GC7448@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121143643.GC7448@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:36:43AM -0400, Jason Gunthorpe wrote:
> On Thu, Nov 21, 2019 at 12:07:46AM -0800, Christoph Hellwig wrote:
> > On Wed, Nov 20, 2019 at 11:13:37PM -0800, John Hubbard wrote:
> > > And get rid of the mmap_sem calls, as part of that. Note
> > > that get_user_pages_fast() will, if necessary, fall back to
> > > __gup_longterm_unlocked(), which takes the mmap_sem as needed.
> > >
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >
> > Looks fine,
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > Jason, can you queue this up for 5.5 to reduce this patch stack a bit?
>
> Yes, I said I'd do this in an earlier revision. Now that it is clear this
> won't go through Andrew's tree, applied to rdma for-next

Jason,

This patch broke RDMA completely.
Change from get_user_pages() to get_user_pages_fast() causes to endless
amount of splats due to combination of the following code:

189 struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
190                             size_t size, int access)
...
263         if (!umem->writable)
264                 gup_flags |= FOLL_FORCE;
265

and

2398 int get_user_pages_fast(unsigned long start, int nr_pages,
2399                         unsigned int gup_flags, struct page **pages)
2400 {
2401         unsigned long addr, len, end;
2402         int nr = 0, ret = 0;
2403
2404         if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
2405                 return -EINVAL;


[   72.623266] ------------[ cut here ]------------
[   72.624143] WARNING: CPU: 1 PID: 2557 at mm/gup.c:2404 get_user_pages_fast+0x115/0x180
[   72.625426] Modules linked in: xt_MASQUERADE iptable_nat nf_nat
   br_netfilter overlay ib_srp scsi_transport_srp rpcrdma rdma_ucm
   ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_umad iw_cm ib_ipoib
   ib_cm mlx5_ib ib_uverbs ib_core mlx5_core mlxfw ptp pps_core
[   72.629024] CPU: 1 PID: 2557 Comm: python3 Not tainted 5.4.0-rc5-J6120-Geeb831ec5b80 #1
[   72.630435] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   72.631973] RIP: 0010:get_user_pages_fast+0x115/0x180
[   72.632873] Code: 8d 0c 10 85 c0 89 d0 0f 49 c1 eb 97 fa 4c 8d
       44 24 0c 4c 89 e9 44 89 e2 48 89 df e8 25 dd ff ff fb 8b 44 24 0c
       e9 75 ff ff ff <0f> 0b b8 ea ff ff ff e9 6d ff ff ff 65 4c 8b 2c
       25 00 5d 01 00 49
[   72.635967] RSP: 0018:ffffc90000edf930 EFLAGS: 00010202
[   72.636896] RAX: 0000000000000000 RBX: 00007f931c392000 RCX: ffff8883f4909000
[   72.638117] RDX: 0000000000010011 RSI: 0000000000000001 RDI: 00007f931c392000
[   72.639353] RBP: 00007f931c392000 R08: 0000000000000020 R09: ffff8883f4909000
[   72.640602] R10: 0000000000000000 R11: ffff8884068d6760 R12: ffff888409e45ba0
[   72.641858] R13: ffff8884068d6760 R14: 0000160000000000 R15: ffff8883f4909000
[   72.643115] FS:  00007f9323754700(0000) GS:ffff88842fa80000(0000) knlGS:0000000000000000
[   72.644586] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.645628] CR2: 00007f931c3ca000 CR3: 00000003f83d6006 CR4: 00000000007606a0
[   72.646875] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   72.648120] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   72.649374] PKRU: 55555554
[   72.649935] Call Trace:
[   72.650477]  ib_umem_get+0x298/0x550 [ib_uverbs]
[   72.651347]  mlx5_ib_db_map_user+0xad/0x130 [mlx5_ib]
[   72.652279]  mlx5_ib_create_cq+0x1e8/0xaa0 [mlx5_ib]
[   72.653207]  create_cq+0x1c8/0x2d0 [ib_uverbs]
[   72.654050]  ib_uverbs_create_cq+0x70/0xa0 [ib_uverbs]
[   72.654988]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xc2/0xf0 [ib_uverbs]
[   72.656331]  ib_uverbs_cmd_verbs.isra.6+0x5be/0xbe0 [ib_uverbs]
[   72.657398]  ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
[   72.658423]  ? kvm_clock_get_cycles+0xd/0x10
[   72.659229]  ? kmem_cache_alloc+0x176/0x1c0
[   72.660025]  ? filemap_map_pages+0x18c/0x350
[   72.660838]  ib_uverbs_ioctl+0xc0/0x120 [ib_uverbs]
[   72.661756]  do_vfs_ioctl+0xa1/0x610
[   72.662458]  ksys_ioctl+0x70/0x80
[   72.663119]	__x64_sys_ioctl+0x16/0x20
[   72.663850]  do_syscall_64+0x42/0x110
[   72.664562]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   72.665492] RIP: 0033:0x7f9332958267
[   72.666185] Code: b3 66 90 48
	8b 05 19 3c 2c 00 64 c7 00 26 00
	00 00 48 c7 c0 ff ff ff ff c3 66
	2e 0f 1f 84 00 00 00 00 00 b8 10
	00 00 00 0f 05 <48> 3d 01 f0 ff
	ff 73 01 c3 48 8b 0d e9 3b 2c 00
	f7 d8 64 89 01 48
[   72.669347] RSP: 002b:00007f9323751928 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   72.670706] RAX: ffffffffffffffda RBX: 00007f93237519b8 RCX:	00007f9332958267
[   72.671937] RDX: 00007f93237519a0 RSI: 00000000c0181b01 RDI: 0000000000000008
[   72.673176] RBP: 00007f9323751980 R08: 0000000000000005 R09: 00007f931c3ffef0
[   72.674415] R10: 0000000000001000 R11: 0000000000000246 R12: 00007f931c400030
[   72.675653] R13: 00007f9323751980 R14: 00007f9323751ea8 R15: 00000000000000ff
[   72.676885] ---[ end trace 033465440517865c ]---

>
> Thanks,
> Jason
>
