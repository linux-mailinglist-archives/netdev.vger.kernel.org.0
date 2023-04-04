Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3796D5BA2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDDJOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjDDJOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:14:16 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73411FF2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:14:13 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pjcjv-0000bf-1Q;
        Tue, 04 Apr 2023 11:14:07 +0200
Date:   Tue, 4 Apr 2023 10:13:59 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCvqJAVjOdogEZKD@makrotopia.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <a0570b00-669f-120d-2700-a97317466727@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0570b00-669f-120d-2700-a97317466727@gmail.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:31:12AM +0200, Heiner Kallweit wrote:
> On 04.04.2023 02:29, Daniel Golle wrote:
> > Hi!
> > 
> > I've been dealing with several SGMII TP PHYs, some of them with support
> > for 2500Base-T, by switching to 2500Base-X interface mode (or by using
> > rate-adaptation to 2500Base-X or proprietary HiSGMII).
> > 
> > Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
> > rate-adaptation which is worth avoiding imho) I've noticed that the
> > current behavior of PHY and MAC drivers in the kernel is not as
> > consistent as I assumed it would be.
> > 
> > Background:
> >>From Russell's comments and the experiments carried out together with
> > Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
> > understood that in general in-band autonegotiation should always be
> > switched off unless phylink_autoneg_inband(mode) returns true, ie.
> > mostly in case 'managed = "in-band-status";' is set in device tree,
> > which is generally the case for SFP cages or PHYs which are not
> > accessible via MDIO.
> > 
> > As of today this is what pcs-mtk-lynxi is now doing as this behavior
> > was inherited from the implementation previously found at
> > drivers/net/ethernet/mediatek/mtk_sgmii.c.
> > 
> > Hence, with MLO_AN_PHY we are expecting both MAC and PHY to *not* use
> > in-band autonegotiation. It is not needed as we have out-of-band status
> > using MDIO and maybe even an interrupt to communicate the link status
> > between the two. Correct so far?
> > 
> > I've also previously worked around this using Vladimir Oltean's patch
> > series introducing sync'ing and validation of in-band-an modes between
> > MAC and PHY -- however, this turns out to be overkill in case the
> > above is true and given there is a way to always switch off in-band-an
> > on both, the MAC and the PHY.
> > 
> > Or should PHY drivers setup in-band AN according to
> > pl->config->ovr_an_inband...?
> > 
> > Also note that the current behavior of PHY drivers is that consistent:
> > 
> >  * drivers/net/phy/mxl-gpy.c
> >    This goes through great lengths to switch on inband-an when initially
> >    coming up in SGMII mode, then switches is off when switching to
> >    2500Base-X mode and after that **never switches it on again**. This
> >    is obviously not correct and the driver can be greatly reduced if
> >    dropping all that (non-)broken logic.
> >    Would a patch like [1] this be acceptable?
> > 
> >  * drivers/net/phy/realtek.c
> >    The driver simply doesn't do anything about in-band-an and hence looks
> >    innocent. However, all RTL8226* and RTL8221* PHYs enable in-band-an
> >    by default in SGMII mode after reset. As many vendors use rate-adapter-
> >    mode, this only surfaces if not using the rate-adapter and having the
> >    MAC follow the PHY mode according to speed, as we do using [2] and [3].
> > 
> These PHY's are supported as internal PHY's in RTL8125 MAC/PHY chips
> where the MAC/PHY communication is handled chip-internally.
> Other use cases are not officially supported (yet), also due to lack of
> public datasheets.

The PHYs I've been encountering in the wild are those which were added by
74d155be2677a ("net: phy: realtek: Add support for RTL8221B-CG series")

They are independently packaged ICs. The relevant datasheets are
not public, but do provide documentation of some but not all registers
of those PHYs.

> 
> >    SGMII in-band AN can be switched off using a magic sequence carried
> >    out on undocumented registers [5].
> > 
> >    Would patches [2], [3], [4], [5] be acceptable?
> > 
> Ideas from the patches can be re-used. Some patches itself are not ready
> for mainline (replace magic numbers with proper constants (as far as
> documented by Realtek), inappropriate use of phy_modify_mmd_changed,
> read_status() being wrong place for updating interface mode).

Unfortunately the registers used to switch off rate-adapter-mode and
also to switch off (Hi)SGMII in-band autonegotation are entirely
undocumented even in the non-public datasheet.
They read/write/read-poll sequences supposedly appear in a document
called "SERDES Mode Setting Flow Application Note" which also doesn't
explain the meaning of the registers and their bits.

Where is updating the interface mode supposed to happen?

I was looking at drivers/net/phy/mxl-gpy.c which calls its
gpy_update_interface() function also from gpy_read_status(). If that is
wrong it should probably be fixed in mxl-gpy.c as well...

> 
> > 
> > Thank you for your advise!
> > 
> > 
> > Daniel
> > 
> > [1]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mediatek/patches-5.15/731-net-phy-hack-mxl-gpy-disable-sgmii-an.patch;hb=HEAD
> > [2]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch;hb=HEAD
> > [3]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/722-net-phy-realtek-support-switching-between-SGMII-and-.patch;hb=HEAD
> > [4]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch;hb=HEAD
> > [5]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch;hb=HEAD
> 
