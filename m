Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8013B98DD
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 01:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhGAXPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 19:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhGAXP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 19:15:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F06C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 16:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dSnme9ME3oprQlznXzzQkLovou6pvW/NauXph41kOGw=; b=OrN+gCOvsEVCaM3pBu7GZYzpF
        X1VsLOddN6nSlX+Kyc0RPqeTTaeckKumtG207BMgX9vyhy/wS05oTUlV65f6QGZJdl85zSv/pzc9L
        wRWvAmp7cCR0zBKWAj7xYU34rlqEVn/VIsnN9a+86ftsssiMHnbdzjWmgyKtaoLDyqThfBbCn78wM
        GY/g3I4prtl4p8AWdoKUi/71nTtYU5RVHYuOpHHn3BRPOdVgwJe6de4NaQru8f6UazxdQ0s6J/5aU
        RqRuig2PL1RaEAFx88jRYa+8vfR1tQXqnfSjSP11G038ccetM+MA453Sdt+6Mrk65ZV46IXeBEXoz
        9e4lRjONA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45598)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lz5ra-0001kj-Ud; Fri, 02 Jul 2021 00:12:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lz5rZ-0004Th-Vw; Fri, 02 Jul 2021 00:12:54 +0100
Date:   Fri, 2 Jul 2021 00:12:53 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: at803x: Support downstream SFP
 cage
Message-ID: <20210701231253.GM22278@shell.armlinux.org.uk>
References: <20210630180146.1121925-1-robert.hancock@calian.com>
 <20210630180146.1121925-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630180146.1121925-3-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 12:01:46PM -0600, Robert Hancock wrote:
> Add support for downstream SFP cages for AR8031 and AR8033. This is
> primarily intended for fiber modules or direct-attach cables, however
> copper modules which work in 1000Base-X mode may also function. Such
> modules are allowed with a warning.

Possibly that's because they default to 1000Base-X mode for
compatibility, but there are some (MikroTik S-RJ01) for example
where the PHY definitely is in SGMII mode and will negotiate
10/100Mbit on its media side which won't work with an AR803x.

> +	/* Some modules support 10G modes as well as others we support.
> +	 * Mask out non-supported modes so the correct interface is picked.
> +	 */
> +	linkmode_and(sfp_support, phy_support, sfp_support);

I think rather than relying on sfp_select_interface() complaining when
sfp_support is empty, do an explicit check here (phylink code
effectively does this via the phylink_validate() check.)

You'll then either be given SGMII or 1000BASE-X by
sfp_select_interface().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
