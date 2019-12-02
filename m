Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB610EE6E
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfLBRf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:35:56 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34050 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbfLBRf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 12:35:56 -0500
Received: by mail-qv1-f66.google.com with SMTP id o18so167713qvf.1;
        Mon, 02 Dec 2019 09:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXLHysx7ObLZy3lrIBxHgYNwKa/KwOmxigB8Ez1BJBE=;
        b=WqNDXMtQpn/vAjAK/ibNmIcW9m61Sk5AI+r0+COqtDdzaM4BGRC9Y2IJfahOio9w4z
         vehwZzgCk+FTxioWr659Pz8UBWw4BX2YMGPx32gcTbk4uL3sih0Q/w/XiZM1q5CT/PLP
         KX/sj3sOEjYB9Xjeb/h4KX5NQ2Q5Uap3UwMx+kfggGVaMmaqOMOxivWbPIiehYGtbIde
         tmRApwgmtFnS6EcuTQEQVUxyTD7X5qMzjwCChvrbbjy4jWgP9gMPRFADuofyaFdluzl6
         i8YKtOFTpTisquk3mglA2GOfPOJnJxEYYNqc108u/6VpcoaKs1vduOvThMP1xqTwG9L2
         IyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXLHysx7ObLZy3lrIBxHgYNwKa/KwOmxigB8Ez1BJBE=;
        b=fK+422VDWfvL48w/7Gs1tdHxAzk6pjZ//kGfWSRxzT8CW2O4CV7BB1sIZx17k9PWqh
         xjHduQMwSuOggY8U6Pd0aRmRm6IMaOLy4cXMfETo/70L6iJjbEAFsSaufQAohwjui57t
         BVkFmI+3fK8w5BEkbn9M5eQg/85Cd9GfgTWuLoszNvNwEpwJ43jzqES+FcoBlb9g3+Dp
         j47dL05U6cSHN5/i7ZfVwYf1xHt7XSMUPSkjQfjK10L+X8RFxkDUdxS75NdpyYbl08so
         i1m6Y9ADY/uSDmDQa7RJt+QIFODu+596JA8iKaiOMDRVJkGzmhFhtNVRcjSQ5PO8NuQA
         sy+w==
X-Gm-Message-State: APjAAAURhiFx7r945RsASzJbySFtJ5/JAaY7wEV16EMmHqDkRgsn3uQn
        QKrczMMdXtRPy2pkuYMKNEumREFRd9t52mpTqJU=
X-Google-Smtp-Source: APXvYqyTLP/78mH1aRDHrJILi7yw4ItOOK9BTvHcoBY1C4vyJ+oGj8C8yH8EQKeZR7MmxVk/X/EdqyHtF9347d4OfUs=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr48373qvb.163.1575308155262;
 Mon, 02 Dec 2019 09:35:55 -0800 (PST)
MIME-Version: 1.0
References: <157529025128.29832.5953245340679936909.stgit@firesoul>
In-Reply-To: <157529025128.29832.5953245340679936909.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 09:35:44 -0800
Message-ID: <CAEf4BzZ_-wMfYxfSi-XBzKDp8bww7_YUDpA0j144HJJYeo+EFQ@mail.gmail.com>
Subject: Re: [bpf PATCH] samples/bpf: fix broken xdp_rxq_info due to map order assumptions
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 4:37 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> In the days of using bpf_load.c the order in which the 'maps' sections
> were defines in BPF side (*_kern.c) file, were used by userspace side
> to identify the map via using the map order as an index. In effect the
> order-index is created based on the order the maps sections are stored
> in the ELF-object file, by the LLVM compiler.
>
> This have also carried over in libbpf via API bpf_map__next(NULL, obj)
> to extract maps in the order libbpf parsed the ELF-object file.
>
> When BTF based maps were introduced a new section type ".maps" were
> created. I found that the LLVM compiler doesn't create the ".maps"
> sections in the order they are defined in the C-file. The order in the
> ELF file is based on the order the map pointer is referenced in the code.
>
> This combination of changes lead to xdp_rxq_info mixing up the map
> file-descriptors in userspace, resulting in very broken behaviour, but
> without warning the user.
>
> This patch fix issue by instead using bpf_object__find_map_by_name()
> to find maps via their names. (Note, this is the ELF name, which can
> be longer than the name the kernel retains).
>
> Fixes: be5bca44aa6b ("samples: bpf: convert some XDP samples from bpf_load to libbpf")
> Fixes: 451d1dc886b5 ("samples: bpf: update map definition to new syntax BTF-defined map")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
> index 51e0d810e070..8fc3ad01de72 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -489,9 +489,9 @@ int main(int argc, char **argv)
>         if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
>                 return EXIT_FAIL;
>
> -       map = bpf_map__next(NULL, obj);
> -       stats_global_map = bpf_map__next(map, obj);
> -       rx_queue_index_map = bpf_map__next(stats_global_map, obj);
> +       map =  bpf_object__find_map_by_name(obj, "config_map");
> +       stats_global_map = bpf_object__find_map_by_name(obj, "stats_global_map");
> +       rx_queue_index_map = bpf_object__find_map_by_name(obj, "rx_queue_index_map");

Yeah, relying on relative order of maps as instantiated by libbpf
internally is extremely fragile. Thanks for fixing this.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>         if (!map || !stats_global_map || !rx_queue_index_map) {
>                 printf("finding a map in obj file failed\n");
>                 return EXIT_FAIL;
>
