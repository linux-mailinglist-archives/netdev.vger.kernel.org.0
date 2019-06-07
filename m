Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9529382F5
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfFGC7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:59:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45513 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfFGC7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 22:59:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id j19so645691qtr.12;
        Thu, 06 Jun 2019 19:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzz8DYGRcQFgk5DYQCQBlcDGLCLl8klfo3nj5i4KBBk=;
        b=ft87MKAop5+OUpVOVZ9cJmgSeVuB8uSVQAJJnzG+MbN0aNjkgW8e1mAq5VirYnmHjS
         drBPymHvvueaDEfs0xl7R9/M98E0yirhCNrhWruOyRnXEkBUU8XDcr1tCTWeH9fndvgQ
         9fh5Kxu/AQO2T9dLuDFfZg6KSFrQJ1YlyV3vacCj46WOk0CLbjD9OzSZkQq5T3fYzPMJ
         h2oQGYiW2LgBIZeeTio7ICWAzHzJDCcY0Bbu758uc+7nVjOmmjIbtMZcGiuHwTHxBJX6
         PaRX0ykqWOJPEdvNT2HRthymzzcADW5ktuVIaJgRH4Q2Yiv8sNH8QUvJLe0YSFxBKP1i
         wiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzz8DYGRcQFgk5DYQCQBlcDGLCLl8klfo3nj5i4KBBk=;
        b=qv7tlCCoZPsxHbGfLdycoigl/cPVkx2ZLXh5FpE4YDWeKSc0cdTznnmOXGwDUfADP2
         UXEMMmUfOuLd9hsOwyp2hu7WSYJiT0nP9Ln7gacWYjFlaO65do6uZ6ToQWAc2up3BuMn
         B2ThXYzVpadjynATgR9d99tmXNIvgggZk/6ou8nRaTHi4fxA9+WqM3TnyWxqAcQLwZf4
         eeerapDjojVrUFgns6V2PDEBLgE+gV1+uez8qZh6D3NOtR2DBm+UeG0YzvMpbYHCN2Be
         /8SbAB7Em2io2PFOCchNYKBjGSjWt2KllX3dW38Y5fS0l/PihpqzNcputg2DNv11/ijP
         Vw8g==
X-Gm-Message-State: APjAAAVaNYRN+piPwgOfC85z6jr2DJigF7pfH/wcS6LhIlbG8SKj9Wel
        ROry313FCCnXXpYcb7LRXB11JKZCl35CSsR2sls=
X-Google-Smtp-Source: APXvYqwlaPeSqjrbyFt9cVtD+DKO+lrFZOKYkr8KHvZSNAJyBXPE2JPgr+wW/xEaA5K+VYkIkvgV/7morZ47ffACM+I=
X-Received: by 2002:a0c:9e02:: with SMTP id p2mr20709481qve.150.1559876369550;
 Thu, 06 Jun 2019 19:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com> <20190606185427.7558-1-mmullins@fb.com>
In-Reply-To: <20190606185427.7558-1-mmullins@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jun 2019 19:59:18 -0700
Message-ID: <CAEf4BzYdRGfJgQ6-Hb8NkCgUqFRVs304KE0KMfAy9vbbTOMp5g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
To:     Matt Mullins <mmullins@fb.com>
Cc:     hall@fb.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 1:17 PM Matt Mullins <mmullins@fb.com> wrote:
>
> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
> they do not increment bpf_prog_active while executing.
>
> This enables three levels of nesting, to support
>   - a kprobe or raw tp or perf event,
>   - another one of the above that irq context happens to call, and
>   - another one in nmi context

Can NMIs be nested?

> (at most one of which may be a kprobe or perf event).
>
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
> ---
> This is more lines of code, but possibly less intrusive than the
> per-array-element approach.
>
> I don't necessarily like that I duplicated the nest_level logic in two
> places, but I don't see a way to unify them:
>   - kprobes' bpf_perf_event_output doesn't use bpf_raw_tp_regs, and does
>     use the perf_sample_data,
>   - raw tracepoints' bpf_get_stackid uses bpf_raw_tp_regs, but not
>     the perf_sample_data, and
>   - raw tracepoints' bpf_perf_event_output uses both...
>
>  kernel/trace/bpf_trace.c | 95 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 80 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f92d6ad5e080..4f5419837ddd 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -410,8 +410,6 @@ static const struct bpf_func_proto bpf_perf_event_read_value_proto = {
>         .arg4_type      = ARG_CONST_SIZE,
>  };
>
> -static DEFINE_PER_CPU(struct perf_sample_data, bpf_trace_sd);
> -
>  static __always_inline u64
>  __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
>                         u64 flags, struct perf_sample_data *sd)
> @@ -442,24 +440,47 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
>         return perf_event_output(event, sd, regs);
>  }
>
> +/*
> + * Support executing tracepoints in normal, irq, and nmi context that each call
> + * bpf_perf_event_output
> + */
> +struct bpf_trace_sample_data {
> +       struct perf_sample_data sds[3];
> +};
> +
> +static DEFINE_PER_CPU(struct bpf_trace_sample_data, bpf_trace_sds);
> +static DEFINE_PER_CPU(int, bpf_trace_nest_level);
>  BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
>            u64, flags, void *, data, u64, size)
>  {
> -       struct perf_sample_data *sd = this_cpu_ptr(&bpf_trace_sd);
> +       struct bpf_trace_sample_data *sds = this_cpu_ptr(&bpf_trace_sds);
> +       struct perf_sample_data *sd;
> +       int nest_level = this_cpu_inc_return(bpf_trace_nest_level);

reverse Christmas tree?

>         struct perf_raw_record raw = {
>                 .frag = {
>                         .size = size,
>                         .data = data,
>                 },
>         };
> +       int err = -EBUSY;
>
> +       if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(sds->sds)))
> +               goto out;

