Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6BC513F8E
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbiD2AgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiD2AgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:36:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53155B9F0B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B9MPe75G7faJ8/oqTbezVPDXUh5tDjsp7lHIHDt9KJU=; b=W/HggcopkR7ZlkM+upWZGpQWu8
        5xEuIAmyUpxPqMrqsT3Sg8Nkg5hhqs+XUnMyiVgQUUSruW8/WLxxCI/QlfXL/PnEIXVZPOa5HMear
        RbSH3zDyBkudp4BpY6CA5+JRBlKDu+L6wILetFmIlj8dCvmvU9x5QiSedXu/LHwIE27Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkEYq-000Oo5-IQ; Fri, 29 Apr 2022 02:32:40 +0200
Date:   Fri, 29 Apr 2022 02:32:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Deduplicate interrupt disablement on
 PHY attach
Message-ID: <YmsyKI5yIY055UqP@lunn.ch>
References: <805ccdc606bd8898d59931bd4c7c68537ed6e550.1651040826.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805ccdc606bd8898d59931bd4c7c68537ed6e550.1651040826.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:30:51AM +0200, Lukas Wunner wrote:
> phy_attach_direct() first calls phy_init_hw() (which restores interrupt
> settings through ->config_intr()), then calls phy_disable_interrupts().
> 
> So if phydev->interrupts was previously set to 1, interrupts are briefly
> enabled, then disabled, which seems nonsensical.
> 
> If it was previously set to 0, interrupts are disabled twice, which is
> equally nonsensical.

I agree this is non nonsensical.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

However the git history is interesting:

commit 7d3ba9360c6dac7c077fbd6631e08f32ea2bcd53
Author: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date:   Wed Sep 9 14:43:14 2020 +0900

    net: phy: call phy_disable_interrupts() in phy_attach_direct() instead
    
    Since the micrel phy driver calls phy_init_hw() as a workaround,
    the commit 9886a4dbd2aa ("net: phy: call phy_disable_interrupts()
    in phy_init_hw()") disables the interrupt unexpectedly. So,
    call phy_disable_interrupts() in phy_attach_direct() instead.
    Otherwise, the phy cannot link up after the ethernet cable was
    disconnected.
    
    Note that other drivers (like at803x.c) also calls phy_init_hw().
    So, perhaps, the driver caused a similar issue too.
    
This removes the call to phy_disable_interrupts() in phy_init_hw()
because it breaks some micrel PHYs.

And then:

ommit 4c0d2e96ba055bd8911bb8287def4f8ebbad15b6
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Thu Feb 11 22:32:52 2021 +0100

    net: phy: consider that suspend2ram may cut off PHY power
    
    Claudiu reported that on his system S2R cuts off power to the PHY and
    after resuming certain PHY settings are lost. The PM folks confirmed
    that cutting off power to selected components in S2R is a valid case.
    Therefore resuming from S2R, same as from hibernation, has to assume
    that the PHY has power-on defaults. As a consequence use the restore
    callback also as resume callback.
    In addition make sure that the interrupt configuration is restored.
    Let's do this in phy_init_hw() and ensure that after this call
    actual interrupt configuration is in sync with phydev->interrupts.
    Currently, if interrupt was enabled before hibernation, we would
    resume with interrupt disabled because that's the power-on default.
    
    This fix applies cleanly only after the commit marked as fixed.
    
    I don't have an affected system, therefore change is compile-tested
    only.

This puts the interrupt handling back into phy_init_hw()!

So it seems like something might be broken here, but your patch should
not make it worse.

    Andrew
