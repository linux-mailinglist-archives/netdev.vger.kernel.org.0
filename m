Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E656AF0D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 01:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbiGGXdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 19:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236791AbiGGXdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 19:33:38 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D05C1C932
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 16:33:35 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id g14so25094724qto.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 16:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3mGVzkNGFQOGZ/y27ZbQkMVyVRvFTFo9AVDkxPU3Qs=;
        b=jI3G3nw3SkAqpzPaUgQF22T9Ic6RqP7p4lMxcErcOD7LNwKHd9PhRD3jRjB5LpdRas
         Y5NSMurtCWidZFToFy1cwL/XBxIfNw8pRD1q5Tkl+DjQU82h4wug5DMjjkpFX5N/DorO
         SwsedXFgGBd+s1tGJbH90/3YrEFEevIGRkGo0KerFHlOynd+zFhmCXD6wOxegx+qKcI7
         whx6NUJOU7zlSU/AwEkpEWHVAccpRcvhOXltX62YPY1hchP+LZnGgdRpe/U837IrWH3D
         dz5dOl6K+w5srsimqMB2BRtRhqEml7mfZ8+BDapksn3GwHM8o2gHQoLWP2Z3Uu5lfvw3
         v75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C3mGVzkNGFQOGZ/y27ZbQkMVyVRvFTFo9AVDkxPU3Qs=;
        b=rztblNBfLQTcdiE5eFtEkgAmTElt8ofgxj2KzD6lyBnfYXwR8sOYf/PRibSyfUM+om
         CjD/lOLobE/QrAanF/MD/7mZ5BD3zb+AOTNNkpSuLxRqAPzfWKiPujNkemo61Wz8nTZQ
         j0qjM3T7kp64HYaFESziPbOgHqafPhi+xNG8RuS7sy2zRbcWu59XoIWIaPA2xS5bwPSY
         W5loaenWxeeweG6R+4KbBzstuHXcjJAVpgA+Ba8zRL1B8WWSwe35fXEQYv6Hd11Wf7Nv
         IdLtDWSDRbl4Rh9h5zZfoDO7vRT4VQtUTMgi6KfD1u6AE4fCyxFikU6L6JR8lwyUTdbY
         Ts8w==
X-Gm-Message-State: AJIora/7Te44VvfbnkIsAgooZDg70JB1Kc7LlZefEc8EzYOtF/2rQPIx
        WHCHHKvwvCReYEZhuOdU2nVbxcp4R3icDJD3I1d5Xw==
X-Google-Smtp-Source: AGRyM1vEAd1x2UNB33pdXaPWBs45WXrfdgTefCVvtafX/mSzrQX5KL9nA7apiMh9koyl9ZSeRjRPZ2w8IZQ0Rvdb+DA=
X-Received: by 2002:a0c:b30e:0:b0:470:a567:edf6 with SMTP id
 s14-20020a0cb30e000000b00470a567edf6mr326564qve.44.1657236814309; Thu, 07 Jul
 2022 16:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com> <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
In-Reply-To: <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 7 Jul 2022 16:33:23 -0700
Message-ID: <CA+khW7h05O1zg90tkK_7G9u0dhi8jN8WFZ_V_58obSLR4n1iBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 9:09 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> >
> >   - walking a cgroup's descendants.
> >   - walking a cgroup's ancestors.
>
> The implementation has another choice, BPF_ITER_CGROUP_PARENT_UP.
> We should add it here as well.
>

Sorry about the late reply. I meant to write two modes: walking up and
walking down. And two sub-modes when walking down: pre-order and
post-order.

But it seems this is confusing. I'm going to use three modes in the
next version: UP, PRE and POST.

Besides, since this patch modifies the bpf_iter_link_info, and that
breaks the btf_dump selftest, I need to include the fix of the
selftest in this patch.

> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
>
> Overall looks good to me with a few nits below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
[...]
> > +
> > +/* cgroup_iter provides two modes of traversal to the cgroup hierarchy.
> > + *
> > + *  1. Walk the descendants of a cgroup.
> > + *  2. Walk the ancestors of a cgroup.
>
> three modes here?
>

Same here. Will use 'three modes' in the next version.

> > + *
[...]
> > +
> > +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> > +                               union bpf_iter_link_info *linfo,
> > +                               struct bpf_iter_aux_info *aux)
> > +{
> > +     int fd = linfo->cgroup.cgroup_fd;
> > +     struct cgroup *cgrp;
> > +
> > +     if (fd)
> > +             cgrp = cgroup_get_from_fd(fd);
> > +     else /* walk the entire hierarchy by default. */
> > +             cgrp = cgroup_get_from_path("/");
> > +
> > +     if (IS_ERR(cgrp))
> > +             return PTR_ERR(cgrp);
> > +
> > +     aux->cgroup.start = cgrp;
> > +     aux->cgroup.order = linfo->cgroup.traversal_order;
>
> The legality of traversal_order should be checked.
>

Sounds good. Will do.

> > +     return 0;
> > +}
> > +
[...]
> > +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> > +                                     struct seq_file *seq)
> > +{
> > +     char *buf;
> > +
> > +     buf = kzalloc(PATH_MAX, GFP_KERNEL);
> > +     if (!buf) {
> > +             seq_puts(seq, "cgroup_path:\n");
>
> This is a really unlikely case. maybe "cgroup_path:<unknown>"?
>

Sure, no problem. This is a path that is unlikely to hit.

> > +             goto show_order;
[...]
