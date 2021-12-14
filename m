Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F3474EB4
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhLNXpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbhLNXp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:45:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B16CC061574;
        Tue, 14 Dec 2021 15:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MCj3uEcu5c6UlruWu6bGSHyPZC5qkeb9xLdGlN1FpGc=; b=IsZndqkKv/JSXqxKDBEWJmdQZi
        LlElMSIgl8FII2Vs4iJlldipr5nqbC21aV4g2bnlA08PoCockhqXBObbigf+rM+uED3RJYH4vjZeN
        LnO4DGPj+2nEQE1Qmo0jtNMvSDQsAy9bHeIebw+F0Emun3JXLAIeimmcxeJ6GFyRRkQqEJimlN+7h
        wGa6DmrR4jVXe2d3rOWaEu81gAGDXVtkh8NCSrGyiLsjOvqPh0jnBGPqxmjEwzwsorAsiH77K9LNF
        8Y1+2N58wwsE0/rF1k3TBLjjUyPhthM5TJ1q2/LH1MWB0Hk4RlnL+Ttz+27vRzSWdXY2l2IPZZupb
        RJXeq2qA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56288)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxHTu-0005Yg-VW; Tue, 14 Dec 2021 23:45:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxHTq-0003vk-2y; Tue, 14 Dec 2021 23:45:10 +0000
Date:   Tue, 14 Dec 2021 23:45:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>, UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
Message-ID: <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214233450.1488736-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 06:34:50PM -0500, Sean Anderson wrote:
> Although most PCSs only need the interface and advertising to configure
> themselves, there is an oddly named "permit_pause_to_mac" parameter
> included as well, and only used by mvpp2. This parameter indicates
> whether pause settings should be autonegotiated or not. mvpp2 needs this
> because it cannot both set the pause mode manually and and advertise
> pause support. That is, if you want to set the pause mode, you have to
> advertise that you don't support flow control. We can't just
> autonegotiate the pause mode and then set it manually, because if
> the link goes down we will start advertising the wrong thing. So
> instead, we have to set it up front during pcs_config. However, we can't
> determine whether we are autonegotiating flow control based on our
> advertisement (since we advertise flow control even when it is set
> manually).
> 
> So we have had this strange additional argument tagging along which is
> used by one driver (though soon to be one more since mvneta has the same
> problem). We could stick MLO_PAUSE_AN in the "mode" parameter, since
> that contains other autonegotiation configuration. However, there are a
> lot of places in the codebase which do a direct comparison (e.g. mode ==
> MLO_AN_FIXED), so it would be difficult to add an extra bit without
> breaking things. But this whole time, mac_config has been getting the
> whole state, and it has not suffered unduly. So just pass state and
> eliminate these other parameters.

Please no. This is a major step backwards.

mac_config() suffers from the proiblem that people constantly
mis-understand what they can access in "state" and what they can't.
This patch introduces exactly the same problem but for a new API.

I really don't want to make that same mistake again, and this patch
is making that same mistake.

The reason mvpp2 and mvneta are different is because they have a
separate bit to allow the results of pause mode negotiation to be
forwarded to the MAC, and that bit needs to be turned off if the
pause autonegotiation is disabled (which is entirely different
from normal autonegotiation.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
