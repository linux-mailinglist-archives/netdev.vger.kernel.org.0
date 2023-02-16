Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF66B698D51
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBPGpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPGpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:45:39 -0500
Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E73A131
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 22:45:38 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id SY1Nph9XNm8TdSY1NpF4Iy; Thu, 16 Feb 2023 07:45:36 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 16 Feb 2023 07:45:36 +0100
X-ME-IP: 86.243.2.178
Message-ID: <95af8972-478f-12b8-efea-30c7e249f449@wanadoo.fr>
Date:   Thu, 16 Feb 2023 07:45:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: mdio: thunder: Do not unregister buses that have not
 been registered
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Daney <david.daney@cavium.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <918382e19fdeb172f3836234d07e706460b7d06b.1620906605.git.christophe.jaillet@wanadoo.fr>
 <20210513121634.GX1336@shell.armlinux.org.uk>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20210513121634.GX1336@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2021 à 14:16, Russell King - ARM Linux admin a écrit :
> On Thu, May 13, 2021 at 01:51:40PM +0200, Christophe JAILLET wrote:
>> In the probe, if 'of_mdiobus_register()' fails, 'nexus->buses[i]' will
>> still have a non-NULL value.
>> So in the remove function, we will try to unregister a bus that has not
>> been registered.
>>
>> In order to avoid that NULLify 'nexus->buses[i]'.
>> 'oct_mdio_writeq(0,...)' must also be called here.
>>
>> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Calling 'devm_mdiobus_free()' would also be cleaner, IMHO.
>> I've not added it because:
>>     - it should be fine, even without it
>>     - I'm not sure how to use it
> 
> devm_mdiobus_free() is a static function not intended to be used by
> drivers. There is no devm.*free() function available for this, so
> this memory will only ever be freed when either probe fails or the
> driver is unbound from its device.
> 
> That should be fine, but it would be nice to give that memory back
> to the system. Without having a function for drivers to use though,
> that's not possible. Such a function should take a struct device
> pointer and the struct mii_bus pointer returned by the devm
> allocation function.
> 
> So, unless Andrew things we really need to free that, what you're
> doing below should be fine as far as setting the pointer to NULL.
> 
> I think I'd want comments from Cavium on setting the register to
> zero - as we don't know how this hardware behaves, and whether that
> would have implications we aren't aware of. So, I'm copying in
> David Daney (the original driver author) for comment, if his email
> address still works!

Hi,

drivers/net/mdio/mdio-thunder.c has been touched recently, so i take the 
opportunity to ping on this old patch.

It does not cleanly apply anymore, but still look valid to me.

CJ

> 
>> ---
>>   drivers/net/mdio/mdio-thunder.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
>> index 822d2cdd2f35..140c405d4a41 100644
>> --- a/drivers/net/mdio/mdio-thunder.c
>> +++ b/drivers/net/mdio/mdio-thunder.c
>> @@ -97,8 +97,14 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>>   		bus->mii_bus->write = cavium_mdiobus_write;
>>   
>>   		err = of_mdiobus_register(bus->mii_bus, node);
>> -		if (err)
>> +		if (err) {
>>   			dev_err(&pdev->dev, "of_mdiobus_register failed\n");
>> +			/* non-registered buses must not be unregistered in
>> +			 * the .remove function
>> +			 */
>> +			oct_mdio_writeq(0, bus->register_base + SMI_EN);
>> +			nexus->buses[i] = NULL;
>> +		}
>>   
>>   		dev_info(&pdev->dev, "Added bus at %llx\n", r.start);
>>   		if (i >= ARRAY_SIZE(nexus->buses))
>> -- 
>> 2.30.2
>>
>>
> 

