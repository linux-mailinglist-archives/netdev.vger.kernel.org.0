Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0D2F28C9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391967AbhALHPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391911AbhALHPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:15:17 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B1DC061575;
        Mon, 11 Jan 2021 23:14:37 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id r63so1270246ybf.5;
        Mon, 11 Jan 2021 23:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=poqEsJKUqbi5q6gJHl8uXM58SBSZyDT+q0k8szBsA2w=;
        b=kDk2nqge0hKimd8X+Qyg7wIl2wcFF8bwwqg63vWK0sXmCj7coW6GbO272s0waLNUTV
         6Uyk7xxB5iTMfoII5kNC8vYJHXOomxU9bfoR/rZOzWU+b1bGCgK4wB1Okh5640UQmk1j
         FZvuYw1b7tu9GDF8kUfeFQISaPc9ycpPU6a+2NKSci9WQvgTj95w7NR7B1vPgXG58ksn
         uLyzskJKMAERW5ZBlc+slnslah4AqpfcU4Mb+UkQmRTGtORIRfBOhXK2xCAWvzDh4HB2
         TJOkVNnltdM7MT9+H3kkc25ITkOtBV7C67Zfw9LIiDP503gAsXcukaFv4IIRRku2WSdN
         ms2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=poqEsJKUqbi5q6gJHl8uXM58SBSZyDT+q0k8szBsA2w=;
        b=VN+ezHm52YxB6CVVo51gbg9CJovJI+p/AOzR0gFQnmpORV22XD7LDZRDJN29RlHb9a
         +jMhmvrra2Th0WZrUo4Mchz5HFS14j4aVYK8XdngMceupMKAXmYTN05YHEACnqKYvHG1
         ZyOsyOKy/XSkmo3KCcls0PA8V6M0Ielv4IsM4deOS4Kt/KdMj3pmeIBeR8luVGXGzYbn
         m7cUj+FpfusPCTTPKxiFQEoLZBCcTOl8F2+wMLN/ek2Yn/rw+WkhHOllr5lnb28Ih5v2
         V4lBXdt0OtnM7nl6TFLj7j9MZm3Wv21Kdt1cM19S+xARS7hfjiUp9fOZyfXiQ6WWB936
         bxnA==
X-Gm-Message-State: AOAM5329fzPG1/weyDYmViWM1ft80zP2BLY+nvWoSp9OXJXlFHpLTO16
        eEBoiGWVI9bXSznBl6iaKQ/9SVtzEERNnK4+CEk=
X-Google-Smtp-Source: ABdhPJwt0X370NZIjw+4up+qc8Hqzg/eRCuXoaZPO/ERuG2aM1WwHStXQY+RD+xf209idrWL+bOw1ka52PXapZxMsvo=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr355322ybd.230.1610435676396;
 Mon, 11 Jan 2021 23:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-5-songliubraving@fb.com> <ad40d69d-9c0f-8205-26df-c5a755778f9e@fb.com>
 <352FED72-11B3-44F0-9B1C-92552AEB4AE8@fb.com> <e890e08e-99d0-9d81-b835-c3a1b4b8bbbf@fb.com>
