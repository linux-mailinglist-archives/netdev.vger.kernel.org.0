Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A04D1930DC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgCYTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:06:21 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41634 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYTGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:06:20 -0400
Received: by mail-qv1-f68.google.com with SMTP id o7so1659724qvq.8;
        Wed, 25 Mar 2020 12:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnvI6xW8U9eNlsD+pukBA7dl4kfcYWoflpIs9zeXJHw=;
        b=mI4gEGSrg8eQRXLrtx8K2FJ8yuqvRnwDFnjZRaLrSO1o0YRv6yNSxWDLP+on6JZb7d
         R/vE963zE770pbvyhgTskDIWMxkDa9fireugqMF6nS8wquHb/Px/DgWZ1uh7wFx3yhp+
         /LeDoFAwhi54QYe/6EJIOl1cnLJGWF3J7Na+WNjMjR390mzuI9jOLZnZ8XwKY9lMI2bc
         b8aedv+oS/w3k+PbUbFCTiS7DNFj6iIluMRtBV/+NgT+I2NjmIO3oFxQ3cLdqsx+sN1A
         w5UcMwNzfF8IlOg0hQZJa5OASmy8zwWLZfgd40jZ8ZMtN1nknIAiJmeAIW4Y6hihikpI
         EJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnvI6xW8U9eNlsD+pukBA7dl4kfcYWoflpIs9zeXJHw=;
        b=mpHea4SHYABhVYin4dmMlGARNWEMh5m55KWQXzWjcI/VcQSW/OsoEgw3WpLYRXG7eX
         lwuZUNjG/+7Ad+HsEuwSLH8U+31yURKAgV9HcywI/ZqRJnyrm21CNbHru+bOSUl+FHjw
         SzUqrid3eXqkLqw9jmp3H5lYvqRQJxrGL1cvmGRDtTp/UgXaHZ8fuPM/WpI75CKeez8t
         T0sSjI5ODKJBQ6JeBPWs8LqELfpCEnerhtJzZWfGULxnokdUmBvDU1hFxyMUADMProvg
         XuKhHwBY4JcqLEW/lFj7kCEGwpyEX8JiDakkgMJYyd4BNmgrtu6NHPKpWHqFzBNesYm3
         GAGQ==
X-Gm-Message-State: ANhLgQ37Gb0dotaIo/eQpMK4TuHzBY+LIb1n/xjN67ozM1WMssFutvc6
        Vvpr+j0VgB67EO/h+AHNYJD0hCjnlUZwbGKZzUmPRf0S
X-Google-Smtp-Source: ADFU+vv9XVSMxZZq7SaDLDvRy1oFnlRezhap3YmLv2gfIZCAyHI03Hf1cqT8vd5HYU35Dfz8cBQBum5Exf0DmtCJZ5M=
X-Received: by 2002:a0c:8525:: with SMTP id n34mr4612358qva.224.1585163178852;
 Wed, 25 Mar 2020 12:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200325162026.254799-1-sdf@google.com>
In-Reply-To: <20200325162026.254799-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 25 Mar 2020 12:06:06 -0700
Message-ID: <CAEf4BzbEuWdb-77nm=o5doGfYbpWxbTe+U2mM+KH1hw6CnYuww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: don't allocate 16M for log buffer by default
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 9:20 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> For each prog/btf load we allocate and free 16 megs of verifier buffer.
> On production systems it doesn't really make sense because the
> programs/btf have gone through extensive testing and (mostly) guaranteed
> to successfully load.
>
> Let's assume successful case by default and skip buffer allocation
> on the first try. If there is an error, start with BPF_LOG_BUF_SIZE
> and double it on each ENOSPC iteration.
>
> v2:
> * Don't allocate the buffer at all on the first try (Andrii Nakryiko)
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/btf.c    | 20 +++++++++++++++-----
>  tools/lib/bpf/libbpf.c | 22 ++++++++++++++--------
>  2 files changed, 29 insertions(+), 13 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3d1c25fc97ae..bfef3d606b54 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -657,22 +657,32 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
>
>  int btf__load(struct btf *btf)
>  {
> -       __u32 log_buf_size = BPF_LOG_BUF_SIZE;
> +       __u32 log_buf_size = 0;
>         char *log_buf = NULL;
>         int err = 0;
>
>         if (btf->fd >= 0)
>                 return -EEXIST;
>
> -       log_buf = malloc(log_buf_size);
> -       if (!log_buf)
> -               return -ENOMEM;
> +retry_load:
> +       if (log_buf_size) {
> +               log_buf = malloc(log_buf_size);
> +               if (!log_buf)
> +                       return -ENOMEM;
>
> -       *log_buf = 0;
> +               *log_buf = 0;
> +       }
>
>         btf->fd = bpf_load_btf(btf->data, btf->data_size,
>                                log_buf, log_buf_size, false);
>         if (btf->fd < 0) {
> +               if (!log_buf || errno == ENOSPC) {
> +                       log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
> +                                          log_buf_size << 1);
> +                       free(log_buf);
> +                       goto retry_load;
> +               }
> +
>                 err = -errno;
>                 pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
>                 if (*log_buf)
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 085e41f9b68e..b2fd43a03708 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4855,8 +4855,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  {
>         struct bpf_load_program_attr load_attr;
>         char *cp, errmsg[STRERR_BUFSIZE];
> -       int log_buf_size = BPF_LOG_BUF_SIZE;
> -       char *log_buf;
> +       size_t log_buf_size = 0;
> +       char *log_buf = NULL;
>         int btf_fd, ret;
>
>         if (!insns || !insns_cnt)
> @@ -4896,22 +4896,28 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         load_attr.prog_flags = prog->prog_flags;
>
>  retry_load:
> -       log_buf = malloc(log_buf_size);
> -       if (!log_buf)
> -               pr_warn("Alloc log buffer for bpf loader error, continue without log\n");
> +       if (log_buf_size) {
> +               log_buf = malloc(log_buf_size);
> +               if (!log_buf)
> +                       pr_warn("Alloc log buffer for bpf loader error, continue without log\n");
> +

considering that log_buf is not allocated first time, if it fails to
allocate on retry then it should be an error, no?

Otherwise looks good, please add my ack after fixing this:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> +               *log_buf = 0;
> +       }
>
>         ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
>
>         if (ret >= 0) {
> -               if (load_attr.log_level)
> +               if (log_buf && load_attr.log_level)
>                         pr_debug("verifier log:\n%s", log_buf);
>                 *pfd = ret;
>                 ret = 0;
>                 goto out;
>         }
>
> -       if (errno == ENOSPC) {
> -               log_buf_size <<= 1;
> +       if (!log_buf || errno == ENOSPC) {
> +               log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
> +                                  log_buf_size << 1);
> +
>                 free(log_buf);
>                 goto retry_load;
>         }
> --
> 2.25.1.696.g5e7596f4ac-goog
>
