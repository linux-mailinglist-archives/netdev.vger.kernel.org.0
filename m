Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD3329D8EB
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389082AbgJ1Wko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388995AbgJ1Wkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:40:43 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4BCC0613CF;
        Wed, 28 Oct 2020 15:40:43 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id f5so593932qvx.6;
        Wed, 28 Oct 2020 15:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3M0WLekqFr96kxIsrR84Jn4HV4j2bOEv/4KnPx68jTI=;
        b=Pe/WbYbuBtwrSjbNw8B6Ukl82pypSAM5eio4JXK285h6DAe4BrRa9YCS9SV2XMATpX
         cc9J+4qRhVeQLxrGrMXs30AqFBQsbVByDinGzhbMiFYtoWkQ7wenmM7h6CkCGO0EAJCz
         3AOWh4l7+MOpKNEj6jRdruKcyFRaz2xIaqA1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3M0WLekqFr96kxIsrR84Jn4HV4j2bOEv/4KnPx68jTI=;
        b=prGLttdlMsajY8ztR/9Pb7Ry+csgx8mOrO+UvAqz/180fsk40h1C1fIyUz53BEiZI2
         MMl8ggtBXWPcVBbVZ4RtH/BduLtG5AIcVKr68dwIa4DXhLHAhutIdhzAsicA8T5OydUw
         te/UJF3vc6kpT96BccUQdItWRUo30PEl0nVIvbaWjAPcZ2dMHy3LkDXcUZ/JNX2dU6Px
         NYXhWyPe07U0ir2UDo7rBvbuseyPbonc6lCeeJd4f+vEMHk8QkpbnRDVndimxhcghzcH
         bpyG17CJSRm5yKBPBkTkfVraAECCSpHWzTuB0gMQZC1WO3sFK3g9jBZrmDIaUujlPYFF
         xumA==
X-Gm-Message-State: AOAM532WZ22WpIPz8XVN4DTbHSbdITdWESGo6LIAncM2NDrMZG19Alms
        fEP3sszRbHyxLJlppzQLh+nVW5JshjkIIaRTmfwLOrZyps3TsA==
X-Google-Smtp-Source: ABdhPJwlFMIeJj2oXCHQcGqJsgpjXmWeIHjnWFfJPn5WyJNep8A+KKIZQ1xp1vfUleS8kNimlWfUF8SaMv2fagilDos=
X-Received: by 2002:a05:6214:11e4:: with SMTP id e4mr5495989qvu.61.1603860470934;
 Tue, 27 Oct 2020 21:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201020220639.130696-1-joel@jms.id.au> <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
 <428dc31828795ce0b010509c8c30bf0049ad9190.camel@kernel.crashing.org>
In-Reply-To: <428dc31828795ce0b010509c8c30bf0049ad9190.camel@kernel.crashing.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 28 Oct 2020 04:47:38 +0000
Message-ID: <CACPK8XfHaGWcDf7vDHoPhqgWQ4LEwxq9EBtbkBngEpHEzJk2SA@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Arnd Bergmann <arnd@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 at 07:41, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Wed, 2020-10-21 at 14:40 +0200, Arnd Bergmann wrote:
> > On Wed, Oct 21, 2020 at 12:39 PM Joel Stanley <joel@jms.id.au> wrote:
> >
> > >
> > > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > > index 331d4bdd4a67..15cdfeb135b0 100644
> > > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > > @@ -653,6 +653,11 @@ static bool ftgmac100_tx_complete_packet(struct ftgmac100 *priv)
> > >         ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
> > >         txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
> > >
> > > +       /* Ensure the descriptor config is visible before setting the tx
> > > +        * pointer.
> > > +        */
> > > +       smp_wmb();
> > > +
> > >         priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv, pointer);
> > >
> > >         return true;
> > > @@ -806,6 +811,11 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
> > >         dma_wmb();
> > >         first->txdes0 = cpu_to_le32(f_ctl_stat);
> > >
> > > +       /* Ensure the descriptor config is visible before setting the tx
> > > +        * pointer.
> > > +        */
> > > +       smp_wmb();
> > > +
> >
> > Shouldn't these be paired with smp_rmb() on the reader side?
>
> (Not near the code right now) I *think* the reader already has them
> where it matters but I might have overlooked something when I quickly
> checked the other day.

Do we need a read barrier at the start of ftgmac100_tx_complete_packet?

        pointer = priv->tx_clean_pointer;
<--- here
        txdes = &priv->txdes[pointer];

        ctl_stat = le32_to_cpu(txdes->txdes0);
        if (ctl_stat & FTGMAC100_TXDES0_TXDMA_OWN)
                return false;

This was the only spot I could see that might require one.

Cheers,

Joel
