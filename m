Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859A54FC778
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbiDKWSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiDKWSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:18:02 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5452126E;
        Mon, 11 Apr 2022 15:15:47 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id q11so20378445iod.6;
        Mon, 11 Apr 2022 15:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ghy1UswEx6W00pg1cAv/pF841qi0AmfQEmewriQWJBs=;
        b=dcVp+hrbmD/m/P0sVNANzMYqawG4Iygh4NY+WK9XwNBErx9AcxSG/ZhU5kh4MLNyDl
         OLn/f+MsMEDyrIhykWCdo6BYe5sGmgJOJU/lf07fKmlPd954bGI5rF4u7UkXpO1ZeTnI
         bkuycLc/gCAspPercz7Seqlhf9Uj0FYEI05lT5G3zcviNCqd2LmIrtRFXnbOGHwHTVlZ
         n/+hSsF+D3maVmBKJAhVJvg/G7iXKUMtObKw2Zsuv002VuRlAFzOy7ugDxTtJIVyosVK
         yghk1fsXau1MViZvz1XLNHth82HG+6ORoNyih8E6oLj44Nbm4aWp85vDgx6dG7iL/THD
         CXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ghy1UswEx6W00pg1cAv/pF841qi0AmfQEmewriQWJBs=;
        b=5turyEgoUZ1BEmG91PNaVd1q74ILjS72oH9ZG0ZToz5sXAxldlPR4B6Iy+Qru08OJB
         R7nCb8cJH8fChdso5K9NVuPHXo4MbQ3kIRokBiqfq7O3xABWurtYvfl0oFveExWJqxj4
         N9bYZ6OiBVGF/klo7Jg7XL34Ky6YeVCa6Br2wgE3DUxn7jdEisqP1fb7c7Jh3kAYXQEy
         RCo6/C+JH1A9X2yH2PVBnJN02KiU85n4btngEVHQnSPY/XRP0EDFbdQ7G6M65h/qru+b
         fz79qQqecGxys8d2Qb02Wel47HviStBwahFDy8fTGTvRtKySbIyZJqT8rpCbzMztxjKC
         cQ7A==
X-Gm-Message-State: AOAM5338pXOrYX/awVNYxQSvgJFdPuLbELZO7/aAtUa0uWYnoXGyzUK+
        VLAyim8hSsQvSBn6cKKkYKTMPfVun4+Z2h5TGDl+FQod
X-Google-Smtp-Source: ABdhPJz//PCz8xh3ol8xW1/hvvN9dhh1a8liK1zU1xJtRnFH696EzAj1ao/6nV1GIGXnGzGDkSG6Yv6RkSbMXNetGpM=
X-Received: by 2002:a02:cc07:0:b0:326:3976:81ad with SMTP id
 n7-20020a02cc07000000b00326397681admr1865761jap.237.1649715346615; Mon, 11
 Apr 2022 15:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-4-jolsa@kernel.org>
 <20220408232610.nwtcuectacpwh6rk@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220408232610.nwtcuectacpwh6rk@MBP-98dd607d3435.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:15:35 -0700
Message-ID: <CAEf4BzZYopSrVo=fdnu2q1U9LwcOJartwreWqM=u=aoV+ZNncQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/4] bpf: Resolve symbols with kallsyms_lookup_names
 for kprobe multi link
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 4:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 07, 2022 at 02:52:23PM +0200, Jiri Olsa wrote:
> > Using kallsyms_lookup_names function to speed up symbols lookup in
> > kprobe multi link attachment and replacing with it the current
> > kprobe_multi_resolve_syms function.
> >
> > This speeds up bpftrace kprobe attachment:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> >
> > After:
> >
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
> >  1 file changed, 73 insertions(+), 50 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b26f3da943de..2602957225ba 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
> >       unsigned long entry_ip;
> >  };
> >
> > +struct user_syms {
> > +     const char **syms;
> > +     char *buf;
> > +};
> > +
> > +static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
> > +{
> > +     const char __user **usyms_copy = NULL;
> > +     const char **syms = NULL;
> > +     char *buf = NULL, *p;
> > +     int err = -EFAULT;
> > +     unsigned int i;
> > +     size_t size;
> > +
> > +     size = cnt * sizeof(*usyms_copy);
> > +
> > +     usyms_copy = kvmalloc(size, GFP_KERNEL);
> > +     if (!usyms_copy)
> > +             return -ENOMEM;
> > +
> > +     if (copy_from_user(usyms_copy, usyms, size))
> > +             goto error;
> > +
> > +     err = -ENOMEM;
> > +     syms = kvmalloc(size, GFP_KERNEL);
> > +     if (!syms)
> > +             goto error;
> > +
> > +     /* TODO this potentially allocates lot of memory (~6MB in my tests
> > +      * with attaching ~40k functions). I haven't seen this to fail yet,
> > +      * but it could be changed to allocate memory gradually if needed.
> > +      */
>
> Why would 6MB kvmalloc fail?
> If we don't have such memory the kernel will be ooming soon anyway.
> I don't think we'll see this kvmalloc triggering oom in practice.
> The verifier allocates a lot more memory to check large programs.
>
> imo this approach is fine. It's simple.
> Trying to do gradual alloc with realloc would be just guessing.
>
> Another option would be to ask user space (libbpf) to do the sort.
> There are pros and cons.
> This vmalloc+sort is slightly better imo.

Totally agree, the simpler the better. Also when you are attaching to
tens of thousands of probes, 6MB isn't a lot of memory for whatever
you are trying to do, anyways :)

Even if libbpf had to sort it, kernel would probably have to validate
that. Also for binary search you'd still need to read in the string
itself, but if you'd do this "on demand", we are adding TOCTOU and
other headaches.

Simple is good.

>
> > +     size = cnt * KSYM_NAME_LEN;
> > +     buf = kvmalloc(size, GFP_KERNEL);
> > +     if (!buf)
> > +             goto error;
> > +
> > +     for (p = buf, i = 0; i < cnt; i++) {
> > +             err = strncpy_from_user(p, usyms_copy[i], KSYM_NAME_LEN);
> > +             if (err == KSYM_NAME_LEN)
> > +                     err = -E2BIG;
> > +             if (err < 0)
> > +                     goto error;

[...]
