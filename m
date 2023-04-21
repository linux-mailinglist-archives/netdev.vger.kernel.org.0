Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF96EAA00
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjDUMIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDUMIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:08:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD6510268
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 05:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3/1PcGnSWsQvWFuySlUIVg+dGVEwbKNCOLZVzpij698=; b=FuyUY5xDHBHkpxQ+5jMjW6t84/
        gaDOqS+hQShIFlCGL8jADL+OSI8gVR18UC04Uc+q9TTgMPQ/ddsdFLrk0zuiBKojlXjTzZBgujsyf
        92gl1ZaerC7FQP5YBdB/WM9eW3ePZuHGnHJs0X0ceNFn/L20z131r+uSCsU/bBz4UhGQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pppXw-00Asfx-4q; Fri, 21 Apr 2023 14:07:24 +0200
Date:   Fri, 21 Apr 2023 14:07:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next] net: phy: add basic driver for NXP CBTX PHY
Message-ID: <0f3b2afd-760f-40e2-b570-b9dc9b0fd117@lunn.ch>
References: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 10:01:41PM +0300, Vladimir Oltean wrote:
> The CBTX PHY is a Fast Ethernet PHY integrated into the SJA1110 A/B/C
> automotive Ethernet switches.
> 
> It was hoped it would work with the Generic PHY driver, but alas, it
> doesn't. The most important reason why is that the PHY is powered down
> by default, and it needs a vendor register to power it on.
> 
> It has a linear memory map that is accessed over SPI by the SJA1110
> switch driver, which exposes a fake MDIO controller. It has the
> following (and only the following) standard clause 22 registers:
> 
> 0x0: MII_BMCR
> 0x1: MII_BMSR
> 0x2: MII_PHYSID1
> 0x3: MII_PHYSID2
> 0x4: MII_ADVERTISE
> 0x5: MII_LPA
> 0x6: MII_EXPANSION
> 0x7: the missing MII_NPAGE for Next Page Transmit Register
> 
> Every other register is vendor-defined.
> 
> The register map expands the standard clause 22 5-bit address space of
> 0x20 registers, however the driver does not need to access the extra
> registers for now (and hopefully never). If it ever needs to do that, it
> is possible to implement a fake (software) page switching mechanism
> between the PHY driver and the SJA1110 MDIO controller driver.
> 
> Also, Auto-MDIX is turned off by default in hardware, the driver turns
> it on by default and reports the current status. I've tested this with a
> VSC8514 link partner and a crossover cable, by forcing the mode on the
> link partner, and seeing that the CBTX PHY always sees the reverse of
> the mode forced on the VSC8514 (and that traffic works). The link
> doesn't come up (as expected) if MDI modes are forced on both ends in
> the same way (with the cross-over cable, that is).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
