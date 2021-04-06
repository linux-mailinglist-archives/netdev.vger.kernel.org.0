Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF4354AC7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbhDFCOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhDFCOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 22:14:35 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7717CC06174A;
        Mon,  5 Apr 2021 19:14:28 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id u6so1107715uap.1;
        Mon, 05 Apr 2021 19:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bo2lGDxVCGe9lNbS3u8q99z58ww2lLJ0dkDpvy52v0w=;
        b=JvKwIZpYl1ZrZ/CWCEVT1AOF2mrWXUr06VkbH2ArfDp0TW+a/pVvBQTk+am3kLYI34
         SPRDumS7uOBLEKVJEGdV3zWGCaLtrTumMoUbGatgWL/ru+5C8HLvJgZ9MQTxbnctON3J
         ac6RdV3G76MTa4dm/MRHfhKz9jfEpVBcADojFeayjUBG0evBff+WgPkpZNcS+Kb3OIEU
         PCMSb23pCKazUjexsjLATjAZsVnhLUV8jw8TUkgZUcJ/Rt94lpXNNKV4M+HQIoXUWn1t
         plrYjfYIdZPsOv21ZBP7j5vHTj1cMUfRmiThn4zRZmosjLS8IlWtkpRYGOhX0DQNkvZV
         W//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bo2lGDxVCGe9lNbS3u8q99z58ww2lLJ0dkDpvy52v0w=;
        b=XVKB/vCCbruZ7R60U5I/hNmwnDUTYMmhHqkcK8hFl0lsKL8WjuAzLzX/QOct9MXs9A
         mFJPkNaAuTyJ/9mPl+ybbHRRQJWqbrmp5ywY42iAZk2biU9LQk9MXuQGdCRYx2P2MDfS
         cX08REYFkPpEfg++kgByF95ffJZeAbSviD2SmceVJlAnCFsUsHOSoCcuUKqdZ131VCvB
         WRrOnPdKIqNPUkBpHCuNEjf0aDesEQcEmFB7qrA8Hf5quyqLwgETD4oEX6YSlPGgVTZK
         BT+qZR3JKG4a4hB2GEhsIbmlUUYYu7uwSIuC8NiwDEuzg4EPezDXBV1EiMu+yJwcaZhv
         bjyw==
X-Gm-Message-State: AOAM532h61Huwkf+1FX+X4AI8pH5seIqAVb0VlrvTBQPVrrzxRvwTs34
        QhTWhrCbRdq4MYMHxynBdPxZ/AZy76u1E058hVQ=
X-Google-Smtp-Source: ABdhPJxAzsq+e2cvHUhJ7oB4lJEPFAWLVTTzHqKcybnYLe57CJXw0rLxoH0FORpXXLfQ3ojfSSqy9fGG+NPw0t9e1xA=
X-Received: by 2002:a9f:3fcf:: with SMTP id m15mr14688262uaj.55.1617675267029;
 Mon, 05 Apr 2021 19:14:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210329123635.56915-1-qianjun.kernel@gmail.com> <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
In-Reply-To: <20210330224406.5e195f3b8b971ff2a56c657d@linux-foundation.org>
From:   jun qian <qianjun.kernel@gmail.com>
Date:   Tue, 6 Apr 2021 10:14:16 +0800
Message-ID: <CAKc596KE+mN1xOXppTOtJY7UDDLSb+zg2kwj=x8AzMN_Px2DuQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] mm:improve the performance during fork
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        Linux-MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> =E4=BA=8E2021=E5=B9=B43=E6=9C=883=
1=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=881:44=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Mon, 29 Mar 2021 20:36:35 +0800 qianjun.kernel@gmail.com wrote:
>
> > From: jun qian <qianjun.kernel@gmail.com>
> >
> > In our project, Many business delays come from fork, so
> > we started looking for the reason why fork is time-consuming.
> > I used the ftrace with function_graph to trace the fork, found
> > that the vm_normal_page will be called tens of thousands and
> > the execution time of this vm_normal_page function is only a
> > few nanoseconds. And the vm_normal_page is not a inline function.
> > So I think if the function is inline style, it maybe reduce the
> > call time overhead.
> >
> > I did the following experiment:
> >
> > use the bpftrace tool to trace the fork time :
> >
> > bpftrace -e 'kprobe:_do_fork/comm=3D=3D"redis-server"/ {@st=3Dnsecs;} \
> > kretprobe:_do_fork /comm=3D=3D"redis-server"/{printf("the fork time \
> > is %d us\n", (nsecs-@st)/1000)}'
> >
> > no inline vm_normal_page:
> > result:
> > the fork time is 40743 us
> > the fork time is 41746 us
> > the fork time is 41336 us
> > the fork time is 42417 us
> > the fork time is 40612 us
> > the fork time is 40930 us
> > the fork time is 41910 us
> >
> > inline vm_normal_page:
> > result:
> > the fork time is 39276 us
> > the fork time is 38974 us
> > the fork time is 39436 us
> > the fork time is 38815 us
> > the fork time is 39878 us
> > the fork time is 39176 us
> >
> > In the same test environment, we can get 3% to 4% of
> > performance improvement.
> >
> > note:the test data is from the 4.18.0-193.6.3.el8_2.v1.1.x86_64,
> > because my product use this version kernel to test the redis
> > server, If you need to compare the latest version of the kernel
> > test data, you can refer to the version 1 Patch.
> >
> > We need to compare the changes in the size of vmlinux:
> >                   inline           non-inline       diff
> > vmlinux size      9709248 bytes    9709824 bytes    -576 bytes
> >
>
> I get very different results with gcc-7.2.0:
>
> q:/usr/src/25> size mm/memory.o
>    text    data     bss     dec     hex filename
>   74898    3375      64   78337   13201 mm/memory.o-before
>   75119    3363      64   78546   132d2 mm/memory.o-after
>
> That's a somewhat significant increase in code size, and larger code
> size has a worsened cache footprint.
>
> Not that this is necessarily a bad thing for a function which is
> tightly called many times in succession as is vm__normal_page()
>
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -592,7 +592,7 @@ static void print_bad_pte(struct vm_area_struct *vm=
a, unsigned long addr,
> >   * PFNMAP mappings in order to support COWable mappings.
> >   *
> >   */
> > -struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long =
addr,
> > +inline struct page *vm_normal_page(struct vm_area_struct *vma, unsigne=
d long addr,
> >                           pte_t pte)
> >  {
> >       unsigned long pfn =3D pte_pfn(pte);
>
> I'm a bit surprised this made any difference - rumour has it that
> modern gcc just ignores `inline' and makes up its own mind.  Which is
> why we added __always_inline.
>
the kernel code version: kernel-4.18.0-193.6.3.el8_2
gcc version 8.4.1 20200928 (Red Hat 8.4.1-1) (GCC)

and I made it again, got the results, and later i will test in the
latest version kernel with the new gcc.

757368576  vmlinux   inline
757381440  vmlinux   no inline
