Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51033453D6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCWA1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:27:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhCWA1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:27:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOUt5-00CUyo-7y; Tue, 23 Mar 2021 01:27:11 +0100
Date:   Tue, 23 Mar 2021 01:27:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFk13y19yMC0rr04@lunn.ch>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
 <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006801d71f47$a61f09b0$f25d1d10$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +#define ETH_MODULE_EEPROM_PAGE_LEN	256
> 
> Sorry to keep raising issues, but I think you want to make this constant
> 128.

Yes, i also think the KAPI should be limited to returning a maximum of
a 1/2 page per call.

> > +#define MODULE_EEPROM_MAX_OFFSET (257 *
> > ETH_MODULE_EEPROM_PAGE_LEN)
> 
> The device actually has 257 addressable chunks of 128 bytes each.  With
> ETH_MODULE_EEPROM_PAGE_LEN set to 256, your constant is 2X too big.
> 
> Note also, SFP devices (but not QSFP or CMIS) actually have another 256
> bytes available at 0x50, in addition to the full 257*128 at 0x51.  So SFP is
> actually 259*128 or (256 + 257 * 128).
> 
> Devices that don't support pages have much lower limits (256 bytes for
> QSFP/CMIS and 512 for SFP).  Some SFP only support 256 bytes.  Most devices
> will return nonsense for pages above 3.  So, this check is really only an
> absolute limit.  The SFP driver that takes this request will probably check
> against a more refined MAX length (eg modinfo->eeprom_len).
> 
> I suggest setting this constant to 259 * (ETH_MODULE_EEPROM_PAGE_LEN / 2).
> Let the driver refine it from there.

I don't even see a need for this. The offset should be within one 1/2
page, of one bank. So offset >= 0 and <= 127. Length is also > 0 and
<- 127. And offset+length is <= 127.

For the moment, please forget about backwards compatibility with the
IOCTL interface. Lets get a new clean KAPI and a new clean internal
API between the ethtool core and the drivers. Once we have that agreed
on, we can work on the various compatibility shims we need to work
between old and new APIs in various places.

      Andrew
