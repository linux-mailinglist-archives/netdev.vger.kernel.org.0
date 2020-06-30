Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2CF20ED36
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgF3FMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgF3FMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:12:07 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16FCC061755;
        Mon, 29 Jun 2020 22:12:06 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b185so6899792qkg.1;
        Mon, 29 Jun 2020 22:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGplCeeRJoAyufaAlmCwLaugI8cgJNgw65k+WGYRnHA=;
        b=CpaXFVZlpVAXY2yH4khkp6NrDgW+8cSR+mkXcCmZImtrEnz10ZfMcUyIE+Oa6YZJbx
         Y82mJWbMxqnTuZVk9FIoW02+m7lGS4PS1XC2CveJStF/mntg1lvksz5gh/e0zqZ6apue
         ITDcHi8vp2RAEJHdKkl0+BdgoG6ZOKuXFj8gMXYImGWjRUuOu8COqR49s235LF5YNJem
         i99VgA+b51Ijl4m3PIJro1P7RVOOUv35GyZEWPXf9T3cVKmJp3M6xaxE1MF/3R7n7QvC
         05W6unvmdHIGvwjc8Jy/IkJUSm2U6T8CnCUJx8AziCX7ST+Ol31BMepNQJI7sfXq5UVz
         WS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGplCeeRJoAyufaAlmCwLaugI8cgJNgw65k+WGYRnHA=;
        b=IMDmiXW2hDmbQ1UiIzYyEC8sj0164KHGFYAanCT4EPyQhtJol/aTM2nfcVSq4O2c4O
         xDCnz4/XBYXl9aTFMqOXFulmqtPXNExBymyT9v5meUFJkM3lFZcX4fq/Fe7OrMFV28Fc
         NNULUZEZdqpKmdVa3uBUkTaS2beMphAZCNkje7RCrj4zC8ox0XLtU1ZXztwK3SX46G/m
         AQvbXwSe7yF5fio0e2x5MUyfI+nhZ7m0RV66dfPymuoH4xDMBMyII2C+l/etpS1yekwC
         GLJO71ycbXsITQ9h880K+iEVz7uYzXWAdlj2M4/S5RmcI5fbwdRnYf08mAlEdxJKs+RD
         gpjQ==
X-Gm-Message-State: AOAM530kWCXyJJOKEcfORIJJyABMcd0slUqH3kQANw82ySn1CKuNpYTk
        GNyURcj3l1fzyt1znIIqdLFvkNnqeQqfVBSbSZA=
X-Google-Smtp-Source: ABdhPJz0krLS9xLR59lh5jFL00U1uqURjzBGWNKJW3rhcljp7ogIRQ09FsQg4w2EQ9bCjer9GYc+y2CCC1/lk9O0XHo=
X-Received: by 2002:a37:270e:: with SMTP id n14mr17217715qkn.92.1593493925876;
 Mon, 29 Jun 2020 22:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200629221746.4033122-1-andriin@fb.com> <CAADnVQLkPPxvFV4ZftGeTNWfhtVnGR+Y8NAYZUmuyOcU_M_Y8g@mail.gmail.com>
In-Reply-To: <CAADnVQLkPPxvFV4ZftGeTNWfhtVnGR+Y8NAYZUmuyOcU_M_Y8g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 22:11:54 -0700
Message-ID: <CAEf4BzaMt-b=Td2A+XmjzcYF0-TrwnbosyDk3Tr+3cztpar=dw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: enforce BPF ringbuf size to be the power of 2
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 9:47 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 3:19 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > BPF ringbuf assumes the size to be a multiple of page size and the power of
> > 2 value. The latter is important to avoid division while calculating position
> > inside the ring buffer and using (N-1) mask instead. This patch fixes omission
> > to enforce power-of-2 size rule.
> >
> > Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  kernel/bpf/ringbuf.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > index 180414bb0d3e..dcc8e8b9df10 100644
> > --- a/kernel/bpf/ringbuf.c
> > +++ b/kernel/bpf/ringbuf.c
> > @@ -132,7 +132,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
> >  {
> >         struct bpf_ringbuf *rb;
> >
> > -       if (!data_sz || !PAGE_ALIGNED(data_sz))
> > +       if (!is_power_of_2(data_sz) || !PAGE_ALIGNED(data_sz))
> >                 return ERR_PTR(-EINVAL);
>
> What's the point checking the same value in two different places?
> The check below did that already.

I was initially treating bpf_ringbuf_alloc() as a sort of internal API
that some other code (outside of BPF map) might want to use. But I'll
drop for now, it can always be added later.

>
> >  #ifdef CONFIG_64BIT
> > @@ -166,7 +166,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
> >                 return ERR_PTR(-EINVAL);
> >
> >         if (attr->key_size || attr->value_size ||
> > -           attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> > +           !is_power_of_2(attr->max_entries) ||
> > +           !PAGE_ALIGNED(attr->max_entries))
> >                 return ERR_PTR(-EINVAL);
> >
> >         rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> > --
> > 2.24.1
> >
