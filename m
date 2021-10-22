Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDADF437FF3
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhJVVby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhJVVbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:31:53 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04957C061764;
        Fri, 22 Oct 2021 14:29:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r2so4419728pgl.10;
        Fri, 22 Oct 2021 14:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ol5e64LpFv12Uil1+Y88UDesKUE1+NUsIExRzpZDEd8=;
        b=BpmWcikC+ew8/gMm6u1SAa+zQSytt+28rPkVD5UD9I2c7P06ebvMGKHBAHptJ1Lq8L
         UA1XQ4C+3ESsY0odxDK5aAETefQyvMnYkj1Lr3huk98RrYTPlQwZfXsinwPvZlzqD0wo
         gNdvqKs3E5yFjwIMvH/1dmamiM9QdmoP1I4A8q1UqieeLL5a5itT/wVC6kuHRrzzwOKK
         0o5rJs11ikZPvW7bOzw9JQUVnQUbPIQ2Ias6W43qmCQNYSYFtvjnYMY9tvFGipiUpd5l
         R+8k2jXj+KQdxj+pr11/XkTbBvnpR72l94pSyNVf1pA5sKoQPOVgS6TRv4k/HyYXbzJP
         Hd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ol5e64LpFv12Uil1+Y88UDesKUE1+NUsIExRzpZDEd8=;
        b=iZ3DOgeAs5cAseOe3LZJ7u3WUV8/tYstC+FEuf/bil1G0RrpPG9tbFqOLLiH6H4u/q
         7iXnXmXRjQWZasMJhxYxxxUT9Xtq8Hzf31tJQhaIQQnyfktu3VSnNC1ZTI8uiuYE2cGa
         pK6C/yRTiiiSPx/TdIcBOqiOt0GxfHA0/jov/3ZhVscI/gQMaUEVaQ1PjXaaRNd1lT1I
         GiGS7osyH5aLim3U6Ln53WuEM1vR2ebGaGxFmgC4yUnQWM1qHjs3JxGzIyZN5pAqtbWz
         nmycSsMRdwvfWrRl2Q3YmtJhYyenI2S+LywgtQebNQBai/CqNxI8zDdsXKvrNkW6t2w+
         u+CA==
X-Gm-Message-State: AOAM530Z558ZU/B4xvPc0L7iUOvwwCKy+fDZ0lK38ZXm8EiRJ+rJ6jJW
        zlhq4wG5x8HQriViHFZbKZj9fdfD/WmmT4ilU6Q=
X-Google-Smtp-Source: ABdhPJznYah8sfUkvYsGPHfJr5lIbvCn1KAeRiDeqtlzO1lODkHPr6qNMJkOgVQLUsmCjC4BeTb4yy2xOw4rhf5VFPY=
X-Received: by 2002:aa7:9f8f:0:b0:44c:cf63:ec7c with SMTP id
 z15-20020aa79f8f000000b0044ccf63ec7cmr2539742pfr.77.1634938175193; Fri, 22
 Oct 2021 14:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com> <35e9e89f-d92f-06f9-b919-ef956d99d7df@windriver.com>
In-Reply-To: <35e9e89f-d92f-06f9-b919-ef956d99d7df@windriver.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 22 Oct 2021 14:29:24 -0700
Message-ID: <CAADnVQJANZQJ5pAeH5KkC2rtY1TDFA_AomDfaPaBY_hw8qhgSA@mail.gmail.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
To:     Quanyang Wang <quanyang.wang@windriver.com>
Cc:     Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        mkoutny@suse.com,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 4:56 AM Quanyang Wang
<quanyang.wang@windriver.com> wrote:
> >> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> >> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
> >> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
> >> ---
> >> V1 ---> V2:
> >> 1. As per Daniel's suggestion, add description to commit msg about the
> >> balance of cgroup's refcount in cgroup_bpf_offline.
> >> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
> >> description about it.
> >> 3. Fix indentation on the percpu_ref_is_dying line.
> >
> > Acked-by: Roman Gushchin <guro@fb.com>
> >
> > The fix looks correct, two fixes tag are fine too, if only it won't
> > confuse scripts picking up patches for stable backports.
> >
> > In fact, it's a very cold path, which is arguably never hit in the real
> > life. On cgroup v2 it's not an issue. I'm not sure we need a stable
> > backport at all, only if it creates a noise for some automation tests.
> >
> > Quanyang, out of curiosity, how did you find it?
> I ran ltp testsuite to find this.
>
> ./runltp -f controllers -s cgroup
>
> Thanks,
> Quanyang
> >
> > Anyway, thanks for catching and fixing it!

Applied to bpf tree. Thanks everyone!
