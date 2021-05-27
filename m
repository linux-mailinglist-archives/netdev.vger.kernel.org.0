Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D5439341A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhE0QiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbhE0QiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:38:21 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511F6C061574;
        Thu, 27 May 2021 09:36:48 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f9so1523222ybo.6;
        Thu, 27 May 2021 09:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nsrt/UTjaoln5+HvtE7btQi+ehNE1T01zBd6uuErEFI=;
        b=R1v3QTZdxU9b+dUtRykAGN+UKmo8ptU44HBPkwQzqZhZLrhjC5iduiusBgZuKL/XBh
         rUx2atp9N4Bd49AB2I/ifRGbjiIvggYa2SvoZ3lYOoV5lHVB55KJjBKf4GhExu1UyvBh
         tJJ0XQehWHY5s9AFzmbWcWwSAUt+OXbjKS3qjoLBaLZxoysm8GSTN1NQFesL9Rq2dpiX
         Q7X4EleoiI0cvsYP/lTVYsraKOpx8jKTdmbXlJhSceBrvNlaQoQ7mBThId/eYSwwyEjt
         CbCWLAn2Fz5fIbd5W7KNkc7rN21d4jEnts5/bx8lKAy9sj5Rr2MxDY885hKEAoUIPSFB
         NgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nsrt/UTjaoln5+HvtE7btQi+ehNE1T01zBd6uuErEFI=;
        b=Y66h19BGmQAoSeJZ/8XFTcDXvKBRPVpZOK7QZJNSchNu5Y7KQQdi/0nhMEKqyeie3V
         4AbiIdd8VP+ahgp/zv1F0dBnOrPGnHyVa3qQDgXoY6iyjhSjqeqLQfSDeFLP8e4msMRC
         tRnIHZSxOsIBJ/2EdSW0EM+fMwUdRy1L14EW/BUPN7NejmhpGa3Ulal5A111OIUtVnts
         w/aUKJY1OOxLqCRCs8sTSCsIq9NdAdvkS3FC5NrAvllThCV0rXNmFcQAi9OOcR7CQY7F
         jChur69PaVVJqTXiBToTSBds02QfvEuT2SbiQQJ3VcImbi4CazVK5/ZMQqSmJT7ezu+r
         XLMw==
X-Gm-Message-State: AOAM532mvIT8D8VxI1vb0Z7IVh8HOrcQd2AFmJ/COpGltv4vOKN664VK
        mWsf00QwvDfxyrbrMWAPAE1k6KCnoUcm5WHxryYXq2ozaklkBg==
X-Google-Smtp-Source: ABdhPJxfr4CZtOLabl+iIX/7fflp4ualxRtJaQPqcCxq25fqVm9SIPOK41eFRCxO4AaKrm5M9e/K2Xri5oiDFaZczvQ=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr5917611ybr.425.1622133407477;
 Thu, 27 May 2021 09:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210527120251.GC30378@techsingularity.net> <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
 <20210527145441.GE30378@techsingularity.net>
In-Reply-To: <20210527145441.GE30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 09:36:35 -0700
Message-ID: <CAEf4BzbW2i4Y-i3TXW7x42PqEpw5_nNeReSXS77m4GC3uqD3wg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 7:54 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Thu, May 27, 2021 at 07:37:05AM -0700, Andrii Nakryiko wrote:
> > > This patch checks for older versions of pahole and only allows
> > > DEBUG_INFO_BTF_MODULES if pahole supports zero-sized per-cpu structures.
> > > DEBUG_INFO_BTF is still allowed as a KVM boot test passed with pahole
> >
> > Unfortunately this won't work. The problem is that vmlinux BTF is
> > corrupted, which results in module BTFs to be rejected as well, as
> > they depend on it.
> >
> > But vmlinux BTF corruption makes BPF subsystem completely unusable. So
> > even though kernel boots, nothing BPF-related works. So we'd need to
> > add dependency for DEBUG_INFO_BTF on pahole 1.22+.
> >
>
> While bpf usage would be broken, the kernel will boot and the effect
> should be transparent to any kernel build based on "make oldconfig".

I think if DEBUG_INFO_BTF=y has no chance of generating valid vmlinux
BTF it has to be forced out. So if we are doing this at all, we should
do it for CONFIG_DEBUG_INFO_BTF, not CONFIG_DEBUG_INFO_BTF_MODULES.
CONFIG_DEBUG_INFO_BTF_MODULES will follow automatically.

> CONFIG_DEBUG_INFO_BTF defaults N so if that is forced out, it will be
> easily missed by a distribution kernel maintainer.

We actually had previous discussions on forcing build failure in cases
when CONFIG_DEBUG_INFO_BTF=y can't be satisfied, but no one followed
up. I'll look into this and will try to change the behavior. It's
caused too much confusion previously and now with changes like this we
are going to waste even more people's time.

>
> Yes, users of BPF will be affected and it may generate bug reports but
> the fix will be to build with a working pahole. Breaking boot on the other
> hand is a lot more visible and hacking around this with a non-zero struct
> size has been shot down.
>
> --
> Mel Gorman
> SUSE Labs
