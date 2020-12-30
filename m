Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD882E7B96
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgL3Rcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:32:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgL3Rcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:32:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8D02222A;
        Wed, 30 Dec 2020 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609349515;
        bh=sbDpGc3jPUAugLxWf9wbwxtbNJRLn21ld/ZCiTC1yVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UQW75j0OsdsgoA8kO2E/oiEGB8UMQtTIq+4aVVP92AB63wvvJoiFn01cLrH4CMCwN
         4nJVs3GAstDy14OTPApn5fceJ55/9ngEX8ZIlD0mDvBz9P8bF6ig5oQ9LBW1AHgeVR
         ERhnS1qIsOojZfX7lpMzAYl0BWuL61H3SYfwTv2dRkNp0vERhPYu7VE+Ldp30ATRHn
         lsRBgYFPPorsFCsIPMMd1qp75lyN9MEm3caUSDBV49vxa2bfci+FfjL5dbLMAgYkaX
         FzmkGyJC6NRg7D1fg4RUbbiCPpaXDsNf+oTxj/l77Q+NEvNzr+NGXXGOR4Efjam2Ok
         yT1+/+zIAMNQQ==
Received: by pali.im (Postfix)
        id E1DC69F8; Wed, 30 Dec 2020 18:31:52 +0100 (CET)
Date:   Wed, 30 Dec 2020 18:31:52 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230173152.7dlq6t5erhspwhvs@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230170546.GU1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 17:05:46 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 05:56:34PM +0100, Pali Rohár wrote:
> > This change is really required for those Realtek chips. I thought that
> > it is obvious that from *both* addresses 0x50 and 0x51 can be read only
> > one byte at the same time. Reading 2 bytes (for be16 value) cannot be
> > really done by one i2 transfer, it must be done in two.
> 
> Then these modules are even more broken than first throught, and
> quite simply it is pointless supporting the diagnostics on them
> because we can never read the values in an atomic way.

They are broken in a way that neither holy water help them...

But from diagnostic 0x51 address we can read at least 8bit registers in
atomic way :-)

> It's also a violation of the SFF-8472 that _requires_ multi-byte reads
> to read these 16 byte values atomically. Reading them with individual
> byte reads results in a non-atomic read, and the 16-bit value can not
> be trusted to be correct.
> 
> That is really not optional, no matter what any manufacturer says - if
> they claim the SFP MSAs allows it, they're quite simply talking out of
> a donkey's backside and you should dispose of the module in biohazard
> packaging. :)
> 
> So no, I hadn't understood this from your emails, and as I say above,
> if this is the case, then we quite simply disable diagnostics on these
> modules since they are _highly_ noncompliant.

We have just two options:

Disable 2 (and more) bytes reads from 0x51 address and therefore disable
sfp_hwmon_read_sensor() function.

Or allow 2 bytes non-atomic reads and allow at least semi-correct values
for hwmon. I guess that upper 8bits would not change between two single
byte i2c transfers too much (when they are done immediately one by one).

But in any case we really need to set read operation for this eeprom to
one byte.
