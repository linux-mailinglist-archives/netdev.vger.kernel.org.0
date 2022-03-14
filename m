Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493074D8BEB
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiCNStD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiCNStA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:49:00 -0400
X-Greylist: delayed 311 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 11:47:47 PDT
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D444A2629
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:47:46 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 277B828003425;
        Mon, 14 Mar 2022 19:42:34 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 12E0223B872; Mon, 14 Mar 2022 19:42:34 +0100 (CET)
Date:   Mon, 14 Mar 2022 19:42:34 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220314184234.GA556@wunner.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310113820.GG15680@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[cc += Heiner Kallweit, Andrew Lunn]

On Thu, Mar 10, 2022 at 12:38:20PM +0100, Oleksij Rempel wrote:
> On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > unregister_netdev()")
> > is causing regressions.

I would like to see this reverted as well.  For obvious reasons,
the order in usbnet_disconnect() should be the inverse of
usbnet_probe().  Since 2c9d6c2b871d, that's no longer the case.


> > Rather than simply reverting it,
> > it seems to me that the call needs to be split. One in the old place
> > and one in the place you moved it to.

I disagree.  The commit message claims that the change is necessary
because phy_disconnect() fails if called with phydev->attached_dev == NULL.

I've just gone through the code to check that and the only thing that
caught my eye is an unconditional call to netif_testing_off(dev) in
phy_stop().  It seems to me that making that call conditional on
"if (dev)" would solve the issue.

That's a bug introduced by
   4a459bdc7472 ("net: phy: Put interface into oper testing during cable
                  test")
or 472115d9834c ("net: phy: stop PHY if needed when entering
                  phy_disconnect")
depending on how you look at it.

Thanks,

Lukas

> > Could you tell me which drivers you moved the call for?
> 
> I moved it for asix_devices.c:ax88772_unbind()
> 
> Probably smsc95xx.c:smsc95xx_unbind() has same issue.
