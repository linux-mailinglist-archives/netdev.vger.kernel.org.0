Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8B6EF82F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240792AbjDZQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjDZQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:12:04 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4E189;
        Wed, 26 Apr 2023 09:12:01 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33QGBDns128863;
        Wed, 26 Apr 2023 11:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682525473;
        bh=jgGajruGTIjdSoKqg0D5ZeNMF0HKGORjWDmcJFN4lP4=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=e9zKe/NQqFFykwLSKilqQtVmQP2O094qPoHi5sK+OafNe0stlbzbyn049vWu9ifhz
         WsAXP8LHPVvN0QPzbRPZVS+PaY+cToPv0jub/o1zZ7r4uus7ZLZ6ocsrmu7dsfQgiz
         fuEbVcm4N1eJJydgW9rH6M+04W7PsPv4ZHfj6J/g=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33QGBDdj027883
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Apr 2023 11:11:13 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Apr 2023 11:11:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 26 Apr 2023 11:11:12 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33QGBCtn019232;
        Wed, 26 Apr 2023 11:11:12 -0500
Message-ID: <0261131b-35b5-4570-0283-651432a9d537@ti.com>
Date:   Wed, 26 Apr 2023 11:11:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/4] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
References: <20230424195402.516-1-jm@ti.com> <20230424195402.516-2-jm@ti.com>
 <20230424-canon-primal-ece722b184d4-mkl@pengutronix.de>
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230424-canon-primal-ece722b184d4-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On 4/24/2023 3:14 PM, Marc Kleine-Budde wrote:
> On 24.04.2023 14:53:59, Judith Mendez wrote:
>> Add an hrtimer to MCAN class device. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found and
>> poll-interval property is defined in device tree M_CAN node.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
>> ---
>> Changelog:
>> v2:
>> 	1. Add poll-interval to MCAN class device to check if poll-interval propery is
>> 	present in MCAN node, this enables timer polling method.
>> 	2. Add 'polling' flag to MCAN class device to check if a device is using timer
>> 	polling method
>> 	3. Check if both timer polling and hardware interrupt are enabled for a MCAN
>> 	device, default to hardware interrupt mode if both are enabled.
>> 	4. Changed ms_to_ktime() to ns_to_ktime()
>> 	5. Removed newlines, tabs, and restructure if/else section.
>>
>>   drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++-----
>>   drivers/net/can/m_can/m_can.h          |  5 +++++
>>   drivers/net/can/m_can/m_can_platform.c | 31 ++++++++++++++++++++++++--
>>   3 files changed, 59 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
>> index a5003435802b..33e094f88da1 100644
>> --- a/drivers/net/can/m_can/m_can.c
>> +++ b/drivers/net/can/m_can/m_can.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/pinctrl/consumer.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/hrtimer.h>
> 
> keep the list of includes sorted
> 
Will do.
>>   
>>   #include "m_can.h"
>>   
>> @@ -1587,6 +1588,11 @@ static int m_can_close(struct net_device *dev)
>>   	if (!cdev->is_peripheral)
>>   		napi_disable(&cdev->napi);
>>   
>> +	if (cdev->polling) {
>> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
>> +		hrtimer_cancel(&cdev->hrtimer);
>> +	}
>> +
>>   	m_can_stop(dev);
>>   	m_can_clk_stop(cdev);
>>   	free_irq(dev->irq, dev);
>> @@ -1793,6 +1799,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
>>   	return NETDEV_TX_OK;
>>   }
>>   
>> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
>> +{
>> +	struct m_can_classdev *cdev =
>> +		container_of(timer, struct m_can_classdev, hrtimer);
>> +
>> +	m_can_isr(0, cdev->net);
>> +
>> +	hrtimer_forward_now(timer, ms_to_ktime(1));
> 
> Please create a define for this
> 
Thanks, will create a define for the 1 ms polling interval.

>> +
>> +	return HRTIMER_RESTART;
>> +}
>> +
>>   static int m_can_open(struct net_device *dev)
>>   {
>>   	struct m_can_classdev *cdev = netdev_priv(dev);
>> @@ -1827,13 +1845,15 @@ static int m_can_open(struct net_device *dev)
>>   		}
>>   
>>   		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
>> -
>>   		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
>> -					   IRQF_ONESHOT,
>> -					   dev->name, dev);
>> -	} else {
>> -		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>> +					   IRQF_ONESHOT, dev->name, dev);
>> +	} else if (!cdev->polling) {
>> +			err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>>   				  dev);
> 
> No need to change the indention
> 
Will fix.

