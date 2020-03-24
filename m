Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19EB191DA2
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCXXqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:46:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35695 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgCXXqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:46:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id e14so653248qts.2;
        Tue, 24 Mar 2020 16:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12i54rUV2CjnkiSHxgDtqYU9HJzD0mdT3615spsxFH8=;
        b=akXeOs+eztP6yWqwQKA1sCESeZjTy9HsVIQYasVqQf0g5d0KlmXD4Gy13x6nOa7C1S
         MAPFxJ6f3O3RJbgnt4dlFu7aUUnxt8w/F4Dy8KzcB4UfgmxCEhHSBclL/I4Xb4xuAMti
         AKlhopGzGDpBfvBicGW04W3LqBgiSawHATMJHJBGWU57oBI7oCabgHbtu0y/FcEyXZpK
         6qqLUHUpYBaHNenCEvrXfsu6IKDhwKcVNcrgCq8vRSLCG3LCAJoSMdt/zIBbZM2LIyZ+
         b8oFpyXdWhd1co1GumP+kAQi4H5uQ5/mVkzj2bsd+rqdnVLbwA8/Ss3yqaevNICoMH5q
         mpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=12i54rUV2CjnkiSHxgDtqYU9HJzD0mdT3615spsxFH8=;
        b=nCBXq0/SurpSUWmWnFY30s1Auc8rOHj17kKhSEVq3i+w1xUBZeIv/zTS/1ljCMCVDS
         UVY7jFTB4Fum902UzIunKjRG0Svvb5r6112rkutd9xuvl48gh36T8kP8mqoXndfbDKaY
         LLehgWZ/UaiURkWIJPnE6vRl5SNZdm9jro6MYqYVCy6W4J2+k7+zXvfWbgUS56R2G7dW
         QzT0g/CyOGZpG44lzeFcbpCTT7GUZIenaN6TkeqF75BkGkmDqrVc8UsXWfF3cmhVUdqj
         4w5utWdnnQXWs+LRd6Ptx4FWqqEZ72Nz6rHAtp5Ze73/DWFX7UW7tHyOJwlOrrDyRigU
         zFyQ==
X-Gm-Message-State: ANhLgQ0pyG8OHAyAF6eoVKdspCyQoDExZj5iaxLe0ECo7OeMslVG3scw
        dL4SBi5dmWsfqmvQaWqx0F+dfR0XDCbNnSdQhOw=
X-Google-Smtp-Source: ADFU+vsiBX7zxNz/Bx//POeFEBNxoJxycjjU1/vJCQ4IQvcyM2EFkezPLMDdBuohXJIuEutebn9T5lN+WQhcjkDtQ/0=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr404024qtv.59.1585093565473;
 Tue, 24 Mar 2020 16:46:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200324233120.66314-1-sdf@google.com>
In-Reply-To: <20200324233120.66314-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 16:45:54 -0700
Message-ID: <CAEf4BzbFOjSDw9YvsoZGtzWVbZykg62atNAgzt19audTXmvprw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: don't allocate 16M for log buffer by default
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

On Tue, Mar 24, 2020 at 4:31 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> For each prog/btf load we allocate and free 16 megs of verifier buffer.
> On production systems it doesn't really make sense because the
> programs/btf have gone through extensive testing and (mostly) guaranteed
> to successfully load.
>
> Let's switch to a much smaller buffer by default (128 bytes, sys_bpf
> doesn't accept smaller log buffer) and resize it if the kernel returns
> ENOSPC. On the first ENOSPC error we resize the buffer to BPF_LOG_BUF_SIZE
> and then, on each subsequent ENOSPC, we keep doubling the buffer.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/btf.c             | 10 +++++++++-
>  tools/lib/bpf/libbpf.c          | 10 ++++++++--
>  tools/lib/bpf/libbpf_internal.h |  2 ++
>  3 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3d1c25fc97ae..53c7efc3b347 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -657,13 +657,14 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
>
>  int btf__load(struct btf *btf)
>  {
> -       __u32 log_buf_size = BPF_LOG_BUF_SIZE;
> +       __u32 log_buf_size = BPF_MIN_LOG_BUF_SIZE;
>         char *log_buf = NULL;
>         int err = 0;
>
>         if (btf->fd >= 0)
>                 return -EEXIST;
>
> +retry_load:
>         log_buf = malloc(log_buf_size);
>         if (!log_buf)
>                 return -ENOMEM;

I'd argue that on first try we shouldn't allocate log_buf at all, then
start allocating it using reasonable starting size (see below).

> @@ -673,6 +674,13 @@ int btf__load(struct btf *btf)
>         btf->fd = bpf_load_btf(btf->data, btf->data_size,
>                                log_buf, log_buf_size, false);
>         if (btf->fd < 0) {
> +               if (errno == ENOSPC) {
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
> index 085e41f9b68e..793c81b35ccc 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4855,7 +4855,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  {
>         struct bpf_load_program_attr load_attr;
>         char *cp, errmsg[STRERR_BUFSIZE];
> -       int log_buf_size = BPF_LOG_BUF_SIZE;
> +       size_t log_buf_size = BPF_MIN_LOG_BUF_SIZE;
>         char *log_buf;
>         int btf_fd, ret;
>
> @@ -4911,7 +4911,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         }
>
>         if (errno == ENOSPC) {

same, doing if (!log_buf || errno == ENOSPC) should handle this
without any other major changes?

> -               log_buf_size <<= 1;
> +               if (errno == ENOSPC) {
> +                       log_buf_size = max((size_t)BPF_LOG_BUF_SIZE,
> +                                          log_buf_size << 1);
> +                       free(log_buf);
> +                       goto retry_load;
> +               }
> +
>                 free(log_buf);
>                 goto retry_load;
>         }
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 8c3afbd97747..2720f3366798 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -23,6 +23,8 @@
>  #define BTF_PARAM_ENC(name, type) (name), (type)
>  #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
>
> +#define BPF_MIN_LOG_BUF_SIZE 128

This seems way too low, if there is some error it almost certainly
will be too short, probably for few iterations, just causing waste.
Let's make it something a bit more reasonable, like 32KB or something?

> +
>  #ifndef min
>  # define min(x, y) ((x) < (y) ? (x) : (y))
>  #endif
> --
> 2.25.1.696.g5e7596f4ac-goog
>
