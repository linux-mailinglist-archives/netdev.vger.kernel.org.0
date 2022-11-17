Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D75062DD61
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbiKQN60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiKQN6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:58:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED11B958F;
        Thu, 17 Nov 2022 05:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dBOuPLoqufhzIHBhnUrPowMnSxcJ7fbtffIk2nq1bjg=; b=fSqHKi4WOAW4udDRU9cRTFDk06
        B3rT7dae00kRrk2M01L7pc8FOj7VIDtBLcc3RujXzDeozXwLo4eGtEGAx10PgHlibSlADFSq1SgoS
        6yqp1ez6q8Eq/F+9dVFdF1Kf3FTVkSNRZgKqbi6XruOHDYhrWDi2T0QWn48c2rAev104=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovfOt-002h7i-JB; Thu, 17 Nov 2022 14:57:55 +0100
Date:   Thu, 17 Nov 2022 14:57:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yusongping@huawei.com
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
Message-ID: <Y3Y94/My9Al4pw+h@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117090514.118296-1-tanghui20@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 05:05:14PM +0800, Hui Tang wrote:
> priv->eth_ldo_rdy is saved the return value of devm_ioremap_resource(),
> which !IS_ERR() should be used to check.
> 
> Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
> Signed-off-by: Hui Tang <tanghui20@huawei.com>
> ---
> v1 -> v2: set priv->eth_ldo_rdy NULL, if devm_ioremap_resource() failed
> ---
>  drivers/net/mdio/mdio-ipq4019.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
> index 4eba5a91075c..dfd1647eac36 100644
> --- a/drivers/net/mdio/mdio-ipq4019.c
> +++ b/drivers/net/mdio/mdio-ipq4019.c
> @@ -231,8 +231,11 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>  	/* The platform resource is provided on the chipset IPQ5018 */
>  	/* This resource is optional */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (res)
> +	if (res) {
>  		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(priv->eth_ldo_rdy))
> +			priv->eth_ldo_rdy = NULL;
> +	}

As i said, please add devm_ioremap_resource_optional().  Follow the
concept of devm_clk_get_optional(), devm_gpiod_get_optional(),
devm_reset_control_get_optional(), devm_reset_control_get_optional(),
platform_get_irq_byname_optional() etc.

All these will not return an error if the resource you are trying to
get does not exist. They instead return NULL, or something which other
API members understand as does not exist, but thats O.K.

These functions however do return errors for real problem, ENOMEM,
EINVAL etc. These should not be ignored.

You should then use this new function for all your other patches where
the resource is optional.

       Andrew
