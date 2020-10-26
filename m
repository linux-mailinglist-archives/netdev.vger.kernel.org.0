Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED62999D9
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394700AbgJZWsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:48:04 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38941 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394693AbgJZWsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:48:04 -0400
Received: by mail-yb1-f195.google.com with SMTP id 67so9064508ybt.6;
        Mon, 26 Oct 2020 15:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PA2hhwrwqtvoOE+FLl+y7isib+ymGtY6avG/tLKX2Xk=;
        b=aJCbZos+nqsSXDhOpj87YejpT0j5KCVzCavOAn4pxK0wOV5swptqtNjXoISVn0F5ez
         zu1fIF8KkCddX8aZIrHqPji48zEOcpSVshtT9u0LoNOwDt+FHF+fvWWbmDgHq9FjURzg
         J6NOdtgsz4Gi9sH5eiY9a1QtZu7dGleQfGYkQ/UUxe9p4XReIGIg2oj6Xa3YxV50N3sS
         aK86UYCU44CZ3aR+xs8JelKyOimYgBD+19eswAs5bUUBW7oPCS5dv+MyDaYIkK/0a/NO
         nQKqG87dvbnTJlwSpTy7Prt2/ltqQ0Cn8t9I7iXl1f1hSJXsy9EHML6Vo/8Gd31L+734
         gqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PA2hhwrwqtvoOE+FLl+y7isib+ymGtY6avG/tLKX2Xk=;
        b=akV56xis7vh6kwKoMCyzZ+ymMcfWfIHxm0Tai4fwVS1f05vN+TZBPpcOpcBYBAaCPs
         uuzFW5bu8wMqJHi21SedF+KTukcSjPyJpNtoulc7KAKcJHZ6On9ON8m3Kv6G892C3P3k
         e9rP7BIoaZAxSvXpZhMd/9pNKE65VPNnQw4F5kVbHNvSzhxJU4qsP+uCYQgzath4znYx
         bwua4SllQ6fFP5Uq/Cp5XmU7wmHj1iiU/Ucwy1NysvLoXdaMl5bq+ajzcsC+4LjlIakb
         KKM4p8jDF4NrM44aY0QQjgdaRtnlEexeeOQ5IfBMQddY9b5NGq6DM6wStySIGEdqR2ax
         efzQ==
X-Gm-Message-State: AOAM533273LEobYFqU9xSstD+DzojK9LTE9bUccnZ+8W181t3mfGs0Kh
        xEVBKCJLdeHLId18nDPcxXopiZgZfWYM8GFFjqnM3/OUf8Q=
X-Google-Smtp-Source: ABdhPJzqLzSh3NdCaWLdV1qCZnoGLPNbcf+wWI9Pi2IVD2005O92IpCE32wJVXJAXi7STygW/I0SZWVLilCg4kJE6Qk=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr27942447ybk.260.1603752482632;
 Mon, 26 Oct 2020 15:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201023123754.30304-1-david.verbeiren@tessares.net>
In-Reply-To: <20201023123754.30304-1-david.verbeiren@tessares.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 15:47:51 -0700
Message-ID: <CAEf4BzZaJaYw0tB0R+q3qoQX7=qy3T9jvzf5q=TH++t66wNd-w@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: zero-fill re-used per-cpu map element
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 8:48 AM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> Zero-fill element values for all cpus, just as when not using
> prealloc. This is the only way the bpf program can ensure known
> initial values for cpus other than the current one ('onallcpus'
> cannot be set when coming from the bpf program).
>
> The scenario is: bpf program inserts some elements in a per-cpu
> map, then deletes some (or userspace does). When later adding
> new elements using bpf_map_update_elem(), the bpf program can
> only set the value of the new elements for the current cpu.
> When prealloc is enabled, previously deleted elements are re-used.
> Without the fix, values for other cpus remain whatever they were
> when the re-used entry was previously freed.
>
> Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
> ---
>  kernel/bpf/hashtab.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 1815e97d4c9c..667553cce65a 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -836,6 +836,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
>         bool prealloc = htab_is_prealloc(htab);
>         struct htab_elem *l_new, **pl_new;
>         void __percpu *pptr;
> +       int cpu;
>
>         if (prealloc) {
>                 if (old_elem) {
> @@ -880,6 +881,17 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
>                 size = round_up(size, 8);
>                 if (prealloc) {
>                         pptr = htab_elem_get_ptr(l_new, key_size);
> +
> +                       /* zero-fill element values for all cpus, just as when
> +                        * not using prealloc. Only way for bpf program to
> +                        * ensure known initial values for cpus other than
> +                        * current one (onallcpus=false when coming from bpf
> +                        * prog).
> +                        */
> +                       if (!onallcpus)
> +                               for_each_possible_cpu(cpu)
> +                                       memset((void *)per_cpu_ptr(pptr, cpu),
> +                                              0, size);

Technically, you don't have to memset() for the current CPU, right?
Don't know if extra check is cheaper than avoiding one memset() call,
though.

But regardless, this 6 level nesting looks pretty bad, maybe move the
for_each_possible_cpu() loop into a helper function?

Also, does the per-CPU LRU hashmap need the same treatment?

>                 } else {
>                         /* alloc_percpu zero-fills */
>                         pptr = __alloc_percpu_gfp(size, 8,
> --
> 2.29.0
>
