Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C051E4326C0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhJRSnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:43:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhJRSnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wKwdNuC/u90uy6tdfGr/fFOqFF6c6+A3o/6MvmpPI0U=; b=qpbsPZjuUVddf2WlJRKUc9gyOq
        cV0YsyWy5GMufSNviD3JS0rKYjeVVFhCSgNpwK8o6sy4K7dgFdieNF4U+bKoXj4q0Hrd7jdTy68jp
        GPaTrEXum4/Hx2RcgmyoWrOsq5p6Jqcv3vyKOj1wX6eLeaCF8+mjpnz39UkIEEr3va7E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcXZJ-00AzoE-9W; Mon, 18 Oct 2021 20:41:05 +0200
Date:   Mon, 18 Oct 2021 20:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 03/13] net: phy: at803x: improve the WOL feature
Message-ID: <YW2/wck2NPhgwjuL@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-4-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-4-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -348,18 +349,29 @@ static int at803x_set_wol(struct phy_device *phydev,
>  			phy_write_mmd(phydev, MDIO_MMD_PCS, offsets[i],
>  				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
>  
> +		/* Enable WOL function */
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> +				0, AT803X_WOL_EN);
> +		if (ret)
> +			return ret;
> +		/* Enable WOL interrupt */
>  		ret = phy_modify(phydev, AT803X_INTR_ENABLE, 0, AT803X_INTR_ENABLE_WOL);
>  		if (ret)
>  			return ret;
> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>  	} else {
> +		/* Disable WoL function */
> +		ret = phy_modify_mmd(phydev, MDIO_MMD_PCS, AT803X_PHY_MMD3_WOL_CTRL,
> +				AT803X_WOL_EN, 0);
> +		if (ret)
> +			return ret;
> +		/* Disable WOL interrupt */
>  		ret = phy_modify(phydev, AT803X_INTR_ENABLE, AT803X_INTR_ENABLE_WOL, 0);
>  		if (ret)
>  			return ret;
> -		value = phy_read(phydev, AT803X_INTR_STATUS);
>  	}
>  
> -	return ret;
> +	/* Clear WOL status */
> +	return phy_read(phydev, AT803X_INTR_STATUS);

It looks like you could be clearing other interrupt bits which have
not been serviced yet. Is it possible to clear just WoL?

Also, you are returning the contents of the interrupt status register?
You should probably be returning 0 if the read was successful.

    Andrew
