Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986705B48D2
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiIJUaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiIJUaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:30:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13AB18E21
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 13:29:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so4665104pjl.0
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 13:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3OB7lD9IsLsjTT/Zgb3BM7QAVB4ydEQ1DyuFepEmj3Y=;
        b=TVDUx2hQxcx9YajRsRQPfI7VgRkyHwrlZO7cYvz2u9rl2snFvvYnJDWLoDS/05E4wo
         X9wuFpyUvGUltIm1E7ICSuu9RUXxc8IZuhn5L+JsWkrR4NZOImmhUW4EP0T+uugqNzrk
         pj0oORzIA08UTdpvjwXpB1Z0OqsgbJBNXYJFmLLAeWia2raNI40zAiXN0D+xsp9QZ5p/
         K72iwJKgPs8GEx00FnC5uf6BRvwUqTvl9SVqVcOgBA0a73PvMA7ltX3imPKfo6GFVKaa
         pdS8B8DF0g0qghIYChRm/Wx6drgajTXiptCZ4zF/uCxPD6xwQ1H2w7ARfL8jIJgxK0sH
         iRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3OB7lD9IsLsjTT/Zgb3BM7QAVB4ydEQ1DyuFepEmj3Y=;
        b=MVcbn5Pr1zsb9tU8qSzLxe9Eing2xgwpQPRrJqJUHaKpJ8yhuHRz6ronRLs5cJH9h4
         iaPXy6OL0sTZz2WY1pzL8+wj+LT0aCmXMR2Ykb5XVfgwtmQci5ZcCDvjzGdRPCQaDnoZ
         flwbhqW9s7ODfhKcXNRMNAhe9xEeEGehfAxiVe4gNvUolAAjnPQSVaYGzyRZkdo3tMFK
         cCFbkkmuVYYrNWlw9LMexqXZBV9fWMzUK9BbEgdu2VNr/335bN8MJmeuJ++2KNpfzQuN
         DXq4XSLuJLT/kIHZa+x6A3/uV7SF5zM8EwOzKG846t20cfoUh2PXcVn5weMs0hdvVjdF
         wjqg==
X-Gm-Message-State: ACgBeo1NweRJuYHg1dh0YEtCKiPSXowHfbfaCmH739gfRIBNDzbdDOzh
        +E5j5YiUWRF5bMzdQ0wWrGjAVf04Lw1sufeZ9e+GFQ==
X-Google-Smtp-Source: AA6agR4zLIlTlZe/0RVmVx49oJdfG1mYQvJFbdLFr1vOKxT2ZifJrd7mtQ4FR3csW9F0zYw8Ux112gEewoiKIAkMYcM=
X-Received: by 2002:a17:902:d505:b0:176:96f1:2e61 with SMTP id
 b5-20020a170902d50500b0017696f12e61mr19227932plg.73.1662841799269; Sat, 10
 Sep 2022 13:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005ed86405e846585a@google.com> <20220910020633.2620505-1-eadavis@sina.com>
In-Reply-To: <20220910020633.2620505-1-eadavis@sina.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Sat, 10 Sep 2022 13:29:47 -0700
Message-ID: <CAKH8qBt_8mEA_2Bn=z9o-rntov8nPa=sH93R8-+zM99u+qP6Fg@mail.gmail.com>
Subject: Re: [PATCH] kernel/bpf: htab_map_alloc() exit by free_map_locked
 logic issue
To:     eadavis@sina.com
Cc:     syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, haoluo@google.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        eadivs <eadivs@sina.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 7:07 PM <eadavis@sina.com> wrote:
>
> From: eadivs <eadivs@sina.com>
>
> syzbot is reporting WARNING: ODEBUG bug in htab_map_alloc(), the
> loop exits without reaching length HASHTAB_MAP_LOCK_COUNT, and
> the loop continues HASHTAB_MAP_LOCK_COUNT times in label
> free_map_locked.

Please use [PATCH bpf] vs [PATCH bpf-next] in subject to indicate
which tree you're targeting.
Also, it seems your email hasn't reached the mailing list for some reason.

Are you sure that the issue is due to HASHTAB_MAP_LOCK_COUNT? The code
seems fine as is; unconditionally calling free on NULL shouldn't be an
issue.

 htab_map_alloc+0xc76/0x1620 kernel/bpf/hashtab.c:632

Which, if I'm looking at the function is:
bpf_map_area_free(htab);

?

> Link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b
> Reported-by: syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com
> Signed-off-by: eadivs <eadivs@sina.com>
> ---
>  kernel/bpf/hashtab.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 65877967f414..f5381e1c00a6 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -473,7 +473,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>         bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
>         bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
>         struct bpf_htab *htab;
> -       int err, i;
> +       int err, i, j = HASHTAB_MAP_LOCK_COUNT;
>
>         htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
>         if (!htab)
> @@ -523,8 +523,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>                                                            sizeof(int),
>                                                            sizeof(int),
>                                                            GFP_USER);
> -               if (!htab->map_locked[i])
> +               if (!htab->map_locked[i]) {
> +                       j = i;
>                         goto free_map_locked;
> +               }
>         }
>
>         if (htab->map.map_flags & BPF_F_ZERO_SEED)
> @@ -554,7 +556,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>  free_prealloc:
>         prealloc_destroy(htab);
>  free_map_locked:
> -       for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
> +       for (i = 0; i < j; i++)
>                 free_percpu(htab->map_locked[i]);
>         bpf_map_area_free(htab->buckets);
>  free_htab:
> --
> 2.37.2
>
