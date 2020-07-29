Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895902326D6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgG2VgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727775AbgG2VgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:36:10 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF96D2053B;
        Wed, 29 Jul 2020 21:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596058570;
        bh=cg9ZkTZgwoi1MOIboVnw0S2lL2mefCcWKqgPPQms7I8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s+8zrJ6GCoYrHRRNEnj+nXaGs51Od6Yqdr5H0hw9DdwoavNKwuJX0mpGEJCGnRJXZ
         Jv9bLbTh2oVt04Asq4aA6/H4txSsYLqMZSKE90UkqJbUhec6WjSw5WHUvzfM1mPJt1
         mBsZDWMTWmcBdcLdnxld6s3LWpADe/vCHYqVX0Iw=
Received: by mail-lf1-f51.google.com with SMTP id h8so13813024lfp.9;
        Wed, 29 Jul 2020 14:36:09 -0700 (PDT)
X-Gm-Message-State: AOAM533hHk/EaHH0n641ahPfGJ4G5cV8HwRgUI5NT4HZJoLgEEuO0yXC
        R/Tpelwd3I+NidPaS6w68AuS9+AV2GJeOI0iZ+Q=
X-Google-Smtp-Source: ABdhPJz2VCnfb8b3Z6VNqZbccAEguD7qJX1yhonk8p/4wUGbLeRBaXomq2CAJ5g+0ueEmbVFLQkrWqaSGhfFZfBJ0gU=
X-Received: by 2002:a19:c501:: with SMTP id w1mr94378lfe.172.1596058568103;
 Wed, 29 Jul 2020 14:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
 <159603981285.4454.14040533307191666685.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603981285.4454.14040533307191666685.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 14:35:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7qesH-NwNgeOM4A04BggD=AzJoQrQ-fB1gdG-3xAcxGQ@mail.gmail.com>
Message-ID: <CAPhsuW7qesH-NwNgeOM4A04BggD=AzJoQrQ-fB1gdG-3xAcxGQ@mail.gmail.com>
Subject: Re: [bpf PATCH v2 3/5] bpf, selftests: Add tests for ctx access in
 sock_ops with single register
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:24 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
[...]

>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> index 1f1966e..f8b13682 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> @@ -54,6 +54,7 @@ SEC("sockops")
>  int bpf_testcb(struct bpf_sock_ops *skops)
>  {
>         char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
> +       struct bpf_sock_ops *reuse = skops;
>         struct tcphdr *thdr;
>         int good_call_rv = 0;
>         int bad_call_rv = 0;
> @@ -62,6 +63,18 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>         int v = 0;
>         int op;
>
> +       /* Test reading fields in bpf_sock_ops using single register */
> +       asm volatile (
> +               "%[reuse] = *(u32 *)(%[reuse] +96)"
> +               : [reuse] "+r"(reuse)
> +               :);
> +
> +       asm volatile (
> +               "%[op] = *(u32 *)(%[skops] +96)"
> +               : [op] "+r"(op)
> +               : [skops] "r"(skops)
> +               :);
> +

Shall we add a separate test for this? It does seem to fix in bpf_testcb().

>         op = (int) skops->op;
>
>         update_event_map(op);
>
