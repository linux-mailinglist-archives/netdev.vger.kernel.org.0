Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637A92E8043
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgLaNx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 08:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLaNx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 08:53:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 385B9223DB;
        Thu, 31 Dec 2020 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609422766;
        bh=6MagMP6DhH5VzRYAkJVqUwze9OoZb5askbPUn2mLudE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k85DfwWZZ8MOND7g633lMxsYpZtUNdL8aFLVZ4WOAp1ywt06ZsHRdtJ+lEw+WQKGT
         QGg7KwXxZKx3L1xJnunhI+YQONPSvZFYy4gf3yhMmIiAa2W+q/uDJCExkCWRjrDCFZ
         3sBodQzjIGZthjIY0P5GcduXH1zVIKmr3p3reNBO4qYf8YWOzQENx159QHFE4rg/Kj
         u3fXl3oBZULA2xfRTUQvgG92gEE5Wx/oOddKIIl2H43qczHVw20LoHzY1daXR/RBPp
         +2ZpEovWdWqOxRBnenq00j/oVk7bpt8ePhf/BjSCxB40BEHBpJVyGc9pQm0e9s0slQ
         iKn5VqghzWNHg==
Received: by pali.im (Postfix)
        id BDA50C35; Thu, 31 Dec 2020 14:52:43 +0100 (CET)
Date:   Thu, 31 Dec 2020 14:52:43 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: sfp: allow to use also SFP modules which are
 detected as SFF
Message-ID: <20201231135243.tvzkre2sddhdxfbq@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-3-pali@kernel.org>
 <20201230161151.GS1551@shell.armlinux.org.uk>
 <20201230170652.of3m226tidtunslm@pali>
 <20201230182707.4a8b13d0@kernel.org>
 <20201230191240.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230191240.GX1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 19:12:40 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 06:27:07PM +0100, Marek Behún wrote:
> > On Wed, 30 Dec 2020 18:06:52 +0100
> > Pali Rohár <pali@kernel.org> wrote:
> > 
> > > 	if (!sfp->type->module_supported(&id) &&
> > > 	    (memcmp(id.base.vendor_name, "UBNT            ", 16) ||
> > > 	     memcmp(id.base.vendor_pn, "UF-INSTANT      ", 16)))
> > 
> > I would rather add a quirk member (bitfield) to the sfp structure and do
> > something like this
> > 
> > if (!sfp->type->module_supported(&id) &&
> >     !(sfp->quirks & SFP_QUIRK_BAD_PHYS_ID))
> > 
> > or maybe put this check into the module_supported method.
> 
> Sorry, definitely not. If you've ever looked at the SDHCI driver with
> its multiple "quirks" bitfields, doing this is a recipe for creating
> a very horrid hard to understand mess.
> 
> What you suggest just results in yet more complexity.

Should I rather put this vendor name/pn check into the
sfp_module_supported() function?

static bool sfp_module_supported(const struct sfp_eeprom_id *id)
{
	if (id->base.phys_id == SFF8024_ID_SFP &&
	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP)
		return true;

	if (id->base.phys_id == SFF8024_ID_SFF_8472 &&
	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP &&
	    !memcmp(id->base.vendor_name, "UBNT            ", 16) &&
	    !memcmp(id->base.vendor_pn, "UF-INSTANT      ", 16))
		return true;

	return false;
}
