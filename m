Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2969066E685
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjAQTE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjAQTBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:01:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436FF303DB;
        Tue, 17 Jan 2023 10:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y9cBDDk6JJaD72oMqAUt7/6UVITS7bKh4vEAkx7xGZs=; b=WJQB90zHY5O6+aCGLfQHpE8peh
        hSPlMui3fWUyiEOrq22/Pzb/yNYAFaeLSCt6e6Grbc43hwoIRHJQm2dt5ueElpgtWX09EltCQyyam
        Ws2WGKa+QePq5/ieskOc1gGYTn4wqRJyVxg/csaMgiD211wfdal6ygG5MjugrklN/1ZEa4i4a4z2D
        Bn6WT7eynmzdPcUFqycMepF3T01IapbKg1iqD70rTvePjGfUlAKPJ6lEFYaZ76ktE8DZPuzQSrVN+
        ixPcI/Dn510yhoxvQpr9sGMbCZikoJMj0EOmYWpiwJ54JDQfJGQ7daalWfBgCFuqJnyUzBNCGZnhs
        f8Loumvg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36166)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHqYF-0008FX-PX; Tue, 17 Jan 2023 18:19:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHqYD-0007Bj-O4; Tue, 17 Jan 2023 18:19:13 +0000
Date:   Tue, 17 Jan 2023 18:19:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jerry.Ray@microchip.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jbe@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 6/6] dsa: lan9303: Migrate to PHYLINK
Message-ID: <Y8bmoZ1Ljf5oegQe@shell.armlinux.org.uk>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
 <20230109211849.32530-7-jerry.ray@microchip.com>
 <Y7/zlzcyTsF+z0cN@shell.armlinux.org.uk>
 <MWHPR11MB169301FF4ED0E0BB2305780AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
 <Y8WRVWaalcfW+vLB@shell.armlinux.org.uk>
 <MWHPR11MB16938EF0B3FBFB87022A327AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16938EF0B3FBFB87022A327AEFC19@MWHPR11MB1693.namprd11.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 10:48:47PM +0000, Jerry.Ray@microchip.com wrote:
