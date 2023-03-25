Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569C86C8A28
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjCYCOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCYCOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:14:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F9166ED
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 19:14:23 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pftPq-0003TX-1f;
        Sat, 25 Mar 2023 03:13:58 +0100
Date:   Sat, 25 Mar 2023 02:12:16 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZB5YgPiZYwbf/G2u@makrotopia.org>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Mar 21, 2023 at 04:58:51PM +0000, Russell King (Oracle) wrote:
> Add a quirk for a copper SFP that identifies itself as "OEM"
> "SFP-2.5G-T". This module's PHY is inaccessible, and can only run
> at 2500base-X with the host without negotiation. Add a quirk to
> enable the 2500base-X interface mode with 2500base-T support, and
> disable autonegotiation.
> 
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

I've tried the same fix also with my 2500Base-T SFP module:
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4223c9fa6902..c7a18a72d2c5 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -424,6 +424,7 @@ static const struct sfp_quirk sfp_quirks[] = {
        SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
        SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
        SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
+       SFP_QUIRK_M("TP-LINK", "TL-SM410U", sfp_quirk_oem_2_5g),
 };

 static size_t sfp_strlen(const char *str, size_t maxlen)

However, the results are a bit of a mixed bag. The link now does come up
without having to manually disable autonegotiation. However, I see this
new warning in the bootlog:
[   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn 12154J6000864    dc 210606  
...
[   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440

Also link speed and status appears unknown, though we do know at least
that the speed is 2500M, and also full duplex will always be true for
2500Base-T:
[   56.004937] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off

root@OpenWrt:/# ethtool sfp2
Settings for sfp2:
        Supported ports: [ FIBRE ]
        Supported link modes:   2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: off
        Port: FIBRE
        PHYAD: 0
        Transceiver: internal
        Supports Wake-on: d
        Wake-on: d
        Link detected: yes

So it seems like this new quirk has brought also some new problems or at
least doesn't address them all.

> ---
>  drivers/net/phy/sfp.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 39e3095796d0..9c1fa0b1737f 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -360,6 +360,23 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
>  	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
>  }
>  
> +static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
> +				      unsigned long *modes,
> +				      unsigned long *interfaces)
> +{
> +	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
> +}
> +
> +static void sfp_quirk_oem_2_5g(const struct sfp_eeprom_id *id,
> +			       unsigned long *modes,
> +			       unsigned long *interfaces)
> +{
> +	/* Copper 2.5G SFP */
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, modes);
> +	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
> +	sfp_quirk_disable_autoneg(id, modes, interfaces);
> +}
> +
>  static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
>  				      unsigned long *modes,
>  				      unsigned long *interfaces)
> @@ -401,6 +418,7 @@ static const struct sfp_quirk sfp_quirks[] = {
>  	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
>  
>  	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
> +	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
>  	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
>  	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
>  	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
> -- 
> 2.30.2
> 
