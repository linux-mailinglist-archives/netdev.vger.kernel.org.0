Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86DCCF06
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJFGgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:36:31 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46553 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfJFGga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:36:30 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so9710379qkd.13;
        Sat, 05 Oct 2019 23:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YcAWsOVDTKBp2eS0wiqe5VmKGDkAQhwF2yQW6DRLqV8=;
        b=TvnkfHRMuyttNRHGb32G1BS23SPdNVrOVl9F9gKxHdtEBUpsTo9rzCZ9ReRdYIkQQ3
         NBK70iyFgROG0RoYRQV3xZHDWwmYCBBU/cnNzYWE5lxzNfbiG/ZPqPMrjg6MAkuibRuX
         +Y6yEaPDrCAs8+Hdhz8SnEiHAPF6xjBv4RFdD8j+qznfosuGluvpOntAnj+rJknqFZ+n
         VDy946t4vOhn0F9K2DdMhsiB/GafNyYGQ6ofpJ8++MN5lJ8be5I++WNnuJjORdlm2WQz
         Jo78wwRL3hn4xJexXL2981EhOU53KvL34U/jIczUcl5t2W6jRxwCeoyqY0VkvJ4Wlgl/
         B27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YcAWsOVDTKBp2eS0wiqe5VmKGDkAQhwF2yQW6DRLqV8=;
        b=H4A2Ua2e3f5HVRLGfcqsGpwjIUwMtncVijFnho/szGLDJLT7kV9z0n+0lVXLq3U6tH
         IQL3XvQvrNAkv3ZkVMfOra7Z7HuXrfhCXPyh1rR2TvRK1OgbAnk32hd1C1QkLfocmaVM
         MhZ/vNQpXzWi07XLE34tUn1HvLBdwmSCP6J1exueWObKWAoI7WZmwMmKdD/iSmLm38km
         s8G3k9p1z4DWjqVWM8lW+XqS5SdA4xPTgvZmOCxP/TDyOhPTV4O7qyRkY9NFqaWWb5le
         P+CtPDp0hNvvupRFqYcnwsBFxOgn/XwVRFnGPrkoK1hhxtt1cDUxyq7gO2uxcig9flgP
         XSQg==
X-Gm-Message-State: APjAAAUckOuAq7iykcOBEeenUni7M/aUsdxR4wOasb6nUQ4DTh65xYNb
        e0Zq4Xw69hD0IBOljY+c13gzlMmeM/irbfUEuuU=
X-Google-Smtp-Source: APXvYqwBqSz6n5RAfsEux/+fS5StAKF7Q+J6XkSiKZ2UJ/K6T1F/l4NMfsYnlF9vks8CdXOHhffmLo2aaR4aGReHgf0=
X-Received: by 2002:a37:9fcd:: with SMTP id i196mr17929277qke.92.1570343787749;
 Sat, 05 Oct 2019 23:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-4-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 23:36:16 -0700
Message-ID: <CAEf4BzahO9XjK7rMYa+DdRRhm2z4MmjD9Y-n3DWGd-W-G3mYRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
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

On Fri, Oct 4, 2019 at 10:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> If in-kernel BTF exists parse it and prepare 'struct btf *btf_vmlinux'
> for further use by the verifier.
> In-kernel BTF is trusted just like kallsyms and other build artifacts
> embedded into vmlinux.
> Yet run this BTF image through BTF verifier to make sure
> that it is valid and it wasn't mangled during the build.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf_verifier.h |  4 ++-
>  include/linux/btf.h          |  1 +
>  kernel/bpf/btf.c             | 66 ++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        | 18 ++++++++++
>  4 files changed, 88 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 26a6d58ca78c..432ba8977a0a 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -330,10 +330,12 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
>  #define BPF_LOG_STATS  4
>  #define BPF_LOG_LEVEL  (BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
>  #define BPF_LOG_MASK   (BPF_LOG_LEVEL | BPF_LOG_STATS)
> +#define BPF_LOG_KERNEL (BPF_LOG_MASK + 1)

It's not clear what's the numbering scheme is for these flags. Are
they independent bits? Only one bit allowed at a time? Only some
subset of bits allowed?
E.g., if I specify BPF_LOG_KERNEL an BPF_LOG_STATS, will it work?

If it's bits, then specifying BPF_LOG_KERNEL as (BPF_LOG_MASK + 1)
looks weird, setting it to 8 would be more obvious and
straightforward.

