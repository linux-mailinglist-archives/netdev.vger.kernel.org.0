Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F399A147542
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 01:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgAXAGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 19:06:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35444 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbgAXAGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 19:06:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RKS5uxiOtDTnd0PSxnRDGoN0y9I/BTA82zbXo7yl1+4=; b=qLEddNv0aq4kNLHaM1x38dRZ9
        0GSNqvEs0KbRZUqTtdaZy8TbMwueNLXppT2XmqdvyjaTvpyFW+UM0JuSveHtfftfMfknPtUUStsa0
        ufwLzbA34X7DoqdFtEdgwUuvb+45iP4DWKo29RQVBMEDR5ti2DNDyHvNlh84U7aHZ4QCeN9vPLqkG
        v/2zugXUGIoCo6cqPBihdHcX6jVX/RfXxh///qhd1sKTfhMCxf7Vx9gEKl9q+ky7NZ01t6nO1ZGTX
        BzRLyz4rAQb30dbvUrJFSKpwDsWJdwrSMN1oizdcu/9TFhw2Fl3H3z4Fdn67qmuAalSPeYEF9XyRb
        6ywamj3dA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42454)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iumUB-0004C2-IU; Fri, 24 Jan 2020 00:06:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iumU9-0006DN-Dh; Fri, 24 Jan 2020 00:06:05 +0000
Date:   Fri, 24 Jan 2020 00:06:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: net: phy: PHY connected SFP behavior
Message-ID: <20200124000605.GP25745@shell.armlinux.org.uk>
References: <CAFSKS=OZzodqriVqjV_rJMrjBoDzK1rAhnU9E4FAROtt553f=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OZzodqriVqjV_rJMrjBoDzK1rAhnU9E4FAROtt553f=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 01:10:09PM -0600, George McCollister wrote:
> In my September email I asked about Copper SFP modules connected
> through a Marvell 88E1512 PHY to an RGMII MAC. Realizing that is off
> the table until netdev can support nested PHYs, I'd like to know what
> PHY driver support for SFPs (using phy_sfp_probe()) is supposed to
> achieve (other than diagnostics) and how. Maybe this discussion could
> even lead to some documentation.

It's just an add-on right now to allow things to work, primarily for
the 88x3310 PHY.  How it works depends entirely on the PHY driver
co-operating to do the right things.

> I was expecting ethtool to show "1000baseX/Full" for "Supported link
> modes" when a 1000BASE-SX SFP is installed. Is this how it's supposed
> to work? Is the PHY driver supposed to use the parsed SFP information
> to limit the supported modes and settings? If so where should this
> occur?

Although the 88e151x code supports the fibre page, and will report
link up if the fibre page does so, the driver initialises the PHY
feature masks using PHY_GBIT_FIBRE_FEATURES which does not include
1000baseX.

Consequently, marvell.c is telling phylib and the rest of the kernel
that the 88e151x does not support any fibre link modes.

> I added some code to print an error and return -EINVAL if
> sfp_select_interface() doesn't return PHY_INTERFACE_MODE_1000BASEX in
> my .module_insert implementation. However, I notice that if I install
> an RJ45 SFP it prints the error but link is actually established (and
> works at 1000 full)!

It is possible for the link to come up with 1000BASE-X at one end
and Cisco SGMII on the other end, but bear in mind that Cisco SGMII
is a vendor hack using 1000BASE-X as its basis, repurposing the
contents of the 16-bit configuration word used for 1000BASE-X
negotiation, and introducing symbol replication to achieve the
slower speeds.

So, if negotiation completes in some way (e.g. by both the SFP PHY
and the 88e1512 bringing the link up in "bypass" mode, or by
misinterpretation of the configuration word) then it is entirely
possible to pass traffic at 1Gbps.

> Even if the product ships with no RJ45 SFP
> support, someone will inevitably install an RJ45 SFP, plug into a
> 1000BaseT switch and assume it'll work in every case. Then I'll get
> calls when it doesn't work on a 100BaseT switch. Any thoughts on
> how/if this should be handled?

