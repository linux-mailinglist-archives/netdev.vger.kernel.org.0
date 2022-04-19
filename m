Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028B2506BCD
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352121AbiDSMK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352082AbiDSMIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:08:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED75C26DD;
        Tue, 19 Apr 2022 05:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5JWhLeTB4wi0TWyHnu2YXPCax/xAcgAg18R1b4GZpGE=; b=NcdtVk50z/MBZUnZfXA/7vbdbe
        ShWKeP9L5J0d2Sa2IO1sVXTTIV5lizuN8Spn++/JMBfe9t93eMWCes+gTuHDv1LJzjTcsCWwPvMW9
        bq+aemd/fKe6VD1cH6kiwNufTbMh5UVhOqU6a3VpVEdqYALzVW2k+psJ2DXMz2sJl9gs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngmZu-00GUXR-8X; Tue, 19 Apr 2022 14:03:30 +0200
Date:   Tue, 19 Apr 2022 14:03:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix error check return value
 of debugfs_create_dir()
Message-ID: <Yl6lEsruT1pJ+ir8@lunn.ch>
References: <20220419014056.2561750-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419014056.2561750-1-lv.ruyi@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:40:56AM +0000, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> If an error occurs, debugfs_create_file() will return ERR_PTR(-ERROR),
> so use IS_ERR() to check it.
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
> index a81d3fd1a439..0c284c18a8d7 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
> @@ -165,7 +165,7 @@ void mtk_wed_hw_add_debugfs(struct mtk_wed_hw *hw)
>  
>  	snprintf(hw->dirname, sizeof(hw->dirname), "wed%d", hw->index);
>  	dir = debugfs_create_dir(hw->dirname, NULL);
> -	if (!dir)
> +	if (IS_ERR(dir))
>  		return;

You should not check the return value from any debugfs calls.

If Zeal bot is saying you should, Zeal is broken/does not understand
debugfs.

   Andrew
