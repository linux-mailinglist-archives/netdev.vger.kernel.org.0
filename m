Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA1D481B
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfJKTDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 15:03:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42915 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbfJKTDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 15:03:02 -0400
Received: by mail-qt1-f195.google.com with SMTP id w14so15329192qto.9;
        Fri, 11 Oct 2019 12:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mME9Itb9y9+1/P0y1IBu53MdsUHIRJGxQd4n0PT1UY=;
        b=GmyghzsmtlB5fKIA5XmwMHPgr5XUGfXNpy/grkS04d59JslPyQbx3ZoHPYIH9UEksH
         wdWcbr4J/pUMfyFjTr8E4V+cGG9uQTTuQyzUFGlLy5hhZbdbN+4aHwZeIyCmHwioeiHH
         N+d5UUFilZtI1285CWCvjXE4r8zSNrBV5kEkPUZ5oBTKa5b76KKswZmZcONq0Z6JoAUJ
         mYs8KXykrXY5OkPZnrvUUOwTmbr2Kp4Pmw+HC3Y6pqOaZ4OVKrRs2vLSwrNQnUdDB0q1
         a24Sjc6tjNxO07N4BLO5LJKYRf8Dqu7z/4J/zZelmyvHOGAvB/V7fQRDxPbxqcEpvD4J
         0UWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mME9Itb9y9+1/P0y1IBu53MdsUHIRJGxQd4n0PT1UY=;
        b=CRjlITR0YOawaAWP7okrtUjfjzQd4ux/KMgE9g/5fJHjHNhJrlu9n6ziyet6SWloO9
         /OpVEzaQuAZcORrGM4FUZ/RCDRD1M1QxI47a86f3EcE6EUX2Ud/nTfhUdiQL+fGQ1kMV
         0p1IyX+nAxtwniyaKX92rauV88Z3fJCSUH5sNmzaGuR4INRE7tybK5Za0rJ0a8C+/TVo
         wN59eMCedPzhjcNQQ5aw5VTziEDv+BVzML9HvXBOWMNo5wgn8GOioMw6+JzXGhrrUMif
         o+8XmPC+ufZHbUc/1k6oVLCaiV4birSM7K0+7H33b6UtP+s7O5D1Fv/kWgAQjHxyHuE2
         bqwg==
X-Gm-Message-State: APjAAAWHyZHSyQRgWgnwus5eHu5l9OjVvviVJ6ZRuNs/10yiwKe8awJk
        uc5UosFULIYAWcXh3tb4gj2K7I8pYsnGZ3IarjQ=
X-Google-Smtp-Source: APXvYqxOsc7CIrr5L6Yn5Y7n+VJ1NnBrD2VIdf9RbM4yGSr9ZR4wl+1zBB7qFpkDZZfz5SLqsoBb7BiDNJzhkCM43wE=
X-Received: by 2002:a0c:f885:: with SMTP id u5mr17234605qvn.247.1570820581167;
 Fri, 11 Oct 2019 12:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-11-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-11-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 12:02:50 -0700
