Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C889157D4B2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiGUUP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiGUUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:15:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F183B951;
        Thu, 21 Jul 2022 13:15:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z132so2265647iof.0;
        Thu, 21 Jul 2022 13:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdlpYHvySLWZI9PuVVkLLZBH3yjydjUTeDSjiCRAPjg=;
        b=Emb6nVw/XsXfIS2rg5l909a2QlHcjhWE6BvXTfg7yFiAz4PCoYNtH3W2EfmQ4FRE6y
         2pzUglyR5engfI0A8axVQUlrS837XKYH84LVFJoqlPal8GV8hRSl1uceuwRPAUHUgPdy
         YdUPzSnnoxSEC9oOOZbIl3zFV+fqFjUsnUcT+dB6Q23AD3q3yumtw9WPxv775fB/3DTs
         WP6TpLle3aNXqrUP0buCa+694rc1cDagQd5A5fMaR3rxaQ5Z3XvvMiys9OjY08KU3ibQ
         fv+sLC6OhAjVZbB5xqlp11/NKOthbaMzt6GxAjDsl5tVgh2KfWVpBSKKAhMwVHs3Nruw
         vEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdlpYHvySLWZI9PuVVkLLZBH3yjydjUTeDSjiCRAPjg=;
        b=fPCPZykZTDkSU6X33lVLNf5JqCp+EaqG4z7JVOPsNnyn9DiEOIEsWNSXYVXZsYkzHr
         gjqLRID23NtztgrJkrOg+ITkKqnQwKX6f5/5n/Ij/TPA6QEGw/c3AH40FfcDhFVO5L6o
         1BXCvLmWurG4CD1Qd0rIuvWGCnGI0NYoTv4f8efFESHoFsc6++O96omjiQFIPLAoPBBe
         whjT4v2ReL+gSlgc0z9qiM6mxaPyHUBirEjWwYEVDwYogTEic+6pQUd3VGrTU49dx+ca
         uT6wRPm6x4zyxfBzpaqWhxTJUGoGdlEN/Fc3cS+ilnBoGc+m6RjITsJDdgosoF/m8UZt
         /JbQ==
X-Gm-Message-State: AJIora+5Q3NY5E71VIOzYuRGRU31+ApiBZuLv7/FZ3huOMjBbrWBugF1
        OaDok3IcCmz786SbTlzzImPdoX1JZp0BkSYmgQhTsjX2aPk=
X-Google-Smtp-Source: AGRyM1s1dL2pvG1uxUsYYIrkYW/FJ9oEkL6wAsTSGF52krk09y5ouOvFZX9RoHB/cPeHZ2FTRKUfl2LlvjYLHkJU5/M=
X-Received: by 2002:a05:6602:150c:b0:67c:149b:a349 with SMTP id
 g12-20020a056602150c00b0067c149ba349mr74750iow.168.1658434550268; Thu, 21 Jul
 2022 13:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com> <20220721153625.1282007-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-3-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 21 Jul 2022 22:15:14 +0200
Message-ID: <CAP01T746d18QjJH1pRaq5Wy2QtrXXKhaJge8sB=q1rNtqjTntA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 02/24] bpf/verifier: allow kfunc to read user
 provided context
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 at 17:36, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> When a kfunc was trying to access data from context in a syscall eBPF
> program, the verifier was rejecting the call.
> This is because the syscall context is not known at compile time, and
> so we need to check this when actually accessing it.
>
> Check for the valid memory access and allow such situation to happen.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>

LGTM, with just a couple more nits.
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

> changes in v7:
> - renamed access_t into atype
> - allow zero-byte read
> - check_mem_access() to the correct offset/size
>
> new in v6
> ---
>  kernel/bpf/verifier.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7c1e056624f9..d5fe7e618c52 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -248,6 +248,7 @@ struct bpf_call_arg_meta {
>         struct bpf_map *map_ptr;
>         bool raw_mode;
>         bool pkt_access;
> +       bool is_kfunc;
>         u8 release_regno;
>         int regno;
>         int access_size;
> @@ -5170,6 +5171,7 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>                                    struct bpf_call_arg_meta *meta)
>  {
>         struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
> +       enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
>         u32 *max_access;
>
>         switch (base_type(reg->type)) {
> @@ -5223,6 +5225,24 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>                                 env,
>                                 regno, reg->off, access_size,
>                                 zero_size_allowed, ACCESS_HELPER, meta);
> +       case PTR_TO_CTX:
> +               /* in case of a kfunc called in a program of type SYSCALL, the context is
> +                * user supplied, so not computed statically.
> +                * Dynamically check it now
> +                */
> +               if (prog_type == BPF_PROG_TYPE_SYSCALL && meta && meta->is_kfunc) {
> +                       enum bpf_access_type atype = meta->raw_mode ? BPF_WRITE : BPF_READ;
> +                       int offset = access_size - 1;
> +
> +                       /* Allow zero-byte read from NULL or PTR_TO_CTX */

This will not be handling the case for NULL, only for kfunc(ptr_to_ctx, 0)
A null pointer has its reg->type as scalar, so it will be handled by
the default case.

> +                       if (access_size == 0)
> +                               return zero_size_allowed ? 0 : -EINVAL;

We should use -EACCES, just to be consistent.

> +
> +                       return check_mem_access(env, env->insn_idx, regno, offset, BPF_B,
> +                                               atype, -1, false);
> +               }
> +
> +               fallthrough;
>         default: /* scalar_value or invalid ptr */
>                 /* Allow zero-byte read from NULL, regardless of pointer type */
>                 if (zero_size_allowed && access_size == 0 &&
> @@ -5335,6 +5355,7 @@ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state
>         WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
>
>         memset(&meta, 0, sizeof(meta));
> +       meta.is_kfunc = true;
>
>         if (may_be_null) {
>                 saved_reg = *mem_reg;
> --
> 2.36.1
>
