Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D97C6BDA3A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCPUej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCPUef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:34:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF64926CD7;
        Thu, 16 Mar 2023 13:34:20 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x3so12486032edb.10;
        Thu, 16 Mar 2023 13:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678998859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uY311bSa6Wng6ze/hYXB3PGHkKCTtt5lQdt3WNfnAxg=;
        b=Op+JfJPwKIiFOu1MhhCrfrlSwx6BR4noVJR+JkQv6O5vhYcqSyS7ErBeLZ9ShV4iB4
         rJfIUPTObyGCfCsfG17/mTHJeMvmjRLFDQsCYQD4fzQjlA/x37+uczPyIIc9VZGlEX9P
         ANEQyF6W8H/INTtI4lLymrpR/6F7MZZ4Um0iBZDTgONHXEJb+iS76HEAl5IDthJm1ShB
         abL1e7c4+FTOwOrg9o62gQCBzgm3t8oL6UUqmnRdI0lDxU/cR9zVBhipRzD8ggZlm9El
         jbcpTFT2d1wWky3UaukdaWEIFs2qzlHaBkCG3cgUyX4OQ3dfUjHcgyjmaONdna+qQR4B
         WqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678998859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uY311bSa6Wng6ze/hYXB3PGHkKCTtt5lQdt3WNfnAxg=;
        b=Ye6FpJifgUM4548Yd4a3cdhKbu4+j2bTGcuLyp6P0oJrXctq5daFrugycWATMxpTWm
         c8bYXX5EJqceI978ndTCGXJQ4nbdIlvoH6x1SP3X0YFWmuuHISKZ/11wlix6gfG+nERa
         qm7UJV1h5BK0ddTnUJUx+Arv6GNKCP7Ifn6r59jJ+BpUpVn7GR+btQUXi5+ZH9t8XMZl
         hzaSwIpjghrvdUWx4mKeNe4lLh+lX4nKF/PkNA2rphQCiWZZBhVbTC0DKmSfMh3ykJkB
         KvIzxq0CgrwL6Wh6ygQFpXQzO59X6IewMn7DnqpQLaEkNQ9u31fhPsJCeQuz3KzhV2yE
         RCeg==
X-Gm-Message-State: AO0yUKXB6+06TWVQDlvDP+5y9kjTSqF7ll0VkD1rA6UTV2gGA6fImqqP
        7KuXcdj8u5/+DrHUWAyVeoWV3dYU7cy3R578Rau6jX7xHik=
X-Google-Smtp-Source: AK7set88zm+0+yBkwZg+bpRlN1aGl76sZVT/LapcwMv8C5PVeX1JISEyPF7m03l+HDuRlneNQ5PqqH1EUUoPS5Lfv4k=
X-Received: by 2002:a17:907:2dac:b0:925:5b14:e919 with SMTP id
 gt44-20020a1709072dac00b009255b14e919mr6439467ejc.5.1678998859059; Thu, 16
 Mar 2023 13:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com> <20230315223607.50803-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20230315223607.50803-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Mar 2023 13:34:06 -0700
Message-ID: <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
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

On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc.
> PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
> so unresolved kfuncs will be seen as zero.
> This allows BPF programs to detect at load time whether kfunc is present
> in the kernel with bpf_kfunc_exists() macro.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/verifier.c       | 7 +++++--
>  tools/lib/bpf/bpf_helpers.h | 3 +++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 60793f793ca6..4e49d34d8cd6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_verifie=
r_env *env,
>                 goto err_put;
>         }
>
> -       if (!btf_type_is_var(t)) {
> -               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.=
\n", id);
> +       if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
> +               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR =
or KIND_FUNC\n", id);
>                 err =3D -EINVAL;
>                 goto err_put;
>         }
> @@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_verifie=
r_env *env,
>                 aux->btf_var.reg_type =3D PTR_TO_BTF_ID | MEM_PERCPU;
>                 aux->btf_var.btf =3D btf;
>                 aux->btf_var.btf_id =3D type;
> +       } else if (!btf_type_is_func(t)) {
> +               aux->btf_var.reg_type =3D PTR_TO_MEM | MEM_RDONLY;
> +               aux->btf_var.mem_size =3D 0;
>         } else if (!btf_type_is_struct(t)) {
>                 const struct btf_type *ret;
>                 const char *tname;
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 7d12d3e620cc..43abe4c29409 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -177,6 +177,9 @@ enum libbpf_tristate {
>  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
>  #define __kptr __attribute__((btf_type_tag("kptr")))
>
> +/* pass function pointer through asm otherwise compiler assumes that any=
 function !=3D 0 */
> +#define bpf_kfunc_exists(fn) ({ void *__p =3D fn; asm ("" : "+r"(__p)); =
__p; })
> +

