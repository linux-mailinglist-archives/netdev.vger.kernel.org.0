Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6652EE65A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbhAGTqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbhAGTqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 14:46:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775CFC0612F4;
        Thu,  7 Jan 2021 11:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0VYbVRFaEHfXgTed8Qk8VILkIca2duBnZVrPZ6rhtgY=; b=QcfTC1dmOQtFnIDeaPka2FPCp
        QeuOZZSsD29kSsTaEalm46h5tQbLAz8TnRTlMkD3C4iG58QGzV+i1n1rzuzOkKdjttuPmXU5uL05t
        T6cyQnpuZ9AjDtnQV7qo7z9SlXYw5M47S1fB2zx3Daayb6TH9IDpj2bXssRrTOrRi57uX3LxId2tI
        0QuzPMnUlmDO1Ia+LsKRaeObSg7X5SZqrbMFN0XOjXFYNGlsbZpsJpDn/lSdQv61vV3/zo3vPf8vY
        ioXisI7rRBM62yKuNmjRlgfa3ObyihflutpmYC3U3VyFRmGOSIpdQg6PSSdTREnkDh/q9TmyQsW+M
        VCn6yYheA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45238)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kxbEE-0003An-Vn; Thu, 07 Jan 2021 19:45:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kxbED-0001QM-EM; Thu, 07 Jan 2021 19:45:49 +0000
Date:   Thu, 7 Jan 2021 19:45:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210107194549.GR1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-2-pali@kernel.org>
 <X/dCm1fK9jcjs4XT@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/dCm1fK9jcjs4XT@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 06:19:23PM +0100, Andrew Lunn wrote:
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

It is counter-intuitive, but as this is indicating whether we need to
switch to byte IO, if we're already doing byte IO, then we don't need
to switch.

> > -static void sfp_quirks_base(struct sfp *sfp, const struct sfp_eeprom_base *base)
> > -{
> > -	sfp->i2c_block_size = sfp_quirk_i2c_block_size(base);
> > +	for (i = 1; i < len; i += block_size) {
> > +		if (memchr_inv(buf + i, '\0', block_size - 1))
> > +			return false;
> > +	}
> 
> Is the loop needed?

I think you're not reading the code very well. It checks for bytes at
offset 1..blocksize-1, blocksize+1..2*blocksize-1, etc are zero. It
does _not_ check that byte 0 or the byte at N*blocksize is zero - these
bytes are skipped. In other words, the first byte of each transfer can
be any value. The other bytes of the _entire_ ID must be zero.

> I also wonder if on the last iteration of the loop you go passed the
> end of buf? Don't you need a min(block_size -1, len - i) or
> similar?

The ID is 64 bytes long, and is fixed. block_size could be a non-power
of two, but that is highly unlikely. block_size will never be larger
than 16 either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
