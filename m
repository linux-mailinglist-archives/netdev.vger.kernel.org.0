Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1373126EF1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLSUda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:33:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3408 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfLSUda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:33:30 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfbde760000>; Thu, 19 Dec 2019 12:32:54 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 19 Dec 2019 12:33:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 19 Dec 2019 12:33:24 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 20:33:20 +0000
Subject: Re: [PATCH v11 00/25] mm/gup: track dma-pinned pages: FOLL_PIN
To:     Leon Romanovsky <leon@kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191219132607.GA410823@unreal>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a4849322-8e17-119e-a664-80d9f95d850b@nvidia.com>
Date:   Thu, 19 Dec 2019 12:30:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191219132607.GA410823@unreal>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576787574; bh=qYns2qRGxuIL2tE2pwcZ9tUscFgdepz6/KR1u4V++yo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=oekFGNukZo3b0oGG0GteVh2OG8cXWIB6RdDi8MzNpTWwpVCO83lB4Iw4jDfJ9drUn
         saDQ2EKNKmwKznWkZqxqqdM+0dodefSnFmC1aSYC6z5J4t92Fjw8TylvSHAzCD5auU
         r1UPbOldYEWzyDWb1PsFwe2bb+LOEvhPeEWj13g+PMzbm0QmOk5I1N1SQUY9j3l++H
         g8+K2jNxhPZGZGK63e1MvA3VDRLFQWNY6Moqvu7J9lc7H5124M/aPT/cCHpnl5vXKn
         Gasun9WEX7bB/99rrDs/CfFGw3rh5U2gFN9+R1e5EUetKmqdQj8I2OSNn/obh0fyLb
         a/d2s9g4z5ojQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/19 5:26 AM, Leon Romanovsky wrote:
> On Mon, Dec 16, 2019 at 02:25:12PM -0800, John Hubbard wrote:
>> Hi,
>>
>> This implements an API naming change (put_user_page*() -->
>> unpin_user_page*()), and also implements tracking of FOLL_PIN pages. It
>> extends that tracking to a few select subsystems. More subsystems will
>> be added in follow up work.
> 
> Hi John,
> 
> The patchset generates kernel panics in our IB testing. In our tests, we
> allocated single memory block and registered multiple MRs using the single
> block.
> 
> The possible bad flow is:
>   ib_umem_geti() ->
>    pin_user_pages_fast(FOLL_WRITE) ->
>     internal_get_user_pages_fast(FOLL_WRITE) ->
>      gup_pgd_range() ->
>       gup_huge_pd() ->
>        gup_hugepte() ->
>         try_grab_compound_head() ->

Hi Leon,

Thanks very much for the detailed report! So we're overflowing...

At first look, this seems likely to be hitting a weak point in the
GUP_PIN_COUNTING_BIAS-based design, one that I believed could be deferred
(there's a writeup in Documentation/core-api/pin_user_page.rst, lines
99-121). Basically it's pretty easy to overflow the page->_refcount
with huge pages if the pages have a *lot* of subpages.

We can only do about 7 pins on 1GB huge pages that use 4KB subpages.
Do you have any idea how many pins (repeated pins on the same page, which
it sounds like you have) might be involved in your test case,
and the huge page and system page sizes? That would allow calculating
if we're likely overflowing for that reason.

So, ideas and next steps:

1. Assuming that you *are* hitting this, I think I may have to fall back to
implementing the "deferred" part of this design, as part of this series, after
all. That means:

   For the pin/unpin calls at least, stop treating all pages as if they are
   a cluster of PAGE_SIZE pages; instead, retrieve a huge page as one page.
   That's not how it works now, and the need to hand back a huge array of
   subpages is part of the problem. This affects the callers too, so it's not
   a super quick change to make. (I was really hoping not to have to do this
   yet.)

2. OR, maybe if you're *close* the the overflow, I could buy some development
time by moving the boundary between pinned vs get_page() refcounts, by
reducing GUP_PIN_COUNTING_BIAS. That's less robust, but I don't want
to rule it out just yet. After all, 1024 is a big chunk to count up with,
and even if get_page() calls add up to, say, 512 refs on a page, it's still
just a false positive on page_dma_pinned(). And false positives, if transient,
are OK.

