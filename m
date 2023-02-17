Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2711069AA87
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBQLgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjBQLgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:36:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1023D0BB
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W+YsRUlNaiXMpg9VJgTEYJkNxt4Tmw2+nkaFNbmCtSQ=; b=vtgaapiUxlmW63poR9iekDLnX1
        fax4PkrNgxM6O1VVuOGt5oXoLwx520LAZe5Phr/iNBTzxHg/1o55bDz10sy0aD+x4ipbhzVELu1nt
        wgdbpfVNp8lvxhfHVBtDOMp1pl5Q/cRfEtYZAlqDPV3rx8GcJiXBZVJ+0uIYHllAPugopawXpy9Xo
        I8omFxfo2udcyGoSyTbzMqQ2pNX6S1zJOMVlj0ljQgNiPGnV2lGsWKcMNEcq9y4MUw6+neM1NgIon
        xzHAHixABk8Iz6u8YCDMDYV0DTDprNXoFM4edigcyeJwz6ow3IsjhPls/GfqeG1KvUpofPNcdjaL1
        A5YaawDw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37382)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pSz2X-0000qM-A3; Fri, 17 Feb 2023 11:36:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pSz2V-0006kX-Ig; Fri, 17 Feb 2023 11:36:31 +0000
Date:   Fri, 17 Feb 2023 11:36:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
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
Subject: Re: [PATCH RFC 01/18] net: phy: Add phydev->eee_active to simplify
 adjust link callbacks
Message-ID: <Y+9mv0E9pca1tuPP@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-2-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:13AM +0100, Andrew Lunn wrote:
> MAC drivers which support EEE need to know the results of the EEE
> auto-neg in order to program the hardware to perform EEE or not.  The
> oddly named phy_init_eee() can be used to determine this, it returns 0
> if EEE should be used, or a negative error code,
> e.g. -EOPPROTONOTSUPPORT if the PHY does not support EEE or negotiate
> resulted in it not being used.
> 
> However, many MAC drivers get this wrong. Add phydev->eee_active which
> indicates the result of the autoneg for EEE, including if EEE is
> administratively disabled with ethtool. The MAC driver can then access
> this in the same way as link speed and duplex in the adjust link
> callback.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Yay!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
