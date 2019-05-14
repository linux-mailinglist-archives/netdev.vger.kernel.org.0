Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2FF1C1AC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 07:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfENFEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 01:04:16 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42299 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfENFEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 01:04:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id j53so17513644qta.9;
        Mon, 13 May 2019 22:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=akDv0Gc/Sv72XbM2LkC/VA0sylIzg07vUXqnm63VUSc=;
        b=YZrz5wZxdiZRvdh640IQopHRFQl+2X4my9PicMsIEGpSR4usPGI7ABulqih8Jw3iAK
         YCYTgwOOWh9h8sVvugWLnT13NuYZ7oJL8CDeXt4e5P2IjVz8Wbt1DHxI0Au3lZtrH6Bv
         uESEc06IR0A0GBI4h8MJeNWze3BYVqq7GJ7ep0yfjuE23ri4Q07+RvYTF2ep8FLIS5ly
         DxgxsB5HifLsbwSjf+Qwg/w3Ou0JZsHIi3JiB4g73FuamanjWVaAYkOLLaf809GO2S2f
         vd4o3Tef3Vu5l/7Ge9iqBQ+N8xA00YuAeR+kjPPvEbBOaFHNkSVr1QmA+K+BnuTJf9xD
         Q2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=akDv0Gc/Sv72XbM2LkC/VA0sylIzg07vUXqnm63VUSc=;
        b=pkrd7OaVZWNt3XtpUEHLBD5qnRp0xVy937zPfr1H6J+5rwIjDQ/KMAfirp/yEcgy5Q
         Ju/1AUXOb/WZ3IuPpofFMPmPw50229ohsc4Ktg5UNr/Ni+lvtK7lEzbaGVfNHaKvg3mQ
         HBIGdcokY3GfocZL8yO8a8PgBwscvQnpeAiZ7bbm9KXkLLgAnlANjQpMa4Cm0p5hsMAs
         /fm/HH2HNQXFmvZOLeUZonh0NIEZ9rA5oFvv5SMpq99OpNSoZKQIsLCF4KwBJSLGVScS
         vdZaKfv2JRxi8aKhnaIfW6GL7ytczm52vPaYZkOWAxPkSYYTycTu0lR6M6Iqq74HjqxG
         GUxA==
X-Gm-Message-State: APjAAAV5ZjfEFUke7po3EyG4cw3g1m/aL4WhZbe+vWGTBk8DTQAYoq7l
        uYEnni54CSvAwXFLnLp8ERh94HWhqjopypMIcE0=
X-Google-Smtp-Source: APXvYqxdMw4R2VyaNEFZSYQwN7g7aWq2b3MywJX475MPvvtC+YhQa997AA9UEn7LhAU+Yh9KkAzZIgsWWUfLs4PIvEk=
X-Received: by 2002:a0c:95d5:: with SMTP id t21mr19516030qvt.215.1557810254748;
 Mon, 13 May 2019 22:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1557789256.git.daniel@iogearbox.net> <505e5dfeea6ab7dd3719bb9863fc50e7595e06ed.1557789256.git.daniel@iogearbox.net>
In-Reply-To: <505e5dfeea6ab7dd3719bb9863fc50e7595e06ed.1557789256.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 May 2019 22:04:03 -0700
Message-ID: <CAEf4BzZc_8FfHKA0rEvgx8T0xRWQp-2scm1N+nwroXi5enDh_g@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf: add map_lookup_elem_sys_only for lookups
 from syscall side
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 4:20 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add a callback map_lookup_elem_sys_only() that map implementations
> could use over map_lookup_elem() from system call side in case the
> map implementation needs to handle the latter differently than from
> the BPF data path. If map_lookup_elem_sys_only() is set, this will
> be preferred pick for map lookups out of user space. This hook is

This is kind of surprising behavior  w/ preferred vs default lookup
code path. Why the desired behavior can't be achieved with an extra
flag, similar to BPF_F_LOCK? It seems like it will be more explicit,
more extensible and more generic approach, avoiding duplication of
lookup semantics.

E.g., for LRU map, with flag on lookup, one can decide whether lookup
from inside BPF program (not just from syscall side!) should modify
LRU ordering or not, simply by specifying extra flag. Am I missing
some complication that prevents us from doing it that way?

> used in a follow-up fix for LRU map, but once development window
> opens, we can convert other map types from map_lookup_elem() (here,
> the one called upon BPF_MAP_LOOKUP_ELEM cmd is meant) over to use
> the callback to simplify and clean up the latter.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h  | 1 +
>  kernel/bpf/syscall.c | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 59631dd..4fb3aa2 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -36,6 +36,7 @@ struct bpf_map_ops {
>         void (*map_free)(struct bpf_map *map);
>         int (*map_get_next_key)(struct bpf_map *map, void *key, void *next_key);
>         void (*map_release_uref)(struct bpf_map *map);
> +       void *(*map_lookup_elem_sys_only)(struct bpf_map *map, void *key);
>
>         /* funcs callable from userspace and from eBPF programs */
>         void *(*map_lookup_elem)(struct bpf_map *map, void *key);
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index ad3ccf8..cb5440b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -808,7 +808,10 @@ static int map_lookup_elem(union bpf_attr *attr)
>                 err = map->ops->map_peek_elem(map, value);
>         } else {
>                 rcu_read_lock();
> -               ptr = map->ops->map_lookup_elem(map, key);
> +               if (map->ops->map_lookup_elem_sys_only)
> +                       ptr = map->ops->map_lookup_elem_sys_only(map, key);
> +               else
> +                       ptr = map->ops->map_lookup_elem(map, key);
>                 if (IS_ERR(ptr)) {
>                         err = PTR_ERR(ptr);
>                 } else if (!ptr) {
> --
> 2.9.5
>
