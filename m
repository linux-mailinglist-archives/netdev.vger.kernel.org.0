Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A2FF67D9
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 08:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfKJHRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 02:17:50 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42050 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKJHRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 02:17:50 -0500
Received: by mail-qk1-f193.google.com with SMTP id m4so8667880qke.9;
        Sat, 09 Nov 2019 23:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JnZi9ds09RNl/dasLwKJzzJAoFVUnwihAUt4GRMgaJQ=;
        b=U8n7gvaJ1u9SORWpxkuUGHVVjalwvR3Pfo+/MRVEml1ra7whwZDxieXIPkUHjD65e0
         jQMg9zRl53oHccjdZtBaAxISRtsdiW707tJOTRuUJzSmBgp7W1j9dule2knKW0aEdyTf
         2oxjcOD81l9IxgsKmLNNLX1J1WnQmvdO1dqHO0ndxUP/9KoX5SG5fko0b3Xur9wRZMbg
         Kddlt8wz6aB852ODptEBSkQ2YIG4VrMjDWDoQnYqimxVmFpjmvlUSa9ZnTaKfdMvo7jp
         X98qzGUfA9krXHalJPKKJWF2bisWNoF8mqflD0pukK1iAKw5CCvfuPbjiE7i40jUon14
         As4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JnZi9ds09RNl/dasLwKJzzJAoFVUnwihAUt4GRMgaJQ=;
        b=c3FkEjB+L+4UeKNPDS6kAmCAVnpMl9z6zlk4T6g5/M+XhYJ5aTKNVoRtjGM2/CwN8O
         CsPuA50HG6VjkKglc6mY386P5u5wLAa77C8xvLoGfQ/6o1Ci1JsYHc5KsJnIsEO/suHx
         Lw74LbLMm0DgyXgrdJyeB/RYwhKwx8PTtC7IlyPjpG3rwoZp8Mrzler4LnozaSJj53N+
         v7479OVdu9scXaqmFugvP3Q5ygKkJP2MsydN/MWVwrJzjdUTl2z/PPh+11VD+z09Wc0g
         w99Kr5ax5/XI/OaNd6exG0d2W0Q9C2Q09LZmyEaz21zl8IvymPqyJ2oJSKs+R5fted8G
         LL+A==
X-Gm-Message-State: APjAAAWJNPzyqQK8y0LUCIsd7UXDd98BLzK3Ea2A7xoO5gI4s2G2nhJ9
        XW4nmkDh3rCLZIxF1XEeuTtbk2oxnnhVmM0ZdPI=
X-Google-Smtp-Source: APXvYqy3+OYnK1B71YLsarnICWQpyK/QffrGpXjatBq8pf/8spPKBz+mMM00hXnFTodBSUjw5rDC/TyFDDggD21kbSs=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr5298605qki.437.1573370268735;
 Sat, 09 Nov 2019 23:17:48 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-16-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-16-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 9 Nov 2019 23:17:37 -0800
Message-ID: <CAEf4BzZAEqv4kJy133PAMt81xaDBTcYDqNHSJP81X+2AitHpOQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 15/18] bpf: Support attaching tracing BPF
 program to other BPF programs
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

On Thu, Nov 7, 2019 at 10:41 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Allow FENTRY/FEXIT BPF programs to attach to other BPF programs of any type
> including their subprograms. This feature allows snooping on input and output
> packets in XDP, TC programs including their return values. In order to do that
> the verifier needs to track types not only of vmlinux, but types of other BPF
> programs as well. The verifier also needs to translate uapi/linux/bpf.h types
> used by networking programs into kernel internal BTF types used by FENTRY/FEXIT
> BPF programs. In some cases LLVM optimizations can remove arguments from BPF
> subprograms without adjusting BTF info that LLVM backend knows. When BTF info
> disagrees with actual types that the verifiers sees the BPF trampoline has to
> fallback to conservative and treat all arguments as u64. The FENTRY/FEXIT
> program can still attach to such subprograms, but won't be able to recognize
> pointer types like 'struct sk_buff *' into won't be able to pass them to
> bpf_skb_output() for dumping to user space.
>
> The BPF_PROG_LOAD command is extended with attach_prog_fd field. When it's set
> to zero the attach_btf_id is one vmlinux BTF type ids. When attach_prog_fd
> points to previously loaded BPF program the attach_btf_id is BTF type id of
> main function or one of its subprograms.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  arch/x86/net/bpf_jit_comp.c |  3 +-
>  include/linux/bpf.h         |  2 +
>  include/linux/btf.h         |  1 +
>  include/uapi/linux/bpf.h    |  1 +
>  kernel/bpf/btf.c            | 58 +++++++++++++++++++---
>  kernel/bpf/core.c           |  2 +
>  kernel/bpf/syscall.c        | 19 +++++--
>  kernel/bpf/verifier.c       | 98 +++++++++++++++++++++++++++++--------
>  kernel/trace/bpf_trace.c    |  2 -
>  9 files changed, 151 insertions(+), 35 deletions(-)
>

[...]

> +
> +static bool btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> +                                    struct btf *btf,
> +                                    const struct btf_type *t,
> +                                    struct bpf_insn_access_aux *info)
> +{
> +       const char *tname = __btf_name_by_offset(btf, t->name_off);
> +       int btf_id;
> +
> +       if (!tname) {
> +               bpf_log(log, "Program's type doesn't have a name\n");
> +               return false;
> +       }
> +       if (strcmp(tname, "__sk_buff") == 0) {

might be a good idea to ensure that t's type is also a struct?

> +               btf_id = btf_resolve_helper_id(log, &bpf_skb_output_proto, 0);

This is kind of ugly and high-maintenance. Have you considered having
something like this, to do this mapping:

struct bpf_ctx_mapping {
    struct sk_buff *__sk_buff;
    struct xdp_buff *xdp_md;
};

So field name is a name you are trying to match, while field type is
actual type you are mapping to? You won't need to find special
function protos (like bpf_skb_output_proto), it will be easy to
extend, you'll have real vmlinux types automatically captured for you
(you'll just have to initially find bpf_ctx_mapping's btf_id).


> +               if (btf_id < 0)
> +                       return false;
> +               info->btf_id = btf_id;
> +               return true;
> +       }
> +       return false;
> +}
>

[...]

> +               if (tgt_prog && conservative) {
> +                       struct btf_func_model *m = &tr->func.model;
> +
> +                       /* BTF function prototype doesn't match the verifier types.
> +                        * Fall back to 5 u64 args.
> +                        */
> +                       for (i = 0; i < 5; i++)
> +                               m->arg_size[i] = 8;
> +                       m->ret_size = 8;
> +                       m->nr_args = 5;
> +                       prog->aux->attach_func_proto = NULL;
> +               } else {
> +                       ret = btf_distill_func_proto(&env->log, btf, t,
> +                                                    tname, &tr->func.model);

there is nothing preventing some parallel thread to modify
tr->func.model in parallel, right? Should these modifications be
either locked or at least WRITE_ONCE, similar to
btf_resolve_helper_id?


> +                       if (ret < 0)
> +                               goto out;
> +               }

[...]
