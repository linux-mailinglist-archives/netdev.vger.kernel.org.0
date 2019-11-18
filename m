Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB168100A7D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKRRkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:40:07 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40783 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfKRRkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:40:06 -0500
Received: by mail-qt1-f194.google.com with SMTP id o49so21153616qta.7;
        Mon, 18 Nov 2019 09:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hyf5OOMWKEL9cOljn/aGmBG4pFeH+YNqiR2OliYFFqI=;
        b=ZSGIiOOcMLaekKnpOYF7PJCMjqZOEthBOZb/PsBDUZEhmzBT2m6eZSyo3Gj136U4GR
         3piMkz8stJlRrveQNpbA5gAIW7IeFjRDB0edF1b3zwUaBCa/95KvFabrz1LHFvoZZDFj
         pKoOjk/4X8Asbp9aiTqwHNtwuUQJgluhwYmjsYyJWri1dq4Hv7BBPyuc8L4bV6+VhjTI
         Ozm8GU8wwx610/X/9CjHGpjgn4kzrhtgGJoF/4HfQ+VgpGWVsczM28p9GNgZXHGrAG1c
         SN0+FZdXX6tLvwJ0bvihGPKvlGP6hqTk8oq9dAh+U2DcUf37sGj5/0FYh9QtJ6QJ9ZsF
         ToOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hyf5OOMWKEL9cOljn/aGmBG4pFeH+YNqiR2OliYFFqI=;
        b=mJjs4NQqbX6+UMqior8DhWftqov09JrZ6JdT3XCc8ciD8TLyBVugVFaFyrCjjxDS17
         PqqSrR+o9bqylHF+lMKFbm291f/V0QxqqhkwcRQl+hJ3BK8YfZKgmWyUBvWWGS+0eW45
         LYEzJquRVjyhpz3I7BwG3OxNvK1Sa14Q2+TCUXUHF7t7gffxVi7SBTDCilIiP5X2p/YZ
         /wfWnXaNTT4k2Tk48/QrWCtOkXU6Kvfh4EXfC8bU3Fajgfk9ZHQVs8tAMzbD7tOeRo7m
         B9BS1kgwJs+DuKIbk7cBSwQRTHwYnlQPDqUqS3dgLjXdBtOIFXSSEeZqknKegsxuKeKg
         CNKw==
X-Gm-Message-State: APjAAAXXWPz+Des/wtzJYmwXQLaRvJiS6v7FzglxEPaoC9re9D14nYDt
        u1yiqpo/D5WaufYNClpoiLThmFDG/O88AiIJ1VY=
X-Google-Smtp-Source: APXvYqzxkfsJ7jA/fUNe+oKfU5tAUVijU9KiOEgz6WDLKAKs5QeRcgJIvlyyFBY7XkpEzpFKxkIe7HOKjFJUjB5+xaU=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr27947748qtk.171.1574098804440;
 Mon, 18 Nov 2019 09:40:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <ff9a3829fb46802262a20dbad1123cd66c118b8b.1573779287.git.daniel@iogearbox.net>
In-Reply-To: <ff9a3829fb46802262a20dbad1123cd66c118b8b.1573779287.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Nov 2019 09:39:53 -0800
Message-ID: <CAEf4BzaxyULFPYd8OGfoc5FLSDt2ecppLFakjRJ2TyK5F-fJOw@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 6/8] bpf: add poke dependency tracking for
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

On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This work adds program tracking to prog array maps. This is needed such
> that upon prog array updates/deletions we can fix up all programs which
> make use of this tail call map. We add ops->map_poke_{un,}track() helpers
> to maps to maintain the list of programs and ops->map_poke_run() for
> triggering the actual update. bpf_array_aux is extended to contain the
> list head and poke_mutex in order to serialize program patching during
> updates/deletions. bpf_free_used_maps() will untrack the program shortly
> before dropping the reference to the map.
>
> The prog_array_map_poke_run() is triggered during updates/deletions and
> walks the maintained prog list. It checks in their poke_tabs whether the
> map and key is matching and runs the actual bpf_arch_text_poke() for
> patching in the nop or new jmp location. Depending on the type of update,
> we use one of BPF_MOD_{NOP_TO_JUMP,JUMP_TO_NOP,JUMP_TO_JUMP}.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/linux/bpf.h   |  36 +++++++++++++
>  kernel/bpf/arraymap.c | 120 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/core.c     |   9 +++-
>  3 files changed, 162 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0ff06a0d0058..62a369fb8d98 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -21,6 +21,7 @@ struct bpf_verifier_env;
>  struct bpf_verifier_log;
>  struct perf_event;
>  struct bpf_prog;
> +struct bpf_prog_aux;
>  struct bpf_map;
>  struct sock;
>  struct seq_file;
> @@ -63,6 +64,12 @@ struct bpf_map_ops {
>                              const struct btf_type *key_type,
>                              const struct btf_type *value_type);
>
> +       /* Prog poke tracking helpers. */
> +       int (*map_poke_track)(struct bpf_map *map, struct bpf_prog_aux *aux);
> +       void (*map_poke_untrack)(struct bpf_map *map, struct bpf_prog_aux *aux);
> +       void (*map_poke_run)(struct bpf_map *map, u32 key, struct bpf_prog *old,
> +                            struct bpf_prog *new);

You are passing bpf_prog_aux for track/untrack, but bpf_prog itself
for run. Maybe stick to just bpf_prog everywhere?

> +
>         /* Direct value access helpers. */
>         int (*map_direct_value_addr)(const struct bpf_map *map,
>                                      u64 *imm, u32 off);
> @@ -584,6 +591,9 @@ struct bpf_array_aux {
>          */
>         enum bpf_prog_type type;
>         bool jited;
> +       /* Programs with direct jumps into programs part of this array. */
> +       struct list_head poke_progs;
> +       struct mutex poke_mutex;
>  };
>

[...]
