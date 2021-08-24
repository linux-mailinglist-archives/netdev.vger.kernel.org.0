Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06713F5F8E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237674AbhHXNxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237682AbhHXNxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 09:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A9F5610CD;
        Tue, 24 Aug 2021 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629813184;
        bh=+4T1vLM9PhQsAxaQ6jazKQVIw0nS9eZIqMNctc3gUrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fR4iEXs2mTu7PR2gKdWPsb2OjcdcgJ4DPkwT9UITOK94OIgG14vsbXr1ruogjNUGN
         G754i55/2mQ0YoB0AbOauMRHVuvt0f30VMQQS6LXh8rEmm8rLTXx0DVHkDM5xPXAn6
         tFHtBd7gxg6SEt4GXLyqFf2wQRnsnnHttMmqedDhJNr+1YA7mclhGhJO/BGgUuNmyE
         uECCmsax5G2N3EsO76WZulXSyUpa22Dla/Lqv73F7j1W2Ek83HNAlpKvuuNQksSI3k
         JT/cwwLzswyjM2IqN0T0FHcdh6nYaBXmQ3lgyETln6EfRBCyHaF5Qj6v+62eunpUYj
         bjWOuwwGGUlfg==
Date:   Tue, 24 Aug 2021 06:53:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "John Efstathiades" <john.efstathiades@pebblebay.com>
Cc:     <linux-usb@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state
 transitions
Message-ID: <20210824065303.17f23421@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
        <20210823135229.36581-6-john.efstathiades@pebblebay.com>
        <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 09:59:12 +0100 John Efstathiades wrote:
> > > +/* Enabling link power state transitions will reduce power consumption
> > > + * when the link is idle. However, this can cause problems with some
> > > + * USB3 hubs resulting in erratic packet flow.
> > > + */
> > > +static bool enable_link_power_states;  
> > 
> > How is the user supposed to control this? Are similar issues not
> > addressed at the USB layer? There used to be a "no autosuspend"
> > flag that all netdev drivers set..  
> 
> The change is specific to U1 and U2 transitions initiated by the device
> itself and does not affect ability of the device to respond to
> host-initiated U1 and U2 transitions.
> 
> There is no user access to this. The driver would have to be recompiled to
> change the default. 

Do you expect the device-initiated transitions to always be causing
trouble or are there scenarios where they are useful?

Having to recompile the driver is a middle ground rarely chosen
upstream. If the code has very low chance of being useful - let's
remove it (git will hold it forever if needed); if there are reasonable
chances someone will find it useful it should be configurable from user
space, or preferably automatically enabled based on some device match
list.

> > Was linux-usb consulted? Adding the list to Cc.
>  
> No, they weren't, but the change was discussed with the driver maintainer at
> Microchip.

Good to hear manufacturer is advising but the Linux USB community 
may have it's own preferences / experience.

> > >  		/* reset MAC */
> > >  		ret = lan78xx_read_reg(dev, MAC_CR, &buf);
> > >  		if (unlikely(ret < 0))
> > > -			return -EIO;
> > > +			return ret;
> > >  		buf |= MAC_CR_RST_;
> > >  		ret = lan78xx_write_reg(dev, MAC_CR, buf);
> > >  		if (unlikely(ret < 0))
> > > -			return -EIO;
> > > +			return ret;  
> > 
> > Please split the ret code changes to a separate, earlier patch.  
> 
> There are ret code changes in later patches in this set. As a general, rule
> should ret code changes be put into their own patch?

It's case by case, in this patch the ret code changes and error
propagation does not seem to be inherently related to the main 
change the patch is making. I think you're referring to patch 7 -
similar comment indeed applies there. I'd recommend taking the 
error propagation changes into a separate patch (can be a single 
one for code extracted from both patches).
