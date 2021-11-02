Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CFB4434B4
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhKBRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhKBRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:44:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B79C061203;
        Tue,  2 Nov 2021 10:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N3bAGKj17dhulSsI0ZUBKwInlPRr6U/3HY9amRyD0lc=; b=xiYs7m7EKOK18NW6IWhhzz6Tpa
        WmZj5EzZei9J4nK3z6zhRMKM+fJ3ZYIwbKJzWsXtxYDyBH20wvGQeyQVZXs1isX2jySsdPsGCEkpw
        oBMzoscAkM4orJCm/AjL7GS3KKLvIMR9HoLPyTkDsQMUce8HijZNUwGd9UmvGW9cx9qPe/a/Ud82s
        PL9hZRLV6kaE8SSy3G/9S8HDMYsqlL1HCqdYE+tgeorL7vkXCiJtKfi4LyX9Kbpm7cRA0eCQfv3i8
        DVm2JgvPv6JymQ1/fHjTgn3Y11q4SjeVL992THSgk+nitRLm2jy2mDKN3qkbw14D/x4etL4cw1wVI
        TQEMhXZg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55444)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mhxnK-000448-Tl; Tue, 02 Nov 2021 17:41:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mhxnJ-0005ah-CX; Tue, 02 Nov 2021 17:41:57 +0000
Date:   Tue, 2 Nov 2021 17:41:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 07:19:46PM +0200, Grygorii Strashko wrote:
> It would require MDIO bus lock, which is not a solution,
> or some sort of batch processing, like for mmd:
>  w reg1 val1
>  w reg2 val2
>  w reg1 val3
>  r reg2
> 
> What Kernel interface do you have in mind?

That is roughly what I was thinking, but Andrew has basically said no
to it.

> Sry, but I have to note that demand for this become terribly high, min two pings in months

Feel free to continue demanding it, but it seems that at least two of
the phylib maintainers are in agreement that providing generic
emulation of C45 accesses in kernel space is just not going to happen.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
