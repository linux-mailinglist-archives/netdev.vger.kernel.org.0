Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA66515F80
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbiD3RWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiD3RWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:22:16 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D354F5BD2C
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:18:53 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v59so19569383ybi.12
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdjPDbeiBk/GAF5DBTylhZNXZUPG7WMDxyxGtiNrPVk=;
        b=lFjJvaMxDTRnYFyna4f3dyt2Cz6JHfYmjp2lCQJth3zMbXGVBFhv/txKTmFe6IebTl
         9IHme/uckxAzXRSCNCuBnGLYske96AZmPoO/D3yZ5Z4lUaZhbTUthd30TptQcpwDdorW
         yOb+cj34Y1McwPsXrVz1AvTPHT4aW0nrk32a1Leht/xT9JdfpxXs4vNnYClo5mVFI3nF
         NlsxqAuJ4AKXauw+Yh/PY3N46mM/hSiJANPN7atcKOCjGxEa8ntysD10oqv4OLLEqK6L
         ZTbK4rsf4JcRXVwNqi4s+L9BXyyUpAHj3LtIFjYG61fFZu4Bj1wNuTJ0zjeD1Ax0d5ev
         hAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdjPDbeiBk/GAF5DBTylhZNXZUPG7WMDxyxGtiNrPVk=;
        b=68ihJ5po4UZ6UCHsNxVY426gCxUdjI2mdWnpXDVOieMaLcIONNLMB2jzNfwdfXly/T
         pNSEKhcCJGrEAaJqA2YHI7rEXnt4JWIfsLinGOFIT4Sp+aJuXeP++kG84VcqRCiDHEvB
         nlKsR9e/4t0zbdXzjuXh43uvs8jFAp1rGTEIG+ngulhuhLXBCGpINiaDwZBYtMxTR40r
         vyw7zNLDxSFKOxvjmG6Twiq2BWv1hgFjLpkj/ixvbYnDfr4RIXWQdXYsbRgIWvSq9c18
         haReFQ3DCd76N2PlXaE1WyTRLHZ/2lv1K5XJtsTHt/7bfDBK7CkTMaf7BaGf/QB3/khD
         fYhg==
X-Gm-Message-State: AOAM530qj5vf5yVJCcoUmzDXMXCnzDcnY7AXzdA1XlDdGvIolWx+ewxv
        Z9SEGOT5vpUTpfkEDA+1RB7zsr9J5B1bw1WYO7M=
X-Google-Smtp-Source: ABdhPJxMsqFMaTRa8I+Yn6p95yM6NAHxOpSVsEIw6jh5005jp5mjK+Kccm8Q2CatLIvMdm7GHCxI/kjWL6TgqmBsxv4=
X-Received: by 2002:a25:cc46:0:b0:645:d969:c0b6 with SMTP id
 l67-20020a25cc46000000b00645d969c0b6mr4611805ybf.245.1651339133108; Sat, 30
 Apr 2022 10:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com> <87czh46we9.fsf@cloudflare.com>
In-Reply-To: <87czh46we9.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Apr 2022 10:18:42 -0700
Message-ID: <CAM_iQpWNVasAA0s1tgCSgLF2+Yhr3gMV5C0WM_FsoQBPnoOvbQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
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

On Tue, Apr 26, 2022 at 2:12 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sun, Apr 10, 2022 at 09:10 AM -07, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > a preparation for the next patch which actually introduces
> > a new sock ops.
> >
> > TCP is special here, because it has tcp_read_sock() which is
> > mainly used by splice(). tcp_read_sock() supports partial read
> > and arbitrary offset, neither of them is needed for sockmap.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/tcp.h |  2 ++
> >  net/ipv4/tcp.c    | 72 +++++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 66 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 6d50a662bf89..f0d4ce6855e1 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -667,6 +667,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
> >  /* Read 'sendfile()'-style from a TCP socket */
> >  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >                 sk_read_actor_t recv_actor);
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +              sk_read_actor_t recv_actor);
>
> Do you think it would be worth adding docs for the newly added function?
> Why it exists and how is it different from the tcp_read_sock which has
> the same interface?

Yeah, I will add some comments to explain this in V2.

Thanks.
