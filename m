Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF223C597
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHEGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEGNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:13:01 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619F4C06174A;
        Tue,  4 Aug 2020 23:13:01 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id e187so10892185ybc.5;
        Tue, 04 Aug 2020 23:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9iXihjRFVPg2A7GpZV7d5YBUlfuYnief6L8DzAwhNQU=;
        b=n6Y2H2WWmCMbfqbcljcDHEqK1L+Ew6tQnJwT1yINtKYqsk2lozkArB54gZVRfb4Lqp
         BX+JkfGswldenIkYA4ZtPlHkBCoH/4Pcd8mqKuw1nTvhtvV/cQdj8k7s9C4WYr8sj6zS
         JHbi/dIzy+GxYIh0+vrA/VoJtqY7KZx9jYXck+pwuEFVZidIB5vaVHoBL0kEA1aOUTym
         goZZ92Axo07KJrviU+TVyCEv4nC+RSqJqxisK55gfii+FZrBAY9kvW32DTdPedzYAvRk
         x/Ldn89C1dvXZGK8AXOwfsLhNQ0jKnXEiuTCAfwvfKnOvU3ZIcz+ZT8c0u6YUj4fA1kA
         Gz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9iXihjRFVPg2A7GpZV7d5YBUlfuYnief6L8DzAwhNQU=;
        b=WVYPQmeEy1oNUTiC9jtW0yqO5AyigiMA+HGSv56D+oMYPmyrE2fHBTz40fZTc1Cjhw
         c4QZTfGjLRHk+ANZQrlwgpSu9QgY2hpJqV6CJ1S89iDbNoP4R/hize0AebInytk7UmYD
         pFkNPFn6ks/56bW7uKHivlJMQbTCVgbXOpiNqlv/aUA12nylXpBYdC8OeQAwPwrbxCxe
         JlNSZs0rI6ORt4M0M/O5C8iLJx5tgllRbQ5Y+ibKuBaRAbi2v24zSa/jh+8uksFHJsfB
         g6Bb/KSR5zO3f3RP05mk06K7osSBpBK9G7PXVOGetVsTLqZPBPKZiDsUbhuv7oHq1xRe
         YGQQ==
X-Gm-Message-State: AOAM530onvrawmvh9uJd0Oxv4+Ruf0Ax8DDO5XkZzUOx61QVXcwYqmNe
        s5368ompeQwjz4LLWPV6UmWo/gPHvat3X3svyTM=
X-Google-Smtp-Source: ABdhPJxTcYVEbJrxK9CDw9YdYiRjgtL8ctcMiDxLOHWTnUuVYoW6JtMFG5/PxsWXYdlpbC0npmNhUuqOKLj1uEZjskA=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr2582970ybg.347.1596607980723;
 Tue, 04 Aug 2020 23:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-7-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:12:49 -0700
Message-ID: <CAEf4BzYtO+ELTpBVwWmWRkmgOCmCnCWU6iZzYjfNRHvb7rgEJg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 06/14] bpf: Remove recursion call in btf_struct_access
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Andrii suggested we can simply jump to again label
> instead of making recursion call.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/btf.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index bc05a24f7361..0f995038b589 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3931,14 +3931,13 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                 /* Only allow structure for now, can be relaxed for
>                  * other types later.
>                  */
> -               elem_type = btf_type_skip_modifiers(btf_vmlinux,
> -                                                   array_elem->type, NULL);
> -               if (!btf_type_is_struct(elem_type))
> +               t = btf_type_skip_modifiers(btf_vmlinux, array_elem->type,
> +                                           NULL);
> +               if (!btf_type_is_struct(t))
>                         goto error;
>
> -               off = (off - moff) % elem_type->size;
> -               return btf_struct_access(log, elem_type, off, size, atype,
> -                                        next_btf_id);
> +               off = (off - moff) % t->size;
> +               goto again;

Transformation looks good, thanks. So:

Acked-by: Andrii Nakryiko <andriin@fb.com>

But this '% t->size' makes me wonder what will happen when we have an
array of zero-sized structs or multi-dimensional arrays with
dimensions of size 0... I.e.:

struct {} arr[123];

or

int arr[0][0]0];

We should probably be more careful with division here.

>
>  error:
>                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
> --
> 2.25.4
>
