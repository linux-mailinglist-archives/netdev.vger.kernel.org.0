Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2183D34620
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFDMES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 08:04:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35573 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfFDMES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 08:04:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id h11so19445366ljb.2;
        Tue, 04 Jun 2019 05:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3J1gXJ8WrBLFRAI1dgrNYQJUNQV1AcqpuGg+T5+KPk=;
        b=h/ZxBNfgtyojJEWdl1prRJA5WkBOT2fM+xWmUMbKNBQN9DeEkdDumnOAdSIxJoSg0B
         e5YAujz/3HUcr+KR5AEDbRYdCXb85osWwBGm7YrNT5QCxes2s0mb57IU5oUD7enutrH5
         j1UYIdBRLSQI4EZ+dOif7mnSPnjkpeMiFr2rnUnCmnRH3zNUN1t5uEQAojPHuB2oCf9F
         XhDJyalwA6BDO52C0jtR25f0B0Ns3c+j9XqFEdopj8W9wUOeomA2vcjREaVIR2p2rKE3
         hRfWyt3aOdG4UY27QFxRugFf7O6caU+pUVjFkIyAe/9wSVKLasd45qhJJuS0Ix2Iq/9v
         Hihw==
X-Gm-Message-State: APjAAAVoJYEffN3C/ypYsFgGVr2+cgqhi95Qk3Dz1EH4pF9sBlms7s3A
        uotBPHOQJEN6e0ukUyR4jUsNnJBU2Tqh+4/aEd8=
X-Google-Smtp-Source: APXvYqz5/3pzap8ZE3WMM30TBQVT+VfiRL9u2vQiwVXG2dfHIRAikYK0s02dYmEOvbTJdR7Bi3vtAJqvSmijM8vUFoo=
X-Received: by 2002:a2e:6e01:: with SMTP id j1mr16411083ljc.135.1559649856163;
 Tue, 04 Jun 2019 05:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
In-Reply-To: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 4 Jun 2019 14:04:03 +0200
Message-ID: <CAMuHMdWbcSUyYo1sJ81qojmbB_g595dVnzQycZq0Yh5BdQYCEg@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

On Tue, Jun 4, 2019 at 1:40 PM Baruch Siach <baruch@tkos.co.il> wrote:
> Merge commit 1c8c5a9d38f60 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> applications") by taking the gpl_compatible 1-bit field definition from
> commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
> following fields.
>
> Thanks to Dmitry V. Levin his analysis of this bug history.
>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Thanks for your patch!

> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3140,7 +3140,7 @@ struct bpf_prog_info {
>         __aligned_u64 map_ids;
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
> -       __u32 gpl_compatible:1;
> +       __u32 gpl_compatible;
>         __u64 netns_dev;
>         __u64 netns_ino;

Wouldn't it be better to change the types of the fields that require
8-byte alignment from __u64 to __aligned_u64, like is already used
for the map_ids fields?

Without that, some day people will need to add a new flag, and will
convert the 32-bit flag to a bitfield again to make space, reintroducing
the issue.

>         __u32 nr_jited_ksyms;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 63e0cf66f01a..fe73829b5b1c 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3140,7 +3140,7 @@ struct bpf_prog_info {
>         __aligned_u64 map_ids;
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
> -       __u32 gpl_compatible:1;
> +       __u32 gpl_compatible;
>         __u64 netns_dev;
>         __u64 netns_ino;

Same here.

>         __u32 nr_jited_ksyms;
> --
> 2.20.1
>


-- 
Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
