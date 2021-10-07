Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7D6425AB0
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243655AbhJGS1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:27:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243553AbhJGS1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hnexheY+ykPO7EobnebT7tAMqi9ur1xwEWFIksKe5a8=; b=CaIzEbSvc3dLyhep5C9Z/3WKu1
        D18LjNJ2KU0u/oaME10z6qgQpv1VSB4zxD3RjzliCQQX+ogAQVW5aCzC6Mib13MAiSiiTlT788f8I
        nbTtgsx266R1bWm4GTA0KE33JkL1MmRbW86NLBmTpgsIwFirlkKu9VxHVTfOj3UEwa4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYY54-009ys9-DE; Thu, 07 Oct 2021 20:25:22 +0200
Date:   Thu, 7 Oct 2021 20:25:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 12/13] drivers: net: dsa: qca8k: add support for
 pws config reg
Message-ID: <YV87kuT2lJ6kV4mb@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-13-ansuelsmth@gmail.com>
 <YV5CJvb2k1/61IU2@lunn.ch>
 <YV759SSdKu0w83UB@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV759SSdKu0w83UB@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Anyway the difference is that they made 2 different package version of
> the qca8327. One with 176 pin and one with 148 pin.

I assume they have different product numbers. So you can quote them in
the DT binding? Are they BGP or QFP? Can somebody easily count the
pins?

> > > +
> > > +	if (of_property_read_bool(node, "qca,power-on-sel"))
> > > +		val |= QCA8K_PWS_POWER_ON_SEL;
> > 
> > What happens if you unconditionally do this? Why is a DT property
> > required?
> > 
> 
> This is needed to bypass the power on strapping and use the regs config.
> The switch can use hardware pin to set eeprom presence and leds open
> drain. Setting this bit on bypass the hardware strapping and sets these
> 2 thing based on the regs.

So first off, it sounds like you have the DT property named wrong. It
should be 'qca,ignore-power-on-sel'.

However, why do you even need this? Generally, strapping gives you the
defaults. Registers get loaded with a value determined by the
strapping. But after that, you can change the value, based on
additional information. Or are you saying the register is read only
when strapping is used?

> > > +	if (of_property_read_bool(node, "qca,led-open-drain"))
> > > +		/* POWER_ON_SEL needs to be set when configuring led to open drain */
> > > +		val |= QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL;

At minimum, you need to clearly document that qca,led-open-drain
implies 'qca,ignore-power-on-sel'. I would probably go further and
return -EINVAL if qca,led-open-drain is set and
'qca,ignore-power-on-sel' is not.

	Andrew
