Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6DC57E438
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiGVQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiGVQQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:16:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B97140F1;
        Fri, 22 Jul 2022 09:16:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j22so9416460ejs.2;
        Fri, 22 Jul 2022 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97WFVBFeJ/mP7POIyyy1UP0JWOMgZ/bOiCTe1ETU5XI=;
        b=DPr5GbzJ9gljq8DfC08aakia49SnfaLxsujJZQI7oAQIHdY1grFo4OcBO4dxciU+Qa
         Or/8tRV8tnIpJ6L8w0iBpM939aGWIBdUIb2ZNSxQzwAj0uIZ6XE13dGUGQzsNipcg9ms
         tNsO/k+a8prGjijrm4qyOaNWV7VDKznCJNtZD37vsxaAynSdg9lFsqrMGb91IKAuu6tt
         THrcBbNLQrN2V6v1jn3kyOpm7/cv7uoR3GgfFs9r9BnqO4bX4WeoF4WjEVmGvH3fW1Is
         jL+u6LyLUyyWEepxJfwOJF/sXhEbu3kloQstYAVH+wMbj89Qwd4H8WyGvPErw6PHUx0/
         Lbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97WFVBFeJ/mP7POIyyy1UP0JWOMgZ/bOiCTe1ETU5XI=;
        b=k889UcTzbHcOn3s2Tk+dZ7AMEX08HpvqjQdbFp6PTYSjU+RrELOc1PCyZBM1hCd6Dm
         s2oisZKynsN8nYNUYka002cZIAf0FD4g1mDpGRECllmmh0NMmd3Sm12jx+PzhPPxQSb2
         u4Qm4pgMPth7wnHkZ3p8wHqNqTxr8UF9uX62QqD8BjP7C9uL1AxQMLVD+m7yEqZimQW5
         gSrDKHwTHrO1KkyTb3tNqP/5w2YZINZLzIq9x3g0V1ym2UIKNpzi7VQow1BLNLlk8Oa1
         KtuZISiFZ0IHHleRYHQppuH2MwbI8gyWMGMPJ+HqVXW+K0ffFow78Xq2X1FofSHHlCuZ
         D03A==
X-Gm-Message-State: AJIora+6orXxjz7G992ffRTKj9zy4L9Tzx5QpVKydG2xBMA967RA/X2d
        rl+51D2u1CrQqYJQkt4Oq25CGPETsJ5wc9LnpOOVjWO7TH4=
X-Google-Smtp-Source: AGRyM1v1fHCwpN/hlsbBmFOHa0gm/aGOOZHGLRZMX0jdSmOSXL/mCoYZb8NkvX8F2/xv5DnONwmLJbh9lwhOEJ1Cqrg=
X-Received: by 2002:a17:906:9b86:b0:6fe:d37f:b29d with SMTP id
 dd6-20020a1709069b8600b006fed37fb29dmr488369ejc.327.1658506605946; Fri, 22
 Jul 2022 09:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220721153625.1282007-3-benjamin.tissoires@redhat.com> <20220722084556.1342406-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220722084556.1342406-1-benjamin.tissoires@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 22 Jul 2022 09:16:34 -0700
Message-ID: <CAADnVQLypx8Yd7L4GByGNEJaWgg0R6ukNV9hz0ge1+ZdW4mdgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 02/24] bpf/verifier: allow kfunc to read user
 provided context
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Fri, Jul 22, 2022 at 1:46 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> When a kfunc was trying to access data from context in a syscall eBPF
> program, the verifier was rejecting the call.
> This is because the syscall context is not known at compile time, and
> so we need to check this when actually accessing it.
>
> Check for the valid memory access and allow such situation to happen.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v8:
> - fixup comment
> - return -EACCESS instead of -EINVAL for consistency
>
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
> index 7c1e056624f9..c807c5d7085a 100644
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

prog_type check looks a bit odd here.
Can we generalize with
if (!env->ops->convert_ctx_access

In other words any program type that doesn't have ctx rewrites can
use helpers to access ctx fields ?

Also why kfunc only?
It looks safe to allow normal helpers as well.
