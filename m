Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1272B468CE6
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 20:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhLETGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 14:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbhLETGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 14:06:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE70C061714;
        Sun,  5 Dec 2021 11:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SOXl9o+NM3H17iooiOp+N4HYzAPe9LLAu+twEINB+rs=; b=fny8pUDOqLGtQTWhQp0lxnx4LC
        sAqFhxpZ6TBXxEN/9/qgPc0TcyBu6c0DRRakioc2++zW39hd7gcSg2qKP1Zm+CS2i0P4GWEEYZOsm
        /+4cUOQXApIDGxGgcD08H0FYQvjglwsAkooyiczEc+LSaPtwAFsJiyPXTLmyZvrH6KVfwQVw5Z4LJ
        0HfT5VrZFaw3A89G1aEqnwecrcw88ckGpDhBI+amQmteYzsXN8R6cnyO2iE1wP8Q6lMwW+em13I17
        6aEXC38vhkfXUH6Wedmab81fRv42sUf412Ag5zdOP+d65SeoaIb9638w5aG8tLaDAHCJEfEH9TuHi
        fJ/oPZLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56088)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtwmh-00047b-Sw; Sun, 05 Dec 2021 19:02:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtwme-0003cE-PB; Sun, 05 Dec 2021 19:02:48 +0000
Date:   Sun, 5 Dec 2021 19:02:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yinbo Zhu <zhuyinbo@loongson.cn>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <Ya0M2E+Pqvh1FvPF@shell.armlinux.org.uk>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
 <YaXrP1AyZ3AWaQzt@shell.armlinux.org.uk>
 <ea3f6904-c610-0ee6-fbab-913ba6ae36c5@loongson.cn>
 <Yas2+yq3h5/Bfvy9@shell.armlinux.org.uk>
 <YavYM2cs0RuY0JdM@shell.armlinux.org.uk>
 <YazhPOIIzpl43tzq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YazhPOIIzpl43tzq@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 04:56:44PM +0100, Andrew Lunn wrote:
> > This patch changes the MODALIAS entry for only PHY devices from:
> > 	MODALIAS=of:Nethernet-phyT(null)
> > to:
> > 	MODALIAS=mdio:00000000001000100001010100010011
> 
> Hi Russell
> 
> You patch looks good for the straight forward cases.
> 
> What happens in the case of
> 
>         ethernet-phy@0 {
>             compatible = "ethernet-phy-ieee802.3-c45";
> 
> 
> Does this get appended to the end, or does it overwrite?

Hmm, good point, I'd forgotten about clause 45 PHYs - we need to dig
the first existing ID out of the clause 45 ID array and use that
instead. That said, we don't publish the ID through the "phy_id"
sysfs file either for clause 45.

I don't believe it's possible to publish multiple modalias strings.

This gives a problem for clause 45 PHYs which can have a different ID
for each MMD, and the driver might match on only one of those. 88x3310
is an example where different MMDs have different IDs. The mechanism
we have in phy_device_create() gets around that, because we call
phy_request_driver_module() for every ID there is in the hope that one
of those will load the appropriate driver, but as I say, I don't
believe that's a possibility via the udev approach.

So I think we may have to say that clause 45 PHYs can't reliably use
the conventional udev mechanism.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
