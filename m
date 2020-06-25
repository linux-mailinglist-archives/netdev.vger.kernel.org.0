Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DB120A368
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391034AbgFYQyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390448AbgFYQx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:53:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D49FC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 09:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g7uFiav7JlCVMlH3MgK1XSkiKMvTyEc1CFWTRCAKBW4=; b=M4/4QUAzAzfEJtzIuOE1ydXEs
        tijbKZcMJWkwh6NIFN5JkqPlKfciN8LuSxcqk2Akk7PioFWQd6pKefGDgVWljD4K677IvZPKitDb9
        yyJEU9jqqg62cBqY3dxPWPXsFI78y7doX7eM8xKXB0B/5QlV3ifq6xJhzqkbEDl9Ue3KFBgx2Mkos
        9B2qtVJG4Un9wi84tSgeWEuJQJbKvRZmbly/AtypTZE6c5IMwxoAOE+Mv8XB4O19XPZHOUpy/bHUO
        a11seMTaCRSPcQJMM5TJ780p6/jjJVr1OB02ChdwK12zU6CoTjf1s8cpp83D2r0a98WFhP7CbBpf5
        IffPggEmA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59646)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1joV8I-0004dG-5E; Thu, 25 Jun 2020 17:53:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1joV8H-00039T-JH; Thu, 25 Jun 2020 17:53:49 +0100
Date:   Thu, 25 Jun 2020 17:53:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 5/7] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200625165349.GI1551@shell.armlinux.org.uk>
References: <20200625152331.3784018-1-olteanv@gmail.com>
 <20200625152331.3784018-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625152331.3784018-6-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 06:23:29PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
> USXGMII) clears the resolved configuration from the PCS's
> auto-negotiation state machine.
> 
> But PHYLINK has a different interpretation of "AN restart". It assumes
> that this Linux system is capable of re-triggering an auto-negotiation
> sequence, something which is only possible with 1000Base-X and
> 2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
> USXGMII, there's an AN master and an AN slave, and it isn't so much of
> "auto-negotiation" as it is "PHY passing the resolved link state on to
> the MAC".

This is not "a different interpretation".

The LX2160A documentation for this PHY says:

  9             Restart Auto Negotiation
 Restart_Auto_N Self-clearing Read / Write command bit, set to '1' to
                restart an auto negotiation sequence. Set to '0'
		(Reset value) in normal operation mode. Note: Controls
		the Clause 37 1000Base-X Auto-negotiation.

It doesn't say anything about clearing anything for SGMII.

Also, the Cisco SGMII specification does not indicate that it is
possible to restart the "autonegotiation" - the PHY is the controlling
end of the SGMII link.  There is no clause in the SGMII specification
that indicates that changing the MAC's tx_config word to the PHY will
have any effect on the PHY once the data path has been established.

Finally, when a restart of negotiation is requested, and we have a PHY
attached in SGMII mode, we will talk to that PHY to cause a restart of
negotiation on the media side, which will implicitly cause the link
to drop and re-establish, causing the SGMII side to indicate link down
and subsequently re-establish according to the media side results.

So, please, lay off your phylink bashing in your commit messages.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