Message-ID: <CAEf4BzbmE_ADjjhu-+mLkQN_5HD6Azhrb-VuprAaoqxP1bb3OQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/12] bpf: check types of arguments passed
 into helpers
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:15 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce new helper that reuses existing skb perf_event output
> implementation, but can be called from raw_tracepoint programs
> that receive 'struct sk_buff *' as tracepoint argument or
> can walk other kernel data structures to skb pointer.
>
> In order to do that teach verifier to resolve true C types
> of bpf helpers into in-kernel BTF ids.
> The type of kernel pointer passed by raw tracepoint into bpf
> program will be tracked by the verifier all the way until
> it's passed into helper function.
> For example:
> kfree_skb() kernel function calls trace_kfree_skb(skb, loc);
> bpf programs receives that skb pointer and may eventually
> pass it into bpf_skb_output() bpf helper which in-kernel is
> implemented via bpf_skb_event_output() kernel function.
> Its first argument in the kernel is 'struct sk_buff *'.
> The verifier makes sure that types match all the way.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h            | 18 ++++++---
>  include/uapi/linux/bpf.h       | 27 +++++++++++++-
>  kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 44 ++++++++++++++--------
>  kernel/trace/bpf_trace.c       |  4 ++
>  net/core/filter.c              | 15 +++++++-
>  tools/include/uapi/linux/bpf.h | 27 +++++++++++++-
>  7 files changed, 180 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6edfe50f1c2c..d3df073f374a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -213,6 +213,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_INT,         /* pointer to int */
>         ARG_PTR_TO_LONG,        /* pointer to long */
>         ARG_PTR_TO_SOCKET,      /* pointer to bpf_sock (fullsock) */
> +       ARG_PTR_TO_BTF_ID,      /* pointer to in-kernel struct */
>  };
>
>  /* type of values returned from helper functions */
> @@ -235,11 +236,17 @@ struct bpf_func_proto {
>         bool gpl_only;
>         bool pkt_access;
>         enum bpf_return_type ret_type;
> -       enum bpf_arg_type arg1_type;
> -       enum bpf_arg_type arg2_type;
> -       enum bpf_arg_type arg3_type;
> -       enum bpf_arg_type arg4_type;
> -       enum bpf_arg_type arg5_type;
> +       union {
> +               struct {
> +                       enum bpf_arg_type arg1_type;
> +                       enum bpf_arg_type arg2_type;
> +                       enum bpf_arg_type arg3_type;
> +                       enum bpf_arg_type arg4_type;
> +                       enum bpf_arg_type arg5_type;
> +               };
> +               enum bpf_arg_type arg_type[5];
> +       };
> +       u32 *btf_id; /* BTF ids of arguments */

are you trying to save memory with this? otherwise not sure why it's
not just `u32 btf_id[5]`? Even in that case it will save at most 12
bytes (and I haven't even check alignment padding and stuff). So
doesn't seem worth it?

>  };
>
>  /* bpf_context is intentionally undefined structure. Pointer to bpf_context is
> @@ -765,6 +772,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                       const struct btf_type *t, int off, int size,
>                       enum bpf_access_type atype,
>                       u32 *next_btf_id);
> +u32 btf_resolve_helper_id(struct bpf_verifier_log *log, void *, int);
>
>  #else /* !CONFIG_BPF_SYSCALL */
>  static inline struct bpf_prog *bpf_prog_get(u32 ufd)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 3bb2cd1de341..b0454440186f 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2751,6 +2751,30 @@ union bpf_attr {
>   *             **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
>   *
>   *             **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> + *
> + * int bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
> + *     Description
> + *             Write raw *data* blob into a special BPF perf event held by
> + *             *map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
> + *             event must have the following attributes: **PERF_SAMPLE_RAW**
> + *             as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
> + *             **PERF_COUNT_SW_BPF_OUTPUT** as **config**.
> + *
> + *             The *flags* are used to indicate the index in *map* for which
> + *             the value must be put, masked with **BPF_F_INDEX_MASK**.
> + *             Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
> + *             to indicate that the index of the current CPU core should be
> + *             used.
> + *
> + *             The value to write, of *size*, is passed through eBPF stack and
> + *             pointed by *data*.

typo? pointed __to__ by *data*?

> + *
> + *             *ctx* is a pointer to in-kernel sutrct sk_buff.
> + *
> + *             This helper is similar to **bpf_perf_event_output**\ () but
> + *             restricted to raw_tracepoint bpf programs.

nit: with BTF type tracking enabled?

> + *     Return
> + *             0 on success, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2863,7 +2887,8 @@ union bpf_attr {
>         FN(sk_storage_get),             \
>         FN(sk_storage_delete),          \
>         FN(send_signal),                \
> -       FN(tcp_gen_syncookie),
> +       FN(tcp_gen_syncookie),          \
> +       FN(skb_output),
>

[...]

> @@ -4072,21 +4091,16 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>
>         meta.func_id = func_id;
>         /* check args */
> -       err = check_func_arg(env, BPF_REG_1, fn->arg1_type, &meta);
> -       if (err)
> -               return err;
> -       err = check_func_arg(env, BPF_REG_2, fn->arg2_type, &meta);
> -       if (err)
> -               return err;
> -       err = check_func_arg(env, BPF_REG_3, fn->arg3_type, &meta);
> -       if (err)
> -               return err;
> -       err = check_func_arg(env, BPF_REG_4, fn->arg4_type, &meta);
> -       if (err)
> -               return err;
> -       err = check_func_arg(env, BPF_REG_5, fn->arg5_type, &meta);
> -       if (err)
> -               return err;
> +       for (i = 0; i < 5; i++) {
> +               if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID) {
> +                       if (!fn->btf_id[i])
> +                               fn->btf_id[i] = btf_resolve_helper_id(&env->log, fn->func, 0);

bug: 0 -> i  :)



> +                       meta.btf_id = fn->btf_id[i];
> +               }
> +               err = check_func_arg(env, BPF_REG_1 + i, fn->arg_type[i], &meta);
> +               if (err)
> +                       return err;
> +       }
>

[...]
