Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6A052950C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349845AbiEPXQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbiEPXQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:16:27 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7369B33355;
        Mon, 16 May 2022 16:16:24 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id e3so17642030ios.6;
        Mon, 16 May 2022 16:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CkJCpZYF3YiWQAlyyCzoYmT0xNfZ0LhU8zbi9exA0fY=;
        b=WZWIn4cTUBVxmfh1NkllORnBTgLjF2t2Tw4qtcUtKnWI9Xf10TRiI6CjomCXVBT7Yu
         ZIwM+AiiAEfivZhQoXoQJMEDBeYCCtZPmBNq75vE7Vh8oehv/8zniMcD7I3+V2VNGKIs
         aNtHdqHBEkLwZrftH3+rxTtrdIiA8T71OUZUXtpdmabw2FFVM9X6vbrKZJMSiBCMzht2
         rNwb/Xdbh+R1gLzHosJRQO9bINRNjDsWQZA/JIZ/nuAgJMj3mkuE0JSWRjdZH8Pc/NmT
         KuPD+sAk458IO2xbqG7PpfZnV3WRX/6YDsdPvAHe+30e3a4UqbAlVebUf6UcWofVS5re
         kL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CkJCpZYF3YiWQAlyyCzoYmT0xNfZ0LhU8zbi9exA0fY=;
        b=PY6Vy71FZeAXwC+y9iMPqY+yKeIszM+d9AElknO2D5k+bSfzaySd/kamDElFkz21uf
         F5v+af8F9+rF8Nqz1MSFiZcR2WlDb/RQYBQlo9vVU3f8w2Wd2O/Gs+UIjlW/qSjR9WGD
         n5UkwB0yna3GaYJPYJKgaCpYs8vojgspHhqmWtaCOsNrjHQFJSEAFEZkzEdl390rM3nG
         utS0zQqb2s3LUDCVhQI/GgSo2OAyVu95gtM96YpgMQzDj2BTy7db5yZm4TNnpSkAyxfZ
         NEeBAWum6SIPC344LnJpgFMQR6gSp3BO/gBrcFkEokG1QTCNelNYybKlbGnEh2YM2YOF
         EAEw==
X-Gm-Message-State: AOAM530jxfMBtrfBJIkoCI0hmecoWi8netOu0jJfgdtRj2MBx/Sr75Be
        Vglbb6q1vdcC0yNoda2k0D4jvdxnU3gm2Q5vp5zeVxN1lIo=
X-Google-Smtp-Source: ABdhPJxsgMivtG1wJz81mSCLpYcBucq/j19d/vLSxCTD97TQ5HP/GBtUQs/ZzxG3c70XnQZmFH9b8k8FR1j5HUGNRP4=
X-Received: by 2002:a05:6638:2393:b0:32e:319d:c7cc with SMTP id
 q19-20020a056638239300b0032e319dc7ccmr4010364jat.103.1652742983822; Mon, 16
 May 2022 16:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
 <20220513190821.431762-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220513190821.431762-1-tadeusz.struk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 May 2022 16:16:12 -0700
Message-ID: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
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

