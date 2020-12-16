Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7812DC71D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbgLPTdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388751AbgLPTdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:00 -0500
X-Gm-Message-State: AOAM5308t+DzEzaeUySteJZktB7J5b8njy1dVPHQzKaTgCDYUu9iFAyJ
        wRvTh4ECe4JQEQXfytr5j3ouw3rkUKj/5f3K7d94sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608143520;
        bh=b0RvPlwbWXozUR5UDtOoKFM5lAWEErBuQgFnovwVI1Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nH+sQ5zn/HBPjgyZnqp7QwoioY6sgfFAC3KY0lxH2/l0AiLjdKRQRk6NA7XEmHSzH
         yErTdgdAByvRMI6ZPecgdhacKLy4tHNaRsSgEZtO8WqRZegz2+AEdT1psA29VCq6rD
         TYDoZSrKAsC4UArKMN+lLBREGnUxUMrDhsnNA6jrHvCh3f8enpDliBPTA0Tqp5lvQ/
         imNNoVS+EK9heyBO/+cleZSQoES7k61BToAA/Vlcy+09/y2c5U7VK3Yg1QTlJK2zNj
         2Cs+wXxl2E35fclJw+3MujeJqbBFOw2oG+7xFgAtCipPP32dHxC9x738/9+X/aocV+
         IWwCW3QeqtWYg==
X-Google-Smtp-Source: ABdhPJxnd6m8FGyn5OPQzgKMf9XyBaGzS9III1DmpKwYngt+yrIaRKOEDlRhXQWkYL/pOsIoiGyourQAsSWXNhW2VK0=
X-Received: by 2002:a2e:9ac1:: with SMTP id p1mr8508519ljj.389.1608143518421;
 Wed, 16 Dec 2020 10:31:58 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-3-songliubraving@fb.com> <CANA3-0cNSkE3iFjbG6EdsA9ZsrTEApBmVwU-2LOkC+0om70zQQ@mail.gmail.com>
In-Reply-To: <CANA3-0cNSkE3iFjbG6EdsA9ZsrTEApBmVwU-2LOkC+0om70zQQ@mail.gmail.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 16 Dec 2020 19:31:47 +0100
X-Gmail-Original-Message-ID: <CANA3-0d1oVEZh2_ypPWwO6DaOin38M--tipEPKZD4s5NANYfdA@mail.gmail.com>
Message-ID: <CANA3-0d1oVEZh2_ypPWwO6DaOin38M--tipEPKZD4s5NANYfdA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: allow bpf_d_path in sleepable
 bpf_iter program
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Cc:     KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 7:15 PM KP Singh <kpsingh@kernel.org> wrote:
>
> On Wed, Dec 16, 2020 at 1:06 AM Song Liu <songliubraving@fb.com> wrote:
> >
> > task_file and task_vma iter programs have access to file->f_path. Enable
> > bpf_d_path to print paths of these file.
> >
> > bpf_iter programs are generally called in sleepable context. However, it
> > is still necessary to diffientiate sleepable and non-sleepable bpf_iter
> > programs: sleepable programs have access to bpf_d_path; non-sleepable
> > programs have access to bpf_spin_lock.
> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >  kernel/trace/bpf_trace.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 4be771df5549a..9e5f9b968355f 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1191,6 +1191,11 @@ BTF_SET_END(btf_allowlist_d_path)
> >
> >  static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> >  {
> > +       if (prog->type == BPF_PROG_TYPE_TRACING &&
> > +           prog->expected_attach_type == BPF_TRACE_ITER &&
> > +           prog->aux->sleepable)
> > +               return true;
>

Another try to send it on the list.

> For the sleepable/non-sleepable we have been (until now) checking
> this in bpf_tracing_func_proto (or bpf_lsm_func_proto)
>
> eg.
>
> case BPF_FUNC_copy_from_user:
> return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
>
> But even beyond that, I don't think this is needed.
>
> We have originally exposed the helper to both sleepable and
> non-sleepable LSM and tracing programs with an allow list.
>
> For LSM the allow list is bpf_lsm_is_sleepable_hook) but
> that's just an initial allow list and thus causes some confusion
> w.r.t to sleep ability (maybe we should add a comment there).
>
> Based on the current logic, my understanding is that
> it's okay to use the helper in the allowed hooks in both
> "lsm.s/" and "lsm/" (and the same for
> BPF_PROG_TYPE_TRACING).
>
> We would have required sleepable only if this helper called "dput"
> (which can sleep).
>
> > +
> >         if (prog->type == BPF_PROG_TYPE_LSM)
> >                 return bpf_lsm_is_sleepable_hook(prog->aux->attach_btf_id);
> >
> > --
> > 2.24.1
> >
