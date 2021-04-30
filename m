Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6386936F65F
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 09:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhD3H1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 03:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhD3H1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 03:27:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E60C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 00:26:15 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lcNXO-00024H-S6; Fri, 30 Apr 2021 09:26:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lcNXN-0003hA-6G; Fri, 30 Apr 2021 09:26:09 +0200
Date:   Fri, 30 Apr 2021 09:26:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v3 3/6] net: add generic selftest support
Message-ID: <20210430072609.GA6711@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <20210419130106.6707-4-o.rempel@pengutronix.de>
 <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdW+cX=vsZg2MyBOM+6Akp-nRQ0QrU=2XSiegFhHNA+jVg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:20:01 up 60 days, 16:55, 117 users,  load average: 0.30, 0.35,
 0.31
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Fri, Apr 30, 2021 at 08:45:05AM +0200, Geert Uytterhoeven wrote:
> Hi Oleksij,
> 
> On Mon, Apr 19, 2021 at 3:13 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > Port some parts of the stmmac selftest and reuse it as basic generic selftest
> > library. This patch was tested with following combinations:
> > - iMX6DL FEC -> AT8035
> > - iMX6DL FEC -> SJA1105Q switch -> KSZ8081
> > - iMX6DL FEC -> SJA1105Q switch -> KSZ9031
> > - AR9331 ag71xx -> AR9331 PHY
> > - AR9331 ag71xx -> AR9331 switch -> AR9331 PHY
> >
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> Thanks for your patch, which is now commit 3e1e58d64c3d0a67 ("net: add
> generic selftest support") upstream.
>
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -429,6 +429,10 @@ config GRO_CELLS
> >  config SOCK_VALIDATE_XMIT
> >         bool
> >
> > +config NET_SELFTESTS
> > +       def_tristate PHYLIB
> 
> Why does this default to enabled if PHYLIB=y?
> Usually we allow the user to make selftests modular, independent of the
> feature under test, but I may misunderstand the purpose of this test.
> 
> Thanks for your clarification!

There is nothing against making optional. Should I do it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
