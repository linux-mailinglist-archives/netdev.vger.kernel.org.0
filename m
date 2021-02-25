Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B722632546F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhBYRPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhBYRPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 12:15:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AD8C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 09:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l034IP7En/rgYZsqho+XToNrOtyW41/Ju3yVOaJKoCA=; b=o4NbQmiM5ZVguuQraJjZ6F4e0
        1Uc2+A8OVxjrLbyRdyEzY674GqpAjT88VzNKI+6mjbMYwy9uszNQAX/fA+j/lycPUGnK1DIa0KaUC
        Lwx08wW9/Jkk+g+fTnbISIpXVQ4CluTQlYJ+1OlEkFmiuD64DYQNdP32g/BxLSAZ55Wdc5vumTQft
        qcLlOKEpceFQZPeh8vIDQyi0mjkH74fxeLgYFf1G22/IeWRCncaoWvAgbQzI6dDZHk27DKOWeEvYR
        jvqEoqgDanm4bMM1/PjV6lykAQcQEfxmFJ16EEAf1meR2hYlOdJ1drC1zdPb245C6aDmrJ35hussY
        KT3zaaeug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47092)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lFKDR-00013R-Dz; Thu, 25 Feb 2021 17:14:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lFKDP-0005A5-Vn; Thu, 25 Feb 2021 17:14:16 +0000
Date:   Thu, 25 Feb 2021 17:14:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net 6/6] net: enetc: force the RGMII speed and duplex
 instead of operating in inband mode
Message-ID: <20210225171415.GU1463@shell.armlinux.org.uk>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225121835.3864036-7-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 02:18:35PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ENETC port 0 MAC supports in-band status signaling coming from a PHY
> when operating in RGMII mode, and this feature is enabled by default.
> 
> It has been reported that RGMII is broken in fixed-link, and that is not
> surprising considering the fact that no PHY is attached to the MAC in
> that case, but a switch.
> 
> This brings us to the topic of the patch: the enetc driver should have
> not enabled the optional in-band status signaling for RGMII unconditionally,
> but should have forced the speed and duplex to what was resolved by
> phylink.
> 
> Note that phylink does not accept the RGMII modes as valid for in-band
> signaling, and these operate a bit differently than 1000base-x and SGMII
> (notably there is no clause 37 state machine so no ACK required from the
> MAC, instead the PHY sends extra code words on RXD[3:0] whenever it is
> not transmitting something else, so it should be safe to leave a PHY
> with this option unconditionally enabled even if we ignore it). The spec
> talks about this here:
> https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/138/RGMIIv1_5F00_3.pdf
> 
> Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>

Looks better, thanks.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> - Don't write to the MAC if speed and duplex did not change.
> - Don't update the speed with the MAC enabled.
> - Remove the logic for enabling in-band signaling in enetc_mac_config.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
