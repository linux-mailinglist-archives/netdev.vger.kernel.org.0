Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75C5B6956
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiIMISX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiIMISW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:18:22 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F005E24973;
        Tue, 13 Sep 2022 01:18:20 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D4F35135F;
        Tue, 13 Sep 2022 10:18:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1663057099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQvQeAgjxqYSjCBCPv4uH0vSfQc2xCoC/J0gxV+KP7I=;
        b=uVhboh596FH2yBLqUi1e0iXmW6/Px6RnnXGnJ7kY2BHZwi/PEGaRkVl2ClDGN/248sQLWV
        Ay9WTamRlVr9my5knVSeSLCd1joTsdRrCtgA392Ok7en1uDmBbAfUV71YKGbcjqcblWW7y
        HjZTmQUOfQKCadVlBRW7MH1sSNN4Q4pz1/qBtFxNBjFI8vyqyZmg3SpTnUpGpmzTcDAsqa
        Ff/3LGYF1sKL4fEA0LOEClzEeYaEHh7ayTdH3dkmwo1l7LKhcwrg/LDGPzcGf0J3eeE+tH
        MiQLeDbHjBHMacQUFZ4IwzQUOEdgX4b5XZC4mG9do3Wtu2hGfMQR7X0nzcAQew==
From:   Michael Walle <michael@walle.cc>
To:     horatiu.vultur@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next] net: phy: micrel: Add interrupts support for LAN8804 PHY
Date:   Tue, 13 Sep 2022 10:18:14 +0200
Message-Id: <20220913081814.212548-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220912195650.466518-1-horatiu.vultur@microchip.com>
References: <20220912195650.466518-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Add support for interrupts for LAN8804 PHY.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 55 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 7b8c5c8d013e..98e9bc101d96 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2676,6 +2676,59 @@ static int lan8804_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static irqreturn_t lan8804_handle_interrupt(struct phy_device *phydev)
> +{
> +	int status;
> +
> +	status = phy_read(phydev, LAN8814_INTS);
> +	if (status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (status > 0)
> +		phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +#define LAN8804_OUTPUT_CONTROL			25
> +#define LAN8804_OUTPUT_CONTROL_INTR_BUFFER	BIT(14)
> +#define LAN8804_CONTROL				31
> +#define LAN8804_CONTROL_INTR_POLARITY		BIT(14)
> +
> +static int lan8804_config_intr(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	/* Change interrupt polarity */
> +	phy_write(phydev, LAN8804_CONTROL, LAN8804_CONTROL_INTR_POLARITY);

I assume you change the polarity to high active? Could you add a note?
The LAN966x nor the LAN8804 datasheet describe this bit. You might also add
a note, that this is an internal PHY and you cannot change the polarity on
the GIC. Which begs the question, is this really only an internal PHY or
can you actually buy it as a dedicated one. Then you'd change the polarity
in a really unusual way.


> +
> +	/* Change interrupt buffer type */

To what? Push-pull?

-michael

> +	phy_write(phydev, LAN8804_OUTPUT_CONTROL,
> +		  LAN8804_OUTPUT_CONTROL_INTR_BUFFER);
> +
