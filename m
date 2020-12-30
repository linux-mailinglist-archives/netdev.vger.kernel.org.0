Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1C2E7BAA
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgL3Rnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgL3Rnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:43:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A762220B;
        Wed, 30 Dec 2020 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609350189;
        bh=EHQNtl/1fFHFC+/tvysBm6vaGm66LzeIefZs3EPpRF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdG6zcLkU/qoadm3ym/yTLc2A8i7+hsKp0UsoI/MZgDWdPyK4ggXYQSjxM5Dwi0Zg
         A/wGyfwm4zTYsORRx6l+ZtgVvqSdXeCCZ2qwEflxDCjyXqKo2+XUrL5gIHx6GOd0G2
         fJP7zg1XJpsibZCWcBX1H5AvEtolaGIFY/8QyBIbwljKe2mvTEjSp6u2gqRNZtVYxm
         zhL0VV/xNA3y5HE+Woc98vSU9Qf3I3Vxy6TGf/o+kD7IT3s9b8xro4I7KkUoDHM6mY
         FonjEJOSKhWssthRoLv0pSqtB08OVM7LwUzYqHYPBCynPZrDechAqF7wv1XNOCIBYs
         GXUWoBXQJakgg==
Received: by pali.im (Postfix)
        id 6372F9F8; Wed, 30 Dec 2020 18:43:07 +0100 (CET)
Date:   Wed, 30 Dec 2020 18:43:07 +0100
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
Message-ID: <20201230174307.lvehswvj5q6c6vk3@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X+y1K21tp01GpvMy@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 18:13:15 Andrew Lunn wrote:
> On Wed, Dec 30, 2020 at 05:05:46PM +0000, Russell King - ARM Linux admin wrote:
> > On Wed, Dec 30, 2020 at 05:56:34PM +0100, Pali Rohár wrote:
> > > This change is really required for those Realtek chips. I thought that
> > > it is obvious that from *both* addresses 0x50 and 0x51 can be read only
> > > one byte at the same time. Reading 2 bytes (for be16 value) cannot be
> > > really done by one i2 transfer, it must be done in two.
> > 
> > Then these modules are even more broken than first throught, and
> > quite simply it is pointless supporting the diagnostics on them
> > because we can never read the values in an atomic way.
> > 
> > It's also a violation of the SFF-8472 that _requires_ multi-byte reads
> > to read these 16 byte values atomically. Reading them with individual
> > byte reads results in a non-atomic read, and the 16-bit value can not
> > be trusted to be correct.
> 
> Hi Pali
> 
> I have to agree with Russell here. I would rather have no diagnostics
> than untrustable diagnostics.

Ok!

So should we completely skip hwmon_device_register_with_info() call
if (i2c_block_size < 2) ?

> The only way this is going to be accepted is if the manufacture says
> that reading the first byte of a word snapshots the second byte as
> well in an atomic way and returns that snapshot on the second
> read. But i highly doubt that happens, given how bad these SFPs are.

I do not think that manufacture says something. I think that they even
do not know that their Realtek chips are completely broken.

I can imagine that vendor just says: it is working in our branded boxes
with SFP cages and if it does not work in your kernel then problem is
with your custom kernel and we do not care about 3rd parties.
