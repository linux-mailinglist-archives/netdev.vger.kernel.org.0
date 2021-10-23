Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07EF438152
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhJWBuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhJWBuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 21:50:03 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14155C061764;
        Fri, 22 Oct 2021 18:47:45 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o17so10888115ybq.4;
        Fri, 22 Oct 2021 18:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aL79YPSpcZmCaedtoxRXcxQnLr8MGhUbQE3zK6kPJbI=;
        b=perVRTJzXe39kErJd5quxg9x9LnKdwY7DU2MbmpZblhONuF97nw/cwjKJoPYTsLLzc
         HMmNMNhByAcBXCUqd0ly0z6lF3Dmrhd0P3fWLHD1byCUkgNnRk5GOCwNkkFRyo7lEojJ
         Lyi2Km5YVr1dRMY0Huxvyy840Ruy1bsUmLgsW2Ap6bmnS+OXIRhDmC02EFz+BjF+HgB1
         2AFtDGEfkVeEEJWhJxQBYR+OA16Kdlf7bGTiUahq66Eqdy8VECYZS47M1Lnx9lPoSipA
         Z2ZaMApPoitUZmGdpcojMhqYTadZKIntYs1/1Wth73hfpv2NN9AQYkWVGzF1/bTE2FGe
         WJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aL79YPSpcZmCaedtoxRXcxQnLr8MGhUbQE3zK6kPJbI=;
        b=hJbJZK15mUaJhlPJHjiHe6FO24Kc/cEt2TjaG4dOrl0Uq/YmvYGpuEOdDHN/LAaI3k
         vtScPqyloaljLVM4lvTcpXPhZGM4s0Pyp7BeCtTeJmd0zm8LnU1c0w7G7dG2wPQidyWl
         sI7zggPnMwPEgSM1lwITzcKwc2+Jxc3luton2UPodgZT+BYExcE2BBu7zuuk9d53cHa5
         jelE34TXCMFbZUGmLgg9SJcfHzbpEErWK2/5kFEHsjYnhe2tupUWCaLql+fZKD5IEZqs
         yNnSE06VOCuVq5LrP2tp2sO7rFOaN+nkBoVQ8acoC/aP6tbqeieiqYqJRfjRkLV1OyVQ
         bzlw==
X-Gm-Message-State: AOAM531TL3lc2AHGFB2AulcVpSFuSWM+bXc7un5P4IsZ7tKlW4QYwGoU
        LfjHrh9GpZLleHbhXBrNVEb4wQ15Qbd9t5XutGs=
X-Google-Smtp-Source: ABdhPJyWQFGFXoZfeYDcpNFMsg4r/ja8xQOeEXR3R2JiFoIKG4ToDW652rUaLUzeVaEaVa9A0y+wOd6K+y39wFKrFTc=
X-Received: by 2002:a25:918e:: with SMTP id w14mr3467778ybl.225.1634953663028;
 Fri, 22 Oct 2021 18:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211022171647.27885-1-quentin@isovalent.com> <20211022171647.27885-5-quentin@isovalent.com>
In-Reply-To: <20211022171647.27885-5-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 18:47:31 -0700
Message-ID: <CAEf4Bzb4Q+w1ziZqo++VLGme1sV=o261d6XVdS9tdKdS7qNVtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpftool: Switch to libbpf's hashmap for
 programs/maps in BTF listing
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
> In order to show BPF programs and maps using BTF objects when the latter
> are being listed, bpftool creates hash maps to store all relevant items.
> This commit is part of a set that transitions from the kernel's hash map
> implementation to the one coming with libbpf.
>
> The motivation is to make bpftool less dependent of kernel headers, to
> ease the path to a potential out-of-tree mirror, like libbpf has.
>
> This commit focuses on the two hash maps used by bpftool when listing
> BTF objects to store references to programs and maps, and convert them
> to the libbpf's implementation.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/btf.c  | 126 ++++++++++++++++-----------------------
>  tools/bpf/bpftool/main.h |   5 ++
>  2 files changed, 57 insertions(+), 74 deletions(-)
>

[...]

> @@ -741,28 +724,20 @@ build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
>                 if (!btf_id)
>                         continue;
>
> -               obj_node = calloc(1, sizeof(*obj_node));
> -               if (!obj_node) {
> -                       p_err("failed to allocate memory: %s", strerror(errno));
> -                       err = -ENOMEM;
> -                       goto err_free;
> -               }
> -
> -               obj_node->obj_id = id;
> -               obj_node->btf_id = btf_id;
> -               hash_add(tab->table, &obj_node->hash, obj_node->btf_id);
> +               hashmap__append(tab, u32_as_hash_field(btf_id),
> +                               u32_as_hash_field(id));

error handling is missing

>         }
>
>         return 0;
>
>  err_free:
> -       delete_btf_table(tab);
> +       hashmap__free(tab);
>         return err;
>  }
>
>  static int
> -build_btf_tables(struct btf_attach_table *btf_prog_table,
> -                struct btf_attach_table *btf_map_table)
> +build_btf_tables(struct hashmap *btf_prog_table,
> +                struct hashmap *btf_map_table)
>  {
>         struct bpf_prog_info prog_info;
>         __u32 prog_len = sizeof(prog_info);
> @@ -778,7 +753,7 @@ build_btf_tables(struct btf_attach_table *btf_prog_table,
>         err = build_btf_type_table(btf_map_table, BPF_OBJ_MAP, &map_info,
>                                    &map_len);
>         if (err) {
> -               delete_btf_table(btf_prog_table);
> +               hashmap__free(btf_prog_table);
>                 return err;
>         }
>
> @@ -787,10 +762,10 @@ build_btf_tables(struct btf_attach_table *btf_prog_table,
>
>  static void
>  show_btf_plain(struct bpf_btf_info *info, int fd,
> -              struct btf_attach_table *btf_prog_table,
> -              struct btf_attach_table *btf_map_table)
> +              struct hashmap *btf_prog_table,
> +              struct hashmap *btf_map_table)
>  {
> -       struct btf_attach_point *obj;
> +       struct hashmap_entry *entry;
>         const char *name = u64_to_ptr(info->name);
>         int n;
>
> @@ -804,18 +779,17 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
>         printf("size %uB", info->btf_size);
>
>         n = 0;
> -       hash_for_each_possible(btf_prog_table->table, obj, hash, info->id) {
> -               if (obj->btf_id == info->id)
> -                       printf("%s%u", n++ == 0 ? "  prog_ids " : ",",
> -                              obj->obj_id);
> -       }
> +       hashmap__for_each_key_entry(btf_prog_table, entry,
> +                                   u32_as_hash_field(info->id))
> +               printf("%s%u", n++ == 0 ? "  prog_ids " : ",",
> +                      hash_field_as_u32(entry->value));

nit: I'd add {}, it's getting a bit hard to follow

>
>         n = 0;
> -       hash_for_each_possible(btf_map_table->table, obj, hash, info->id) {
> -               if (obj->btf_id == info->id)
> -                       printf("%s%u", n++ == 0 ? "  map_ids " : ",",
> -                              obj->obj_id);
> -       }
> +       hashmap__for_each_key_entry(btf_map_table, entry,
> +                                   u32_as_hash_field(info->id))
> +               printf("%s%u", n++ == 0 ? "  map_ids " : ",",
> +                      hash_field_as_u32(entry->value));
> +
>         emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
>
>         printf("\n");

[...]
