Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EE626E96A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgIQXVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIQXVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 19:21:49 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7604B20870;
        Thu, 17 Sep 2020 23:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600384908;
        bh=ZcCU89wBoLhrvM3l5xbyYx1b+RaLLH7G0whMHPwn0nI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kTikafltNLjyW4lLbfA7xIjMFBhM3/Ms33Q/AO1NMBZ0FCf6EDWMpgInoqJWPF8Mr
         jPQgqRnePZRkRUUGuMIY73cWYwGgRzjA8LrgvAKVSpKaOpvUH47qdocDmL7hBtmVRF
         j6vFKnUYjN+jJbHlDtZidThU/xNG6ZfQfLI3Z7iw=
Received: by mail-lf1-f48.google.com with SMTP id u8so4059563lff.1;
        Thu, 17 Sep 2020 16:21:48 -0700 (PDT)
X-Gm-Message-State: AOAM5320LrD+4LcdOCxW0oIvrxEO/U00pIfoxTUxRMmLdJ4mRStYKbcr
        CIRK5za2nWWOoKZguK2ug1h3HtuRs7PHX+3sMyg=
X-Google-Smtp-Source: ABdhPJzbPaNTGkLOcGBXm9hWyjTAm71EO0Y2Na5ZEEHhD1PkHfSt4yVGB6PJFxnTedUW1WoqWj056ykLsczqz8eJGRE=
X-Received: by 2002:a19:cc09:: with SMTP id c9mr9113446lfg.482.1600384906796;
 Thu, 17 Sep 2020 16:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200917135700.649909-1-luka.oreskovic@sartura.hr>
In-Reply-To: <20200917135700.649909-1-luka.oreskovic@sartura.hr>
From:   Song Liu <song@kernel.org>
Date:   Thu, 17 Sep 2020 16:21:35 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4WXqiK-AFP6nU1L03yXGLLuz845mFP8W_rhbyaw=Ck=w@mail.gmail.com>
Message-ID: <CAPhsuW4WXqiK-AFP6nU1L03yXGLLuz845mFP8W_rhbyaw=Ck=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add support for other map types to bpf_map_lookup_and_delete_elem
To:     Luka Oreskovic <luka.oreskovic@sartura.hr>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Juraj Vijtiuk <juraj.vijtiuk@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 7:16 AM Luka Oreskovic
<luka.oreskovic@sartura.hr> wrote:
>
[...]

> +++ b/kernel/bpf/syscall.c
> @@ -1475,6 +1475,9 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>         if (CHECK_ATTR(BPF_MAP_LOOKUP_AND_DELETE_ELEM))
>                 return -EINVAL;
>
> +       if (attr->flags & ~BPF_F_LOCK)
> +               return -EINVAL;
> +

Please explain (in comments for commit log) the use of BPF_F_LOCK in
the commit log,
as it is new for BPF_MAP_LOOKUP_AND_DELETE_ELEM.

>         f = fdget(ufd);
>         map = __bpf_map_get(f);
>         if (IS_ERR(map))
> @@ -1485,13 +1488,19 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>                 goto err_put;
>         }
>
> +       if ((attr->flags & BPF_F_LOCK) &&
> +           !map_value_has_spin_lock(map)) {
> +               err = -EINVAL;
> +               goto err_put;
> +       }
> +
>         key = __bpf_copy_key(ukey, map->key_size);
>         if (IS_ERR(key)) {
>                 err = PTR_ERR(key);
>                 goto err_put;
>         }
>
> -       value_size = map->value_size;
> +       value_size = bpf_map_value_size(map);
>
>         err = -ENOMEM;
>         value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> @@ -1502,7 +1511,24 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>             map->map_type == BPF_MAP_TYPE_STACK) {
>                 err = map->ops->map_pop_elem(map, value);
>         } else {
> -               err = -ENOTSUPP;
> +               err = bpf_map_copy_value(map, key, value, attr->flags);
> +               if (err)
> +                       goto free_value;

IIUC, we cannot guarantee the value returned is the same as the value we
deleted. If this is true, I guess this may confuse the user with some
concurrency
bug.

Thanks,
Song

[...]
