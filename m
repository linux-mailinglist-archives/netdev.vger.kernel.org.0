Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5103F466B66
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356945AbhLBVKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhLBVKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:10:31 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4CC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 13:07:08 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r25so3088536edq.7
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 13:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M1R/ikzMyGfO3PAEq/5iOfsrHH1xbNlGGQr4YAkm4vg=;
        b=Eqn/gcOy2a5BO3y0BwKddQbliABExIIH7nm/2jI4KmWBSFskYMT7CE6kf0Ui7eDMRK
         CD2WFgS5d94jH/xFD6y3fn6jke5H4pvUECID9Y65CcV9gAX8i3gX/2F8WCMDH522ezNt
         OYNPRth+HmDLJASO9vcy14lWwAq2iewl1apt2tiCZwgtIvn1YjBS34gPvwv1ebla/d/Z
         duxKVa7+hvaCXBU0EnNGVQuHRrbLBmqTE4pfdphn57SQLVVTWdN4s2bcX/GqnQioh+IS
         4T2yvsAFYpOtRvMTfPm1Slsr7ct0SMkKPx0sr846CPKYAW8CLQX9GWa7h0keRE18lnDD
         r8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M1R/ikzMyGfO3PAEq/5iOfsrHH1xbNlGGQr4YAkm4vg=;
        b=2Cei0eDMiMG7mibZiZX/bsM2yx7nRKSPT3rIvZ1c5mkttHGny4LF2t619FVocz3fse
         1ypFNxymYVUxfOag7WRzLT8ZKAr1VgC2HgAaM1i70cc2PkGG+hepmiqydoNr0piMb3sO
         U78tIfJ3PhBs8FYHKzaGbl4tXQj+1xNwU97lJkOj4HkbXxSR3YEekqEDNuvdP2ItIIe8
         SopSFX9jy2OL4q6MummMRdXOMD19guC2Ghp4sPEgHBbkU/L8wvq9YcnT5jeVifI43kNK
         6hsEfsiHffxM5aXg/yCMS1e7sFWh+PG/xw4QJBU5XXgZkqRCaoNIMZVaSzvMXcrNlCxP
         VK7Q==
X-Gm-Message-State: AOAM5301kCL/ESObIqqJ0WtEUJYi+J4lA9sf5CMIiPL+wYmvuEOxA/x7
        T0zXwoKLuJxiREy7P7V7xO8=
X-Google-Smtp-Source: ABdhPJy6GSdreeHoFKPHdtC7JmH4cRhphP3Bcz0MzefRi7oXkYpJJ5EkRqaJjzTictINW//sUGDnIA==
X-Received: by 2002:a50:f09b:: with SMTP id v27mr20882459edl.53.1638479226831;
        Thu, 02 Dec 2021 13:07:06 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id ar4sm524493ejc.52.2021.12.02.13.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 13:07:06 -0800 (PST)
Date:   Thu, 2 Dec 2021 23:07:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Message-ID: <20211202210705.vsqr67svt3sm53h3@skbuf>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <CANn89iJOH0QtRhDfBzJr3fpJPNCQJhbMqT_8sa+vH_6mmZ7xhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJOH0QtRhDfBzJr3fpJPNCQJhbMqT_8sa+vH_6mmZ7xhw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 12:37:35PM -0800, Eric Dumazet wrote:
> On Thu, Dec 2, 2021 at 11:32 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Thanks Vladimir
> >
> > I think that maybe the issue is that the initial skb->csum is zero,
> > and the csum_parttial(removed_block) is also zero.
> >
> > But the initial skb->csum should not be zero if you have a non " all
> > zero"  frame.
> >
> > Can you double check this in drivers/net/ethernet/freescale/enetc/enetc.c ?
> 
> Yes, I am not sure why the csum is inverted in enetc_get_offloads()

I guess it's inverted because the hardware doesn't provide its one's
complement.

> Perhaps
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c
> b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 504e12554079e306e477b9619f272d6e96527377..72524f14cae0093763f8a3f57b1e08e31bc4df1a
> 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -986,7 +986,7 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
>         if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
>                 u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
> 
> -               skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
> +               skb->csum = csum_unfold((__force __sum16)htons(inet_csum));
>                 skb->ip_summed = CHECKSUM_COMPLETE;
>         }
> 
> If this does not work, then maybe :
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c
> b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 504e12554079e306e477b9619f272d6e96527377..d190faa9a8242f9f3f962dd30b9f4409a83ee697
> 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -987,7 +987,8 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
>                 u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
> 
>                 skb->csum = csum_unfold((__force __sum16)~htons(inet_csum));
> -               skb->ip_summed = CHECKSUM_COMPLETE;
> +               if (likely(skb->csum))
> +                       skb->ip_summed = CHECKSUM_COMPLETE;
>         }
> 
>         if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN) {

I guess you aren't interested any longer in the result of these changes,
since the csum isn't zero in enetc?
