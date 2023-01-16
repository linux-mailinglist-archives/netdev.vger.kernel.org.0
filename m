Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3666CE98
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjAPSQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjAPSPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:15:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C11DB8C;
        Mon, 16 Jan 2023 10:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8SqEStixSgleQx9E0b7GHfKpPPQNCKdg9GWT8X5eRf4=; b=yMjJf8IQct0gI5oHyvQp7NW78W
        sC/k247KEpiFvzToFPV/E85Q1dRBgI0pasD7jRJTz3SyAr81ncgc7xKbblgkQOwIcGm/JGShcWBjK
        /ZudCIkawYUsAtg7ppfoXYMav0FRWEyL5mljVS0DdVI/j5Q1oCoD1DvTNO0+mOWpD9Z/NPkEg2EMz
        nUwNUDNdlOWT03fT3Nq6I2VF/HKutGBHplsut5TTA1p0ZUVSVJRIdgk+3UYp+UaKn2+kK1+65KtCK
        lpb2Fv+pII4/cJ3SRsjM5lBPsB4q315MVeB3EzgEgUNIVgH0D22w00d8Y8+/8CtwrfKOa3XktiSQE
        2WExF76g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36140)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHTp1-0005bB-7z; Mon, 16 Jan 2023 18:03:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHToz-0006Cq-7v; Mon, 16 Jan 2023 18:03:01 +0000
Date:   Mon, 16 Jan 2023 18:03:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jbe@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Message-ID: <Y8WRVWaalcfW+vLB@shell.armlinux.org.uk>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-7-jerry.ray@microchip.com>
 <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
 <MWHPR11MB169301FF4ED0E0BB2305780AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB169301FF4ED0E0BB2305780AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 05:22:05PM +0000, Jerry.Ray@microchip.com wrote:
> > > +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> > > +                                  struct phylink_config *config)
> > > +{
> > > +     struct lan9303 *chip = ds->priv;
> > > +
> > > +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> > > +
> > > +     config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> > > +                                MAC_SYM_PAUSE;
> > 
> > You indicate that pause modes are supported, but...
> > 
> > > +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
> > > +                                     unsigned int mode,
> > > +                                     phy_interface_t interface,
> > > +                                     struct phy_device *phydev, int speed,
> > > +                                     int duplex, bool tx_pause,
> > > +                                     bool rx_pause)
> > > +{
> > > +     u32 ctl;
> > > +
> > > +     /* On this device, we are only interested in doing something here if
> > > +      * this is the xMII port. All other ports are 10/100 phys using MDIO
> > > +      * to control there link settings.
> > > +      */
> > > +     if (port != 0)
> > > +             return;
> > > +
> > > +     ctl = lan9303_phy_read(ds, port, MII_BMCR);
> > > +
> > > +     ctl &= ~BMCR_ANENABLE;
> > > +
> > > +     if (speed == SPEED_100)
> > > +             ctl |= BMCR_SPEED100;
> > > +     else if (speed == SPEED_10)
> > > +             ctl &= ~BMCR_SPEED100;
> > > +     else
> > > +             dev_err(ds->dev, "unsupported speed: %d\n", speed);
> > > +
> > > +     if (duplex == DUPLEX_FULL)
> > > +             ctl |= BMCR_FULLDPLX;
> > > +     else
> > > +             ctl &= ~BMCR_FULLDPLX;
> > > +
> > > +     lan9303_phy_write(ds, port, MII_BMCR, ctl);
> > 
> > There is no code here to program the resolved pause modes. Is it handled
> > internally within the switch? (Please add a comment to this effect
> > either in get_caps or here.)
> > 
> > Thanks.
> > 
> 
> As I look into this, the part does have control flags for advertising
> Symmetric and Asymmetric pause toward the link partner. The default is set
> by a configuration strap on power-up. I am having trouble mapping the rx and
> tx pause parameters into symmetric and asymmetric controls. Where can I find
> the proper definitions and mappings?
> 
>   ctl &= ~( ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_AYM);
>   if(tx_pause)
>     ctl |= ADVERTISE_PAUSE_CAP;
>   if(rx_pause)
>     ctl |= ADVERTISE_PAUSE_AYM;

lan9303_phylink_mac_link_up() has nothing to do with what might be
advertised to the link partner - this is called when the link has been
negotiated and established, and it's purpose is to program the results
of the resolution into the MAC.

That means programming the MAC to operate at the negotiated speed and
duplex, and also permitting the MAC to generate pause frames when its
receive side becomes full (tx_pause) and whether to act on pause frames
received over the network (rx_pause).

If there's nowhere to program the MAC to accept and/or generate pause
frames, how are they controlled? Does the MAC always accept and/or
generate them? Or does the MAC always ignore them and never generates
them?

If the latter, then that suggests pause frames are not supported, and
thus MAC_SYM_PAUSE and MAC_ASYM_PAUSE should not be set in the get_caps
method.

This leads me on to another question - in the above quoted code, what
device's BMCR is being accessed in lan9303_phylink_mac_link_up() ? Is
it a PCS? If it is, please use the phylink_pcs support, as the
pcs_config() method gives you what is necessary to program the PCS
advertisement.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
