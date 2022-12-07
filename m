Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D56459C5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLGMYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLGMYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:24:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005873FB95;
        Wed,  7 Dec 2022 04:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KFLaoTEu2QQ7MxUXT6CC0pCM2Cxx17l+86Z3LioNIDY=; b=0hB7SpXoLqzcTZJ32Y1iyQCB/j
        pWg3jx8euI4i0JpMPqaZG11jHKHmYq/bIMMzcf3SnT+ayo9vhBCsHHyFIJfVPA9ANpWwO9/8aIq3C
        71Q5BW69Jq9U7ta4PA1aBEx3dQeBIO1CCKsE+fOD4tqLgoDz8y3+5BlD0H5wV1CXDUKBMpiOLVo8C
        3SRHbLiiWwo2I+PfGIw+RYKn4K8kKEJEJMX8hMh29jwtSeeUXRd+T4nnQ/Zt7izMqvgeU1G3g51LR
        ilawPcHRvuro+Z+BQLuR9LNuMZqkk4BfokilaXFOAg1x91K+FKO6jkwn3K3Es4x8t08WlqY9VwpTf
        eHso3NGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35614)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2tSs-0000cJ-Aa; Wed, 07 Dec 2022 12:23:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2tSp-0000jD-8b; Wed, 07 Dec 2022 12:23:51 +0000
Date:   Wed, 7 Dec 2022 12:23:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu.Beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, hkallweit1@gmail.com, Sergiu.Moga@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phylink: add helper to initialize phylink's
 phydev
Message-ID: <Y5CF15Yk1ndwO/+a@shell.armlinux.org.uk>
References: <20221205153328.503576-1-claudiu.beznea@microchip.com>
 <20221205153328.503576-2-claudiu.beznea@microchip.com>
 <Y44VATEVPpEOBz/3@shell.armlinux.org.uk>
 <4375d733-ed49-869c-635f-0f0ba7304283@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4375d733-ed49-869c-635f-0f0ba7304283@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Dec 07, 2022 at 10:49:39AM +0000, Claudiu.Beznea@microchip.com wrote:
> On 05.12.2022 17:57, Russell King (Oracle) wrote:
> > when we know that the PHY has lost power - maybe the MAC driver can
> > tell phylink that detail, and be updated to use phylink_suspend() and
> > phylink_resume() ?
> 
> Cutting the power is arch specific and it may depends on the PM mode that
> system will go (at least for AT91 architecture). At the moment there is no
> way for drivers to know about architecture specific power management mode.
> There was an attempt to implement this (few years ago, see [1]) but it
> wasn't accepted (from what I can see in the source code at the moment).
> 
> So, in case we choose to move it to phylink_resume() we will have to
> reinitialize the PHY unconditionally (see below). Would this be OK?

I guess it would - off the top of my head, I can't think why a call to
phy_init_hw() would cause an issue, but maybe my fellow phylib
maintainers have a different opinion.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
