Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB8129ADB
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLWU3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:29:52 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:40673 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWU3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:29:52 -0500
Received: by mail-qv1-f66.google.com with SMTP id dp13so6780091qvb.7;
        Mon, 23 Dec 2019 12:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u3bM40DQGJwFxa8bQbqygcSAKBmzJQdS8BLF8sF03Go=;
        b=MbGSCT+fJA+Oh53nS+99q/pwRGBr622vpPJ2xB7r+0O2lP3AobA6krj1WP5yJX7Is/
         Z2vRegzzFjMrud//xqKBcuYotvQV0+YKa37Lwr7uRcMbD7P/q7XuNLIMfUf2+CNRzbuE
         fDnM25uZvwgqWI/tp6XOCV2oLGwDTwKP7mp80p7h8OkUWgJGBxf/GrbueCiKDJOMzT4a
         zA5yFJUmApZGJFA556jSQ7Ikfa/PXy7BUlNktyA9thVBttO2/o7UaMfFgS7882DcDr/g
         2zzpSz56QIDvC8jVptsGrofJ5t3DlCC7S+UJX5Zp62EUOSxYUxDDeMcBHQXKaZscc8zE
         QUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u3bM40DQGJwFxa8bQbqygcSAKBmzJQdS8BLF8sF03Go=;
        b=EBb4addXtladxj6EzcdnnJPcbkf5GGfeVehJzTAI29FuYoWv3jydYIchCK4egGYuos
         sDtQcEMDRKNFg1zZFUPcbWexXR2g0FwG4AtMNbXnrZHcfiWkQMdGGk8zWoYM5z4rPs2C
         eQX/ImA/Sj13ga85eiHk3syMoxw8A3vS9Z/0YUSwSDgovQpc5aqXEN6gtgUfC+E2WIf6
         bikVlxnc9UQ60macUG72pmfl7nNgM2DpPWhAIkxSH9qGuTwAAucPYP+5is4qkeD/VIhi
         a1Cvs/cwch83EKBfZVShe3ZD97FpdCuTzuWu+RaSK9V0imHpw1aObi1HDqek/Z8vIdAp
         5y0A==
X-Gm-Message-State: APjAAAUE0dCuF7Ax4sY27kz7UTfK9h6JnmZMxb4BdttX/t3z4WrfmWXm
        wdzKJwxGCVCqNHlAfZ9kmSdwbNGrjLw9b3a7Uz4=
X-Google-Smtp-Source: APXvYqx5+PSx4g4ydMwaKb6icy7/DtFnwIQOsWrldTlmPtgeswBzTKPW5QM4iqj/+/I3rmm2pZtBB1pBkorHgzlW6IA=
X-Received: by 2002:a05:6214:8cb:: with SMTP id da11mr16630926qvb.228.1577132988805;
 Mon, 23 Dec 2019 12:29:48 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062606.1182939-1-kafai@fb.com>
