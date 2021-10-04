Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7E421A6A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhJDXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhJDXGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 19:06:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C3C061745;
        Mon,  4 Oct 2021 16:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Hzftuv3PjPqJSiP37NDPAWqu7Juih7yGqoA9fFvnUQk=; b=sDgxro6akYfeWFAiiSGMq4F79X
        nKsykoajwK4BAbwHVOzz9pLEYKMSK69CCNKfo14OUYuMcDdK7EDhfKI4YEqe3d0wgrFQKVo81A0JZ
        8TEfuiBMC5ja/nmGK9FVRzgiw+UHtGL2C3c9gI61tmJoWjc0h39miLibrSZtxd2lps7FZVQBOULj2
        XcYE4JPP64NPeqNa2uSMHRVcetuS94n2xVXXqcGRk+108Fky9vMpHBYeo8uH+qea8OBMMm7WPv/7C
        tsp6BWUCFFgOk5rSOTAp3LlUqhMT5n10rr9LokPo3+hKAejdwSblmpii6t1dOF3LHzoQLo4iFTkIA
        XX3zTyDQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54934)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXX0P-00086a-Dm; Tue, 05 Oct 2021 00:04:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXX0M-0007ti-Hi; Tue, 05 Oct 2021 00:04:18 +0100
Date:   Tue, 5 Oct 2021 00:04:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
Message-ID: <YVuIcqKjDgawNPG4@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-9-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-9-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:19PM -0400, Sean Anderson wrote:
> As the number of interfaces grows, the number of if statements grows
> ever more unweildy. Clean everything up a bit by using a switch
> statement. No functional change intended.

This doesn't look right to me.

> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index e2730b3e1a57..18afa544b623 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -510,32 +510,55 @@ static void macb_validate(struct phylink_config *config,
>  			  unsigned long *supported,
>  			  struct phylink_link_state *state)
>  {
> +	bool one = state->interface == PHY_INTERFACE_MODE_NA;

Shouldn't this be != ?

Since PHY_INTERFACE_MODE_NA is supposed to return all capabilities.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
