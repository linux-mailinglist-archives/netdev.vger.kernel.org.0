Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE816BF555
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 23:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCQWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 18:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCQWtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 18:49:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043FF77983;
        Fri, 17 Mar 2023 15:49:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z21so26012378edb.4;
        Fri, 17 Mar 2023 15:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679093390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzAO5IY3/07KnMsZG7NvPgJuLLx15i6akv5YrhLltW8=;
        b=UTCazEE7D5ltA48DksI6eZ3zH8cDEpDp04+ZE6vMQf7slhp5G98HFbQpekRlO96Uy/
         MmJkSl44f/DTYrS0JJW/blxjq6cemMzktUOlhRKPaKNlihYf+ZZ6lyzCUmJgtkCvuKcn
         SUkuLV9wVOrRqNVBSd97uRBrR8HUbwQWlZ7YORep7yG35sK+O/VutyAUqgOKoh1oAlOg
         9OJJfA0sMFxUGwI1Nzut4c3IJLE3AV3lcVkNVXd0oZcQlX4zMLq/s5A3gT5oJx+Kw3Ak
         ocwkw1DBWU23fw9dk9ArDStybXUZ1nz4wMloyiSlN3Wld/Vwz/NN7aYZEZT+yQbry2C5
         q2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679093390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzAO5IY3/07KnMsZG7NvPgJuLLx15i6akv5YrhLltW8=;
        b=USLsOm2AkdzGAa574B88C1v+NjWzNJ305/V8cyqC5z7HZGxfKxZ5NwYnTPdO1D5tJ9
         GA3C8cDnL4rr1EJm3/G4EWjOQrrT7Bf7EM9j6h1m3fdtX5PL9daLd5crVpU63+LYJRDs
         zhcH7UnVx2XKeiE+44/kgTnylk3KJklnYMf8QfZWePuVAaf0gf9yDG35GJaENhsfDkRX
         k+dZ1jg59bF5gLy/4IgL71KoU+OY7ui4M3tjkUQI4Ug4Zf/1W1oWyp1V3kzX9gDpT70k
         psJgxcyCk+qXUrnRn0o2wb68TS3JMu7N/Dy8PpXyD1uqqApS+anAqwAIJs9k0mmA5cWU
         Kb3Q==
X-Gm-Message-State: AO0yUKW6X9t/NM9FY9vPwyWzhhcJUUq9zBm7HOxFHZ2azreT3Kp+c3Bj
        O3Xd8IIkapXUQSZcSxK79ZkG5wZsn+XdMJIU+Ww=
X-Google-Smtp-Source: AK7set94YWjrSTWpnDw4ALe33zzsKh2aJsjdU9fMS7v+B+fJkOUDYmLlf3GntgDqU9bzFBHZ36FgybXN+N9ykYGc7ac=
X-Received: by 2002:a50:d687:0:b0:4fc:6494:81c3 with SMTP id
 r7-20020a50d687000000b004fc649481c3mr2504306edi.1.1679093390321; Fri, 17 Mar
 2023 15:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230317201920.62030-1-alexei.starovoitov@gmail.com> <20230317201920.62030-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20230317201920.62030-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Mar 2023 15:49:38 -0700
Message-ID: <CAEf4BzbpG2bxNyr_Qmado_fMwZ8Czjy+uTTNxmfwE-PUbrL+mg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] libbpf: Fix relocation of kfunc ksym in
 ld_imm64 insn.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 1:19=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> void *p =3D kfunc; -> generates ld_imm64 insn.
> kfunc() -> generates bpf_call insn.
>
> libbpf patches bpf_call insn correctly while only btf_id part of ld_imm64=
 is
> set in the former case. Which means that pointers to kfuncs in modules ar=
e not
> patched correctly and the verifier rejects load of such programs due to b=
tf_id
> being out of range. Fix libbpf to patch ld_imm64 for kfunc.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index a557718401e4..4c34fbd7b5be 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7533,6 +7533,12 @@ static int bpf_object__resolve_ksym_func_btf_id(st=
ruct bpf_object *obj,
>         ext->is_set =3D true;
>         ext->ksym.kernel_btf_id =3D kfunc_id;
>         ext->ksym.btf_fd_idx =3D mod_btf ? mod_btf->fd_array_idx : 0;
> +       /* Also set kernel_btf_obj_fd to make sure that bpf_object__reloc=
ate_data()
> +        * populates FD into ld_imm64 insn when it's used to point to kfu=
nc.
> +        * {kernel_btf_id, btf_fd_idx} -> fixup bpf_call.
> +        * {kernel_btf_id, kernel_btf_obj_fd} -> fixup ld_imm64.
> +        */
> +       ext->ksym.kernel_btf_obj_fd =3D mod_btf ? mod_btf->fd : 0;
>         pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
>                  ext->name, kfunc_id);

we should report module name here as well, I'll send a patch for both
func and var ksyms

>
> --
> 2.34.1
>
