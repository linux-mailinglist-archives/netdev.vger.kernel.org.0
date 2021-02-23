Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A863225DA
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhBWGXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhBWGWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 01:22:24 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1002C061574;
        Mon, 22 Feb 2021 22:21:43 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id x19so15424762ybe.0;
        Mon, 22 Feb 2021 22:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aN0nEKFhckdZG5EVeID2xP188+9jE1AxS3UZDyML5Vk=;
        b=LVe9/bYYFRbcktdhUrB8khXJiLQbsmf5LBj8OoRu5fC1dhe+whay/vuW8QYBR3iXTR
         uWcTeEw8W2gogkvgIMDwTOoSahyrlZLv/LBada2TWdIOve3Qz/8YjiWzEm3g4cTeQH9N
         BXXl/g2yCd9CJXRcfcsfcxhAAvZhxHq8ARABaxZpBglxj1c65nE4IxFTune2GDh+6Lm8
         vyEoSQPcdgV1ETSYsO75hBX4iMRXv5UicQKdVhduwoxPhNTwBtb4logKvbJcfpMGIo7U
         UmltnNBEr9G93vd4Xd28UW0u5P1F3c/jK722TZ3b+b4JyQ42Uh6L7Gs36UMgnWODh4So
         NadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aN0nEKFhckdZG5EVeID2xP188+9jE1AxS3UZDyML5Vk=;
        b=NjorKyXiA/NJX7Ttx7x4txUb1T4avfnmh4gJ5lEX1CL9ZrqL2WmlSAGKJSdqnElqYk
         L5rP1bKBXx8eMnCGNa+bKelOTt3WTl/Y06xPBjk7weAKzLGnzpjZcwA4O13TGLnC6eeZ
         nB6Ta/hTaA+BnMY67OyGywM437YWHgCnRwCrxLLUGUy5c3vi/ZYU8F6QXF2Jy+9suuHu
         hDZ0irT8GEhPP34euIyPLdeArV51Q5oLW1t1CqN7C8CjN8xT9tOP3kP1RNpyyjzDIQiz
         vhoMOnUkSUZD2nNmzrXy9qRe4VEijTUqxg1rTs1Gm9tVoFuWS7DCCmgPznEqd81NqAtB
         oQoQ==
X-Gm-Message-State: AOAM531BWqElWk8GWAIZ0BT4gt9B+3bz5S9dH4VjQ8aa6hMDtz2vKOgl
        0Q2PABwZHtFlZV1bb1ROGtUXw2heHZdLp44sJorEOMP2
X-Google-Smtp-Source: ABdhPJz0kpIjm45OSQ2/0vvSkcwb3mBWyaza/m2EZ+d3b9y1k/nkI0s35d5XQkexXqt6Aqvch5Yg2blbBm8C+uS0nh4=
X-Received: by 2002:a25:bd12:: with SMTP id f18mr14582916ybk.403.1614061303271;
 Mon, 22 Feb 2021 22:21:43 -0800 (PST)
MIME-Version: 1.0
References: <20210223012014.2087583-1-songliubraving@fb.com> <20210223012014.2087583-3-songliubraving@fb.com>
In-Reply-To: <20210223012014.2087583-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 22:21:32 -0800
Message-ID: <CAEf4BzaZ0ATbJsLoQu_SRUYgzkak9zv61N+T=gijOQ+X=57ErA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive bpf_task_storage_[get|delete]
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 5:23 PM Song Liu <songliubraving@fb.com> wrote:
>
> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
> may cause deadlock on either locks.
>
> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy, which
> is similar to bpf_prog_active. We need this counter to be global, because
> the two locks here belong to two different objects: bpf_local_storage_map
> and bpf_local_storage. If we pick one of them as the owner of the counter,
> it is still possible to trigger deadlock on the other lock. For example,
> if bpf_local_storage_map owns the counters, it cannot prevent deadlock
> on bpf_local_storage->lock when two maps are used.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/bpf/bpf_task_storage.c | 57 ++++++++++++++++++++++++++++++-----
>  1 file changed, 50 insertions(+), 7 deletions(-)
>

[...]

> @@ -109,7 +136,9 @@ static void *bpf_pid_task_storage_lookup_elem(struct bpf_map *map, void *key)
>                 goto out;
>         }
>
> +       bpf_task_storage_lock();
>         sdata = task_storage_lookup(task, map, true);
> +       bpf_task_storage_unlock();
>         put_pid(pid);
>         return sdata ? sdata->data : NULL;
>  out:
> @@ -141,8 +170,10 @@ static int bpf_pid_task_storage_update_elem(struct bpf_map *map, void *key,
>                 goto out;
>         }
>
> +       bpf_task_storage_lock();
>         sdata = bpf_local_storage_update(
>                 task, (struct bpf_local_storage_map *)map, value, map_flags);

this should probably be container_of() instead of casting

> +       bpf_task_storage_unlock();
>
>         err = PTR_ERR_OR_ZERO(sdata);
>  out:
> @@ -185,7 +216,9 @@ static int bpf_pid_task_storage_delete_elem(struct bpf_map *map, void *key)
>                 goto out;
>         }
>
> +       bpf_task_storage_lock();
>         err = task_storage_delete(task, map);
> +       bpf_task_storage_unlock();
>  out:
>         put_pid(pid);
>         return err;

[...]
