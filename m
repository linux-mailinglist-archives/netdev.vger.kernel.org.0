Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF66E81AD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjDSTG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDSTGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:06:25 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2D40EC;
        Wed, 19 Apr 2023 12:06:21 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JJ658A056800;
        Wed, 19 Apr 2023 14:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681931165;
        bh=E+cjoie7RPKxaQf86Kyiqb8pq9K0t0ykgWwdaQ9rxoQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=qfIGhe4QdpZA2a4p3EkKA9wO5DkmbgZVQBH4iMoqMyMwCoL+eXmnY0QEHVHC7jYcj
         GR4UEgDWlCVZ3lbtfo06cI6cB3V+5iS2mVYGcHjQzmZ+hvR+I40ZpqL9bfpW2Fomgr
         zSfFqCDeMg2NDF71uk6QKI29HM9mn+1Yd9RbldwI=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JJ65eW057983
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 14:06:05 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 14:06:05 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 14:06:04 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JJ64lN081689;
        Wed, 19 Apr 2023 14:06:04 -0500
Message-ID: <fb137f96-b1a1-30ee-cd92-d52f1f0f76d7@ti.com>
Date:   Wed, 19 Apr 2023 14:06:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-6-jm@ti.com>
 <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230414-bounding-guidance-262dffacd05c-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On 4/14/2023 1:20 PM, Marc Kleine-Budde wrote:
> On 13.04.2023 17:30:51, Judith Mendez wrote:
>> Add a hrtimer to MCAN struct. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
> 
> Are you sure about the 1ms?
> 
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>>   drivers/net/can/m_can/m_can.c          | 24 ++++++++++++++++++++++--
>>   drivers/net/can/m_can/m_can.h          |  3 +++
>>   drivers/net/can/m_can/m_can_platform.c |  9 +++++++--
>>   3 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index 8e83d6963d85..bb9d53f4d3cc 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/pinctrl/consumer.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/hrtimer.h>
>>   
>>   #include "m_can.h"
>>   
>> @@ -1584,6 +1585,11 @@ static int m_can_close(struct net_device *dev)
>>   	if (!cdev->is_peripheral)
>>   		napi_disable(&cdev->napi);
>>   
>> +	if (dev->irq < 0) {
>> +		dev_info(cdev->dev, "Disabling the hrtimer\n");
> 
> Make it a dev_dbg() or remove completely.
> 

Will do, thanks.

>> +		hrtimer_cancel(&cdev->hrtimer);
>> +	}
>> +
>>   	m_can_stop(dev);
>>   	m_can_clk_stop(cdev);
>>   	free_irq(dev->irq, dev);
>> @@ -1792,6 +1798,19 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
>> +{
>> +	irqreturn_t ret;
> 
> never read value?
> 

I have removed ret completely now.

>> +	struct m_can_classdev *cdev =
>> +		container_of(timer, struct m_can_classdev, hrtimer);
>> +
>> +	ret = m_can_isr(0, cdev->net);
>> +
>> +	hrtimer_forward_now(timer, ns_to_ktime(5 * NSEC_PER_MSEC));
> 
> There's ms_to_ktime()....and the "5" doesn't match your patch
> description.
> 
>> +
>> +	return HRTIMER_RESTART;
>> +}
>> +
>>   static int m_can_open(struct net_device *dev)
>>   {
>>   	struct m_can_classdev *cdev = netdev_priv(dev);
>> @@ -1836,8 +1855,9 @@ static int m_can_open(struct net_device *dev)
>>   	}
>>   
>>   	if (err < 0) {
>> -		netdev_err(dev, "failed to request interrupt\n");
>> -		goto exit_irq_fail;
>> +		dev_info(cdev->dev, "Enabling the hrtimer\n");
>> +		cdev->hrtimer.function = &hrtimer_callback;
>> +		hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);
> 
> IMHO it makes no sense to request an IRQ if the device doesn't have one,
> and then try to fix up things in the error path. What about this?
> 
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -1831,9 +1831,11 @@ static int m_can_open(struct net_device *dev)
>                   err = request_threaded_irq(dev->irq, NULL, m_can_isr,
>                                              IRQF_ONESHOT,
>                                              dev->name, dev);
> -        } else {
> +        } else if (dev->irq) {
>                   err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>                                     dev);
> +        } else {
> +                // polling
>           }
>   
>           if (err < 0) {
> 
>>   	}

Thanks for the recommendation, I will include in v2.

>>   
>>   	/* start the m_can controller */
>> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
>> index a839dc71dc9b..ed046d77fdb9 100644
>> --- a/drivers/net/can/m_can/m_can.h
>> +++ b/drivers/net/can/m_can/m_can.h
>> @@ -28,6 +28,7 @@
>>   #include <linux/pm_runtime.h>
>>   #include <linux/slab.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/hrtimer.h>
>>   
>>   /* m_can lec values */
>>   enum m_can_lec_type {
>> @@ -93,6 +94,8 @@ struct m_can_classdev {
>>   	int is_peripheral;
>>   
>>   	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> +
>> +	struct hrtimer hrtimer;
>>   };
>>   
>>   struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>> index 9c1dcf838006..53e1648e9dab 100644
>> --- a/drivers/net/can/m_can/m_can_platform.c
>> +++ b/drivers/net/can/m_can/m_can_platform.c
>> @@ -7,6 +7,7 @@
>>   
>>   #include <linux/phy/phy.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/hrtimer.h>
>>   
>>   #include "m_can.h"
>>   
>> @@ -98,8 +99,12 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>   	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>>   	irq = platform_get_irq_byname(pdev, "int0");
>>   	if (IS_ERR(addr) || irq < 0) {
> 
> What about the IS_ERR(addr) case?
> 

Added, thanks.

>> -		ret = -EINVAL;
>> -		goto probe_fail;
>> +		if (irq == -EPROBE_DEFER) {
>> +			ret = -EPROBE_DEFER;
>> +			goto probe_fail;
>> +		}
>> +		dev_info(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
>> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
> 
> I don't like it when polling is unconditionally set up in case of an irq
> error. I'm not sure if we need an explicit device tree property....

This is an interesting thought, I would definitely like to look more 
into this. Though I am thinking it would be part of future optimization 
patch. Thanks so much for your recommendation.

regards,
Judith
