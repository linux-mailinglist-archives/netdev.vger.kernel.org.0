Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990E95046F4
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 09:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiDQHbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 03:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiDQHbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 03:31:04 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC7BD61
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 00:28:27 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id A48B630002421;
        Sun, 17 Apr 2022 09:28:25 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 97A665F05A; Sun, 17 Apr 2022 09:28:25 +0200 (CEST)
Date:   Sun, 17 Apr 2022 09:28:25 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] usbnet: Fix use-after-free on disconnect
Message-ID: <20220417072825.GA5737@wunner.de>
References: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
 <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
 <20220414105858.GA9106@wunner.de>
 <YlgAd2bHWAJwgd8q@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlgAd2bHWAJwgd8q@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 01:07:35PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 14, 2022 at 12:58:58PM +0200, Lukas Wunner wrote:
> > On Wed, Apr 13, 2022 at 08:59:48PM +0200, Oliver Neukum wrote:
> > > On 13.04.22 16:16, Lukas Wunner wrote:
> > > > --- a/drivers/net/usb/usbnet.c
> > > > +++ b/drivers/net/usb/usbnet.c
> > > > @@ -469,6 +469,9 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
> > > >   */
> > > >  void usbnet_defer_kevent (struct usbnet *dev, int work)
> > > >  {
> > > > +	if (dev->intf->condition == USB_INTERFACE_UNBINDING)
> > > > +		return;
> > > 
> > > But, no, you cannot do this. This is a very blatant layering violation.
> > > You cannot use states internal to usb core like that in a driver.
> > 
> > Why do you think it's internal?
> > 
> > enum usb_interface_condition is defined in include/linux/usb.h
> > for everyone to see and use.  If it was meant to be private,
> > I'd expect it to be marked as such or live in drivers/usb/core/usb.h.
> 
> Because we didn't think people would do crazy things like this.

I assume "crazy things" encompasses reading and writing intf->condition
without any locking or explicit memory barriers.  However many drivers
do that through the exported functions:

  usb_reset_device()
  usb_lock_device_for_reset()
  usb_driver_claim_interface()
  usb_driver_release_interface()

In any case, I've decided to pursue a different approach which fixes the
issue in core networking code rather than usbnet.  USB Ethernet may not
be the only culprit after all.  A replacement patch superseding this one
was just submitted:

https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de

Thanks,

Lukas
