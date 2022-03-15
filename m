Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3B4D9659
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346039AbiCOIeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345986AbiCOIeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:34:08 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863A84CD74
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:32:36 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id B67F7100D940E;
        Tue, 15 Mar 2022 09:32:34 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8D5C1226848; Tue, 15 Mar 2022 09:32:34 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:32:34 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220315083234.GA27883@wunner.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315054403.GA14588@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 06:44:03AM +0100, Oleksij Rempel wrote:
> On Mon, Mar 14, 2022 at 08:14:36PM +0100, Andrew Lunn wrote:
> > On Mon, Mar 14, 2022 at 07:42:34PM +0100, Lukas Wunner wrote:
> > > On Thu, Mar 10, 2022 at 12:38:20PM +0100, Oleksij Rempel wrote:
> > > > On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > > > > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > > > > unregister_netdev()") is causing regressions.
> > > > > Rather than simply reverting it,
> > > > > it seems to me that the call needs to be split. One in the old place
> > > > > and one in the place you moved it to.
> > > 
> > > I disagree.  The commit message claims that the change is necessary
> > > because phy_disconnect() fails if called with
> > > phydev->attached_dev == NULL.
> > 
> > The only place i see which sets phydev->attached_dev is
> > phy_attach_direct(). So if phydev->attached_dev is NULL, the PHY has
> > not been attached, and hence there is no need to call
> > phy_disconnect().
> 
> phydev->attached_dev is not NULL.

Right, I was mistaken, sorry.


> It was linked to unregistered/freed
> netdev. This is why my patch changing the order to call phy_disconnect()
> first and then unregister_netdev().

Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:

  usbnet_disconnect()
    unregister_netdev()
    ax88772_unbind()
      phy_disconnect()
    free_netdev()

Is it illegal to disconnect a PHY from an unregistered, but not yet freed
net_device?

Oleksij, the commit message of 2c9d6c2b871d says that disconnecting the
PHY "fails" in that situation.  Please elaborate what the failure looked
like.  Did you get a stacktrace?

Thanks,

Lukas
