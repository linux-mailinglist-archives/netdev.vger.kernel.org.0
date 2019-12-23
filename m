Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE39129BC6
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 00:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLWXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 18:20:22 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39940 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfLWXUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 18:20:21 -0500
Received: by mail-qk1-f193.google.com with SMTP id c17so14777529qkg.7;
        Mon, 23 Dec 2019 15:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMdWdM7LFYQH+fxL4cGJUo7gwgTy2PraIoPXC8o4QZw=;
        b=A+QoyNYVl6/3tlN1zI0S1YAmGzZ8o8K8rSulyE0ZCxlTxVge2If3j+IVuHNidIZ90Q
         gJLC5btc3LXtil6Fnw4UoIlQhMbGYYO1567UEIyN/XNqQLtgBT+uHRrA3Ta9iJD+5QSS
         MUtX4Oba1iDxB2qt5Vs9fVoF8NoX6JflxBrp5TZT3doe/ErD6TsFcck/4YbKagQv230z
         EMZspDD5LKWWvvvH8tU1nQJKJlFtsB9Z6C/0M5Yw2XbL4eZ9cGlOyj0rGUcduGr8p194
         90/F/MCaV2v3XU9z2tL1dERQ2sptTP43HmmyxcsWFKw8kqOYulXQU23P0RMMhzxHZ71S
         NFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMdWdM7LFYQH+fxL4cGJUo7gwgTy2PraIoPXC8o4QZw=;
        b=LufUbtKuaw/oDfJSgTuwuvVNd9R28725XcjP/9qzNCtye9ql8MUHwF5ZCuUi8c4zzW
         3hJNpbbv0x9Qc4qaBZNZr4YCoETxMSfxKbrFwFTvjrRQ3n21hxwPxYnHteVvbXol0ElA
         NAwztMKZy/hX0YrrW6PYpQGJxx76Hjnw5z52YvHh6P3lswfTdMv9zA8atcTNN57ColPW
         3Z6QPtu2xRYjB+W+VNWZeZkOnyztp2REoTr/GcnISplmqrhHMoIgsTDa6pX4vPApigaB
         R1k9nTL5AS/Pkg9R/0vd9hZUCY3JWxKTJoVXwlWmjTzjDH/3uJi6zHl95fYHCQpPnP7a
         Je3A==
X-Gm-Message-State: APjAAAVNghtyj8WerhP+uqhGSyK9whixS7npe9xpxGpT07cTBLvlA0WF
        85n2U0VTNW1vvqhUFEWxEmaZaS7hNQLroavLwNd+mA==
X-Google-Smtp-Source: APXvYqzdVqV6FjPPc06W6fiRQB1oTCVdWPWhAU4VJfMg2f4pCTI6ylx0x3RST0wbXG8fzfKb8OWoY3h/pxRSEFLs2wc=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr28956102qkj.36.1577143220866;
 Mon, 23 Dec 2019 15:20:20 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062611.1183363-1-kafai@fb.com>
In-Reply-To: <20191221062611.1183363-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 15:20:10 -0800
Message-ID: <CAEf4BzbrA4YqvUcNVvCjkQsWz9UuERwwZWhLmFrRh1sgx=yL2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/11] bpf: tcp: Support tcp_congestion_ops in bpf
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
> This patch makes "struct tcp_congestion_ops" to be the first user
> of BPF STRUCT_OPS.  It allows implementing a tcp_congestion_ops
> in bpf.
>
> The BPF implemented tcp_congestion_ops can be used like
> regular kernel tcp-cc through sysctl and setsockopt.  e.g.
> [root@arch-fb-vm1 bpf]# sysctl -a | egrep congestion
> net.ipv4.tcp_allowed_congestion_control = reno cubic bpf_cubic
> net.ipv4.tcp_available_congestion_control = reno bic cubic bpf_cubic
> net.ipv4.tcp_congestion_control = bpf_cubic
>
> There has been attempt to move the TCP CC to the user space
> (e.g. CCP in TCP).   The common arguments are faster turn around,
> get away from long-tail kernel versions in production...etc,
> which are legit points.
>
> BPF has been the continuous effort to join both kernel and
> userspace upsides together (e.g. XDP to gain the performance
> advantage without bypassing the kernel).  The recent BPF
> advancements (in particular BTF-aware verifier, BPF trampoline,
> BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
> possible in BPF.  It allows a faster turnaround for testing algorithm
> in the production while leveraging the existing (and continue growing)
> BPF feature/framework instead of building one specifically for
> userspace TCP CC.
>
> This patch allows write access to a few fields in tcp-sock
> (in bpf_tcp_ca_btf_struct_access()).
>
> The optional "get_info" is unsupported now.  It can be added
> later.  One possible way is to output the info with a btf-id
> to describe the content.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/filter.h            |   2 +
>  include/net/tcp.h                 |   1 +
>  kernel/bpf/bpf_struct_ops_types.h |   7 +-
>  net/core/filter.c                 |   2 +-
>  net/ipv4/Makefile                 |   4 +
>  net/ipv4/bpf_tcp_ca.c             | 226 ++++++++++++++++++++++++++++++
>  net/ipv4/tcp_cong.c               |  14 +-
>  net/ipv4/tcp_ipv4.c               |   6 +-
>  net/ipv4/tcp_minisocks.c          |   4 +-
>  net/ipv4/tcp_output.c             |   4 +-
>  10 files changed, 255 insertions(+), 15 deletions(-)
>  create mode 100644 net/ipv4/bpf_tcp_ca.c
>

Naming nits below. Other than that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

> +static const struct btf_type *tcp_sock_type;
> +static u32 tcp_sock_id, sock_id;
> +
> +static int bpf_tcp_ca_init(struct btf *_btf_vmlinux)
> +{

there is no reason to pass anything but vmlinux's BTF to this
function, so I think just having "btf" as a name is OK.

> +       s32 type_id;
> +
> +       type_id = btf_find_by_name_kind(_btf_vmlinux, "sock", BTF_KIND_STRUCT);
> +       if (type_id < 0)
> +               return -EINVAL;
> +       sock_id = type_id;
> +
> +       type_id = btf_find_by_name_kind(_btf_vmlinux, "tcp_sock",
> +                                       BTF_KIND_STRUCT);
> +       if (type_id < 0)
> +               return -EINVAL;
> +       tcp_sock_id = type_id;
> +       tcp_sock_type = btf_type_by_id(_btf_vmlinux, tcp_sock_id);
> +
> +       return 0;
> +}
> +
> +static bool check_optional(u32 member_offset)

check_xxx is quite ambiguous, in general: is it a check that it is
optional or that it's not optional? How about using
is_optional/is_unsupported to make this clear?


> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(optional_ops); i++) {
> +               if (member_offset == optional_ops[i])
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +

[...]
