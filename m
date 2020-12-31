Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994CA2E8155
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgLaRBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 12:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgLaRBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 12:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E3D120786;
        Thu, 31 Dec 2020 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609434042;
        bh=2Q5/jyDzLCoOHxjn8Vg8jD4DTmyCYtWu95co3RUHzSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YBZAjw2BCycDoFvK5sF5nxlRKhMLgEp7rAonCNjbeyllByiPv7bdypip/8XC3rxJ/
         5+nFJu+TVo9MtyR6vnr5zO0c5iAIb7bUliWZvZcKd0o0MV6IbhkQtr5qMprlYq3mZ2
         xQPrMD7eJIe9hoUhtGXb6dIwJPshQlh3PTMor9K2ziRgy16fTOft0utAzUSZdEEEeO
         o3ccxhMAk04H6qTXwptgCRkcvtAZa8laoW1HqZbqDVMIijleWQ08d1qbDa7nzRkRJr
         HIEwcwHIa7w7Oc0He+polkS4PNgh017AkmJnPyep0K8GqCqBp4Szk0nvMz2v13GcZg
         h6zuqcPny7SSw==
Received: by pali.im (Postfix)
        id C2D5EC35; Thu, 31 Dec 2020 18:00:39 +0100 (CET)
Date:   Thu, 31 Dec 2020 18:00:39 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201231170039.zkoa6mij3q3gt7c6@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ume1+wz8HXHEf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X+3ume1+wz8HXHEf@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 31 December 2020 16:30:33 Andrew Lunn wrote:
> On Thu, Dec 31, 2020 at 01:14:10PM +0100, Pali Rohár wrote:
> > On Wednesday 30 December 2020 19:09:58 Russell King - ARM Linux admin wrote:
> > > On Wed, Dec 30, 2020 at 06:43:07PM +0100, Pali Rohár wrote:
> > > > On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> > > > > Hi Pali
> > > > > 
> > > > > I have to agree with Russell here. I would rather have no diagnostics
> > > > > than untrustable diagnostics.
> > > > 
> > > > Ok!
> > > > 
> > > > So should we completely skip hwmon_device_register_with_info() call
> > > > if (i2c_block_size < 2) ?
> > > 
> > > I don't think that alone is sufficient - there's also the matter of
> > > ethtool -m which will dump that information as well, and we don't want
> > > to offer it to userspace in an unreliable form.
> > 
> > Any idea/preference how to disable access to these registers?
> 
> Page A0, byte 92:
> 
> "Diagnostic Monitoring Type" is a 1 byte field with 8 single bit
> indicators describing how diagnostic monitoring is implemented in the
> particular transceiver.
> 
> Note that if bit 6, address 92 is set indicating that digital
> diagnostic monitoring has been implemented, received power
> monitoring, transmitted power monitoring, bias current monitoring,
> supply voltage monitoring and temperature monitoring must all be
> implemented. Additionally, alarm and warning thresholds must be
> written as specified in this document at locations 00 to 55 on
> two-wire serial address 1010001X (A2h) (see Table 8-5).
> 
> Unfortunately, we cannot simply set sfp->id.ext.diagmon to false,
> because it can also be used to indicate power, software reading of
> TX_DISABLE, LOS, etc. These are all single bytes, so could be returned
> correctly, assuming they have been implemented according to the spec.
> 
> Looking at sfp_module_info(), adding a check for i2c_block_size < 2
> when determining what length to return. ethtool should do the right
> thing, know that the second page has not been returned to user space.

But if we limit length of eeprom then userspace would not be able to
access those TX_DISABLE, LOS and other bits from byte 110 at address A2.

Problematic two-byte values are in byte range 96-109 at address A2.
Therefore before byte 110.
