Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7406855C0
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389082AbfHGWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 18:25:52 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43722 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387536AbfHGWZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 18:25:52 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so9466495qto.10;
        Wed, 07 Aug 2019 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZReaImTgpx+g4tKexVN6Z5xzwt1fsbk5bazHurmrjE=;
        b=EuQeDNVacNZDdOwyVaNnHoGiUTmYXApm+RVqF1h+a3y1NxfGtKuLAE+KZ2n7W8JFhX
         +oUVZYmaZrNHqaLpr9hfdByqqEaB7XG2b5MqnRLLQzFUSGsLwqAo3w08inTLqrhYO4Ir
         Z3/qRG0rYXcixUtIMWneynkhirVo1icqY8rREKhSV1LOfvHj2BdMNdk427MdfZ/T8c8C
         sNy4N6XXctp++LcEBv9j2sgtI/Orn83LwRP5yXh1hRQ13U1JEFuyQN5EgqbNxCJhzDVC
         3ND2Rf0DhDjyx3VJHIvAqNravrUXJQiXksuL2YwR2UX8Kl7gOnkR1wRcg1lPvpiKpk1c
         WfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZReaImTgpx+g4tKexVN6Z5xzwt1fsbk5bazHurmrjE=;
        b=uXVTSPr4jFbb6/ivp0FEsFolpllm0tyKLTQWQaIOD2hQSrlpa9DTfCaWTVQaXr2VTB
         FhPJAEsqq1zBa2ViCoNBWOQJkpqEVCP8IvfJjjjvxlCBLNLBHK/9z9zmXqDW55bneFYE
         Nh+h7GpqTj4JlbeCf342PkyajgmqX7QjMCGTbkJKPt+S4KP+ybODwAigZorwXLn0gXto
         X03fQubwYtKNrJqLRWZzhWyCyL0vdjQKzxiHo0xXA6Rsi379ZN0LbqpYYX3bOqrVjKSq
         SJXQgDb1zywwZ3n8iVEZAhmeCo80SnocbPWGO8DbbYa2w5y0XspwngPVCBLEktDG61f2
         RVsQ==
X-Gm-Message-State: APjAAAU/7n1POPb80e7/I/DpRBBE6bJtNrADWVpmSh25LcPhRaMrA7+4
        rLwS7yqTe7vGeSwvenWt28lCoYtF/9LfLvr8tE+EfAE6EwgLTA7a
X-Google-Smtp-Source: APXvYqx71kmx3NQ0ZwtFuJVtLYOIAxgbfZkpvc8CHhEbT8SYVnE8H7bTIoOLXA8+dGSZwMzMeipqqZgLuqhx1EfDiLw=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr8401145qvv.38.1565216751560;
 Wed, 07 Aug 2019 15:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190807214001.872988-1-andriin@fb.com> <20190807214001.872988-5-andriin@fb.com>
 <20190807221649.fiqo2kqj73qjcakr@ast-mbp>
In-Reply-To: <20190807221649.fiqo2kqj73qjcakr@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Aug 2019 15:25:40 -0700
Message-ID: <CAEf4BzZuqPLJ=ModfYqKpU6bDMqZpt_NfDZyPTCOp=Ws0MnAhA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 04/14] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 3:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 07, 2019 at 02:39:51PM -0700, Andrii Nakryiko wrote:
> > This patch implements the core logic for BPF CO-RE offsets relocations.
> > Every instruction that needs to be relocated has corresponding
> > bpf_offset_reloc as part of BTF.ext. Relocations are performed by trying
> > to match recorded "local" relocation spec against potentially many
> > compatible "target" types, creating corresponding spec. Details of the
> > algorithm are noted in corresponding comments in the code.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> ...
> > +static struct btf *bpf_core_find_kernel_btf(void)
> > +{
> > +     const char *locations[] = {
> > +             "/lib/modules/%1$s/vmlinux-%1$s",
> > +             "/usr/lib/modules/%1$s/kernel/vmlinux",
> > +     };
>
> the vmlinux finding logic didn't work out of the box for me.
> My vmlinux didn't have -`uname -r` suffix.
> Probably worth adding /boot/vmlinux-uname too.

Yeah, there doesn't appear to be a consensus about standard location.
For completeness, I'll add a set of paths perf is using in follow-up
patch. But overall this mess with searching for vmlinux is one of
motivational factors for https://patchwork.ozlabs.org/patch/1143622/,
which should fix this problem.

> May be vmlinuz can have BTF as well?

Probably, but it might be too expensive to extract it? Either way,
once .BTF is loadable inside kernel, there won't be a need to search
for vmlinux/vmlinux location.

>
> Overall looks great. Applied to bpf-next. Thanks!
>

Thanks!
