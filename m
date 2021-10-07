Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A70425A55
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243466AbhJGSHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:07:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhJGSHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uqZhubrZS0AC3XCDxYOs5HijLXlbSUCH28Z8t+sc3d0=; b=loExcZsc/YaIjMqkO/RpnyxTf2
        Ouop7cKYoMODlVT0BhuhEZ+4sSV5CkVylC0KAeGrR588aM4gpRU9JptqndcNyZ2AYq9YfDm4L/UPp
        9V8jrzl41TZXWP+Ni96CKAaVtaM3N/LiWppIg+ixvxz6+V67MiXvYZuYqBly1251YJSY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYXmG-009ykS-Dh; Thu, 07 Oct 2021 20:05:56 +0200
Date:   Thu, 7 Oct 2021 20:05:56 +0200
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
Subject: Re: [net-next PATCH 10/13] net: dsa: qca8k: add explicit SGMII PLL
 enable
Message-ID: <YV83BAmhHfmDyCjv@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-11-ansuelsmth@gmail.com>
 <YV4/ehy9aYJyozvy@lunn.ch>
 <YV73umYovC0wh5hz@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV73umYovC0wh5hz@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, Oct 07, 2021 at 03:35:54PM +0200, Ansuel Smith wrote:
> On Thu, Oct 07, 2021 at 02:29:46AM +0200, Andrew Lunn wrote:
> > On Thu, Oct 07, 2021 at 12:36:00AM +0200, Ansuel Smith wrote:
> > > Support enabling PLL on the SGMII CPU port. Some device require this
> > > special configuration or no traffic is transmitted and the switch
> > > doesn't work at all. A dedicated binding is added to the CPU node
> > > port to apply the correct reg on mac config.
> > 
> > Why not just enable this all the time when the CPU port is in SGMII
> > mode?
> 
> I don't know if you missed the cover letter with the reason. Sgmii PLL
> is a mess. Some device needs it and some doesn't. With a wrong
> configuration the result is not traffic. As it's all messy we decided to
> set the PLL to be enabled with a dedicated binding and set it disabled
> by default. We enouncer more device that require it disabled than device
> that needs it enabled. (in the order of 70 that doesn't needed it and 2
> that requires it enabled or port instability/no traffic/leds problem)

What exactly does this PLL do? Clock recovery of the SGMII clock, and
then using it in the opposite direction? What combinations of PHYs
need it, and which don't?

> > Is it also needed for 1000BaseX?
> > 
> 
> We assume it really depends on the device.

That i find surprising. 1000BaseX and SGMII are very similar. I would
expect a device with requires the PLL enabled for SGMII also needs it
for 1000BaseX.

> > DT properties like this are hard to use. It would be better if the
> > switch can decide for itself if it needs the PLL enabled.
> 
> Again reason in the cover letter sgmii part. Some qca driver have some
> logic based on switch revision. We tried that and it didn't work since
> some device had no traffic with pll enabled (and with the revision set
> to enable pll)

This is my main problem with this patchset. You are adding lots of
poorly documented properties which are proprietary to this switch. And
you are saying, please try all 2^N combinations and see what works
best. That is not very friendly at all.

So it would be good to explain each one in detail. Maybe given the
explanation, we can figure out a way to detect at runtime, and not
need the option. If not, you can add it to the DT binding to help
somebody pick a likely starting point for the 2^N search.

	 Andrew
