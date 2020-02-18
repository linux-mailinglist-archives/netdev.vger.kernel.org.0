Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7001629E4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgBRPyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:54:17 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48043 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgBRPyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 10:54:17 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6cb48bc0
        for <netdev@vger.kernel.org>;
        Tue, 18 Feb 2020 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=MN5KnVYqUFmR9/YourV1KMbg0Zc=; b=dbC2Iv
        mn07/QzLTwHL9tb8969CRM+beHNVMW2TiMhbORswQZYTuetU+EnELNkAvvTRHRqy
        jt34ZJwnDzJooKCB0YbaiBR+mmHw1xQOIySDjo0mWDjdTNDofLUn+Kg3cuCGG1+u
        hL5sMl+BqSUaQ1MSkO7rIemntKxkLVWnviemPvR3kI3zcKsOUzPD6gXouIJpwe4R
        PAj6JIN2PeX1iZ8L6H5m4krKmsHu/FkJCEWsCj31cy5jgpgIljz0ptNX45PfA5aM
        UcfnTurJtVqS/LII8V7y/IYH4DSe/t9emACIMrUw6qt9wpUf2YjtuUJfKPjimI2/
        ZMsJk1Vd9Xmn56oA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ea966107 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 18 Feb 2020 15:51:36 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id j132so20548416oih.9
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 07:54:14 -0800 (PST)
X-Gm-Message-State: APjAAAWm0aTHpPTQuZU3a6GSYKq5/6EZiqHkeYxyZMilxd3i15Y9E1lb
        cuMlRfmwtrWiDZGCCvp2Erj2h55WvAe7UndxNcM=
X-Google-Smtp-Source: APXvYqydDoIRdDotIhjfukZ/mljlE33HHiYzymdRwFDX8oElXs3tVlRafiQFmz3Hjiw/43eaPvRNRNGF9ZxG17d5RoU=
X-Received: by 2002:a05:6808:4d3:: with SMTP id a19mr9093oie.119.1582041254391;
 Tue, 18 Feb 2020 07:54:14 -0800 (PST)
MIME-Version: 1.0
References: <20200108215909.421487-1-Jason@zx2c4.com> <20200108215909.421487-7-Jason@zx2c4.com>
 <e1e06281-16e9-edb8-dcda-7bdcf60507a7@solarflare.com>
In-Reply-To: <e1e06281-16e9-edb8-dcda-7bdcf60507a7@solarflare.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Feb 2020 16:54:03 +0100
X-Gmail-Original-Message-ID: <CAHmME9r=eiMizN_E0noTCEaR=9PXVpq76=4x+v-xT6Nf9MsFAw@mail.gmail.com>
Message-ID: <CAHmME9r=eiMizN_E0noTCEaR=9PXVpq76=4x+v-xT6Nf9MsFAw@mail.gmail.com>
Subject: Re: [PATCH 6/8] net: sfc: use skb_list_walk_safe helper for gso segments
To:     Edward Cree <ecree@solarflare.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 4:35 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 08/01/2020 21:59, Jason A. Donenfeld wrote:
> > This is a straight-forward conversion case for the new function, and
> > while we're at it, we can remove a null write to skb->next by replacing
> > it with skb_mark_not_on_list.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  drivers/net/ethernet/sfc/tx.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> > index 00c1c4402451..547692b33b4d 100644
> > --- a/drivers/net/ethernet/sfc/tx.c
> > +++ b/drivers/net/ethernet/sfc/tx.c
> > @@ -473,12 +473,9 @@ static int efx_tx_tso_fallback(struct efx_tx_queue *tx_queue,
> >       dev_consume_skb_any(skb);
> >       skb = segments;
> >
> > -     while (skb) {
> > -             next = skb->next;
> > -             skb->next = NULL;
> > -
> > +     skb_list_walk_safe(skb, skb, next) {
> Could this be replaced with
>     skb_list_walk_safe(segments, skb, next) {
> and elide the assignment just above?
> Or is there some reason I'm missing not to do that?

Yes that's probably correct.
