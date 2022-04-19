Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F4F506BFC
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349840AbiDSMOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352260AbiDSMNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:13:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A52377DD;
        Tue, 19 Apr 2022 05:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1lvxcKnGXEZSQ46qlcZLm8oKI0iNua4Tz0vIoesYXjY=; b=FKaywvYRPXa1OdccTJp0XgAWdH
        NajyWXuVIKm8rnPSk0vcaA4ZjwhurC8x2ybsH/rX9v+/rspbd4eFQ14BkZefitsVlI8dYf4XSy8xg
        7x7zC6md/9FuDbjiAeGqRL6h/5tGHjPyV3KB3XTFspUGg+JfJWlVKTZMBROwmxKCc3xI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngmeF-00GUaa-9X; Tue, 19 Apr 2022 14:07:59 +0200
Date:   Tue, 19 Apr 2022 14:07:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: phy: fix error check return value of phy_read()
Message-ID: <Yl6mH0HKCGPxgejI@lunn.ch>
References: <20220419014439.2561835-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419014439.2561835-1-lv.ruyi@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:44:39AM +0000, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> phy_read() returns a negative number if there's an error, but the
> error-checking code in the bcm87xx driver's config_intr function
> triggers if phy_read() returns non-zero.  Correct that.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
>  drivers/net/phy/bcm87xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
> index 313563482690..e62b53718010 100644
> --- a/drivers/net/phy/bcm87xx.c
> +++ b/drivers/net/phy/bcm87xx.c
> @@ -146,7 +146,7 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
>  
>  	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
>  		err = phy_read(phydev, BCM87XX_LASI_STATUS);
> -		if (err)
> +		if (err < 0)
>  			return err;

This should probably have a Fixes: tag, and be for net, not next-next.
Please read the netdev FAQ about the trees, and submittinng fixes for
netdev.

     Andrew
