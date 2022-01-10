Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A17488E34
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbiAJBsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbiAJBsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:48:52 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2969C06173F;
        Sun,  9 Jan 2022 17:48:51 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id b1so10082545ilj.2;
        Sun, 09 Jan 2022 17:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRzXEInKytKx8eViRZxOhhZFZGHIQQcx095M8KO/MJQ=;
        b=GSJynyKV6hgpd7JxZq5oTQDFP1DQekXa6FJ++BcB7o3Eona+DdeMWQbCxWTSSKDKPN
         e+uInvsfkeu6r/T4qqThTOcM2kn/7IB8LUTJkOgJB+HT7NPPa7d9Qc7dvW9HhVf7UFi2
         HK0fn8N2+WZxGraj2j473ZlrIYjNLgQch6VVA4olJJoZjyXqGrK6ZLEjKzRv0VFoBwGm
         uynDvFwTzSMSRnsmR0lmt7DumRicwzetLCUAPr4ZGPF2KM9N27XDlUHKVFHJhTWh2Vlg
         B6baVfhlmNOZ7D71Jt0EyX1ORGMC4qe1CAsMPd5/G7m7zw70VT+1pVQNUOCA3afXlifW
         ok9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRzXEInKytKx8eViRZxOhhZFZGHIQQcx095M8KO/MJQ=;
        b=MEc094S0Q5mZCQt4T5X7a5k9bnxpIym/04p+M0nDAxhRckAp4EupYAiQlht5F8Ei9z
         qgaKOHrqRo9MaMljubxmPhwvDab5U0+hDOsNAJCOfCT7MVwqDbID3LHMKFMobEQPD8Qb
         5DsqOXYn6caCXTq2gNkRNQBqSszDWZiLyOD/wnGrL/nyFlfKkEpc/B1rntDE1372JxZT
         cLD6Js9V5I0CSvCTWacc/1mRmjI5qmhj78Bkn/np0tK5nHrROfZ3U4NAX03UI+dJY0vx
         rR/WijiMgW+ngDGwMp5DbJ0BDwmiTHU2HagTe2cDk/vCXlx3J8LxU46x99I+0U3mMk5U
         KxmA==
X-Gm-Message-State: AOAM5311gm4E1K8l91PeH2UkwYueyg11QHt4uuIelYkBJXsnfsD6f4dy
        P2HZtCCRICLmP8d8qZFRGfzci7nIi2sEdeCBcYphRgqa
X-Google-Smtp-Source: ABdhPJyB/NtD6y25lsx6AsgrruCY8IPCwh8xeXaLa/racW2x/7j06kbdsh7Wb1/KGYZNNdeXcfRirAj18kPbLI2y4G0=
X-Received: by 2002:a05:6e02:1c06:: with SMTP id l6mr4260083ilh.239.1641779331275;
 Sun, 09 Jan 2022 17:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20220108134739.32541-1-laoar.shao@gmail.com>
In-Reply-To: <20220108134739.32541-1-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 9 Jan 2022 17:48:39 -0800
Message-ID: <CAEf4BzZe7_VDOKBiDpD3gn5XVAfkpOVUyowyTo_ziqDuhFTqyQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix possible NULL pointer dereference when
 destroy skelton
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 8, 2022 at 5:47 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> When I checked the code in skelton header file generated with my own bpf
> prog, I found there may be possible NULL pointer derefence when destroy
> skelton. Then I checked the in-tree bpf progs, finding that is a common
> issue. Let's take the generated samples/bpf/xdp_redirect_cpu.skel.h for
> example. Below is the generated code in
> xdp_redirect_cpu__create_skeleton(),
>         xdp_redirect_cpu__create_skeleton
>                 struct bpf_object_skeleton *s;
>                 s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));
>                 if (!s)
>                         goto error;
>                 ...
>         error:
>                 bpf_object__destroy_skeleton(s);
>                 return  -ENOMEM;
>
> After goto error, the NULL 's' will be deferenced in
> bpf_object__destroy_skeleton().
>
> We can simply fix this issue by just adding a NULL check in
> bpf_object__destroy_skeleton().
>
> Fixes: d66562fba ("libbpf: Add BPF object skeleton support")

We ask to use 12-character short SHA, I've fixed it up, but for future
submissions keep this in mind.

Fixed a few typos and applied to bpf-next, thanks.

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7c74342bb668..a07fbd59e4b8 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -11464,6 +11464,9 @@ void bpf_object__detach_skeleton(struct bpf_object_skeleton *s)
>
>  void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
>  {
> +       if (!s)
> +               return;
> +
>         if (s->progs)
>                 bpf_object__detach_skeleton(s);
>         if (s->obj)
> --
> 2.17.1
>
