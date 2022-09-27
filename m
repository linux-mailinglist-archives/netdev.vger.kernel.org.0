Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15B85EC355
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiI0MyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiI0MyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:54:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F34BB2DBE;
        Tue, 27 Sep 2022 05:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TwOM1cbMVamtPFkYywyOaop0czuweJ5MvSviS0bOHi0=; b=dfm0iFVe5lEvCkZOgTTjD090jA
        WZhnAw601Wp/gq2AYvLBf1KpneMIUMawkuRQzmwbnUA7EpLuWeTp24F+1DXQu+vD8UYpm35vvfeSX
        Ul9bxMrs8nQhgzJg/mGT/RZ+C8iXQQMcrwvUfyJP9fd2KbLCUGx+y/CfNUIBs+27oFhQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odA6A-000P5e-PC; Tue, 27 Sep 2022 14:54:06 +0200
Date:   Tue, 27 Sep 2022 14:54:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <YzLybsJBIHtbQOwE@lunn.ch>
References: <20220922052803.3442561-1-yoshihiro.shimoda.uh@renesas.com>
 <20220922052803.3442561-3-yoshihiro.shimoda.uh@renesas.com>
 <Yy2wivbzUA2zroqy@lunn.ch>
 <TYBPR01MB5341ACAD30E913D01C94FE08D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YzH65W3r1IV+rHFW@lunn.ch>
 <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB534189F384D8A0F5E5E00666D8559@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > How do the CPU ports differ to the other ports? When you mention CPU
> > ports, it makes me wonder if this should be a DSA driver?
> 
> I compared a DSA diagram [1] and this Ethernet Switch and then
> this switch differs than the DSA diagram:
> - This switch has a feature which accesses DRAM directly like an "ethernet controller".
>   I called this feature as "cpu port", but it might be incorrect.
> - This switch has doesn't have any "control path". Instead of that, this switch
>   is controled by registers via APB (internal bus) directly.
> 
> So, IIUC, this should not be a DSA driver.
> 
> [1] https://bootlin.com/blog/tag/dsa/
> 
> > Is there a public data sheet for this device?
> 
> Unfortunately, we have no public data sheet for this device.
> But, I tried to figure this switch diagram about control/data paths as below:
> 
> Control path:
> +--- R-Car S4-8 SoC -------------------------+
> |                                            |
> | CPU ---(APB bus)---+--- Ethernet Switch ---|---(MDIO)--------------+
> |                    |                       |                       |
> |                    +--- Ethernet SERDES    |              External Ethernet PHY --- RJ45
> |                                            |
> +--------------------------------------------+
> Notes: The switch and SERDES have 3 ports of MDIO and SGMII.
> 
> Data Path:
> +--- R-Car S4-8 SoC ---------------------------------------------------------+
> |                                                                            |
> | CPU ---(AXI bus)---+--- DRAM        +--------+                             |
> |                    +---(cpu port)---|        |---(ether port)--- SERDES ---|---(SGMII)--- PHY --- RJ45
> |                    |                | Switch |---(ether port)--- SERDES ---|---(SGMII)--- PHY --- RJ45
> |                    +---(cpu port)---|        |---(ether port)--- SERDES ---|---(SGMII)--- PHY --- RJ45
> |                                     +--------|                             |
> +----------------------------------------------------------------------------+

This device is somewhere between a DSA switch and a pure switchdev
switch. It probably could be modelled as a DSA switch.

For a pure switchdev switch, you have a set of DMA channels per user
port. So with 3 user ports, i would expect there to be three sets of
RX and TX DMA rings. Frames from the CPU would go directly to the user
ports, bypassing the switch.

For this hardware, how are the rings organised? Are the rings for the
CPU ports, or for the user ports? How do you direct a frame from the
CPU out a specific user port? Via the DMA ring you place it into, or
do you need a tag on the frame to indicate its egress port?

The memory mapping of the registers is not really an issue. The
B52/SF2 can have memory mapped registers.

> The current driver only supports one of MDIO, cpu port and ethernet port, and it acts as an ethernet device.
> 
> > > Perhaps, since the current driver supports 1 ethernet port and 1 CPU port only,
> > > I should modify this driver for the current condition strictly.
> > 
> > I would suggest you support all three user ports. For an initial
> > driver you don't need to support any sort of acceleration. You don't
> > need any hardware bridging etc. That can be added later. Just three
> > separated ports.
> 
> Thank you for your suggestion. However, supporting three user ports
> is required to modify an external ethernet PHY driver.
> (For now, a boot loader initialized the PHY, but one port only.)
> 
> The PHY is 88E2110 on my environment, so Linux has a driver in
> drivers/net/phy/marvell10g.c. However, I guess this is related to
> configuration of the PHY chip on the board, it needs to change
> the host 7interface mode, but the driver doesn't support it for now.

Please give us more details. The marvell10g driver will change its
host side depending on the result of the line side negotiation. It
changes the value of phydev->interface to indicate what is it doing on
its host side, and you have some control over what modes it will use
on the host side. You can probably define its initial host side mode
via phy-mode in DT.

Also, relying on the bootloader is a bad idea. People like to change
the bootloader, upgrade it for new features, etc. In the ARM world we
try to avoid any dependency on the bootloader.

> > In the DSA world we call these user ports.
> 
> I got it.
> However, when I read the dsa document of Linux kernel,
> it seems to call DSA ports. Perhaps, I could misunderstand the document though...
> https://docs.kernel.org/networking/dsa/dsa.html

DSA has four classes of ports:

User ports:   connected to the outside world
CPU ports:    connected to the SoC
DSA ports:    connecting between switches. If you have two switches and want
              to combine them into one cluster, you use DSA ports between
	      them.
Unused ports: Physically exist, but are unused in the board design.

       Andrew
