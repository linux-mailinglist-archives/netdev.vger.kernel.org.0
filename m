Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74389500BB3
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 12:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiDNLB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiDNLBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:01:25 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FB27DE0C
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 03:59:00 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 525E62805D231;
        Thu, 14 Apr 2022 12:58:58 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 4869B562CA; Thu, 14 Apr 2022 12:58:58 +0200 (CEST)
Date:   Thu, 14 Apr 2022 12:58:58 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20220414105858.GA9106@wunner.de>
References: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
 <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 08:59:48PM +0200, Oliver Neukum wrote:
> On 13.04.22 16:16, Lukas Wunner wrote:
> > Jann Horn reports a use-after-free on disconnect of a USB Ethernet
> > (ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
> > different driver (ax88172a.c).
> 
> I see. Very good catch
> 
> > --- a/drivers/net/usb/usbnet.c
> > +++ b/drivers/net/usb/usbnet.c
> > @@ -469,6 +469,9 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
> >   */
> >  void usbnet_defer_kevent (struct usbnet *dev, int work)
> >  {
> > +	if (dev->intf->condition == USB_INTERFACE_UNBINDING)
> > +		return;
> 
> But, no, you cannot do this. This is a very blatant layering violation.
> You cannot use states internal to usb core like that in a driver.

Why do you think it's internal?

enum usb_interface_condition is defined in include/linux/usb.h
for everyone to see and use.  If it was meant to be private,
I'd expect it to be marked as such or live in drivers/usb/core/usb.h.

Adding Greg to clarify.


> I see two options.
> 1. A dedicated flag in usbnet (then please with the correct smp barriers)
> 2. You introduce an API to usb core to query this.

I'd definitely prefer option 2 as I'd hate to duplicate functionality.

What do you have in mind?  A simple accessor to return intf->condition
or something like usb_interface_unbinding() which returns a bool?

Thanks,

Lukas
