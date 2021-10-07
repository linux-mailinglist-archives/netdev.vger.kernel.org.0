Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031A2425D2F
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241512AbhJGU0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232278AbhJGU0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8289F61248;
        Thu,  7 Oct 2021 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633638248;
        bh=i2ENI6ev+4ytBDtCA52TOEUhotS1o52ohxJfoBwmq/Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b3JJwN0coq3swTjTLe7kViINmeSbgQZ8hsOkAxsuVYB9z5er/jytsN4GYVDzvzeLa
         /iRJiUM7fELYLn/HIgAAF+JVf7wysdzptFTXqLQfBfJ/5llysSJ8HWGigZ82GFojSw
         MRELTuCpwpvuf/JORvbI6CdWEuZ6Cq5ltPI2SsiE/PK3oi+Er6e2Ap8nWlKm5GRfuJ
         tItfmqwsXv7gtFmaibeXmx9poPFc9mo/vvjgFXuMdMetJIKLboIKgOspn7tvMzNNO9
         NgYh4c71E4x18T3vlFNrratsBY4E2RfA1ZoNL2TGxSuz21+ocR47B0gMa707Pu+Zae
         lLICZydLa5j6Q==
Received: by mail-lf1-f51.google.com with SMTP id i24so28424310lfj.13;
        Thu, 07 Oct 2021 13:24:08 -0700 (PDT)
X-Gm-Message-State: AOAM5309EO5rVeHEFMpSCT27RT9TQKTWTV+mMz9cA9LtAYv7uDgYLH5n
        72C1DdPSMmRb3RkYuH/pTZ/2btfQYq7niKexiJs=
X-Google-Smtp-Source: ABdhPJwnR4mn5NImFQklOP3SJuU83TSGM1YNG/ialtZugLnVMz4Hprzyx6PX44gq5nxOjUWcYNRHdgwwwxazfwoPN5Y=
X-Received: by 2002:a2e:3907:: with SMTP id g7mr6852603lja.285.1633638246444;
 Thu, 07 Oct 2021 13:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-2-memxor@gmail.com>
In-Reply-To: <20211006002853.308945-2-memxor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 7 Oct 2021 13:23:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4NYBZ40h5Wni0jjNOWcq5+NkyO+XMWn7NWVqXTo=qScg@mail.gmail.com>
Message-ID: <CAPhsuW4NYBZ40h5Wni0jjNOWcq5+NkyO+XMWn7NWVqXTo=qScg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/6] bpf: Add bpf_kallsyms_lookup_name helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> This helper allows us to get the address of a kernel symbol from inside
> a BPF_PROG_TYPE_SYSCALL prog (used by gen_loader), so that we can
> relocate weak and typeless ksym vars.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

LGTM.

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 14 ++++++++++++++
>  kernel/bpf/syscall.c           | 24 ++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
>  4 files changed, 53 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index d604c8251d88..17206aae329d 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2107,6 +2107,7 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
>  extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
>  extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
>  extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
> +extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
>
>  const struct bpf_func_proto *tracing_prog_func_proto(
>    enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6fc59d61937a..bbd0a3f4e5f6 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4909,6 +4909,19 @@ union bpf_attr {
>   *     Return
>   *             The number of bytes written to the buffer, or a negative error
>   *             in case of failure.
> + *
> + * long bpf_kallsyms_lookup_name(const char *name, int name_sz, int flags, u64 *res)
> + *     Description
> + *             Get the address of a kernel symbol, returned in *res*. *res* is
> + *             set to 0 if the symbol is not found.
> + *     Return
> + *             On success, zero. On error, a negative value.
> + *
> + *             **-EINVAL** if *flags* is not zero.
> + *
> + *             **-EINVAL** if string *name* is not the same size as *name_sz*.
> + *
> + *             **-ENOENT** if symbol is not found.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5089,6 +5102,7 @@ union bpf_attr {
>         FN(task_pt_regs),               \
>         FN(get_branch_snapshot),        \
>         FN(trace_vprintk),              \
> +       FN(kallsyms_lookup_name),       \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4e50c0bfdb7d..073ca9ebe58b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4753,6 +4753,28 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
> +{
> +       if (flags)
> +               return -EINVAL;
> +
> +       if (name_sz <= 1 || name[name_sz - 1])
> +               return -EINVAL;
> +
> +       *res = kallsyms_lookup_name(name);
> +       return *res ? 0 : -ENOENT;
> +}
> +
> +const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
> +       .func           = bpf_kallsyms_lookup_name,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_MEM,
> +       .arg2_type      = ARG_CONST_SIZE,
> +       .arg3_type      = ARG_ANYTHING,
> +       .arg4_type      = ARG_PTR_TO_LONG,
> +};
> +
>  static const struct bpf_func_proto *
>  syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -4763,6 +4785,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_btf_find_by_name_kind_proto;
>         case BPF_FUNC_sys_close:
>                 return &bpf_sys_close_proto;
> +       case BPF_FUNC_kallsyms_lookup_name:
> +               return &bpf_kallsyms_lookup_name_proto;
>         default:
>                 return tracing_prog_func_proto(func_id, prog);
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 6fc59d61937a..bbd0a3f4e5f6 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4909,6 +4909,19 @@ union bpf_attr {
>   *     Return
>   *             The number of bytes written to the buffer, or a negative error
>   *             in case of failure.
> + *
> + * long bpf_kallsyms_lookup_name(const char *name, int name_sz, int flags, u64 *res)
> + *     Description
> + *             Get the address of a kernel symbol, returned in *res*. *res* is
> + *             set to 0 if the symbol is not found.
> + *     Return
> + *             On success, zero. On error, a negative value.
> + *
> + *             **-EINVAL** if *flags* is not zero.
> + *
> + *             **-EINVAL** if string *name* is not the same size as *name_sz*.
> + *
> + *             **-ENOENT** if symbol is not found.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5089,6 +5102,7 @@ union bpf_attr {
>         FN(task_pt_regs),               \
>         FN(get_branch_snapshot),        \
>         FN(trace_vprintk),              \
> +       FN(kallsyms_lookup_name),       \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> --
> 2.33.0
>
