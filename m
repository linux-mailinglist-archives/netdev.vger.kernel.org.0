Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC472E9925
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhADPtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 10:49:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADPtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 10:49:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwS5t-00Fz01-18; Mon, 04 Jan 2021 16:48:29 +0100
Date:   Mon, 4 Jan 2021 16:48:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <X/M4zXd9a/EGK2UD@lunn.ch>
References: <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
 <20201127155637.GS2073444@lunn.ch>
 <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com>
 <X+tYamjmow0MfFxz@lunn.ch>
 <45a1b5c6-d348-cc62-681d-b2f257b578f9@nvidia.com>
 <X+yehiw/6DYUyPzy@lunn.ch>
 <3c4a5b4f-86bd-19df-c40c-db1452ac43b2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c4a5b4f-86bd-19df-c40c-db1452ac43b2@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 05:24:11PM +0200, Vladyslav Tarasiuk wrote:
> 
> On 30-Dec-20 17:36, Andrew Lunn wrote:
> > On Wed, Dec 30, 2020 at 03:55:02PM +0200, Vladyslav Tarasiuk wrote:
> > > On 29-Dec-20 18:25, Andrew Lunn wrote:
> > > > > Hi Andrew,
> > > > > 
> > > > > Following this conversation, I wrote some pseudocode checking if I'm on
> > > > > right path here.
> > > > > Please review:
> > > > > 
> > > > > struct eeprom_page {
> > > > >           u8 page_number;
> > > > >           u8 bank_number;
> > > > >           u16 offset;
> > > > >           u16 data_length;
> > > > >           u8 *data;
> > > > > }
> > > > I'm wondering about offset and data_length, in this context. I would
> > > > expect you always ask the kernel for the full page, not part of
> > > > it. Even when user space asks for just part of a page. That keeps you
> > > > cache management simpler.
> > > As far as I know, there may be bytes, which may change on read.
> > > For example, clear on read values in CMIS 4.0.
> > Ah, i did not know there were such bits. I will go read the spec. But
> > it should not really matter. If the SFP driver is interested in these
> > bits, it will have to intercept the read and act on the values.
> 
> But in case user requests a few bytes from a page with clear-on-read
> values, reading full page will clear all such bytesfrom user perspective
> even if they were not requested. Driver may intercept the read, but for
> user it will look like those bytes were not set.

Yes, O.K. Reading individual words does make sense.

> Without command line argument user will not be able to request a single
> A2h page, for example. He will see it only in some kind of general dump -
> with human-readable decoder usage or multiple page dump.
> 
> And same goes forpages on other i2c addresses. How to know what to dump,
> if user does not provide i2c address and there is no way to know what to
> request from proprietary SFPs?

So we should look at this from the perspective of use cases. Currently
we have:

ethtool -m|--dump-module-eeprom|--module-info devname [raw on|off] [hex on|off] [offset N] [length N]

If you use it without any of [raw on|off] [hex on|off] [offset N]
[length N] it decodes what it finds. As soon as you pass any of these
options, the decoding is disabled and is just dumps values, either raw
or hex.

I would say, i2c address as a parameter can be added, but again,
passing it disables decoding, is just dumps raw or hex.

When not passed, and decoding is enabled, the decoder should decide if
A2 is available based on what is finds in page 0, and ask for it.

We also need to clearly define what offset and length means in this
context. It has to be within a specific page if page, bank or i2c
address has been passed, unlike what it currently means which is
offset into the current blob returned by the kernel.

I also took a look at CMIS. It has interesting semantics for address
wrap around when doing multiple byte reads. A read which reaches 127
wraps around to 0. A read which reached 255 wraps around to 128. So
for the kernel API, we probably do not want to allow offset/length to
cause a wrap around. You can only read within the low 128 bytes, or
the upper 128 bytes.

   Andrew
