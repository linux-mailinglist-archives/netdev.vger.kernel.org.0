Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA369D214
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 18:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjBTRYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 12:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjBTRYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 12:24:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1871BAD7;
        Mon, 20 Feb 2023 09:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MVStDAU/MhMJ8HyjTz1NdugFG2jwXeZFYaOaNP/80lE=; b=NxHpZtVZENUimreQoLfQPeDiQu
        kxZByjPd13DkqxmODnSYbrf7yDftgOJPRSQ/Ju0sdOGPcLIlIO6IKGVKjNL4aDZcPA680MuF+eqJ1
        lQ6somQo103xo89Tl64YOjJKTq3tF0CjMn0WZVs1pIyBeA96nGO98xFvyzA4tElv1VZBb/oJujEkI
        4M+GZkBi6eLayqIu/AM2U77ODWsP73FUFDtis7DygmuvUkK6CVgO5DX2AvqfHaQK63mh5NzxlpefE
        fm/ROiD+D64vPCMddHVmTiMHRZDuL5Yt80DUqqJCGHf3vso//mH/296pFha9/MynV1d6bmVtyD0gB
        +q05AM5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37710)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pU9tT-0004ps-Fz; Mon, 20 Feb 2023 17:24:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pU9tR-0001P2-F6; Mon, 20 Feb 2023 17:24:01 +0000
Date:   Mon, 20 Feb 2023 17:24:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] net: phy: do not force EEE support
Message-ID: <Y/OssaOmxIRDkrTr@shell.armlinux.org.uk>
References: <20230220135605.1136137-1-o.rempel@pengutronix.de>
 <20230220135605.1136137-4-o.rempel@pengutronix.de>
 <Y/OB9oeEn98y0u4o@shell.armlinux.org.uk>
 <20230220150720.GA19238@pengutronix.de>
 <Y/OWSjQ0m65fF5dk@lunn.ch>
 <20230220161339.GC19238@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220161339.GC19238@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 05:13:39PM +0100, Oleksij Rempel wrote:
> On Mon, Feb 20, 2023 at 04:48:26PM +0100, Andrew Lunn wrote:
> > > Hm.. ethtool do not provide enough information about expected behavior.
> > > Here is my expectation:
> > > - "ethtool --set-eee lan1 eee on" should enable EEE if it is disabled.
> > > - "ethtool --set-eee lan1 advertise 0x10" should change set of
> > >   advertised modes.
> > > - a sequence of "..advertise 0x10", "..eee on", "eee off" should restore
> > >   preconfigured advertise modes. advertising_eee instead of
> > >   supported_eee.
> > 
> > I agree ethtool is not very well documented. However, i would follow
> > what -s does. You can pass link modes you want to advertise, and you
> > can turn auto-neg on and off. Does turning auto-neg off and on again
> > reset the links modes which are advertised? I don't actually know, but
> > i think the behaviour should be consistent for link modes and EEE
> > modes.
> 
> Hm.. "ethtool -s lan1 autoneg on" will restore supported values. Even
> without switching it off.

Remember that -s is for the media capabilities, not EEE. There is
specific handling of the advertising mask in the userspace
ethtool.c::do_sset() but that doesn't exist for EEE, which merely
goes a ETHTOOL_GEEE, modifies the structure according to the arguments
given, and then calls ETHTOOL_SEEE. So:

# ethtool --set-eee lan1 eee on

will merely change eeecmd.eee_enabled to be set if it wasn't already,
but will not change eeecmd.advertised in any way - it'll contain
whatever it did before, which may or may not be zero.

This is in contrast to:

# ethtool -s lan1 autoneg on

which will set the advertisement to be the those that are supported.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
