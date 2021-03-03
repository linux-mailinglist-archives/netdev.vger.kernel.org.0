Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F332C4A9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450196AbhCDAP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1390506AbhCCWJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 17:09:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHZei-009DB1-3u; Wed, 03 Mar 2021 23:07:44 +0100
Date:   Wed, 3 Mar 2021 23:07:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/5] ethtool: Allow network drivers to dump
 arbitrary EEPROM data
Message-ID: <YEAIsEutk8udzEHb@lunn.ch>
References: <1614181274-28482-1-git-send-email-moshe@nvidia.com>
 <1614181274-28482-2-git-send-email-moshe@nvidia.com>
 <YDrnwFyvCFT8owgd@lunn.ch>
 <e1775d96-9ab6-4f7a-bb0b-63652bc53164@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1775d96-9ab6-4f7a-bb0b-63652bc53164@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > + * struct ethtool_eeprom_data - EEPROM dump from specified page
> > > + * @offset: Offset within the specified EEPROM page to begin read, in bytes.
> > > + * @length: Number of bytes to read. On successful return, number of bytes
> > > + *	actually read.
> > > + * @page: Page number to read from.
> > > + * @bank: Page bank number to read from, if applicable by EEPROM spec.
> > > + * @i2c_address: I2C address of a page. Zero indicates a driver should choose
> > > + *	by itself.
> > I don't particularly like the idea of the driver deciding what to
> > read. User space should really be passing 0x50 or 0x51 for the normal
> > case. And we need to make it clear what these addresses mean, since
> > they are often referred to as 0xA0 and 0xA2, due to addresses being
> > shifted one bit left and a r/w bit added.
> 
> I was thinking what address should I send from userspace by default?
> Should I send 0x50 or 0xA0 and at some point to do the shift?
> mlx5 uses 0x50 and 0x51, for example.

I would use the same meaning of i2c address as the i2c subsystem. So
addresses in the range of 0 to 0x7f. And please add a comment about
this here.

> > I also don't think the in place length should be modified. It would be
> > better to follow the use semantics of returning a negative value on
> > error, or a positive value for the length actually
> > read. ethtool_eeprom_data can then be passed as a const.
> But how would userspace know how much actually was read?

You are going to put the data into a netlink attribute. That attribute
has a length. So userspace gets to know that way.

> Should I fail the command if only part of a data requested was read?

That is not the usual POSIX semantics. I would return whatever is
available.

> > > @@ -1865,6 +1888,8 @@ static inline int ethtool_validate_duplex(__u8 duplex)
> > >   #define ETH_MODULE_SFF_8636_MAX_LEN     640
> > >   #define ETH_MODULE_SFF_8436_MAX_LEN     640
> > > +#define ETH_MODULE_EEPROM_MAX_LEN	640
> > I'm surprised such a high value is allowed. 128 seems more
> > appropriate, given the size of 1/2 pages.
> 
> This is done for backwards compatibility mechanism (last patch in the
> series)
> to work properly. I wanted to limit the length to 128 (or 256, maybe), but
> currently ethtool supports dumps of 640 bytes at most.
> I guess I can add another value like ETH_MODULE_EEPROM_PAGE_MAX_LEN 256 and
> if
> new ndo is available or page number is specified, use it for check.
> If ndo is not implemented, use 640 instead.

I need to look at the last patch. But for backwards compatibility with
the old IOCTL call, we might want the glue code to read each 1/2 page
individually, and combine them. That way we keep the new API uniform,
reads only 1/2 pages.

      Andrew
