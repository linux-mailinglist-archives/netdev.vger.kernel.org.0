Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70432DF23
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCEBdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:33:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCEBdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 20:33:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHzKm-009MZG-CQ; Fri, 05 Mar 2021 02:32:52 +0100
Date:   Fri, 5 Mar 2021 02:32:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V2 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YEGKRNLce9dzFkqI@lunn.ch>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-2-git-send-email-moshe@nvidia.com>
 <001101d71159$8721f4b0$9565de10$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101d71159$8721f4b0$9565de10$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > + * @length: Number of bytes to read.
> > + * @page: Page number to read from.
> > + * @bank: Page bank number to read from, if applicable by EEPROM spec.
> > + * @i2c_address: I2C address of a page. Value less than 0x7f expected.
> > Most
> > + *	EEPROMs use 0x50 or 0x51.
> 
> The standards are all very clear

Our experience so far is that manufactures of SFP modules like to
ignore the standard. And none of the standards seem to cover copper
modules, which have additional registers at some other page.
Admittedly, they cannot be mapped as pages, you need some proprietary
protocol to map MDIO onto I2C. But i would not be surprised to find
some SFP that maps the FLASH of the microcontroller onto an address,
which we might be able to read out using this API.

So i suggested we keep it generic, allowing access to these
proprietary registers at other addresses. And if there is nothing
there, you probably get a 1/2 page of 0xff.

> I suggest that 0xA0 and 0xA2 also be silently accepted, and
> translated to 0x50 and 0x51 respectively.

No, i don't like having two different values mean the same thing.  It
just leads to confusion. And userspace is going to be confused when it
asks for 0xA0 but the reply says it is for 0x50.

The Linux I2C subsystem does not magically map 8bit addresses in 7bit
addresses. We should follow what the Linux I2C subsystem does.

> > +
> > +	request->offset =
> > nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_OFFSET]);
> > +	request->length =
> > nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_LENGTH]);
> > +	if (request->length > ETH_MODULE_EEPROM_MAX_LEN)
> > +		return -EINVAL;	
> 
> This is really problematic as there are MANY different max values, within
> the specs

I agree. We should only be returning one 1/2 page as a maximum. So it
should be limited to 128 bytes. And offset+length should not go beyond
the end of a 1/2 page.

> > +	if (tb[ETHTOOL_A_EEPROM_DATA_PAGE])
> > +		request->page =
> > nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_PAGE]);
> > +	if (tb[ETHTOOL_A_EEPROM_DATA_BANK])
> > +		request->bank =
> > nla_get_u32(tb[ETHTOOL_A_EEPROM_DATA_BANK]);
> 
> Other checks:
> 
> Page and bank have to be between 0 and 255 (inclusive), they
> go into an 8 bit register in the eeprom.

Yes, a u8 would be a better type here.

     Andrew
