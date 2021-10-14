Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6A42E492
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 01:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhJNXKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 19:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhJNXKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 19:10:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9596EC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 16:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n0FYeTod2zxLiM1IA5S7I8D4oh1sLjcVaEOeVC2cOes=; b=JR51BiEgP+es1T5vK7DWdqQPzX
        PqNErUypPMsAWnT6o+bZTScJmXeQP3HYqyGx18hel8YeGKHavABEjoz072xAAwpZcVhPjfOowCd7N
        JFOGGJJYoe9/lnK/9ELQBnznkvZBjXByR92fHymod5sTz65anC9UtfHm6TztyzUrkKtHtmbDXYhEJ
        FXr6Hnmi4XTjRVKLZ/K9oWyi08vjKLn6JdsqhieoitCHmI6iYwFsH/wZne9Ee2ePKx96fJ/TNnfDP
        uzE9nvAvFncZIWnuHI9zueX9bjojmUQHyat6Vgch308qCS/IF0OBQTi/t04wFASHOi/UEYIItMyy7
        clXyRkQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55120)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mb9pt-0001nt-Da; Fri, 15 Oct 2021 00:08:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mb9pr-0002Xf-6F; Fri, 15 Oct 2021 00:08:27 +0100
Date:   Fri, 15 Oct 2021 00:08:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 01:50:36PM -0400, Sean Anderson wrote:
> On 10/14/21 12:34 PM, Russell King (Oracle) wrote:
> > You can find some patches that add the "supported_interfaces" masks
> > in git.armlinux.org.uk/linux-arm.git net-queue
> > 
> > and we could add to phylink_validate():
> > 
> > 	if (!phy_interface_empty(pl->config->supported_interfaces) &&
> > 	    !test_bit(state->interface, pl->config->supported_interfaces))
> > 		return -EINVAL;
> > 
> > which should go a long way to simplifying a lot of these validation
> > implementations.
> > 
> > Any thoughts on that?
> 
> IMO the actual issue here is PHY_INTERFACE_MODE_NA. Supporting this
> tends to add complexity to validate(), because we have a lot of code
> like
> 
> 	if (state->interface == PHY_INTERFACE_MODE_FOO) {
> 		if (we_support_foo())
> 			phylink_set(mask, Foo);
> 		else if (state->interface != PHY_INTERFACE_MODE_NA) {
> 			linkmode_zero(supported);
> 			return;
> 		}
> 	}
> 
> which gets even worse when we want to have different interfaces share
> logic.

There is always the option to use different operations structs if the
properties of the interfaces can be divided up in that way - and that
will probably be more efficient (not that the validate callback is a
performance critical path though.)

> IMO validate() could be much cleaner if we never called it with
> NA and instead did something like
> 
> 	if (state->interface == PHY_INTERFACE_MODE_NA) {
> 		unsigned long *original;
> 
> 		linkmode_copy(original, supported);
> 		for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
> 			if (test_bit(i, pl->config->supported_interfaces)) {
> 				unsigned long *iface_mode;
> 
> 				linkmode_copy(iface_mode, original);
> 				state->interface = i;
> 				pl->mac_ops->validate(pl->config, iface_mode, state);
> 				linkmode_or(supported, supported, iface_mode);
> 			}
> 		}
> 		state->interface = PHY_INTERFACE_MODE_NA;
> 	}
> 
> This of course can be done in addition to/instead of your above
> suggestion. I suggested something like this in v3 of this series, but it
> would be even better to do this on the phylink level.

In addition I think - I think we should use a non-empty
supported_interfaces as an indicator that we use the above, otherwise
we have to loop through all possible interface modes. That also
provides some encouragement to fill out the supported_interfaces
member.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
