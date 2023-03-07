Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347E96AF3D4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjCGTKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbjCGTJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:09:44 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486E3C2228
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:54:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id da10so56493936edb.3
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 10:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1678215266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/VPBd1/cIEQ8mvitb5S4xC+5LiGWv+b4kdw/T6kpKD0=;
        b=Us2QhbUw+z3a2uMeUo1LJSWaebmcvd+wDCt5aYNo2hpwlTJSznm8XCZbQ/Hii9DzQK
         0iODEn5ABEY6J5Hq5ltbknnHfB9rnPSWiFoI9H1QE2wFDEmc6nFqGD41YQWfyPXLvDZf
         5wrFua3K05oDlr5QlF+zW6aXgF2AnFskagR24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215266;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/VPBd1/cIEQ8mvitb5S4xC+5LiGWv+b4kdw/T6kpKD0=;
        b=KbTkBBIt146bZG4hz38GHq0Ww6yggB+5zDDLmVVrnbPis3vqfg3n6Z3fs/2ZsjENXd
         JrIyhIZZZkSDZHD6fWBIlQl1o4hVfxNobPZECJ5QEqpSzhiQZymLYRyYkgWpFb8r4Mt0
         Hnch9T+ueFTL2x9gSYWgOlZ4LO0xl0aUt4ZYfsnE/UYPXRWj/PrnHFJn7YIy0r5Gt7BN
         8RHRtBcOLoUU7JnLGig4aljPG8ifpA6xjXhL4CTzqq3CmSNlI3jXiEvb31X2vLRYYyx+
         i55mu/Tx5HFE1RfsErergtWUSPp0bLXHUcMOIThyFcAi29xI0mWRfU7SdcL/P6LZWtvb
         qJOA==
X-Gm-Message-State: AO0yUKU3r6LNsuIxKv5M6MdVJR5hkKqW+LBjZDhgWdIcaTzS4C/WupYA
        gBN9rlfGDhy+HjHYNR9rPruaRPfDLaJw7C6LMkuIhA==
X-Google-Smtp-Source: AK7set85kBrN1ckdrgzPkzy2USMui/e5AnEbftp45IcxQYYItIX0J6t9Ki/qiu+re1+A5Mqm8btG1ezrj/FIr7l48Xo=
X-Received: by 2002:a50:9fcd:0:b0:4ad:7389:d298 with SMTP id
 c71-20020a509fcd000000b004ad7389d298mr8543872edf.4.1678215266512; Tue, 07 Mar
 2023 10:54:26 -0800 (PST)
MIME-Version: 1.0
References: <20230307172306.786657-1-kal.conley@dectris.com> <ee0aa756-4a9c-1d7a-4179-78024e41d37e@intel.com>
In-Reply-To: <ee0aa756-4a9c-1d7a-4179-78024e41d37e@intel.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Tue, 7 Mar 2023 19:58:51 +0100
Message-ID: <CAHApi-kcvc2qB0D6dV7OG99FsnzAEa-rchOMfySkZ-E=EOh_4w@mail.gmail.com>
Subject: Re: [PATCH] xsk: Add missing overflow check in xdp_umem_reg
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
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
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The RCT declaration style is messed up in the whole block. Please move
> lines around, there's nothing wrong in that.

I think I figured out what this is. Is this preference documented
somewhere? I will fix it.

>
> >       int err;
> >
> >       if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> > @@ -188,8 +189,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
> >       if (npgs > U32_MAX)
> >               return -EINVAL;
> >
> > -     chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
> > -     if (chunks == 0)
> > +     chunks = div_u64_rem(size, chunk_size, &chunks_rem);
> > +     if (chunks == 0 || chunks > U32_MAX)
>
> You can change the first cond to `!chunks` while at it, it's more
> preferred than `== 0`.

If you want, I can change it. I generally like to keep unrelated
changes to a minimum.

>
> >               return -EINVAL;
>
> Do you have any particular bugs that the current code leads to? Or it's
> just something that might hypothetically happen?

If the UMEM is large enough, the code is broke. Maybe it can be
exploited somehow? It should be checked for exactly the same reasons
as `npgs` right above it.

>
> >
> >       if (!unaligned_chunks && chunks_rem)
> > @@ -201,7 +202,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
> >       umem->size = size;
> >       umem->headroom = headroom;
> >       umem->chunk_size = chunk_size;
> > -     umem->chunks = chunks;
> > +     umem->chunks = (u32)chunks;
>
> You already checked @chunks fits into 32 bits, so the cast can be
> omitted here, it's redundant.

I made it consistent with the line right below it. It seems like the
cast may improve readability since it makes it known the truncation is
on purpose. I don't see how that is redundant with the safety check.
Should I change both lines?

>
> >       umem->npgs = (u32)npgs;
> >       umem->pgs = NULL;
> >       umem->user = NULL;
>
> Thanks,
> Olek

Kal
