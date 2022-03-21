Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9F64E21EA
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 09:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbiCUIRU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Mar 2022 04:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345155AbiCUIRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 04:17:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A766122997
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 01:15:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWDBd-0004Zy-AB; Mon, 21 Mar 2022 09:14:45 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWDBW-0023Fj-7t; Mon, 21 Mar 2022 09:14:39 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWDBW-0001PK-AO; Mon, 21 Mar 2022 09:14:38 +0100
Message-ID: <84f2c72ced35506522ea3a6be72879d1699f885b.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] net: mdio: add reset deassertion for Aspeed MDIO
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Dylan Hung <dylan_hung@aspeedtech.com>, robh+dt@kernel.org,
        joel@jms.id.au, andrew@aj.id.au, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com, stable@vger.kernel.org
Date:   Mon, 21 Mar 2022 09:14:38 +0100
In-Reply-To: <20220321070131.23363-2-dylan_hung@aspeedtech.com>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
         <20220321070131.23363-2-dylan_hung@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dylan,

On Mo, 2022-03-21 at 15:01 +0800, Dylan Hung wrote:
> Add reset deassertion for Aspeed MDIO.  There are 4 MDIO controllers
> embedded in Aspeed AST2600 SOC and share one reset control register
> SCU50[3]. So devm_reset_control_get_shared is used in this change.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/mdio/mdio-aspeed.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-
> aspeed.c
> index e2273588c75b..8ac262a12d13 100644
> --- a/drivers/net/mdio/mdio-aspeed.c
> +++ b/drivers/net/mdio/mdio-aspeed.c
> @@ -3,6 +3,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/delay.h>
> +#include <linux/reset.h>
>  #include <linux/iopoll.h>
>  #include <linux/mdio.h>
>  #include <linux/module.h>
> @@ -37,6 +38,7 @@
>  
>  struct aspeed_mdio {
>         void __iomem *base;
> +       struct reset_control *reset;
>  };
>  
>  static int aspeed_mdio_read(struct mii_bus *bus, int addr, int
> regnum)
> @@ -120,6 +122,12 @@ static int aspeed_mdio_probe(struct
> platform_device *pdev)
>         if (IS_ERR(ctx->base))
>                 return PTR_ERR(ctx->base);
>  
> +       ctx->reset = devm_reset_control_get_shared(&pdev->dev, NULL);

The device tree bindings should have a required reset control property
documented before this is added.

> +       if (IS_ERR(ctx->reset))
> +               return PTR_ERR(ctx->reset);
> +
> +       reset_control_deassert(ctx->reset);
> +

This is missing a corresponding reset_control_assert() in
aspeed_mdio_remove() and in the error path of of_mdiobus_register().
That would allow to assert the reset line again after all MDIO
controllers are unbound.

regards
Philipp
