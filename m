Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3436BCFE8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCPMwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCPMwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:52:32 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4DD591E7;
        Thu, 16 Mar 2023 05:52:30 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5447d217bc6so29409947b3.7;
        Thu, 16 Mar 2023 05:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678971150;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T7Jpy4DSfLMpiwHA6jiHTwcb088wWJhvD55NBMwMR6c=;
        b=hwCb44imd9ou/Bo1fjQGD5719+dbzGjsyBvpU3QDc0PO57feC5zFL/Y76CKShclQxk
         nPLXTsmur0gZWQywhu104XckHZ1TNA72kZ7/rqsO23xLOqqbc4+M7YXIrM3MKnVGg8ZK
         Adrn0ulKvyEnwnqFwMRt38xrgUkqqta6IYXiuX0u2eFWDNqZ7qU+OvTmurmI/l/Mm+ej
         RmmLoHy8yMIW80GMgMns4VBmlXCPsouP9LM5rrGhnRdwFKXuWDtvwk+y/3NOGXdbOKyL
         waaw5Mq7ebQ+wqdJNedECWPMGximDPEPOrrmF7gpEQSN+TjIM1CFiNx5crZGt97kExhp
         O9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678971150;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T7Jpy4DSfLMpiwHA6jiHTwcb088wWJhvD55NBMwMR6c=;
        b=J+vq1gnSG0Xn9Fmj+lT2pwoncy8WDQSwxiCFVsS1QI/bwKGRBaOGj5VQHYmVfpECor
         4ujUnd37de/ElJHGPNsrvkKUlnBI1A6+620Ec/5bCv1osgHmE9Ejl70dQQ1wm38irZiV
         jgrGkgk8MK5J2BVPjPR3Jo9kRaW2svwtJcjmEWyq2W4u3hdt7XytTkBDAk37GcHn5bmM
         TmrGTcK1pPoLSDxWOJSKtxUcSqUIS8ZliAVFgUjIxNLKtTlH7mHXOWCplPhQAj8pFsP7
         y+7fkcsyeFgXmaAvKc6zSKQJdyXvQgZ9nmdynEQVLNoMv6fQMp02fbTUvt+qNd00AGcb
         /9+w==
X-Gm-Message-State: AO0yUKVnE+lRLQs7+z0/fPNcydJUQyjB/eXbG7/TQ/eYVsF6vRQJUBot
        RjGU2mQnENWqjXYGDxCQyih+J6s2C/DYRSfk8lE=
X-Google-Smtp-Source: AK7set/lUb1zkA82VJfdvVqjluyqa8oIprHbNum2MPdeRl/SU3i49Ig6UkvLYfhxclQj2+s7v4D+zAv///msbIpNgpA=
X-Received: by 2002:a81:af46:0:b0:541:8285:b25 with SMTP id
 x6-20020a81af46000000b0054182850b25mr2007186ywj.10.1678971149933; Thu, 16 Mar
 2023 05:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230308174013.1114745-1-kal.conley@dectris.com>
In-Reply-To: <20230308174013.1114745-1-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Mar 2023 13:52:18 +0100
Message-ID: <CAJ8uoz1f1RSWtFspPQsEBoH_j3=jUYkDmye3nHRQ_xvgHiusHg@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xsk: Add missing overflow check in xdp_umem_reg
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Mar 2023 at 18:51, Kal Conley <kal.conley@dectris.com> wrote:
>
> The number of chunks can overflow u32. Make sure to return -EINVAL on
> overflow.
>
> Also remove a redundant u32 cast assigning umem->npgs.

Thanks!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xdp_umem.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 4681e8e8ad94..02207e852d79 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -150,10 +150,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
>
>  static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
> -       u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
>         bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
> -       u64 npgs, addr = mr->addr, size = mr->len;
> -       unsigned int chunks, chunks_rem;
> +       u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
> +       u64 addr = mr->addr, size = mr->len;
> +       u32 chunks_rem, npgs_rem;
> +       u64 chunks, npgs;
>         int err;
>
>         if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> @@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>         if (npgs > U32_MAX)
>                 return -EINVAL;
>
> -       chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
> -       if (chunks == 0)
> +       chunks = div_u64_rem(size, chunk_size, &chunks_rem);
> +       if (!chunks || chunks > U32_MAX)
>                 return -EINVAL;
>
>         if (!unaligned_chunks && chunks_rem)
> @@ -202,7 +203,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>         umem->headroom = headroom;
>         umem->chunk_size = chunk_size;
>         umem->chunks = chunks;
> -       umem->npgs = (u32)npgs;
> +       umem->npgs = npgs;
>         umem->pgs = NULL;
>         umem->user = NULL;
>         umem->flags = mr->flags;
> --
> 2.39.2
>
