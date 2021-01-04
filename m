Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D1C2E9722
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbhADOVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:21:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbhADOVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 09:21:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E7921D93;
        Mon,  4 Jan 2021 14:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609770073;
        bh=tgnQRJ6U7DDuRuCcWIJ9ljcKBZPad6QeFd5MTeyUFv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1vQqJz4Cph+uXxCZ6BfMNn9AsBHzpWSHFepcf1aX4SPozzVl+HbcmhehCqBj8pbX
         WpzLcIbVbISKbkVzK0gC5osFLRB8LFQTt9OJ9lP3tTCjvb9Isk76/4VzAv5w1EujH4
         Vj4H6A7YPToy3t3nwq+OqDPqzt8Yn6ZCbR2oqF0YHqZaMcDsnMy18gHaOlTUmwJsbK
         2+r0YjKFfXJm6W3LVDJcl5L0xNYrgZteumuGYw0ZV6eyQmYYuUXRoT/t7/zUJpesOT
         MRCQgXwOFu9VeUNp6nrNw94NwUuxJKUEUsA+sbMIVrZQRRJ++zt2leQa+KX6aZyfi+
         dYUADGE6WsWyg==
Date:   Mon, 4 Jan 2021 16:20:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v11 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20210104142057.GL31158@unreal>
References: <20210104082218.1389450-1-steen.hegelund@microchip.com>
 <20210104082218.1389450-4-steen.hegelund@microchip.com>
 <20210104121502.GK31158@unreal>
 <5e5332e026af5d3716cf9bb0aa404783b53f9e02.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e5332e026af5d3716cf9bb0aa404783b53f9e02.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 02:16:38PM +0100, Steen Hegelund wrote:
> Hi Leon,
>
>
> On Mon, 2021-01-04 at 14:15 +0200, Leon Romanovsky wrote:
> >
> > <...>
> >
> > > +struct sparx5_sd10g28_args {
> > > +     bool                 skip_cmu_cfg; /* Enable/disable CMU cfg
> > > */
> > > +     bool                 no_pwrcycle;  /* Omit initial power-
> > > cycle */
> > > +     bool                 txinvert;     /* Enable inversion of
> > > output data */
> > > +     bool                 rxinvert;     /* Enable inversion of
> > > input data */
> > > +     bool                 txmargin;     /* Set output level to 
> > > half/full */
> > > +     u16                  txswing;      /* Set output level */
> > > +     bool                 mute;         /* Mute Output Buffer */
> > > +     bool                 is_6g;
> > > +     bool                 reg_rst;
> > > +};
> >
> > All those bools in structs can be squeezed into one u8, just use
> > bitfields, e.g. "u8 a:1;".
>
> Got you.
>
> >
> > Also I strongly advise do not do vertical alignment, it will cause to
> > too many churn later when this code will be updated.
>
> So just a single space between the type and the name and the comment is
> preferable?

Yes, use clang formatter over your code, it will change everything to be
aligned to kernel coding style.
https://linuxplumbersconf.org/event/7/contributions/803/

>
> >
> > > +
> >
> > <...>
> >
> > > +static inline void __iomem *sdx5_addr(void __iomem *base[],
> > > +                                   int id, int tinst, int tcnt,
> > > +                                   int gbase, int ginst,
> > > +                                   int gcnt, int gwidth,
> > > +                                   int raddr, int rinst,
> > > +                                   int rcnt, int rwidth)
> > > +{
> > > +#if defined(CONFIG_DEBUG_KERNEL)
> > > +     WARN_ON((tinst) >= tcnt);
> > > +     WARN_ON((ginst) >= gcnt);
> > > +     WARN_ON((rinst) >= rcnt);
> > > +#endif
> >
> > Please don't put "#if defined(CONFIG_DEBUG_KERNEL)", print WARN_ON().
>
> OK, I will drop the #if and keep the WARN_ON...

Thanks
