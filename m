Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32C0E565E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfJYWIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:08:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40641 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:08:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id o49so5545755qta.7;
        Fri, 25 Oct 2019 15:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LWKlUaogNYnS3K8DmwBz8ORZPUMtELVN3CSeAYljbE=;
        b=TlTnzAt5wjUXjHADyN+p1EoZi7S4jyXFtYgMmsc72T7gXim5y3t5lnXJGiifk4YzK/
         0BMCLrxBl4Oe3ugwSsibrxqNLvR6Lcp8AdD67jiRV/37y1Xc30jWzfaqMVtYC8ejgTps
         9pKFhjh6jHnnLyhsvacoG5d6GgfF2URlLLzhrXWlQyeF0IagG5L5lgmy51W3L8ckhyA8
         pkM94mM7ZLzaXRiBKJ4leDR3DcyCRyAn2snDmrSDq1OQdY+HTtxH+k5SLE5erIlJ5BkJ
         YJt/BcnCv9d96of+s7RfXoYyct7aFWksKYPWlS3PPSVLIk5zdcnvPAn2madfX721L092
         +qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LWKlUaogNYnS3K8DmwBz8ORZPUMtELVN3CSeAYljbE=;
        b=LrhxYu0OzZqy9/mUZ467swvcvpS3H2ggjvdopnegud3RpI3G/3/TWBk2gL48mfMUQd
         AoOalnpFn/OhsWvBS4q0L4mWajnKCzOYl3AlGRg48vwkFJLqhjN9csdtLlyn83rru71g
         4dpgqJgoSOhsX561mf+7BYvMX7EWGeV+3KhZp3E2FejBCcREV60ev6Ro21COhhXK9zee
         09Q+vzKkD2SaJ9fUYx9cwm25N/+ubj2bP3kmw94gtSeZ1bXW0y0L6s9SlKE0x+yjzEL3
         bzY+8qmQtK00mwMlqgUUMQD/5krbwrZXRIm0+X21iG9nELcSQx924FJx1zBkawY07kfU
         iSTQ==
X-Gm-Message-State: APjAAAXEvf0AoWtqFituo58hXrSSqkP/NQaNelVyqyyTLTZAWsYS8jh6
        n4VvIs9hZ3GEv7O+Z0W3msM6iYY99bWa2HluhNSHC5a5
X-Google-Smtp-Source: APXvYqwOJsB+Um7g58gfOPRtQS/wy/RaTd6YS3o6tIAQKSxpDSQO7sm9j79jtVzdYFA8BL2eK+1o52E0t3yG+pE4KIo=
X-Received: by 2002:a0c:c2d3:: with SMTP id c19mr5807792qvi.158.1572041308118;
 Fri, 25 Oct 2019 15:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <c4d464c7b06a13b7b8c50fce02ef5e7c76111b33.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <c4d464c7b06a13b7b8c50fce02ef5e7c76111b33.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 15:08:16 -0700
Message-ID: <CAEf4Bzb30P_jcWmjX-oo3VxRmPGyjDfULgQM0xz9JOmdgKkcRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] bpf: Add probe_read_{user,kernel} and
 probe_read_str_{user,kernel} helpers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> The current bpf_probe_read() and bpf_probe_read_str() helpers are broken
> in that they assume they can be used for probing memory access for kernel
> space addresses /as well as/ user space addresses.
>
> However, plain use of probe_kernel_read() for both cases will attempt to
> always access kernel space address space given access is performed under
> KERNEL_DS and some archs in-fact have overlapping address spaces where a
> kernel pointer and user pointer would have the /same/ address value and
> therefore accessing application memory via bpf_probe_read{,_str}() would
> read garbage values.
>
> Lets fix BPF side by making use of recently added 3d7081822f7f ("uaccess:
> Add non-pagefault user-space read functions"). Unfortunately, the only way
> to fix this status quo is to add dedicated bpf_probe_read_{user,kernel}()
> and bpf_probe_read_str_{user,kernel}() helpers. The bpf_probe_read{,_str}()
> helpers are aliased to the *_kernel() variants to retain their current
> behavior; for API consistency and ease of use the latter have been added
> so that it is immediately *obvious* which address space the memory is being
> probed on (user,kernel). The two *_user() variants attempt the access under
> USER_DS set.
>
> Fixes: a5e8c07059d0 ("bpf: add bpf_probe_read_str helper")
> Fixes: 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  include/uapi/linux/bpf.h       | 119 ++++++++++++++++++++---------
>  kernel/trace/bpf_trace.c       | 133 ++++++++++++++++++++++-----------
>  tools/include/uapi/linux/bpf.h | 119 ++++++++++++++++++++---------
>  3 files changed, 253 insertions(+), 118 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4af8b0819a32..b8ffb419df51 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -564,7 +564,11 @@ union bpf_attr {
>   * int bpf_probe_read(void *dst, u32 size, const void *src)
>   *     Description
>   *             For tracing programs, safely attempt to read *size* bytes from
> - *             address *src* and store the data in *dst*.
> + *             kernel space address *src* and store the data in *dst*.
> + *
> + *             This helper is an alias to bpf_probe_read_kernel().
> + *
> + *             Generally, use bpf_probe_read_user() or bpf_probe_read_kernel() instead.
>   *     Return
>   *             0 on success, or a negative error in case of failure.
>   *
> @@ -1428,43 +1432,14 @@ union bpf_attr {
>   *
>   * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)

seems like an approriate time to standardize terminology. Should it be
unsafe_ptr like here, or src like in bpf_probe_read description?

>   *     Description
> - *             Copy a NUL terminated string from an unsafe address
> - *             *unsafe_ptr* to *dst*. The *size* should include the
> - *             terminating NUL byte. In case the string length is smaller than
> - *             *size*, the target is not padded with further NUL bytes. If the
> - *             string length is larger than *size*, just *size*-1 bytes are
> - *             copied and the last byte is set to NUL.
> - *

[...]

>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -2888,7 +2929,11 @@ union bpf_attr {
>         FN(sk_storage_delete),          \
>         FN(send_signal),                \
>         FN(tcp_gen_syncookie),          \
> -       FN(skb_output),
> +       FN(skb_output),                 \
> +       FN(probe_read_user),            \
> +       FN(probe_read_kernel),          \
> +       FN(probe_read_str_user),        \
> +       FN(probe_read_str_kernel),

naming is subjective, but I'd go with probe_{user,kernel}_read[_str]
scheme, but given bpf_probe_write_user and desire to stay consistent,
I'd still stick to slightly different probe_read_{user,kernel}[_str]
scheme.

>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 79919a26cd59..ff001b766799 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -138,12 +138,52 @@ static const struct bpf_func_proto bpf_override_return_proto = {
>  };
>  #endif
>

[...]
