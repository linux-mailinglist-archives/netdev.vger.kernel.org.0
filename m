Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E472ED75F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbhAGTS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbhAGTS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:18:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4AB2343E;
        Thu,  7 Jan 2021 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610047067;
        bh=XVIYRfKGq0dcKADutiD7n/H1TcWOHzI9VAKr+sE32rY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HfmunOAliOvzGx+UzE9UAt/yg5xEYDoq88MYFHTjOa7JOrJu+kHdbuJYTKXFiCFw4
         YQ/Ut/hdbFmuMmGM1oKr2jOdVlndH6WGmODr8NKOLxe+NOt4jT6XpCLrwGtmR9pESB
         2fXDPFySS4UbI1y0tAu10mNsMoKtv/9OI5/We/fosWRyW1Tzh0GBhCPzPOszCM9G+V
         1VHZrMGRVfK3VepeVF++xYz7KGzV+eDiD8bS6XUv6HZRph+Uup+/9oKtD9OdvgmE4L
         2JdBnVA5lqWayKmg83Hb0Gwvf0HXdwABpFUMwjU8TCZRDZtSnQ32c5cqciebjyC8rH
         ziDffUxo4G8pA==
Received: by pali.im (Postfix)
        id D59E977B; Thu,  7 Jan 2021 20:17:44 +0100 (CET)
Date:   Thu, 7 Jan 2021 20:17:44 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107191744.jf76nse35vp6ask3@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/dCm1fK9jcjs4XT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/dCm1fK9jcjs4XT@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 07 January 2021 18:19:23 Andrew Lunn wrote:
> > +	if (sfp->i2c_block_size < 2) {
> > +		dev_info(sfp->dev, "skipping hwmon device registration "
> > +				   "due to broken EEPROM\n");
> > +		dev_info(sfp->dev, "diagnostic EEPROM area cannot be read "
> > +				   "atomically to guarantee data coherency\n");
> 
> Strings like this are the exception to the 80 character rule. People
> grep for them, and when they are split, they are harder to find.

Ok. I will fix it.

> > -static int sfp_quirk_i2c_block_size(const struct sfp_eeprom_base *base)
> > +static bool sfp_id_needs_byte_io(struct sfp *sfp, void *buf, size_t len)
> >  {
> > -	if (!memcmp(base->vendor_name, "VSOL            ", 16))
> > -		return 1;
> > -	if (!memcmp(base->vendor_name, "OEM             ", 16) &&
> > -	    !memcmp(base->vendor_pn,   "V2801F          ", 16))
> > -		return 1;
> > +	size_t i, block_size = sfp->i2c_block_size;
> >  
> > -	/* Some modules can't cope with long reads */
> > -	return 16;
> > -}
> > +	/* Already using byte IO */
> > +	if (block_size == 1)
> > +		return false;
> 
> This seems counter intuitive. We don't need byte IO because we are
> doing btye IO? Can we return True here?

I do not know this part was written by Russel.

Currently function is used in a way if sfp subsystem should switch to
byte IO. So if we are already using byte IO we are not going to do
switch and therefore false is returning.

At least this is how I understood why 'return false' is there.

> >  
> > -static void sfp_quirks_base(struct sfp *sfp, const struct sfp_eeprom_base *base)
> > -{
> > -	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
> > +	for (i = 1; i < len; i += block_size) {
> > +		if (memchr_inv(buf + i, '\0', block_size - 1))
> > +			return false;
> > +	}
> 
> Is the loop needed?

Originally I wanted to use just four memcmp() calls but Russel told me
that code should be generic (in case in future initial block size would
be changed, which is a good argument) and come up with this code with
for-loop.

So I think loop is needed.

> I also wonder if on the last iteration of the loop you go passed the
> end of buf? Don't you need a min(block_size -1, len - i) or
> similar?

You are right, if code is generic this needs to be fixed to prevent
reading reading undefined memory. I will replace it by proposed min(...)
call.
