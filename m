Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EEA5B6B1C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiIMJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiIMJpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:45:17 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A82F14020;
        Tue, 13 Sep 2022 02:45:16 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2B3A51267;
        Tue, 13 Sep 2022 11:45:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1663062314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OmpEgagjlULRvJ/1pGA/OeRDk6objYeCwx870+1HYV4=;
        b=zi1mMMjGMptL+yo9NbTngbslzM5i/3Ybv0b1GMqp1BjLP8l5MtEgZ/YUmwMixCLBZSq+Zy
        U23gBduChTwYbo2uHOXTPpuMTnW6ep8xlR7JBYdW0B7WO5qHAlEFkkRcmBvj0euUjAnvZ+
        DtX6A8ItzbHR/SwD3IQsItfT0mHm9zxlrAukYNEjvnPemaXT96DhGYmDNP51Nai0ixwZgG
        QEbleSB9OR7wmHxuY85JD8aKOhlEmYNS7yb71nnMP1H3qmketClMw1iVRRSVCeuthb5zXR
        vGU1KLR4Okp980iCf/RegFPRw26UGzdrUm9qRUe7LkLg7lGpgPw8PXT4q1XtCQ==
From:   Michael Walle <michael@walle.cc>
To:     michael@walle.cc
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Add interrupts support for LAN8804 PHY
Date:   Tue, 13 Sep 2022 11:45:08 +0200
Message-Id: <20220913094508.222812-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220913081814.212548-1-michael@walle.cc>
References: <20220913081814.212548-1-michael@walle.cc>
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

>> Add support for interrupts for LAN8804 PHY.
>> 
>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>> ---
>>  drivers/net/phy/micrel.c | 55 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>> 
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>> index 7b8c5c8d013e..98e9bc101d96 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -2676,6 +2676,59 @@ static int lan8804_config_init(struct phy_device *phydev)
>>  	return 0;
>>  }
>>  
>> +static irqreturn_t lan8804_handle_interrupt(struct phy_device *phydev)
>> +{
>> +	int status;
>> +
>> +	status = phy_read(phydev, LAN8814_INTS);
>> +	if (status < 0) {
>> +		phy_error(phydev);
>> +		return IRQ_NONE;
>> +	}
>> +
>> +	if (status > 0)
>> +		phy_trigger_machine(phydev);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +#define LAN8804_OUTPUT_CONTROL			25
>> +#define LAN8804_OUTPUT_CONTROL_INTR_BUFFER	BIT(14)
>> +#define LAN8804_CONTROL				31
>> +#define LAN8804_CONTROL_INTR_POLARITY		BIT(14)
>> +
>> +static int lan8804_config_intr(struct phy_device *phydev)
>> +{
>> +	int err;
>> +
>> +	/* Change interrupt polarity */
>> +	phy_write(phydev, LAN8804_CONTROL, LAN8804_CONTROL_INTR_POLARITY);
>
> I assume you change the polarity to high active? Could you add a note?
> The LAN966x nor the LAN8804 datasheet describe this bit. You might also add
> a note, that this is an internal PHY and you cannot change the polarity on
> the GIC. Which begs the question, is this really only an internal PHY or
> can you actually buy it as a dedicated one. Then you'd change the polarity
> in a really unusual way.
> 
> 
> > +
> > +	/* Change interrupt buffer type */
> 
> To what? Push-pull?

Regardless of my remarks, the code itself is working fine:

Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10

-michael

> +	phy_write(phydev, LAN8804_OUTPUT_CONTROL,
> +		  LAN8804_OUTPUT_CONTROL_INTR_BUFFER);
> +

