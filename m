Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7544D41B6E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 07:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbfFLFAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 01:00:50 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33868 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730371AbfFLFAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 01:00:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so5545198qkt.1;
        Tue, 11 Jun 2019 22:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JcECTazd5+X/IE6p/WVmtR3Fgvm89aHsPRQggGuu+EY=;
        b=J7ArH3Yt5lE7WbbXKpzMBFQvvxWahnl6SYnUwh7WVhJSOU+0x7GkGPfoaJm0+kElyu
         fTfKUePfYdL9ZVFkAJqfdWlVE6myate/Y98LCVxs6AT6YadiiTGvA+JNxQ0G3k/N9P5/
         Vr57/3482TKjG/g5yaZiMXFlQAXbNLc0PbC0Cnsz/9fkfEDxoNI4rSnH5h/TdHWRgzaw
         WA2QNpcO9HQE9p9Al3VLJszX9q+uXmyBZaYmeLKFsGqmt1ISOE0PPMQXDroqxyp4nxz2
         VVHO02PEFzY3hGYChvsFE5rDVgjSN/Is4u1n59wWCn+i7EeInTmuSQ5xb0NI87BvV2Sn
         qMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JcECTazd5+X/IE6p/WVmtR3Fgvm89aHsPRQggGuu+EY=;
        b=k5MNsg//WYCmgo2y4/hc25vPtI0m7eM+HFUc/ayDnN81raIs+IYu/HKIr6UHyG+fyL
         wUcPo5d7+2AlZOfWbyELDe0ff3fTOu4rYJjMHZpeoOhhgAuZ17VAXZJ2uR4Da7K15HPu
         PqJj13iVYDiFACF6GujyGjywmVcqi52NAVJwDqPRg8Y1rwAoJkXexR/DrLbFW+JeT8SW
         THCcTuTrcefL8tQ5vmjy2jc38ZRasSJBByFchZSt3tPYfYBZezHDKp+lLztAPprIEix/
         DHFs55Kn5Rbu9zBluZusXb4Bd9xI66/rl+w+izZgNOqgsSdNcZf1v93vQQghGHh39Gah
         rwFw==
X-Gm-Message-State: APjAAAWnbm+hvVz0L6vcLFhwkgADay6X8GRGO8z1va7MSpljtxlK4rkY
        cOnEvXF+iagAetbo+RF7ZvCxwt3CzT4Z8aQueAa6Up0S
X-Google-Smtp-Source: APXvYqyC0fC+EdfW+meSAw2yk+md34AM6YEXJKAns3+1/KZEabHmLVBscO3cdUCGZRmWc1S9RURArDVosM+j55nVMKc=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr34640304qkc.241.1560315648800;
 Tue, 11 Jun 2019 22:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190611215304.28831-1-mmullins@fb.com>
In-Reply-To: <20190611215304.28831-1-mmullins@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Jun 2019 22:00:37 -0700
Message-ID: <CAEf4BzZ_Gypm32mSnrpGWw_U9q8LfTn7hag-p-LvYKVNkFdZGw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
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

On Tue, Jun 11, 2019 at 8:48 PM Matt Mullins <mmullins@fb.com> wrote:
>
> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
> they do not increment bpf_prog_active while executing.
>
> This enables three levels of nesting, to support
>   - a kprobe or raw tp or perf event,
>   - another one of the above that irq context happens to call, and
>   - another one in nmi context
> (at most one of which may be a kprobe or perf event).
>
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
> Signed-off-by: Matt Mullins <mmullins@fb.com>
> ---

LGTM, minor nit below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> v1->v2:
>   * reverse-Christmas-tree-ize the declarations in bpf_perf_event_output
>   * instantiate err more readably
>
> I've done additional testing with the original workload that hit the
> irq+raw-tp reentrancy problem, and as far as I can tell, it's still
> solved with this solution (as opposed to my earlier per-map-element
> version).
>
>  kernel/trace/bpf_trace.c | 100 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 84 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f92d6ad5e080..1c9a4745e596 100644
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
> @@ -442,24 +440,50 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
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
> +       int nest_level = this_cpu_inc_return(bpf_trace_nest_level);
>         struct perf_raw_record raw = {
>                 .frag = {
>                         .size = size,
>                         .data = data,
>                 },
>         };
> +       struct perf_sample_data *sd;
> +       int err;
>
> -       if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
> -               return -EINVAL;
> +       if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(sds->sds))) {
> +               err = -EBUSY;
> +               goto out;
> +       }
> +
> +       sd = &sds->sds[nest_level - 1];
> +
> +       if (unlikely(flags & ~(BPF_F_INDEX_MASK))) {
> +               err = -EINVAL;
> +               goto out;
> +       }

Feel free to ignore, but just stylistically, given this check doesn't
depend on sd, I'd move it either to the very top or right after
`nest_level > ARRAY_SIZE(sds->sds)` check, so that all the error
checking is grouped without interspersed assignment.

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
> @@ -822,16 +846,48 @@ pe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
> @@ -848,12 +904,18 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
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
> @@ -868,11 +930,17 @@ static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
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
