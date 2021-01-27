Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D930669C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhA0Voj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhA0Vbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:31:31 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFA7C061573;
        Wed, 27 Jan 2021 13:30:51 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v200so3475160ybe.1;
        Wed, 27 Jan 2021 13:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7BWgk6+3gM7d2xKKx78BdFFfnduTmRUXyeGc/EuUw6I=;
        b=Mwo3170sTmMVxwucjojiyzxWxtd1Ria2Eu1hqiaZG4pnWuIBrqvURfMR1bBlNy+zL9
         fmOzP5ii1hZxsirRbIDVD8BxFKPTx9GY2vNcO5hatn0dgwq0Rv43cdUxzvmPLLexjyVe
         DDXdukMSv9dYxZ5OJxdTxNnchpyVazIInuI3kan629xMBF8G0i60gvcv9VAMitGZNC87
         k4LrUNDsNS2it5PL3d+drVP0xPwXYKIayLyQu8SjImWBDWk/6yHznFr1HkusKNf7SBPr
         +wGxOPKmgJu8ihyPwbcBrcZJf5qx9c5ihTPO1Z7tVzlfpaY8GM1Em9WL5z6W/EIrAnzB
         7CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7BWgk6+3gM7d2xKKx78BdFFfnduTmRUXyeGc/EuUw6I=;
        b=ePfwemnqbFQP4Re90gF2wjULeiKBWPTIBxJvg1VkTrSeyDlsNhuShkGhLHTkV6Uou+
         kpZ88rpVv/aIOA2sHDsnsLtnXE79ZRPJy03A3Skh7TRYjRyd51SoYLhqj/37AOYG2WPN
         P6xuFGUiRXFOLdL9IcImafRQvE9daM7Q5E3YU+DhIOpaIr5ZSEVwRDI9Li+gT9fmnBWQ
         KaF+1nXF6qJr86brXE6L3y9tqj875LMs00ewtVz8poCShsNeinp78lSnt7bHnzwO1V9i
         7rDNgxztHV2W8hxbmV7OhXl8OrlVrSs+n+wx0YhloLu2rlVpYeBFvMx0TnD2uKxeaiIr
         +lXg==
X-Gm-Message-State: AOAM532GusdJr917dl9XMOf4UWID60CcKRuJAAsIuwrypHKt8kMn/FOn
        GwDoDyy8O7uNsSAMe6ioDttY5gkYIO4GlPbP4HA=
X-Google-Smtp-Source: ABdhPJzmlOn8bgm3BoGish66rnam2FCEGTZyGKiUkiSjbLjz/SxaSxE7vHgjpqIj3Ezt+aVzytSxZaVh3C4LYy5QmUM=
X-Received: by 2002:a25:4605:: with SMTP id t5mr6491833yba.260.1611783050543;
 Wed, 27 Jan 2021 13:30:50 -0800 (PST)
MIME-Version: 1.0
References: <20210126085923.469759-1-songliubraving@fb.com> <20210126085923.469759-5-songliubraving@fb.com>
In-Reply-To: <20210126085923.469759-5-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 13:30:39 -0800
Message-ID: <CAEf4BzapLJbmhezw98S8udWO-atgLA2h6Lo9O_ss5Ka_xOR1mA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] bpf: runqslower: use task local storage
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 1:11 AM Song Liu <songliubraving@fb.com> wrote:
>
> Replace hashtab with task local storage in runqslower. This improves the
> performance of these BPF programs. The following table summarizes average
> runtime of these programs, in nanoseconds:
>
>                           task-local   hash-prealloc   hash-no-prealloc
> handle__sched_wakeup             125             340               3124
> handle__sched_wakeup_new        2812            1510               2998
> handle__sched_switch             151             208                991
>
> Note that, task local storage gives better performance than hashtab for
> handle__sched_wakeup and handle__sched_switch. On the other hand, for
> handle__sched_wakeup_new, task local storage is slower than hashtab with
> prealloc. This is because handle__sched_wakeup_new accesses the data for
> the first time, so it has to allocate the data for task local storage.
> Once the initial allocation is done, subsequent accesses, as those in
> handle__sched_wakeup, are much faster with task local storage. If we
> disable hashtab prealloc, task local storage is much faster for all 3
> functions.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/runqslower/runqslower.bpf.c | 31 ++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> index 1f18a409f0443..a597a23d79939 100644
> --- a/tools/bpf/runqslower/runqslower.bpf.c
> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> @@ -11,9 +11,9 @@ const volatile __u64 min_us = 0;
>  const volatile pid_t targ_pid = 0;
>
>  struct {
> -       __uint(type, BPF_MAP_TYPE_HASH);
> -       __uint(max_entries, 10240);
> -       __type(key, u32);
> +       __uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> +       __uint(map_flags, BPF_F_NO_PREALLOC);
> +       __type(key, int);
>         __type(value, u64);
>  } start SEC(".maps");
>
> @@ -25,15 +25,18 @@ struct {
>
>  /* record enqueue timestamp */
>  __always_inline
> -static int trace_enqueue(u32 tgid, u32 pid)
> +static int trace_enqueue(struct task_struct *t)
>  {
> -       u64 ts;
> +       u32 pid = t->pid;
> +       u64 *ptr;
>
>         if (!pid || (targ_pid && targ_pid != pid))
>                 return 0;
>
> -       ts = bpf_ktime_get_ns();
> -       bpf_map_update_elem(&start, &pid, &ts, 0);
> +       ptr = bpf_task_storage_get(&start, t, 0,
> +                                  BPF_LOCAL_STORAGE_GET_F_CREATE);
> +       if (ptr)
> +               *ptr = bpf_ktime_get_ns();

nit: if (!ptr) return 0; is more in line with general handling of
error/unusual conditions. Keeps main logic sequential (especially if
we need to add some extra steps later.


>         return 0;
>  }
>
> @@ -43,7 +46,7 @@ int handle__sched_wakeup(u64 *ctx)
>         /* TP_PROTO(struct task_struct *p) */
>         struct task_struct *p = (void *)ctx[0];
>
> -       return trace_enqueue(p->tgid, p->pid);
> +       return trace_enqueue(p);
>  }
>
>  SEC("tp_btf/sched_wakeup_new")

[...]
