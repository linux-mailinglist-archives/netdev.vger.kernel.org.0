Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283534389DA
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJXPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 11:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhJXPjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 11:39:39 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E443C061745;
        Sun, 24 Oct 2021 08:37:18 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t1so5682652qvb.1;
        Sun, 24 Oct 2021 08:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8ci/xhYPZR9e9UWmXQi7hAkc36PIq0f8k5stqRYk7mo=;
        b=RjQvHCu6f7eSjRB8qg3psq+nfMVQG+ZruM8AVXCA0/rpVpO4InHat1m+YQCmTINfBz
         Ol440Kw1avJdVjbwIEwMNTOkIOuPpD7tLmxZJYrDYDCckCWXEqPa6eG5L7gly1NdJGSh
         lV09I3pU8hkWQgWY9kQoNThAZQuxGPJWNRPFccc1+zHzcvITW9wHejg1TiXIKswDKqJv
         e8cymnnYPtOUT3NHrFUQx8OOl78aMcD/qmsBqgs0UHoJUq9uVsm9h4iJXQoskzoytcXQ
         AUtzXIRqWMT2MPHd+S6sf9Q1iDsIfxt4uB/NbKHX+zZv3MYttyyMH0Oa4lIiXWQmS+Rj
         m6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8ci/xhYPZR9e9UWmXQi7hAkc36PIq0f8k5stqRYk7mo=;
        b=FBgSCxgO8FtrZlhi6AJTlSaFwXYtA0w/D4xJ81GFQv7FxlNRruSeC5aJ18iOxoQ7jw
         hHM6PdCWYMM7thlQTwj3ex+mCsW4ISDqfXhcgxs3SotGrG8A2TqhdxusuDFDwFI4Wd7R
         SOz5a2xOmpKG8cuT879u+XaXLM3tgyZc/TVJ501BLryGToq+wgdjyAyAccPgrNpHbkTc
         oZbt42YranzvCs/KtkwGSnnj5Kft9zPoR9OZBjKtsc/LN1nCt5ZbKzMSOLq3Rqlnu3ER
         Jy33eZ/QSb9OOF2gq1PFC86M1G8UoqycV16GOqnD/hoNU7r4gakCNbiZgJcEofufofjK
         WqJA==
X-Gm-Message-State: AOAM532nGE91/O0uSzkIEIeOYKqy6fyvn+Zr/Pg4105Z0B7Qk/3LZnt7
        iJYs4GgALIlu0HQEAHIw60YkGjSnnx6jzIyIFbk=
X-Google-Smtp-Source: ABdhPJwHB5yRdux1BH63kxaSupU5LEEL4Cl1/mb3pSuvSXDXnou8rFq9dBthQ+5MRArNkn8tlbWXfPoEl6v3gGb5RFo=
X-Received: by 2002:ad4:5403:: with SMTP id f3mr11208276qvt.31.1635089837684;
 Sun, 24 Oct 2021 08:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <fb712f802228ab4319891983164bf45e90d529e7.1635076200.git.christophe.jaillet@wanadoo.fr>
 <CA+FuTSftgpOGxAxRE5u9o6gT_exaLtC2JkBz=iq21qe+tTTomA@mail.gmail.com> <f14bbf8a-2070-650f-3f26-bd45aad48b88@wanadoo.fr>
In-Reply-To: <f14bbf8a-2070-650f-3f26-bd45aad48b88@wanadoo.fr>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 24 Oct 2021 11:36:41 -0400
Message-ID: <CAF=yD-K+ZwjCZ3j3vELjYT5spE3RB2KBxg-Q2YK0f++PXjnEsw@mail.gmail.com>
Subject: Re: [PATCH] gve: Fix a possible invalid memory access
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jeroendb@google.com, Catherine Sullivan <csully@google.com>,
        awogbemila@google.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bailey Forrest <bcf@google.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fraker <jfraker@google.com>, yangchun@google.com,
        xliutaox@google.com, Sagi Shahar <sagis@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 10:58 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 24/10/2021 =C3=A0 15:51, Willem de Bruijn a =C3=A9crit :
> > On Sun, Oct 24, 2021 at 7:52 AM Christophe JAILLET
> > <christophe.jaillet@wanadoo.fr> wrote:
> >>
> >> It is spurious to allocate a bitmap for 'num_qpls' bits and record the
> >> size of this bitmap with another value.
> >>
> >> 'qpl_map_size' is used in 'drivers/net/ethernet/google/gve/gve.h' with
> >> 'find_[first|next]_zero_bit()'.
> >> So, it looks that memory after the allocated 'qpl_id_map' could be
> >> scanned.
> >
> > find_first_zero_bit takes a length argument in bits:
> >
> >      /**
> >       * find_first_zero_bit - find the first cleared bit in a memory re=
gion
> >       * @addr: The address to start the search at
> >       * @size: The maximum number of bits to search
> >
> > qpl_map_size is passed to find_first_zero_bit.
> >
> > It does seem roundabout to compute first the number of longs needed to
> > hold num_qpl bits
> >
> >      BITS_TO_LONGS(num_qpls)
> >
> > then again compute the number of bits in this buffer
> >
> >      * sizeof(unsigned long) * BITS_PER_BYTE
> >
> > Which will simply be num_qpls again.
> >
> > But, removing BITS_PER_BYTE does not arrive at the right number.
>
> (* embarrassed *)
>
> So obvious.
> Thank you for taking time for the explanation on a so badly broken patch.
>
> I apologize for the noise and the waste of time :(

No worries, it happens. Thanks for reviewing code.

>
> BTW, why not just have 'priv->qpl_cfg.qpl_map_size =3D num_qpls;'?

Yes, that seems more straightforward to me too.
