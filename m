Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E93341042
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 23:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhCRWQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 18:16:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35668 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhCRWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 18:16:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lN0wC-00Bl9u-KK; Thu, 18 Mar 2021 23:16:16 +0100
Date:   Thu, 18 Mar 2021 23:16:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V3 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFPRMEa/CfZKsMyA@lunn.ch>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
 <1615828363-464-2-git-send-email-moshe@nvidia.com>
 <YFNPhvelhxg4+5Cl@lunn.ch>
 <3d8b9b2b-25e2-3812-2daf-09f1c5088eb0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8b9b2b-25e2-3812-2daf-09f1c5088eb0@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +Request contents:
> > > +
> > > +  =====================================  ======  ==========================
> > > +  ``ETHTOOL_A_EEPROM_DATA_HEADER``       nested  request header
> > > +  ``ETHTOOL_A_EEPROM_DATA_OFFSET``       u32     offset within a page
> > > +  ``ETHTOOL_A_EEPROM_DATA_LENGTH``       u32     amount of bytes to read
> > I wonder if offset and length should be u8. At most, we should only be
> > returning a 1/2 page, so 128 bytes. We don't need a u32.
> 
> 
> That's right when page is given, but user may have commands that
> used to work on the ioctl KAPI with offset higher than one page.

CMIS section 5.4.1 says:

  The slave maintains an internal current byte address counter
  containing the byte address accessed during the latest read or write
  operation incremented by one with roll-over as follows: The current
  byte address counter rolls-over after a read or write operation at
  the last byte address of the current 128-byte memory page (127 or
  255) to the first byte address (0 or 128) of the same 128-byte
  memory page.

This wrapping is somewhat unexpected. If the user access is for a read
starting at 120 and a length of 20, they get bytes 120-127 followed by
0-11. The user is more likely to be expecting 120-139.

We have two ways to address this:

1) We limit reads to a maximum of a 1/2 page, and the start and end
point needs to be within that 1/2 page.

2) We detect that the read is going to go across a 1/2 page boarder,
and perform two reads to the MAC driver, and glue the data back
together again in the ethtool core.

What i don't want is to leave the individual drivers to solve this,
because i expect some of them will get it wrong.

	Andrew
