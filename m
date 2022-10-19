Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686FE604380
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJSLko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiJSLj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 07:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0923518DAA6;
        Wed, 19 Oct 2022 04:18:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C97E6176B;
        Wed, 19 Oct 2022 10:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14972C433D6;
        Wed, 19 Oct 2022 10:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666176065;
        bh=B6/i+zuHr8M8YUCl5dAojeyEr1/k0AiM1p2uxl25xx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tEDEaoFbXcvOR15+0B3Ox/PnYnpuM8GvrZl68oUKFqopE+DMQNg+Z/JlwyA5sAyTv
         71XLaUr2NDVAJDAUz1nJC8ZKHnMsE8O3hPU3gw+sGPFiKCs/i/B+qQIU+B6LZ8mgkt
         in8tn3dT7bWQ8+QPyDSvxqLhy1RCNLbEXNn9lFkCeJ9oY1DEPW0N1lFEOlkQ1fioCu
         ZR2D78gHSzME9geOD7LtTiIGhfHGTeoNql4MJfwKQ844WX2hQjL2gxFelQh0tf5Hp1
         08phjIkMSYBvUoJQ3Rh447M/5mNyn5lPpp8OUAeJZOTPV7DONfBOCLiBdqW6LoXYBl
         l5T+0+b7d1QIg==
Date:   Wed, 19 Oct 2022 12:41:00 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: renesas: rswitch: Pass host parameters to
 phydev
Message-ID: <20221019124100.41c9bbaf@dellmb>
In-Reply-To: <20221019085052.933385-4-yoshihiro.shimoda.uh@renesas.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
        <20221019085052.933385-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 17:50:52 +0900
Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:

> Use of_phy_connect_with_host_params() to pass host parameters to
> phydev. Otherwise, connected PHY cannot work correctly.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index c604331bfd88..bb2f1e667210 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -16,6 +16,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
> +#include <linux/phy.h>
>  #include <linux/phy/phy.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> @@ -1234,11 +1235,19 @@ static void rswitch_phy_remove_link_mode(struct rswitch_device *rdev,
>  
>  static int rswitch_phy_init(struct rswitch_device *rdev, struct device_node *phy)
>  {
> +	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
>  	struct phy_device *phydev;
>  	int err = 0;
>  
> -	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
> -				rdev->etha->phy_interface);
> +	phy_interface_zero(host_interfaces);
> +	if (rdev->etha->phy_interface == PHY_INTERFACE_MODE_SGMII)
> +		__set_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces);
> +
> +	phydev = of_phy_connect_with_host_params(rdev->ndev, phy,
> +						 rswitch_adjust_link, 0,
> +						 rdev->etha->phy_interface,
> +						 host_interfaces,
> +						 rdev->etha->speed);
>  	if (!phydev) {
>  		err = -ENOENT;
>  		goto out;

NAK. There already is API for doing this: phylink. Adding new, and so
much specific function for this is a waste. Just convert the rswitch
driver to phylink.

Please look at the documentation at
  Documentation/networking/sfp-phylink.rst

Marek
