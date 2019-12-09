Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 888421172F3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLIRj5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Dec 2019 12:39:57 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57853 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLIRj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:39:57 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ieN0l-0006ad-55; Mon, 09 Dec 2019 18:39:55 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1ieN0i-0001wW-8t; Mon, 09 Dec 2019 18:39:52 +0100
Date:   Mon, 9 Dec 2019 18:39:52 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM i.MX6q: make sure PHY fixup for KSZ9031 is
 applied only on one board
Message-ID: <20191209173952.qnkzfrbixjgi2jfy@pengutronix.de>
References: <20191209084430.11107-1-o.rempel@pengutronix.de>
 <20191209171508.GD9099@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191209171508.GD9099@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:37:00 up 24 days,  8:55, 32 users,  load average: 0.03, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Dec 09, 2019 at 06:15:08PM +0100, Andrew Lunn wrote:
> Hi Oleksij
> 
> > This patch changes the MICREL KSZ9031 fixup, which was introduced for
> > the "Data Modul eDM-QMX6" board in following patch, to be only activated
> > for this specific board.
> 
> ...
> 
> >  static void __init imx6q_enet_phy_init(void)
> >  {
> > +	/* Warning: please do not extend this fixup list. This fixups are
> > +	 * applied even on boards where related PHY is not directly connected
> > +	 * to the ethernet controller. For example with switch in the middle.
> > +	 */
> >  	if (IS_BUILTIN(CONFIG_PHYLIB)) {
> >  		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> >  				ksz9021rn_phy_fixup);
> > -		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > -				ksz9031rn_phy_fixup);
> > +
> > +		if (of_machine_is_compatible("dmo,imx6q-edmqmx6"))
> > +			phy_register_fixup_for_uid(PHY_ID_KSZ9031,
> > +						   MICREL_PHY_ID_MASK,
> > +						   ksz9031rn_phy_fixup);
> > +
> >  		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> >  				ar8031_phy_fixup);
> >  		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> 
> What about the other 3 fixups? Are they not also equally broken,
> applied for all boards, not specific boards?

Yes. all of them are broken.
I just trying to not wake all wasp at one time. Most probably there are
board working by accident. So, it will be good to have at least separate
patches for each fixup.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
