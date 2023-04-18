Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F096E6DC7
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 23:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDRVAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 17:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDRVAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 17:00:20 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C744940FA;
        Tue, 18 Apr 2023 14:00:17 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33IKxvUv027084;
        Tue, 18 Apr 2023 15:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681851597;
        bh=l+g/rrVq/gexW1MWXpawC7favKvdCG3qnBu/DVzf5vw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=ilAQ52XaWO7kl8gbzfujSGsgaUovOS9czXPHtyb1tfLfm9gGfjO3T0rv2AHdGNNVi
         8jOj+uOXl3lbCORlUSiDLi22pMpF823aD7qULmSidInGxrJGX/xLBa7CmGDoDht7rJ
         AdtQko4dLMhcdvRwVdQxN6VY15Rimgq9pWv9oMBQ=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33IKxvlj087223
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Apr 2023 15:59:57 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 18
 Apr 2023 15:59:57 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 18 Apr 2023 15:59:57 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33IKxvWe100302;
        Tue, 18 Apr 2023 15:59:57 -0500
Message-ID: <5ece3561-4690-a721-aa83-adf80d0be9f5@ti.com>
Date:   Tue, 18 Apr 2023 15:59:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software
 interrupt
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
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
 <4a6c66eb-2ccf-fc42-a6fc-9f411861fcef@hartkopp.net>
 <20230416-failing-washbasin-e4fa5caea267-mkl@pengutronix.de>
 <f58e8dce-898c-8797-5293-1001c9a75381@hartkopp.net>
 <20230417-taking-relieving-f2c8532864c0-mkl@pengutronix.de>
 <25806ec7-64c5-3421-aea1-c0d431e3f27f@hartkopp.net>
 <20230417-unsafe-porridge-0b712d137530-mkl@pengutronix.de>
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230417-unsafe-porridge-0b712d137530-mkl@pengutronix.de>
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

On 4/17/2023 2:26 PM, Marc Kleine-Budde wrote:
> On 17.04.2023 19:34:03, Oliver Hartkopp wrote:
>> On 17.04.23 09:26, Marc Kleine-Budde wrote:
>>> On 16.04.2023 21:46:40, Oliver Hartkopp wrote:
>>>>> I had the 5ms that are actually used in the code in mind. But this is a
>>>>> good calculation.
>>>>
>>>> @Judith: Can you acknowledge the value calculation?
>>>>
>>>>>> The "shortest" 11 bit CAN ID CAN frame is a Classical CAN frame with DLC = 0
>>>>>> and 1 Mbit/s (arbitration) bitrate. This should be 48 bits @1Mbit => ~50
>>>>>> usecs
>>>>>>
>>>>>> So it should be something about
>>>>>>
>>>>>>        50 usecs * (FIFO queue len - 2)
>>>>>
>>>>> Where does the "2" come from?
>>>>
>>>> I thought about handling the FIFO earlier than it gets completely "full".
>>>>
>>>> The fetching routine would need some time too and the hrtimer could also
>>>> jitter to some extend.
>>>
>>> I was assuming something like this.
>>>
>>> I would argue that the polling time should be:
>>>
>>>       50 µs * FIFO length - IRQ overhead.
>>>
>>> The max IRQ overhead depends on your SoC and kernel configuration.
>>
>> I just tried an educated guess to prevent the FIFO to be filled up
>> completely. How can you estimate the "IRQ overhead"? And how do you catch
>> the CAN frames that are received while the IRQ is handled?
> 
> We're talking about polling, better call it "overhead" or "latency from
> timer expiration until FIFO has at least one frame room". This value
> depends on your system.
> 
> It depends on many, many factors, SoC, Kernel configuration (preempt RT,
> powersaving, frequency scaling, system load. In your example it's 100
> µs. I wanted to say there's an overhead (or latency) and we need enough
> space in the FIFO, to cover it.
> 

I am not sure how to estimate IRQ overhead, but FIFO length should be 64
elements.

50 us * 62 is about 3.1 ms and we are using 1 ms timer polling interval.

Running a few benchmarks showed that using 0.5 ms timer polling interval 
starts to take a toll on CPU load, that is why I chose 1 ms polling 
interval.

regards,
Judith