In-Reply-To: <e890e08e-99d0-9d81-b835-c3a1b4b8bbbf@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Jan 2021 23:14:25 -0800
Message-ID: <CAEf4BzZivGBmDbUxfiDwAC3aFoTWNfyWaiZRA4Vu16ZT9kzE8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] bpf: runqslower: use task local storage
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "haoluo@google.com" <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:24 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/11/21 2:54 PM, Song Liu wrote:
> >
> >
> >> On Jan 11, 2021, at 9:49 AM, Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 1/8/21 3:19 PM, Song Liu wrote:
> >>> Replace hashtab with task local storage in runqslower. This improves the
> >>> performance of these BPF programs. The following table summarizes average
> >>> runtime of these programs, in nanoseconds:
> >>>                            task-local   hash-prealloc   hash-no-prealloc
> >>> handle__sched_wakeup             125             340               3124
> >>> handle__sched_wakeup_new        2812            1510               2998
> >>> handle__sched_switch             151             208                991
> >>> Note that, task local storage gives better performance than hashtab for
> >>> handle__sched_wakeup and handle__sched_switch. On the other hand, for
> >>> handle__sched_wakeup_new, task local storage is slower than hashtab with
> >>> prealloc. This is because handle__sched_wakeup_new accesses the data for
> >>> the first time, so it has to allocate the data for task local storage.
> >>> Once the initial allocation is done, subsequent accesses, as those in
> >>> handle__sched_wakeup, are much faster with task local storage. If we
> >>> disable hashtab prealloc, task local storage is much faster for all 3
> >>> functions.
> >>> Signed-off-by: Song Liu <songliubraving@fb.com>
> >>> ---
> >>>   tools/bpf/runqslower/runqslower.bpf.c | 26 +++++++++++++++-----------
> >>>   1 file changed, 15 insertions(+), 11 deletions(-)
> >>> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> >>> index 1f18a409f0443..c4de4179a0a17 100644
> >>> --- a/tools/bpf/runqslower/runqslower.bpf.c
> >>> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> >>> @@ -11,9 +11,9 @@ const volatile __u64 min_us = 0;
> >>>   const volatile pid_t targ_pid = 0;
> >>>     struct {
> >>> -   __uint(type, BPF_MAP_TYPE_HASH);
> >>> -   __uint(max_entries, 10240);
> >>> -   __type(key, u32);
> >>> +   __uint(type, BPF_MAP_TYPE_TASK_STORAGE);
> >>> +   __uint(map_flags, BPF_F_NO_PREALLOC);
> >>> +   __type(key, int);
> >>>     __type(value, u64);
> >>>   } start SEC(".maps");
> >>>   @@ -25,15 +25,19 @@ struct {
> >>>     /* record enqueue timestamp */
> >>>   __always_inline
> >>> -static int trace_enqueue(u32 tgid, u32 pid)
> >>> +static int trace_enqueue(struct task_struct *t)
> >>>   {
> >>> -   u64 ts;
> >>> +   u32 pid = t->pid;
> >>> +   u64 ts, *ptr;
> >>>             if (!pid || (targ_pid && targ_pid != pid))
> >>>             return 0;
> >>>             ts = bpf_ktime_get_ns();
> >>> -   bpf_map_update_elem(&start, &pid, &ts, 0);
> >>> +   ptr = bpf_task_storage_get(&start, t, 0,
> >>> +                              BPF_LOCAL_STORAGE_GET_F_CREATE);
> >>> +   if (ptr)
> >>> +           *ptr = ts;
> >>>     return 0;
> >>>   }
> >>>   @@ -43,7 +47,7 @@ int handle__sched_wakeup(u64 *ctx)
> >>>     /* TP_PROTO(struct task_struct *p) */
> >>>     struct task_struct *p = (void *)ctx[0];
> >>>   - return trace_enqueue(p->tgid, p->pid);
> >>> +   return trace_enqueue(p);
> >>>   }
> >>>     SEC("tp_btf/sched_wakeup_new")
> >>> @@ -52,7 +56,7 @@ int handle__sched_wakeup_new(u64 *ctx)
> >>>     /* TP_PROTO(struct task_struct *p) */
> >>>     struct task_struct *p = (void *)ctx[0];
> >>>   - return trace_enqueue(p->tgid, p->pid);
> >>> +   return trace_enqueue(p);
> >>>   }
> >>>     SEC("tp_btf/sched_switch")
> >>> @@ -70,12 +74,12 @@ int handle__sched_switch(u64 *ctx)
> >>>             /* ivcsw: treat like an enqueue event and store timestamp */
> >>>     if (prev->state == TASK_RUNNING)
> >>> -           trace_enqueue(prev->tgid, prev->pid);
> >>> +           trace_enqueue(prev);
> >>>             pid = next->pid;
> >>>             /* fetch timestamp and calculate delta */
> >>> -   tsp = bpf_map_lookup_elem(&start, &pid);
> >>> +   tsp = bpf_task_storage_get(&start, next, 0, 0);
> >>>     if (!tsp)
> >>>             return 0;   /* missed enqueue */
> >>
> >> Previously, hash table may overflow so we may have missed enqueue.
> >> Here with task local storage, is it possible to add additional pid
> >> filtering in the beginning of handle__sched_switch such that
> >> missed enqueue here can be treated as an error?
> >
> > IIUC, hashtab overflow is not the only reason of missed enqueue. If the
> > wakeup (which calls trace_enqueue) happens before runqslower starts, we
> > may still get missed enqueue in sched_switch, no?
>
> the wakeup won't happen before runqslower starts since runqslower needs
> to start to do attachment first and then trace_enqueue() can run.

I think Song is right. Given wakeup and sched_switch need to be
matched, depending at which exact time we attach BPF programs, we can
end up missing wakeup, but not missing sched_switch, no? So it's not
an error.

>
> For the current implementation trace_enqueue() will happen for any non-0
> pid before setting test_progs tgid, and will happen for any non-0 and
> test_progs tgid if it is set, so this should be okay if we do filtering
> in handle__sched_switch. Maybe you can do an experiment to prove whether
> my point is correct or not.
>
> >
> > Thanks,
> > Song
> >
