Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145E9DD559
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbfJRX2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:28:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42425 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:28:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id w14so11483281qto.9;
        Fri, 18 Oct 2019 16:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6lpCIrsMYPYcD9InY4Cu70Jl8jCrSHSWXe2rgvlZ9M=;
        b=rlckflWxbZ6myo1EBYdxg6/xMH+HOqdIKmkHKAucZ2w+uT3iWrKaENvMRBgB6yRbc5
         11ysmebnFl6C8TBZeVvEc7V9WKmEHZSaFCFgDKNUq9i9StUn5TfDjk/x5vQzCxu5jlmS
         8WBJXzrGieJo8Er3+dWIry3JKhKN2scaDFPc6qp9WI91l0E5HBo574RM3bYcono6GT+D
         pWno0rlnoeVgyBfuSEYDqPXaw8yUlrVjHyDwCZDBNo+e7A+u117421KJor8pox3Yn1qQ
         ARqVMUjaoFtFjZufnBm4H/v98MjGXDQl6cPegaAfswPTHEYDaJDraW/dZXOynwxfjIxW
         NECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6lpCIrsMYPYcD9InY4Cu70Jl8jCrSHSWXe2rgvlZ9M=;
        b=SUhzxYqTN5ncbfFw4kz1IVvc7TBx53POiDP+UcHT1FDvViFJGFVG/B0rmNPrLLp9tF
         kuCtrzPg9g9NxS/P53uP7tm7s2qnTuCjZnlwjRWsW4Ax7D8tRHmj+mbKcKioeICMb7Rg
         oJEYz1cHRUhiU4MekzRdXypShSNHYYJnnMpcmeI/De2UJUdTW7nM69c+MMKkCp0GSwWC
         IhOfGoUXRNblQkNqjaNqVNom3GKCQzcrO3QZj+ybtrvXHjDrJHriJKKjd4fipyHgQXqS
         avxTFliUq06fHVNz6iyYiORL7imfSQNJA3TGBw5QczkFzg9GowRI1GX+KdtyOc79eMQ3
         tatg==
X-Gm-Message-State: APjAAAU7LS1CH6uDweAKiILUBioQ0Y3YBvQkFpk6VU81cNBIAbuFfFGc
        CtJsnr06RGZPpn0iKBRh6aLmuxRt3C3pGYpq8gMgTOhS
X-Google-Smtp-Source: APXvYqy8RjoIm9zAVBy+wdcNAWGxZ4BSfPHQgOsxkbchQU83enGMIwioL1dR8cKQMDjPWZQhTIWd01WiHkk6GAajAmI=
X-Received: by 2002:a05:6214:5cf:: with SMTP id t15mr5067795qvz.196.1571441311022;
 Fri, 18 Oct 2019 16:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191018060933.2950231-1-ast@kernel.org>
In-Reply-To: <20191018060933.2950231-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Oct 2019 16:28:19 -0700
Message-ID: <CAEf4BzZKTHMqyTsLk-4ysjyRpN1sRN_vK1yn5HfAFWfqKZ=B-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_attr.attach_btf_id check
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 4:25 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Only raw_tracepoint program type can have bpf_attr.attach_btf_id >= 0.

typo: just > (code is actually correct, though)

> Make sure to reject other program types that accidentally set it to non-zero.
>
> Fixes: ccfe29eb29c2 ("bpf: Add attach_btf_id attribute to program load")
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 523e3ac15a08..16ea3c0db4f6 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1570,6 +1570,17 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>                            enum bpf_attach_type expected_attach_type,
>                            u32 btf_id)
>  {
> +       switch (prog_type) {
> +       case BPF_PROG_TYPE_RAW_TRACEPOINT:
> +               if (btf_id > BTF_MAX_TYPE)
> +                       return -EINVAL;
> +               break;
> +       default:
> +               if (btf_id)
> +                       return -EINVAL;
> +               break;
> +       }
> +
>         switch (prog_type) {
>         case BPF_PROG_TYPE_CGROUP_SOCK:
>                 switch (expected_attach_type) {
> @@ -1610,13 +1621,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>                 default:
>                         return -EINVAL;
>                 }
> -       case BPF_PROG_TYPE_RAW_TRACEPOINT:
> -               if (btf_id > BTF_MAX_TYPE)
> -                       return -EINVAL;
> -               return 0;
>         default:
> -               if (btf_id)
> -                       return -EINVAL;
>                 return 0;
>         }
>  }
> --
> 2.17.1
>
