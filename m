Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5C535829
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 06:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbiE0EAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 00:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiE0EAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 00:00:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F72E27A8;
        Thu, 26 May 2022 21:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AF88B82281;
        Fri, 27 May 2022 04:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A33C385A9;
        Fri, 27 May 2022 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653624046;
        bh=AIn4JDCvAfCC2uEkwjg1qq8LYA0cehvmuztjXF/NZcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aRsOSLBvnd62P0sGwVb67mpQvRy4aPsy1ClDRfM2GmGBhWWxCfVeafDNxmpiTs0WM
         kUyVfzVnLYg+nAcs3fq+jsNRAfx+toFcYiz7qCVhD5B1gLWAYDxFQH1J8Jx9hMGN0A
         UZISU+Ybd60FbtMKglpZ8+wdzDwIpHSk+4gO8DAysauLnnD0KF/xlVOYmE5rAoJ8aA
         vFc4jSMkDkaqwsJQqMptP/AW2tMU8S6C5gIQrShcgFsL6lLHVsDYmohpKBfa3MRYIx
         xpbZV4nKpSjO+m3vqkpTLelcgmDS1hZelYMjZqFoG4kugeSv2+Z73ZfnUELw9HMkro
         abTGLhuKi6Itg==
Date:   Thu, 26 May 2022 21:00:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Luo Jie <luoj@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Viorel Suman <viorel.suman@nxp.com>
Subject: Re: [PATCH] net: phy: at803x: disable WOL at probe
Message-ID: <20220526210044.638128f6@kernel.org>
In-Reply-To: <20220525103657.22384-1-viorel.suman@oss.nxp.com>
References: <20220525103657.22384-1-viorel.suman@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 13:36:57 +0300 Viorel Suman (OSS) wrote:
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 73926006d319..6277d1b1d814 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -443,10 +443,10 @@ static int at803x_set_wol(struct phy_device *phydev,
>  		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
>  	};
>  
> -	if (!ndev)
> -		return -ENODEV;
> -
>  	if (wol->wolopts & WAKE_MAGIC) {
> +		if (!ndev)
> +			return -ENODEV;

Please move the ndev variable into the scope.
It'll make it clear that it can't be used elsewhere
in this function.

>  		mac = (const u8 *) ndev->dev_addr;
>  
>  		if (!is_valid_ether_addr(mac))
> @@ -857,6 +857,9 @@ static int at803x_probe(struct phy_device *phydev)
>  	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
>  		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
>  		int mode_cfg;
> +		struct ethtool_wolinfo wol = {
> +			.wolopts = 0,
> +		};
>  
>  		if (ccr < 0)
>  			goto err;
> @@ -872,6 +875,13 @@ static int at803x_probe(struct phy_device *phydev)
>  			priv->is_fiber = true;
>  			break;
>  		}
> +
> +		/* Disable WOL by default */
> +		ret = at803x_set_wol(phydev, &wol);
> +		if (ret < 0) {
> +			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
> +			return ret;

Don't you need to goto err; here?

> +		}
>  	}
>  
>  	return 0;
