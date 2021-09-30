Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0A41D975
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349216AbhI3MQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348201AbhI3MQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 08:16:08 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094BAC06176A;
        Thu, 30 Sep 2021 05:14:26 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r1so12607426ybo.10;
        Thu, 30 Sep 2021 05:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ly6d2NRz/CO4e+/occWByJ+1ybkH2AhzgC827GNKok=;
        b=D3yALrGFWCHoJefkI8XjZMKrwZ18ui6XDMw4t95SVu6n4b+QlQDXUbKuYqj+3ZUR77
         4OraB2xwKiXlxZZNnGmNOHTq5acSirqEeu5hMoj3h8R24v2FpumBTvNIfEGIUIDjTWke
         dkjas9WJSrST1VbmPCOntur+clVa23wWWI2RAVuGhzrik9BskkbnlF3cScob9/OZa++q
         zXE7q1BSlOymhD3sKQLngpY0g741BFHsJFuU/FMsebpo+A1PiQtm3o24bcLml9xVln5K
         mrZ0oBecfxxCxRSmjBC9vfAJ90S8NFMZroKhANmw42yTzYnnMAF+9h8wraYhzlLDGKFA
         usSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ly6d2NRz/CO4e+/occWByJ+1ybkH2AhzgC827GNKok=;
        b=6pQCy3Mz9Ed8lQbEZNRY59215zyoScAKpxk9w8IJMOBESr0+Yd9RF/WUL1zHUZKCXj
         pxOpEuAKHVpgKU01ihekITnqDM9MHtfws9wy3tHeRP2XaHlNPPhns9h8RfxY4M4FYwYT
         iLFQ660BxVWNWq5zsA2sU+qoPE+U0PhEExLEt8Vn+6OzyhHWBaR9etB1hPZDtq+VGuBt
         QVzWgJXjonnhOJgJspECOmhc92aN9vNxHcFBidgPKSmiIXEI7uGEzEWHTNjgvJuOcCww
         ibvGBJbnlmR8AdfMhgU9rtemxQ6+uuZxUpTEVg9kOzEDkDiEfyG0jZQsR7iEOzpcsPS5
         fJCQ==
X-Gm-Message-State: AOAM530A6wYG0clXk9FoWtIDr7zgtbxN+GCbZk+C8fQREasNAO2Yl8Os
        22ejaHgj0QmgWuUhvRF0+qKZ9qHP1V6Tw0CLJ8o=
X-Google-Smtp-Source: ABdhPJx8FtzrbD51HUmiENPFGgET25pOeR5F1yAAzL7J7koVSiUqSLdK0Jmqh5ZoQDDR0cyJLgayWISpxy8Dt9tMI4E=
X-Received: by 2002:a25:515:: with SMTP id 21mr6157057ybf.279.1633004065280;
 Thu, 30 Sep 2021 05:14:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210925053106.1031798-1-th.yasumatsu@gmail.com> <9be5acb8-5eaa-6101-1be8-a74d7df7e20e@iogearbox.net>
In-Reply-To: <9be5acb8-5eaa-6101-1be8-a74d7df7e20e@iogearbox.net>
From:   Tatushiko Yasumatsu <th.yasumatsu@gmail.com>
Date:   Thu, 30 Sep 2021 21:14:14 +0900
Message-ID: <CA+_JbcvO-1NZ1aumJoVfJyRgnGv49U1pMqMvQS7h3j1FUfMO1g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix integer overflow in prealloc_elems_and_freelist()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tatushiko Yasumatsu <th.yasumatsu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:29:43PM +0200, Daniel Borkmann wrote:
> On 9/25/21 7:31 AM, Tatsuhiko Yasumatsu wrote:
> > In prealloc_elems_and_freelist(), the multiplication to calculate the
> > size passed to bpf_map_area_alloc() could lead to an integer overflow.
> > As a result, out-of-bounds write could occur in pcpu_freelist_populate()
> > as reported by KASAN:
> >
> > [...]
> > [   16.968613] BUG: KASAN: slab-out-of-bounds in pcpu_freelist_populate+0xd9/0x100
> > [   16.969408] Write of size 8 at addr ffff888104fc6ea0 by task crash/78
> > [   16.970038]
> > [   16.970195] CPU: 0 PID: 78 Comm: crash Not tainted 5.15.0-rc2+ #1
> > [   16.970878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > [   16.972026] Call Trace:
> > [   16.972306]  dump_stack_lvl+0x34/0x44
> > [   16.972687]  print_address_description.constprop.0+0x21/0x140
> > [   16.973297]  ? pcpu_freelist_populate+0xd9/0x100
> > [   16.973777]  ? pcpu_freelist_populate+0xd9/0x100
> > [   16.974257]  kasan_report.cold+0x7f/0x11b
> > [   16.974681]  ? pcpu_freelist_populate+0xd9/0x100
> > [   16.975190]  pcpu_freelist_populate+0xd9/0x100
> > [   16.975669]  stack_map_alloc+0x209/0x2a0
> > [   16.976106]  __sys_bpf+0xd83/0x2ce0
> > [...]
> >
> > The possibility of this overflow was originally discussed in [0], but
> > was overlooked.
> >
> > Fix the integer overflow by casting one operand to u64.
> >
> > [0] https://lore.kernel.org/bpf/728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com/
> >
> > Fixes: 557c0c6e7df8 ("bpf: convert stackmap to pre-allocation")
> > Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
> > ---
> >   kernel/bpf/stackmap.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> > index 09a3fd97d329..8941dc83a769 100644
> > --- a/kernel/bpf/stackmap.c
> > +++ b/kernel/bpf/stackmap.c
> > @@ -66,7 +66,7 @@ static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
> >     u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
>
> Thanks a lot for the fix, Tatsuhiko! Could we just change the above elem_size to u64 instead?

Thank you for your review, Daniel!
Yes, I think it's possible to just change elem_size to u64.

We just have to be careful to cast one operand (smap->map.value_size)
to u64, so that the integer overflow won't happen in 32-bit
architectures.
This is necessary because in 32-bit architectures, the result of
sizeof() is a 32-bit integer.

I will update the patch.

>
> >     int err;
> > -   smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
> > +   smap->elems = bpf_map_area_alloc((u64)elem_size * smap->map.max_entries,
> >                                      smap->map.numa_node);
> >     if (!smap->elems)
> >             return -ENOMEM;
> >
>
> Best,
> Daniel

Best regards,
Tatsuhiko Yasumatsu
