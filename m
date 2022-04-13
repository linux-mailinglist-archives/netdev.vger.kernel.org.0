Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C384FFEB4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbiDMTLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbiDMTLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:11:21 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5F270F5C;
        Wed, 13 Apr 2022 12:07:46 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d3so1719580ilr.10;
        Wed, 13 Apr 2022 12:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92E/ec4i5LnhAm6QfmhSLHw5yVycbFL5hByOUbqqyro=;
        b=TVLFgLZhWw6pmaRSfd8bAJqxiuLDzXp6AhxR4EW15cCA/zVlxldabR2rrvhODDiu2l
         0RPPQqsKdHHUbTdsmar4UDI8jHlZ7eg6YxnHXITnQG77WGlokY0yFuqkJgt+zZ9Zj64F
         M0DWigVjEfKffzYkdY4TbbnKCampfLI1o2yIuaB7fjy+7iAGzh0Opjk0M/8OB+X8pv9A
         o7pJggpyjTiVgwq2LEH4En4OeILnsOynPYcZd9xjmsJnBhpGzCY7v4ovJmo4Y1RaYhZP
         waIvYNCSmThhJH1kbPJP/riNvkxlbsTRQKHqOCwiVaQU0ut1CYWPSkLZxHiI4onbDpKM
         fWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92E/ec4i5LnhAm6QfmhSLHw5yVycbFL5hByOUbqqyro=;
        b=0bfhtTu9BnKa9giU0wwZKyHz8g4YSaruPXqpWl/vZDurRwTcInDfr2mKgPJTHrmU+M
         /n1VwRHyNN7OEmSFjv9ZD078FaVKOTOENVfKUBISBCieaKL+bgEDsm1mG16j/V2jT5+O
         5rJhEnFEyl3T8TzzOHdaQIZm5uHXJe4wRDrJxMNCPgz37wCvBBYpidVN+X5HI5PWrIoV
         edbKHxOarguTbjXY/v9d/FJLh3rODNyO0RcsGojEm3/Lc7DMS46twFgkeDV8pd6nvBev
         0PmeMcRpMDJnr24R2l8AW5qv6YXWMVJAUTLxfBNDSSUaK+VwBokKvaWqX6PRcEeszDtn
         SDxQ==
X-Gm-Message-State: AOAM532pUSJCfqrWh5qujgdzCCSPg2NU3DV1HIR7QcAD3srOaIfeeMPZ
        zipfxJvnZDdtLWGdDCATRY1SFk7tbGzfgCO77V4=
X-Google-Smtp-Source: ABdhPJy033MvMEQyvLE1qMebv5SInN1YiIGgNWcBjQVCXo+iGTnhZGlH3qzZa0OZCQXnN5XJH4eIskAi6CqWqjXQb1o=
X-Received: by 2002:a05:6e02:1562:b0:2ca:50f1:72f3 with SMTP id
 k2-20020a056e02156200b002ca50f172f3mr18617417ilu.71.1649876866131; Wed, 13
 Apr 2022 12:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
 <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com> <e7692d0b-e495-8d3e-4905-c4109bf5caa4@linaro.org>
In-Reply-To: <e7692d0b-e495-8d3e-4905-c4109bf5caa4@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 12:07:35 -0700
Message-ID: <CAEf4Bzbb+AmuABH2cw=48uuznz7bT=eEMc1V9mS3GSqgU664Tw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix KASAN use-after-free Read in compute_effective_progs
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
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

On Wed, Apr 13, 2022 at 10:28 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Hi Andrii,
> On 4/12/22 21:34, Andrii Nakryiko wrote:
> > On Tue, Apr 5, 2022 at 10:04 AM Tadeusz Struk<tadeusz.struk@linaro.org>  wrote:
> >> Syzbot found a Use After Free bug in compute_effective_progs().
> >> The reproducer creates a number of BPF links, and causes a fault
> >> injected alloc to fail, while calling bpf_link_detach on them.
> >> Link detach triggers the link to be freed by bpf_link_free(),
> >> which calls __cgroup_bpf_detach() and update_effective_progs().
> >> If the memory allocation in this function fails, the function restores
> >> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> >> gets freed just after it returns. After this, every subsequent call to
> >> update_effective_progs() causes this already deallocated pointer to be
> >> dereferenced in prog_list_length(), and triggers KASAN UAF error.
> >> To fix this don't preserve the pointer to the link on the cgroup list
> >> in __cgroup_bpf_detach(), but proceed with the cleanup and retry calling
> >> update_effective_progs() again afterwards.
> > I think it's still problematic. BPF link might have been the last one
> > that holds bpf_prog's refcnt, so when link is put, its prog can stay
> > there in effective_progs array(s) and will cause use-after-free
> > anyways.
> >
> > It would be best to make sure that detach never fails. On detach
> > effective prog array can only shrink, so even if
> > update_effective_progs() fails to allocate memory, we should be able
> > to iterate and just replace that prog with NULL, as a fallback
> > strategy.
>
> it would be ideal if detach would never fail, but it would require some kind of
> prealloc, on attach maybe? Another option would be to minimize the probability

