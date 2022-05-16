Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B5D529576
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346697AbiEPXqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiEPXqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:46:09 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4A621E32;
        Mon, 16 May 2022 16:46:07 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e194so17668271iof.11;
        Mon, 16 May 2022 16:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NGmqOSoM/D/mlnC6zemgOPjMPqkvgQ6nvvptywkIkBQ=;
        b=LUNfwdi8TjvvTwcSOEgYdD/CjULEhvBRWPbzoOorGdAgxNpqegtZbi3YapReYWF1uC
         zhByIgHMeTEcEuzaBYbRLj1YEj9hJV06WVRvF29S9CLENehMxIwwM+ZIQAmGpBbIhz65
         iyEqytk5wROHHWSkk1DYeo4IwVgupQEU/FWPfsGNnNr/xoHNbCyIaogVnULZqhhDZh0B
         vTwkZv9tfLhaeM8pi+Ylj5NVHUvmi+XG9COEpF6gB7jIjv5G9cbWb+KNbdBy9D1KGK6N
         kmflUrHLR3SFhZNU5NIy8E064V93c5PE1d/L2ZaU2RBpnk2SC+9ALUYa8E0KIJwP7rO3
         VOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NGmqOSoM/D/mlnC6zemgOPjMPqkvgQ6nvvptywkIkBQ=;
        b=WIsyIrxDHhAPcP+KTGCUJ6VXRi8/dKNmbKPKXdIuw0UZWvPmLuvcu5dTpwGScNVDnm
         /Jo9GL+GKrTNQZdCn8gomPrWBPYj1pkVQ1t2+e1T1oNOBIAz0sZUB7zJ5mz0RdKx9Owf
         A8CJIprxyfN36W4VxmNaKGpDyfVbUllql83hCn+0jz1I8GjsxQHuPFvj7BeTjjBuuEXR
         PyMxnnc+DJ/DAoeXRXzRBEldz6/75tocjQsvT9Ft7Fq5h6yDmF1cVP4XR7tnXcDs7RJx
         DSUugmcaJddlJDnkuG1LmmVe9TwnoZ3Y6LLys+a2CRcU2Gc4rjW8FosOvGBa1/fw4u9O
         OfZg==
X-Gm-Message-State: AOAM532t6XIOG+BjsdYOIDrcMi3V+lT9B7qcYRU0gyLvZlAg8t6hEDsN
        RoaOFYe+n+rb9L1DiG1grhW11VQPKgU4RCx5QKE=
X-Google-Smtp-Source: ABdhPJx8vwSSxGyeZm7P5K9XJwN8Ufh6yWvDl4kzldAdJFHxSoLSzr2MrRLxy6rVWceYE43yCXVi+3OPsrtxvceSiX8=
X-Received: by 2002:a05:6638:468e:b0:32b:fe5f:d73f with SMTP id
 bq14-20020a056638468e00b0032bfe5fd73fmr10812141jab.234.1652744767089; Mon, 16
 May 2022 16:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
 <20220513190821.431762-1-tadeusz.struk@linaro.org> <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <2fcdbecf-5352-ea81-ee42-ee10fbe2f72e@linaro.org>
In-Reply-To: <2fcdbecf-5352-ea81-ee42-ee10fbe2f72e@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 May 2022 16:45:56 -0700
Message-ID: <CAEf4BzZSb7z=c+dqsO4rTBet7jUzqCXOG-mVxFxqX9y0y05cEw@mail.gmail.com>
Subject: Re: [PATCH v3] bpf: Fix KASAN use-after-free Read in compute_effective_progs
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
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

