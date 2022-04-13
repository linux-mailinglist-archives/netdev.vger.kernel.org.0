Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A314FEE51
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 06:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiDMEgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 00:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiDMEgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 00:36:35 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D1A20BE6;
        Tue, 12 Apr 2022 21:34:13 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 125so611274iov.10;
        Tue, 12 Apr 2022 21:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+kKAmZ56bSMiCNUh+T1c9pQhR9+j4E7TijaQbHLEFfI=;
        b=DA13Jbr1itHfsq+mubcsEIdeL5WVrgUdhlg1wq21e4tHiw9MtlKgRy81OQWpdbcY2S
         FXxKDjDF4e6MmttFTqsEdOh0l2BFsZP2RmaVLAbH6eEUxoHO9YLR9qa6aB7U+U+t2h2f
         8sOwQ0JI9t9OjyTJzwr//4qCm2bezKDglobwwrqqaAn8B26PklVVRBmuSiG58+jcoPxI
         pdgcSxGAAl+Tk5DXoMejzfwUr6RmOp+x+TOsi5C93hDgBHsLQgRWCsNjaEyJwhs3DGHh
         4BRY/xTUkmrVk5nj80b/ytzxtz7lPuFXyzln+Mp4ElxeKgmKnH2S9EaYzrC4SsUal6b7
         aN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+kKAmZ56bSMiCNUh+T1c9pQhR9+j4E7TijaQbHLEFfI=;
        b=ZB+cAXg5JyZaX8WWglmtXazxMTd9AhbT86K8lb+gX9FjCtvnzxKXhSQUGEWKJZfDnq
         pj2y0xv+QFOL/eMRfCTtdgz+RanUVblJl0Kpkf15Wm7VFFUIaoETbEBkoTat/2+LLP1I
         Esyuv5q6yVBas7huHCWlCqa6s1QRwtTA99m1z0zNl2wPIPp8fMJAdaU4qt17WnahedYo
         StLou0fYp7IgKjCmoR8qgxhXNryd9ZeTWS/4twHVseAHhi7nt+RFvYC5O+gjQh+nFFnj
         oxoYe6lYODGe6OnlvrrqL/TGzjZQjrasgVoW0seZT/L9xczpQwtM/obIbuaZ31XxQAMg
         krzw==
X-Gm-Message-State: AOAM533PyJFb61ZCQel+/xCraYG3eoljtoIW5ScX/hyb+oSeM1N7Caca
        PMwu0sSHGcZj7EcDEmXnVnr59oPLsuKQGk7kcn0=
X-Google-Smtp-Source: ABdhPJzqSVa2ep/AdEZORIqrAJS6wVCc+EbBE13SJmpPq4zS/7me/akccrlRROpUkl+u6W7EbVOSqkgIdE7WjOJYtsc=
X-Received: by 2002:a02:cc07:0:b0:326:3976:81ad with SMTP id
 n7-20020a02cc07000000b00326397681admr5093551jap.237.1649824452458; Tue, 12
 Apr 2022 21:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220405170356.43128-1-tadeusz.struk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Apr 2022 21:34:01 -0700
Message-ID: <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com>
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

On Tue, Apr 5, 2022 at 10:04 AM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
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
> To fix this don't preserve the pointer to the link on the cgroup list
> in __cgroup_bpf_detach(), but proceed with the cleanup and retry calling
> update_effective_progs() again afterwards.

I think it's still problematic. BPF link might have been the last one
that holds bpf_prog's refcnt, so when link is put, its prog can stay
there in effective_progs array(s) and will cause use-after-free
anyways.

It would be best to make sure that detach never fails. On detach
effective prog array can only shrink, so even if
update_effective_progs() fails to allocate memory, we should be able
to iterate and just replace that prog with NULL, as a fallback
strategy.

>
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
>  kernel/bpf/cgroup.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 128028efda64..b6307337a3c7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -723,10 +723,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>         pl->link = NULL;
>
>         err = update_effective_progs(cgrp, atype);
> -       if (err)
> -               goto cleanup;
> -
> -       /* now can actually delete it from this cgroup list */
> +       /*
> +        * Proceed regardless of error. The link and/or prog will be freed
> +        * just after this function returns so just delete it from this
> +        * cgroup list and retry calling update_effective_progs again later.
> +        */
>         list_del(&pl->node);
>         kfree(pl);
>         if (list_empty(progs))
> @@ -735,12 +736,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>         if (old_prog)
>                 bpf_prog_put(old_prog);
>         static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> -       return 0;
>
> -cleanup:
> -       /* restore back prog or link */
> -       pl->prog = old_prog;
> -       pl->link = link;
> +       /* In case of error call update_effective_progs again */
> +       if (err)
> +               err = update_effective_progs(cgrp, atype);

there is no guarantee that this will now succeed, right? so it's more
like "let's try just in case we are lucky this time"?

> +
>         return err;
>  }
>
> @@ -881,6 +881,7 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
>         struct bpf_cgroup_link *cg_link =
>                 container_of(link, struct bpf_cgroup_link, link);
>         struct cgroup *cg;
> +       int err;
>
>         /* link might have been auto-detached by dying cgroup already,
>          * in that case our work is done here
> @@ -896,8 +897,10 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
>                 return;
>         }
>
> -       WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> -                                   cg_link->type));
> +       err = __cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> +                                 cg_link->type);
> +       if (err)
> +               pr_warn("cgroup_bpf_detach() failed, err %d\n", err);
>
>         cg = cg_link->cgroup;
>         cg_link->cgroup = NULL;
> --
> 2.35.1
