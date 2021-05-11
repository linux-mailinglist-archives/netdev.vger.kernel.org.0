Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A1D37B125
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhEKV54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKV5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:57:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A8FC061574;
        Tue, 11 May 2021 14:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RKf0jhjqNyYKa1rwLYcbF4xtKVI/z4lp0gDi5eHVKyw=; b=xhdV61NXfHaovmyP1GOMVMIqz
        QjCVo7lOaj+nCCq9P4erUTr+/yU4fr2EsAOcWvwerLlNfjxNETg2mUnKotlQWCpXE/4dF8rR51bl2
        5AynBeYQmksC+PMcyeH0O7oy2EzZyP32gPSIJTejJhp3jdgCWiuhmZkOzl4aOdCRClRouIpouA9Sz
        PZgNtrq8Fy+JMmEr7VnYy62LYx+LqV+XHt3GLz9pHvk2J5Vp0yOgL6nTpH1Q+Gq1/PheSPYzNBNnS
        VmVPs+S2t3/K8a0vVi2cf9Px25/iLHZnLzDn/wcLimAoK8S/p56tqDVeO03Q/fe5Lfhrhzch4aC6F
        +nK2xpdTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43874)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lgaMv-0003Fx-Gv; Tue, 11 May 2021 22:56:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lgaMu-0001Qg-7M; Tue, 11 May 2021 22:56:44 +0100
Date:   Tue, 11 May 2021 22:56:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <20210511215644.GO1336@shell.armlinux.org.uk>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511214605.2937099-1-pgwipeout@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
> +static int yt8511_config_init(struct phy_device *phydev)
> +{
> +	int ret, val, oldpage;
> +
> +	/* set clock mode to 125mhz */
> +	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
> +	if (oldpage < 0)
> +		goto err_restore_page;
> +
> +	val = __phy_read(phydev, YT8511_PAGE);
> +	val |= (YT8511_CLK_125M);
> +	ret = __phy_write(phydev, YT8511_PAGE, val);

Please consider __phy_modify(), and handle any error it returns.

> +
> +	/* disable auto sleep */
> +	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);

Please consider handling a failure to write here.

> +	val = __phy_read(phydev, YT8511_PAGE);
> +	val &= (~BIT(15));
> +	ret = __phy_write(phydev, YT8511_PAGE, val);

Also a use for __phy_modify().

> +
> +err_restore_page:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
> +static struct phy_driver motorcomm_phy_drvs[] = {
> +	{
> +		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
> +		.name		= "YT8511 Gigabit Ethernet",
> +		.config_init	= &yt8511_config_init,

Please drop the '&' here, it's unnecessary.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
