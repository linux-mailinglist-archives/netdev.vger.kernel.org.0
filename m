Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5CD607662
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJULlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiJULlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:41:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165931E8B8A;
        Fri, 21 Oct 2022 04:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ybzj+4INELQ+p10Y7K/jRSkq7s5IXHsyCClX4FS/l14=; b=F2+zcW8NX3aYgLlejVS2joun3r
        cnmlcNvTL3nMYgQY7GkQpFApFoz44GGlQWZHwEkSi95aUNkzJBxNSGCPhORGM3aE751T/TtnrgiEn
        RwFzIcPrbWy2phovgkzgpy5TaWRvz5bTyCsQSTBundZzGkYHA1sJIFQCoO5nFdfqoHi5p7T+jZAWu
        KHEsmUF7hRWuG/Nu+8gga/kd9/B4ncS1S3ElH2yqHWLbRWWtCnJsZPjwFtVJuvac3McqEnZsEhwK1
        8K6092yiN3hd9Unz8UitPmn2i63TD2xt1eLJPPUGP/XD8OlrtLuiyq5rO5X1mZvLlchZSHkc7v28V
        xGc2YRbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34860)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olqOT-00008I-FO; Fri, 21 Oct 2022 12:40:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olqOR-00048B-B4; Fri, 21 Oct 2022 12:40:51 +0100
Date:   Fri, 21 Oct 2022 12:40:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lxu@maxlinear.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set
 driver for GPY211 chips
Message-ID: <Y1KFQ3emJhg8gXOj@shell.armlinux.org.uk>
References: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 21, 2022 at 03:33:05PM +0530, Raju Lakkaraju wrote:
> @@ -370,6 +415,38 @@ static int gpy_config_aneg(struct phy_device *phydev)
>  			      VSPEC1_SGMII_CTRL_ANRS, VSPEC1_SGMII_CTRL_ANRS);
>  }
>  
> +static void gpy_update_mdix(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, PHY_CTL1);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return;
> +	}
> +
> +	if (ret & PHY_CTL1_AMDIX)
> +		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +	else
> +		if (ret & PHY_CTL1_MDICD || ret & PHY_CTL1_MDIAB)
> +			phydev->mdix_ctrl = ETH_TP_MDI_X;
> +		else
> +			phydev->mdix_ctrl = ETH_TP_MDI;

I think this would be better formatted as:

	if (...)
		...
	else if (...)
		...
	else
		...

We don't indent unless there's braces, and if there's braces, coding
style advises braces on both sides of the "else". So, much better to
use the formatting I suggest above.

Apart from that, nothing stands out as being wrong in this patch.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