consider this a nit, but I find it much simpler to follow when err is
set just before goto, so that it's clear what's going to be returned:

int err;

if (something_bad) {
    err = -EBAD_ERR_CODE1;
    goto out;
}


> +
> +       sd = &sds->sds[nest_level - 1];
> +
> +       err = -EINVAL;
>         if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
> -               return -EINVAL;
> +               goto out;

Same here.

>
>         perf_sample_data_init(sd, 0, 0);
>         sd->raw = &raw;
>
> -       return __bpf_perf_event_output(regs, map, flags, sd);
> +       err = __bpf_perf_event_output(regs, map, flags, sd);
> +
> +out:
> +       this_cpu_dec(bpf_trace_nest_level);
> +       return err;
>  }
>
>  static const struct bpf_func_proto bpf_perf_event_output_proto = {
> @@ -822,16 +843,48 @@ pe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  /*
>   * bpf_raw_tp_regs are separate from bpf_pt_regs used from skb/xdp
>   * to avoid potential recursive reuse issue when/if tracepoints are added
> - * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack
> + * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack.
> + *
> + * Since raw tracepoints run despite bpf_prog_active, support concurrent usage
> + * in normal, irq, and nmi context.
>   */
> -static DEFINE_PER_CPU(struct pt_regs, bpf_raw_tp_regs);
> +struct bpf_raw_tp_regs {
> +       struct pt_regs regs[3];
> +};
> +static DEFINE_PER_CPU(struct bpf_raw_tp_regs, bpf_raw_tp_regs);
> +static DEFINE_PER_CPU(int, bpf_raw_tp_nest_level);
> +static struct pt_regs *get_bpf_raw_tp_regs(void)
> +{
> +       struct bpf_raw_tp_regs *tp_regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +       int nest_level = this_cpu_inc_return(bpf_raw_tp_nest_level);
> +
> +       if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(tp_regs->regs))) {
> +               this_cpu_dec(bpf_raw_tp_nest_level);
> +               return ERR_PTR(-EBUSY);
> +       }
> +
> +       return &tp_regs->regs[nest_level - 1];
> +}
> +
> +static void put_bpf_raw_tp_regs(void)
> +{
> +       this_cpu_dec(bpf_raw_tp_nest_level);
> +}
> +
>  BPF_CALL_5(bpf_perf_event_output_raw_tp, struct bpf_raw_tracepoint_args *, args,
>            struct bpf_map *, map, u64, flags, void *, data, u64, size)
>  {
> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
> +       int ret;
> +
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);
>
>         perf_fetch_caller_regs(regs);
> -       return ____bpf_perf_event_output(regs, map, flags, data, size);
> +       ret = ____bpf_perf_event_output(regs, map, flags, data, size);
> +
> +       put_bpf_raw_tp_regs();
> +       return ret;
>  }
>
>  static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
> @@ -848,12 +901,18 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
>  BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
>            struct bpf_map *, map, u64, flags)
>  {
> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
> +       int ret;
> +
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);
>
>         perf_fetch_caller_regs(regs);
>         /* similar to bpf_perf_event_output_tp, but pt_regs fetched differently */
> -       return bpf_get_stackid((unsigned long) regs, (unsigned long) map,
> -                              flags, 0, 0);
> +       ret = bpf_get_stackid((unsigned long) regs, (unsigned long) map,
> +                             flags, 0, 0);
> +       put_bpf_raw_tp_regs();
> +       return ret;
>  }
>
>  static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
> @@ -868,11 +927,17 @@ static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
>  BPF_CALL_4(bpf_get_stack_raw_tp, struct bpf_raw_tracepoint_args *, args,
>            void *, buf, u32, size, u64, flags)
>  {
> -       struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
> +       struct pt_regs *regs = get_bpf_raw_tp_regs();
> +       int ret;
> +
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);
>
>         perf_fetch_caller_regs(regs);
> -       return bpf_get_stack((unsigned long) regs, (unsigned long) buf,
> -                            (unsigned long) size, flags, 0);
> +       ret = bpf_get_stack((unsigned long) regs, (unsigned long) buf,
> +                           (unsigned long) size, flags, 0);
> +       put_bpf_raw_tp_regs();
> +       return ret;
>  }
>
>  static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
> --
> 2.17.1
>
