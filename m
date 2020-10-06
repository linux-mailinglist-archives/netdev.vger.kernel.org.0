Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7119C285442
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 00:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgJFWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 18:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgJFWCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 18:02:55 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D82C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 15:02:54 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5Wg05Ck0z1sPqZ;
        Wed,  7 Oct 2020 00:02:44 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5Wfr25c3z1qqkD;
        Wed,  7 Oct 2020 00:02:44 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id tgmV8edPjSCT; Wed,  7 Oct 2020 00:02:42 +0200 (CEST)
X-Auth-Info: Zp5K9zGhXz5eMCqHzvN7tPMqF4Y7AUIHUHFAEyIzXHI=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed,  7 Oct 2020 00:02:42 +0200 (CEST)
Subject: Re: [PATCH] net: fec: Fix phy_device lookup for
 phy_reset_after_clk_enable()
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Richard Leitner <richard.leitner@skidata.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20201006202029.254212-1-marex@denx.de>
 <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <9f882603-2419-5931-fe8f-03c2a28ac785@denx.de>
Date:   Wed, 7 Oct 2020 00:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <110b63bb-9096-7ce0-530f-45dffed09077@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 11:09 PM, Florian Fainelli wrote:
> 
> 
> On 10/6/2020 1:20 PM, Marek Vasut wrote:
>> The phy_reset_after_clk_enable() is always called with ndev->phydev,
>> however that pointer may be NULL even though the PHY device instance
>> already exists and is sufficient to perform the PHY reset.
>>
>> If the PHY still is not bound to the MAC, but there is OF PHY node
>> and a matching PHY device instance already, use the OF PHY node to
>> obtain the PHY device instance, and then use that PHY device instance
>> when triggering the PHY reset.
>>
>> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable()
>> support")
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: NXP Linux Team <linux-imx@nxp.com>
>> Cc: Richard Leitner <richard.leitner@skidata.com>
>> Cc: Shawn Guo <shawnguo@kernel.org>
>> ---
>>   drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++++++++--
>>   1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>> b/drivers/net/ethernet/freescale/fec_main.c
>> index 2d5433301843..5a4b20941aeb 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -1912,6 +1912,24 @@ static int fec_enet_mdio_write(struct mii_bus
>> *bus, int mii_id, int regnum,
>>       return ret;
>>   }
>>   +static void fec_enet_phy_reset_after_clk_enable(struct net_device
>> *ndev)
>> +{
>> +    struct fec_enet_private *fep = netdev_priv(ndev);
>> +    struct phy_device *phy_dev = ndev->phydev;
>> +
>> +    /*
>> +     * If the PHY still is not bound to the MAC, but there is
>> +     * OF PHY node and a matching PHY device instance already,
>> +     * use the OF PHY node to obtain the PHY device instance,
>> +     * and then use that PHY device instance when triggering
>> +     * the PHY reset.
>> +     */
>> +    if (!phy_dev && fep->phy_node)
>> +        phy_dev = of_phy_find_device(fep->phy_node);
> 
> Don't you need to put the phy_dev reference at some point?

Probably, yes.

But first, does this approach and this patch even make sense ?
I mean, it fixes my problem, but is this right ?
