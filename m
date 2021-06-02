Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890B23995FE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 00:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFBWhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 18:37:37 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:34538 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhFBWhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 18:37:37 -0400
Received: by mail-yb1-f182.google.com with SMTP id 207so6075950ybd.1;
        Wed, 02 Jun 2021 15:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+pNnKOd3Qul4uw6usdHHg7dueizxkBp3gwgxWbDFKyQ=;
        b=uppkdMaRBvQcakiWgNDMZGy9sDzEtZz3VX84tn5MVLBl1WaJXV1qizA6S85bhl4OGG
         hHc6g11/pBpMpWhxhP2WkNXdd8VtMyAkN/eb50tL4h2zT2mdq3v4GCvyJfIM1kWip2tD
         TeRVd3NSd3NAqIbNPJWFkCx8tQbWST7DKEv/vQDj1FfT14X39006YXmzmYKcVjLfU+Mj
         VR6ONG/Fcmg0mSgfMrPG4Iq8pL8eeF2BV/Dv712mPC6weRyMlEFUln6z4xolLyN9f/Mz
         qLV9GxVCi3DoqCxv0IDaoYAbB8bdJxKYnY1d0++I4cYltISZSyAjU2HiNp0TbU0x0wB4
         19kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+pNnKOd3Qul4uw6usdHHg7dueizxkBp3gwgxWbDFKyQ=;
        b=AzgYUS1pHzdQIvds4OBZtxd6n4+hE0om+ToZzAiUovW8FbP5xSBh5OI6gs78k31aZp
         JDGqtPSrarfcsWc89EZKhcljKvZSgEBVrVdl9Yq+0A/KGeSiklRAew/FDCaVVPzFJCCf
         FYrKw1tWt6RHcLA4ayrviH1b2V9ChFUHZWbtBVokCsOy0BT5eIQiMTdwEXc9Jtz/RDJM
         efLrX4NMbB1C4KVw3CUyRTsOj8EMKTu9B8LhNHJqHQgmaCqgP2nlf/vH10ncXg3MckIu
         rufH7mz+eSOvqO1KhwsPVizXJAlSNKWddW/xQ2NI73kvP5djzLVsIDEFc7kK82U06wwA
         LfQw==
X-Gm-Message-State: AOAM533KHfLgKiUi52OcGp+qzbm58G7IQdFNNbmZdNEm55IE/2Y936sx
        Y2pMT39O7JMxoTjMVIW5DPuuhWSOP+OpPJbqCdo=
X-Google-Smtp-Source: ABdhPJwD+kBwqESdc9PqJeJxhTbVrBc+gzpiJ0Jf+Z5CFk4i8SmuKo1t3xOxIC0W9pHKMXFBRLMckYd2K/pG6cuCONs=
X-Received: by 2002:a25:9942:: with SMTP id n2mr52100238ybo.230.1622673280042;
 Wed, 02 Jun 2021 15:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com> <20210527040259.77823-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20210527040259.77823-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Jun 2021 15:34:29 -0700
Message-ID: <CAEf4BzbPkUdsY8XD5n2yMB8CDvakz4jxshjF8xrzqHXQS0ct9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add verifier checks for bpf_timer.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 9:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add appropriate safety checks for bpf_timer:
> - restrict to array, hash, lru. per-cpu maps cannot be supported.
> - kfree bpf_timer during map_delete_elem and map_free.
> - verifier btf checks.
> - safe interaction with lookup/update/delete operations and iterator.
> - relax the first field only requirement of the previous patch.
> - allow bpf_timer in global data and search for it in datasec.
> - check prog_rdonly, frozen flags.
> - mmap is allowed. otherwise global timer is not possible.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h        | 36 +++++++++++++-----
>  include/linux/btf.h        |  1 +
>  kernel/bpf/arraymap.c      |  7 ++++
>  kernel/bpf/btf.c           | 77 +++++++++++++++++++++++++++++++-------
>  kernel/bpf/hashtab.c       | 53 ++++++++++++++++++++------
>  kernel/bpf/helpers.c       |  2 +-
>  kernel/bpf/local_storage.c |  4 +-
>  kernel/bpf/syscall.c       | 23 ++++++++++--
>  kernel/bpf/verifier.c      | 30 +++++++++++++--
>  9 files changed, 190 insertions(+), 43 deletions(-)
>

