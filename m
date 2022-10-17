Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF448600A86
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 11:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiJQJZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 05:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiJQJZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 05:25:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936B54BA7C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dBmzv6I83tg+bHyqn4f5A90tTtA80ihFycU+CHqRwA4=; b=N7dyEvJT9V3Q2xlDRpxllqqjAw
        i1GIfdzCZYYcdXiAHqQamjrYde6GBR+N/6RHg3+6I5rdGwB+SvItU9NgNVFk/u/O7bELIC1Lj/g6W
        rcdrfSSfdyLvx1nLqoOk3qKzrF67G54u75n6lxYQci2HqXzymZW9hvlEbec+tVki76WA3GDRvvSNj
        CTG//QjKHnr/eOI7UB1nuRyeMCVrMz7aSxzEkMJE6ni+qe7BByt9u6jXZg0I5eS2ee7cLjJYlB2Bx
        aGBpFQSpFkRoqLtqaSeDZzpTGmbkwGmrTR7cyj59LTvsOLXKxaDolZfjg0Hp3DuKHKmbDX68YjmYZ
        ptJ10fAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34750)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okMMg-00033L-AI; Mon, 17 Oct 2022 10:24:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okMMb-0008Qk-GT; Mon, 17 Oct 2022 10:24:49 +0100
Date:   Mon, 17 Oct 2022 10:24:49 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Multi-PHYs and multiple-ports bonding support
Message-ID: <Y00fYeZEcG/E3FPV@shell.armlinux.org.uk>
References: <20221017105100.0cb33490@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017105100.0cb33490@pc-8.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 10:51:00AM +0200, Maxime Chevallier wrote:
> 2) Changes in Phylink
> 
> This might be the tricky part, as we need to track several ports,
> possibly connected to different PHYs, to get their state. For now, I
> haven't prototyped any of this yet.

The problem is _way_ larger than phylink. It's a fundamental throughout
the net layer that there is one-PHY to one-MAC relationship. Phylink
just adopts this because it is the established norm, and trying to fix
it is rather rediculous without a use case.

See code such as the ethtool code, where the MAC and associated layers
are# entirely bypassed with all the PHY-accessing ethtool commands and
the commands are passed directly to phylib for the PHY registered
against the netdev.

We do have use cases though - consider a setup such as the mcbin with
the 3310 in SGMII mode on the fibre link and a copper PHY plugged in
with its own PHY - a stacked PHY situation (we don't support this
right now.) Which PHY should the MII ioctls, ethtool, and possibly the
PTP timestamp code be accessing with a copper SFP module plugged in?

This needs to be solved for your multi-PHY case, because you need to
deal with programming e.g. the link advertisement in both PHYs, not
just one - and with the above model, you have no choice which PHY gets
the call, it's always going to be the one registered with the netdev.

The point I'm making is that you're suggesting this is a phylink issue,
but it isn't, it's a generic networking layering bypass issue. If the
net code always forwarded the ethtool etc stuff to the MAC and let the
MAC make appropriate decisions about how these were handled, then we
would have a properly layered approach where each layer can decide
how a particular interface is implemented - to cope with situations
such as the one you describe.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
