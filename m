Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE30C174152
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgB1VPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:15:09 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:56849 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgB1VPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:15:08 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 1236B100009;
        Fri, 28 Feb 2020 21:15:05 +0000 (UTC)
Date:   Fri, 28 Feb 2020 22:15:04 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, foss@0leil.net
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200228211504.GI1686232@kwain>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
 <20200228155702.2062570-4-antoine.tenart@bootlin.com>
 <20200228162942.GF29979@lunn.ch>
 <20200228164839.GH1686232@kwain>
 <20200228172616.GG29979@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200228172616.GG29979@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 06:26:16PM +0100, Andrew Lunn wrote:
> > > What is not clearly defined, is how you combine
> > > PHY_INTERFACE_MODE_RGMII* with DT properties. I guess i would enforce
> > > that phydev->interface is PHY_INTERFACE_MODE_RGMII and then the delays
> > > in DT are absolute values.
> > 
> > So, if there's a value in the device tree, and the mode corresponds
> > (RXID for Rx skew), we do use the dt value. That should look like what's
> > in the patch (except for the default value used when no configuration is
> > provided in the dt).
> 
> No. I would not do that. PHY_INTERFACE_MODE_RGMII_RXID means 2ns delay
> for RX. So how do you then interpret the DT property. Is it 2ns + the
> DT delay? That would then mean you need negative values in DT if you
> want short delays than 2ns.
> 
> Which is why i suggest PHY_INTERFACE_MODE_RGMII. It is then clear you
> have a base delay of 0ns, and the DT property then has the absolute
> value of the delay.

OK I see, to avoid confusion we could either define RGMII_ID or RGMII
and fixed delays in the dt if the 2ns one isn't what we need.

We may need an RGMII dedicated documentation then, to avoid future
confusion :)

> > > There is also some discussion about what should go in DT. #defines
> > > like you have, or time in pS, and the driver converts to register
> > > values. I generally push towards pS.
> > 
> > That would allow a more generic dt binding, and could be used by other
> > PHY drivers. The difficulty would be to map the pS to allowed values in
> > the h/w. Should we round them to the upper or lower bound?
> 
> I would document the accepted values in DT, and return -EINVAL if DT
> does not exactly match one of the listed values. Plus a phydev_err()
> message to help debug.

OK.

> > I also saw the micrel-ksz90x1 dt documentation describes many skews, not
> > only one for Rx and one for Tx. How would the generic dt binding would
> > look like then?
> 
> It is a balancing act. Do you actually need dt properties for your
> hardware? Are the standard 2ns delays sufficient. For many designs it
> is. Just because the hardware supports all sorts of configurations,
> are they actually needed? It seems like adding delays are needed for a
> few boards. But do all the properties exposed for the Micrel PHY every
> get used, or is it a case of, the hardware has it, lets make it
> available, even if nobody ever uses it?

Right, this kind of settings shouldn't be needed for lots of boards, so
we can add a per-PHY binding, only when it's needed. The board I'm
currently working on do use smaller delays than 2ns and I was told to
use even lower ones if the connexion wasn't stable. But then do we
really need such a configuration upstream (apart from supporting the 2ns
delays)? That's a good question :)

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
