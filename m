Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E9500BD0
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbiDNLKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiDNLKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:10:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC6374DC5;
        Thu, 14 Apr 2022 04:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1674D61234;
        Thu, 14 Apr 2022 11:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ECAC385A1;
        Thu, 14 Apr 2022 11:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649934460;
        bh=N8fZoRR/MqVYpakPiKIChLg8Ip1k00Jv+UvTYBl06I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rNajIpH8VoRQ10f7BGDubY5P7grv08Vg3rMts5/sImX3bWVT4Oo3+/BHm10DL9l6c
         3fok+bTNF1UyeF83fFuu3C1bYNNs+58dT6tMnoo0PWTZWHn1dqaCsnPBksYhKnM7B3
         UZSDNNmsJ4OzxajXtj+O58OKOtKEuqyAOVNanwRQ=
Date:   Thu, 14 Apr 2022 13:07:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
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
Message-ID: <YlgAd2bHWAJwgd8q@kroah.com>
References: <127121d9d933ebe3fc13f9f91cc33363d6a8a8ac.1649859147.git.lukas@wunner.de>
 <614e6498-3c3e-0104-591e-8ea296dfd887@suse.com>
 <20220414105858.GA9106@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414105858.GA9106@wunner.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 12:58:58PM +0200, Lukas Wunner wrote:
> On Wed, Apr 13, 2022 at 08:59:48PM +0200, Oliver Neukum wrote:
> > On 13.04.22 16:16, Lukas Wunner wrote:
> > > Jann Horn reports a use-after-free on disconnect of a USB Ethernet
> > > (ax88179_178a.c).  Oleksij Rempel has witnessed the same issue with a
> > > different driver (ax88172a.c).
> > 
> > I see. Very good catch
> > 
> > > --- a/drivers/net/usb/usbnet.c
> > > +++ b/drivers/net/usb/usbnet.c
> > > @@ -469,6 +469,9 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
> > >   */
> > >  void usbnet_defer_kevent (struct usbnet *dev, int work)
> > >  {
> > > +	if (dev->intf->condition == USB_INTERFACE_UNBINDING)
> > > +		return;
> > 
> > But, no, you cannot do this. This is a very blatant layering violation.
> > You cannot use states internal to usb core like that in a driver.
> 
> Why do you think it's internal?
> 
> enum usb_interface_condition is defined in include/linux/usb.h
> for everyone to see and use.  If it was meant to be private,
> I'd expect it to be marked as such or live in drivers/usb/core/usb.h.

Because we didn't think people would do crazy things like this.

> Adding Greg to clarify.

Oliver is right.  Also what prevents the condition from changing _right_
after you tested for it?

thanks,

greg k-h
