Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F74CFFD5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbiCGNUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiCGNUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:20:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE50175231;
        Mon,  7 Mar 2022 05:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jkgrcGL5XxpJ/cC4Kt/aatOT+J8nw9xV7dTD+5vlNho=; b=NHMy8ziVDRxFeSeIznqzsV++75
        ckAOyrvY2K4CskAbd1s/hYhu5qkWOTNbL7+hAFhbw6ukxwVN8ydKrXg9Clp2f6cEMaZz+hnmB+uMC
        cEpl8YGNdxDiJPOz3YsNicefaOhfepzslxCUNE6vKOy5ui/XgZn5VI1H4I5RIDCpvDMM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRDGs-009cIY-Fy; Mon, 07 Mar 2022 14:19:30 +0100
Date:   Mon, 7 Mar 2022 14:19:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com,
        Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
Message-ID: <YiYGYuOGLMaRz45W@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-4-Divya.Koppera@microchip.com>
 <YiIOwZih+I6gsNlM@lunn.ch>
 <CO1PR11MB4771EC01014BE84EF96AE536E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771EC01014BE84EF96AE536E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +     /* Make sure the PHY is not broken. Read idle error count,
> > > +      * and reset the PHY if it is maxed out.
> > > +      */
> > > +     regval = phy_read(phydev, MII_STAT1000);
> > > +     if ((regval & 0xFF) == 0xFF) {
> > > +             phy_init_hw(phydev);
> > > +             phydev->link = 0;
> > > +             if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
> > > +                     phydev->drv->config_intr(phydev);
> > > +             return genphy_config_aneg(phydev);
> > > +     }
> > 
> > Is this related to PTP? Or is the PHY broken in general? This looks like it should
> > be something submitted to stable.
> >
> 
> Previously lan8814 phy used kszphy_read_status, we have reused the same function and added new
> Changes related to latency with new function lan8814_read_status.

Ah, ksz9031_read_status() already has this workaround. How important
is the ordering here? Rather than cut/paste the code, why not actually
call ksz9031_read_status() to get the basic link status and then
append the additional information in this function.

> > > +static int lan8814_config_init(struct phy_device *phydev) {
> > > +     int val;
> > > +
> > > +     /* Reset the PHY */
> > > +     val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
> > > +     val |= LAN8814_QSGMII_SOFT_RESET_BIT;
> > > +     lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET,
> > > + val);
> > > +
> > > +     /* Disable ANEG with QSGMII PCS Host side */
> > > +     val = lanphy_read_page_reg(phydev, 5,
> > LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
> > > +     val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
> > > +     lanphy_write_page_reg(phydev, 5,
> > > + LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
> > > +
> > > +     /* MDI-X setting for swap A,B transmit */
> > > +     val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
> > > +     val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
> > > +     val |= LAN8814_ALIGN_TX_A_B_SWAP;
> > > +     lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
> > 
> > This does not look related to PTP. If David has not ready merged this, i would
> > of said you should of submitted this as a separate patch.
> > 
> 
> This code already present in lan8814 phy code. I think due to movement of function from up to down.
> This change reflected here.

I don't remember seeing the same code with - at the beginning.  In
general, it is better to have lots of small patches, each being
obviously correct. If you need to move a function earlier/later, do it
in a patch of its own. It is obviously correct, so takes 0 time to
review, and makes the remaining patches simpler, so also easier to
review.

	Andrew
