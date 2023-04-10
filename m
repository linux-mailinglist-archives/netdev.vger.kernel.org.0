Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984C56DC6D0
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjDJMff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjDJMfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:35:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FE3524C
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d2+lBh8lS0G9iUo2LXWeYtJmG+/hNc65qAkbSIa7o2E=; b=N3bI7AceE6SI91NLphVKLaM8kE
        1Xu+YktnmUWAvTU7ewdbXTd591CnnGT2XAkSG+Y9xD6ulirlBjptirwci77hctEavL1/rb45MMRLy
        NZvnlVbEmcBx/ZqvOKMo/kY8P1ESO7FVQ+EV0E73MRLyoKAaykv6P1snfRjQZ+bUFZcU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plqk4-009upD-Mr; Mon, 10 Apr 2023 14:35:28 +0200
Date:   Mon, 10 Apr 2023 14:35:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <c4b386af-2a51-4690-b552-e1da074e06d2@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410100012.esudvvyik3ck7urr@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 01:00:12PM +0300, Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 06:10:31PM +0200, Andrew Lunn wrote:
> > On Fri, Apr 07, 2023 at 06:41:59PM +0300, Vladimir Oltean wrote:
> > > In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
> > > one end and phy-mode = "rev-mii" on the other, right?
> > 
> > In theory, yes. As far as i understand, it makes a difference to where
> > the clock comes from. rev-mii is a clock provider i think.
> > 
> > But from what i understand of the code, and the silicon, this property
> > is going to be ignored, whatever value you give it. phy-mode is only
> > used and respected when the port can support 1000Base-X, SGMII, and
> > above, or use its built in PHY. For MII, GMII, RMII, RGMII the port
> > setting is determined by strapping resistors.
> > 
> > The DSA core however does care that there is a phy-mode, even if it is
> > ignored. I hope after these patches land we can turn that check into
> > enforce mode, and that then unlocks Russell to make phylink
> > improvement.
> 
> Actually, looking at mv88e6xxx_translate_cmode() right now, I guess it's
> not exactly true that the value is going to be ignored, whatever it is.
> A CMODE of MV88E6XXX_PORT_STS_CMODE_MII_PHY is not going to be translated
> into "rev-mii", but into "mii", same as MV88E6XXX_PORT_STS_CMODE_MII.
> Same for MV88E6XXX_PORT_STS_CMODE_RMII_PHY ("rmii" and not "rev-rmii").
> So, when given "rev-mii" or "rev-rmii" as phy modes in the device tree,
> the generic phylink validation procedure should reject them for being
> unsupported.

I tested vf610-zii-devel-rev-c.dtb:

[    2.307416] mv88e6085 mdio_mux-0.1:00: configuring for fixed/rev-rmii link mode
[    2.314459] mv88e6085 mdio_mux-0.1:00: configuring for fixed/xaui link mode
[    2.320588] mv88e6085 mdio_mux-0.1:00: Link is Up - 100Mbps/Full - flow control off
[    2.327722] mv88e6085 mdio_mux-0.2:00: configuring for fixed/xaui link mode
[    2.334729] mv88e6085 mdio_mux-0.2:00: Link is Up - 10Gbps/Full - flow control off
[    2.343263] mv88e6085 mdio_mux-0.1:00: Link is Up - 10Gbps/Full - flow control off
[    2.396110] mv88e6085 mdio_mux-0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Marvell 88E6390 Fa)
[    2.498137] mv88e6085 mdio_mux-0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Marvell 88E6390 Fa)
[    2.566028] mv88e6085 mdio_mux-0.1:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:03] driver [Marvell 88E6390 Fa)
[    2.663995] mv88e6085 mdio_mux-0.1:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:04] driver [Marvell 88E6390 Fa)
[    2.746064] mv88e6085 mdio_mux-0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Marvell 88E6390 Fa)
[    2.834000] mv88e6085 mdio_mux-0.2:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Marvell 88E6390 Fa)
[    2.933998] mv88e6085 mdio_mux-0.2:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:03] driver [Marvell 88E6390 Fa)
[    3.016031] mv88e6085 mdio_mux-0.2:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:04] driver [Marvell 88E6390 Fa)
[    3.033976] mv88e6085 mdio_mux-0.2:00 sff2 (uninitialized): switched to inband/2500base-x link mode

So we can see link mode rev-rmii and there are no errors.

Testing a board using mii, not rmii is going to be a bit harder. I
don't have one set up right now.

      Andrew
