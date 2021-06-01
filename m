Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7953972D3
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFALyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFALyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:54:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13436C061574;
        Tue,  1 Jun 2021 04:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hThjzyD5PdpvEbtDuA2WlTKzdIKthAXEXN7E7fzGif0=; b=xnISXh1iuAYIg9J7zF2crdN68
        ycZn4SEIUAob7ZGnV3Vyfmg4mGpcCB3Y9VbVjfbDhKhKmXtOJgVc7+KYYh2b3pyoZ1OwAa0jYrc1b
        fy+BV5byDSkvisC3WJO2nJ1oshL7JL2TjMt6asGnP1ftPuZn2x1scmZQ5LUfk813ZZr884qYE8CVA
        SNcE4os5KQzM1T/LsVswbez0oqWp3qOwiNNZShSfmS82wy/3DjQPlBVUQSZh5SYEBE5NUcqRBzn2j
        l1KMs07gN2PLzPEoT9kXbP4wnURhffeNvQP3C8WFBIQThZ92aRGNBFG/Z3/Yw2eNXnMgHW7XVPdBi
        4gUQfmQ3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44564)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lo2wW-0003wM-Ab; Tue, 01 Jun 2021 12:52:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lo2wV-0008W6-QQ; Tue, 01 Jun 2021 12:52:19 +0100
Date:   Tue, 1 Jun 2021 12:52:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: phy: realteck: add dt property to
 disable ALDPS mode
Message-ID: <20210601115219.GU30436@shell.armlinux.org.uk>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-4-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601090408.22025-4-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 05:04:07PM +0800, Joakim Zhang wrote:
> @@ -325,8 +329,10 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  	u16 val;
>  	int ret;
>  
> -	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
> -	phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
> +	if (!(priv->quirks & RTL821X_ALDPS_DISABLE_FEATURE)) {
> +		val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
> +		phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
> +	}

Similar questions as with the previous patch, but also... this doesn't
actually disable the feature if it was previously turned on. E.g. a
kexec() from a current kernel that has set these features into a
subsequent kernel that the DT requests the feature to be disabled. Or
a boot loader that has enabled this feature.

If DT specifies that this feature is disabled, shouldn't this code be
disabling it explicitly?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
