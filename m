Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0051A649F0E
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 13:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiLLMrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 07:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiLLMrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 07:47:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDF212084;
        Mon, 12 Dec 2022 04:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bnDEDv4cCUbLu4jOeJkF2nvePqKhVNSO7r0+B2yW+J8=; b=zblTOoSnDU5imG7LtfiCwQMBeB
        JjNa1ISzUmSc5+FkwIYHtnKWvBNgnCybwImEB+b4ExzFYJNHH+01/646BHZU0wROeW/Ohs1nLGgxn
        tAjQTUpGnm2Y0/jU5fV0bdfMe/QzFUYh6HKyEScNqBQvimGBiaLxSFKLEREWOgaatkkIHaxHvYnjm
        fkmHHWkvqblz/3J8wGb29mYKR4BYXIxUfaAKRVA7donhMa/tJ4aIAAQKt2TNGHT6vXxd111thUTaJ
        5jkubZauSdYrVGIpxCHblw9aVO43YOM4wOFk94ETOpu1T09fsPeB9KtHMjHe7CFvMLhLBFDsX3WTH
        rYFxV6QQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35676)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p4iD9-0005a5-LJ; Mon, 12 Dec 2022 12:47:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p4iD7-0005Vm-Bu; Mon, 12 Dec 2022 12:47:09 +0000
Date:   Mon, 12 Dec 2022 12:47:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, hkallweit1@gmail.com, sergiu.moga@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Message-ID: <Y5cizXwsEnJ3fX0y@shell.armlinux.org.uk>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212112845.73290-2-claudiu.beznea@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 01:28:44PM +0200, Claudiu Beznea wrote:
> There are scenarios where PHY power is cut off on system suspend.
> There are also MAC drivers which handles themselves the PHY on
> suspend/resume path. For such drivers the
> struct phy_device::mac_managed_phy is set to true and thus the
> mdio_bus_phy_suspend()/mdio_bus_phy_resume() wouldn't do the
> proper PHY suspend/resume. For such scenarios call phy_init_hw()
> from phylink_resume().
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
> 
> Hi, Russel,
> 
> I let phy_init_hw() to execute for all devices. I can restrict it only
> for PHYs that has struct phy_device::mac_managed_phy = true.
> 
> Please let me know what you think.

I think it would be better to only do this in the path where we call
phy_start() - if we do it in the WoL path (where the PHY remains
running), then there is no phy_start() call, so phy_init_hw() could
result in the PHY not working after a suspend/resume event.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