On Mon, May 16, 2022 at 4:35 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> On 5/16/22 16:16, Andrii Nakryiko wrote:
> > On Fri, May 13, 2022 at 12:08 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> >>   kernel/bpf/cgroup.c | 64 +++++++++++++++++++++++++++++++++++++++------
> >>   1 file changed, 56 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> >> index 128028efda64..9d3af4d6c055 100644
> >> --- a/kernel/bpf/cgroup.c
> >> +++ b/kernel/bpf/cgroup.c
> >> @@ -681,6 +681,57 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
> >>          return ERR_PTR(-ENOENT);
> >>   }
> >>
> >> +/**
> >> + * purge_effective_progs() - After compute_effective_progs fails to alloc new
> >> + *                           cgrp->bpf.inactive table we can recover by
> >> + *                           recomputing the array in place.
> >> + *
> >> + * @cgrp: The cgroup which descendants to traverse
> >> + * @link: A link to detach
> >> + * @atype: Type of detach operation
> >> + */
> >> +static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
> >> +                                 enum cgroup_bpf_attach_type atype)
> >> +{
> >> +       struct cgroup_subsys_state *css;
> >> +       struct bpf_prog_array_item *item;
> >> +       struct bpf_prog *tmp;
> >> +       struct bpf_prog_array *array;
> >> +       int index = 0, index_purge = -1;
> >> +
> >> +       if (!prog)
> >> +               return;
> >> +
> >> +       /* recompute effective prog array in place */
> >> +       css_for_each_descendant_pre(css, &cgrp->self) {
> >> +               struct cgroup *desc = container_of(css, struct cgroup, self);
> >> +
> >> +               array = desc->bpf.effective[atype];
> >
> > ../kernel/bpf/cgroup.c:748:23: warning: incorrect type in assignment
> > (different address spaces)
> > ../kernel/bpf/cgroup.c:748:23:    expected struct bpf_prog_array *array
> > ../kernel/bpf/cgroup.c:748:23:    got struct bpf_prog_array [noderef] __rcu *
> >
> >
> > you need rcu_dereference here? but also see suggestions below to avoid
> > iterating effective directly (it's ambiguous to search by prog only)
>
> I didn't check it with sparse so I didn't see this warning.
> Will fix in the next version.
>
> >
> >> +               item = &array->items[0];
> >> +
> >> +               /* Find the index of the prog to purge */
> >> +               while ((tmp = READ_ONCE(item->prog))) {
> >> +                       if (tmp == prog) {
> >
> > I think comparing just prog isn't always correct, as the same program
> > can be in effective array multiple times if attached through bpf_link.
> >
> > Looking at replace_effective_prog() I think we can do a very similar
> > (and tested) approach:
> >
> > 1. restore original pl state in __cgroup_bpf_detach (so we can find it
> > by comparing pl->prog == prog && pl->link == link)
> > 2. use replace_effective_prog's approach to find position of pl in
> > effective array (using this nested for loop over cgroup parents and
> > list_for_each_entry inside)
> > 3. then instead of replacing one prog with another do
> > bpf_prog_array_delete_safe_at ?
> >
> > I'd feel more comfortable using the same tested overall approach of
> > replace_effective_prog.
>
> Ok, I can try that.
>
> >
> >> +                               index_purge = index;
> >> +                               break;
> >> +                       }
> >> +                       item++;
> >> +                       index++;
> >> +               }
> >> +
> >> +               /* Check if we found what's needed for removing the prog */
> >> +               if (index_purge == -1 || index_purge == index - 1)
> >> +                       continue;
> >
> > the search shouldn't fail, should it?
>
> I wasn't if the prog will be present in all parents so I decided to add this
> check to make sure it is found.

Looking at replace_effective_prog (it's been a while since I touched
this code) it has to be present, otherwise it's a bug

>
> >
> >> +
> >> +               /* Remove the program from the array */
> >> +               WARN_ONCE(bpf_prog_array_delete_safe_at(array, index_purge),
> >> +                         "Failed to purge a prog from array at index %d", index_purge);
> >> +
> >> +               index = 0;
> >> +               index_purge = -1;
> >> +       }
> >> +}
> >> +
> >>   /**
> >>    * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
> >>    *                         propagate the change to descendants
> >> @@ -723,8 +774,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >>          pl->link = NULL;
> >>
> >>          err = update_effective_progs(cgrp, atype);
> >> -       if (err)
> >> -               goto cleanup;
> >> +       if (err) {
> >> +               struct bpf_prog *prog_purge = prog ? prog : link->link.prog;
> >> +
> >
> > so here we shouldn't forget link, instead pass both link and prog (one
> > of them will have to be NULL) into purge_effective_progs
>
> ok, I will pass in both.
>
> --
> Thanks,
> Tadeusz
