Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C7E69B9F9
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBRMZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 07:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRMZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:25:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51797144A0
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 04:25:41 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pTMHZ-0000av-QX; Sat, 18 Feb 2023 13:25:37 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pTMHR-0002KZ-74; Sat, 18 Feb 2023 13:25:29 +0100
Date:   Sat, 18 Feb 2023 13:25:29 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 00/18] Rework MAC drivers EEE support
Message-ID: <20230218122529.GC9065@pengutronix.de>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <Y++OdVY3S8D7uopq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y++OdVY3S8D7uopq@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 02:25:57PM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 04:42:12AM +0100, Andrew Lunn wrote:
> > phy_init_eee() is supposed to be called once auto-neg has been
> > completed to determine if EEE should be used with the current link
> > mode. The MAC hardware should then be configured to either enable or
> > disable EEE. Many drivers get this wrong, calling phy_init_eee() once,
> > or only in the ethtool set_eee callback.
> 
> Looking at some of the recent EEE changes (not related to this patch
> set) I've come across:
> 
> commit 9b01c885be364526d8c05794f8358b3e563b7ff8
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Sat Feb 11 08:41:10 2023 +0100
> 
>     net: phy: c22: migrate to genphy_c45_write_eee_adv()
> 
> This part of the patch is wrong:
> 
> __genphy_config_aneg():
> -       if (genphy_config_eee_advert(phydev))
> +       err = genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
> 
> The problem here is that these are not equivalent.
> 
> genphy_config_eee_advert() only clears the broken EEE modes in the
> advertisement, it doesn't actually set the advertisement to anything
> in particular.
> 
> The replacement code _configures_ the advertisement to whatever the
> second argument is, which means each time the advertisement is
> changed (and thus __genphy_config_aneg() is called) the EEE
> advertisement will ignore whatever the user configured via the
> set_eee() APIs, and be restored to the full EEE capabilities in the
> supported mask.
> 
> This is an obvious regression that needs fixing, especially as the
> merge window is potentially due to open this weekend.

You are right :(

I'll be able to come with a fix this Monday.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
