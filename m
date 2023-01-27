Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF1E67E949
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbjA0PSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbjA0PSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:18:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC02155A5;
        Fri, 27 Jan 2023 07:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=clgmemFyLB5CGSAnCHnwDzFVOe3aAZNcIzPJ3wS4IfM=; b=VCpW25fPkfIk7NriSA60c4/1co
        N7Jd+JRCcSqhYS7bY4uooxV+s8HVGxCtb8H6EjjsABonStuTGgao0gX5AAs/zZkTlTCLg2SqMqjJJ
        NZnbBxO72JAg/FyP80aNXdILi4McNf/R7koAssPKiC8WJT7wtmcnSRx67da9DF+14Ki+5GSpdoERk
        TnUtQ77n/aqVIyFzaPHvpagfZa2lyoA1w6627SOHBFvw/C63geW1wbC2JCxzygUbnnPclu+DMjpzF
        y+s/JL8geCgNlKppqxTCbeOffXqm8QQRrLwgKxe2oGmAi+SaqkspWB/IP5Xj9AuBhCcglN87wNzAm
        7gsHTZEA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36328)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pLQTw-0005Tt-Hd; Fri, 27 Jan 2023 15:17:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pLQTs-0008Qk-R4; Fri, 27 Jan 2023 15:17:32 +0000
Date:   Fri, 27 Jan 2023 15:17:32 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:26:21PM +0900, Yoshihiro Shimoda wrote:
> Some Ethernet PHYs (like marvell10g) will decide the host interface
> mode by the media-side speed. So, the rswitch driver needs to
> initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> .init() for initializing all ports and .power_on() for initializing
> each port. So, add phy_power_{on,off} calling for it.

So how does this work?

88x3310 can change it's MAC facing interface according to the speed
negotiated on the media side, or it can use rate adaption mode, but
if it's not a MACSEC device, the MAC must pace its transmission
rate to that of the media side link.

The former requires one to reconfigure the interface mode in
mac_config(), which I don't see happening in this patch set.

The latter requires some kind of configuration in mac_link_up()
which I also don't see happening in this patch set.

So, I doubt this works properly.

Also, I can't see any sign of any working DT configuration for this
switch to even be able to review a use case - all there is in net-next
is the basic description of the rswitch in a .dtsi and no users. It
may be helpful if there was some visibility of its use, and why
phylink is being used in this driver - because right now with phylink's
MAC methods stubbed out in the way they are, and even after this patch
set, I see little point to this driver using phylink.

Moreover, looking at the binding document, you don't even support SFPs
or fixed link, which are really the two reasons to use phylink over
phylib.

Also, phylink only really makes sense if the methods in its _ops
structures actually do something useful, because without that there
can be no dynamic configuration of the system to suit what is
connected.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
