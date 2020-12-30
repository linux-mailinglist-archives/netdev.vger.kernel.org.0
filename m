Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC722E7A65
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgL3Ph1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:37:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgL3Ph0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:37:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kudWg-00F36b-BJ; Wed, 30 Dec 2020 16:36:38 +0100
Date:   Wed, 30 Dec 2020 16:36:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <X+yehiw/6DYUyPzy@lunn.ch>
References: <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
 <20201127155637.GS2073444@lunn.ch>
 <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com>
 <X+tYamjmow0MfFxz@lunn.ch>
 <45a1b5c6-d348-cc62-681d-b2f257b578f9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45a1b5c6-d348-cc62-681d-b2f257b578f9@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 03:55:02PM +0200, Vladyslav Tarasiuk wrote:
> 
> On 29-Dec-20 18:25, Andrew Lunn wrote:
> > > Hi Andrew,
> > > 
> > > Following this conversation, I wrote some pseudocode checking if I'm on
> > > right path here.
> > > Please review:
> > > 
> > > struct eeprom_page {
> > >          u8 page_number;
> > >          u8 bank_number;
> > >          u16 offset;
> > >          u16 data_length;
> > >          u8 *data;
> > > }
> > I'm wondering about offset and data_length, in this context. I would
> > expect you always ask the kernel for the full page, not part of
> > it. Even when user space asks for just part of a page. That keeps you
> > cache management simpler.
> As far as I know, there may be bytes, which may change on read.
> For example, clear on read values in CMIS 4.0.

Ah, i did not know there were such bits. I will go read the spec. But
it should not really matter. If the SFP driver is interested in these
bits, it will have to intercept the read and act on the values.

> I wasn't aware of that. It complicates things a bit, should we add a
> parameter of i2c address? So in this case page 0 will be with i2c
> address A0h. And if user needs page 0 from i2c address A2h, he will
> specify it in command line.

Not on the command line. You should be able to determine from reading
page 0 at A0h is the diagnostics are at A2h or a page of A0h. That is
the whole point of this API, we decode the first page, and that tells
us what other pages should be available. So adding the i2c address to
the netlink message would be sensible. And i would not be too
surprised if there are SFPs with proprietary registers on other
addresses, which could be interesting to dump, if you can get access
to the needed datasheets.

   Andrew
