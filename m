Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0358F803
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 09:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiHKHAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiHKHAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 03:00:37 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCD629817;
        Thu, 11 Aug 2022 00:00:35 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27B705Jv069485;
        Thu, 11 Aug 2022 02:00:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660201205;
        bh=ip7Z7++npAFNQklVD88uiIaYx0GA6sMVYP8RDrD+Dlg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=MCsdobzlKdfD6Ulpqq7P5xIIxIQVtIFe/XFfzsPnhCG4JRfZq2Ud3d4GRYaJ1Ozbm
         MDjHA8awaP7Vo/piMo0hXhsem+Zzw10npMWOD/JTBgVbGt0IcpCdh+wkQe3O5xiFqb
         O0z8mY9K+nybscCmpzCKN1oZba28phSU2pcptkJU=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27B705ia056567
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Aug 2022 02:00:05 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 11
 Aug 2022 02:00:04 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 11 Aug 2022 02:00:05 -0500
Received: from [10.24.69.79] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27B7018j032239;
        Thu, 11 Aug 2022 02:00:02 -0500
Message-ID: <9d17ab9f-1679-4af1-f85c-a538cb330d7b@ti.com>
Date:   Thu, 11 Aug 2022 12:30:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <vigneshr@ti.com>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
 <YvRNpAdG7/edUEc+@lunn.ch>
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <YvRNpAdG7/edUEc+@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/08/22 6:00 am, Andrew Lunn wrote:
>> +static int davinci_mdiobb_read(struct mii_bus *bus, int phy, int reg)
>> +{
>> +	int ret;
>> +	struct mdiobb_ctrl *ctrl = bus->priv;
>> +	struct davinci_mdio_data *data;
>> +
>> +	data = container_of(ctrl, struct davinci_mdio_data, bb_ctrl);
>> +
>> +	if (phy & ~PHY_REG_MASK || reg & ~PHY_ID_MASK)
>> +		return -EINVAL;
> 
> You don't need this. Leave it up to the bit banging code to do the
> validation. This also breaks C45, which the bit banging code can do,
> and it looks like the hardware cannot.

I will remove these validation.

>> +
>> +	ret = pm_runtime_resume_and_get(data->dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = mdiobb_read(bus, phy, reg);
>> +
>> +	pm_runtime_mark_last_busy(data->dev);
>> +	pm_runtime_put_autosuspend(data->dev);
> 
> Once you take the validation out, this function then all becomes about
> runtime power management. Should the bit banging core actually be
> doing this? It seems like it is something which could be useful for
> other devices.
> 
> struct mii_bus has a parent member. If set, you could apply these run
> time PM functions to that. Please add a patch to modify the core bit
> banging code, and then you should be able to remove these helpers.

Devices may or may not be configured for runtime autosuspend, and 
perhaps may not even use runtime PM. pm_runtime_enabled() and the 
autosuspend configuration could be addressed by checking against 
dev->power.use_autosuspend flag. But if the runtime PM functions are 
added to the bit banging core, would it not restrict the usage of 
pm_runtime_put_*() variants for others?

There is atleast one device sh_eth, which is not configured for 
autosuspend but uses the bit bang core in sh_mdiobb_read() and invokes 
regular runtime PM functions.

>>   static int davinci_mdio_probe(struct platform_device *pdev)
>>   {
>>   	struct mdio_platform_data *pdata = dev_get_platdata(&pdev->dev);
>> @@ -340,12 +535,30 @@ static int davinci_mdio_probe(struct platform_device *pdev)
>>   	struct phy_device *phy;
>>   	int ret, addr;
>>   	int autosuspend_delay_ms = -1;
>> +	const struct soc_device_attribute *soc_match_data;
> 
> netdev uses reverse christmas tree. Variables should be sorted longest
> first, shortest last.

Noted. I will fix this as well.


-- 
Regards,
Ravi
