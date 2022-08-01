Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C85863B9
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 07:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbiHAFL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 01:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239333AbiHAFLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 01:11:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B48B865
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 22:11:54 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oINiL-0003hP-Ai; Mon, 01 Aug 2022 07:11:37 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oINiJ-0006ut-6u; Mon, 01 Aug 2022 07:11:35 +0200
Date:   Mon, 1 Aug 2022 07:11:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 09/10] net: dsa: microchip: add regmap_range
 for KSZ8563 chip
Message-ID: <20220801051135.GB4662@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-10-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:45PM +0200, Oleksij Rempel wrote:
> Add register validation for KSZ8563.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 131 +++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index d3a9836c706f..97b5fb75b489 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -412,6 +412,135 @@ static const u8 lan937x_shifts[] = {
>  	[ALU_STAT_INDEX]		= 8,
>  };
>  
> +static const struct regmap_range ksz8563_valid_regs[] = {
> +	regmap_reg_range(0x0000, 0x0003),
> +	regmap_reg_range(0x0006, 0x0006),
> +	regmap_reg_range(0x000f, 0x001f),
> +	regmap_reg_range(0x0100, 0x0100),
> +	regmap_reg_range(0x0104, 0x0107),
> +	regmap_reg_range(0x010d, 0x010d),
> +	regmap_reg_range(0x0110, 0x0113),
> +	regmap_reg_range(0x0120, 0x012b),
> +	regmap_reg_range(0x0201, 0x0201),
> +	regmap_reg_range(0x0210, 0x0213),
> +	regmap_reg_range(0x0300, 0x0300),
> +	regmap_reg_range(0x0302, 0x031b),
> +	regmap_reg_range(0x0320, 0x032b),
> +	regmap_reg_range(0x0330, 0x0336),
> +	regmap_reg_range(0x0338, 0x033e),
> +	regmap_reg_range(0x0340, 0x035f),
> +	regmap_reg_range(0x0370, 0x0370),
> +	regmap_reg_range(0x0378, 0x0378),
> +	regmap_reg_range(0x037c, 0x037d),
> +	regmap_reg_range(0x0390, 0x0393),
> +	regmap_reg_range(0x0400, 0x040e),
> +	regmap_reg_range(0x0410, 0x042f),
> +	regmap_reg_range(0x0500, 0x0519),
> +	regmap_reg_range(0x0520, 0x054b),
> +	regmap_reg_range(0x0550, 0x05b3),
> +
> +	/* port 1 */
> +	regmap_reg_range(0x1000, 0x1001),
> +	regmap_reg_range(0x1004, 0x100b),
> +	regmap_reg_range(0x1013, 0x1013),
> +	regmap_reg_range(0x1017, 0x1017),
> +	regmap_reg_range(0x101b, 0x101b),
> +	regmap_reg_range(0x101f, 0x1021),
> +	regmap_reg_range(0x1030, 0x1030),
> +	regmap_reg_range(0x1100, 0x1111),
> +	regmap_reg_range(0x111a, 0x111d),
> +	regmap_reg_range(0x1122, 0x1127),
> +	regmap_reg_range(0x112a, 0x112b),
> +	regmap_reg_range(0x1136, 0x1139),
> +	regmap_reg_range(0x113e, 0x113f),
> +	regmap_reg_range(0x1300, 0x1301),
> +	regmap_reg_range(0x1303, 0x1303),

Some of this register are not supported on port 1 and 2. I'll send new
version of this patches.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
