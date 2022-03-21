Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DD84E2420
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346250AbiCUKTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiCUKTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:19:17 -0400
X-Greylist: delayed 922 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 03:17:52 PDT
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0BE97BB4
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:17:52 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 6D36F30000D3D;
        Mon, 21 Mar 2022 11:17:51 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 61EFA3FFD0C; Mon, 21 Mar 2022 11:17:51 +0100 (CET)
Date:   Mon, 21 Mar 2022 11:17:51 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220321101751.GB19177@wunner.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <a363a053-ee8b-c7d4-5ba5-57187d1b4651@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a363a053-ee8b-c7d4-5ba5-57187d1b4651@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 04:53:34PM +0100, Oliver Neukum wrote:
> On 15.03.22 14:28, Andrew Lunn wrote:
> >>>> It was linked to unregistered/freed
> >>>> netdev. This is why my patch changing the order to call phy_disconnect()
> >>>> first and then unregister_netdev().
> >>> Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
> >>>
> >>>   usbnet_disconnect()
> >>>     unregister_netdev()
> >>>     ax88772_unbind()
> >>>       phy_disconnect()
> >>>     free_netdev()
> >>>
> >>> Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> >>> net_device?
> > There are drivers which unregistering and then calling
> > phy_disconnect. In general that should be a valid pattern. But more
> > MAC drivers actually connect the PHY on open and disconnect it on
> > close. So it is less well used.
> 
> this is an interesting discussion, but what practical conclusion
> do we draw from it? Is it necessary to provide both orders
> of notifying the subdriver, or isn't it?

I see two possible solutions:

(1) The pattern of unregistering a net_device and then detaching the PHY
    is made legal by setting attached_dev = NULL on unregister and adding
    NULL pointer checks to phylib.  I'll wait for the phylib maintainers'
    comments whether they find that acceptable.

(2) Affected drivers (asix_devices.c, smsc95xx.c, possibly others) are
    amended with ->ndo_uninit() callbacks, which call phy_disconnect().
    That's basically your (Oliver's) idea to split usbnet ->unbind,
    but without actually having to split it.  (Just use the existing
    ->ndo_uninit.)

By the way: 2c9d6c2b871d caused breakage in smsc95xx.c which was
subsequently fixed by a049a30fc27c.  That in turn required another
fix, 0bf3885324a8.  Some of these code changes will have to be
rolled back or adjusted after reverting 2c9d6c2b871d.  It's a giant mess.
It's possible that more drivers saw fixes due to 2c9d6c2b871d,
I haven't checked that yet.

Oliver, why did you want to revert 2c9d6c2b871d, i.e. in which drivers
have your users reported breakage?  Do you have bugzilla links?

Thanks,

Lukas
