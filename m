Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015EC14BF31
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgA1SIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 13:08:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55994 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgA1SIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 13:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=27BCOIqr/wU+I4IrmORaozwu+T70UyCl4JtrDd+CI94=; b=gdIevUZ2qK6OpxHho3MufWbPt
        BAR6uXvIytSdD3mS/dJD8OEbTCxNlo+SuFbDltAklslGG5ORJQI5oY0XhpLsmd41S+k3JOAcWaEBW
        +qrs0ZAor9GYpxnR9GXp6+VIP6VwicXFHpu/bPZZmkew4W+jAgYv9X4UqMX5avJH7sy+8WApdAnFL
        En6RDgB4j2zlk+EkA6R0xyPLLJZqEc3UNI75Vo0tYLiFCVfyoRfE9aQqS05qpyloeFTQTOMXZtiiz
        1Y9ORiDoYgTq8sE0nA1dSdYKIMr/AkfSgmVM+LTMQA4iTk/YzC6rFA2cLC6PqkAthxzzpXk1QGI0b
        5aCCeNOaA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:32880)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iwVHT-0000c0-EH; Tue, 28 Jan 2020 18:08:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iwVHP-0002ak-1h; Tue, 28 Jan 2020 18:08:03 +0000
Date:   Tue, 28 Jan 2020 18:08:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200128180802.GD25745@shell.armlinux.org.uk>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127145107.GE13647@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 03:51:07PM +0100, Andrew Lunn wrote:
> I've also had issues with the DSA links, also being configured to
> 10/Half. That seems to be related to having a phy-mode property in
> device tree. I need to add a fixed-link property to set the correct
> speed. Something is broken here, previously the fixed-link was only
> needed if the speed needed to be lower than the ports maximum. I think
> that is a separate issue i need to dig into, not part of the PCS to
> MAC transfer.

I think I understand what is happening on this one more fully.

When DSA initialises, the DSA and CPU ports are initially configured to
maximum speed via mv88e6xxx_setup_port(), called via mv88e6xxx_setup(),
the .setup method, dsa_switch_setup(), and dsa_tree_setup_switches().

dsa_tree_setup_switches() then moves on to calling dsa_port_setup().
dsa_port_setup() calls dsa_port_link_register_of() for the DSA and CPU
ports, which calls into dsa_port_phylink_register().

That calls phylink_create(), and then attempts to attach a PHY using
phylink_of_phy_connect() - which itself is rather weird - since when
has a DSA or CPU port been allowed to have a PHY in its DT node?

The upshot is, phylink_create() will (and always has) treated a node
without a fixed-link or in-band specification as a "phy" mode link.
Moving on, phylink_start() will be called.

phylink_start() attempts to set an initial configuration.  As there
is no PHY attached, phylink has no idea what parameters to set, but
it needs to set an initial configuration, so it does so.  The result
is, dsa_port_phylink_mac_config() gets called without the speed and
duplex being set as one would expect.

That hasn't changed in phylink yet - so it's a bug that dates back
to the phylink integration into the DSA core, and is a regression
resulting from that.

The reason my patch above appears to solve it is because I'm ignoring
calls to mac_config() with mode == MLO_AN_PHY in various circumstances,
which results in the initial configuration by mv88e6xxx_setup_port()
remaining.

I'm not yet sure what to do about that; and I'm out of time to think
about that anymore today - but I thought I'd post my analysis so far
in the hope that it helps.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
