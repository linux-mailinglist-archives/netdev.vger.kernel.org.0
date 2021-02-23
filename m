Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC92322656
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhBWHUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhBWHUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 02:20:12 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B49CC061574;
        Mon, 22 Feb 2021 23:19:32 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f4so15497814ybk.11;
        Mon, 22 Feb 2021 23:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbrJy9F31IyOyKc6QRCuclFArja7riXdxECoDwKq/m4=;
        b=kAS+penUa37P4RUd7+QrbldH1BOQ9P2ymVbT5d7WvMt8LPaXToK7YR09KpEL96x5iH
         Aa6YQDtzdpxS24rH4c30RL6CF0chlrE72YML+61YkdyiG2UOXDbZX57M6p+bi+QVYO0Z
         55dTjsGmSRiMfi/CzyLzG05XfvMEUz+aV89SPozdzSCaL+mKKV//V+ST8AjwdoCFOLix
         cr/IBF6xSaIMe8IPhMX6lboCp4b55+PerW0B5B1tCFRQ4OmjM2esDrgKkwXq6GNNOWcu
         zvxnFYylwFWHtlk6CmlCWC86+30ptXQuCFS+vG1BCpxReP6MXb9MpOD7PmqAJTGCK/Mh
         p0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbrJy9F31IyOyKc6QRCuclFArja7riXdxECoDwKq/m4=;
        b=il1Mas5x2s6JEIJfd75LCEaQUoAdZhmUB6NwH7ZtJ57YlhIY+2NDGbo8uGH0yc0up5
         p/Wvdxz/urxByoC1HdG52rI/uwgxxnJE9v4rBNcZJohlt929xLqrtTpwxfw9lICRigkL
         kH1m9JwNMRIU6SQCiLsDrmnrTYnB6+a/K+FiSfuXFJDAFH6Rwsc0c5p4I29csxLuM2l/
         gcusYeHMyW/yVtd3gpMaLdODqdr6Jj+HpGOLioq9zIP2w9VH9Jd39X01eHySUAqJ6U2T
         mcUFPoHnV6Zb8VUGvU1o2iW1PAdxCu4QxpZ1KwUIF6no0epbhUbiq0qriZSWRURZP8Km
         kbnQ==
X-Gm-Message-State: AOAM533EwxwGAqdrcFaEUd0OaSo80p1B9oFzTzvhT9y9SJ5qu3tlt4PA
        irzED00aJJOkee5QoP8+SUsYJ6YT1f5+eOapfqk=
X-Google-Smtp-Source: ABdhPJwK5/Sqw5Ltw3LgeC8rYm9LOWViuZu5pvWXekhZe2huE+WnBU0kkgQP1FGzNNtiImHeIMHc8N8GSaxyM0i5PmY=
X-Received: by 2002:a25:37c4:: with SMTP id e187mr39545653yba.347.1614064772003;
 Mon, 22 Feb 2021 23:19:32 -0800 (PST)
MIME-Version: 1.0
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-3-songliubraving@fb.com> <CAEf4BzaZ0ATbJsLoQu_SRUYgzkak9zv61N+T=gijOQ+X=57ErA@mail.gmail.com>
 <6A4F1927-AF73-4AC8-AE44-5878ACEDF944@fb.com>
In-Reply-To: <6A4F1927-AF73-4AC8-AE44-5878ACEDF944@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 23:19:21 -0800
Message-ID: <CAEf4Bzak3Ye4xoAAva2WLc=-e+xEQFbSyk9gs50ASoSn-Gn5_A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/6] bpf: prevent deadlock from recursive bpf_task_storage_[get|delete]
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Ziljstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 11:16 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Feb 22, 2021, at 10:21 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Feb 22, 2021 at 5:23 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
> >> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
> >> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
> >> may cause deadlock on either locks.
> >>
> >> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy, which
> >> is similar to bpf_prog_active. We need this counter to be global, because
> >> the two locks here belong to two different objects: bpf_local_storage_map
> >> and bpf_local_storage. If we pick one of them as the owner of the counter,
> >> it is still possible to trigger deadlock on the other lock. For example,
> >> if bpf_local_storage_map owns the counters, it cannot prevent deadlock
> >> on bpf_local_storage->lock when two maps are used.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> kernel/bpf/bpf_task_storage.c | 57 ++++++++++++++++++++++++++++++-----
> >> 1 file changed, 50 insertions(+), 7 deletions(-)
> >>
> >
> > [...]
> >
> >> @@ -109,7 +136,9 @@ static void *bpf_pid_task_storage_lookup_elem(struct bpf_map *map, void *key)
> >>                goto out;
> >>        }
> >>
> >> +       bpf_task_storage_lock();
> >>        sdata = task_storage_lookup(task, map, true);
> >> +       bpf_task_storage_unlock();
> >>        put_pid(pid);
> >>        return sdata ? sdata->data : NULL;
> >> out:
> >> @@ -141,8 +170,10 @@ static int bpf_pid_task_storage_update_elem(struct bpf_map *map, void *key,
> >>                goto out;
> >>        }
> >>
> >> +       bpf_task_storage_lock();
> >>        sdata = bpf_local_storage_update(
> >>                task, (struct bpf_local_storage_map *)map, value, map_flags);
> >
> > this should probably be container_of() instead of casting
>
> bpf_task_storage.c uses casting in multiple places. How about we fix it in a
> separate patch?
>

Sure, let's fix all uses in a separate patch. My point is that this
makes an assumption (that struct bpf_map map field is always the very
first one) which is not enforced and not documented in struct
bpf_local_storage_map.

> Thanks,
> Song
>
> >
> >> +       bpf_task_storage_unlock();
> >>
> >>        err = PTR_ERR_OR_ZERO(sdata);
> >> out:
> >> @@ -185,7 +216,9 @@ static int bpf_pid_task_storage_delete_elem(struct bpf_map *map, void *key)
> >>                goto out;
> >>        }
> >>
> >> +       bpf_task_storage_lock();
> >>        err = task_storage_delete(task, map);
> >> +       bpf_task_storage_unlock();
> >> out:
> >>        put_pid(pid);
> >>        return err;
> >
> > [...]
>
