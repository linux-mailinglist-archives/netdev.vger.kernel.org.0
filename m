Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5C825B848
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgICB0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgICB0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 21:26:11 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3384C061244;
        Wed,  2 Sep 2020 18:26:10 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so955287ybp.7;
        Wed, 02 Sep 2020 18:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wk1QngnZveRkG+Rb9Te6BreL5IP4JNk/9WC7Z4W7xWw=;
        b=WR0w0oiA7+ffGDKltlEFg7Xl6jFWWcuC8zsduLexb5JShwtBxZaaBoYSfBcU3Hu//C
         WFpRtduIQjbASIkGqwYh7VUpR3L9prjMteeiPWFhbRwHT+iagjQSr7q6wzCcd2fpCt5e
         tvWGprcw9HqW/DF6yYFHnqjqmdoFPpLOJS9CzPdJaNdt/pogy9IF2LKYgdHvjsTGaQuY
         i7F5N/fYN3IVb2qPqmldwsXXkBokj732kCo4rXo5FEx5PQcnDcPl6Rub442jECA1IXU0
         3/QHB1tDn+jaOGjYA6pRMuRQ73p32gX+tCI+DsYL78NZrun626b+2839bXta/knmPdUI
         Z+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wk1QngnZveRkG+Rb9Te6BreL5IP4JNk/9WC7Z4W7xWw=;
        b=PnEJBfE+fSy4hcI3x4wic2Nr+8vmIyRN0jsXeiQGZyA28aeuPbm/hUDDF8iD9cpsCs
         5DGTPVGeM7lQgtrI78+XawL3o0xFvf/pAvuTralPhGaCx5p63lTR5noKSspULAJAc25i
         g4/lwyotMRNZuPu1g+WsHMoishaV7geVaMp63pUu9gHri5wztVG8azlhSjiPQ7ZwANDR
         SM++ZmjJLAScC67SlxLWh8BrPU+vB4GiD7BVNIvXjboYXjKfwoG35TOObIUHXfru5JL2
         B/crxN98BiPd6frEYUQCjNDBzAzrcb3s8592U28eAUjj5NIrtJ2G416kIKxFrnf45C/z
         q1qQ==
X-Gm-Message-State: AOAM531VRzKIMQYB6r1zDErL/dxGQghGKMS79UJKECPTe9PWT7E2JrqA
        tEFTxZZNQ3X+em0SPDF7dahBIghWs5J6I8rwjV4=
X-Google-Smtp-Source: ABdhPJyCnZQ872Fg/QMUc/AZGGmLaCS6mPNLLT2EBufUh+uUbIryGBfVCF757Qi15JvioxfKLTM4zL2NnxFf6rJTAuw=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr677859ybg.425.1599096368004;
 Wed, 02 Sep 2020 18:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200902235340.2001300-1-yhs@fb.com> <20200902235340.2001375-1-yhs@fb.com>
In-Reply-To: <20200902235340.2001375-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 18:25:57 -0700
Message-ID: <CAEf4BzaBxaPyWXOWOVRWCXcLW40FOFWkG7gUPSktGwS07duQVA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: do not use bucket_lock for hashmap iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
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

On Wed, Sep 2, 2020 at 4:56 PM Yonghong Song <yhs@fb.com> wrote:
>
> Currently, for hashmap, the bpf iterator will grab a bucket lock, a
> spinlock, before traversing the elements in the bucket. This can ensure
> all bpf visted elements are valid. But this mechanism may cause
> deadlock if update/deletion happens to the same bucket of the
> visited map in the program. For example, if we added bpf_map_update_elem()
> call to the same visited element in selftests bpf_iter_bpf_hash_map.c,
> we will have the following deadlock:
>

[...]

>
> Compared to old bucket_lock mechanism, if concurrent updata/delete happens,
> we may visit stale elements, miss some elements, or repeat some elements.
> I think this is a reasonable compromise. For users wanting to avoid

I agree, the only reliable way to iterate map without duplicates and
missed elements is to not update that map during iteration (unless we
start supporting point-in-time snapshots, which is a very different
matter).


> stale, missing/repeated accesses, bpf_map batch access syscall interface
> can be used.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  kernel/bpf/hashtab.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 78dfff6a501b..7df28a45c66b 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1622,7 +1622,6 @@ struct bpf_iter_seq_hash_map_info {
>         struct bpf_map *map;
>         struct bpf_htab *htab;
>         void *percpu_value_buf; // non-zero means percpu hash
> -       unsigned long flags;
>         u32 bucket_id;
>         u32 skip_elems;
>  };
> @@ -1632,7 +1631,6 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
>                            struct htab_elem *prev_elem)
>  {
>         const struct bpf_htab *htab = info->htab;
> -       unsigned long flags = info->flags;
>         u32 skip_elems = info->skip_elems;
>         u32 bucket_id = info->bucket_id;
>         struct hlist_nulls_head *head;
> @@ -1656,19 +1654,18 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
>
>                 /* not found, unlock and go to the next bucket */
>                 b = &htab->buckets[bucket_id++];
> -               htab_unlock_bucket(htab, b, flags);
> +               rcu_read_unlock();

Just double checking as I don't yet completely understand all the
sleepable BPF implications. If the map is used from a sleepable BPF
program, we are still ok doing just rcu_read_lock/rcu_read_unlock when
accessing BPF map elements, right? No need for extra
rcu_read_lock_trace/rcu_read_unlock_trace?

>                 skip_elems = 0;
>         }
>

[...]
