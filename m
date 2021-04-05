Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB035488C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhDEWNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:13:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhDEWNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:13:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTXTS-00EzvS-Ed; Tue, 06 Apr 2021 00:13:34 +0200
Date:   Tue, 6 Apr 2021 00:13:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] of: net: fix of_get_mac_addr_nvmem() for PCI and DSA
 nodes
Message-ID: <YGuLjiozGIxsGYQy@lunn.ch>
References: <20210405164643.21130-1-michael@walle.cc>
 <20210405164643.21130-3-michael@walle.cc>
 <YGuCblk9vvmD0NiH@lunn.ch>
 <2d6eef78762562bcbb732179b32f0fd9@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d6eef78762562bcbb732179b32f0fd9@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 11:46:04PM +0200, Michael Walle wrote:
> Hi Andrew,
> 
> Am 2021-04-05 23:34, schrieb Andrew Lunn:
> > > -static int of_get_mac_addr_nvmem(struct device_node *np, u8 addr)
> > > +static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
> > >  {
> > >  	struct platform_device *pdev = of_find_device_by_node(np);
> > > +	struct nvmem_cell *cell;
> > > +	const void *mac;
> > > +	size_t len;
> > >  	int ret;
> > > 
> > > -	if (!pdev)
> > > -		return -ENODEV;
> > > +	/* Try lookup by device first, there might be a nvmem_cell_lookup
> > > +	 * associated with a given device.
> > > +	 */
> > > +	if (pdev) {
> > > +		ret = nvmem_get_mac_address(&pdev->dev, addr);
> > > +		put_device(&pdev->dev);
> > > +		return ret;
> > > +	}
> > 
> > Can you think of any odd corner case where nvmem_get_mac_address()
> > would fail, but of_nvmem_cell_get(np, "mac-address") would work?
> 
> You mean, it might make sense to just return here when
> nvmem_get_mac_address() will succeed and fall back to the
> of_nvmem_cell_get() in case of an error?

I've not read the documentation for nvmem_get_mac_address(). I was
thinking we might want to return real errors, and -EPROBE_DEFER. But
maybe with -ENODEV we should try of_nvmem_cell_get()?

But i'm not sure if there are any real use cases? The only thing i can
think of is if np points to something deeper inside the device tree
than what pdev does?

     Andrew
