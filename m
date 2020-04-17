Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8AA1AE310
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgDQRBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:01:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgDQRBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GDt6Kg65vGRHTbVpxtwsO49QfnwXL2hG69odrZ95CMU=; b=hFTCB2elCtEZeaC6o6m91HbKSs
        e+jNfounAVKh/FRtsRCRy+TsjFMezugcIv1OgyXfebFunp2bndZ8jG4CHHlKqnoaTJBumqO7iwjyn
        hFoD69plmRq81SR0UsS5SnRTFij5AMkSacKykva5C4O/TS1PCPjGqwDbcRh+lgLGUwhc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPUN0-003JwF-8T; Fri, 17 Apr 2020 19:01:38 +0200
Date:   Fri, 17 Apr 2020 19:01:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@siol.net>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mripard@kernel.org,
        linux-kernel@vger.kernel.org, wens@csie.org, lee.jones@linaro.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
Message-ID: <20200417170138.GD785713@lunn.ch>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
 <20200416185758.1388148-3-jernej.skrabec@siol.net>
 <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
 <6176364.4vTCxPXJkl@jernej-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6176364.4vTCxPXJkl@jernej-laptop>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You could use PHY_ID_MATCH_MODEL() here.
> 
> Hm... This doesn't work with dynamically allocated memory, right?

I would suggest we get the right structure first, then figure out
details like this.

Depending on when the device will respond to MDIO, we might be able to
make this a normal PHY driver. It then probes in the normal way, and
all the horrible dependencies you talked about, module loading order,
etc all go away.

There were 3 things you talked about to make the PHY usable:

1) Clock
2) Reset
3) Must be enabled and configured through I2C

We already have the concept of a PHY device having a reset controller
as a property. e.g. Documentation/devicetree/bindings/net/ethernet-phy.yaml

resets = <&rst 8>;

So if the MFD exports a reset controller, we can control that from the
PHY core. If the MFD has not probed yet, the reset core code will
return EPROBE_DEFFER, and the PHY probe will get differed until late.
That solves a lot of probe order issues.

The clock can be handled in two different ways, depending on if the
clock needs to be ticking to read the PHY ID registers. If it does
need to be ticking, we add support for a clks property in just the
same way we have support for the reset property. The PHY core will
clk_enable_prepare() the clock before probing the PHY. If the clock is
not needed for probing, the PHY driver can enable the clock as needed.

The last part, Must be enabled and configured through I2C, we need to
look at the details. It could be the reset controller also enabled the
PHY. If that is enough that the PHY then probes, the PHY driver can
then configure the PHY as needed via i2c.

     Andrew
