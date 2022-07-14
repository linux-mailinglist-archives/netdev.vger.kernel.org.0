Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C3B5755FA
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbiGNTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiGNTos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:44:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88066BC27;
        Thu, 14 Jul 2022 12:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=juqdfawgY+mSOy4Q9xQHkJDUGz0LPzuu1htfB/1lskw=; b=nefOM4zVvJVlye2X2eOBPrTjOF
        M+tA7bm/BSfK8k3HugWHtepejg31y/x7X3Xv4igOK1f23iFTQb71LqJuZQ5pkAxiKlJCjP8dGOvEe
        yIrHeKA/ub+CP1rWS6VdjyPtFsi1GSDfCPb+un1VdGovhK59h0pKNQXagJQCv0dittjgzXB7A0EPF
        S/gyOybpAiHfo+a7IAwHL2O01YoDV/Z0Rs+HnsNjaVf+FxXaXJH4AagMpd2qA2R32Jw8cXVurCseK
        cZjBuDLr2ONA2lFMmxV7AZfxr7aiQ6DgDSGbr7QU30CibtI3jDhDigKR9DW2APaL+tPJGx7DSEIBs
        N7Hn3m3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33344)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oC4lN-0006G0-ED; Thu, 14 Jul 2022 20:44:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oC4lK-0006qv-Ou; Thu, 14 Jul 2022 20:44:38 +0100
Date:   Thu, 14 Jul 2022 20:44:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <YtByJhYpo5BzX4GV@shell.armlinux.org.uk>
References: <20220714010021.1786616-1-mw@semihalf.com>
 <YtAMw7Sp06Kiv9PK@shell.armlinux.org.uk>
 <CAPv3WKcxH=b01ikuUESczWeX8SJjc2fg3GjSCp7Q8p72uSt_og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKcxH=b01ikuUESczWeX8SJjc2fg3GjSCp7Q8p72uSt_og@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 07:18:57PM +0200, Marcin Wojtas wrote:
> Hi Russell,
> 
> czw., 14 lip 2022 o 14:32 Russell King (Oracle)
> <linux@armlinux.org.uk> napisał(a):
> >
> > On Thu, Jul 14, 2022 at 03:00:21AM +0200, Marcin Wojtas wrote:
> > > Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> > > stopped relying on SPEED_MAX constant and hardcoded speed settings
> > > for the switch ports and rely on phylink configuration.
> > >
> > > It turned out, however, that when the relevant code is called,
> > > the mac_capabilites of CPU/DSA port remain unset.
> > > mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> > > dsa_tree_setup_switches(), which precedes setting the caps in
> > > phylink_get_caps down in the chain of dsa_tree_setup_ports().
> > >
> > > As a result the mac_capabilites are 0 and the default speed for CPU/DSA
> > > port is 10M at the start. To fix that execute phylink_get_caps() callback
> > > which fills port's mac_capabilities before they are processed.
> > >
> > > Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> > > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> >
> > Please don't merge this - the plan is to submit the RFC series I sent on
> > Wednesday which deletes this code, and I'd rather not re-spin the series
> > and go through the testing again because someone else changed the code.
> 
> Thank for the heads-up. Are you planning to resend the series or
> willing to get it merged as-is? I have perhaps one comment, but I can
> apply it later as a part of fwnode_/device_ migration.
> 
> >
> > Marcin - please can you test with my RFC series, which can be found at:
> >
> > https://lore.kernel.org/all/Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk/
> >
> 
> The thing is my v2 of DSA fwnode_/device_ migration is tested and
> ready to send. There will be conflicts (rather easy) with your
> patchset - I volunteer to resolve it this way or another, depending on
> what lands first. I have 2 platforms to test it with + also ACPI case
> locally.
> 
> I'd like to make things as smooth as possible and make it before the
> upcoming merge window - please share your thoughts on this.

I've also been trying to get the mv88e6xxx PCS conversion in, but
it's been held up because there's a fundamental problem in DSA that
this series is addressing.

This series is addressing a faux pas on my part, where I had forgotten
that phylink doesn't get used in DSA unless firmware specifies a
fixed-link (or a PHY) - in other words when the firmware lacks a
description of the link.

So, what do we do...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
