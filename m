Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11151209C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239930AbiD0PmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbiD0PmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:42:04 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95722AC50;
        Wed, 27 Apr 2022 08:38:52 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 8270E3000034F;
        Wed, 27 Apr 2022 17:38:51 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 7700B118753; Wed, 27 Apr 2022 17:38:51 +0200 (CEST)
Date:   Wed, 27 Apr 2022 17:38:51 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
Message-ID: <20220427153851.GA15329@wunner.de>
References: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
 <YmlgQhauzZ/tkX/v@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmlgQhauzZ/tkX/v@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 05:24:50PM +0200, Andrew Lunn wrote:
> On Wed, Apr 27, 2022 at 08:41:49AM +0200, Lukas Wunner wrote:
> > Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
> > smsc95xx_resume() to call phy_init_hw().  That function waits for the
> > device to runtime resume even though it is placed in the runtime resume
> > path, causing a deadlock.
> 
> You have looked at this code, tried a few different things, so this is
> probably a dumb question.
> 
> Do you actually need to call phy_init_hw()?
> 
> mdio_bus_phy_resume() will call phy_init_hw(). So long as you first
> resume the MAC and then the PHY, shouldn't this just work?

mdio_bus_phy_resume() is only called for system sleep.  But this is about
*runtime* PM.

mdio_bus_phy_pm_ops does not define runtime PM callbacks.  So runtime PM
is disabled on PHYs, no callback is invoked for them when the MAC runtime
suspends, hence the onus is on the MAC to runtime suspend the PHY (which
is a child of the MAC).  Same on runtime resume.

Let's say I enable runtime PM on the PHY and use pm_runtime_force_suspend()
to suspend the PHY from the MAC's ->runtime_suspend callback.  At that
point the MAC already has status RPM_SUSPENDING.  Boom, deadlock.

The runtime PM core lacks the capability to declare that children should
be force runtime suspended before a device can runtime suspend, that's
the problem.

Thanks,

Lukas
