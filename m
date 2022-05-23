Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F881531E58
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiEWWHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiEWWHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:07:22 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB77B38BF2;
        Mon, 23 May 2022 15:07:20 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id b7so16483939vsq.1;
        Mon, 23 May 2022 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSlHjnTpNeJkBXf9g/KNtqsnSqM2X0+xdvEyIgTr6JQ=;
        b=EWwnTLM16H2GID9+UMX+0nE+pP3lqI2zGGAdpDUwji1ya5dw7SMD1eY9VBTTyzZ97p
         pnByUqrOiDK2UWSurC7DobSo4CmD+ZAvHtc04GRJIsGw0fSO+eLor7K60PCvjH5JEVyS
         e/eH4dT5yygEZpGlkm6i0xZPBRNG+Bw7w0NVBq8AcoYzA9Xhu2CCIxlyaXrckX+jhUE2
         zy0bMaodYI5pg8r4ys5ei2CpT7VSiYqgQjcmbmH/Tje8evG8fCsaD2DZ1WPXq+5aGyjR
         8BpBP/zt3jvcyEp80mLe/oV8xS1aBQ8q6qqiPSdBWfwlFIc7IpG714GItGipaHKVGzvo
         4cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSlHjnTpNeJkBXf9g/KNtqsnSqM2X0+xdvEyIgTr6JQ=;
        b=YFFE/PyYILo4LQ9lw4dENDg8wPPNEAe+rXSPb6ldXkj9EutMboYNoDxm1oCaV+tYLU
         UdYa0oqe8djUlXv0B/8Pq9FG4EV32y5Jx5c5jM8DFNvff6YqoAmP2HdpnjhzXFlgBUbY
         5kvq6xPoJ20EY/igavjubXYHZRF0ucDwkj9IpOk08sOQmAradClDUA1h5yOysDX/kldB
         /28hjqMJhn8Nt1PF20iAQ68wtIFL6SImQg5h3r9C9O8uVBI+ganf1gI1MJTBpYdpvGFB
         Dj7ETNfbc+LUJmXnLdhDoL0xVDnJGhQJLLM4UKNYVMZvDiZ5um+PO+LgPhfQgQ6TOZCt
         if0w==
X-Gm-Message-State: AOAM533flFvpBr8awJ0XlfVmmdtY9uN0WfE8JihmYsUgOlbKX81MVjTq
        3K40+9EOJSa9RrpUpWWv94ADRnYyKBGtOa8qk5k=
X-Google-Smtp-Source: ABdhPJz1O2EWuAnkK+LM9P6gjKOn5UxPsEEewag3V5kdOD0oCJLqAcLdS5U+rPZbYmR16eX6VvASq4sH/ezCoCC8KQo=
X-Received: by 2002:a05:6102:370a:b0:333:c0e7:77e8 with SMTP id
 s10-20020a056102370a00b00333c0e777e8mr9914433vst.54.1653343639818; Mon, 23
 May 2022 15:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220523102955.43844-1-douglas.raillard@arm.com> <4268b7c5-458e-32cc-36c4-79058be0480e@iogearbox.net>
In-Reply-To: <4268b7c5-458e-32cc-36c4-79058be0480e@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:07:08 -0700
Message-ID: <CAEf4BzZH-vV8iVqcDr_izTm+VqnqQ4QCzCgPA0pVX3iuVm9iHg@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix determine_ptr_size() guessing
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Douglas RAILLARD <douglas.raillard@arm.com>,
        bpf <bpf@vger.kernel.org>, beata.michalska@arm.com,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
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

On Mon, May 23, 2022 at 2:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/23/22 12:29 PM, Douglas RAILLARD wrote:
> > From: Douglas Raillard <douglas.raillard@arm.com>
> >
> > One strategy employed by libbpf to guess the pointer size is by finding
> > the size of "unsigned long" type. This is achieved by looking for a type
> > of with the expected name and checking its size.
> >
> > Unfortunately, the C syntax is friendlier to humans than to computers
> > as there is some variety in how such a type can be named. Specifically,
> > gcc and clang do not use the same name in debug info.
>
> Could you elaborate for the commit msg what both emit differently?
>
> > Lookup all the names for such a type so that libbpf can hope to find the
> > information it wants.
> >
> > Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
> > ---
> >   tools/lib/bpf/btf.c | 15 +++++++++++++--
> >   1 file changed, 13 insertions(+), 2 deletions(-)
> >
> >   CHANGELOG
> >       v2:
> >               * Added missing case for "long"
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 1383e26c5d1f..ab92b3bc2724 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -489,8 +489,19 @@ static int determine_ptr_size(const struct btf *btf)
> >               if (!name)
> >                       continue;
> >
> > -             if (strcmp(name, "long int") == 0 ||
> > -                 strcmp(name, "long unsigned int") == 0) {
> > +             if (
> > +                     strcmp(name, "long") == 0 ||
> > +                     strcmp(name, "long int") == 0 ||
> > +                     strcmp(name, "int long") == 0 ||
> > +                     strcmp(name, "unsigned long") == 0 ||
> > +                     strcmp(name, "long unsigned") == 0 ||
> > +                     strcmp(name, "unsigned long int") == 0 ||
> > +                     strcmp(name, "unsigned int long") == 0 ||
> > +                     strcmp(name, "long unsigned int") == 0 ||
> > +                     strcmp(name, "long int unsigned") == 0 ||
> > +                     strcmp(name, "int unsigned long") == 0 ||
> > +                     strcmp(name, "int long unsigned") == 0
> > +             ) {
>
> I was wondering whether strstr(3) or regexec(3) would be better, but then it's

regexec() seems like an overkill, but strstr() won't work because
we'll mistakingly find "long long". Splitting by space and sorting
also feels like going a bit too far. So I guess let's stick to this
exhaustive comparison approach.

But Douglas, can you please a table instead of writing out all those strcmp():

const char *long_aliases[] = {
    "long",
    "long int",
    ...
}

for (i = 0; i < ARRAY_SIZE(long_aliases); i++) { ... }

?

> probably not worth it and having the different combinations spelled out is
> probably still better. Pls make sure though to stick to kernel coding convention
> (similar alignment around strcmp() as the lines you remove).
>
> >                       if (t->size != 4 && t->size != 8)
> >                               continue;
> >                       return t->size;
> >
>
> Thanks,
> Daniel
