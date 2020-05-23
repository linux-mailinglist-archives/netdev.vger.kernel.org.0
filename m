Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F026A1DF7EB
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbgEWPJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 11:09:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbgEWPJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 11:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zh94Nr629GpL+7Cc8d7CAB3Ge/T9cKmSDlUiPtXtVyY=; b=4BL/0GtpgOfn+IAhEzql2eSDX+
        DVGeFgoayWi+x9vGrlTnqRnwFrmtwKz53Gt8urbo5mYyuxNycvaCn9nuUaS4KiX4fHvRLRbKizsFn
        4l7fJg2XKm+xNdc8sKmggRz9TrW7s61he3Dmm+xL6Np776nJLXJyNQHN6YGBM7AYArL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcVmZ-0034So-JE; Sat, 23 May 2020 17:09:51 +0200
Date:   Sat, 23 May 2020 17:09:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dp83869: Add RGMII internal delay
 configuration
Message-ID: <20200523150951.GK610998@lunn.ch>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-5-dmurphy@ti.com>
 <a1ec8ef0-1536-267b-e8f7-9902ed06c883@gmail.com>
 <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <948bfa24-97ad-ba35-f06c-25846432e506@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	dp83869->tx_id_delay = DP83869_RGMII_CLK_DELAY_INV;
> > > +	ret = of_property_read_u32(of_node, "tx-internal-delay-ps",
> > > +				   &dp83869->tx_id_delay);
> > > +	if (!ret && dp83869->tx_id_delay > dp83869_internal_delay[delay_size]) {
> > > +		phydev_err(phydev,
> > > +			   "tx-internal-delay value of %u out of range\n",
> > > +			   dp83869->tx_id_delay);
> > > +		return -EINVAL;
> > > +	}
> > This is the kind of validation that I would be expecting from the PHY
> > library to do, in fact, since you use Device Tree standard property, I
> > would expect you only need to pass the maximum delay value and some
> > storage for your array of delays.
> 
> Actually the PHY library will return either the 0th index if the value is to
> small or the max index if the value is to large
> 
> based on the array passed in so maybe this check is unnecessary.

Hi Dan

I'm not sure the helper is implementing the best behaviour. Rounded to
the nearest when within the supported range is O.K. But if the request
is outside the range, i would report an error.

Any why is your PHY special, in that is does care about out of range
delays, when others using new the new core helper don't?

	Andrew
