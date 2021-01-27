Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297503062E7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbhA0SBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235091AbhA0SA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:00:58 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B95C06174A;
        Wed, 27 Jan 2021 10:00:17 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id p21so3895816lfu.11;
        Wed, 27 Jan 2021 10:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFMN9onqllDx0JO+g/LmIUXKcLoeGQxKuSLE4P7rhPM=;
        b=HLLxp7nIcFF2FU/CvOE3BlIJCheP75vlctnzmxdx+/wB2+Zgnt7AZoDmAiMDmAE8Lp
         JZnAmprluMwKHZKPM3fz/1JMYJu9b+jkoRpzxlk2TlnOwsuMVvhrldNd9dHQu5iK6Vwp
         fXeumtskuhrk3HMOYx8k8MAsbUZAVY+txGFn1RKylVKdWiXvMdkQMV1Ba86EXXkuTdcv
         ZvubYJtb0/O93HlrSv5VOC8m7AtSZiFitlo1YFZAMuqtsAvb/lmXmqKzEUhMyqhxpWBE
         fCdB6m2/vQgkPq73Fi/rGsA/DBr0m4COTvaj7q2twKdCoTQG2WcwQN+npEjNPGvEXLYB
         seXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFMN9onqllDx0JO+g/LmIUXKcLoeGQxKuSLE4P7rhPM=;
        b=G9MGn+FvsbKekUnE/rwd4mHiT0/Opy8UR6VFxxkS4vLV7htlIom/606YQ1p9sGxYyG
         gb+RxiuEB2hdRs/DV/Hs+RqfvKU0hL0OKT22rbXeMEZEUVuGCadGjKA2oz5nX1gk/IhM
         7V8VnI3iRwWrCn10goRjAUWkAxriKsX7wSDqR3l5RcfC/r9415GSgHntZivG6QpLzJsP
         /jq61In3GCusFBETxzADdjtlWRbVgVjmX0gOgxlNGecRQdzt1gI1e0jEwkcrMygjNiRZ
         m3qptej0Xr85GDDkRKB0qudKNPZJH69ewZaQj3Fz82sBk/BBGmgAJEceSy3veT6enn1S
         3CWQ==
X-Gm-Message-State: AOAM530jGD2U0r3AhZGnr2GDF0cXtq9Yy/aIOzzY+M687osnEna01/8h
        O3v7UWNqXIXQsIC+WByPJf97Trx1IAxF6GFTEKs=
X-Google-Smtp-Source: ABdhPJwnLxauhycV4xuaAfkSvaCO3mPdf39CwZ0FqYZtIlej0RICgFE+W0FesCuKYGXQhJ4LZpNQEvrDsIJKFQ/y2tw=
X-Received: by 2002:a19:6d07:: with SMTP id i7mr5994244lfc.75.1611770416292;
 Wed, 27 Jan 2021 10:00:16 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
In-Reply-To: <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Jan 2021 10:00:04 -0800
Message-ID: <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >               ret = PTR_ERR(l_new);
> > > +             if (ret == -EAGAIN) {
> > > +                     htab_unlock_bucket(htab, b, hash, flags);
> > > +                     htab_gc_elem(htab, l_old);
> > > +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> > > +                     goto again;
> >
> > Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
> > in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?
>
> In this case, the old one is scheduled for removal in GC, we just wait for GC
> to finally remove it. It won't stall unless GC itself or the worker scheduler is
> wrong, both of which should be kernel bugs.
>
> If we don't do this, users would get a -E2BIG when it is not too big. I don't
> know a better way to handle this sad situation, maybe returning -EBUSY
> to users and let them call again?

I think using wq for timers is a non-starter.
Tying a hash/lru map with a timer is not a good idea either.

I think timers have to be done as independent objects similar to
how the kernel uses them.
Then there will be no question whether lru or hash map needs it.
The bpf prog author will be able to use timers with either.
The prog will be able to use timers without hash maps too.

I'm proposing a timer map where each object will go through
bpf_timer_setup(timer, callback, flags);
where "callback" is a bpf subprogram.
Corresponding bpf_del_timer and bpf_mod_timer would work the same way
they are in the kernel.
The tricky part is kernel style of using from_timer() to access the
object with additional info.
I think bpf timer map can model it the same way.
At map creation time the value_size will specify the amount of extra
bytes necessary.
Another alternative is to pass an extra data argument to a callback.
