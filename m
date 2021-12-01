Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DF1464BA2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 11:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348669AbhLAKdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 05:33:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36870 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348628AbhLAKc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 05:32:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D040EB81E29;
        Wed,  1 Dec 2021 10:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBF0C53FCC;
        Wed,  1 Dec 2021 10:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638354576;
        bh=AETMMOBDPGn+QVfejghVAmHwWjI/7/bsub2Dx0V2n1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kKgNhAT9qH3X2bUtpCTaa4PNttI8HZMuvoKs8aX6pG8r4gCGfx5dMJ9/G5IojdnF/
         GWHDgbTR/TDyRo3f6cbXyTjzYQTqgN6bZFr7zUK4d1hxBtNdgteSj5cRFLCLRXJNwA
         /ZJBUwyY1+upcObJyXqZifHGIEweRgPdO0F8Y3T6KqKa2cwoC7yaVbNIzJmO/KPVqC
         Uw5O8sCg4RIjbd1HoZdVa5MVqIq8gLT59onNjcqsJA03dXd2pBHV2IYeRnMbrusKwD
         0qqD0LWz+0TAsaaIOLHoNwoYmhnVIx69NoL8WVdNd+jyMtlh++pQuhxYNK2FzhE/Y3
         eELnK/kXRIHDg==
Date:   Wed, 1 Dec 2021 12:29:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Bixuan Cui <cuibixuan@linux.alibaba.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH -next] bpf: Add oversize check before call kvmalloc()
Message-ID: <YadOjJXMTjP85MQx@unreal>
References: <1638027102-22686-1-git-send-email-cuibixuan@linux.alibaba.com>
 <CAEf4BzbV=s+C=dFS5YfAdJhiBv+3ocanaZ-NNHoPz8RzHhGCbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbV=s+C=dFS5YfAdJhiBv+3ocanaZ-NNHoPz8RzHhGCbQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 02:53:16PM -0800, Andrii Nakryiko wrote:
> On Sat, Nov 27, 2021 at 7:32 AM Bixuan Cui <cuibixuan@linux.alibaba.com> wrote:
> >
> > Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add
> > the oversize check. When the allocation is larger than what kvmalloc()
> > supports, the following warning triggered:
> >
> > WARNING: CPU: 1 PID: 372 at mm/util.c:597 kvmalloc_node+0x111/0x120
> > mm/util.c:597
> > Modules linked in:
> > CPU: 1 PID: 372 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> > Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 60
> > 20 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 4f 20 d1 ff <0f> 0b e9
> > 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 36
> > RSP: 0018:ffffc90002bf7c98 EFLAGS: 00010216
> > RAX: 00000000000000ec RBX: 1ffff9200057ef9f RCX: ffffc9000ac63000
> > RDX: 0000000000040000 RSI: ffffffff81a6a621 RDI: 0000000000000003
> > RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
> > R10: ffffffff81a6a5de R11: 0000000000000000 R12: 00000000ffff9aaa
> > R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
> > FS:  00007f05f2573700(0000) GS:ffff8880b9d00000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b2f424000 CR3: 0000000027d2c000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  kvmalloc include/linux/slab.h:741 [inline]
> >  map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
> >  __sys_bpf+0x3a5b/0x5f00 kernel/bpf/syscall.c:4603
> >  __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
> >  __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
> >  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > The type of 'value_size' is u32, its value may exceed INT_MAX.
> >
> > Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com
> > Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
> > ---
> >  kernel/bpf/syscall.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 1033ee8..f5bc380 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1094,6 +1094,10 @@ static int map_lookup_elem(union bpf_attr *attr)
> >         }
> >
> >         value_size = bpf_map_value_size(map);
> > +       if (value_size > INT_MAX) {
> > +               err = -EINVAL;
> 
> -E2BIG makes a bit more sense in this scenario?

kvmalloc should be fixed do not print WARN_ON() on attempts to provide
such allocations sizes.

We are in RDMA, and everyone who receives this size as an input from the
user, seeing this type of error.

Thanks

> 
> > +               goto err_put;
> > +       }
> >
> >         err = -ENOMEM;
> >         value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
> > --
> > 1.8.3.1
> >
