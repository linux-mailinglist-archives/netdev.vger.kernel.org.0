Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC26E7CFF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjDSOjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjDSOji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:39:38 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427776E80;
        Wed, 19 Apr 2023 07:39:17 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JEd2EH125730;
        Wed, 19 Apr 2023 09:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681915142;
        bh=D0p2krU/Tl2rjp8hr8uRJrf8+8CgtChn0G/J3nT/yQM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=gz9AU5f5ncVZgWLxhSr/1uWh8c2nRAJMhBew64+M3tfqIrjq9KjavCdTIooME9T8O
         e0+YD2GhRMNQqhx2POXM0OlhcYKJrNXZtFs9aBg/YJQV8vpG4ZsKljCynhVuO2Pf0Y
         liRD456sLBi/CcKgAQ4isyx3qW01l/yadsWbxnzM=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JEd13j000691
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 09:39:01 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 09:39:01 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 09:39:01 -0500
Received: from [128.247.81.102] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JEd16r028564;
        Wed, 19 Apr 2023 09:39:01 -0500
Message-ID: <5d81aeb6-2b52-5807-5b42-daa87767144f@ti.com>
Date:   Wed, 19 Apr 2023 09:38:58 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
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
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
 <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
 <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
 <20230417-unsafe-porridge-0b712d137530-mkl@pengutronix.de>
 <5ece3561-4690-a721-aa83-adf80d0be9f5@ti.com>
 <20230419-trimmer-fasting-928868e8cb81-mkl@pengutronix.de>
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230419-trimmer-fasting-928868e8cb81-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
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

On 4/19/2023 1:13 AM, Marc Kleine-Budde wrote:
> On 18.04.2023 15:59:57, Mendez, Judith wrote:
>>>>>>>> The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC = 0
>>>>>>>> and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit => ~50
>>>>>>>> usecs
>>>>>>>>
>>>>>>>> So it should be something about
>>>>>>>>
>>>>>>>>         50 usecs * (FIFO queue len - 2)
>>>>>>>
>>>>>>> Where does the "2" come from?
>>>>>>
>>>>>> I thought about handling the FIFO earlier than it gets completely "full".
>>>>>>
>>>>>> The fetching routine would need some time too and the hrtimer could also
>>>>>> jitter to some extend.
>>>>>
>>>>> I was assuming something like this.
>>>>>
>>>>> I would argue that the polling time should be:
>>>>>
>>>>>        50 µs * FIFO length - IRQ overhead.
>>>>>
>>>>> The max IRQ overhead depends on your SoC and kernel configuration.
>>>>
>>>> I just tried an educated guess to prevent the FIFO to be filled up
>>>> completely. How can you estimate the "IRQ overhead"? And how do you catch
>>>> the CAN frames that are received while the IRQ is handled?
>>>
>>> We're talking about polling, better call it "overhead" or "latency from
>>> timer expiration until FIFO has at least one frame room". This value
>>> depends on your system.
>>>
>>> It depends on many, many factors, SoC, Kernel configuration (preempt RT,
>>> powersaving, frequency scaling, system load. In your example it's 100
>>> µs. I wanted to say there's an overhead (or latency) and we need enough
>>> space in the FIFO, to cover it.
>>>
>>
>> I am not sure how to estimate IRQ overhead, but FIFO length should be 64
>> elements.
> 
> Ok
> 
>> 50 us * 62 is about 3.1 ms and we are using 1 ms timer polling interval.
> 
> Sounds good.
> 
>> Running a few benchmarks showed that using 0.5 ms timer polling interval
>> starts to take a toll on CPU load, that is why I chose 1 ms polling
>> interval.
> 
> However in the code you use 5 ms.

Yes, it was a mistake, will send out a respin with the correct value, 
thanks.

regards,
Judith
