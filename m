Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699FC2C2B81
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbgKXPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389277AbgKXPiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:38:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18A1C0613D6;
        Tue, 24 Nov 2020 07:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gemFyzpNjNLon40XFhSL9X2QjE/xiw9/g4FNTnG3Ym4=; b=D8CkwFXXZblYfDir5fESdil6h
        NJyGgTiXqzqCcZfxLA8A8+baS9eDHlGG1kk8H9YaehBBDfvIICFz31qIDxAeTVL4fJ50/QDIv3Aul
        xaA2bie40QhHP5Y6iQKZuO9ESIwZBYCb55pFpbPEEWFSytwA1c1oEZzD+Uoo64odChsrldM4fURpV
        YmsVpGK0Vv+RZWqdcBW+znGKeLK6Em3GxajInaLTTbft1RKaJUmeKbsc7gcAWLPXtKqy5ZPpCGJhu
        UqKRl51EIlxSR6R0s8ohVoP8Nx7V+6Api/6lE/zcji2uszEmAUpEmPcvevOwkOs8T4sbYRxMSOUan
        Dvo0U0w4w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35544)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khaOC-0007tb-AP; Tue, 24 Nov 2020 15:37:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khaO6-0007S6-L7; Tue, 24 Nov 2020 15:37:50 +0000
Date:   Tue, 24 Nov 2020 15:37:50 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yonglong Liu <liuyonglong@huawei.com>, stable@vger.kernel.org,
        linuxarm@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
Message-ID: <20201124153750.GH1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124145647.GF1551@shell.armlinux.org.uk>
 <bd83b9c15f6cfed5df90da4f6b50d1a3f479b831.camel@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd83b9c15f6cfed5df90da4f6b50d1a3f479b831.camel@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 04:17:42PM +0100, Antonio Borneo wrote:
> On Tue, 2020-11-24 at 14:56 +0000, Russell King - ARM Linux admin wrote:
> > Userspace doesn't expect the advertising mask to change beneath it.
> > Since updates from userspace are done using a read-modify-write of
> > the ksettings, this can have the undesired effect of removing 1G
> > from the configured advertising mask.
> > 
> > We've had other PHYs have this behaviour; the correct solution is for
> > the PHY driver to implement reading the resolution from the PHY rather
> > than relying on the generic implementation if it can down-shift
> 
> If it's already upstream, could you please point to one of the phy driver
> that already implements this properly?

Reading the resolved information is PHY specific as it isn't
standardised.

Marvell PHYs have read the resolved information for a very long time.
I added support for it to at803x.c:

06d5f3441b2e net: phy: at803x: use operating parameters from PHY-specific status

after it broke for exactly the reason you're reporting for your PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
