Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA75577142
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiGPTsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 15:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiGPTsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 15:48:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D81C101;
        Sat, 16 Jul 2022 12:48:13 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q14so6355838iod.3;
        Sat, 16 Jul 2022 12:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z4ccNBeWVPImDHLuhSMEUl7P2+XfQAkGMxLoWz9oAMs=;
        b=MUcMO0HxCUG8TxgkJwIYYDjnnhga6jwBaNEk+33XIZA/VZBrDlaagvC7/mqfvpZPKY
         JwbKX4IYv+fLX4r6G7vMdsRPWxsAXAWhfBrb/8ILE1ao3wIRSypWUbIsSkOt1/6tO3qq
         d1h8Qqxreamtd2ofvtDs30XdLopmcGPSHmoYV08ZUMywF1/W5sNpQNrKt5HRADzVWGXa
         q40uqgT9rQIAAP/+B4ZsYiZFjkDcPRtejv+Vlq9HXsavSsA6OX+WgqU99QkiJ3J6WUFZ
         iYjqJwqy66cujVD2cX7q7sIrziw3eYnY4ahHXDU6hmiDGCM+NJ7l8s89orPQmgEFUmO9
         jgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z4ccNBeWVPImDHLuhSMEUl7P2+XfQAkGMxLoWz9oAMs=;
        b=8MXIKCegq2cXSg7b7hH/gxr59tjp6BEaeu7zvC9rymRabXBV/3hi/jj4u70TdSiBFh
         WUrBaS1EhoLF4MnKmTAY4ELG16Lsw/0ggoRy74sWqoGvzG3nLDZGdsO846eSHLTxDwDQ
         Ao7dSNN6Eayw/g5q87+vL/dDx9A8UAXi5bDRxyJyj4duQ3WGPutMNaMF4pfMPbBdqZ+5
         9Mnu4n4dG2WgbFQjm8RoeEEVUqtOjPhZOrnwDVqnvicJNMchvFCGDWoB7W4Jt/LKy2By
         x+h99dQSYf4QlfwxbpYYowpAcnCtjflLqtVagTiLfK2D3Rrkda3junlPxBJF7MJQ995g
         68cw==
X-Gm-Message-State: AJIora/vUtQ7BUE7SumghXTLduI6qpyTfSlZtQ/lQ/wPFJxunWzCGOxG
        f/fGeOy5joQiDdxBraGxXtEG57YsOedHu8FB74U=
X-Google-Smtp-Source: AGRyM1ubmKtb+ja3MY58pjJ8vWMuna7mCIPAwIZwJhkaPNF9GrWbontMdfo8GJHALPm0jw5FkTNANCvte0Mvl9WC5Nw=
X-Received: by 2002:a05:6602:2e8d:b0:64f:b683:c70d with SMTP id
 m13-20020a0566022e8d00b0064fb683c70dmr9534049iow.62.1658000892752; Sat, 16
 Jul 2022 12:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com> <20220712145850.599666-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-3-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 16 Jul 2022 21:47:34 +0200
Message-ID: <CAP01T766-JGd=6twHYhWDmjVBk7wuuvWMLFyDZ656fka6GW8Cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 02/23] bpf/verifier: allow kfunc to read user
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

On Tue, 12 Jul 2022 at 17:02, Benjamin Tissoires
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
> new in v6
> ---
>  kernel/bpf/verifier.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 328cfab3af60..f6af57a84247 100644
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
> @@ -5223,6 +5225,19 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
>                                 env,
>                                 regno, reg->off, access_size,
>                                 zero_size_allowed, ACCESS_HELPER, meta);
> +       case PTR_TO_CTX:
> +               /* in case of a kfunc called in a program of type SYSCALL, the context is
> +                * user supplied, so not computed statically.
> +                * Dynamically check it now
> +                */
> +               if (prog_type == BPF_PROG_TYPE_SYSCALL && meta && meta->is_kfunc) {
> +                       enum bpf_access_type access_t = meta->raw_mode ? BPF_WRITE : BPF_READ;

small nit: _t suffix is used for types, so you could probably rename
this. maybe atype?

> +
> +                       return check_mem_access(env, env->insn_idx, regno, access_size, BPF_B,
> +                                               access_t, -1, false);

If I read the code correctly, this makes the max_ctx_offset of prog
access_size + 1 (off + size_to_bytes(BPF_B)), which is 1 more than the
actual size being accessed.

This also messes up check_helper_mem_access when it allows NULL, 0
pair to pass (because check is against actual size + 1). We do allow
passing NULL when size is 0 for kfuncs (see zero_size_allowed is true
in check_mem_size_reg), so your hid_hw_request function is missing
that NULL check for buf too.

In the selftest that checks for failure in loading
+ bpf_kfunc_call_test_mem_len_pass1(&args->data, sizeof(*args) + 1);
so it will still fail with just sizeof(*args).

Also please add coverage for this case in the next version.

> +               }
> +
> +               fallthrough;
>         default: /* scalar_value or invalid ptr */
>                 /* Allow zero-byte read from NULL, regardless of pointer type */
>                 if (zero_size_allowed && access_size == 0 &&
> @@ -5335,6 +5350,7 @@ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state
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