On Fri, May 13, 2022 at 12:08 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> Syzbot found a Use After Free bug in compute_effective_progs().
> The reproducer creates a number of BPF links, and causes a fault
> injected alloc to fail, while calling bpf_link_detach on them.
> Link detach triggers the link to be freed by bpf_link_free(),
> which calls __cgroup_bpf_detach() and update_effective_progs().
> If the memory allocation in this function fails, the function restores
> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> gets freed just after it returns. After this, every subsequent call to
> update_effective_progs() causes this already deallocated pointer to be
> dereferenced in prog_list_length(), and triggers KASAN UAF error.
>
> To fix this issue don't preserve the pointer to the prog or link in the
> list, but remove it and replace it with a dummy prog without shrinking
> the table. The subsequent call to __cgroup_bpf_detach() or
> __cgroup_bpf_detach() will correct it.
>
> Cc: "Alexei Starovoitov" <ast@kernel.org>
> Cc: "Daniel Borkmann" <daniel@iogearbox.net>
> Cc: "Andrii Nakryiko" <andrii@kernel.org>
> Cc: "Martin KaFai Lau" <kafai@fb.com>
> Cc: "Song Liu" <songliubraving@fb.com>
> Cc: "Yonghong Song" <yhs@fb.com>
> Cc: "John Fastabend" <john.fastabend@gmail.com>
> Cc: "KP Singh" <kpsingh@kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: <bpf@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
> Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> v2: Add a fall back path that removes a prog from the effective progs
>     table in case detach fails to allocate memory in compute_effective_progs().
>
> v3: Implement the fallback in a separate function purge_effective_progs
> ---
>  kernel/bpf/cgroup.c | 64 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 56 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..9d3af4d6c055 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -681,6 +681,57 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
>         return ERR_PTR(-ENOENT);
>  }
>
> +/**
> + * purge_effective_progs() - After compute_effective_progs fails to alloc new
> + *                           cgrp->bpf.inactive table we can recover by
> + *                           recomputing the array in place.
> + *
> + * @cgrp: The cgroup which descendants to traverse
> + * @link: A link to detach
> + * @atype: Type of detach operation
> + */
> +static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
> +                                 enum cgroup_bpf_attach_type atype)
> +{
> +       struct cgroup_subsys_state *css;
> +       struct bpf_prog_array_item *item;
> +       struct bpf_prog *tmp;
> +       struct bpf_prog_array *array;
> +       int index = 0, index_purge = -1;
> +
> +       if (!prog)
> +               return;
> +
> +       /* recompute effective prog array in place */
> +       css_for_each_descendant_pre(css, &cgrp->self) {
> +               struct cgroup *desc = container_of(css, struct cgroup, self);
> +
> +               array = desc->bpf.effective[atype];

../kernel/bpf/cgroup.c:748:23: warning: incorrect type in assignment
(different address spaces)
../kernel/bpf/cgroup.c:748:23:    expected struct bpf_prog_array *array
../kernel/bpf/cgroup.c:748:23:    got struct bpf_prog_array [noderef] __rcu *


you need rcu_dereference here? but also see suggestions below to avoid
iterating effective directly (it's ambiguous to search by prog only)

> +               item = &array->items[0];
> +
> +               /* Find the index of the prog to purge */
> +               while ((tmp = READ_ONCE(item->prog))) {
> +                       if (tmp == prog) {

I think comparing just prog isn't always correct, as the same program
can be in effective array multiple times if attached through bpf_link.

Looking at replace_effective_prog() I think we can do a very similar
(and tested) approach:

1. restore original pl state in __cgroup_bpf_detach (so we can find it
by comparing pl->prog == prog && pl->link == link)
2. use replace_effective_prog's approach to find position of pl in
effective array (using this nested for loop over cgroup parents and
list_for_each_entry inside)
3. then instead of replacing one prog with another do
bpf_prog_array_delete_safe_at ?

I'd feel more comfortable using the same tested overall approach of
replace_effective_prog.

> +                               index_purge = index;
> +                               break;
> +                       }
> +                       item++;
> +                       index++;
> +               }
> +
> +               /* Check if we found what's needed for removing the prog */
> +               if (index_purge == -1 || index_purge == index - 1)
> +                       continue;

the search shouldn't fail, should it?

> +
> +               /* Remove the program from the array */
> +               WARN_ONCE(bpf_prog_array_delete_safe_at(array, index_purge),
> +                         "Failed to purge a prog from array at index %d", index_purge);
> +
> +               index = 0;
> +               index_purge = -1;
> +       }
> +}
> +
>  /**
>   * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
>   *                         propagate the change to descendants
> @@ -723,8 +774,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>         pl->link = NULL;
>
>         err = update_effective_progs(cgrp, atype);
> -       if (err)
> -               goto cleanup;
> +       if (err) {
> +               struct bpf_prog *prog_purge = prog ? prog : link->link.prog;
> +

so here we shouldn't forget link, instead pass both link and prog (one
of them will have to be NULL) into purge_effective_progs

> +               purge_effective_progs(cgrp, prog_purge, atype);
> +       }
>
>         /* now can actually delete it from this cgroup list */
>         list_del(&pl->node);
> @@ -736,12 +790,6 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>                 bpf_prog_put(old_prog);
>         static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>         return 0;
> -
> -cleanup:
> -       /* restore back prog or link */
> -       pl->prog = old_prog;
> -       pl->link = link;
> -       return err;
>  }
>
>  static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> --
> 2.36.1
>
