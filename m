Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7B107AEB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKVWzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:55:51 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33230 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVWzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:55:51 -0500
Received: by mail-qt1-f196.google.com with SMTP id y39so9734769qty.0;
        Fri, 22 Nov 2019 14:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oc0KuxSsPMiXY62FSFhpEGkdqwTKKPVlqNIE8RWTe28=;
        b=l2NYiXZHsEJav2DEZS53v4bin9FzT3XGlnaqpW4530omQo2ULREbK9YK6b11Q0Vsds
         j36L1/qnDMaXm7ThKzoajcyebOY2XvXmXXfi0Icd7XsfL6CJSqFQ7KKUohQoHOBnqMgn
         nbKPrv5sE/kLYHpECu+HPrDF1qxGKtxgBq0tM0gRYumVE0JK8lTNR0dQFNd4s3vJjyOs
         yLPUU1i01zt1DbP66kvIsp0MGEfEF2YPoctQSd+Z+q2splqS4eNB4rVCH2yXFAnGaX+R
         1p/Uw8O//G15rFF/8+PmjRioG8ojb8aJ8CpCX6I2nlpEzpqjLqQm4JCDWXsQw+SlVvbC
         4uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oc0KuxSsPMiXY62FSFhpEGkdqwTKKPVlqNIE8RWTe28=;
        b=DfKnRl7nbj6FjFxhOCw24GC4x3upkxsTbmy3qCXOzj9v107w3VU36llBMf1Pwpt23I
         UXXkSlTmXHvqU5KF0bhSXVdpxp+Au9ZK/J0rUFeATwFxXjllhTL9PUQ+JDGerPypOGkT
         qDvI5im7ywSZyjnF8KVmkaXi3aOzMAzyU40/5iHGaEulhO6c3kVSyv6QSHduZ0wRBi5O
         fEqbypsafcq6zvq2IuA/fpaVIsGW8+uVz7+asMspQx/QEKkdwMnfihay0kdgDteYyPZ/
         9pYH6fx+wWKMlRhvE5cewkypVZMyldyxXUXSof4TF1KoAA9u2Ix03g4d1P2L3adMFT6K
         z93w==
X-Gm-Message-State: APjAAAXMmwFfzQGn8Q/b/EGruFt4vlozv4EAPBX2nY1dHZXkF5I32uX1
        To4pNDuuKwvG5jz0fMv9Rpw7d96R0cn6lRkV47I=
X-Google-Smtp-Source: APXvYqzZeWn0f6szCYC5GgatZXH8KWE2h6aCNskFixyma/5Ty/BL19xB7oVdgwKo/BaIJO11LFkOpFv9luVetDlxg+M=
X-Received: by 2002:ac8:6613:: with SMTP id c19mr6844242qtp.117.1574463347922;
 Fri, 22 Nov 2019 14:55:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574452833.git.daniel@iogearbox.net> <1fb364bb3c565b3e415d5ea348f036ff379e779d.1574452833.git.daniel@iogearbox.net>
In-Reply-To: <1fb364bb3c565b3e415d5ea348f036ff379e779d.1574452833.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Nov 2019 14:55:37 -0800
Message-ID: <CAEf4BzaZf+_WyARsmZ_rgO_+Ug1iSKsqaoWpB-dPXS6uejT=Qg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] bpf: add poke dependency tracking for
 prog array maps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:08 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This work adds program tracking to prog array maps. This is needed such
> that upon prog array updates/deletions we can fix up all programs which
> make use of this tail call map. We add ops->map_poke_{un,}track()
> helpers to maps to maintain the list of programs and ops->map_poke_run()
> for triggering the actual update.
>
> bpf_array_aux is extended to contain the list head and poke_mutex in
> order to serialize program patching during updates/deletions.
> bpf_free_used_maps() will untrack the program shortly before dropping
> the reference to the map. For clearing out the prog array once all urefs
> are dropped we need to use schedule_work() to have a sleepable context.
>
> The prog_array_map_poke_run() is triggered during updates/deletions and
> walks the maintained prog list. It checks in their poke_tabs whether the
> map and key is matching and runs the actual bpf_arch_text_poke() for
> patching in the nop or new jmp location. Depending on the type of update,
> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/bpf.h   |  12 +++
>  kernel/bpf/arraymap.c | 183 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/core.c     |   9 ++-
>  kernel/bpf/syscall.c  |  20 +++--
>  4 files changed, 212 insertions(+), 12 deletions(-)
>

[...]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 5a9873e58a01..bb002f15b32a 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -26,12 +26,13 @@
>  #include <linux/audit.h>
>  #include <uapi/linux/btf.h>
>
> -#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY || \
> -                          (map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> -                          (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> -                          (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> +#define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> +                         (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> +                         (map)->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS)
> +#define IS_FD_PROG_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PROG_ARRAY)
>  #define IS_FD_HASH(map) ((map)->map_type == BPF_MAP_TYPE_HASH_OF_MAPS)
> -#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_HASH(map))
> +#define IS_FD_MAP(map) (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map) || \
> +                       IS_FD_HASH(map))
>
>  #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
>
> @@ -878,7 +879,7 @@ static int map_lookup_elem(union bpf_attr *attr)
>                 err = bpf_percpu_cgroup_storage_copy(map, key, value);
>         } else if (map->map_type == BPF_MAP_TYPE_STACK_TRACE) {
>                 err = bpf_stackmap_copy(map, key, value);
> -       } else if (IS_FD_ARRAY(map)) {
> +       } else if (IS_FD_ARRAY(map) || IS_FD_PROG_ARRAY(map)) {

Why BPF_MAP_TYPE_PROG_ARRAY couldn't still stay as "IS_FD_ARRAY"?
Seems like it's still handled the same here and is technically an
array containing FDs, no? You can still have more precise
IS_FD_PROG_ARRAY, for cases like in map_update_elem(), where you need
to special-handle just that map type.

>                 err = bpf_fd_array_map_lookup_elem(map, key, value);
>         } else if (IS_FD_HASH(map)) {
>                 err = bpf_fd_htab_map_lookup_elem(map, key, value);
> @@ -1005,6 +1006,10 @@ static int map_update_elem(union bpf_attr *attr)
>                    map->map_type == BPF_MAP_TYPE_SOCKMAP) {
>                 err = map->ops->map_update_elem(map, key, value, attr->flags);
>                 goto out;
> +       } else if (IS_FD_PROG_ARRAY(map)) {
> +               err = bpf_fd_array_map_update_elem(map, f.file, key, value,
> +                                                  attr->flags);
> +               goto out;
>         }
>
>         /* must increment bpf_prog_active to avoid kprobe+bpf triggering from
> @@ -1087,6 +1092,9 @@ static int map_delete_elem(union bpf_attr *attr)
>         if (bpf_map_is_dev_bound(map)) {
>                 err = bpf_map_offload_delete_elem(map, key);
>                 goto out;
> +       } else if (IS_FD_PROG_ARRAY(map)) {
> +               err = map->ops->map_delete_elem(map, key);

map->ops->map_delete_elem would be called below anyways, except under
rcu_read_lock() with preempt_disable() (maybe_wait_bpf_programs() is
no-op for prog_array). So if there is specific reason we want to avoid
preempt_disable and rcu_read_lock(), would be nice to have a comment
explaining that.


> +               goto out;
>         }
>
>         preempt_disable();
> --
> 2.21.0
>
