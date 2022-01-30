Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6454A364E
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 13:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350584AbiA3MlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 07:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbiA3MlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 07:41:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55008C061714;
        Sun, 30 Jan 2022 04:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kZB5ahdLUol5/N8DBSN+3qX+veD/LzUVPKh58HExSNk=; b=DgPu0Q3DwXvjAcD1HMncfoPpm/
        OZGmGlgvMXRpX6yICg6YxkcSVqgxV4jBkRh4Dpkk5bOS/W9sAS7LIFqqHBRPFjxORv5Pe0NRi2ZtQ
        2X2q182H9jLgAI3RFaCzOzfhIoFv1kCHVzUAX7ON1mJYSDFJJ5BQLiSaOjlqFEt07hQyXFdUyyVm4
        ndyEYoBzAsKL1QJdtt/sl1Infty025qni+VEIGpVPibCpCGQURMtDAbABWY21zePcJJDtMEcivbCQ
        3T6UNxnZLaRoirm4jcNncS9Xc4Vh+K+mx8NXRdMVWr5xUeEvAwKH9/ZCkXXE/y8I3wK/AKgb34qW2
        ZpoHu3Lg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56932)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nE9Vr-0007MR-Qy; Sun, 30 Jan 2022 12:40:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nE9Vp-0000A2-Ka; Sun, 30 Jan 2022 12:40:57 +0000
Date:   Sun, 30 Jan 2022 12:40:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Subject: Re: [PATCH net] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <YfaHWSe+FvZC7w/x@shell.armlinux.org.uk>
References: <YfZnmMteVry/A1XR@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfZnmMteVry/A1XR@earth.li>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 10:25:28AM +0000, Jonathan McDowell wrote:
> A typo in qca808x_read_status means we try to set SMII mode on the port
> rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> traffic due to the mismatch in configuration between the phy and the
> mac.
> 
> Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---
>  drivers/net/phy/at803x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 5b6c0d120e09..7077e3a92d31 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -1691,7 +1691,7 @@ static int qca808x_read_status(struct phy_device *phydev)
>  	if (phydev->link && phydev->speed == SPEED_2500)
>  		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
>  	else
> -		phydev->interface = PHY_INTERFACE_MODE_SMII;
> +		phydev->interface = PHY_INTERFACE_MODE_SGMII;

Is it intentional to set the interface to SGMII also when there is no
link?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
