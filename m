Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43302273F06
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIVJ5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIVJ5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:57:07 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97A7C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:57:06 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w16so20381328oia.2
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=stm1xuTsqpLJMTv8SV3qYFXEHsBh8qCH06mfO4/ZLJM=;
        b=X3zLDnpTHxVNpnSeioEQ5e0Orn5gI12nN4tFUjfecIgB43UkZldAz6W+Kxsm18FaeP
         xjDoFe3L7c6VWnvwBBcFGm+2EuKeiwAtrabjeGxv0irBwcEBoeApegLilDY79Z3aKtJU
         HJi9A5lKCrSrRaWJq3LcCV+O92fyedNWtCRPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=stm1xuTsqpLJMTv8SV3qYFXEHsBh8qCH06mfO4/ZLJM=;
        b=rgNeE1AxSYMZR5PrNYt4Ki4dSTwDkj6/aBJa+CcuRtl3ieK0dxJBCcyEzvl3hXXCsW
         piU562Gy7r4awL1GJscgo6HtZ0Ete6Hvt1MQsi2x50waDdUGk0FtgEhRfWHXly6KV4xV
         YZ0pp0oJMEM7XJ7xW/wqKyWDL91Mcsq9+r4lA4rQyMV3PufdzQ30nyM6zXeOqPr3U0I5
         siE9CcrzWiOx5wGQahPIffjroeTQvT18e+76ciboX2mjoTUUwYCySdaj7grRUEymFeJR
         3Jh6NAb8fyAqpLJYn1ICTumFygs3iJ3wfmUyi0ePxDZS8udEBHh71zWYQ5ValwOgNirp
         YomA==
X-Gm-Message-State: AOAM530xNUxs/EH8H7d5xNSG3DyNCeHiHzUTAe45HU3sC4aY8jpn4vnl
        Rm8S+V19qd7KajarId2OM8U/+yahbgcgsa33yo+VYg==
X-Google-Smtp-Source: ABdhPJwRZ32H4B9USBBtsRdRpm5blzRVJ7B2k1rWTi/flHu1SbFFYQabeAY1VTSYqts8hVeWZDSqnDoT4bY6LPq5Bic=
X-Received: by 2002:aca:3087:: with SMTP id w129mr2020496oiw.102.1600768626105;
 Tue, 22 Sep 2020 02:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070415.1916194-1-kafai@fb.com>
In-Reply-To: <20200922070415.1916194-1-kafai@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 22 Sep 2020 10:56:55 +0100
Message-ID: <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 01/11] bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
>
> check_reg_type() checks whether a reg can be used as an arg of a
> func_proto.  For PTR_TO_BTF_ID, the check is actually not
> completely done until the reg->btf_id is pointing to a
> kernel struct that is acceptable by the func_proto.
>
> Thus, this patch moves the btf_id check into check_reg_type().
> The compatible_reg_types[] usage is localized in check_reg_type() now.
>
> The "if (!btf_id) verbose(...); " is also removed since it won't happen.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  kernel/bpf/verifier.c | 65 +++++++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 30 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 15ab889b0a3f..3ce61c412ea0 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4028,20 +4028,29 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
>         [__BPF_ARG_TYPE_MAX]            = NULL,
>  };
>
> -static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> -                         const struct bpf_reg_types *compatible)
> +static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
> +                         enum bpf_arg_type arg_type,
> +                         const struct bpf_func_proto *fn)

How about (env, regno, arg_type, expected_btf_id) instead? Otherwise
implementing sockmap update from iter with your current approach is
difficult for me. See resolve_map_arg_type, which now needs to resolve
expected_bpf_id.

See below for what I mean:

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2468533bc4a1..3a238a295c37 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3931,7 +3931,8 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)

 static int resolve_map_arg_type(struct bpf_verifier_env *env,
                  const struct bpf_call_arg_meta *meta,
-                 enum bpf_arg_type *arg_type)
+                 enum bpf_arg_type *arg_type,
+                 u32 **expected_btf_id)
 {
     if (!meta->map_ptr) {
         /* kernel subsystem misconfigured verifier */
@@ -3943,7 +3944,8 @@ static int resolve_map_arg_type(struct
bpf_verifier_env *env,
     case BPF_MAP_TYPE_SOCKMAP:
     case BPF_MAP_TYPE_SOCKHASH:
         if (*arg_type == ARG_PTR_TO_MAP_VALUE) {
-            *arg_type = ARG_PTR_TO_SOCKET;
+            *arg_type = ARG_PTR_TO_BTF_ID_SOCK_COMMON;
+            *expected_btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON];
         } else {
             verbose(env, "invalid arg_type for sockmap/sockhash\n");
             return -EINVAL;
@@ -4044,11 +4046,9 @@ static const struct bpf_reg_types
*compatible_reg_types[] = {
     [__BPF_ARG_TYPE_MAX]        = NULL,
 };

-static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
-              enum bpf_arg_type arg_type,
-              const struct bpf_func_proto *fn)
+static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
+              enum bpf_arg_type arg_type, u32 *expected_btf_id)
 {
-    u32 regno = BPF_REG_1 + arg;
     struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
     enum bpf_reg_type expected, type = reg->type;
     const struct bpf_reg_types *compatible;
@@ -4077,8 +4077,6 @@ static int check_reg_type(struct
bpf_verifier_env *env, u32 arg,

 found:
     if (type == PTR_TO_BTF_ID) {
-        u32 *expected_btf_id = fn->arg_btf_id[arg];
-
         if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
                       *expected_btf_id)) {
             verbose(env, "R%d is of type %s but %s is expected\n",
@@ -4105,6 +4103,7 @@ static int check_func_arg(struct
bpf_verifier_env *env, u32 arg,
     struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
     enum bpf_arg_type arg_type = fn->arg_type[arg];
     enum bpf_reg_type type = reg->type;
+    u32 *expected_btf_id = fn->arg_btf_id[arg];
     int err = 0;

     if (arg_type == ARG_DONTCARE)
@@ -4132,7 +4131,7 @@ static int check_func_arg(struct
bpf_verifier_env *env, u32 arg,
     if (arg_type == ARG_PTR_TO_MAP_VALUE ||
         arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
         arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
-        err = resolve_map_arg_type(env, meta, &arg_type);
+        err = resolve_map_arg_type(env, meta, &arg_type, &expected_btf_id);
         if (err)
             return err;
     }
@@ -4143,7 +4142,7 @@ static int check_func_arg(struct
bpf_verifier_env *env, u32 arg,
          */
         goto skip_type_check;

-    err = check_reg_type(env, arg, arg_type, fn);
+    err = check_reg_type(env, regno, arg_type, expected_btf_id);
     if (err)
         return err;

-- 
2.25.1



--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
