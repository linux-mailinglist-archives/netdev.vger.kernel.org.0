Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3F488D82
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbiAJAnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbiAJAni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:43:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E881BC06173F;
        Sun,  9 Jan 2022 16:43:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E13BB80EB2;
        Mon, 10 Jan 2022 00:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11D9C36AE3;
        Mon, 10 Jan 2022 00:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641775415;
        bh=DmH7M5tRFpzsUho15Vfl8GOzZSKDrQsO+NphZsKjRzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dVEQZVvw4+aXfmrbaCeha9pUXDgrzWIW/lGiTDSlDegUr2oI2qMe8fIDAYm/kdmNK
         d9Hk/N1IsETmVVGyvi+mcg/wzrwYJgFidWGrlHR9CsVlUjvGAXH5+oU9pcJqUioNAa
         h4ZFdoeg5IGfWBgXJsNaE9xJMgftF7XIgPyMrhLhS2c3DMfAHuV0W3oUSXmEWWLvaY
         khC0FtMPJlv95ncdlj8eMudEbFLVhwhVbH6EkRs4dWwXEH3VAQnAsLj0ihOW7T6bm6
         Yb/AgSabCfvfUOeVzSQ3gIL5u3ZQQM8FGDzi8bfPPPjPheHgWXsm+A/1Du+VVXZq3G
         774u8bbBnKV+g==
Date:   Sun, 9 Jan 2022 16:43:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net,
        matthias.bgg@gmail.com, linux@armlinux.org.uk, nathan@kernel.org,
        ndesaulniers@google.com, opensource@vdorst.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix error checking in
 mtk_mac_config()
Message-ID: <20220109164333.61dc2e89@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220108155003.3991055-1-trix@redhat.com>
References: <20220108155003.3991055-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 07:50:03 -0800 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this problem
> mtk_eth_soc.c:394:7: warning: Branch condition evaluates
>   to a garbage value
>                 if (err)
>                     ^~~
> 
> err is not initialized and only conditionally set.
> Check err consistently with the rest of mtk_mac_config(),
> after even possible setting.
> 
> Fixes: 7e538372694b ("net: ethernet: mediatek: Re-add support SGMII")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index b67b4323cff08..a27e548488584 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -385,14 +385,16 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
>  		       0 : mac->id;
>  
>  		/* Setup SGMIISYS with the determined property */
> -		if (state->interface != PHY_INTERFACE_MODE_SGMII)
> +		if (state->interface != PHY_INTERFACE_MODE_SGMII) {
>  			err = mtk_sgmii_setup_mode_force(eth->sgmii, sid,
>  							 state);
> -		else if (phylink_autoneg_inband(mode))
> +			if (err)
> +				goto init_err;
> +		} else if (phylink_autoneg_inband(mode)) {
>  			err = mtk_sgmii_setup_mode_an(eth->sgmii, sid);
> -
> -		if (err)
> -			goto init_err;
> +			if (err)
> +				goto init_err;
> +		}
>  
>  		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
>  				   SYSCFG0_SGMII_MASK, val);

Why not init err to 0 before the if or add an else err = 0; branch?
