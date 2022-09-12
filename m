Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA755B58BB
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILKvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiILKvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F1430546;
        Mon, 12 Sep 2022 03:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F07360C3C;
        Mon, 12 Sep 2022 10:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1788CC433D6;
        Mon, 12 Sep 2022 10:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662979881;
        bh=x1l0IDqQZ51UEurxy14dU5zvqq4g9UAFcH1HMygZUMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fxj8z/gR5MD47zuFVSSO478nUPnekHAm6fqAYLue2tCVGDiM3wk5uHK1/CIv2eXO+
         Wwyu7k/l+99TiwyfwOdMe/OwtVp2xsj/uucqLQSogz+loOAS1znBWBjFi1YEUqEw39
         dRnuCNNgK57b7qNz3VjVpbM4g7lhsrbfvjSlhqz/ziHddozLgkwQXV+Skt5SQYVhhd
         5N9x83v77Q7LkjANuenLswqIWAXAyM3w7itcfhiDUlr/WscHqF9msN0Re38HwkGw0E
         IgeuiojT8NrE8X6tXcLrCAYag8aWfVvpyEw41/m0OnWkbrxJT0zAHAakNTz8PCa70o
         Gk74XT8W6K+ww==
Date:   Mon, 12 Sep 2022 11:51:14 +0100
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <Yx8PIsInsR7oQqgh@google.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220911200244.549029-9-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Sep 2022, Colin Foster wrote:

> Add control of an external VSC7512 chip by way of the ocelot-mfd interface.
> 
> Currently the four copper phy ports are fully functional. Communication to
> external phys is also functional, but the SGMII / QSGMII interfaces are
> currently non-functional.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v1 from previous RFC:
>     * Remove unnecessary byteorder and kconfig header includes.
>     * Create OCELOT_EXT_PORT_MODE_SERDES macro to match vsc9959.
>     * Utilize readx_poll_timeout for SYS_RESET_CFG_MEM_INIT.
>     * *_io_res struct arrays have been moved to the MFD files.
>     * Changes to utilize phylink_generic_validate() have been squashed.
>     * dev_err_probe() is used in the probe function.
>     * Make ocelot_ext_switch_of_match static.
>     * Relocate ocelot_ext_ops structure to be next to vsc7512_info, to
>       match what was done in other felix drivers.
>     * Utilize dev_get_regmap() instead of the obsolete
>       ocelot_init_regmap_from_resource() routine.
> 
> ---
>  drivers/mfd/ocelot-core.c           |   3 +
>  drivers/net/dsa/ocelot/Kconfig      |  14 ++
>  drivers/net/dsa/ocelot/Makefile     |   5 +
>  drivers/net/dsa/ocelot/ocelot_ext.c | 254 ++++++++++++++++++++++++++++
>  include/soc/mscc/ocelot.h           |   2 +
>  5 files changed, 278 insertions(+)
>  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> 
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index aa7fa21b354c..b7b9f6855f74 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -188,6 +188,9 @@ static const struct mfd_cell vsc7512_devs[] = {
>  		.use_of_reg = true,
>  		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
>  		.resources = vsc7512_miim1_resources,
> +	}, {
> +		.name = "ocelot-ext-switch",
> +		.of_compatible = "mscc,vsc7512-ext-switch",
>  	},
>  };

Please separate this out into its own patch.

-- 
Lee Jones [李琼斯]
