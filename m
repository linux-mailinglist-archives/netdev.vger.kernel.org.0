Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D409A4A7FBB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347537AbiBCHZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiBCHZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 02:25:03 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38817C061714;
        Wed,  2 Feb 2022 23:25:03 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e79so2093497iof.13;
        Wed, 02 Feb 2022 23:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=obNs/UCtJWI+Udtprzfhd/c78/ANgv8/P0zEYbBkkbE=;
        b=MCkdGSCoWl61o1oQqPY68fKUA9nmIJoLjbH+eeMGgQ5ziySuzG7MYLULCxSeMWZ3ws
         LMFIHZH704h+mb9SKup1unid2LSGQMu9TACA5vAfnyjhB4mCcfsrEMwFtyjHU3D2sEz0
         wc1MoiZNytK9LHqtzboJs0l2VSWatwll6znJxjC5lp0W++mhCLDLbJaD8+sA+qwbapy2
         aknI1Uq0NfsYvXg9F+Xm7rrHu3KFNgBldqqdsVrFKI4XJetI5Bcd+hH1McpKL04A2YMJ
         dZMVTGR2puTAS2/838rvP0uNUxtPW0naYBlZzns6gcSdFr+uMFnEm66RqfLPtscXITzI
         t2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=obNs/UCtJWI+Udtprzfhd/c78/ANgv8/P0zEYbBkkbE=;
        b=1Rs0hZOrcAo5j/+01Ts8dsuydkNHWA+sKZamU8Zl+tH0RKYVZa3rzYxr1uZqq3DVrv
         bq7xBuUW2kAFpEY62ElA5ZIbQwTSIX6XvhVuiTaqHHCEGnbQ7nwkJPOtEc1Td32mbZWI
         5fUw/iUrdPn1MatltVG+G2sjJLxfzxA37Kzr3WLOA9YeZ8zw3V/6AkNg2esFhjR+nh8Q
         EoYMTjshH6QtCA0s4VV7ekJpoWUQPlfv7f+mRYuenXMRykr3fBpbo2u4jiC6qk/KyIKG
         TPBTw9cv0amxGPFx/gC+x+CDk2sEIH4O6fdwNmzPgIDqSIOIfdwOFgJDt8lmgH38fTzm
         XLbg==
X-Gm-Message-State: AOAM531AWkevk7CxWUcKgvMTyVrh6jqC8IsI//5pyNJNNSt3eDdKJWIg
        8NE/j/3MBfUUC0Nad50P8PqgG41G2MhD4h5KF7YY4y78So0=
X-Google-Smtp-Source: ABdhPJyKDWbTAeGIrDJb3I3hxDkySBBeJmZE3Kv2cnpCMVw8HFn8Rxf0yLs+J92BOO7iFKvtizz8q3o2Lwuqa5ZkcYs=
X-Received: by 2002:a05:6638:304d:: with SMTP id u13mr15395389jak.103.1643873102621;
 Wed, 02 Feb 2022 23:25:02 -0800 (PST)
MIME-Version: 1.0
References: <c6c74927-0199-617a-c4b2-bb4d0a733906@iogearbox.net> <20220203051427.23315-1-houtao1@huawei.com>
In-Reply-To: <20220203051427.23315-1-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Feb 2022 23:24:51 -0800
Message-ID: <CAEf4BzbA8ZH5HJHh=mzg2pvTsMcNMJLeWMZ6tUEahxJnppfPcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
To:     Hou Tao <hotforest@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, andreyknvl@google.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hou Tao <houtao1@huawei.com>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 9:14 PM Hou Tao <hotforest@gmail.com> wrote:
>
> Hi,
>
> > On 2/2/22 7:01 AM, Hou Tao wrote:
> > > After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
> > > after mapping"), non-VM_ALLOC mappings will be marked as accessible
> > > in __get_vm_area_node() when KASAN is enabled. But now the flag for
> > > ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
> > > after vmap() returns. Because the ringbuf area is created by mapping
> > > allocated pages, so use VM_MAP instead.
> > >
> > > After the change, info in /proc/vmallocinfo also changes from
> > >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> > > to
> > >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user
> > >
> > > Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
> > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > > ---
> > > v2:
> > >    * explain why VM_ALLOC will lead to vmalloc-oob access
> >
> > Do you know which tree commit 2fd3fb0be1d1 is, looks like it's neither
> > in bpf nor in bpf-next tree at the moment.
> >
> It is on linux-next tree:
>
>  $ git name-rev 2fd3fb0be1d1
>  2fd3fb0be1d1 tags/next-20220201~2^2~96
>
> > Either way, I presume this fix should be routed via bpf tree rather
> > than bpf-next? (I can add Fixes tag while applying.)
> >
> Make sense and thanks for that.

Added

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier
support for it")

and pushed to bpf tree, thanks.

>
> Regards,
> Tao
>
> > >    * add Reported-by tag
> > > v1: https://lore.kernel.org/bpf/CANUnq3a+sT_qtO1wNQ3GnLGN7FLvSSgvit2UVgqQKRpUvs85VQ@mail.gmail.com/T/#t
> > > ---
> > >   kernel/bpf/ringbuf.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > > index 638d7fd7b375..710ba9de12ce 100644
> > > --- a/kernel/bpf/ringbuf.c
> > > +++ b/kernel/bpf/ringbuf.c
> > > @@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> > >     }
> > >
> > >     rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > > -             VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > > +             VM_MAP | VM_USERMAP, PAGE_KERNEL);
> > >     if (rb) {
> > >             kmemleak_not_leak(pages);
> > >             rb->pages = pages;
> > >
> >
> >
