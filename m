Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF31E2C2A87
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbgKXO5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbgKXO5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:57:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C596BC0613D6;
        Tue, 24 Nov 2020 06:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J0J3E7b9p8oawWwuEj7kpUYKxWq5ce28QVykTXRpMWw=; b=u05sgykDakZ+56Z95sUEBTtjp
        o6F/rDI/sDO5xwz4tL2EqZb4Nczft02XO9EvJeef0tCFxtkfG3cgkaQo2KgjQLRGhubJNJpywtEIT
        ZFBFz89nuHKzIvvs8qkcu/caoeaqh24A3ZiVIv2g8JUdxJXbvGt/vnQHJOWj2xkQ4jtCEKb/qbtjb
        qQO41vt/Sa7p67hJ6Vvg4/cG25PG75Gw5FmDTMwNm/05G0mVRt7tosUcEVMZclmLUoITntUoYBOpV
        L1GN41vjd/d18I+Y1Sy6FW/DIQl7queUHwgp2UBZzvBBJs6xzJEujOXaF3Vbo/WQEFixU5PWuaWOs
        KIB7801zQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35532)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khZkS-0007qo-Q0; Tue, 24 Nov 2020 14:56:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khZkN-0007Qk-I3; Tue, 24 Nov 2020 14:56:47 +0000
Date:   Tue, 24 Nov 2020 14:56:47 +0000
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
Message-ID: <20201124145647.GF1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124143848.874894-1-antonio.borneo@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 03:38:48PM +0100, Antonio Borneo wrote:
> If the auto-negotiation fails to establish a gigabit link, the phy
> can try to 'down-shift': it resets the bits in MII_CTRL1000 to
> stop advertising 1Gbps and retries the negotiation at 100Mbps.
> 
> From commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode
> in genphy_read_status") the content of MII_CTRL1000 is not checked
> anymore at the end of the negotiation, preventing the detection of
> phy 'down-shift'.
> In case of 'down-shift' phydev->advertising gets out-of-sync wrt
> MII_CTRL1000 and still includes modes that the phy have already
> dropped. The link partner could still advertise higher speeds,
> while the link is established at one of the common lower speeds.
> The logic 'and' in phy_resolve_aneg_linkmode() between
> phydev->advertising and phydev->lp_advertising will report an
> incorrect mode.
> 
> Issue detected with a local phy rtl8211f connected with a gigabit
> capable router through a two-pairs network cable.
> 
> After auto-negotiation, read back MII_CTRL1000 and mask-out from
> phydev->advertising the modes that have been eventually discarded
> due to the 'down-shift'.

Sorry, but no. While your solution will appear to work, in
introduces unexpected changes to the user visible APIs.

>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +		if (phydev->is_gigabit_capable) {
> +			adv = phy_read(phydev, MII_CTRL1000);
> +			if (adv < 0)
> +				return adv;
> +			/* update advertising in case of 'down-shift' */
> +			mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
> +							adv);

If a down-shift occurs, this will cause the configured advertising
mask to lose the 1G speed, which will be visible to userspace.
Userspace doesn't expect the advertising mask to change beneath it.
Since updates from userspace are done using a read-modify-write of
the ksettings, this can have the undesired effect of removing 1G
from the configured advertising mask.

We've had other PHYs have this behaviour; the correct solution is for
the PHY driver to implement reading the resolution from the PHY rather
than relying on the generic implementation if it can down-shift.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
