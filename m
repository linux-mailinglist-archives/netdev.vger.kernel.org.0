Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECAD4D7214
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 02:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiCMBTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 20:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiCMBTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 20:19:05 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF0C140CC;
        Sat, 12 Mar 2022 17:17:58 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 220F722239;
        Sun, 13 Mar 2022 02:17:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647134276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksdj/ixqaiIjLynzM+T/FDDg69VmFfwpwPCW3aBfahI=;
        b=F419Ni3r/GFuqV6+thZoXy8OnN0iXLYHFSEbmLQ5JTiEX/06Upg0FmfhxSB4V1Pf809Qr7
        vkc0/1h+Lr9TckZWltJXQeOmUWbrtf+jX7VaALMGHHanp1H0S4hmWMTqIq1ZQUgGfKE/L7
        vTP3tfq4VDy6k9L61wsfxJzEW/Ed1xQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 13 Mar 2022 02:17:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: mdio: mscc-miim: replace magic numbers
 for the bus reset
In-Reply-To: <Yi1ALN6hN9aV1VrA@lunn.ch>
References: <20220313002153.11280-1-michael@walle.cc>
 <20220313002153.11280-3-michael@walle.cc> <Yi1ALN6hN9aV1VrA@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7cbe529d46c64b01eb99c016d9f16f1a@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-13 01:51, schrieb Andrew Lunn:
>> diff --git a/drivers/net/mdio/mdio-mscc-miim.c 
>> b/drivers/net/mdio/mdio-mscc-miim.c
>> index 64fb76c1e395..7773d5019e66 100644
>> --- a/drivers/net/mdio/mdio-mscc-miim.c
>> +++ b/drivers/net/mdio/mdio-mscc-miim.c
>> @@ -158,18 +158,18 @@ static int mscc_miim_reset(struct mii_bus *bus)
>>  {
>>  	struct mscc_miim_dev *miim = bus->priv;
>>  	int offset = miim->phy_reset_offset;
>> +	int mask = PHY_CFG_PHY_ENA | PHY_CFG_PHY_COMMON_RESET |
>> +		   PHY_CFG_PHY_RESET;
> 
>> -		ret = regmap_write(miim->phy_regs,
>> -				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
>> +		ret = regmap_write(miim->phy_regs, offset, mask);
> 
> Is mask the correct name? It is not being used in the typical way for
> a mask.

It is the mask of all the reset bits, see also patch 3/3. Either all
these bits are set or none. Do you have any suggestion? I thought about
adding mask and value for the remap_update_bits() in patch 3/3 but
decided against it, just because it doesn't add any value because
mask and value are the same.

-michael
