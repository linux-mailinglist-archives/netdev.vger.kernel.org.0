Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B592E7B31
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgL3Q5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgL3Q5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 11:57:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32C78207B0;
        Wed, 30 Dec 2020 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609347397;
        bh=V+aLYAw5V+gjGYjHrXaqAJlB+BRURDmo1fvdNBpiWJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=da/HNLOONEY1gf7JXbXxcr3qula4LHwJSn+Y8sIHkj5MNVlXcqLMKCHBXt9Wrs0m0
         jIG5+1N1cOOUF9pBE72lLRBpw5MfHSvTBXdI+1asnQJVsaNuBdGz7cZozKtn1vMCZc
         1N7tIDCuJT1hjt+9zYVhh6y+G15dmbLHk04vyXnsdPcdHVDckAxdL3/EhcJM+kqkyP
         ba3LCM8YTHkqjGNiBG/RsEqEAJGqbayM1n/IjB0FOik1m0ULKVYFKA2QnWTPkKU6TB
         DoqdBQVOudJlVQUn/ZcC/Mh1twtiMwa0RITDo83d8aHso+4cEivzL1xAK6KQONMcjJ
         KJLZTKk5XkpGw==
Received: by pali.im (Postfix)
        id C4A4C9F8; Wed, 30 Dec 2020 17:56:34 +0100 (CET)
Date:   Wed, 30 Dec 2020 17:56:34 +0100
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
Message-ID: <20201230165634.c4ty3mw6djezuyq6@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230161036.GR1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 16:10:37 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 04:47:52PM +0100, Pali Rohár wrote:
> > Workaround for GPON SFP modules based on VSOL V2801F brand was added in
> > commit 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490
> > v2.0 workaround"). But it works only for ids explicitly added to the list.
> > As there are more rebraded VSOL V2801F modules and OEM vendors are putting
> > into vendor name random strings we cannot build workaround based on ids.
> > 
> > Moreover issue which that commit tried to workaround is generic not only to
> > VSOL based modules, but rather to all GPON modules based on Realtek RTL8672
> > and RTL9601C chips.
> > 
> > They can be found for example in following GPON modules:
> > * V-SOL V2801F
> > * C-Data FD511GX-RM0
> > * OPTON GP801R
> > * BAUDCOM BD-1234-SFM
> > * CPGOS03-0490 v2.0
> > * Ubiquiti U-Fiber Instant
> > * EXOT EGS1
> > 
> > Those Realtek chips have broken EEPROM emulator which for N-byte read
> > operation returns just one byte of EEPROM data followed by N-1 zeros.
> > 
> > So introduce a new function sfp_id_needs_byte_io() which detects SFP
> > modules with these Realtek chips which have broken EEPROM emulator based on
> > N-1 zeros and switch to 1 byte EEPROM reading operation which workaround
> > this issue.
> > 
> > This patch fixes reading EEPROM content from SFP modules based on Realtek
> > RTL8672 and RTL9601C chips.
> > 
> > Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
> > Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  drivers/net/phy/sfp.c | 78 ++++++++++++++++++++++++-------------------
> >  1 file changed, 44 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 91d74c1a920a..490e78a72dd6 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -336,19 +336,11 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
> >  			size_t len)
> >  {
> >  	struct i2c_msg msgs[2];
> > -	size_t block_size;
> > +	u8 bus_addr = a2 ? 0x51 : 0x50;
> > +	size_t block_size = sfp->i2c_block_size;
> >  	size_t this_len;
> > -	u8 bus_addr;
> >  	int ret;
> >  
> > -	if (a2) {
> > -		block_size = 16;
> > -		bus_addr = 0x51;
> > -	} else {
> > -		block_size = sfp->i2c_block_size;
> > -		bus_addr = 0x50;
> > -	}
> > -
> 
> NAK. You are undoing something that is definitely needed. The
> diagnostics must be read with sequential reads to be able to properly
> read the 16-bit values.

This change is really required for those Realtek chips. I thought that
it is obvious that from *both* addresses 0x50 and 0x51 can be read only
one byte at the same time. Reading 2 bytes (for be16 value) cannot be
really done by one i2 transfer, it must be done in two.

Therefore I had to "undo" this change as it is breaking support for all
those Realtek SFPs, including VSOL. That is why I also put Fixes tag
into commit message as it is really fixing reading for VSOL SFP from
address 0x51.

I understand that you want to read __be16 val in sfp_hwmon_read_sensor()
function via one i2c transfer to have "consistent" value, but it is
impossible on these Realtek chips.

I have already tested that sfp_hwmon_read_sensor() function see just
zero on second byte when is trying to use 2-byte read via one i2c
transfer.

When it use two i2c transfers, one for low 8bits and one for high 8bits
then reading is working.

> The rest of the patch is fine; it's a shame the entire thing has
> been spoilt by this extra addition that was not in the patch we had
> been discussing off-list.

Sorry for that. I really thought that it is obvious that this change
needs to be undone and read must always use byte transfer if we detect
these broken Realtek chips.