[...]

>  /* copy everything but bpf_spin_lock */
>  static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>  {
> +       u32 off = 0, size = 0;
> +
>         if (unlikely(map_value_has_spin_lock(map))) {
> -               u32 off = map->spin_lock_off;
> +               off = map->spin_lock_off;
> +               size = sizeof(struct bpf_spin_lock);
> +       } else if (unlikely(map_value_has_timer(map))) {
> +               off = map->timer_off;
> +               size = sizeof(struct bpf_timer);
> +       }

so the need to handle 0, 1, or 2 gaps seems to be the only reason to
disallow both bpf_spinlock and bpf_timer in one map element, right?
Isn't it worth addressing it from the very beginning to lift the
artificial restriction? E.g., for speed, you'd do:

if (likely(neither spinlock nor timer)) {
 /* fastest pass */
} else if (only one of spinlock or timer) {
  /* do what you do here */
} else {
  int off1, off2, sz1, sz2;

  if (spinlock_off < timer_off) {
    off1 = spinlock_off;
    sz1 = spinlock_sz;
    off2 = timer_off;
    sz2 = timer_sz;
  } else {
    ... you get the idea
  }

  memcpy(0, off1);
  memcpy(off1+sz1, off2);
  memcpy(off2+sz2, total_sz);
}

It's not that bad, right?

>
> +       if (unlikely(size)) {
>                 memcpy(dst, src, off);
> -               memcpy(dst + off + sizeof(struct bpf_spin_lock),
> -                      src + off + sizeof(struct bpf_spin_lock),
> -                      map->value_size - off - sizeof(struct bpf_spin_lock));
> +               memcpy(dst + off + size,
> +                      src + off + size,
> +                      map->value_size - off - size);
>         } else {
>                 memcpy(dst, src, map->value_size);
>         }

[...]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f386f85aee5c..0a828dc4968e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3241,6 +3241,15 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
>                         return -EACCES;
>                 }
>         }
> +       if (map_value_has_timer(map)) {
> +               u32 t = map->timer_off;
> +
> +               if (reg->smin_value + off < t + sizeof(struct bpf_timer) &&

<= ? Otherwise we allow accessing the first byte, unless I'm mistaken.

> +                    t < reg->umax_value + off + size) {
> +                       verbose(env, "bpf_timer cannot be accessed directly by load/store\n");
> +                       return -EACCES;
> +               }
> +       }
>         return err;
>  }
>
> @@ -4675,9 +4684,24 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
>                         map->name);
>                 return -EINVAL;
>         }
> -       if (val) {
> -               /* todo: relax this requirement */
> -               verbose(env, "bpf_timer field can only be first in the map value element\n");

ok, this was confusing, but now I see why you did that...

> +       if (!map_value_has_timer(map)) {
> +               if (map->timer_off == -E2BIG)
> +                       verbose(env,
> +                               "map '%s' has more than one 'struct bpf_timer'\n",
> +                               map->name);
> +               else if (map->timer_off == -ENOENT)
> +                       verbose(env,
> +                               "map '%s' doesn't have 'struct bpf_timer'\n",
> +                               map->name);
> +               else
> +                       verbose(env,
> +                               "map '%s' is not a struct type or bpf_timer is mangled\n",
> +                               map->name);
> +               return -EINVAL;
> +       }
> +       if (map->timer_off != val + reg->off) {
> +               verbose(env, "off %lld doesn't point to 'struct bpf_timer' that is at %d\n",
> +                       val + reg->off, map->timer_off);
>                 return -EINVAL;
>         }
>         WARN_ON(meta->map_ptr);
> --
> 2.30.2
>
