Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7671CEB41
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgELDP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:15:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23CC061A0C;
        Mon, 11 May 2020 20:15:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n14so12235454qke.8;
        Mon, 11 May 2020 20:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OCjk5lRyNnGdzoT7H/2cpQ+ftIGab0ek4X9QCagt82A=;
        b=MiGIrO0OjLF30WDYQeiMxr2H4+e6I601oMrswaP/iAMJONiVaQWBQ6dSxIipPlL72o
         BAL3d5QmMjDTVa/bho2IsL/FEy9gL0g7OvS68ANLgW+94MZssagebSrhLIDsA14ajswz
         wC2q1asbZEmWP2VLGKONXNGSFYPuQLeaDlYMvgFPkiwaQK4ox837jcvtQJbLBWBmsiMa
         vfcFc4+M49nPQ+5GnzlbkLifQ1CoTyTmL7yzMp96vORrRNSFBNl7b+zQY6vA925PdRa8
         dX5tWkpWjdeYQK1mw7JqHp/oV+aKYSyfGGTmr0uAigxpIGVDkk18EEz4mlq6XbYMr3pl
         fQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OCjk5lRyNnGdzoT7H/2cpQ+ftIGab0ek4X9QCagt82A=;
        b=EqG0jJAdxufsAz3vqnv5NSORANPWsPYFcNdhR4eiWfzLhi4myxSnXRdzri9WqodVIF
         AIAOeDBfG1aaMYMd6lktuFo26oiB2lc5xgYD4kjIMPK0lK20I8ClftvVI6T1QE1zYl5W
         wrj/NWNa89F1/VdzmIPvalR9Iu+5FVb39KuvII3JnDkGoJXbS0IJLxzS8mg8mjQeE51Y
         09h4DJYur9rC7A+luMVZeNgVqCWRs66YKeT8hNnYG7vQy2FgUAOpl5Twyqoh/yB+XM2y
         b/2KP3fjWR5gfItNQuBZt3/Jet/5sVqgLFisZHRnEvIS9WyEKAhS+NVHEKlIlBiSrdMP
         n3lA==
X-Gm-Message-State: AGi0PubrXAlQQt2+3dmTA+A4ukjr/q7HLnHAyekXFiIGXbCZMt4Y1k4P
        JXeq+4Z6vDkojMe22RZhgyp8FKSncs6zetipI4k=
X-Google-Smtp-Source: APiQypJYdzzEcFFEKlqS/mxg7pT5lU0SC4lN7u+/MPQA1qSfE8vHPKnd95NrdTm5EbdVykEv14ysH7coZ99595VegFs=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr18877994qka.39.1589253326381;
 Mon, 11 May 2020 20:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053918.1542509-1-yhs@fb.com>
 <CAEf4BzaV6u1eTta4h4+mftQCQVOGPf0Q++B8tZxho+Uq3M1=mA@mail.gmail.com> <849a051d-5c42-a61c-91ef-15a2bdb2b509@fb.com>
In-Reply-To: <849a051d-5c42-a61c-91ef-15a2bdb2b509@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 May 2020 20:15:15 -0700
Message-ID: <CAEf4BzYzwnQuvjR-deQ1OaPMaNSQcnFQOCEaAWvTrdgqOQarJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/21] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 6:36 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/8/20 11:24 AM, Andrii Nakryiko wrote:
> > On Wed, May 6, 2020 at 10:41 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Given a bpf program, the step to create an anonymous bpf iterator is:
> >>    - create a bpf_iter_link, which combines bpf program and the target.
> >>      In the future, there could be more information recorded in the link.
> >>      A link_fd will be returned to the user space.
> >>    - create an anonymous bpf iterator with the given link_fd.
> >>
> >> The bpf_iter_link can be pinned to bpffs mount file system to
> >> create a file based bpf iterator as well.
> >>
> >> The benefit to use of bpf_iter_link:
> >>    - using bpf link simplifies design and implementation as bpf link
> >>      is used for other tracing bpf programs.
> >>    - for file based bpf iterator, bpf_iter_link provides a standard
> >>      way to replace underlying bpf programs.
> >>    - for both anonymous and free based iterators, bpf link query
> >>      capability can be leveraged.
> >>
> >> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
> >> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
> >> querying. Currently, only prog_id is needed, so there is no
> >> additional in-kernel show_fdinfo() and fill_link_info() hook
> >> is needed for BPF_LINK_TYPE_ITER link.
> >>
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >
> > still looks good, but I realized show_fdinfo and fill_link_info is
> > missing, see request for a follow-up below :)
> >
> >
> >>   include/linux/bpf.h            |  1 +
> >>   include/linux/bpf_types.h      |  1 +
> >>   include/uapi/linux/bpf.h       |  1 +
> >>   kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
> >>   kernel/bpf/syscall.c           | 14 ++++++++
> >>   tools/include/uapi/linux/bpf.h |  1 +
> >>   6 files changed, 80 insertions(+)
> >>
> >
> > [...]
> >
> >> +static const struct bpf_link_ops bpf_iter_link_lops = {
> >> +       .release = bpf_iter_link_release,
> >> +       .dealloc = bpf_iter_link_dealloc,
> >> +};
> >
> > Link infra supports .show_fdinfo and .fill_link_info methods, there is
> > no need to block on this, but it would be great to implement them from
> > BPF_LINK_TYPE_ITER as well in the same release as a follow-up. Thanks!
>
> The reason I did not implement is due to we do not have additional
> information beyond prog_id to present. The prog_id itself gives all
> information about this link. I looked at tracing program

Not all, e.g., bpf_iter target is invisible right now. It's good to
have this added in a follow up, but certainly not a blocker.


> show_fdinfo/fill_link_info, the additional attach_type is printed.
> But attach_type is obvious for BPF_LINK_TYPE_ITER which does not
> need print.
>
> In the future when we add more stuff to parameterize the bpf_iter,
> will need to implement these two callbacks as well as bpftool.

yep

>
> >
> >
> > [...]
> >
