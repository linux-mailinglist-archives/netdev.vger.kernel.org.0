Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE9E467B56
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352984AbhLCQ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:28:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352974AbhLCQ20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 11:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IHweVjf+bzJbyZ9swjjmVxq9Sqs2NyygDLTZcHFlMQE=; b=pG+ihJW5UtrmDjEb9ZL2peXgJf
        E8jj1YYTSPFXd5pg+EyfJ6uWAXaAG9G33wdb5Cq9DycIt5lykDSr1hCZCjjZ62zpKuu2+zkFpQkJY
        hMRx7e7kk46myOsz7UMiuPCIRdX5TjLYB+3hgUeAdNvwcjLRpb/1rm5IedHsyGTZnogc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mtBMq-00FRMB-F5; Fri, 03 Dec 2021 17:25:00 +0100
Date:   Fri, 3 Dec 2021 17:25:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martyn Welch <martyn.welch@collabora.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        kernel@collabora.com, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <YapE3I0K4s1Vzs3w@lunn.ch>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,

Adding Russell to Cc:

> I'm currently in the process of updating the GE B850v3 [1] to run a
> newer kernel than the one it's currently running. 

Which kernel exactly. We like bug reports against net-next, or at
least the last -rc.

> This device (and others in the same family) use a mv88e6240 switch to
> provide a number of their ethernet ports. The CPU link on the switch is
> connected via a PHY, as the network port on the SoM used is exposed via
> a PHY.
> 
> The ports of the B850v3 stopped working when I upgraded, bisecting
> resulted in me finding that this commit was the root cause:
> 
> 3be98b2d5fbc (refs/bisect/bad) net: dsa: Down cpu/dsa ports phylink
> will control
> 
> I think this is causing the PHY on the mv88e6240 side of the CPU link
> to be forced down in our use case.
> 
> I assume an extra check is needed here to stop that in cases like ours,
> though I'm not sure what at this point. Any ideas?

From the commit message.

    DSA and CPU ports can be configured in two ways. By default, the
    driver should configure such ports to there maximum bandwidth. For
    most use cases, this is sufficient. When this default is insufficient,
    a phylink instance can be bound to such ports, and phylink will
    configure the port,

You have a phy-handle in your node:

        port@4 {
                reg = <4>;
                label = "cpu";
                ethernet = <&switch_nic>;
                phy-handle = <&switchphy4>;
        };

so i would expect there to be a phylink instance. The commit message
continues to say:

                                          and phylink will
    configure the port, e.g. based on fixed-link properties.

So i think you are asking the wrong question. It is not an extra check
is needed here, we need to understand why phylink is not configuring
the MAC. Or is that configuration wrong.

I suggest you add #define DEBUG 1 to the very top of
drivers/net/phy/phylink.c so we can see what phylink is doing.

	Andrew