We allocate new arrays in update_effective_progs() under assumption
that we might need to grow the array because we use
update_effective_progs() for attachment. But for detachment we know
that we definitely don't need to increase the size, we need to remove
existing element only, thus shrinking the size.

Normally we'd reallocate the array to shrink it (and that's why we use
update_effective_progs() and allocate memory), but we can also have a
fallback path for detachment only to reuse existing effective arrays
and just shift all the elements to the right from the element that's
being removed. We'll leave NULL at the end, but that's much better
than error out. Subsequent attachment or detachment will attempt to
properly size and reallocate everything.

So I think that should be the fix, if you'd be willing to work on it.


> of failing by sending it gfp_t flags (GFP_NOIO | GFP_NOFS | __GFP_NOFAIL)?
> Detach can really only fail if the kzalloc in compute_effective_progs() fails
> so maybe doing something like bellow would help:
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..5a47740c317b 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -226,7 +226,8 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
>    */
>   static int compute_effective_progs(struct cgroup *cgrp,
>                                    enum cgroup_bpf_attach_type atype,
> -                                  struct bpf_prog_array **array)
> +                                  struct bpf_prog_array **array,
> +                                  gfp_t flags)
>   {
>         struct bpf_prog_array_item *item;
>         struct bpf_prog_array *progs;
> @@ -241,7 +242,7 @@ static int compute_effective_progs(struct cgroup *cgrp,
>                 p = cgroup_parent(p);
>         } while (p);
>
> -       progs = bpf_prog_array_alloc(cnt, GFP_KERNEL);
> +       progs = bpf_prog_array_alloc(cnt, flags);
>         if (!progs)
>                 return -ENOMEM;
>
> @@ -308,7 +309,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
>         INIT_LIST_HEAD(&cgrp->bpf.storages);
>
>         for (i = 0; i < NR; i++)
> -               if (compute_effective_progs(cgrp, i, &arrays[i]))
> +               if (compute_effective_progs(cgrp, i, &arrays[i], GFP_KERNEL))
>                         goto cleanup;
>
>         for (i = 0; i < NR; i++)
> @@ -328,7 +329,8 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
>   }
>
>   static int update_effective_progs(struct cgroup *cgrp,
> -                                 enum cgroup_bpf_attach_type atype)
> +                                 enum cgroup_bpf_attach_type atype,
> +                                 gfp_t flags)
>   {
>         struct cgroup_subsys_state *css;
>         int err;
> @@ -340,7 +342,8 @@ static int update_effective_progs(struct cgroup *cgrp,
>                 if (percpu_ref_is_zero(&desc->bpf.refcnt))
>                         continue;
>
> -               err = compute_effective_progs(desc, atype, &desc->bpf.inactive);
> +               err = compute_effective_progs(desc, atype, &desc->bpf.inactive,
> +                                             flags);
>                 if (err)
>                         goto cleanup;
>         }
> @@ -499,7 +502,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>         bpf_cgroup_storages_assign(pl->storage, storage);
>         cgrp->bpf.flags[atype] = saved_flags;
>
> -       err = update_effective_progs(cgrp, atype);
> +       err = update_effective_progs(cgrp, atype, GFP_KERNEL);
>         if (err)
>                 goto cleanup;
>
> @@ -722,7 +725,7 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct
> bpf_prog *prog,
>         pl->prog = NULL;
>         pl->link = NULL;
>
> -       err = update_effective_progs(cgrp, atype);
> +       err = update_effective_progs(cgrp, atype, GFP_NOIO | GFP_NOFS | __GFP_NOFAIL);
>         if (err)
>                 goto cleanup;
>
> >> -cleanup:
> >> -       /* restore back prog or link */
> >> -       pl->prog = old_prog;
> >> -       pl->link = link;
> >> +       /* In case of error call update_effective_progs again */
> >> +       if (err)
> >> +               err = update_effective_progs(cgrp, atype);
> > there is no guarantee that this will now succeed, right? so it's more
> > like "let's try just in case we are lucky this time"?
>
> Yes, there is no guarantee, but my thinking was that since we have freed some
> memory (see kfree(pl) above) let's retry and see if it works this time.
> If that is combined with the above gfp flags it is a good chance that it will
> work. What do you think?
>

See above, instead of compensating for the update_effective_progs()
failure, we should make sure it never fails for detachment.


> --
> Thanks,
> Tadeusz
