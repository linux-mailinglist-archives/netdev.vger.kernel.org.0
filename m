Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029F331A7F8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhBLWog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:44:36 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:34535 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhBLWmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 17:42:00 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id CCD5D22802;
        Fri, 12 Feb 2021 23:40:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613169663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEr7rFtIl92i4XGkwR8MY7Q+brTQSUvCVEW26gGEDYU=;
        b=YQZPWoQHQutDr1xgDMibQPpfTciFnC89xMjtXTjJrflBz52lwGfAuJrTtv+A4XhGdbYw3w
        rdkFSgNSS0I7pVnvyWPiTPC0F9YRrmr2r9CtlC7F+QwGMRfoLJ7dMmGx04AoKJcxEyX4n/
        IHhQr1foLW0sQfQUUkzYn39mu3E7aaU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Feb 2021 23:40:59 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
In-Reply-To: <20210212172341.3489046-2-olteanv@gmail.com>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <eb7b911f4fe008e1412058f219623ee2@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-12 18:23, schrieb Vladimir Oltean:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently Linux has no control over whether a MAC-to-PHY interface uses
> in-band signaling or not, even though phylink has the
> 	managed = "in-band-status";
> property which denotes that the MAC expects in-band signaling to be 
> used.
> 
> The problem is really that if the in-band signaling is configurable in
> both the PHY and the MAC, there is a risk that they are out of sync
> unless phylink manages them both. Most if not all in-band autoneg state
> machines follow IEEE 802.3 clause 37, which means that they will not
> change the operating mode of the SERDES lane from control to data mode
> unless in-band AN completed successfully. Therefore traffic will not
> work.
> 
> It is particularly unpleasant that currently, we assume that PHYs which
> have configurable in-band AN come pre-configured from a prior boot 
> stage
> such as U-Boot, because once the bootloader changes, all bets are off.

Fun fact, now it may be the other way around. If the bootloader doesn't
configure it and the PHY isn't reset by the hardware, it won't work in
the bootloader after a reboot ;)

> Let's introduce a new PHY driver method for configuring in-band 
> autoneg,
> and make phylink be its first user. The main PHY library does not call
> phy_config_inband_autoneg, because it does not know what to configure 
> it
> to. Presumably, non-phylink drivers can also call 
> phy_config_inband_autoneg
> individually.

If you disable aneg between MAC and PHY, what would be the actual speed
setting/duplex mode then? I guess it have to match the external speed?

I'm trying this on the AT8031. I've removed 'managed = 
"in-band-status";'
for the PHY. Confirmed that it won't work and then I've implemented your
new callback. That will disable the SGMII aneg (which is done via the
BMCR of fiber page if I'm not entirely mistaken); ethernet will then
work again. But only for gigabit. I presume because the speed setting
of the SGMII link is set to gigabit.

-michael