>
>  static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
>  {
> -       return log->level && log->ubuf && !bpf_verifier_log_full(log);
> +       return (log->level && log->ubuf && !bpf_verifier_log_full(log)) ||
> +               log->level == BPF_LOG_KERNEL;
>  }
>
>  #define BPF_MAX_SUBPROGS 256
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 64cdf2a23d42..55d43bc856be 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -56,6 +56,7 @@ bool btf_type_is_void(const struct btf_type *t);
>  #ifdef CONFIG_BPF_SYSCALL
>  const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> +struct btf *btf_parse_vmlinux(void);
>  #else
>  static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
>                                                     u32 type_id)
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 29c7c06c6bd6..848f9d4b9d7e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -698,6 +698,9 @@ __printf(4, 5) static void __btf_verifier_log_type(struct btf_verifier_env *env,
>         if (!bpf_verifier_log_needed(log))
>                 return;
>
> +       if (log->level == BPF_LOG_KERNEL && !fmt)
> +               return;

This "!fmt" condition is subtle and took me a bit of time to
understand. Is the intent to print only verification errors for
BPF_LOG_KERNEL mode? Maybe small comment would help?

> +
>         __btf_verifier_log(log, "[%u] %s %s%s",
>                            env->log_type_id,
>                            btf_kind_str[kind],
> @@ -735,6 +738,8 @@ static void btf_verifier_log_member(struct btf_verifier_env *env,
>         if (!bpf_verifier_log_needed(log))
>                 return;
>
> +       if (log->level == BPF_LOG_KERNEL && !fmt)
> +               return;
>         /* The CHECK_META phase already did a btf dump.
>          *
>          * If member is logged again, it must hit an error in
> @@ -777,6 +782,8 @@ static void btf_verifier_log_vsi(struct btf_verifier_env *env,
>
>         if (!bpf_verifier_log_needed(log))
>                 return;
> +       if (log->level == BPF_LOG_KERNEL && !fmt)
> +               return;
>         if (env->phase != CHECK_META)
>                 btf_verifier_log_type(env, datasec_type, NULL);
>
> @@ -802,6 +809,8 @@ static void btf_verifier_log_hdr(struct btf_verifier_env *env,
>         if (!bpf_verifier_log_needed(log))
>                 return;
>
> +       if (log->level == BPF_LOG_KERNEL)
> +               return;
>         hdr = &btf->hdr;
>         __btf_verifier_log(log, "magic: 0x%x\n", hdr->magic);
>         __btf_verifier_log(log, "version: %u\n", hdr->version);
> @@ -2406,6 +2415,8 @@ static s32 btf_enum_check_meta(struct btf_verifier_env *env,
>                 }
>
>

nit: extra empty line here, might as well get rid of it in this change?

> +               if (env->log.level == BPF_LOG_KERNEL)
> +                       continue;
>                 btf_verifier_log(env, "\t%s val=%d\n",
>                                  __btf_name_by_offset(btf, enums[i].name_off),
>                                  enums[i].val);
> @@ -3367,6 +3378,61 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
>         return ERR_PTR(err);
>  }
>
> +extern char __weak _binary__btf_vmlinux_bin_start[];
> +extern char __weak _binary__btf_vmlinux_bin_end[];
> +
> +struct btf *btf_parse_vmlinux(void)

It's a bit unfortunate to duplicate a bunch of logic of btf_parse()
here. I assume you considered extending btf_parse() with extra flag
but decided it's better to have separate vmlinux-specific version?

> +{
> +       struct btf_verifier_env *env = NULL;
> +       struct bpf_verifier_log *log;
> +       struct btf *btf = NULL;
> +       int err;
> +

[...]

>         if (!copy_to_user(log->ubuf + log->len_used, log->kbuf, n + 1))
>                 log->len_used += n;
>         else
> @@ -9241,6 +9247,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>         env->ops = bpf_verifier_ops[env->prog->type];
>         is_priv = capable(CAP_SYS_ADMIN);
>
> +       if (is_priv && !btf_vmlinux) {

I'm missing were you are checking that vmlinux BTF (raw data) is
present at all? Should this have additional `&&
_binary__btf_vmlinux_bin_start` check?

> +               mutex_lock(&bpf_verifier_lock);
> +               btf_vmlinux = btf_parse_vmlinux();

This is racy, you might end up parsing vmlinux BTF twice. Check
`!btf_vmlinux` again under lock?

> +               mutex_unlock(&bpf_verifier_lock);
> +       }
> +
>         /* grab the mutex to protect few globals used by verifier */
>         if (!is_priv)
>                 mutex_lock(&bpf_verifier_lock);
> @@ -9260,6 +9272,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>                         goto err_unlock;
>         }
>
> +       if (IS_ERR(btf_vmlinux)) {

There is an interesting interplay between non-priviledged BPF and
corrupted vmlinux. If vmlinux BTF is malformed, but system only ever
does unprivileged BPF, then we'll never parse vmlinux BTF and won't
know it's malformed. But once some privileged BPF does parse and
detect problem, all subsequent unprivileged BPFs will fail due to bad
BTF, even though they shouldn't use/rely on it. Should something be
done about this inconsistency?

> +               verbose(env, "in-kernel BTF is malformed\n");
> +               ret = PTR_ERR(btf_vmlinux);
> +               goto err_unlock;
> +       }
> +
>         env->strict_alignment = !!(attr->prog_flags & BPF_F_STRICT_ALIGNMENT);
>         if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
>                 env->strict_alignment = true;
> --
> 2.20.0
>
