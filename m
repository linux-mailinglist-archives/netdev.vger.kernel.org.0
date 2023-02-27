Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B829D6A4247
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjB0NJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjB0NJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:09:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E396CDCF;
        Mon, 27 Feb 2023 05:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S/7WtCGaQMhXLXtk7Vr0qWEeT3/0Qv7S0/Mtts2Gzn0=; b=kDGxtBGgY7u9qf1RnK+vtQTBir
        uorUoWl/XnfkFfXHPt0L2r6hu/z+jQQ/fqlrWMeCRWQXBUZu6pS9Pw4t8ky1lPKSy/b0AxG1bcUSx
        Yocm97Qfq2bNDlKufQfsKscqyVzrcLX7a4tRwsLnw/mkEMyCIuj6WU2We/SvJAfn6wgE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pWdEx-0064oo-Pg; Mon, 27 Feb 2023 14:08:27 +0100
Date:   Mon, 27 Feb 2023 14:08:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Message-ID: <Y/yrS65V7h5vG7xN@lunn.ch>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
 <20230224174132.GA1224969@roeck-us.net>
 <20230224183646.GA26307@pengutronix.de>
 <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> > index f595acd0a895..67dac9f0e71d 100644
> > --- a/drivers/net/phy/phy-c45.c
> > +++ b/drivers/net/phy/phy-c45.c
> > @@ -799,6 +799,7 @@ static int genphy_c45_read_eee_cap1(struct phy_device *phydev)
> >           * (Register 3.20)
> >           */
> >          val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
> > +       printk("MDIO_PCS_EEE_ABLE = 0x%04x", val);
> >          if (val < 0)
> >                  return val;
> > 
> 
> For cubieboard:
> 
> MDIO_PCS_EEE_ABLE = 0x0000
> 
> qemu reports attempts to access unsupported registers.

MDIO is a serial bus with two lines, clock driven by the bus master
and data. There is a pull up on the data line, so if the device does
not respond to a read request, you get 0xffff. That value is all i've
ever seen a real PHY do when asked to read a register which does not
exist. So i would say QEMU could be better emulate this.

The code actually looks for the value 0xffff and then decides that EEE
is not supporting in the PHY.

The value of 0x0 is probably being interpreted as meaning EEE is
supported, but none of the link modes, 10Mbps, 100Mbps etc support
EEE. I would say it is then legitimate to read/write other EEE
registers, so long as those writes take into account that no link
modes are actually supported.

Reading the other messages in this thread, a bug has been found in the
patches. But i would also say QEMU could do better.

      Andrew
