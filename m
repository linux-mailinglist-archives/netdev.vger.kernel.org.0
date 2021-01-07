Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3212ED558
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbhAGRUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:20:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbhAGRUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:20:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxYwV-00GiTn-Iu; Thu, 07 Jan 2021 18:19:23 +0100
Date:   Thu, 7 Jan 2021 18:19:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <X/dCm1fK9jcjs4XT@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106153749.6748-2-pali@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (sfp->i2c_block_size < 2) {
> +		dev_info(sfp->dev, "skipping hwmon device registration "
> +				   "due to broken EEPROM\n");
> +		dev_info(sfp->dev, "diagnostic EEPROM area cannot be read "
> +				   "atomically to guarantee data coherency\n");

Strings like this are the exception to the 80 character rule. People
grep for them, and when they are split, they are harder to find.

> -static int sfp_quirk_i2c_block_size(const struct sfp_eeprom_base *base)
> +static bool sfp_id_needs_byte_io(struct sfp *sfp, void *buf, size_t len)
>  {
> -	if (!memcmp(base->vendor_name, "VSOL            ", 16))
> -		return 1;
> -	if (!memcmp(base->vendor_name, "OEM             ", 16) &&
> -	    !memcmp(base->vendor_pn,   "V2801F          ", 16))
> -		return 1;
> +	size_t i, block_size = sfp->i2c_block_size;
>  
> -	/* Some modules can't cope with long reads */
> -	return 16;
> -}
> +	/* Already using byte IO */
> +	if (block_size == 1)
> +		return false;

This seems counter intuitive. We don't need byte IO because we are
doing btye IO? Can we return True here?

>  
> -static void sfp_quirks_base(struct sfp *sfp, const struct sfp_eeprom_base *base)
> -{
> -	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
> +	for (i = 1; i < len; i += block_size) {
> +		if (memchr_inv(buf + i, '\0', block_size - 1))
> +			return false;
> +	}

Is the loop needed?

I also wonder if on the last iteration of the loop you go passed the
end of buf? Don't you need a min(block_size -1, len - i) or
similar?

> -	/* Some modules (CarlitoxxPro CPGOS03-0490) do not support multibyte
> -	 * reads from the EEPROM, so start by reading the base identifying
> -	 * information one byte at a time.
> -	 */
> -	sfp->i2c_block_size = 1;
> +	sfp->i2c_block_size = 16;

Did we loose the comment:

/* Some modules (Nokia 3FE46541AA) lock up if byte 0x51 is read as a
 * single read. Switch back to reading 16 byte blocks ...

That explains why 16 is used. Given how broken stuff is and the number
of workaround we need, we should try to document as much as we cam, so
we don't break stuff when adding more workarounds.

     Andrew
