Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14C92E7C11
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgL3TNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgL3TNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:13:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69053C061573;
        Wed, 30 Dec 2020 11:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=375e4YxYTm0FF5RfAlPr3QpppBYCWWAfCx/myiWk9aE=; b=R9tUBgUMK6SgV2DTDEFZbkSmw
        /+3mwuqVYJdpva4pZYDnPutmWlIj7BZArJBm/AxQExQtNSrG2bdyBHWk19HMKW8uxr01/KLZ5cJee
        3EX+zn+C7r7AHyNEP2y/bRv6LQi9m9kelncNUC1d2+XbtHuqbSZ3JeguecwezK0SRH9neP2895W3h
        Pnob3axSu9nkA8ZP0v/KD5tlx1VAQqQpORpLc45sxTc4sJrLOY4H0OlaOBvPrl/C+dijG9v7hVsuw
        Uomx9iPhJeWHvMapCzZHSJvJk+x/ADk1K5Yc58nTCtIDoQYQPwjdgArLnlpp6Z4968o00tQmaOcYp
        OrdOvZgkQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44928)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kugtk-0005tJ-Ty; Wed, 30 Dec 2020 19:12:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kugtk-0002R8-Ni; Wed, 30 Dec 2020 19:12:40 +0000
Date:   Wed, 30 Dec 2020 19:12:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: sfp: allow to use also SFP modules which are
 detected as SFF
Message-ID: <20201230191240.GX1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-3-pali@kernel.org>
 <20201230161151.GS1551@shell.armlinux.org.uk>
 <20201230170652.of3m226tidtunslm@pali>
 <20201230182707.4a8b13d0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230182707.4a8b13d0@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 06:27:07PM +0100, Marek Behún wrote:
> On Wed, 30 Dec 2020 18:06:52 +0100
> Pali Rohár <pali@kernel.org> wrote:
> 
> > 	if (!sfp->type->module_supported(&id) &&
> > 	    (memcmp(id.base.vendor_name, "UBNT            ", 16) ||
> > 	     memcmp(id.base.vendor_pn, "UF-INSTANT      ", 16)))
> 
> I would rather add a quirk member (bitfield) to the sfp structure and do
> something like this
> 
> if (!sfp->type->module_supported(&id) &&
>     !(sfp->quirks & SFP_QUIRK_BAD_PHYS_ID))
> 
> or maybe put this check into the module_supported method.

Sorry, definitely not. If you've ever looked at the SDHCI driver with
its multiple "quirks" bitfields, doing this is a recipe for creating
a very horrid hard to understand mess.

What you suggest just results in yet more complexity.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
