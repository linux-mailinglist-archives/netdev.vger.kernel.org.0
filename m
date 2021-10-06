Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54A8423E53
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbhJFNBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhJFNBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:01:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA18610A1;
        Wed,  6 Oct 2021 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633525167;
        bh=eyi95azOwLINnhnxMNVngWuAMMcQLrl9/uaXBM/omLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VsX3KTlazfshIJlT7btg+UOFXMMaw0txqMRHQmCoL9/HCVwMMXWsyXvrOo1N82QNn
         VgdzTdfjVhMsE3RF+6khe95wfi+ZAARX13Bh1ON6z/xgxKrQ0kNA69gBhqVjeX6OF+
         6eBUrUQs4uN42WKWuon0nNab6rYqovkS9GNB0Y0sxkb3uG+5vC75Q3ZYmALMlp6NUB
         wwU2GFfamm5/ysEJWGTDv5lvdW0dsbIQ+ArAAzjLbVLNpIKUIuDXDVzS8R4rD9MVyr
         L2WfDjNBrywYLMbPKXRWtJofDizsYx5ezrNUXm69HlM3gp8lPrqkMoOetttD1Om8L4
         i8CN8+dNNxJ5A==
Date:   Wed, 6 Oct 2021 05:59:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] device property: add a helper for loading
 netdev->dev_addr
Message-ID: <20211006055925.293a9816@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YV1TkRtiu/q2vm/S@kuha.fi.intel.com>
References: <20211005155321.2966828-1-kuba@kernel.org>
        <20211005155321.2966828-4-kuba@kernel.org>
        <YV1TkRtiu/q2vm/S@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 10:43:13 +0300 Heikki Krogerus wrote:
> On Tue, Oct 05, 2021 at 08:53:20AM -0700, Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> > 
> > There is a handful of drivers which pass netdev->dev_addr as
> > the destination buffer to device_get_mac_address(). Add a helper
> > which takes a dev pointer instead, so it can call an appropriate
> > helper.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/base/property.c  | 20 ++++++++++++++++++++
> >  include/linux/property.h |  2 ++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index 453918eb7390..1c8d4676addc 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -997,6 +997,26 @@ void *device_get_mac_address(struct device *dev, char *addr, int alen)
> >  }
> >  EXPORT_SYMBOL(device_get_mac_address);
> >  
> > +/**
> > + * device_get_ethdev_addr - Set netdev's MAC address from a given device
> > + * @dev:	Pointer to the device
> > + * @netdev:	Pointer to netdev to write the address to
> > + *
> > + * Wrapper around device_get_mac_address() which writes the address
> > + * directly to netdev->dev_addr.
> > + */
> > +void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev)
> > +{
> > +	u8 addr[ETH_ALEN];
> > +	void *ret;
> > +
> > +	ret = device_get_mac_address(dev, addr, ETH_ALEN);
> > +	if (ret)
> > +		eth_hw_addr_set(netdev, addr);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(device_get_ethdev_addr);  
> 
> Is there some reason why can't this be in net/ethernet/eth.c?
> 
> I would really prefer that we don't add any more subsystem specific
> functions into this file (drivers/base/property.c).

Sure.

> Shouldn't actually fwnode_get_mac_addr() and fwnode_get_mac_address()
> be moved to net/ethernet/eth.c as well?

Fine by me, there's already a handful of such helpers there. 

I'll add the refactoring I posted as a RFC to the series as well:

https://lore.kernel.org/all/20211006022444.3155482-1-kuba@kernel.org/
