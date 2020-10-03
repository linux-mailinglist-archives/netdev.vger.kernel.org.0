Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BE281FD8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJCAfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 20:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJCAfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 20:35:51 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C55C0613D0;
        Fri,  2 Oct 2020 17:35:51 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a2so2416393ybj.2;
        Fri, 02 Oct 2020 17:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AEtzmVCYtkICiHqIu4rwnoC+JzWDpAlEdiR3iqsZ+1o=;
        b=Bbjifo9OhPjw8kPh+0ZLbbzSjq8nuni5mt1HzHFFfxVZQyyN0lF6lVgSmc3Zng6iEY
         dB9keS1yu9JUsR3amReLs6qypRp9iQ+q6dm5SfAwcs/h5N2vpaUiZ6cvnxs8PnAv9sXP
         taHN7CKDBkA7My9HsK7qVsMqzH68oF2PPnhirQrgCJBc0gmbQVMwQNm3PBSpWVuMM+sc
         aShDDDJZDxrKNpgAOrQjD7RceBOYan7K0omPwjQ2Hgd7mG9tHcWUdVDOjbmKZ7NeiCGF
         PXhLwaj6/metWbyPvrOCePa1AaAEXYmQvhnAKWAbhQu11QsZqf2O0v/sLBT1BlWmv9T0
         BTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AEtzmVCYtkICiHqIu4rwnoC+JzWDpAlEdiR3iqsZ+1o=;
        b=L2oDJdqXJ30kTy3Fqm4Mnm31gBnpBQPtrHBQsRBuBl/3uqX1oXsw/mMQfQTwcWL37d
         HjaD0ik+cKucTfGLIO2Uz9s5FVT08pGKs3krK9oHbBesjKcn060eSYRnGSC4GhZVKl62
         SHdzNdAq7tnig0MMwBI/7kh0hR+DAOqs4C9VrBENvXxMzfmYia3x+G8DxzC5d1j2ZOZx
         nUjKKZagUf9DxhXSgGTQkcpjNYgXZcL0qdLEFG5zg78DID57VYi+y7Bu4A/5pQUsKEiy
         hpg+ynFRbYr2QlEuU6PiSIIZHrkkWPvVjptNFf0TDBototHw4jkpdRmyaG+SbCcBly/v
         TS0g==
X-Gm-Message-State: AOAM530m2C0YSBx4GHAVOt4iTB4k4WLy7fNaa9a/wERZy3lKq5CiYyvh
        gfMui7CYn+1B4ya3slmCdWBOQfxSUwGBM8pwVPU=
X-Google-Smtp-Source: ABdhPJxpTy8lFkCaPXl/s6woIa9ddQUnHQWrCIQ6a9YzAt5wkKmz0A5qGlG/x1bN8LmSct+OsEKXY7CCBgHKM76Ce5s=
X-Received: by 2002:a25:2687:: with SMTP id m129mr6176801ybm.425.1601685350185;
 Fri, 02 Oct 2020 17:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201003002544.3601440-1-sdf@google.com>
In-Reply-To: <20201003002544.3601440-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 2 Oct 2020 17:35:38 -0700
Message-ID: <CAEf4BzavuVpHFJ4q0U6ot1Uf9Pg88ukDc_CNruzHbCNXU0mP0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: deref map in BPF_PROG_BIND_MAP when it's
 already used
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 5:26 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> We are missing a deref for the case when we are doing BPF_PROG_BIND_MAP
> on a map that's being already held by the program.
> There is 'if (ret) bpf_map_put(map)' below which doesn't trigger
> because we don't consider this an error.
> Let's add missing bpf_map_put() for this specific condition.
>
> Fixes: ef15314aa5de ("bpf: Add BPF_PROG_BIND_MAP syscall")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index f1528c2a6927..1110ecd7d1f3 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4323,8 +4323,10 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
>         used_maps_old = prog->aux->used_maps;
>
>         for (i = 0; i < prog->aux->used_map_cnt; i++)
> -               if (used_maps_old[i] == map)
> +               if (used_maps_old[i] == map) {
> +                       bpf_map_put(map);
>                         goto out_unlock;
> +               }
>
>         used_maps_new = kmalloc_array(prog->aux->used_map_cnt + 1,
>                                       sizeof(used_maps_new[0]),
> --
> 2.28.0.806.g8561365e88-goog
>