>> +	} else {
>> +		dev_dbg(cdev->dev, "Start hrtimer\n");
>> +		cdev->hrtimer.function = &hrtimer_callback;
>> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(cdev->poll_interval), HRTIMER_MODE_REL_PINNED);
>>   	}
>>   
>>   	if (err < 0) {
>> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
>> index a839dc71dc9b..1ba87eb23f8e 100644
>> --- a/drivers/net/can/m_can/m_can.h
>> +++ b/drivers/net/can/m_can/m_can.h
>> @@ -28,6 +28,7 @@
>>   #include <linux/pm_runtime.h>
>>   #include <linux/slab.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/hrtimer.h>
> 
> keep the list of includes sorted
> 
>>   
>>   /* m_can lec values */
>>   enum m_can_lec_type {
>> @@ -93,6 +94,10 @@ struct m_can_classdev {
>>   	int is_peripheral;
>>   
>>   	struct mram_cfg mcfg[MRAM_CFG_NUM];
>> +
>> +	struct hrtimer hrtimer;
>> +	u32 poll_interval;
>> +	u8 polling;
> 
> bool
> 
Will use bool instead.
>>   };
>>   
>>   struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
>> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
>> index 9c1dcf838006..e899c04edc01 100644
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
>> @@ -97,11 +98,37 @@ static int m_can_plat_probe(struct platform_device *pdev)
>>   
>>   	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
>>   	irq = platform_get_irq_byname(pdev, "int0");
> 
> use platform_get_irq_byname_optional(), it doesn't print an error
> message.
> 
Thanks.

>> -	if (IS_ERR(addr) || irq < 0) {
>> -		ret = -EINVAL;
>> +	if (irq == -EPROBE_DEFER) {
>> +		ret = -EPROBE_DEFER;
>>   		goto probe_fail;
>>   	}
>>   
>> +	if (IS_ERR(addr)) {
>> +		ret = PTR_ERR(addr);
>> +		goto probe_fail;
>> +	}
> 
> please move the error check for "addr" directly after the "addr = "
> assignment.
> 
Will do.
>> +
>> +	mcan_class->polling = 0;
> 
> No need to init as "0"
> 

Awsome thanks.
>> +	if (device_property_present(mcan_class->dev, "poll-interval")) {
>> +		mcan_class->polling = 1;
>> +	}
> 
> No need for the { } here.
> 
>> +
>> +	if (!mcan_class->polling && irq < 0) {
>> +		ret = -ENODATA;
> -ENXIO
>> +		dev_dbg(mcan_class->dev, "Polling not enabled\n");
> 
> print a proper error message using dev_err_probe("IRQ %s not found and
> polling not activated\n")
> 
Why %s when MCAN requests 1 IRQ which is "int0"? If we want to print 
"int0", should it be hardcoded into the print error message?

>> +		goto probe_fail;
>> +	}
>> +
>> +	if (mcan_class->polling && irq > 0) {
>> +		mcan_class->polling = 0;
>> +		dev_dbg(mcan_class->dev, "Polling not enabled, hardware interrupt exists\n");
>> +	}
>> +
>> +	if (mcan_class->polling && irq < 0) {
>> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
>> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
>> +	}
> 
> combine both if (mcan_class->polling) into one.
> 
Will do.
>> +
>>   	/* message ram could be shared */
>>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
>>   	if (!res) {
>> -- 
>> 2.17.1
>>
>>

regards,
Judith
