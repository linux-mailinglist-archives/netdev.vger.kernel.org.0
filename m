Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550E214BF9F
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 19:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgA1SZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 13:25:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgA1SZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 13:25:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9rzg8pOQc/eaFdW99Vz4O3jHl+7pHiM7u4M/N2zjXkU=; b=VebU66qEXJs9WAZC/uirqsZ7mX
        OeOrKJJw/KVKUhkMEVs/QGETVhl2qzSFUd3E/lV7hdBCotWajXxt6dvKTE9vVde4qW/MMN5mMOp3S
        ZA1c5MLXkU2rC0fe7ztoIqt4Ohv3tPUiuPC8w1qtDw5vdx11umzbQlCyqmRrmTHhgoUk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iwVYU-0003W8-Ff; Tue, 28 Jan 2020 19:25:42 +0100
Date:   Tue, 28 Jan 2020 19:25:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
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
Message-ID: <20200128182542.GB12180@lunn.ch>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200128180802.GD25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128180802.GD25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 06:08:03PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Jan 27, 2020 at 03:51:07PM +0100, Andrew Lunn wrote:
> > I've also had issues with the DSA links, also being configured to
> > 10/Half. That seems to be related to having a phy-mode property in
> > device tree. I need to add a fixed-link property to set the correct
> > speed. Something is broken here, previously the fixed-link was only
> > needed if the speed needed to be lower than the ports maximum. I think
> > that is a separate issue i need to dig into, not part of the PCS to
> > MAC transfer.
> 
> I think I understand what is happening on this one more fully.
> 
> When DSA initialises, the DSA and CPU ports are initially configured to
> maximum speed via mv88e6xxx_setup_port(), called via mv88e6xxx_setup(),
> the .setup method, dsa_switch_setup(), and dsa_tree_setup_switches().
> 
> dsa_tree_setup_switches() then moves on to calling dsa_port_setup().
> dsa_port_setup() calls dsa_port_link_register_of() for the DSA and CPU
> ports, which calls into dsa_port_phylink_register().
> 
> That calls phylink_create(), and then attempts to attach a PHY using
> phylink_of_phy_connect() - which itself is rather weird - since when
> has a DSA or CPU port been allowed to have a PHY in its DT node?

Hi Russell

There are some boards which have back to back PHYs between the SoC and
the Switch. Most designs rely on strapping the PHYs to just work, no
software configuration needed. But then came along a board with a PHY
which needed a kick to make it work :-(

> That hasn't changed in phylink yet - so it's a bug that dates back
> to the phylink integration into the DSA core, and is a regression
> resulting from that.

And i think i probably did not notice it because nearly all the boards
i test with connect to the FEC, which is Fast Ethernet only, so needs
fixed-link properties.

	   Andrew
