Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3614D9415
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiCOFpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345017AbiCOFpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:45:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D99936E34
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:44:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nTzyW-0002KH-K4; Tue, 15 Mar 2022 06:44:04 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nTzyV-0007cT-3y; Tue, 15 Mar 2022 06:44:03 +0100
Date:   Tue, 15 Mar 2022 06:44:03 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220315054403.GA14588@pengutronix.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yi+UHF37rb0URSwb@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:26:56 up 94 days, 14:12, 65 users,  load average: 0.00, 0.06,
 0.08
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 08:14:36PM +0100, Andrew Lunn wrote:
> On Mon, Mar 14, 2022 at 07:42:34PM +0100, Lukas Wunner wrote:
> > [cc += Heiner Kallweit, Andrew Lunn]
> > 
> > On Thu, Mar 10, 2022 at 12:38:20PM +0100, Oleksij Rempel wrote:
> > > On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > > > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > > > unregister_netdev()")
> > > > is causing regressions.
> > 
> > I would like to see this reverted as well.  For obvious reasons,
> > the order in usbnet_disconnect() should be the inverse of
> > usbnet_probe().  Since 2c9d6c2b871d, that's no longer the case.
> > 
> > 
> > > > Rather than simply reverting it,
> > > > it seems to me that the call needs to be split. One in the old place
> > > > and one in the place you moved it to.
> > 
> > I disagree.  The commit message claims that the change is necessary
> > because phy_disconnect() fails if called with phydev->attached_dev == NULL.
> 
> The only place i see which sets phydev->attached_dev is
> phy_attach_direct(). So if phydev->attached_dev is NULL, the PHY has
> not been attached, and hence there is no need to call
> phy_disconnect().

phydev->attached_dev is not NULL. It was linked to unregistered/freed
netdev. This is why my patch changing the order to call phy_disconnect()
first and then unregister_netdev().

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
