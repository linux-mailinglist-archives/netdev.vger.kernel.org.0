Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800111E6754
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405011AbgE1QVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404972AbgE1QVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 12:21:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9ED8207D3;
        Thu, 28 May 2020 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590682898;
        bh=aJC9vnyh2osZWUmJkgq/qDYXmG7CBcn92mTmlBNgrsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jEBNy7PISIzrKTIuuGjf54NX9DHJCcRjb93ej3YytsO7yic4wLFTJPtuFrGGZiSUo
         asf+ijh2Jc2a2niM0roSIUeywcg27k24MeCS3+8DAWx+LdtJkBj+sCyj9+ApPH3ew1
         N4d1ertx8J4J+29U5JbxhJYBaxkUXQeT/aDacmIY=
Date:   Thu, 28 May 2020 09:21:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        allan.nielsen@microchip.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
Message-ID: <20200528092135.62e4b06f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527234113.2491988-12-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
        <20200527234113.2491988-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 02:41:13 +0300 Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
> 
> This is a 10-port (8 external, 2 internal) switch from
> Vitesse/Microsemi/Microchip that is integrated into the Freescale/NXP
> T1040 PowerPC SoC. The situation is very similar to Felix from NXP
> LS1028A, except that this is a platform device and Felix is a PCI
> device.
> 
> Extending the Felix driver to probe a PCI as well as a platform device
> would have introduced unnecessary complexity. The 'meat' of both drivers
> is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> bits in seville_vsc9953.c.
> 
> Like Felix, this driver configures its own PCS on the internal MDIO bus
> using a phy_device abstraction for it (yes, it will be refactored to use
> a raw mdio_device, like other phylink drivers do, but let's keep it like
> that for now). But unlike Felix, the MDIO bus and the PCS are not from
> the same vendor. The PCS is the same QorIQ/Layerscape PCS as found in
> Felix/ENETC/DPAA*, but the internal MDIO bus that is used to access it
> is actually an instantiation of drivers/net/phy/mdio-mscc-miim.c. But it
> would be difficult to reuse that driver (it doesn't even use regmap, and
> it's less than 200 lines of code), so we hand-roll here some internal
> MDIO bus accessors within seville_vsc9953.c, which serves the purpose of
> driving the PCS absolutely fine.
> 
> Also, same as Felix, the PCS doesn't support dynamic reconfiguration of
> SerDes protocol, so we need to do pre-validation of PHY mode from device
> tree and not let phylink change it.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

drivers/net/dsa/ocelot/seville_vsc9953.c:636:19: warning: symbol 'vsc9953_vcap_is2_keys' was not declared. Should it be static?
drivers/net/dsa/ocelot/seville_vsc9953.c:706:19: warning: symbol 'vsc9953_vcap_is2_actions' was not declared. Should it be static?
