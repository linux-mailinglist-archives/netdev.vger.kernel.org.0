Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372243E362B
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 17:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhHGPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 11:41:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhHGPlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 11:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ljG+gOgPhLlIz+lF+PzNSjVAdj+ITrjpHY3qF3K40KI=; b=g46H/LDkYQ6QABx6TRj66BCzfk
        tD2triw69MSMuR0BVTahWTRFR2XuOtxStoGwARv5iEStVYURGkVIuoChIy47fid58dtnu29l9iVvK
        gNzi8D1IHKfGhen1wvFe8Akp3XPyUc4ZLW4O39DtYexQFz0UTu6eUvM/X0fLODy5Izl8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mCOR9-00GVPH-Ra; Sat, 07 Aug 2021 17:40:35 +0200
Date:   Sat, 7 Aug 2021 17:40:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <YQ6pc6EZRLftmRh3@lunn.ch>
References: <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
 <20210802121550.gqgbipqdvp5x76ii@skbuf>
 <YQfvXTEbyYFMLH5u@lunn.ch>
 <20210802135911.inpu6khavvwsfjsp@skbuf>
 <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
 <20210803235401.rctfylazg47cjah5@skbuf>
 <20210804095954.GN22278@shell.armlinux.org.uk>
 <20210804104625.d2qw3gr7algzppz5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804104625.d2qw3gr7algzppz5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am not even clear what is the expected canonical behavior for a MAC
> driver. It parses rx-internal-delay-ps and tx-internal-delay-ps, and
> then what?

So best practices are based around a MAC-PHY link. phy-mode is passed
to the PHY, and the MAC does not act upon it. MAC rx-internal-delay-ps
and tx-internal-delay-ps can be used to fine tune the link. You can
use them to add and sometimes subtract small amounts of delay.

> It treats all "rgmii*" phy-mode strings identically? Or is it an
> error to have "rgmii-rxid" for phy-mode and non-zero
> rx-internal-delay-ps?

I would say the first is correct, the second statement is false. You
should always be able to fine tune the link, independent of the PHY
mode.

We also have to consider the case when the PHY is not actually able to
implement the delay. It hopefully returns -EOPNOTSUPP for anything
other than "rgmii". You can then put the full 2ns delay into
tx-internal-delay-ps nd rx-internal-delay-ps.

And lastly there is one MAC driver which mostly ignores these best
practices because the vendor crap tree always did the delay in the
MAC. It correctly masks the phy-mode, so the PHY does not add delays.

For MAC-MAC and fixed link best practices are very fuzzily defined.
It is not something we have much of in the kernel. We might also want
to narrow the discussion down to MACs within a switch. MACs within in
NIC should probably follow the best practices for a MAC-PHY link, even
if it is actually a switch on the other end.

I also agree with Russell that mv88e6xxx is probably broken for a
MAC-PHY link. It is known to work for a Marvell DSA in MAC-MAC link,
we have boards doing that.

It seems like a switch MAC should parse rx-internal-delay-ps and
tx-internal-delay-ps and apply them independent of the phy-mode. That
keeps it consistent with MAC-PHY. And if there is a PHY connected,
pass the phy-mode on unmasked.

So that we don't break mv88e6xxx, for a CPU or DSA port, we probably
should continue to locally implement the delay, with the assumption
there is no PHY, it is a MAC-MAC link. We probably want to patch
mv88e6xxx to do nothing for user ports.

I suspect it is a 50/50 roll of a dice what rx and tx actually
mean. Is it from the perspective of the MAC or the PHY? Luckily,
rgmii-rxid and rgmii-txid don't appear in DT very often.

   Andrew
