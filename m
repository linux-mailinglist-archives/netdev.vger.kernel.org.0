Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36C531715A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhBJU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbhBJU1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:27:12 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41423C06174A;
        Wed, 10 Feb 2021 12:26:32 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id p193so3351863yba.4;
        Wed, 10 Feb 2021 12:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBf4S9Gb1zWhjk6tip4xtVHLOf1g8wLduC5wilk76nY=;
        b=KoAfvBqk4oH9PxYnTnsfoqZrtJZQtjZZ7+QCY6GyjvW0WLXY1pqaGnFabNWkjNMeT/
         7Etx+/MR2lMpMBlCA6wWGiI19v4Q1YopPUtKA1tZDC05p2s4TsoHm2ZjTrvfHTcHszJh
         F4IbTq/V6E8BtPOiB3UhNScL9BLP/r65DOlgsLedfXgMZ4czEwdft+CCNyCDE+JvOVI7
         XZNn4SQia7MVeTr7hoO+mrZCtbm9CG5wLpU+P8/e65KIrcpeB4UgWFhGo517LwoqJhiJ
         ngmIVOc6w6E+Dp7N63XbLq8gQ7sVEqDSW0JBedwwCRb5poxEU8vGcrgjIpcy9zmhIHna
         DDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBf4S9Gb1zWhjk6tip4xtVHLOf1g8wLduC5wilk76nY=;
        b=YmBf2cmLR5qG9RtHwJA2K/VioISX4N+iitbJMv+rJNzlEZNVUJUXUx+jymqcR1EBCd
         0eL8mx7GahFNeUuQ0J0Cf1RbC0j6yrTGZ5Woqi5IPD3gTp6I02DSPPQytIZ20d57VVPJ
         icEASv0APwTngdo/9T+RqJHUTo16krSuCod7+PgKYOscNZWYFKseDPFAqYHJBMbILkM+
         ht/0+mm4Z21uZx5hKJjL9AZqhsdfOdLWGkS723iyIEzwLiL59V0WzkOQVBygUy8mVmyJ
         YKstry+zR5gucIqwMrHOk9d5spDGhO6MI96vOViDjgl/x1oVq7+tfcoWeGtZdsjy3YSK
         sg4g==
X-Gm-Message-State: AOAM530cdnuSYs3bTLUIAnAy5IzUGAplxItT3+52WeQk4YoKF8+aMV5d
        JEC5W+6Ko/I3oQrk40xHDEojZaeZ4c/mAWUMo8hm0RRoaidCfA==
X-Google-Smtp-Source: ABdhPJw1WePKAkyl6q9ai+CG7sCzbNTMHKMzwThKcCUPov/Mt6KrDMHlZb8h4BHF3mnJ2PDEruqAML8+voUJ0RHKGic=
X-Received: by 2002:a25:c905:: with SMTP id z5mr6611202ybf.260.1612988791591;
 Wed, 10 Feb 2021 12:26:31 -0800 (PST)
MIME-Version: 1.0
References: <20210209193105.1752743-1-kafai@fb.com>
In-Reply-To: <20210209193105.1752743-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 12:26:20 -0800
Message-ID: <CAEf4BzYmTSfRv4vhPeDiYq-zdoAE9rvy=hszsQNUzQ3noeii-Q@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] libbpf: Ignore non function pointer member in struct_ops
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 12:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> When libbpf initializes the kernel's struct_ops in
> "bpf_map__init_kern_struct_ops()", it enforces all
> pointer types must be a function pointer and rejects
> others.  It turns out to be too strict.  For example,
> when directly using "struct tcp_congestion_ops" from vmlinux.h,
> it has a "struct module *owner" member and it is set to NULL
> in a bpf_tcp_cc.o.
>
> Instead, it only needs to ensure the member is a function
> pointer if it has been set (relocated) to a bpf-prog.
> This patch moves the "btf_is_func_proto(kern_mtype)" check
> after the existing "if (!prog) { continue; }".
>
> The "btf_is_func_proto(mtype)" has already been guaranteed
> in "bpf_object__collect_st_ops_relos()" which has been run
> before "bpf_map__init_kern_struct_ops()".  Thus, this check
> is removed.
>
> Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Looks good, see nit below.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6ae748f6ea11..b483608ea72a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -887,12 +887,6 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map,
>                         kern_mtype = skip_mods_and_typedefs(kern_btf,
>                                                             kern_mtype->type,
>                                                             &kern_mtype_id);
> -                       if (!btf_is_func_proto(mtype) ||
> -                           !btf_is_func_proto(kern_mtype)) {
> -                               pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n",
> -                                       map->name, mname);
> -                               return -ENOTSUP;
> -                       }
>
>                         prog = st_ops->progs[i];
>                         if (!prog) {

debug message below this line is a bit misleading, it talks about
"func ptr is not set", but it actually could be any kind of field. So
it would be nice to just talk about "members" or "fields" there, no?

> @@ -901,6 +895,12 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map,
>                                 continue;
>                         }
>
> +                       if (!btf_is_func_proto(kern_mtype)) {
> +                               pr_warn("struct_ops init_kern %s: kernel member %s is not a func ptr\n",
> +                                       map->name, mname);
> +                               return -ENOTSUP;
> +                       }
> +
>                         prog->attach_btf_id = kern_type_id;
>                         prog->expected_attach_type = kern_member_idx;
>
> --
> 2.24.1
>
