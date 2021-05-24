Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1E38E5D3
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 13:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhEXLve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 07:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhEXLve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 07:51:34 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE3C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 04:50:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id j6so37577382lfr.11
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 04:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xASC3O84pM9r2GeKmJvJYHHRsZGixKYhGJW0hMFnD0A=;
        b=YMkU8KfQ50kctCel48OBKvWjBjwv4GPHNaR1Rktfpkr0NYMCRviwdewn5iWz4UPGnF
         2o0dWKpaOV2rvBV51SkmUzUXYqK7soxzMQEIhZiE1p0L9br2UBhELNAbMlp+wkZGisKd
         AP6/9uzeKucep/D72B4zShBlCNR3c5LfvCe4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xASC3O84pM9r2GeKmJvJYHHRsZGixKYhGJW0hMFnD0A=;
        b=SqmjgU6JQL6A1Qj2GOK6xy8er8qL21Kbr0S0kknKpIokUMSd0L9eTjlx6r/+xGllCp
         x53c0GQad2ZHLwEcWdJKhh4lfKOVOO4ZH8H1EkNaDrjTj2S11Fwdoj2xn2cJSGPq54Im
         A3M9/xzf5ThuZtgQZtLOheUA4SVL9Rdvi8hkrFEsaKCHojDksG7+/rwBzUzGBWa7uHc1
         e4Osvj/hEzeequnlbdXsvxfYnuSbYCf8GUdrOSEZ3BxS5mDUsJ5wzXaYMI/PsP+vCT+4
         uZkWeuR9r2VxFWv2eEerwJApNeKrKVKF8UTCWYlEpRV/Xqx81rnss0BWgNL4Xe7siDEY
         LpnQ==
X-Gm-Message-State: AOAM531MHGKFwGkCG+Z+K9NDtxk74WLFUoweOJdzwd799v5W8RAuO1Jq
        w2hicmugqhV5Wz4UU1+ci6g8AlK+zoESzWa8GQy2NIVTNiswMQ==
X-Google-Smtp-Source: ABdhPJy/cWm/XKkLHqYL8qqSaAZwlmKlgwzMPNN5TqERYBBVpzxZlJYCzg/ieXcm9JsKoYQUJEhjw6dBtqMvCFGiMDY=
X-Received: by 2002:a05:6512:10c8:: with SMTP id k8mr10716229lfg.325.1621857003840;
 Mon, 24 May 2021 04:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 24 May 2021 12:49:52 +0100
Message-ID: <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 May 2021 at 19:55, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> and helpers to operate on it:
> long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> long bpf_timer_del(struct bpf_timer *timer)

I like invoking the callback with a pointer to the map element it was
defined in, since it solves lifetime of the context and user space
introspection of the same. I'm not so sure about being able to put it
into all different kinds of maps, is that really going to be used?

It would be useful if Cong Wang could describe their use case, it's
kind of hard to tell what the end goal is. Should user space be able
to create and arm timers? Or just BPF? In the other thread it seems
like a primitive for waiting on a timer is proposed. Why? It also begs
the question how we would wait on multiple timers.

>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> This is work in progress, but gives an idea on how API will look.
> ---
>  include/linux/bpf.h                           |   1 +
>  include/uapi/linux/bpf.h                      |  25 ++++
>  kernel/bpf/helpers.c                          | 106 +++++++++++++++++
>  kernel/bpf/verifier.c                         | 110 ++++++++++++++++++
>  kernel/trace/bpf_trace.c                      |   2 +-
>  scripts/bpf_doc.py                            |   2 +
>  tools/include/uapi/linux/bpf.h                |  25 ++++
>  .../testing/selftests/bpf/prog_tests/timer.c  |  42 +++++++
>  tools/testing/selftests/bpf/progs/timer.c     |  53 +++++++++
>  9 files changed, 365 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
>  create mode 100644 tools/testing/selftests/bpf/progs/timer.c
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9dc44ba97584..18e09cc0c410 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -312,6 +312,7 @@ enum bpf_arg_type {
>         ARG_PTR_TO_FUNC,        /* pointer to a bpf program function */
>         ARG_PTR_TO_STACK_OR_NULL,       /* pointer to stack or NULL */
>         ARG_PTR_TO_CONST_STR,   /* pointer to a null terminated read-only string */
> +       ARG_PTR_TO_TIMER,       /* pointer to bpf_timer */
>         __BPF_ARG_TYPE_MAX,
>  };
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 418b9b813d65..c95d7854d9fb 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4761,6 +4761,24 @@ union bpf_attr {
>   *             Execute close syscall for given FD.
>   *     Return
>   *             A syscall result.
> + *
> + * long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)

In your selftest the callback has a type (int)(*callback)(struct
bpf_map *map, int *key, struct map_elem *val).

> + *     Description
> + *             Initialize the timer to call given static function.
> + *     Return
> + *             zero
> + *
> + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> + *     Description
> + *             Set the timer expiration N msecs from the current time.
> + *     Return
> + *             zero
> + *
> + * long bpf_timer_del(struct bpf_timer *timer)
> + *     Description
> + *             Deactivate the timer.
> + *     Return
> + *             zero
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -4932,6 +4950,9 @@ union bpf_attr {
>         FN(sys_bpf),                    \
>         FN(btf_find_by_name_kind),      \
>         FN(sys_close),                  \
> +       FN(timer_init),                 \
> +       FN(timer_mod),                  \
> +       FN(timer_del),                  \
>         /* */

How can user space force stopping of timers (required IMO)?

>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -6038,6 +6059,10 @@ struct bpf_spin_lock {
>         __u32   val;
>  };
>
> +struct bpf_timer {
> +       __u64 opaque;
> +};
> +

This might be clear already, but we won't be able to modify the size
of bpf_timer later since it would break uapi, right?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
