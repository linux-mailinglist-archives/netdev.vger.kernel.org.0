Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFC91043BA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKTS4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:56:41 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35512 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfKTS4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:56:41 -0500
Received: by mail-qt1-f194.google.com with SMTP id n4so706872qte.2;
        Wed, 20 Nov 2019 10:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AGdskKahMLrQ7700HUtIxdAUNyehyfxrPKNv8FqY4Rw=;
        b=LW7JeeNASmzSiXfAn9/naBcr5YNrxZurq+H3FYCIzMRLYc4R3U/LM2kfOKc7LEzb2u
         U0kfaTubWaBGRhFrevJDp3rZn0y0522WQABSwEdQdCIQkTW4fqAu3nfm8IWC6oYn+Z/s
         gqIdF70zTpr0kv5KRc06xw+XbN6FYuqkpSO2D6O2nbLjxveyhKOk/j9r07KNgfQ2wgHW
         G1aHEFjfBLj4FCdHqPEyjZRS/OWYg46ihBmGYkURXkeinkf3/8dLk5Aci90KRatyHm9p
         01mZRdZSXk8eaAj4aszrBwiBQhdJSlD2aaUvVErHvCwDBlEXWMRDvA69pexCPJhl0Gv4
         jouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AGdskKahMLrQ7700HUtIxdAUNyehyfxrPKNv8FqY4Rw=;
        b=T7ht0SE2O8UQKILxSzryhFx7ZLr7X+by9QyMWclUkx0hGqQ2bhZuBNlRbLdWGRFjKd
         5GKzu6wKn5XpCVvRpO+Z1lQtZXl2vhT5UopYl42jIZoQNe3s5QpU6l5sfsoNceoAT1Ca
         jK+saRJRKObjFDgAvF2OPUFjSuCJwgoV4FGn7lq7j84yeShkAX2kIZY1JXkA1BQl4M/H
         KdqGWDZBGbBdYWbHAP96GNpeUZGINY93YBKi4hQsKaB5Ku+XAAgNW3mKxDisFHj3Ps9m
         nJSqsamco3rHCJ/QanRncANm2rPt+bhSkY/qwiGFb0F12NbKv39vlbSEuZr1a6lJ1PCP
         KSUQ==
X-Gm-Message-State: APjAAAWIUB2BrRKTQc2FTgf7gTPbd5RyIM0TMGEXpsbg//fT9dvrpUBQ
        yKIW8Jai9TY2DAMQ/6qn+9JgBzVfWAy0KR2lrnaQysH0
X-Google-Smtp-Source: APXvYqxwdNliyQp6cjOxPnqq9F/l1eQhgf0BZ+bErQ8vgFqWr2UyPnLuuei5Nj1IH2A7nDow+EBC7Qxm0Hjz6WfnUBA=
X-Received: by 2002:ac8:6613:: with SMTP id c19mr4175068qtp.117.1574276198214;
 Wed, 20 Nov 2019 10:56:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574126683.git.daniel@iogearbox.net> <41436f9a5d5dd8ef5e88e05b1439e68428fdf2a3.1574126683.git.daniel@iogearbox.net>
In-Reply-To: <41436f9a5d5dd8ef5e88e05b1439e68428fdf2a3.1574126683.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 10:56:27 -0800
Message-ID: <CAEf4BzaVvPa5dLfPCfiXik9tnbXZaW2omxXiFwdJbFb7s1Z=PQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: add poke dependency tracking for prog
 array maps
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 5:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
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
>  include/linux/bpf.h   |  36 ++++++++++
>  kernel/bpf/arraymap.c | 151 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/core.c     |   9 ++-
>  3 files changed, 193 insertions(+), 3 deletions(-)
>

[...]

>  #endif /* _LINUX_BPF_H */
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 5be12db129cc..d2b559c6659e 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -586,10 +586,14 @@ int bpf_fd_array_map_update_elem(struct bpf_map *map, struct file *map_file,
>         if (IS_ERR(new_ptr))
>                 return PTR_ERR(new_ptr);
>
> +       bpf_map_poke_lock(map);
>         old_ptr = xchg(array->ptrs + index, new_ptr);
> +       if (map->ops->map_poke_run)
> +               map->ops->map_poke_run(map, index, old_ptr, new_ptr);
> +       bpf_map_poke_unlock(map);

so this is a bit subtle, if I understand correctly. I was originally
going to suggest that if no map->ops->map_poke_run is set, then
bpf_map_pole_{lock,unlock} shouldn't be called at all. But then I
realized that this creates a race, where xchg can happen in different
order than map_poke_runs. Am I right?

If yes, I wonder if it will be better to express this logic more
explicitly as below, to avoid someone else "optimizing" the code
later:

if (map->ops->map_poke_run) {
    bpf_map_poke_lock(map);
    old_ptr = xchg(array->ptrs + index, new_ptr);
    bpf_map_poke_unlock(map);
} else {
    old_ptr = xchg(array->ptrs + index, new_ptr);
}

This will make it more apparent that something different is happing
when poke tracking is supported by a map.

Am I overthinking this?

> +
>         if (old_ptr)
>                 map->ops->map_fd_put_ptr(old_ptr);
> -
>         return 0;
>  }
>

[...]

> +static void prog_array_map_poke_untrack(struct bpf_map *map,
> +                                       struct bpf_prog_aux *prog_aux)
> +{
> +       struct prog_poke_elem *elem, *tmp;
> +       struct bpf_array_aux *aux;
> +
> +       aux = container_of(map, struct bpf_array, map)->aux;
> +       mutex_lock(&aux->poke_mutex);
> +       list_for_each_entry_safe(elem, tmp, &aux->poke_progs, list) {
> +               if (elem->aux == prog_aux) {
> +                       list_del_init(&elem->list);
> +                       kfree(elem);

break; ?

> +               }
> +       }
> +       mutex_unlock(&aux->poke_mutex);
> +}
> +

[...]

> +
> +                       ret = bpf_arch_text_poke(poke->ip, type,
> +                                                old ? (u8 *)old->bpf_func +
> +                                                poke->adj_off : NULL,
> +                                                new ? (u8 *)new->bpf_func +
> +                                                poke->adj_off : NULL);

nit: extract old/new address calculation, so it's not multi-line
wrapped? It's a bit hard to follow.

> +                       BUG_ON(ret < 0 && ret != -EINVAL);
> +               }
> +       }
> +}
> +

[...]
