Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF826D558B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 02:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDDA3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 20:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDA3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 20:29:41 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9091F269A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 17:29:40 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pjUYI-0005NR-0w;
        Tue, 04 Apr 2023 02:29:34 +0200
Date:   Tue, 4 Apr 2023 01:29:31 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>
Cc:     John Crispin <john@phrozen.org>
Subject: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCtvaxY2d74XLK6F@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I've been dealing with several SGMII TP PHYs, some of them with support
for 2500Base-T, by switching to 2500Base-X interface mode (or by using
rate-adaptation to 2500Base-X or proprietary HiSGMII).

Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
rate-adaptation which is worth avoiding imho) I've noticed that the
current behavior of PHY and MAC drivers in the kernel is not as
consistent as I assumed it would be.

Background:
From Russell's comments and the experiments carried out together with
Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
understood that in general in-band autonegotiation should always be
switched off unless phylink_autoneg_inband(mode) returns true, ie.
mostly in case 'managed = "in-band-status";' is set in device tree,
which is generally the case for SFP cages or PHYs which are not
accessible via MDIO.

As of today this is what pcs-mtk-lynxi is now doing as this behavior
was inherited from the implementation previously found at
drivers/net/ethernet/mediatek/mtk_sgmii.c.

Hence, with MLO_AN_PHY we are expecting both MAC and PHY to *not* use
in-band autonegotiation. It is not needed as we have out-of-band status
using MDIO and maybe even an interrupt to communicate the link status
between the two. Correct so far?

I've also previously worked around this using Vladimir Oltean's patch
series introducing sync'ing and validation of in-band-an modes between
MAC and PHY -- however, this turns out to be overkill in case the
above is true and given there is a way to always switch off in-band-an
on both, the MAC and the PHY.

Or should PHY drivers setup in-band AN according to
pl->config->ovr_an_inband...?

Also note that the current behavior of PHY drivers is that consistent:

 * drivers/net/phy/mxl-gpy.c
   This goes through great lengths to switch on inband-an when initially
   coming up in SGMII mode, then switches is off when switching to
   2500Base-X mode and after that **never switches it on again**. This
   is obviously not correct and the driver can be greatly reduced if
   dropping all that (non-)broken logic.
   Would a patch like [1] this be acceptable?

 * drivers/net/phy/realtek.c
   The driver simply doesn't do anything about in-band-an and hence looks
   innocent. However, all RTL8226* and RTL8221* PHYs enable in-band-an
   by default in SGMII mode after reset. As many vendors use rate-adapter-
   mode, this only surfaces if not using the rate-adapter and having the
   MAC follow the PHY mode according to speed, as we do using [2] and [3].

   SGMII in-band AN can be switched off using a magic sequence carried
   out on undocumented registers [5].

   Would patches [2], [3], [4], [5] be acceptable?


Thank you for your advise!


Daniel

[1]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mediatek/patches-5.15/731-net-phy-hack-mxl-gpy-disable-sgmii-an.patch;hb=HEAD
[2]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch;hb=HEAD
[3]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/722-net-phy-realtek-support-switching-between-SGMII-and-.patch;hb=HEAD
[4]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch;hb=HEAD
[5]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch;hb=HEAD
