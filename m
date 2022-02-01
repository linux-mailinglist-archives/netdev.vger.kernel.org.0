Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9304A54B7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 02:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiBABfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 20:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiBABfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 20:35:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755A5C061714;
        Mon, 31 Jan 2022 17:35:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 396016127D;
        Tue,  1 Feb 2022 01:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A967C36AE2;
        Tue,  1 Feb 2022 01:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643679298;
        bh=dp5GfBZlWK/76zAgmaghbi69RmaTVYKP8oGHHjSzkZ4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b0avxoBngR0FmyTguj/RtEqHknqkae7nkG2PrXaktcLoGHFtCJuGy61fsbTwQpdlU
         64s+VbLb+iGAbHqmuUWadGrZSwG3vjDMLwXAQ591GnkTFkpZp+YY+vNVpTkLC2MXLI
         ArydQmcQAybaHbwyWz5//R/3wGh1CfCaNxiAlMqn33asJx/pjuO4LhpFGbeY8EaV7D
         8HHAuh8PV4zHwJLt6pP/9JEtt+8s+RUQ13/EvDpcz2L67qEAMtt6BPNE4gmJ5hso7+
         sRdfDDp4SHD3XV8Q1ElpVgI0ohc8CLcHDQ3ZeKZoBc65JbGti6fxpCFUJHDayuHUAA
         RKWOxvuVwgEKQ==
Received: by mail-yb1-f174.google.com with SMTP id c19so17423815ybf.2;
        Mon, 31 Jan 2022 17:34:58 -0800 (PST)
X-Gm-Message-State: AOAM533QI8Ll7+AiCQIZqXRrKAmnTj0aXs2jemOr1rTQireZ2gija4/Q
        pl5HP0Sc1uq4GBR6XvhqYQ8Jg5kI9925tU4qXeE=
X-Google-Smtp-Source: ABdhPJxPhm2qvy5gh/yC1btwsle5xpf0Wt1yKVdXcinI8Y201wkaXJfl3Kozi0DqByBzNY8FOkGw7JcWk12iVTG4iZ0=
X-Received: by 2002:a05:6902:1208:: with SMTP id s8mr35728901ybu.654.1643679297710;
 Mon, 31 Jan 2022 17:34:57 -0800 (PST)
MIME-Version: 1.0
References: <20220128234517.3503701-1-song@kernel.org> <20220128234517.3503701-8-song@kernel.org>
 <ab7e0a98-fced-23b3-6876-01ce711bd579@iogearbox.net>
In-Reply-To: <ab7e0a98-fced-23b3-6876-01ce711bd579@iogearbox.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 31 Jan 2022 17:34:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5Pfvn8GNfuuuEGzdyugGDLF_g-V3T7RihBrxoQLxNb5g@mail.gmail.com>
Message-ID: <CAPhsuW5Pfvn8GNfuuuEGzdyugGDLF_g-V3T7RihBrxoQLxNb5g@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 7/9] bpf: introduce bpf_prog_pack allocator
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 4:06 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/29/22 12:45 AM, Song Liu wrote:
> > Most BPF programs are small, but they consume a page each. For systems
> > with busy traffic and many BPF programs, this could add significant
> > pressure to instruction TLB.
> >
> > Introduce bpf_prog_pack allocator to pack multiple BPF programs in a huge
> > page. The memory is then allocated in 64 byte chunks.
> >
> > Memory allocated by bpf_prog_pack allocator is RO protected after initial
> > allocation. To write to it, the user (jit engine) need to use text poke
> > API.
>
> Did you benchmark the program load times under this API, e.g. how much
> overhead is expected for very large programs?

For the two scale tests in test_verifier:

./test_verifier 965 966
#965/p scale: scale test 1 OK
#966/p scale: scale test 2 OK

The runtime is about 0.6 second before the set and 0.7 second after.

Is this a good benchmark?

>
> > Signed-off-by: Song Liu <song@kernel.org>
> > ---
> >   kernel/bpf/core.c | 127 ++++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 127 insertions(+)
> >
[...]
> > +     }
> > +     mutex_lock(&pack_mutex);
> > +     list_for_each_entry(pack, &pack_list, list) {
> > +             pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
> > +                                              nbits, 0);
> > +             if (pos < BPF_PROG_CHUNK_COUNT)
> > +                     goto found_free_area;
> > +     }
> > +
> > +     pack = alloc_new_pack();
> > +     if (!pack)
> > +             goto out;
>
> Will this effectively disable the JIT for all bpf_prog_pack_alloc requests <=
> BPF_PROG_MAX_PACK_PROG_SIZE when vmap_allow_huge is false (e.g. boot param via
> nohugevmalloc) ?

This won't disable JIT. It will just allocate 512x 4k pages for a 2MB pack. We
will mark the whole 2MB RO, same as a 2MB huge page. We still benefit
from this as this avoids poking the linear mapping (1GB pages) to 4kB pages
with set_memory_ro().

Thanks,
Song
