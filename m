Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9B6C8EBE
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 15:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCYOGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 10:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYOGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 10:06:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF24112BF6
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=p1PH+7g64HUJvwAOXYLjzY9dtldAbufioG+exBJz+2M=; b=fGAq34GCh4Rl3hWD8EvAqiz6yR
        nZ/cPr6qimv7x4/c6ZftefT5C7CiOxtRMyi895xabJmyMhBkfiwJWkE19zM14IBpPrBbrMj265lJn
        wQLypC/hOHKr8mV5dlr2laz7O36kIXCM88lNbd1T49cOBWC9nzLG0hWUUmSzY/RUBmxBtrsj7IolJ
        Q2AU3n4L4n4cDR1j7J81IqsdpELUzgKt0zEGXBqgWS0NP7eWCaOtKg/SfRvIjH941mapz7nWbFA7D
        vvljBFnnRlB4DIIWTgwKiaxnTuHKkrBMK+9oK2bDbPv4M2J+IMnuUnZMCsBCGMuszCVHek7j2iDsy
        NwHlplRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54994)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pg4Wp-0000Z9-NZ; Sat, 25 Mar 2023 14:05:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pg4Wl-0003V8-4f; Sat, 25 Mar 2023 14:05:51 +0000
Date:   Sat, 25 Mar 2023 14:05:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZB5YgPiZYwbf/G2u@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 02:12:16AM +0000, Daniel Golle wrote:
> Hi Russell,
> 
> On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> > Add a quirk for a copper SFP that identifies itself as "OEM"
> > "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> > at 2500base-X with the host without negotiation. Add a quirk to
> > enable the 2500base-X interface mode with 2500base-T support, and
> > disable autonegotiation.
> > 
> > Reported-by: Frank Wunderlich <frank-w@public-files.de>
> > Tested-by: Frank Wunderlich <frank-w@public-files.de>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> I've tried the same fix also with my 2500Base-T SFP module:
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 4223c9fa6902..c7a18a72d2c5 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] = {
>         SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
>         SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
>         SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
> +       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
>  };
> 
>  static size_t sfp_strlen(const char *str, size_t maxlen)

Thanks for testing.

> However, the results are a bit of a mixed bag. The link now does come up
> without having to manually disable autonegotiation. However, I see this
> new warning in the bootlog:
> [   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn 12154J6000864    dc 210606  
> ...
> [   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440

This will be the result of issuing an ethtool command, and phylink
doesn't know what to do with the advertising mask - which is saying:

   Autoneg, Fibre, Pause, AsymPause

In other words, there are no capabilities to be advertised, which is
invalid, and suggests user error. What ethtool command was being
issued?

> Also link speed and status appears unknown, though we do know at least
> that the speed is 2500M, and also full duplex will always be true for
> 2500Base-T:
> [   56.004937] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off

I would guess this is because we set the advertising mask to be 2.5bT
FD, and the PCS resolution (being all that we have) reports that we
got 2.5bX FD - and when we try to convert those to a speed/duplex we
fail because there appears to be no mutual ethtool capabilities that
can be agreed.

However, given that the media may be doing 2.5G, 1G or 100M with this
module, and we have no idea what the media may be doing because we
can't access the PHY, it seems to me that reporting "Unknown" speed
and "Unknown" duplex is entirely appropriate and correct, if a little
odd.

The solution... obviously is to have access to the PHY so we know
what the media is doing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