> > > > > +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> > > > > +                                  struct phylink_config *config)
> > > > > +{
> > > > > +     struct lan9303 *chip = ds->priv;
> > > > > +
> > > > > +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> > > > > +
> > > > > +     config->mac_capabilities = MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> > > > > +                                MAC_SYM_PAUSE;
> > > >
> > > > You indicate that pause modes are supported, but...
> > > >
> > > > > +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
> > > > > +                                     unsigned int mode,
> > > > > +                                     phy_interface_t interface,
> > > > > +                                     struct phy_device *phydev, int speed,
> > > > > +                                     int duplex, bool tx_pause,
> > > > > +                                     bool rx_pause)
> > > > > +{
> > > > > +     u32 ctl;
> > > > > +
> > > > > +     /* On this device, we are only interested in doing something here if
> > > > > +      * this is the xMII port. All other ports are 10/100 phys using MDIO
> > > > > +      * to control there link settings.
> > > > > +      */
> > > > > +     if (port != 0)
> > > > > +             return;
> > > > > +
> > > > > +     ctl = lan9303_phy_read(ds, port, MII_BMCR);
> > > > > +
> > > > > +     ctl &= ~BMCR_ANENABLE;
> > > > > +
> > > > > +     if (speed == SPEED_100)
> > > > > +             ctl |= BMCR_SPEED100;
> > > > > +     else if (speed == SPEED_10)
> > > > > +             ctl &= ~BMCR_SPEED100;
> > > > > +     else
> > > > > +             dev_err(ds->dev, "unsupported speed: %d\n", speed);
> > > > > +
> > > > > +     if (duplex == DUPLEX_FULL)
> > > > > +             ctl |= BMCR_FULLDPLX;
> > > > > +     else
> > > > > +             ctl &= ~BMCR_FULLDPLX;
> > > > > +
> > > > > +     lan9303_phy_write(ds, port, MII_BMCR, ctl);
> > > >
> > > > There is no code here to program the resolved pause modes. Is it handled
> > > > internally within the switch? (Please add a comment to this effect
> > > > either in get_caps or here.)
> > > >
> > > > Thanks.
> > > >
> > >
> > > As I look into this, the part does have control flags for advertising
> > > Symmetric and Asymmetric pause toward the link partner. The default is set
> > > by a configuration strap on power-up. I am having trouble mapping the rx and
> > > tx pause parameters into symmetric and asymmetric controls. Where can I find
> > > the proper definitions and mappings?
> > >
> > >   ctl &= ~( ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_AYM);
> > >   if(tx_pause)
> > >     ctl |= ADVERTISE_PAUSE_CAP;
> > >   if(rx_pause)
> > >     ctl |= ADVERTISE_PAUSE_AYM;
> > 
> > lan9303_phylink_mac_link_up() has nothing to do with what might be
> > advertised to the link partner - this is called when the link has been
> > negotiated and established, and it's purpose is to program the results
> > of the resolution into the MAC.
> > 
> > That means programming the MAC to operate at the negotiated speed and
> > duplex, and also permitting the MAC to generate pause frames when its
> > receive side becomes full (tx_pause) and whether to act on pause frames
> > received over the network (rx_pause).
> > 
> > If there's nowhere to program the MAC to accept and/or generate pause
> > frames, how are they controlled? Does the MAC always accept and/or
> > generate them? Or does the MAC always ignore them and never generates
> > them?
> > 
> > If the latter, then that suggests pause frames are not supported, and
> > thus MAC_SYM_PAUSE and MAC_ASYM_PAUSE should not be set in the get_caps
> > method.
> > 
> > This leads me on to another question - in the above quoted code, what
> > device's BMCR is being accessed in lan9303_phylink_mac_link_up() ? Is
> > it a PCS? If it is, please use the phylink_pcs support, as the
> > pcs_config() method gives you what is necessary to program the PCS
> > advertisement.
> > 
> > Thanks.
> > 
> > --
> 
> On this device, the XMII connection is the rev-xmii port connected to the CPU.
> This is the DSA port. This device 'emulates' a phy (virtual phy) allowing the
> CPU to use standard phy registers to set things up.
> 
> Let me back up for a moment.
> The device supports half-duplex BackPressure as well as full-duplex Flow
> Control.
> The device has bootstrapping options that will configure the Settings for
> BP and FC. On port 0, these strapping options also affect the Virtual Phys
> Auto-Negotiation Link Partner Base Page Ability Register.
> If auto-negotiation is enabled, the flow control is enabled/disabled based
> on the Sym/Asym settings of the Advertised and Link Partner's capabilities
> registers.
> If Manual Flow Control is enabled, then flow control is programmed into the
> Manual_FC_0 register directly and the auto-neg registers are ignored. The
> device can be strapped to use (default to) the Manual FC register.
> 
> So this is why I'm trying to reflect the flow control settings as provided in
> the mac_link_up hook api into the emulated phy's aneg settings.

But it's wrong to be trying to do that.

The advertisement (in other words _our_ capabilities) should be
configured at one of the _config() stages - which includes the speed,
duplex and pause capabilities.

When the link partner wants to connect, the advertisement is exchanged
between each ends, and these advertisements are then used to determine
the final properties of the link. At this point, the link comes up,
and the link_up() methods will be called.

If, in the link_up() method, you want to change the advertisement, then
you would need to program that, and _then_ trigger a renegotiation of
the link, which would cause the link to go down. The above process would
be repeated, and ultimately link_up() would be called again. You'd then
reprogram the advertisement and trigger another renegotiation, and the
link would go down, up, down, up, down, up indefinitely.

> Question:  In the get capabilities API, should I report the device's
> flow control capabilities independent of how the device is bootstrapped or
> should I reflect the bootstrapped settings? I consider the bootstrap setting
> to affect the register default rather than limit what the device is physically
> capable of supporting.

I would suggest that the bootstrapping should in this case be reflected
in the MAC_*_PAUSE settings passed to phylink, so phylink knows how that
is configured and should end up with the same resolution as the
hardware. Things can go wrong if ethtool is then used to force manual
pause settings, but in such a case, you will be provided with the new
advertisement using the standard algorithm for determining the ASYM and
SYM bits that the kernel uses (which is not perfect, since it's
ambiguous.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
