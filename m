Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E8173E75
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1R0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:26:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1R0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 12:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dPwpiIlKKcaHNDUd0CNUUN+MvX4RTwnCjX7uFREeo4w=; b=fnmrjyYTrZVwCVWcpYIPwBdrxL
        PsJ+nybeehvJ/rQzFGIDbuggw7BZ49VvdOirQxUtrFFmBSkrxdV6nQZ03YOV1fb9B+7ss+on6hqTO
        YABnRZ1QCittLZ2TJt0vpWm2Hi2nXbfVlO1nSBdRjz+Uliin7UPon35uZk69NNLEjCjM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7jOy-0005Pm-2L; Fri, 28 Feb 2020 18:26:16 +0100
Date:   Fri, 28 Feb 2020 18:26:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: RGMII skew delay
 configuration
Message-ID: <20200228172616.GG29979@lunn.ch>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
 <20200228155702.2062570-4-antoine.tenart@bootlin.com>
 <20200228162942.GF29979@lunn.ch>
 <20200228164839.GH1686232@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228164839.GH1686232@kwain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I did not know that, thanks for the explanation! So if ID/TXID/RXID is
> used, I should configure the Rx and/or Tx skew with
> VSC8584_RGMII_SKEW_2_0, except if the dt says otherwise.

Yes.

> > What is not clearly defined, is how you combine
> > PHY_INTERFACE_MODE_RGMII* with DT properties. I guess i would enforce
> > that phydev->interface is PHY_INTERFACE_MODE_RGMII and then the delays
> > in DT are absolute values.
> 
> So, if there's a value in the device tree, and the mode corresponds
> (RXID for Rx skew), we do use the dt value. That should look like what's
> in the patch (except for the default value used when no configuration is
> provided in the dt).

No. I would not do that. PHY_INTERFACE_MODE_RGMII_RXID means 2ns delay
for RX. So how do you then interpret the DT property. Is it 2ns + the
DT delay? That would then mean you need negative values in DT if you
want short delays than 2ns.

Which is why i suggest PHY_INTERFACE_MODE_RGMII. It is then clear you
have a base delay of 0ns, and the DT property then has the absolute
value of the delay.

> > There is also some discussion about what should go in DT. #defines
> > like you have, or time in pS, and the driver converts to register
> > values. I generally push towards pS.
> 
> That would allow a more generic dt binding, and could be used by other
> PHY drivers. The difficulty would be to map the pS to allowed values in
> the h/w. Should we round them to the upper or lower bound?

I would document the accepted values in DT, and return -EINVAL if DT
does not exactly match one of the listed values. Plus a phydev_err()
message to help debug.

> I also saw the micrel-ksz90x1 dt documentation describes many skews, not
> only one for Rx and one for Tx. How would the generic dt binding would
> look like then?

It is a balancing act. Do you actually need dt properties for your
hardware? Are the standard 2ns delays sufficient. For many designs it
is. Just because the hardware supports all sorts of configurations,
are they actually needed? It seems like adding delays are needed for a
few boards. But do all the properties exposed for the Micrel PHY every
get used, or is it a case of, the hardware has it, lets make it
available, even if nobody ever uses it?

So i think a standardized DT for delays is good, but i would not go
any further.

    Andrew