In-Reply-To: <20191221062606.1182939-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 12:29:37 -0800
Message-ID: <CAEf4BzYF8mBrkzM3=+XtyCwoQrLGvkA-6Uc3KXJ9CWmaKePX8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/11] bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch allows the kernel's struct ops (i.e. func ptr) to be
> implemented in BPF.  The first use case in this series is the
> "struct tcp_congestion_ops" which will be introduced in a
> latter patch.
>
> This patch introduces a new prog type BPF_PROG_TYPE_STRUCT_OPS.
> The BPF_PROG_TYPE_STRUCT_OPS prog is verified against a particular
> func ptr of a kernel struct.  The attr->attach_btf_id is the btf id
> of a kernel struct.  The attr->expected_attach_type is the member
> "index" of that kernel struct.  The first member of a struct starts
> with member index 0.  That will avoid ambiguity when a kernel struct
> has multiple func ptrs with the same func signature.
>
> For example, a BPF_PROG_TYPE_STRUCT_OPS prog is written
> to implement the "init" func ptr of the "struct tcp_congestion_ops".
> The attr->attach_btf_id is the btf id of the "struct tcp_congestion_ops"
> of the _running_ kernel.  The attr->expected_attach_type is 3.
>
> The ctx of BPF_PROG_TYPE_STRUCT_OPS is an array of u64 args saved
> by arch_prepare_bpf_trampoline that will be done in the next
> patch when introducing BPF_MAP_TYPE_STRUCT_OPS.
>
> "struct bpf_struct_ops" is introduced as a common interface for the kernel
> struct that supports BPF_PROG_TYPE_STRUCT_OPS prog.  The supporting kernel
> struct will need to implement an instance of the "struct bpf_struct_ops".
>
> The supporting kernel struct also needs to implement a bpf_verifier_ops.
> During BPF_PROG_LOAD, bpf_struct_ops_find() will find the right
> bpf_verifier_ops by searching the attr->attach_btf_id.
>
> A new "btf_struct_access" is also added to the bpf_verifier_ops such
> that the supporting kernel struct can optionally provide its own specific
> check on accessing the func arg (e.g. provide limited write access).
>
> After btf_vmlinux is parsed, the new bpf_struct_ops_init() is called
> to initialize some values (e.g. the btf id of the supporting kernel
> struct) and it can only be done once the btf_vmlinux is available.
>
> The R0 checks at BPF_EXIT is excluded for the BPF_PROG_TYPE_STRUCT_OPS prog
> if the return type of the prog->aux->attach_func_proto is "void".
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h               |  30 +++++++
>  include/linux/bpf_types.h         |   4 +
>  include/linux/btf.h               |  34 ++++++++
>  include/uapi/linux/bpf.h          |   1 +
>  kernel/bpf/Makefile               |   2 +-
>  kernel/bpf/bpf_struct_ops.c       | 122 +++++++++++++++++++++++++++
>  kernel/bpf/bpf_struct_ops_types.h |   4 +
>  kernel/bpf/btf.c                  |  88 ++++++++++++++------
>  kernel/bpf/syscall.c              |  17 ++--
>  kernel/bpf/verifier.c             | 134 +++++++++++++++++++++++-------
>  10 files changed, 372 insertions(+), 64 deletions(-)
>  create mode 100644 kernel/bpf/bpf_struct_ops.c
>  create mode 100644 kernel/bpf/bpf_struct_ops_types.h
>

All looks good, apart from the concern with partially-initialized
bpf_struct_ops.

[...]

> +const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
> +};
> +
> +void bpf_struct_ops_init(struct btf *_btf_vmlinux)

this is always get passed vmlinux's btf, so why not call it short and
sweet "btf"? _btf_vmlinux is kind of ugly and verbose.

> +{
> +       const struct btf_member *member;
> +       struct bpf_struct_ops *st_ops;
> +       struct bpf_verifier_log log = {};
> +       const struct btf_type *t;
> +       const char *mname;
> +       s32 type_id;
> +       u32 i, j;
> +

[...]

> +static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
> +{
> +       const struct btf_type *t, *func_proto;
> +       const struct bpf_struct_ops *st_ops;
> +       const struct btf_member *member;
> +       struct bpf_prog *prog = env->prog;
> +       u32 btf_id, member_idx;
> +       const char *mname;
> +
> +       btf_id = prog->aux->attach_btf_id;
> +       st_ops = bpf_struct_ops_find(btf_id);

if struct_ops initialization fails, type will be NULL and type_id will
be 0, which we rely on here to not get partially-initialized
bpf_struct_ops, right? Small comment mentioning this would be helpful.


> +       if (!st_ops) {
> +               verbose(env, "attach_btf_id %u is not a supported struct\n",
> +                       btf_id);
> +               return -ENOTSUPP;
> +       }
> +

[...]

>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>  {
>         struct bpf_prog *prog = env->prog;
> @@ -9520,6 +9591,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>         long addr;
>         u64 key;
>
> +       if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
> +               return check_struct_ops_btf_id(env);
> +

There is a btf_id == 0 check below, you need to check that for
STRUCT_OPS as well, otherwise you can get partially-initialized
bpf_struct_ops struct in check_struct_ops_btf_id.

>         if (prog->type != BPF_PROG_TYPE_TRACING)
>                 return 0;
>
> --
> 2.17.1
>
