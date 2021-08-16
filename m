Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17F93ED8AC
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhHPOHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhHPOHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 10:07:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F1F60BD3;
        Mon, 16 Aug 2021 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629122801;
        bh=f4neUyvqykSAwH4JGsrCA1+Yhs5mlliJgzU7NxJQOsI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=siQMDpPSZx48iW9/vJhDlmxPn6G96yI2de5+T2bAKDLP+Ff/YkgxpXhIis2E2ibB0
         6cZwmra8/AMYtEiSgEYFsMDL/5zQgqDTkg9q12DTgunEqg6Tv5eL+5r5syxSRL1kZo
         1S8IKcQAkfVFLDp7HOtBjPOP9a3FUb6GITFHSgQIclzwXKLIM1KNs9S/Avq/rnKqcg
         cTfJOrYtpIZh+zu3PsatfT+pQUufrDlsAUtlcchKzmqZxUdeaXxcBbjoY1jX04PxXB
         qymRj2itUtkRT6NMswkuDf7ymqVKf5c2cPlrYuJ61qts0RRKo2bp4Tlf6QkQ3U7Ti6
         dfOiG9ZYh5ZnQ==
Date:   Mon, 16 Aug 2021 07:06:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <20210816070640.2a7a6f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRjWXzYrQsGZiISc@carbon>
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
        <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRjWXzYrQsGZiISc@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Aug 2021 11:54:55 +0300 Petko Manolov wrote:
> > > @@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> > >  	data[2] = loopback ? 0x09 : 0x01;
> > >  
> > >  	memcpy(pegasus->eth_regs, data, sizeof(data));
> > > -	ret = set_registers(pegasus, EthCtrl0, 3, data);
> > > +	set_registers(pegasus, EthCtrl0, 3, data);
> > >  
> > >  	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
> > >  	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||  
> > 
> > This one is not added by the recent changes as I initially thought, 
> > the driver has always checked this return value. The recent changes 
> > did this:
> > 
> >         ret = set_registers(pegasus, EthCtrl0, 3, data);
> >  
> >         if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
> >             usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
> >             usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
> >                 u16 auxmode;
> > -               read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > +               ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > +               if (ret < 0)
> > +                       goto fail;
> >                 auxmode |= 4;
> >                 write_mii_word(pegasus, 0, 0x1b, &auxmode);
> >         }
> >  
> > +       return 0;
> > +fail:
> > +       netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> >         return ret;
> > }
> > 
> > now the return value of set_registeres() is ignored. 
> > 
> > Seems like  a better fix would be to bring back the error checking, 
> > why not?  
> 
> Mostly because for this particular adapter checking the read failure makes much
> more sense than write failure.

This is not an either-or choice.

> Checking the return value of set_register(s) is often usless because device's
> default register values are sane enough to get a working ethernet adapter even
> without much prodding.  There are exceptions, though, one of them being
> set_ethernet_addr().
> 
> You could read the discussing in the netdev ML, but the essence of it is that
> set_ethernet_addr() should not give up if set_register(s) fail.  Instead, the
> driver should assign a valid, even if random, MAC address.
> 
> It is much the same situation with enable_net_traffic() - it should continue
> regardless.  There are two options to resolve this: a) remove the error check
> altogether; b) do the check and print a debug message.  I prefer a), but i am
> also not strongly opposed to b).  Comments?

c) keep propagating the error like the driver used to.

I don't understand why that's not the most obvious option.

The driver used to propagate the errors from the set_registers() call
in enable_net_traffic() since the beginning of the git era. This is 
_not_ one of the error checking that you recently added.
