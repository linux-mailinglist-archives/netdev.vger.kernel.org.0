Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F9F2B754E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 05:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgKRELD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 23:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgKRELC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 23:11:02 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E34C0613D4;
        Tue, 17 Nov 2020 20:11:01 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id f11so1009347lfs.3;
        Tue, 17 Nov 2020 20:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QiZ+hPWcgRrSJYrRI/DcwNjpknvcfyeQfNBRbOUcAZo=;
        b=kCdq/mUuaZJ6pc88zsrgz7uqcd0wPOwknm5DTCqlhoCmvs/754Xfkj1NmHP7Q79d/F
         +IvidmjpocDik3B8lo3Kg16Y2caHKLwyiUr6G4dkS6GcTbRJ6/myby64lpQNSyxer+T/
         MuyE2e+Pt1GeN7ZpPh4CCSPW8jO5DKGt66IqFP0XCfXP8/eORwv/ock173v6lxAB2H8b
         UfwzrHn9LR0VevS5E4IzV/vf8KyMoL1otvHuTu7LG9PLYaKx0fvJ8ajw/tecwW7Z2dg4
         v8sf96RAFzagHJZlzw+QZz2rRE95V0wyEfzICI6SpJ7FCtW/D0NVsW55RV2iKma7YMpv
         JPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QiZ+hPWcgRrSJYrRI/DcwNjpknvcfyeQfNBRbOUcAZo=;
        b=oXPDUzeI4TLgzvj5j7bjzuIMdrjAvtIwKgJeFH2PzXK8T2vGeevOllNitBS/w5XxLv
         D7N/SWyTniXIZY6LnpqbY9yBkGHW3JLJycHwR65hS9ZFUOoEQq2MJNKMuZe5tf5Htdy4
         VHMwk+acWU3eqWJoPQ82sU/JJLyi0syhQSuF47WlHZkWowGiXcHBQgI1Noy99Jhdm+XM
         mWCIsfFRZkHt0FpXtS2//xDJUCG5BAyiqAMR72tnYCvTWw1vaLZULzKj5hrXzKYCojB4
         w3WxeyVgZA0LEnqXvDV9xpSp10w+RLII6PuX1DxkKhAeNHZoG+5eQqi+Z6u8p4pfrCD/
         eBnw==
X-Gm-Message-State: AOAM530XJus0py8VMXUrpHBTslUg5ygh2jCQ2eiqcvZApdFdGCf9QhNp
        qG8/0fcscSv70uC+tgHPPjpuBj/SvM32VXVbfBwmdT3H5Ew=
X-Google-Smtp-Source: ABdhPJyW1BjaZImKMrTr6fljnV6J3SiCCfled+e4ZYa2bF2lU5eUh+EjQDFQFYiYjSQGKKB9MnnnpGkOCQnMcPkFe0o=
X-Received: by 2002:ac2:544d:: with SMTP id d13mr2792930lfn.500.1605672659630;
 Tue, 17 Nov 2020 20:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20201110084758.115617-1-yinxin_1989@aliyun.com>
In-Reply-To: <20201110084758.115617-1-yinxin_1989@aliyun.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Nov 2020 20:10:48 -0800
Message-ID: <CAADnVQK-XuFi0yZuWa+upEeFypKYNr7XHc-8JhGtfYzFPLni9g@mail.gmail.com>
Subject: Re: [PATCH] bpf:Fix update dirty data in lru percpu hash maps
To:     Xin Yin <yinxin_1989@aliyun.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 1:04 AM Xin Yin <yinxin_1989@aliyun.com> wrote:
>
> For lru_percpu_map update elem, prealloc_lru_pop() may return
> an unclear elem, if the func called by bpf prog and "onallcpus"
> set to false, it may update an elem whith dirty data.
>
> Clear percpu value of the elem, before use it.
>
> Signed-off-by: Xin Yin <yinxin_1989@aliyun.com>

The alternative fix commit d3bec0138bfb ("bpf: Zero-fill re-used
per-cpu map element")
was already merged.
Please double check that it fixes your test.

> ---
>  kernel/bpf/hashtab.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 728ffec52cf3..b1f781ec20b6 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -709,6 +709,16 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
>         }
>  }
>
> +static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr)
> +{
> +       u32 size = round_up(htab->map.value_size, 8);
> +       int cpu;
> +
> +       for_each_possible_cpu(cpu) {
> +               memset(per_cpu_ptr(pptr, cpu), 0, size);
> +       }
> +}
> +
>  static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
>  {
>         return htab->map.map_type == BPF_MAP_TYPE_HASH_OF_MAPS &&
> @@ -1075,6 +1085,9 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
>                 pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
>                                 value, onallcpus);
>         } else {
> +               if (!onallcpus)
> +                       pcpu_init_value(htab,
> +                                       htab_elem_get_ptr(l_new, key_size));
>                 pcpu_copy_value(htab, htab_elem_get_ptr(l_new, key_size),
>                                 value, onallcpus);
>                 hlist_nulls_add_head_rcu(&l_new->hash_node, head);
> --
> 2.19.5
>
