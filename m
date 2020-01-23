Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1734147182
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWTKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 14:10:23 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:34289 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgAWTKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 14:10:23 -0500
Received: by mail-ot1-f43.google.com with SMTP id a15so3852799otf.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 11:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JxlVhpOfDv5UrdhXDwsO/q6QSO+kefSG3I3h0fUuLXs=;
        b=lRFZWK/DFZyfIBJj7dTejQx99OkNtVosB1p8XjndV3rfY20pYO801gBLoTTUB32orW
         lHc5IXHD6KcGJw82kWBbPl44PgJyuVB31mNJUrx/VB+9Pt770r+sTdFudlaXLCNff89W
         a98UGGPPIgV8uuVx3ZIhSwC6WZaHWORpDMnN0WwP3F+ICawxl761nfcCZBXeSaI6Vz8J
         QWMQ+Wa0zZzxPUCeAuwEG0sc8qJSWHlyzTl5nM0K1To0FXRTqHuXOdWt32Gk1RmGzPSC
         jxKjrA/VyF7ESx+PSNOEXHvhI8Mq6hZGm0QT05/mIKfR/PqJf+FEgMf2g7Ll7vXiVD8Z
         s5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JxlVhpOfDv5UrdhXDwsO/q6QSO+kefSG3I3h0fUuLXs=;
        b=laMEoxoDkBa2kdV9kKOxdaMizsGm+low0+D3BW1rj9m2WNSFqYIqk6a60j9ZagO7Oo
         NAgreH3Y5z8ymq5mmi5UAv9ArvXcmwMSf6UULRvEBhXwI1IxesrOsu8TAs+JPNPBirQ0
         ZjaGk5XPDwvYUhoiHzaI0orb8pCz6oK0KmAlT3Zp2uWIAQV9XtINuIajr4/8XNcnb4S/
         2eP4SV/XjQrrk2BvCIxp4RAj8NHR2w6IqT5UmfkqB7MU/JliyS65zEL2fxTcYJ3d4NVt
         YerrNUZbGh8/8RcWBhrsrDpSmUmiPc4qwtLlQO5v+c3QYHJvA++crFUIk8D8ftpit7eW
         xvJA==
X-Gm-Message-State: APjAAAWaE/S8hdu6GiuIxom8+lC53/qpsFClo1R8IcRuUW9CPRr6I5Jr
        iTrphiuD4FyH+BGaVBQajawBKdyBa4KrJbPRGZEgLjw=
X-Google-Smtp-Source: APXvYqznw3RCUmp7OfVByJlY0167KRg+5G0FSmQbHbNEH3DGNbqNJQEE2thGFulGVqXf8Ji9LZQGlSX9fRNQXiC2vc8=
X-Received: by 2002:a9d:5885:: with SMTP id x5mr12058139otg.132.1579806621110;
 Thu, 23 Jan 2020 11:10:21 -0800 (PST)
MIME-Version: 1.0
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 23 Jan 2020 13:10:09 -0600
Message-ID: <CAFSKS=OZzodqriVqjV_rJMrjBoDzK1rAhnU9E4FAROtt553f=w@mail.gmail.com>
Subject: net: phy: PHY connected SFP behavior
To:     netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In my September email I asked about Copper SFP modules connected
through a Marvell 88E1512 PHY to an RGMII MAC. Realizing that is off
the table until netdev can support nested PHYs, I'd like to know what
PHY driver support for SFPs (using phy_sfp_probe()) is supposed to
achieve (other than diagnostics) and how. Maybe this discussion could
even lead to some documentation.

I was expecting ethtool to show "1000baseX/Full" for "Supported link
modes" when a 1000BASE-SX SFP is installed. Is this how it's supposed
to work? Is the PHY driver supposed to use the parsed SFP information
to limit the supported modes and settings? If so where should this
occur?

I added some code to print an error and return -EINVAL if
sfp_select_interface() doesn't return PHY_INTERFACE_MODE_1000BASEX in
my .module_insert implementation. However, I notice that if I install
an RJ45 SFP it prints the error but link is actually established (and
works at 1000 full)! Even if the product ships with no RJ45 SFP
support, someone will inevitably install an RJ45 SFP, plug into a
1000BaseT switch and assume it'll work in every case. Then I'll get
calls when it doesn't work on a 100BaseT switch. Any thoughts on
how/if this should be handled?

Information reported by ethtool when the 1000BASE-SX SFP module is
installed (after running ip link set eth1 up):

