Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44515F0819
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfKEVSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:18:06 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41356 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKEVSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:18:06 -0500
Received: by mail-qt1-f194.google.com with SMTP id o3so31249147qtj.8;
        Tue, 05 Nov 2019 13:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqVeoKSM4BKyi4tcxLxugG9GeYHKOEZo8aR3QuPOuYs=;
        b=m8GpQ4hB3FW9sOwZdQEjH3P3mlaHUbP7H4vflYhqAyEF5m4GoXqphHOEBCPHTpMhwE
         zqWWdFxYGEW7ExfB54OhOEuUDx/V7PgTqBkMAurHT044X6FKDiF5roufJ/BjPC8pvzT7
         ShzRcMR2RI51eFbT0muwplAS2xFs3pbyzVk7Ul3EoAcoReM9K/MgpYOxuTk8QEkFl7Sn
         rxcGrt7mqSKNPWqRMcu6ZRl9GlyPyN37oEh9n9qamcqmJfV1qsvGg1lfnD5VPkcvLCHm
         kcziufomPSRhUsb7YDxyx/3fcOxJ/pnnvHkxF2F5COAN9HuMHDCaymMVl2ZwPPk4JtL8
         v0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqVeoKSM4BKyi4tcxLxugG9GeYHKOEZo8aR3QuPOuYs=;
        b=dPuC+57ZuA3PNYGXEcBj1ld7fQNkbXF1uZb6K+Pw5pmM8dfAvY/jiwGF0QfF8shMzB
         osvka1SdrcvXFGhX5xn4I3fLr5wGIDTT7fI61yNbWIVEhrIs6aov3r8BBtwk9shHiVXD
         Dmiol8r588awfUuegpLrJ8psT8qYUY1Iiq+U22ESRhavWTdWdV85w7gb3wyu3m2NvzSA
         XrV4orTXFr/amSPzN1SfZnDl9SRN97awW04fxihrrm0FpqpUjvTMxNT9B1bm5WkDw9li
         88NsCwcE9f+Zl3uvlYlr4DsFI0/uDV5uFvwzryEv4Ey6GPLyASvjOnxnLn5mAFu99KWX
         mcpw==
X-Gm-Message-State: APjAAAUqH8o6SDZLsKJbh7GRwHXdcQRtew6Q8zVf+8AcYDYq9UCAGXYk
        flIfJ8a6dKbktloVGGNCaq7pmRB3H3dG1i3XWCidNg==
X-Google-Smtp-Source: APXvYqyGRkE9eFVnK0z0VGG8Li0rNHkBSgCtwu1xv8zwmXhqXXoZ6iXZPsf/4KSck0+3h0PfQuHIbqj9JDOfG1POdrI=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr19619322qte.59.1572988685267;
 Tue, 05 Nov 2019 13:18:05 -0800 (PST)
MIME-Version: 1.0
References: <20191102220025.2475981-1-ast@kernel.org> <20191102220025.2475981-5-ast@kernel.org>
In-Reply-To: <20191102220025.2475981-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 13:17:54 -0800
Message-ID: <CAEf4BzbJ3Y4_rjvr9Xu2MR87Ghdx_1n=KOOaeqM_F7+OwPihRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: Add support to attach to
 fentry/fexit tracing progs
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 3:03 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Teach libbpf to recognize tracing programs types and attach them to
> fentry/fexit.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/include/uapi/linux/bpf.h |  2 ++
>  tools/lib/bpf/libbpf.c         | 55 +++++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h         |  2 ++
>  tools/lib/bpf/libbpf.map       |  1 +
>  4 files changed, 53 insertions(+), 7 deletions(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index df6809a76404..69c200e6e696 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -201,6 +201,8 @@ enum bpf_attach_type {
>         BPF_CGROUP_GETSOCKOPT,
>         BPF_CGROUP_SETSOCKOPT,
>         BPF_TRACE_RAW_TP,
> +       BPF_TRACE_FENTRY,
> +       BPF_TRACE_FEXIT,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7aa2a2a22cef..03e784f36dd9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3744,7 +3744,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>         return 0;
>  }
>
> -static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id);
> +static int libbpf_attach_btf_id_by_name(const char *name, __u32 *btf_id, bool raw_tp);

Bools are hard to follow in code, why not just passing full
attach_type instead? It will also be more future-proof, if we need
another trick, similar to "bpf_trace_" prefix for raw_tp?

Also, I have a mild preference for having output arguments to be the
very last in the argument list. Do you mind reordering so thar bool
raw_tp is second?

>
>  static struct bpf_object *
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> @@ -3811,7 +3811,9 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                 bpf_program__set_type(prog, prog_type);
>                 bpf_program__set_expected_attach_type(prog, attach_type);
>                 if (prog_type == BPF_PROG_TYPE_TRACING) {
> -                       err = libbpf_attach_btf_id_by_name(prog->section_name, &btf_id);
> +                       err = libbpf_attach_btf_id_by_name(prog->section_name,
> +                                                          &btf_id,
> +                                                          attach_type == BPF_TRACE_RAW_TP);

[...]
