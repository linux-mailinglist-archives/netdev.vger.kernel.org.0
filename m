Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CD28ADD8
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgJLFst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJLFsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:48:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F83C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 22:48:46 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kRqhN-0008SA-GX; Mon, 12 Oct 2020 07:48:41 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kRqhL-0002Ue-T7; Mon, 12 Oct 2020 07:48:39 +0200
Date:   Mon, 12 Oct 2020 07:48:39 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Bruno Thomsen <bruno.thomsen@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        David Jander <david@protonic.nl>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: PHY reset question
Message-ID: <20201012054839.n6do5ruxhbhc7h7n@pengutronix.de>
References: <20201006080424.GA6988@pengutronix.de>
 <CAOMZO5Ds7mm4dWdt_a+HU=V40zjp006JQJbozRCicx9yiqacgg@mail.gmail.com>
 <CAH+2xPD=CE+pk_cEC=cLv1nebBBg7X+xDpOFANf3rQ4V2+2Cvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH+2xPD=CE+pk_cEC=cLv1nebBBg7X+xDpOFANf3rQ4V2+2Cvw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:33:52 up 331 days, 20:52, 351 users,  load average: 0.00, 0.03,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

thank you for the feedback!

On Fri, Oct 09, 2020 at 04:25:49PM +0200, Bruno Thomsen wrote:
> Hi Fabio and Oleksij
> 
> Den ons. 7. okt. 2020 kl. 11.50 skrev Fabio Estevam <festevam@gmail.com>:
> >
> > Hi Oleksij,
> >
> > On Tue, Oct 6, 2020 at 5:05 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > >
> > > Hello PHY experts,
> > >
> > > Short version:
> > > what is the proper way to handle the PHY reset before identifying PHY?
> > >
> > > Long version:
> > > I stumbled over following issue:
> > > If PHY reset is registered within PHY node. Then, sometimes,  we will not be
> > > able to identify it (read PHY ID), because PHY is under reset.
> > >
> > > mdio {
> > >         compatible = "virtual,mdio-gpio";
> > >
> > >         [...]
> > >
> > >         /* Microchip KSZ8081 */
> > >         usbeth_phy: ethernet-phy@3 {
> > >                 reg = <0x3>;
> > >
> > >                 interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
> > >                 reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
> > >                 reset-assert-us = <500>;
> > >                 reset-deassert-us = <1000>;
> > >         };
> > >
> > >         [...]
> > > };
> > >
> > > On simple boards with one PHY per MDIO bus, it is easy to workaround by using
> > > phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
> > > using reset-gpios within PHY node (see above DT example).
> > >
> > > &fec {
> > >         [...]
> > >         phy-mode = "rmii";
> > >         phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
> > >         [...]
> >
> > I thought this has been fixed by Bruno's series:
> > https://www.spinics.net/lists/netdev/msg673611.html
> 
> Yes, that has fixed the Microchip/Micrel PHY ID auto detection
> issue. I have send a DTS patch v3 that makes use of the newly
> added device tree parameter:
> https://lkml.org/lkml/2020/9/23/595

This way is suitable only for boards with single PHY and single reset
line. But it is not scale on boards with multiple PHY and multiple reset
lines.

So far, it looks like using compatible like "ethernet-phy-idXXXX.XXXX"
is the only way to go.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