ethtool eth1
Settings for eth1:
        Supported ports: [ TP MII FIBRE ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: MII
        PHYAD: 0
        Transceiver: internal
        Auto-negotiation: on
        Supports Wake-on: d
        Wake-on: d
        Link detected: yes


It also shows these supported link modes if no SFP module is present.
As you can see below the SFP module is 1000BASE-SX.

ethtool -m eth1
    Identifier                                : 0x03 (SFP)
    Extended identifier                       : 0x04 (GBIC/SFP defined
by 2-wire interface ID)
    Connector                                 : 0x07 (LC)
    Transceiver codes                         : 0x00 0x00 0x00 0x01
0x20 0x40 0x0c 0x01 0x00
    Transceiver type                          : Ethernet: 1000BASE-SX
    Transceiver type                          : FC: intermediate distance (I)
    Transceiver type                          : FC: Shortwave laser w/o OFC (SN)
    Transceiver type                          : FC: Multimode, 62.5um (M6)
    Transceiver type                          : FC: Multimode, 50um (M5)
    Transceiver type                          : FC: 100 MBytes/sec
    Encoding                                  : 0x01 (8B/10B)
    BR, Nominal                               : 1300MBd
    Rate identifier                           : 0x00 (unspecified)
    Length (SMF,km)                           : 0km
    Length (SMF)                              : 0m
    Length (50um)                             : 550m
    Length (62.5um)                           : 300m
    Length (Copper)                           : 0m
    Length (OM3)                              : 0m
    Laser wavelength                          : 850nm
    Vendor name                               : OPTOWAY
    Vendor OUI                                : 00:0e:fa
    Vendor PN                                 : SPM-7100AWG
    Vendor rev                                : 0000
    Option values                             : 0x00 0x1a
    Option                                    : RX_LOS implemented
    Option                                    : TX_FAULT implemented
    Option                                    : TX_DISABLE implemented
    BR margin, max                            : 0%
    BR margin, min                            : 0%
    Vendor SN                                 : 154501267
    Date code                                 : 151104
    Optical diagnostics support               : Yes
    Laser bias current                        : 4.128 mA
    Laser output power                        : 0.2104 mW / -6.77 dBm
    Receiver signal average optical power     : 0.1683 mW / -7.74 dBm
    Module temperature                        : 41.59 degrees C /
106.87 degrees F
    Module voltage                            : 3.2744 V
    Alarm/warning flags implemented           : Yes
    Laser bias current high alarm             : Off
    Laser bias current low alarm              : Off
    Laser bias current high warning           : Off
    Laser bias current low warning            : Off
    Laser output power high alarm             : Off
    Laser output power low alarm              : Off
    Laser output power high warning           : Off
    Laser output power low warning            : Off
    Module temperature high alarm             : Off
    Module temperature low alarm              : Off
    Module temperature high warning           : Off
    Module temperature low warning            : Off
    Module voltage high alarm                 : Off
    Module voltage low alarm                  : Off
    Module voltage high warning               : Off
    Module voltage low warning                : Off
    Laser rx power high alarm                 : Off
    Laser rx power low alarm                  : Off
    Laser rx power high warning               : Off
    Laser rx power low warning                : Off
    Laser bias current high alarm threshold   : 20.000 mA
    Laser bias current low alarm threshold    : 1.000 mA
    Laser bias current high warning threshold : 15.000 mA
    Laser bias current low warning threshold  : 2.000 mA
    Laser output power high alarm threshold   : 0.6310 mW / -2.00 dBm
    Laser output power low alarm threshold    : 0.1000 mW / -10.00 dBm
    Laser output power high warning threshold : 0.5012 mW / -3.00 dBm
    Laser output power low warning threshold  : 0.1259 mW / -9.00 dBm
    Module temperature high alarm threshold   : 95.00 degrees C /
203.00 degrees F
    Module temperature low alarm threshold    : -35.00 degrees C /
-31.00 degrees F
    Module temperature high warning threshold : 85.00 degrees C /
185.00 degrees F
    Module temperature low warning threshold  : -30.00 degrees C /
-22.00 degrees F
    Module voltage high alarm threshold       : 3.6000 V
    Module voltage low alarm threshold        : 3.0000 V
    Module voltage high warning threshold     : 3.5000 V
    Module voltage low warning threshold      : 3.1000 V
    Laser rx power high alarm threshold       : 0.6310 mW / -2.00 dBm
    Laser rx power low alarm threshold        : 0.0126 mW / -19.00 dBm
    Laser rx power high warning threshold     : 0.5012 mW / -3.00 dBm
    Laser rx power low warning threshold      : 0.0200 mW / -16.99 dBm


I'm testing with the phy branch of git://git.armlinux.org.uk/linux-arm.git

I modified marvell.c to call phy_sfp_probe() exactly like marvell10g.c.

I then modified my devicetree to include the following (note fec2 is
connected to the Marvell 88E1512 PHY that is connected to the SFP
cage):
/ {

...

        sfp: sfp {
                compatible = "sff,sfp";
                i2c-bus = <&i2c4>;
                los-gpio = <&expander0 2 GPIO_ACTIVE_HIGH>;
                mod-def0-gpio = <&expander0 0 GPIO_ACTIVE_LOW>;
                tx-fault-gpio = <&expander0 1 GPIO_ACTIVE_HIGH>;
                maximum-power-milliwatt = <1000>;
        };
};

&fec1 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_enet1>;
        phy-mode = "rgmii-id";
        status = "okay";

        mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                ethphy0: ethernet-phy@0 {
                        reg = <0>;
                        sfp = <&sfp>;
                };
        };

        fixed-link {
                speed = <1000>;
                full-duplex;
        };
};

&fec2 {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_enet2>;
        phy-mode = "rgmii-id";
        phy-handle = <&ethphy0>;
        status = "okay";
};

Thanks!
George McCollister
