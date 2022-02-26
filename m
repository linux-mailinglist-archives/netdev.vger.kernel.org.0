Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B384C541D
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiBZGMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiBZGMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB45C2BAF3B;
        Fri, 25 Feb 2022 22:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81A6E60B72;
        Sat, 26 Feb 2022 06:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63F8C340F2;
        Sat, 26 Feb 2022 06:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645855906;
        bh=r5rev/UqgjHZwz5Xbpbd5gQP1ldjs9PDROFwrCAHB2o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A0kmdkd3V1RXqL92ioBP0M1/TaJAbJfnb7K0HJs2ooPXBc3KgR1RFNilgRw0N+X9W
         GATsVcZ8UrQg78pNo/idi21OvFRaJRU/1oplUelXUkfQxW5oyhVZlE2rUek+gNx4VL
         FoEkw4sglocdXhfyQjaGiWt3npszBx83aHyp9PZxjUdVKOCpOATOiwVUGKxn/Dx6MJ
         QKrpvSRd5ZfR2hJ/cE/biUuu79H2yzXMoazx7PMmVqd+NmCgLJ/vK64imwsZXPdmw9
         7W/bEBLjgDWlhBqcJ5pKe8aZexCR++rU7UCVdFPHpSg3UcscMxQydR4bugsWn92pAZ
         2tE1OZV05CubQ==
Received: by mail-yb1-f176.google.com with SMTP id c6so9978896ybk.3;
        Fri, 25 Feb 2022 22:11:46 -0800 (PST)
X-Gm-Message-State: AOAM5325OoYc9pTBMRKM4qNv1uHUazB1iQJ6JrwKBrJ0IlT/e0w91fM1
        1Bn8puUuuOxU+9Oxg3/hCQQ2iKAeUjP2FyQBTOc=
X-Google-Smtp-Source: ABdhPJw/1j0Jl6aqyekJ/DyjUClCR0sairiCd+k8gMLmylyvGRy7eWMKUy/d954CE8hilUHcIfQdB71C5m7QZQ+X/f4=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr10248523ybn.259.1645855905985; Fri, 25
 Feb 2022 22:11:45 -0800 (PST)
MIME-Version: 1.0
References: <20220225152355.315204-1-stijn@linux-ipv6.be>
In-Reply-To: <20220225152355.315204-1-stijn@linux-ipv6.be>
From:   Song Liu <song@kernel.org>
Date:   Fri, 25 Feb 2022 22:11:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5yA_zx7iyy-k+048S5a=1QiM=SBKDKhg=sGBVVUb0wvA@mail.gmail.com>
Message-ID: <CAPhsuW5yA_zx7iyy-k+048S5a=1QiM=SBKDKhg=sGBVVUb0wvA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 7:24 AM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>
> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
> max_entries parameter set, the map will be created with max_entries set
> to the number of available CPUs. When we try to reuse such a pinned map,
> map_is_reuse_compat will return false, as max_entries in the map
> definition differs from max_entries of the existing map, causing the
> following error:
>
> libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
>
> Fix this by overwriting max_entries in the map definition. For this to
> work, we need to do this in bpf_object__create_maps, before calling
> bpf_object__reuse_map.
>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> v2: overwrite max_entries in the map definition instead of adding an
>     extra check in map_is_reuse_compat, and introduce a helper function
>     for this as suggested by Song.
> ---
>  tools/lib/bpf/libbpf.c | 44 ++++++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 19 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7f10dd501a52..133462637b09 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4854,7 +4854,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>         LIBBPF_OPTS(bpf_map_create_opts, create_attr);
>         struct bpf_map_def *def = &map->def;
>         const char *map_name = NULL;
> -       __u32 max_entries;
>         int err = 0;
>
>         if (kernel_supports(obj, FEAT_PROG_NAME))
> @@ -4864,21 +4863,6 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>         create_attr.numa_node = map->numa_node;
>         create_attr.map_extra = map->map_extra;
>
> -       if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries) {
> -               int nr_cpus;
> -
> -               nr_cpus = libbpf_num_possible_cpus();
> -               if (nr_cpus < 0) {
> -                       pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
> -                               map->name, nr_cpus);
> -                       return nr_cpus;
> -               }
> -               pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
> -               max_entries = nr_cpus;
> -       } else {
> -               max_entries = def->max_entries;
> -       }
> -
>         if (bpf_map__is_struct_ops(map))
>                 create_attr.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
>
> @@ -4928,7 +4912,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>
>         if (obj->gen_loader) {
>                 bpf_gen__map_create(obj->gen_loader, def->type, map_name,
> -                                   def->key_size, def->value_size, max_entries,
> +                                   def->key_size, def->value_size, def->max_entries,
>                                     &create_attr, is_inner ? -1 : map - obj->maps);
>                 /* Pretend to have valid FD to pass various fd >= 0 checks.
>                  * This fd == 0 will not be used with any syscall and will be reset to -1 eventually.
> @@ -4937,7 +4921,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>         } else {
>                 map->fd = bpf_map_create(def->type, map_name,
>                                          def->key_size, def->value_size,
> -                                        max_entries, &create_attr);
> +                                        def->max_entries, &create_attr);
>         }
>         if (map->fd < 0 && (create_attr.btf_key_type_id ||
>                             create_attr.btf_value_type_id)) {
> @@ -4954,7 +4938,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
>                 map->btf_value_type_id = 0;
>                 map->fd = bpf_map_create(def->type, map_name,
>                                          def->key_size, def->value_size,
> -                                        max_entries, &create_attr);
> +                                        def->max_entries, &create_attr);
>         }
>
>         err = map->fd < 0 ? -errno : 0;
> @@ -5058,6 +5042,24 @@ static int bpf_object_init_prog_arrays(struct bpf_object *obj)
>         return 0;
>  }
>
> +static int map_set_def_max_entries(struct bpf_map *map)
> +{
> +       if (map->def.type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !map->def.max_entries) {
> +               int nr_cpus;
> +
> +               nr_cpus = libbpf_num_possible_cpus();
> +               if (nr_cpus < 0) {
> +                       pr_warn("map '%s': failed to determine number of system CPUs: %d\n",
> +                               map->name, nr_cpus);
> +                       return nr_cpus;
> +               }
> +               pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
> +               map->def.max_entries = nr_cpus;
> +       }
> +
> +       return 0;
> +}
> +
>  static int
>  bpf_object__create_maps(struct bpf_object *obj)
>  {
> @@ -5090,6 +5092,10 @@ bpf_object__create_maps(struct bpf_object *obj)
>                         continue;
>                 }
>
> +               err = map_set_def_max_entries(map);
> +               if (err)
> +                       goto err_out;
> +
>                 retried = false;
>  retry:
>                 if (map->pin_path) {
> --
> 2.34.1
>