If a big-name switch only supports 1000BASE-X on a SFP cage, and
someone plugs a SGMII module in, the situation is the same.  The
results are indeterminant.  If the switch vendor has decided not
to support such modules (e.g. by only allowing whitelisted modules
to reduce their support costs - which I believe is commonly portrayed
on the 'net as "vendor lockin" with SFP modules) then they get bad
stick as a result of that... I don't think there is a solution to
this.

> Information reported by ethtool when the 1000BASE-SX SFP module is
> installed (after running ip link set eth1 up):
> 
> ethtool eth1
> Settings for eth1:
>         Supported ports: [ TP MII FIBRE ]
>         Supported link modes:   10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Supported pause frame use: Symmetric
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Half 10baseT/Full
>                                 100baseT/Half 100baseT/Full
>                                 1000baseT/Full
>         Advertised pause frame use: Symmetric
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Link partner advertised link modes:  1000baseT/Full
>         Link partner advertised pause frame use: No
>         Link partner advertised auto-negotiation: No
>         Link partner advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: MII
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: d
>         Wake-on: d
>         Link detected: yes

Unfortunately, even if the Marvell PHY driver detects a 1000BASE-X
link, it parses it using fiber_lpa_mod_linkmode_lpa_t(), which
will report it as 1000baseT/Full or 1000baseT/Half.  It's also my
belief that the driver mis-parses the pause mode settings as well.

The same is true of linkmode_adv_to_fiber_adv_t() - it uses
the 1000baseT/Full and 1000baseT/Half to set the fibre FD and HD
bits (which are actually 1000baseX) and also sets the fibre pause
mode settings incorrectly.

As I don't have a setup using 88e151x PHYs, I've been leaving well
alone as I've been assuming whoever contributed the code has a
working setup for it, and changing it could cause a userspace
regression - that's the problem when userspace visible APIs that are
incorrectly implemented, fixing the cockup becomes extremely difficult
because of the risk of causing regressions.

For example, we don't have an ethtool capability for 1000baseX/Half,
so we can't convert this code to use the 1000baseX linkmodes without
dropping half duplex support, but how do we know whether anyone is
using that... the only way we /could/ find out is to intentionally
break it and wait to see if anyone complains, but if they complain
in a few years time, we still need to fix it... and if they're relying
on the current usage of 1000baseT/* then we're basically screwed, we
have to revert back to the existing behaviour.

> It also shows these supported link modes if no SFP module is present.
> As you can see below the SFP module is 1000BASE-SX.
> 
> ethtool -m eth1
>     Identifier                                : 0x03 (SFP)
>     Extended identifier                       : 0x04 (GBIC/SFP defined
> by 2-wire interface ID)
>     Connector                                 : 0x07 (LC)
>     Transceiver codes                         : 0x00 0x00 0x00 0x01
> 0x20 0x40 0x0c 0x01 0x00
>     Transceiver type                          : Ethernet: 1000BASE-SX
>     Transceiver type                          : FC: intermediate distance (I)
>     Transceiver type                          : FC: Shortwave laser w/o OFC (SN)
>     Transceiver type                          : FC: Multimode, 62.5um (M6)
>     Transceiver type                          : FC: Multimode, 50um (M5)
>     Transceiver type                          : FC: 100 MBytes/sec
>     Encoding                                  : 0x01 (8B/10B)
>     BR, Nominal                               : 1300MBd
>     Rate identifier                           : 0x00 (unspecified)
>     Length (SMF,km)                           : 0km
>     Length (SMF)                              : 0m
>     Length (50um)                             : 550m
>     Length (62.5um)                           : 300m
>     Length (Copper)                           : 0m
>     Length (OM3)                              : 0m
>     Laser wavelength                          : 850nm
>     Vendor name                               : OPTOWAY
>     Vendor OUI                                : 00:0e:fa
>     Vendor PN                                 : SPM-7100AWG
>     Vendor rev                                : 0000
>     Option values                             : 0x00 0x1a
>     Option                                    : RX_LOS implemented
>     Option                                    : TX_FAULT implemented
>     Option                                    : TX_DISABLE implemented
>     BR margin, max                            : 0%
>     BR margin, min                            : 0%
>     Vendor SN                                 : 154501267
>     Date code                                 : 151104
>     Optical diagnostics support               : Yes
>     Laser bias current                        : 4.128 mA
>     Laser output power                        : 0.2104 mW / -6.77 dBm
>     Receiver signal average optical power     : 0.1683 mW / -7.74 dBm
>     Module temperature                        : 41.59 degrees C /
> 106.87 degrees F
>     Module voltage                            : 3.2744 V
>     Alarm/warning flags implemented           : Yes
>     Laser bias current high alarm             : Off
>     Laser bias current low alarm              : Off
>     Laser bias current high warning           : Off
>     Laser bias current low warning            : Off
>     Laser output power high alarm             : Off
>     Laser output power low alarm              : Off
>     Laser output power high warning           : Off
>     Laser output power low warning            : Off
>     Module temperature high alarm             : Off
>     Module temperature low alarm              : Off
>     Module temperature high warning           : Off
>     Module temperature low warning            : Off
>     Module voltage high alarm                 : Off
>     Module voltage low alarm                  : Off
>     Module voltage high warning               : Off
>     Module voltage low warning                : Off
>     Laser rx power high alarm                 : Off
>     Laser rx power low alarm                  : Off
>     Laser rx power high warning               : Off
>     Laser rx power low warning                : Off
>     Laser bias current high alarm threshold   : 20.000 mA
>     Laser bias current low alarm threshold    : 1.000 mA
>     Laser bias current high warning threshold : 15.000 mA
>     Laser bias current low warning threshold  : 2.000 mA
>     Laser output power high alarm threshold   : 0.6310 mW / -2.00 dBm
>     Laser output power low alarm threshold    : 0.1000 mW / -10.00 dBm
>     Laser output power high warning threshold : 0.5012 mW / -3.00 dBm
>     Laser output power low warning threshold  : 0.1259 mW / -9.00 dBm
>     Module temperature high alarm threshold   : 95.00 degrees C /
> 203.00 degrees F
>     Module temperature low alarm threshold    : -35.00 degrees C /
> -31.00 degrees F
>     Module temperature high warning threshold : 85.00 degrees C /
> 185.00 degrees F
>     Module temperature low warning threshold  : -30.00 degrees C /
> -22.00 degrees F
>     Module voltage high alarm threshold       : 3.6000 V
>     Module voltage low alarm threshold        : 3.0000 V
>     Module voltage high warning threshold     : 3.5000 V
>     Module voltage low warning threshold      : 3.1000 V
>     Laser rx power high alarm threshold       : 0.6310 mW / -2.00 dBm
>     Laser rx power low alarm threshold        : 0.0126 mW / -19.00 dBm
>     Laser rx power high warning threshold     : 0.5012 mW / -3.00 dBm
>     Laser rx power low warning threshold      : 0.0200 mW / -16.99 dBm
> 
> 
> I'm testing with the phy branch of git://git.armlinux.org.uk/linux-arm.git
> 
> I modified marvell.c to call phy_sfp_probe() exactly like marvell10g.c.
> 
> I then modified my devicetree to include the following (note fec2 is
> connected to the Marvell 88E1512 PHY that is connected to the SFP
> cage):
> / {
> 
> ...
> 
>         sfp: sfp {
>                 compatible = "sff,sfp";
>                 i2c-bus = <&i2c4>;
>                 los-gpio = <&expander0 2 GPIO_ACTIVE_HIGH>;
>                 mod-def0-gpio = <&expander0 0 GPIO_ACTIVE_LOW>;
>                 tx-fault-gpio = <&expander0 1 GPIO_ACTIVE_HIGH>;
>                 maximum-power-milliwatt = <1000>;
>         };
> };
> 
> &fec1 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_enet1>;
>         phy-mode = "rgmii-id";
>         status = "okay";
> 
>         mdio {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 ethphy0: ethernet-phy@0 {
>                         reg = <0>;
>                         sfp = <&sfp>;
>                 };
>         };
> 
>         fixed-link {
>                 speed = <1000>;
>                 full-duplex;
>         };
> };
> 
> &fec2 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_enet2>;
>         phy-mode = "rgmii-id";
>         phy-handle = <&ethphy0>;
>         status = "okay";
> };
> 
> Thanks!
> George McCollister
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
