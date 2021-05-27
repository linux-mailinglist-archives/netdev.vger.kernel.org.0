Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58403938B0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhE0W06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhE0W05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 18:26:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9B7C061574;
        Thu, 27 May 2021 15:25:22 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id w1so2887224ybt.1;
        Thu, 27 May 2021 15:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7uOtvAQxo11BZ9qV4iscB9IwPVfNGrEjy6zxUfl9fAQ=;
        b=M7JkcsTVF7/siykqcbEhtevruKBCIx0gc9z1xs99OMOplvieDhCOZuwzx0RpQZTYIq
         UdXGrfOLSslfU37BlHTfJeyq8vgNte94vccbZMEenubMID/jVp3kpFORE+K0rG7pqLXM
         j15VIecE4NbOv5xDy39wDbM9a5uoqMa0KMwx2ZOA1n5C5KWBp62jWBGnuj5u3HxnHVvm
         ROrskkYmFIU+kZ4W1a5fSzSitr4+5XDhq/mJAS8WZUsUIAil9OBjAiAbBnKAZX9+8Hlc
         PrvJAjfCJQ8gG5LHi5V84ME3YToHskuuGR+6JI2aDxQuiFT3qjO40XsCfQUDBhZFUJru
         wqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7uOtvAQxo11BZ9qV4iscB9IwPVfNGrEjy6zxUfl9fAQ=;
        b=sjahlqWxEiQuoMNE+1N84vYQHSIsVy4ofpUbjXSrag13Yw6Gazb6nZhytPPovl20iF
         YPZ1tahNdNmxpYwc9iUQOO/nFgup5ZdmavHhcZ8QRcUPNlXRQz8rKu1zFC133MoY4WnY
         IO86fSLegA9fuHxVFgGxkW2fIueRI7Q9r7PKtM4jfg8CG5kof8lUW21rb1575RyWfhEZ
         X6AEYKS/vSYDrf86s/o357h3vNaCmj1NdQ4XyMmV2c6er4KTJ5IiLyRq0+4DWcl1wo1z
         XkW6oLbVB54/fxpT2xxmLGkIYcjX8h3GHqQbfhmOfzGM3WOTjZyVvbvLZC94/qnIPQZn
         QisA==
X-Gm-Message-State: AOAM5320ZhuK7hljPEUJM7AgNGcB1qH6PTUxGjX+T6iA+DpQCa91U/ss
        M+eogZTNaLRA3xVj44jJBL+lXvIq8u+WPgEBSyw=
X-Google-Smtp-Source: ABdhPJwep05E6OXImfZO1Z6zxyIrNIa/XIFP2ZNM+bMfL7sTFz8oYlsBRkxELywH69UbX1Cwi9Y0EKKE4bunYVTo2lA=
X-Received: by 2002:a25:3357:: with SMTP id z84mr7803181ybz.260.1622154322177;
 Thu, 27 May 2021 15:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210527120251.GC30378@techsingularity.net> <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
 <20210527145441.GE30378@techsingularity.net> <CAEf4BzbW2i4Y-i3TXW7x42PqEpw5_nNeReSXS77m4GC3uqD3wg@mail.gmail.com>
 <20210527172700.GH30378@techsingularity.net>
In-Reply-To: <20210527172700.GH30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 15:25:10 -0700
Message-ID: <CAEf4BzaP3ieYPX9vWETvp5bL8XRZ1XHr5C0dhLWed7DFanpa0g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>,
        Masahiro Yamada <masahiroy@kernel.org>
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

On Thu, May 27, 2021 at 10:27 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Thu, May 27, 2021 at 09:36:35AM -0700, Andrii Nakryiko wrote:
> > On Thu, May 27, 2021 at 7:54 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> > >
> > > On Thu, May 27, 2021 at 07:37:05AM -0700, Andrii Nakryiko wrote:
> > > > > This patch checks for older versions of pahole and only allows
> > > > > DEBUG_INFO_BTF_MODULES if pahole supports zero-sized per-cpu structures.
> > > > > DEBUG_INFO_BTF is still allowed as a KVM boot test passed with pahole
> > > >
> > > > Unfortunately this won't work. The problem is that vmlinux BTF is
> > > > corrupted, which results in module BTFs to be rejected as well, as
> > > > they depend on it.
> > > >
> > > > But vmlinux BTF corruption makes BPF subsystem completely unusable. So
> > > > even though kernel boots, nothing BPF-related works. So we'd need to
> > > > add dependency for DEBUG_INFO_BTF on pahole 1.22+.
> > > >
> > >
> > > While bpf usage would be broken, the kernel will boot and the effect
> > > should be transparent to any kernel build based on "make oldconfig".
> >
> > I think if DEBUG_INFO_BTF=y has no chance of generating valid vmlinux
> > BTF it has to be forced out. So if we are doing this at all, we should
> > do it for CONFIG_DEBUG_INFO_BTF, not CONFIG_DEBUG_INFO_BTF_MODULES.
> > CONFIG_DEBUG_INFO_BTF_MODULES will follow automatically.
> >
>
> Ok, I sent a version that prevents DEBUG_INFO_BTF being set unless
> pahole is at least 1.22.
>
> > > CONFIG_DEBUG_INFO_BTF defaults N so if that is forced out, it will be
> > > easily missed by a distribution kernel maintainer.
> >
> > We actually had previous discussions on forcing build failure in cases
> > when CONFIG_DEBUG_INFO_BTF=y can't be satisfied, but no one followed
> > up.
>
> It is weird how it is handled. DEBUG_INFO_BTF can be set and then fail to
> build vmlinux because pahole is too old. With DEBUG_INFO_BTF now requiring
> at least 1.22, the other version checks for 1.16 and 1.19 are redundant
> and could be cleaned up.
>
> > I'll look into this and will try to change the behavior. It's
> > caused too much confusion previously and now with changes like this we
> > are going to waste even more people's time.
> >
>
> Thanks.

So I've tried to change that, but I'm not sure that's possible with
the current Kconfig system. I tried to use $(error-if), but it happens
too early, at the text pre-processing stage, before the value of
CONFIG_DEBUG_INFO_BTF is known, so it's impossible to express
something like this:

$(error_if,CONFIG_DEBUG_INFO_BTF=y && PAHOLE_VERSION < 116,Pahole is tool old)

Masahiro, is it possible to somehow express the condition that if
CONFIG_DEBUG_INFO_BTF=y is selected, but some external dependency
(pahole version in this case) is too old, then fail the build
immediately? Currently we fail at the very end of vmlinux linking
step, which is very late.

Alternatively, it was proposed to just add an extra dependency (like,
"depends PAHOLE_IS_116_OR_NEWER"), but that will silently unselect
CONFIG_DEBUG_INFO_BTF if the condition is not satisfied, so it's even
more confusing to users.

Any suggestions on how to proceed with something like that? Thanks!

>
> --
> Mel Gorman
> SUSE Labs
