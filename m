Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80368508E06
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380891AbiDTRK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380890AbiDTRK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:10:26 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F899A1AC;
        Wed, 20 Apr 2022 10:07:39 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id r1so2130945vsi.12;
        Wed, 20 Apr 2022 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wzRThF5HaMonZLDTFgx0pibWyxVIQs6oTZK8LgP7Rk=;
        b=DIRM9JAA75v6UB8C3NSUnFYtbGPd/6hGhEKGkyI+Qzs60Io3TIPm88HkB1ucaEZpUO
         tpM93Zbvl4jgUFSDoE4EoTeK/OEylNiGBJXMwM7V+qQDeF1wYJ7OoFK0oty62mH9NDuz
         nG8q5XHmMEiRTwqLUHGRn/xscX49csCdN5yb2XWU6CJaStkPgBBY2zZj3pc2qa7BmrB2
         JLhYu1voLabqjhPlEX5dEdbIrCkLwOekaD0SZh1jcGX20ucW3tZGLk8RK8icG4S1lVVz
         eRKqffFRMSZBeqmHCRtpIQ1PR7Hj4mN8iS96oc8YcGGNnXfRMwsVdtZDZtaSFVIdgCI9
         L8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wzRThF5HaMonZLDTFgx0pibWyxVIQs6oTZK8LgP7Rk=;
        b=HXCEvX3FfW/eRPlZmFcjejoV1b/es2/JRqNpGWTF1JYVBlyhZ8swpIf6NJYFAI2xbF
         6kNvgB/5+lG4RLWMm6LFmd9iUEACFtg9hUC9921RZar9YhWEWSCERzJVbkiTNsnNwPlx
         Rix2cPsSjOQflM65Ia5comUobDE+VqvXU++QTD7w6Aduq6UBFviyv1NPFcvDe7ViII1B
         ZD79ihfksAnLJ6aOe2vAvzOpemDGlzS9EqvweFKzRon07HDGSVTVXdgkAw1p0v3Au49T
         SrLV7CpGouCKrQ398mB7ym+ihf4YOx5U/6J383RbMJjegi2B4/Rjtpotqg1cfQTIGZEQ
         Md9g==
X-Gm-Message-State: AOAM531aL6sbeLMBdh7Qu20UATMaDQSnZQ3aLEHzxfdtTpTg83PXXPJb
        ut1auZx7LYaKa5jYNwb4zaJAXHlmuODTi+Xt2dE=
X-Google-Smtp-Source: ABdhPJwosYeXjdDFdfe3eeuiuX8GCcuD9bNGCVWpuxBZPWoXVPR9lp6Cb9JSRQa3umfSF+agDr9O5WRgsMqQGbAUo80=
X-Received: by 2002:a67:f80b:0:b0:32a:17d6:7fb2 with SMTP id
 l11-20020a67f80b000000b0032a17d67fb2mr6249988vso.40.1650474458618; Wed, 20
 Apr 2022 10:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbiVeQfhxEu908w2mU4d8+5kKeMknuvhzCXuxM9pJ1jmQ@mail.gmail.com>
 <20220415141355.4329-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220415141355.4329-1-tadeusz.struk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Apr 2022 10:07:27 -0700
Message-ID: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
Subject: Re: [PATCH v2] bpf: Fix KASAN use-after-free Read in compute_effective_progs
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 7:14 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
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
> list, but remove it and rearrange the effective table without
> shrinking it. The subsequent call to __cgroup_bpf_detach() or
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
> ---
>  kernel/bpf/cgroup.c | 55 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 48 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..5a64cece09f3 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -723,10 +723,8 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>         pl->link = NULL;
>
>         err = update_effective_progs(cgrp, atype);
> -       if (err)
> -               goto cleanup;
>
> -       /* now can actually delete it from this cgroup list */
> +       /* now can delete it from this cgroup list */
>         list_del(&pl->node);
>         kfree(pl);
>         if (list_empty(progs))
> @@ -735,12 +733,55 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>         if (old_prog)
>                 bpf_prog_put(old_prog);
>         static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> -       return 0;
> +
> +       if (!err)
> +               return 0;
>
>  cleanup:
> -       /* restore back prog or link */
> -       pl->prog = old_prog;
> -       pl->link = link;
> +       /*
> +        * If compute_effective_progs failed with -ENOMEM, i.e. alloc for
> +        * cgrp->bpf.inactive table failed, we can recover by removing
> +        * the detached prog from effective table and rearranging it.
> +        */
> +       if (err == -ENOMEM) {
> +               struct bpf_prog_array_item *item;
> +               struct bpf_prog *prog_tmp, *prog_detach, *prog_last;
> +               struct bpf_prog_array *array;
> +               int index = 0, index_detach = -1;
> +
> +               array = cgrp->bpf.effective[atype];
> +               item = &array->items[0];
> +
> +               if (prog)
> +                       prog_detach = prog;
> +               else
> +                       prog_detach = link->link.prog;
> +
> +               if (!prog_detach)
> +                       return -EINVAL;
> +
> +               while ((prog_tmp = READ_ONCE(item->prog))) {
> +                       if (prog_tmp == prog_detach)
> +                               index_detach = index;
> +                       item++;
> +                       index++;
> +                       prog_last = prog_tmp;
> +               }
> +
> +               /* Check if we found what's needed for removing the prog */
> +               if (index_detach == -1 || index_detach == index-1)
> +                       return -EINVAL;
> +
> +               /* Remove the last program in the array */
> +               if (bpf_prog_array_delete_safe_at(array, index-1))
> +                       return -EINVAL;
> +
> +               /* and update the detached with the last just removed */
> +               if (bpf_prog_array_update_at(array, index_detach, prog_last))
> +                       return -EINVAL;
> +
> +               err = 0;
> +       }

There are a bunch of problems with this implementation.

1. We should do this fallback right after update_effective_progs()
returns error, before we get to list_del(&pl->node) and subsequent
code that does some additional things (like clearing flags and stuff).
This additional code needs to run even if update_effective_progs()
fails. So I suggest to extract the logic of removing program from
effective prog arrays into a helper function and doing

err = update_effective_progs(...);
if (err)
    purge_effective_progs();

where purge_effective_progs() will be the logic you are adding. And it
will be void function because it can't fail.

2. We have to update not just cgrp->bpf.effective array, but all the
descendants' lists as well. See what update_effective_progs() is
doing, it has css_for_each_descendant_pre() iteration. You need to do
it here as well. But instead of doing compute_effective_progs() which
allocates a new copy of an array we'll need to update existing array
in place.

3. Not clear why you need to do both bpf_prog_array_delete_safe_at()
and bpf_prog_array_update_at(), isn't delete_safe_at() enought?


>         return err;
>  }
>
> --
> 2.35.1
>
