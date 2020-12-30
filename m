Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710F52E7B7F
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgL3ROB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:14:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgL3ROB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:14:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuf2B-00F3rd-FZ; Wed, 30 Dec 2020 18:13:15 +0100
Date:   Wed, 30 Dec 2020 18:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X+y1K21tp01GpvMy@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230170546.GU1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 05:05:46PM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 05:56:34PM +0100, Pali Rohár wrote:
> > This change is really required for those Realtek chips. I thought that
> > it is obvious that from *both* addresses 0x50 and 0x51 can be read only
> > one byte at the same time. Reading 2 bytes (for be16 value) cannot be
> > really done by one i2 transfer, it must be done in two.
> 
> Then these modules are even more broken than first throught, and
> quite simply it is pointless supporting the diagnostics on them
> because we can never read the values in an atomic way.
> 
> It's also a violation of the SFF-8472 that _requires_ multi-byte reads
> to read these 16 byte values atomically. Reading them with individual
> byte reads results in a non-atomic read, and the 16-bit value can not
> be trusted to be correct.

Hi Pali

I have to agree with Russell here. I would rather have no diagnostics
than untrustable diagnostics.

The only way this is going to be accepted is if the manufacture says
that reading the first byte of a word snapshots the second byte as
well in an atomic way and returns that snapshot on the second
read. But i highly doubt that happens, given how bad these SFPs are.

      Andrew
