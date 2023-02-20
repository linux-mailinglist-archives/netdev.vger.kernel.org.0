Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6569D21C
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 18:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBTR14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 12:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjBTR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 12:27:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8767A9E;
        Mon, 20 Feb 2023 09:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mH9qxb7B4hZl+BCpNQATHvkZRGXXJca/dRvdInumqhU=; b=DOREJOxVKRJwKQewFvC+r+sZ4c
        txotW69FqcEFswbtKY0kFgzMeiVRohgJwHgXcqTSde35o9jR4YV2RpkpSgKpJ8mwOcRUPzFqpxbZK
        FK/FqpCsFjlws8S9wp5Ev4FnHzHtgRwyUMGaNjC9hM2ggcGG8UrKLGLZ62o/ECsICjZKB0/jGD+gS
        em1SKN+F6/ERD/KgYnflch8gQghlqODiTzqAiYH2VEkHXPKMyMMrDETwD4lmafQLOafqFvC8pA504
        5d3RdxF93+uJRRLsulOGbZ292ZlEmJIJ/SiEkE4nmIB+W4SvtupRaPfcnI0q0/mVjwsLrt4pZOhmz
        7ZPVWgcA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42764)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU9x7-0004q5-8e; Mon, 20 Feb 2023 17:27:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU9x6-0001PA-JN; Mon, 20 Feb 2023 17:27:48 +0000
Date:   Mon, 20 Feb 2023 17:27:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OtlFxsjG6UDBfz@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
 <20230220150720.GA19238@pengutronix.de>
 <Y/OWSjQ0m65fF5dk@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/OWSjQ0m65fF5dk@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:48:26PM +0100, Andrew Lunn wrote:
> > Hm.. ethtool do not provide enough information about expected behavior.
> > Here is my expectation:
> > - "ethtool --set-eee lan1 eee on" should enable EEE if it is disabled.
> > - "ethtool --set-eee lan1 advertise 0x10" should change set of
> >   advertised modes.
> > - a sequence of "..advertise 0x10", "..eee on", "eee off" should restore
> >   preconfigured advertise modes. advertising_eee instead of
> >   supported_eee.
> 
> I agree ethtool is not very well documented. However, i would follow
> what -s does. You can pass link modes you want to advertise, and you
> can turn auto-neg on and off. Does turning auto-neg off and on again
> reset the links modes which are advertised? I don't actually know, but
> i think the behaviour should be consistent for link modes and EEE
> modes.

Hi Andrew,

I don't think we can do that without modifying the userspace ethtool -
see my other reply in this thread. It seems ethtool has some specific
handling for "autoneg on" without an advertising mask, where it
explicitly updates the advertising mask to have the link modes from
the supported mask. That logic doesn't exist for the EEE path, and
as the EEE path does a read-modify-according-to-arguments-write,
we can't even use "is the advertising mask zero" to implement it
kernel side (not that I think kernel side is the right place for
that policy.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
