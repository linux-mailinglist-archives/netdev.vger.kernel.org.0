Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11491F257F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfKGCl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:41:27 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:35418 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGCl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:41:27 -0500
Received: by mail-qv1-f68.google.com with SMTP id y18so241975qve.2;
        Wed, 06 Nov 2019 18:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzllj5xxAbVfN1xifoht5573apNvV4Nxhrb2VrioqKY=;
        b=D5uszVoxygitXeg82NxXE2skLgjqAuPDe8xkdzDu7e7TEXNZS9dRIdMRbQQHXpj5j3
         AIZXg+cdt68qCBLAQgx1P+IavLEHBoi97FzNeNm4ebGxLTGFYoEhMzlxFkKJAL0aTlxH
         2TdTA151JLPBgA1ig/pV/WXptRpd4d1GJInyAYyJLZGyYKEwn9eyLEqyB3AnMITSjcIX
         SffxvHzacrVqD1dV2kCDupK5TvCNtZG2rg3TskGgK9fcQ/UXS5lj7K+MrvreRfP+R6KK
         HvGzEr1KA0ZfDngNbQYQmVsjMp7+P4Bd4Xx69Hohv3Xrf6Clu80lNfMiUkdMGzK/ZXpL
         NUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzllj5xxAbVfN1xifoht5573apNvV4Nxhrb2VrioqKY=;
        b=hS7dDNEn/4/hwBy7/6FUjNeIFQ4bmIVNeKMGVTrmvv3n8rmvwFnfqQbzOPOZ/WrK/6
         NE3Kdd4R5NpUUhPrs+xDPDYvLEBuDlTXXbuoLeWfnFCmy9kDs8OsNA3gb02GoVNn4WLa
         6VqB1KkoRwn28SPJA3asZ2GUmM+EUjhHMw6ZQNrzvdWpwiv0UNeMVvjZPm66l2bsVdur
         by3ePj3r1xB6aJHw8suc753q+4w8L60/hiM8HUfHpoDitAJfe0goaRXQMCvdVW4DHfSs
         oshR6HmbC54Weo65ATJr3jsoO/m7vYs9mmjEv3hoB7awlo8vz/Tj86WHTVLo1893SS85
         Ht1Q==
X-Gm-Message-State: APjAAAW77nsd9pqnBHzwaa5pzX/EhwMFQlTB3uUsqKd8BgyhRRqTMq1Y
        OWCFawF0XJpvbIizRcVBhnzhy1KldsuR8TbT5h0=
X-Google-Smtp-Source: APXvYqylkTCgz33UPU8CyfepZLuREVN9fopjbYKH1Kie5rkGIA1Pt+S5zYRdcshCpSN0vsDH6BPyoyDrHlMIx4UdG7U=
X-Received: by 2002:ad4:4e4a:: with SMTP id eb10mr1195269qvb.228.1573094486512;
 Wed, 06 Nov 2019 18:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20191107014639.384014-1-kafai@fb.com> <20191107014643.384298-1-kafai@fb.com>
In-Reply-To: <20191107014643.384298-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Nov 2019 18:41:15 -0800
Message-ID: <CAEf4BzaQOEjbJwV9Ycb1QdBVkFRQLB_3cyw1sfXTz-iV_pt4Yw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: Add array support to btf_struct_access
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 5:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds array support to btf_struct_access().
> It supports array of int, array of struct and multidimensional
> array.
>
> It also allows using u8[] as a scratch space.  For example,
> it allows access the "char cb[48]" with size larger than
> the array's element "char".  Another potential use case is
> "u64 icsk_ca_priv[]" in the tcp congestion control.
>
> btf_resolve_size() is added to resolve the size of any type.
> It will follow the modifier if there is any.  Please
> see the function comment for details.
>
> This patch also adds the "off < moff" check at the beginning
> of the for loop.  It is to reject cases when "off" is pointing
> to a "hole" in a struct.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Looks good, just two small nits.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 187 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 157 insertions(+), 30 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 128d89601d73..5c4b6aa7b9f0 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -1036,6 +1036,82 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
>         return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
>  }
>

[...]

> -               if (off + size <= moff / 8)
> -                       /* won't find anything, field is already too far */
> +               /* offset of the field in bytes */
> +               moff = btf_member_bit_offset(t, member) / 8;
> +               if (off + size <= moff)

you dropped useful comment :(

>                         break;
> +               /* In case of "off" is pointing to holes of a struct */
> +               if (off < moff)
> +                       continue;
>

[...]

> +
> +               mtrue_end = moff + msize;

nit: there is no other _end, so might be just mend (in line with moff)

> +               if (off >= mtrue_end)
>                         /* no overlap with member, keep iterating */
>                         continue;
> +

[...]
