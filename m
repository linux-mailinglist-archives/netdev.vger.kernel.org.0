Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C27438131
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJWA5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhJWA5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:57:11 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666A9C061764;
        Fri, 22 Oct 2021 17:54:53 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id l201so10620793ybl.9;
        Fri, 22 Oct 2021 17:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0+EipaKTFDYPLsYdlQsGXiOEKd2hot77ATloljTuOo=;
        b=Xg3tBiIU2621bRNDGZRTB3U8x1Qd17n0em1Q1CXdsIer/Au5tbVLDeewmgfNE64Uua
         hd59VZolGPLG5ISY5awlDDshE5KMSTU9XdlGvuDTUy2qfZLX4n6SiMDlRIp45QH5V/5w
         DPINhiZ7901RKJTlfznl8xnswbqEb837swkC5jNxGRm8/J8FcZm59JghGGpHMaJmTSfE
         +1TbcIrl5tXZAXW8P8mVxVtujcWg7YirqhlYMZ+ejmPERVzZGo6WYaJvfh6aL/N/uDjm
         zVko50qQMH3oePfCT62QJgKODzuzGS078qNUfXRJ9NDlPd83VGzrrjg4JissjFeqZqhu
         1hXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0+EipaKTFDYPLsYdlQsGXiOEKd2hot77ATloljTuOo=;
        b=arWjNh4RkFcr4M+3gVEr3wcb5fy2S0mvoW0LIKc1FcYg7skkbysUAnBUqY10Cc2JAu
         Cio2PaNhpq8nZCTwZjinBL/iO9O5gaAeCfkZPKPZaRbdsGEN+X+adRKB4ZyLxt0MeSYa
         diJGpr3pfAT9aBPyR6H+oNJQZX2Vjo0Y9WDTpwdBp/quBjglvpzPVoHshNxJcUO3vyr7
         2zeTYl+XetTnBw6clHWej2K1wJOoNMJIHN3N4xzQiNJROmU61MJlGRIkaJCFkahmt+54
         hxVOndXYSkst63Tuip4r6M6hLX3M5eruIEI0C/VDNyTl7AlpRHJFi+i+p9Jqv1H9v4F+
         hIRA==
X-Gm-Message-State: AOAM530IzZlNwryOqABThsdQ8s8onSvIEQkSLxYWVr3FHx6f0F2egc/X
        WchcYKsJ7KvAs2G0H8yJfJ/PMkWHP/9Yv4uOaK8=
X-Google-Smtp-Source: ABdhPJwKgAHndD6XnUp/cOCe/u6IuFfduqgx+dSKPODg5G2DNEVjE+mJ2sbvlQQK7w+xhLpDO87v8J/TyTn3C/VCRp8=
X-Received: by 2002:a25:8749:: with SMTP id e9mr1748215ybn.2.1634950492468;
 Fri, 22 Oct 2021 17:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211022171647.27885-1-quentin@isovalent.com> <20211022171647.27885-4-quentin@isovalent.com>
In-Reply-To: <20211022171647.27885-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 17:54:41 -0700
Message-ID: <CAEf4BzbgGSS6p5Xyx6Sp34hLZQ8XwQN7Fg6ykPZ5VHFw6doUJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] bpftool: Switch to libbpf's hashmap for
 pinned paths of BPF objects
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:16 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> In order to show pinned paths for BPF programs, maps, or links when
> listing them with the "-f" option, bpftool creates hash maps to store
> all relevant paths under the bpffs. So far, it would rely on the
> kernel implementation (from tools/include/linux/hashtable.h).
>
> We can make bpftool rely on libbpf's implementation instead. The
> motivation is to make bpftool less dependent of kernel headers, to ease
> the path to a potential out-of-tree mirror, like libbpf has.
>
> This commit is the first step of the conversion: the hash maps for
> pinned paths for programs, maps, and links are converted to libbpf's
> hashmap.{c,h}. Other hash maps used for the PIDs of process holding
> references to BPF objects are left unchanged for now. On the build side,
> this requires adding a dependency to a second header internal to libbpf,
> and making it a dependency for the bootstrap bpftool version as well.
> The rest of the changes are a rather straightforward conversion.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile |  8 +++---
>  tools/bpf/bpftool/common.c | 50 ++++++++++++++++++++------------------
>  tools/bpf/bpftool/link.c   | 35 ++++++++++++++------------
>  tools/bpf/bpftool/main.h   | 29 +++++++++++++---------
>  tools/bpf/bpftool/map.c    | 35 ++++++++++++++------------
>  tools/bpf/bpftool/prog.c   | 35 ++++++++++++++------------
>  6 files changed, 105 insertions(+), 87 deletions(-)
>

[...]

> @@ -420,28 +421,20 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
>         if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len))
>                 goto out_close;
>
> -       obj_node = calloc(1, sizeof(*obj_node));
> -       if (!obj_node) {
> +       path = strdup(fpath);
> +       if (!path) {
>                 err = -1;
>                 goto out_close;
>         }
>
> -       obj_node->id = pinned_info.id;
> -       obj_node->path = strdup(fpath);
> -       if (!obj_node->path) {
> -               err = -1;
> -               free(obj_node);
> -               goto out_close;
> -       }
> -
> -       hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
> +       hashmap__append(build_fn_table, u32_as_hash_field(pinned_info.id), path);

handle errors? operation can fail

>  out_close:
>         close(fd);
>  out_ret:
>         return err;
>  }

[...]

>
>  unsigned int get_page_size(void)
> @@ -962,3 +956,13 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
>
>         return fd;
>  }
> +
> +size_t bpftool_hash_fn(const void *key, void *ctx)
> +{
> +       return (size_t)key;
> +}
> +
> +bool bpftool_equal_fn(const void *k1, const void *k2, void *ctx)

kind of too generic and too assuming function (hash_fn and
equal_fn)... Maybe either use static functions near each hashmap use
case, or name it to specify that it works when keys are ids?

> +{
> +       return k1 == k2;
> +}

[...]

> @@ -256,4 +247,18 @@ int do_filter_dump(struct tcmsg *ifinfo, struct nlattr **tb, const char *kind,
>
>  int print_all_levels(__maybe_unused enum libbpf_print_level level,
>                      const char *format, va_list args);
> +
> +size_t bpftool_hash_fn(const void *key, void *ctx);
> +bool bpftool_equal_fn(const void *k1, const void *k2, void *ctx);
> +
> +static inline void *u32_as_hash_field(__u32 x)

it's used for keys only, right? so u32_as_hash_key?

> +{
> +       return (void *)(uintptr_t)x;
> +}
> +
> +static inline bool hashmap__empty(struct hashmap *map)
> +{
> +       return map ? hashmap__size(map) == 0 : true;
> +}
> +
>  #endif

[...]