3. It would be nice if I could reproduce this. I have a two-node mlx5 Infiniband
test setup, but I have done only the tiniest bit of user space IB coding, so
if you have any test programs that aren't too hard to deal with that could
possibly hit this, or be tweaked to hit it, I'd be grateful. Keeping in mind
that I'm not an advanced IB programmer. At all. :)

4. (minor note to self) This also uncovers a minor weakness in diagnostics:
there's no page dump in these reports, because I chickened out and didn't
include my WARN_ONCE_PAGE() macro that would have provided it. Although,
even without it, it's obvious that this is a page overflow.


thanks,
-- 
John Hubbard
NVIDIA


> 
>   108 static __maybe_unused struct page *try_grab_compound_head(struct page *page,
>   109                                                           int refs,
>   110                                                           unsigned int flags)
>   111 {
>   112         if (flags & FOLL_GET)
>   113                 return try_get_compound_head(page, refs);
>   114         else if (flags & FOLL_PIN)
>   115                 return try_pin_compound_head(page, refs);
>   116
>   117         WARN_ON_ONCE(1);
>   118         return NULL;
>   119 }
> 
> # (master) $ dmesg
> [10924.722220] mlx5_core 0000:00:08.0 eth2: Link up
> [10924.725383] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> [10960.902254] ------------[ cut here ]------------
> [10960.905614] WARNING: CPU: 3 PID: 8838 at mm/gup.c:61 try_grab_compound_head+0x92/0xd0
> [10960.907313] Modules linked in: nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp rpcrdma rdma_ucm ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core kvm_intel mlx5_core rfkill mlxfw sunrpc virtio_net pci_hyperv_intf kvm irqbypass net_failover crc32_pclmul i2c_piix4 ptp crc32c_intel failover pcspkr ghash_clmulni_intel i2c_core pps_core sch_fq_codel ip_tables ata_generic pata_acpi serio_raw ata_piix floppy [last unloaded: mlxkvl]
> [10960.917806] CPU: 3 PID: 8838 Comm: consume_mtts Tainted: G           OE     5.5.0-rc2-for-upstream-perf-2019-12-18_10-06-50-78 #1
> [10960.920530] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [10960.923024] RIP: 0010:try_grab_compound_head+0x92/0xd0
> [10960.924329] Code: e4 8d 14 06 48 8d 4f 34 f0 0f b1 57 34 0f 94 c2 84 d2 75 cb 85 c0 74 cd 8d 14 06 f0 0f b1 11 0f 94 c2 84 d2 75 b9 66 90 eb ea <0f> 0b 31 ff eb b7 85 c0 66 0f 1f 44 00 00 74 ab 8d 14 06 f0 0f b1
> [10960.928512] RSP: 0018:ffffc9000129f880 EFLAGS: 00010082
> [10960.929831] RAX: 0000000080000001 RBX: 00007f6397446000 RCX: 000fffffffe00000
> [10960.931422] RDX: 0000000000040000 RSI: 0000000000011800 RDI: ffffea000f5d8000
> [10960.933005] RBP: ffffc9000129f93c R08: ffffc9000129f93c R09: 0000000000200000
> [10960.934584] R10: ffff88840774b200 R11: ffff888000000230 R12: 00007f6397446000
> [10960.936212] R13: 0000000000000046 R14: 80000003d76000e7 R15: 0000000000000080
> [10960.937793] FS:  00007f63a0590740(0000) GS:ffff88842f980000(0000) knlGS:0000000000000000
> [10960.939962] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10960.941367] CR2: 00000000023e9008 CR3: 0000000406d0a002 CR4: 00000000007606e0
> [10960.942975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [10960.944654] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [10960.946394] PKRU: 55555554
> [10960.947310] Call Trace:
> [10960.948193]  gup_pgd_range+0x61e/0x950
> [10960.949585]  internal_get_user_pages_fast+0x98/0x1c0
> [10960.951313]  ib_umem_get+0x2b3/0x5a0 [ib_uverbs]
> [10960.952929]  mr_umem_get+0xd8/0x280 [mlx5_ib]
> [10960.954150]  ? xas_store+0x49/0x550
> [10960.955187]  mlx5_ib_reg_user_mr+0x149/0x7a0 [mlx5_ib]
> [10960.956478]  ? xas_load+0x9/0x80
> [10960.957474]  ? xa_load+0x54/0x90
> [10960.958465]  ? lookup_get_idr_uobject.part.10+0x12/0x80 [ib_uverbs]
> [10960.959926]  ib_uverbs_reg_mr+0x138/0x2a0 [ib_uverbs]
> [10960.961192]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xb1/0xf0 [ib_uverbs]
> [10960.963208]  ib_uverbs_cmd_verbs.isra.8+0x997/0xb30 [ib_uverbs]
> [10960.964603]  ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
> [10960.965949]  ? mem_cgroup_commit_charge+0x6a/0x140
> [10960.967177]  ? page_add_new_anon_rmap+0x58/0xc0
> [10960.968360]  ib_uverbs_ioctl+0xbc/0x130 [ib_uverbs]
> [10960.969595]  do_vfs_ioctl+0xa6/0x640
> [10960.970631]  ? syscall_trace_enter+0x1f8/0x2e0
> [10960.971829]  ksys_ioctl+0x60/0x90
> [10960.972825]  __x64_sys_ioctl+0x16/0x20
> [10960.973888]  do_syscall_64+0x48/0x130
> [10960.974949]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [10960.976219] RIP: 0033:0x7f639fe9b267
> [10960.977260] Code: b3 66 90 48 8b 05 19 3c 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 3b 2c 00 f7 d8 64 89 01 48
> [10960.981413] RSP: 002b:00007fff5335ca08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [10960.983472] RAX: ffffffffffffffda RBX: 00007fff5335ca98 RCX: 00007f639fe9b267
> [10960.985037] RDX: 00007fff5335ca80 RSI: 00000000c0181b01 RDI: 0000000000000003
> [10960.986603] RBP: 00007fff5335ca60 R08: 0000000000000003 R09: 00007f63a055e010
> [10960.988194] R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f63a055e150
> [10960.989903] R13: 00007fff5335ca60 R14: 00007fff5335cc38 R15: 00007f6397246000
> [10960.991544] ---[ end trace 1f0ee07a75a16a93 ]---
> [10960.992773] ------------[ cut here ]------------
> [10960.993995] WARNING: CPU: 3 PID: 8838 at mm/gup.c:150 try_grab_page+0x55/0x70
> [10960.995758] Modules linked in: nfsv3 nfs_acl rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp rpcrdma rdma_ucm ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_ib ib_uverbs ib_core kvm_intel mlx5_core rfkill mlxfw sunrpc virtio_net pci_hyperv_intf kvm irqbypass net_failover crc32_pclmul i2c_piix4 ptp crc32c_intel failover pcspkr ghash_clmulni_intel i2c_core pps_core sch_fq_codel ip_tables ata_generic pata_acpi serio_raw ata_piix floppy [last unloaded: mlxkvl]
> [10961.008579] CPU: 3 PID: 8838 Comm: consume_mtts Tainted: G        W  OE     5.5.0-rc2-for-upstream-perf-2019-12-18_10-06-50-78 #1
> [10961.011416] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> [10961.013766] RIP: 0010:try_grab_page+0x55/0x70
> [10961.014921] Code: 00 04 00 00 b8 01 00 00 00 f3 c3 48 8b 47 08 a8 01 75 1c 8b 47 34 85 c0 7e 1d f0 ff 47 34 b8 01 00 00 00 c3 48 8d 78 ff eb cb <0f> 0b 31 c0 c3 48 8d 78 ff 66 90 eb dc 0f 0b 31 c0 c3 66 0f 1f 84
> [10961.019058] RSP: 0018:ffffc9000129f7e8 EFLAGS: 00010282
> [10961.020351] RAX: 0000000080000001 RBX: 0000000000050201 RCX: 000000000f5d8000
> [10961.021921] RDX: 000ffffffffff000 RSI: 0000000000040000 RDI: ffffea000f5d8000
> [10961.023494] RBP: 00007f6397400000 R08: ffffea000f986cc0 R09: ffff8883c758bdd0
> [10961.025067] R10: 0000000000000001 R11: ffff888000000230 R12: ffff888407701c00
> [10961.026637] R13: ffff8883e61b35d0 R14: ffffea000f5d8000 R15: 0000000000050201
> [10961.028217] FS:  00007f63a0590740(0000) GS:ffff88842f980000(0000) knlGS:0000000000000000
> [10961.030353] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [10961.031721] CR2: 00000000023e9008 CR3: 0000000406d0a002 CR4: 00000000007606e0
> [10961.033305] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [10961.034884] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [10961.036456] PKRU: 55555554
> [10961.037369] Call Trace:
> [10961.038285]  follow_trans_huge_pmd+0x10c/0x300
> [10961.039555]  follow_page_mask+0x64a/0x760
> [10961.040762]  __get_user_pages+0xf1/0x720
> [10961.041851]  ? apic_timer_interrupt+0xa/0x20
> [10961.042996]  internal_get_user_pages_fast+0x14b/0x1c0
> [10961.044266]  ib_umem_get+0x2b3/0x5a0 [ib_uverbs]
> [10961.045474]  mr_umem_get+0xd8/0x280 [mlx5_ib]
> [10961.046652]  ? xas_store+0x49/0x550
> [10961.047696]  mlx5_ib_reg_user_mr+0x149/0x7a0 [mlx5_ib]
> [10961.048967]  ? xas_load+0x9/0x80
> [10961.049949]  ? xa_load+0x54/0x90
> [10961.050935]  ? lookup_get_idr_uobject.part.10+0x12/0x80 [ib_uverbs]
> [10961.052378]  ib_uverbs_reg_mr+0x138/0x2a0 [ib_uverbs]
> [10961.053635]  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xb1/0xf0 [ib_uverbs]
> [10961.055646]  ib_uverbs_cmd_verbs.isra.8+0x997/0xb30 [ib_uverbs]
> [10961.057033]  ? uverbs_disassociate_api+0xd0/0xd0 [ib_uverbs]
> [10961.058381]  ? mem_cgroup_commit_charge+0x6a/0x140
> [10961.059611]  ? page_add_new_anon_rmap+0x58/0xc0
> [10961.060796]  ib_uverbs_ioctl+0xbc/0x130 [ib_uverbs]
> [10961.062034]  do_vfs_ioctl+0xa6/0x640
> [10961.063081]  ? syscall_trace_enter+0x1f8/0x2e0
> [10961.064253]  ksys_ioctl+0x60/0x90
> [10961.065252]  __x64_sys_ioctl+0x16/0x20
> [10961.066315]  do_syscall_64+0x48/0x130
> [10961.067382]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [10961.068647] RIP: 0033:0x7f639fe9b267
> [10961.069691] Code: b3 66 90 48 8b 05 19 3c 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 3b 2c 00 f7 d8 64 89 01 48
> [10961.073882] RSP: 002b:00007fff5335ca08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [10961.075949] RAX: ffffffffffffffda RBX: 00007fff5335ca98 RCX: 00007f639fe9b267
> [10961.077545] RDX: 00007fff5335ca80 RSI: 00000000c0181b01 RDI: 0000000000000003
> [10961.079128] RBP: 00007fff5335ca60 R08: 0000000000000003 R09: 00007f63a055e010
> [10961.080709] R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f63a055e150
> [10961.082278] R13: 00007fff5335ca60 R14: 00007fff5335cc38 R15: 00007f6397246000
> [10961.083873] ---[ end trace 1f0ee07a75a16a94 ]---
> 
> Thanks
> 