I think we shouldn't add this helper macro. It just obfuscates a
misuse of libbpf features and will be more confusing in practice.

If I understand the comment, that asm is there to avoid compiler
optimization of *knowing* that kfunc exists (it's extern is resolved
to something other than 0), even if kfunc's ksym is not declared with
__weak.

But that's actually bad and misleading, as even if code is written to
use kfunc as optional, libbpf will fail load even before we'll get to
kernel, as it won't be able to find ksym's BTF information in kernel
BTF. Optional kfunc *has* to be marked __weak.

__weak has a consistent semantics to indicate something that's
optional. This is documented (e.g., [0] for kconfig variables) We do
have tests making sure this works for weak __kconfig and variable
__ksyms. Let's add similar ones for kfunc ksyms.


  [0] https://nakryiko.com/posts/bpf-core-reference-guide/#kconfig-extern-v=
ariables


Just to demonstrate what I mentioned above, I tried this quick
experiment. Commented out block assumes that feature detection is done
by user-space and use_kfunc is set to true or false, depending on
whether that kfunc is detected. But if bpf_iter_num_new1 is defined as
non-weak __ksym, this fails with either use_kfunc=3Dtrue or
use_kfunc=3Dfalse. Which is correct behavior from libbpf's POV.

On the other hand, the second part, which your patch now makes
possible, is the proper way to detect if kfunc is defined and that
kfunc is defined as __weak. It works, even if kfunc is not present in
the kernel.


So I think bpf_kfunc_exists() will just hide and obfuscate the actual
issue (lack of __weak marking for something that's optional).

diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c
b/tools/testing/selftests/bpf/progs/test_vmlinux.c
index 4b8e37f7fd06..92291a0727b7 100644
--- a/tools/testing/selftests/bpf/progs/test_vmlinux.c
+++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
@@ -6,15 +6,21 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
+#include "bpf_misc.h"

 #define MY_TV_NSEC 1337

+const volatile bool use_kfunc =3D false;
+
 bool tp_called =3D false;
 bool raw_tp_called =3D false;
 bool tp_btf_called =3D false;
 bool kprobe_called =3D false;
 bool fentry_called =3D false;

+extern int bpf_iter_num_new1(struct bpf_iter_num *it, int start, int
end) __ksym;
+extern int bpf_iter_num_new2(struct bpf_iter_num *it, int start, int
end) __ksym __weak;
+
 SEC("tp/syscalls/sys_enter_nanosleep")
 int handle__tp(struct trace_event_raw_sys_enter *args)
 {
@@ -24,6 +30,19 @@ int handle__tp(struct trace_event_raw_sys_enter *args)
        if (args->id !=3D __NR_nanosleep)
                return 0;

+       /*
+       if (use_kfunc) { // fails
+               struct bpf_iter_num it;
+               bpf_iter_num_new1(&it, 0, 100);
+               bpf_iter_num_destroy(&it);
+       }
+       */
+       if (bpf_iter_num_new2) { // works
+               struct bpf_iter_num it;
+               bpf_iter_num_new2(&it, 0, 100);
+               bpf_iter_num_destroy(&it);
+       }
+
        ts =3D (void *)args->args[0];
        if (bpf_probe_read_user(&tv_nsec, sizeof(ts->tv_nsec), &ts->tv_nsec=
) ||
            tv_nsec !=3D MY_TV_NSEC)


>  #ifndef ___bpf_concat
>  #define ___bpf_concat(a, b) a ## b
>  #endif
> --
> 2.34.1
>
