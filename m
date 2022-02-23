Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939D84C1F6F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbiBWXQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiBWXQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:16:09 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2351357150;
        Wed, 23 Feb 2022 15:15:41 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id w7so728785ioj.5;
        Wed, 23 Feb 2022 15:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P25Zfn5c3BtqYaoA6/wRj29feqJY0Zz0Nev1IhUk9Dc=;
        b=HfHAa2uKg47YCKjW0CQBrlojE22jxt/8JNZubtz/35jfAp6QaO8wnHBFEPeo2fSHkK
         SlW5+ZEyXEaPUU8AlTeR+Eaixz0FpST78wWFjKrpAKpQ9O+dAFJFZ9RzEtHzFygvvCJ+
         Ypwhe6dTmaxzM8AXonk9ymSZPpsyYGxoLUMTJd68Yq5ahc5pSE4No3w0ybWVdkDpZ46r
         G4Rubvbu3Z9xV+KKf58+xb8TeYWX/97dGaGioNDNPx92V7kCUeBFObmLNJeRTQsaMNUK
         25JhzDK+vd5H7pthS2OpoR/ffvFhd4p3UthPI131UoaRCQ9esrbZOUYHrkoJNG2024rk
         eS1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P25Zfn5c3BtqYaoA6/wRj29feqJY0Zz0Nev1IhUk9Dc=;
        b=0r0zHnATpRnEAJre4YWhRGz3getxQq+71bFd8emRhnGnBHferDdgzOrDQWFT88o8bC
         +fmgyWiOI0DdTkWRBL/rVg95iopHBbSaHbsoKjIQBIAbyff6x33m5Du/LEusNP9VDcTh
         RgZoj4yPvYSHqFySW7faS2WmzhZavEApjqPjNrrvNJYYa9XEuspUZhQH+VvVVHPxfVaZ
         Newwq510RnTuY4IZ2PGQANPa34LjKETkxO8xI4QXgLPcGNa4c9G9UjNoNOgONtsWq2J/
         X7eo+wpebBOUFc5cIeaXADr5W1jyamMcBt0T22HJPfnuZSpd3WjivLkGkeSuZmqdOmaR
         exnw==
X-Gm-Message-State: AOAM5327tVoGUrquZNT+Er/7OUgVzQlkuJ0Ok9a8w5MGtLG9pMCJnDtj
        R31wESD69wCZehdcn4KVDt5899RTNs6YzpnXTR0=
X-Google-Smtp-Source: ABdhPJyH0mfb4p1AXEHyZ7nFOjHrPR/3RLDwloDCPaFaTjCrBVgRJexaQLr2VbGg+iObXNrg/nG3gbCUia8PAMp8V7w=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr8474iov.144.1645658140535; Wed, 23 Feb
 2022 15:15:40 -0800 (PST)
MIME-Version: 1.0
References: <20220222204236.2192513-1-stijn@linux-ipv6.be> <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
In-Reply-To: <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Feb 2022 15:15:29 -0800
Message-ID: <CAEf4BzYuk2Rur-pae7gbuXSb=ayJ0fUREStdWyorWgd_q1D9zQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
To:     Song Liu <song@kernel.org>
Cc:     Stijn Tintel <stijn@linux-ipv6.be>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 6:37 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Feb 22, 2022 at 12:51 PM Stijn Tintel <stijn@linux-ipv6.be> wrote:
> >
> > When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
> > max_entries parameter set, this parameter will be set to the number of
> > possible CPUs. Due to this, the map_is_reuse_compat function will return
> > false, causing the following error when trying to reuse the map:
> >
> > libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
> >
> > Fix this by checking against the number of possible CPUs if the
> > max_entries parameter is not set in the map definition.
> >
> > Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
> > Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> I think the following fix would be more future proof, but the patch
> as-is is better for
> stable backport? How about we add a follow up patch on top of current
> patch to fix
> def->max_entries once for all?

Keeping special logic for PERF_EVENT_ARRAY in one place is
preferrable. With this, the changes in map_is_reuse_compat() shouldn't
be necessary at all. Stijn, can you please send v2 with Song's
proposed changes?

>
> Thanks,
> Song
>
> diff --git i/tools/lib/bpf/libbpf.c w/tools/lib/bpf/libbpf.c
> index ad43b6ce825e..a1bc1c80bc69 100644
> --- i/tools/lib/bpf/libbpf.c
> +++ w/tools/lib/bpf/libbpf.c
> @@ -4881,10 +4881,9 @@ static int bpf_object__create_map(struct
> bpf_object *obj, struct bpf_map *map, b
>                         return nr_cpus;
>                 }
>                 pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
> -               max_entries = nr_cpus;
> -       } else {
> -               max_entries = def->max_entries;
> +               def->max_entries = nr_cpus;
>         }
> +       max_entries = def->max_entries;
>
>         if (bpf_map__is_struct_ops(map))
>                 create_attr.btf_vmlinux_value_type_id =
> map->btf_vmlinux_value_type_id;
