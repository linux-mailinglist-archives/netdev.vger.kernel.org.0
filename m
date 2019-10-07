Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E033CEFB2
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 01:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfJGXmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 19:42:13 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46259 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbfJGXmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 19:42:13 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so14496911qkd.13;
        Mon, 07 Oct 2019 16:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gPbndkUp+VpEuDvaOx3NjaF7XhZ9kzYhvl1uUbDKnFg=;
        b=UFjbQaxMjYjuxhh75EygCiuMG1KHr2/yKHN/oAh56N06VUfQNgGA4q7/eISs7lWB0c
         v/1FZYmpqFXF79wCZGtv3iKEVrcj0Uan1AltYqaCGzb0KY97lOgLe3cJS95UvEaZ+aoS
         A4XM0sCcf0ipAYHGFRAwbWDpLtnVbX/Uqke4FZifGa+R6GPLbBqH4RCpTqUBE7FRkEK9
         9JhGdxZH223C7/HXlI1g6xtJ6Li0RwNP7rc1ab1+CK3y9JYmFOGCtslw2sRdq4hssMYV
         ffkadZpd4ap+T0rNyqbn1jozwnPJtI99REcU38V8zZeah/25ME50N0GF4XpC59YiamuY
         N44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPbndkUp+VpEuDvaOx3NjaF7XhZ9kzYhvl1uUbDKnFg=;
        b=HYqeIOp5DUhWS9o2jLEXd9JOCwOb9WGZ5kS929BLtWZnC73JZ6fRP7LsUGY4BX6pKB
         gDT50VXuRlOsut1aXUkKbTtUzP4z6dlOpnseoO5ChHWoNNqt93E/5AtfIdsAFGWq8Se0
         jeXB6532xvO8dKv80t223KitRrTM4uZrjQYjnIlOoHu96BnMpPspgq3GBUH1750IRjG1
         n90zR2LLbvCLMCaSU32YvEj0ZkuGspzMsCNzW+gCUbKvOJIceSW1bs49GohleuYhT84N
         iQXH/VotLCH/KIXfxRv8yqcwin5jokpkFu2QFbBacjOrJoDWwwxh4sbcuRSU+OpbIlOz
         IULw==
X-Gm-Message-State: APjAAAUWxk4M09HFH1NSzqnMLhatYPLL9nRulVlUe8jgJnrnNcWDhHFe
        lKxSc8XB4tSyVOXHABKzkz+yd3QhniSc6FBgl+s=
X-Google-Smtp-Source: APXvYqxM3n2Ood9D+ySjKrrPHvtWkzqJpw3ZliYVAD6Yr9y5jJUP3bc+HGSrTYeOw80vPRdel3p9HTKvTwj4xac059E=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr26044257qkk.39.1570491731089;
 Mon, 07 Oct 2019 16:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-5-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 16:41:59 -0700
Message-ID: <CAEf4BzZxHyBoX9stW7uapZ06xd26N_zZcghytkQAUM1ss5sN6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/10] libbpf: auto-detect btf_id of raw_tracepoint
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> For raw tracepoint program types libbpf will try to find
> btf_id of raw tracepoint in vmlinux's BTF.
> It's a responsiblity of bpf program author to annotate the program
> with SEC("raw_tracepoint/name") where "name" is a valid raw tracepoint.

As an aside, I've been thinking about allowing to specify "raw_tp/"
and "tp/" in section name as an "alias" for "raw_tracepoint/" and
"tracepoint/", respectively. Any objections?

> If "name" is indeed a valid raw tracepoint then in-kernel BTF
> will have "btf_trace_##name" typedef that points to function
> prototype of that raw tracepoint. BTF description captures
> exact argument the kernel C code is passing into raw tracepoint.
> The kernel verifier will check the types while loading bpf program.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..0e6f7b41c521 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4591,6 +4591,22 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>                         continue;
>                 *prog_type = section_names[i].prog_type;
>                 *expected_attach_type = section_names[i].expected_attach_type;
> +               if (*prog_type == BPF_PROG_TYPE_RAW_TRACEPOINT) {
> +                       struct btf *btf = bpf_core_find_kernel_btf();
> +                       char raw_tp_btf_name[128] = "btf_trace_";
> +                       int ret;
> +
> +                       if (IS_ERR(btf))
> +                               /* lack of kernel BTF is not a failure */
> +                               return 0;
> +                       /* append "btf_trace_" prefix per kernel convention */
> +                       strcpy(raw_tp_btf_name + sizeof("btf_trace_") - 1,
> +                              name + section_names[i].len);

buffer overflow here? use strncat() instead?

> +                       ret = btf__find_by_name(btf, raw_tp_btf_name);
> +                       if (ret > 0)
> +                               *expected_attach_type = ret;
> +                       btf__free(btf);
> +               }
>                 return 0;
>         }
>         pr_warning("failed to guess program type based on ELF section name '%s'\n", name);
> --
> 2.20.0
>
