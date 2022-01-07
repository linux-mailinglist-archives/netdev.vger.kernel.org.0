Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D97487E18
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiAGVRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiAGVRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:17:51 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C36C061574;
        Fri,  7 Jan 2022 13:17:51 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q5so8700257ioj.7;
        Fri, 07 Jan 2022 13:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/tSm3F0mr1eWZ5R2UpnKSIhESVsNU+pdkgxHUepnRaM=;
        b=m2tp/DvfEEL+wUW4vNrArSeCGdUYMgJGV5e3/9aU+BeSAvVKEEKQGq501dfJF0c5Da
         0Wh8RAtXSzRAwUyE3iM/mupgDicXfbftVS6IQhKVpML8SMF63Lps/sxv+SA5iO7SdCYQ
         kJsbDtQag+VQlaH2ukMsm3PAFoe3rVCQm1km/r016TPpWj+cfbCwOlcF9OJrIWVWGSWr
         HWHbUrEDxxqJuG/xUnLH29p5y4OLaLF4DpG904h1M/8Vrqp4m3DJO3LoXpGZX28ic2jN
         fjO57bzMxCvDkWf0Kdw/tdt6lRSTuwgDHFnSyKdWfn1YxS18Qdsb1bPjwrDtkzmuby3d
         jEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/tSm3F0mr1eWZ5R2UpnKSIhESVsNU+pdkgxHUepnRaM=;
        b=YSvYj3iNKB5G6BnA3o9857W1KZG2UlzyAMwrVYP38Z2K7e/LQ5AcSXeRSVe2mSmwlO
         Sdl2dCuoe/Oydgj1exyhQcFcIj6mWETTo1MRXjkNJcoUzAU8ep+HGWCKym6AkiN0Nnp3
         hlWP6bbH6K144fRHI5hqLGJUGG1ea2WCGHYhrBRZjx/E5xp8Dgns5XTkTf6WyGpLU+DO
         35KV1S+7JP8Zhk6rJFvY3J4Fq3RHdbAEHcR/MupOfUL1+9vE907uiPcgtcMl7ot1MYTh
         nYu3I1W4Ko3vkEZqgJFOqwEdu8v4JSCoVqotNM8lkV3LoKnmG/h2tMhx2F4/nscW7TA4
         jawQ==
X-Gm-Message-State: AOAM531MkVkoN0tk+fx6fjZnhwcZo/O2kLiGrQ27vg6s7gOgSA5nE/ay
        ujoo58EOBTlZsN50B49UpKgoX9/39+YZMB5ApTY=
X-Google-Smtp-Source: ABdhPJzVxmwaPiwyDYwVZIotVb7p0zTACSZ8duAKscw/3cP3iUqdUMlyRuihH9pBxfiFotKbEJRBzeajp1N+4919J6Q=
X-Received: by 2002:a02:c6a5:: with SMTP id o5mr32228893jan.145.1641590270852;
 Fri, 07 Jan 2022 13:17:50 -0800 (PST)
MIME-Version: 1.0
References: <20220107183049.311134-1-toke@redhat.com>
In-Reply-To: <20220107183049.311134-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Jan 2022 13:17:39 -0800
Message-ID: <CAEf4BzbRxwbJQFZHvB-hBj1A+364Jua4KJgkL+D_9PKsj7jKSg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] xdp: check prog type before updating BPF link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The bpf_xdp_link_update() function didn't check the program type before
> updating the program, which made it possible to install any program type =
as
> an XDP program, which is obviously not good. Syzbot managed to trigger th=
is
> by swapping in an LWT program on the XDP hook which would crash in a help=
er
> call.
>
> Fix this by adding a check and bailing out if the types don't match.
>
> Fixes: 026a4c28e1db ("bpf, xdp: Implement LINK_UPDATE for BPF XDP link")
> Reported-by: syzbot+983941aa85af6ded1fd9@syzkaller.appspotmail.com
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

The fix looks good to me, thanks. I'd love it if this was done
generically in link_update, but each link type has its own locking
schema for link->prog, so I didn't figure out a way to do this in a
centralized way.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  net/core/dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c4708e2487fb..2078d04c6482 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9656,6 +9656,12 @@ static int bpf_xdp_link_update(struct bpf_link *li=
nk, struct bpf_prog *new_prog,
>                 goto out_unlock;
>         }
>         old_prog =3D link->prog;
> +       if (old_prog->type !=3D new_prog->type ||
> +           old_prog->expected_attach_type !=3D new_prog->expected_attach=
_type) {
> +               err =3D -EINVAL;
> +               goto out_unlock;
> +       }
> +
>         if (old_prog =3D=3D new_prog) {
>                 /* no-op, don't disturb drivers */
>                 bpf_prog_put(new_prog);
> --
> 2.34.1
>
