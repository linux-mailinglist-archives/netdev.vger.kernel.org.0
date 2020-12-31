Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432802E80EF
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgLaPbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 10:31:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLaPbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 10:31:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuzuL-00FFji-Bs; Thu, 31 Dec 2020 16:30:33 +0100
Date:   Thu, 31 Dec 2020 16:30:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X+3ume1+wz8HXHEf@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201231121410.2xlxtyqjelrlysd2@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 01:14:10PM +0100, Pali Rohár wrote:
> On Wednesday 30 December 2020 19:09:58 Russell King - ARM Linux admin wrote:
> > On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> > > On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > > > Hi Pali
> > > > 
> > > > I have to agree with Russell here. I would rather have no diagnostics
> > > > than untrustable diagnostics.
> > > 
> > > Ok!
> > > 
> > > So should we completely skip hwmon_device_register_with_info() call
> > > if (i2c_block_size < 2) ?
> > 
> > I don't think that alone is sufficient - there's also the matter of
> > ethtool -m which will dump that information as well, and we don't want
> > to offer it to userspace in an unreliable form.
> 
> Any idea/preference how to disable access to these registers?

Page A0, byte 92:

"Diagnostic Monitoring Type" is a 1 byte field with 8 single bit
indicators describing how diagnostic monitoring is implemented in the
particular transceiver.

Note that if bit 6, address 92 is set indicating that digital
diagnostic monitoring has been implemented, received power
monitoring, transmitted power monitoring, bias current monitoring,
supply voltage monitoring and temperature monitoring must all be
implemented. Additionally, alarm and warning thresholds must be
written as specified in this document at locations 00 to 55 on
two-wire serial address 1010001X (A2h) (see Table 8-5).

Unfortunately, we cannot simply set sfp->id.ext.diagmon to false,
because it can also be used to indicate power, software reading of
TX_DISABLE, LOS, etc. These are all single bytes, so could be returned
correctly, assuming they have been implemented according to the spec.

Looking at sfp_module_info(), adding a check for i2c_block_size < 2
when determining what length to return. ethtool should do the right
thing, know that the second page has not been returned to user space.

	Andrew
