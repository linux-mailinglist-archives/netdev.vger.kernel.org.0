Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6B4427D2C
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhJITuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 15:50:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhJITuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 15:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MRKPTxTn90KaIhHuJXp8eJykj9sWkwQdUNCBRD6NPLI=; b=CsgfUCHLE86f11Pt1P9qW1ca1b
        6qpzTDkCZI1eVn82VOQ2c5O3pm1N1aEnLR+BF+VxK1J6ylb5z0a3TCivrXMJk4RFpTB/5EzFzFGuE
        eTiOnJQWJ2WxHRVmvWWQWbomWoZ0QB/CdyiWwI3M2AzExExQ76WBGJUmawNWDZeMcvwQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZIK5-00AAut-SR; Sat, 09 Oct 2021 21:47:57 +0200
Date:   Sat, 9 Oct 2021 21:47:57 +0200
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWHx7Q9jBrws8ioN@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
 <YWHMRMTSa8xP4SKK@lunn.ch>
 <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Problem here is that from Documentation falling edge can be set only on
> PAD0. PAD5 and PAD6 have the related bit reserved.

Meaning in future, they could be used for this, if those ports get
support for SGMII.

> But anyway qca8k support only single sgmii and it's not supported a
> config with multiple sgmii.

Yet, until such hardware appears. We do see more support for SFPs. And
more support for multi-gigi ports. Both of which use a SERDES
interface which can support SGMII. So i would not be too surprised if
future versions of the switch have more ports like this.

> Do we have standard binding for this?

No, there is no standard binding for this. This seems specific to
these devices, maybe a proprietary extension to SGMII?

> About the mac swap. Do we really need to implement a complex thing for
> something that is really implemented internally to the switch?

If it was truly internal to the switch, no. But i don't think it
is. The DSA core has no idea the ports are swapped, and so i think
will put the names on the wrong ports. Does devlink understand the
ports are swapped? How about .ndo_get_phys_port_name? Will udev mix up
the ports?

The way you wanted to look in the other ports DT properties suggests
it is not internal to the switch.

I think to help my understanding, we need some examples of DTS files
with and without the swap, where the properties are read from, what
the interface names are, etc.

> I will move the falling binding to the port DT node and move the
> configuration to mac_config. Should I keep the
> dedicated function to setup PAD0 swap or I can directly add the check in
> the qca8k_setup for only the bit related to enable the swap?

That does not matter too much. DT is an ABI, we should not change it
later, so we need to look forward. C code is not ABI, it can be
changed if/when more SGMII ports actually arrive.

	Andrew
