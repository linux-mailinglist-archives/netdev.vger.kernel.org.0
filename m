Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3515B43AB82
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 06:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhJZFBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 01:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhJZFBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 01:01:54 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1233EC061745;
        Mon, 25 Oct 2021 21:59:31 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id a6so20744659ybq.9;
        Mon, 25 Oct 2021 21:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W2eo2WOjW2D0GJkhtMCC8VoRAOYDsHWkgjk0JHaSu64=;
        b=GKP2pCbiitzJEBCjJhqMVjO3n4gwAIKGBlMGfVifxNBx91Pt6V7ECERBjL9HWbWLTp
         UsegDt7V3lx0mB0+uj1oZHYDzSbnTbrUVqq6nBSQl6IOWD1TGA7sebGDy90rWLq9LZQH
         vBllxeMjztA3iHsfpCU3+W8Itt4fnfO0Jn0+pEGb4cNVaGnGcF1NP83Zgpk6sTQRCSv8
         E5E8feM6Sfymmml03Y+3OYD1sIK1g5zltcj045nTERuqiXFzn/dNKQqP/TInM7fmF5T7
         dAMyYo5KekjWhiUApOklBmFFOoeC9nYya6g6/NFA0F5WWdQ190x/fB2Vp5Wdb4EIQ2ab
         iTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W2eo2WOjW2D0GJkhtMCC8VoRAOYDsHWkgjk0JHaSu64=;
        b=0ch7ThHEAZlS1XAevcIPEtcBx3jaS0KvOV/GsJNiaAMR4dUh9ef2enYxt+KpgvajdP
         D0BXRp55VBDz2zbvTEw6WbtJEVCWV7vAzTtM4AGEoUEdn92YR6UF+T00qWGWk+S++dp1
         5tS/eE0pZQx/S7nHPhH7nlphuzLnVxUxNt1CWku/sV9TCym/r1JqBXA1RZ5PkgJS9vM9
         PXbz16TmKg9t+Ggm/6wExobLAjIdvZFhq7r9/Q4JtkkvNiBgbg7IcPvSHtokjGNR06dU
         6O+reVxU/5tZV85xckEVV6r+a1Le7uAVRPaeQncgC4Z189c9JfAYXIr/m+sbknjta5U4
         5YJQ==
X-Gm-Message-State: AOAM530fgFNuN76SfX0eJpeHEa636r1Ox4KWK+av66KujzXDjUVCC0nn
        ooyiYFaqX2vn0Y+7+JlOwMOO8Kk4W6lWJrqOnWE=
X-Google-Smtp-Source: ABdhPJz7wama3mBE8Jei4cff7RjgiCogWiggtFyU8m/VMHGVhBFINFTqVqWy4gT31OtpIVTvgaeS8IR7yvgbX358gvk=
X-Received: by 2002:a25:cf50:: with SMTP id f77mr8457113ybg.114.1635224370369;
 Mon, 25 Oct 2021 21:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org> <20211023120452.212885-3-jolsa@kernel.org>
In-Reply-To: <20211023120452.212885-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Oct 2021 21:59:19 -0700
Message-ID: <CAEf4BzY70kx8VhK5R-ianrQMZJPPynGV_3+Xc2-9Q5JRE3QKUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add support to detect and dedup
 instances of same structs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The s390x compiler generates multiple definitions of the same struct
> and dedup algorithm does not seem to handle this at the moment.
>
> I found code in dedup that seems to handle such situation for arrays,
> and added btf_dedup_is_equiv call for structs.
>
> With this change I can no longer see vmlinux's structs in kernel
> module BTF data, but I have no idea if that breaks anything else.
>

I'm pretty sure this is not the right way to handle this. Let's figure
out what is causing a difference in types (i.e., why they are not
equivalent), before attempting to patch up BTF dedup algorithm.

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/btf.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3a01c4b7f36a..ec164d0cee30 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -3920,8 +3920,16 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
>                  * types within a single CU. So work around that by explicitly
>                  * allowing identical array types here.
>                  */
> -               return hypot_type_id == cand_id ||
> -                      btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
> +               struct btf_type *t;
> +
> +               if (hypot_type_id == cand_id)
> +                       return 1;
> +               t = btf_type_by_id(d->btf, hypot_type_id);
> +               if (btf_is_array(t))
> +                       return btf_dedup_identical_arrays(d, hypot_type_id, cand_id);
> +               if (btf_is_struct(t))
> +                       return btf_dedup_is_equiv(d, hypot_type_id, cand_id);
> +               return 0;
>         }
>
>         if (btf_dedup_hypot_map_add(d, canon_id, cand_id))
> --
> 2.31.1
>
