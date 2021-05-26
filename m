Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463EF391F52
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhEZSn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235564AbhEZSn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 14:43:26 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E8C061574;
        Wed, 26 May 2021 11:41:53 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id w1so3479939ybt.1;
        Wed, 26 May 2021 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=id6F4lgfjQNsJ+3S/VgOIlQEjaPpg+ReNaNL6KgFZYE=;
        b=G9uWbmyGB9td6lW4+3dQWDxA8jE3yVCUGPZVKZ3BNl/ItZ9wkOEFuPvKCUDOkfZybL
         pqcRcytG65avmCD6ISAc/snTplX8rQuy66SQntPnr2Q9xkSFIxZByus6UlojrPmt3HJ9
         BVPGJlUu09DHIhxgiUvztft51RHE1wV5oGdlPQ0PIVMEpOmZ8r6oAh/oS076fGKS916c
         1CynmiLCVu+TsfQbqSB2H0IlPRKNMXjYb1FMrxr0pFeajfHDGStgifmpcA7fxGx13q5J
         h2hwNvlI4stoN+RCC49jEZ1X79Ux0OcmI4RNAC5NagNZtGwQlpDC/WmTP98oz9YvGark
         IvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=id6F4lgfjQNsJ+3S/VgOIlQEjaPpg+ReNaNL6KgFZYE=;
        b=B230yREWRT8tz2VL6YeZoI9kEg2sMjG/yfFzVlF4LPysYtkBuygXEXG2TPenArs27V
         hv4j8GkE8Q3l9UxVUP9Si2vziaPcubBc1EDllP8oziKmX1gmchqKpDkMLF6XkIZKhlzI
         9p5kozA2atpWDYbQvNpLV8WgXGubiKRIPCEJjZYhon+qD3waFq3lSgJfRzQKJ9uxS+Bj
         uveIvUu0aU/nnkxCNv/q1FLLKkFjDbcEd74vnee4z1FT3kFV0/J0/f0DOBQwC3P0ORDR
         idEu2qMHetlAmKPWZtuIBDFRF1FkfyVWTo5Q7xoolLrs3adqIaFfVnB0x0wU2NHaVqcI
         Dm/Q==
X-Gm-Message-State: AOAM532Q/efuDyId/TYJ/0Kaip5LjBgnnXn+hNUSSvLM+6Yq3gynj5Sl
        V102HDytkHttmyiN4YBA6V7m6k/xK7Pz2I5LEZM=
X-Google-Smtp-Source: ABdhPJyY046+/p0uD+0FKN1t+G408mKyXLq4Kt2YkFXGHopZCRpbiqn4uVwu41LCkFbVhvWXJNTMcwoeFdR2Ozjag4g=
X-Received: by 2002:a25:1455:: with SMTP id 82mr51691332ybu.403.1622054512897;
 Wed, 26 May 2021 11:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net> <CAEf4BzZOQnBgYXSR71HgsqhYcaFk5M5mre+6do+hnuxgWx5aNg@mail.gmail.com>
 <20210526181306.GZ30378@techsingularity.net>
In-Reply-To: <20210526181306.GZ30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 May 2021 11:41:41 -0700
Message-ID: <CAEf4BzbbQfwUERObV4EQ4fTx3auKZm_CyoidWK7hWAK32wFZ3A@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:13 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> On Wed, May 26, 2021 at 09:57:31AM -0700, Andrii Nakryiko wrote:
> > > This patch checks for older versions of pahole and forces struct pagesets
> > > to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set. A
> > > warning is omitted so that distributions can update pahole when 1.22
> >
> > s/omitted/emitted/ ?
> >
>
> Yes.
>
> > > is released.
> > >
> > > Reported-by: Michal Suchanek <msuchanek@suse.de>
> > > Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> > > Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > > ---
> >
> > Looks good! I verified that this does fix the issue on the latest
> > linux-next tree, thanks!
> >
>
> Excellent
>
> > One question, should
> >
> > Fixes: 5716a627517d ("mm/page_alloc: convert per-cpu list protection
> > to local_lock")
> >
> > be added to facilitate backporting?
> >
>
> The git commit is not stable because the patch "mm/page_alloc: convert
> per-cpu list protection to local_lock" is in Andrew's mmotm tree which is

Oh, I didn't know about this instability.

> quilt based. I decided not to treat the patch as a fix because the patch is
> not wrong as such, it's a limitation of an external tool.  However, I would
> expect both the problematic patch and the BTF workaround to go in during
> the same merge window so backports to -stable should not be required.

Yep, makes sense.

>
> > Either way:
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > Tested-by: Andrii Nakryiko <andrii@kernel.org>
> >
>
> Thanks!
>
> --
> Mel Gorman
> SUSE Labs
