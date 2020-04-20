Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C561B1056
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgDTPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:38:22 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:38901 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgDTPiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:38:22 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 495W7H6SD5z1r76J;
        Mon, 20 Apr 2020 17:38:18 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 495W7G3mHXz1qtwY;
        Mon, 20 Apr 2020 17:38:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id qqbZnqMMz5eD; Mon, 20 Apr 2020 17:38:16 +0200 (CEST)
X-Auth-Info: PIpsRW0wARhrzYIQa+S1GAq68j/sSx1VJx7d9JAUTNI=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 20 Apr 2020 17:38:16 +0200 (CEST)
Subject: Re: [PATCH V4 07/19] net: ks8851: Remove ks8851_rdreg32()
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-8-marex@denx.de>
 <20200420140700.6632hztejwcgjwsf@wunner.de>
 <99104102-7973-e80f-9006-9a448403562b@denx.de>
 <20200420142002.2l57umsi3rh5ka7e@wunner.de>
 <e8924fbc-b515-527c-a772-b5ac5cfc1cf4@denx.de>
 <20200420144403.eoo47sq7pwp6yc7d@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <0edb18eb-0c18-c3cd-a0b7-4ba23428f354@denx.de>
Date:   Mon, 20 Apr 2020 17:38:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200420144403.eoo47sq7pwp6yc7d@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 4:44 PM, Lukas Wunner wrote:
> On Mon, Apr 20, 2020 at 04:24:05PM +0200, Marek Vasut wrote:
>> On 4/20/20 4:20 PM, Lukas Wunner wrote:
>>> On Mon, Apr 20, 2020 at 04:12:59PM +0200, Marek Vasut wrote:
>>>> On 4/20/20 4:07 PM, Lukas Wunner wrote:
>>>>> On Tue, Apr 14, 2020 at 08:20:17PM +0200, Marek Vasut wrote:
>>>>>> The ks8851_rdreg32() is used only in one place, to read two registers
>>>>>> using a single read. To make it easier to support 16-bit accesses via
>>>>>> parallel bus later on, replace this single read with two 16-bit reads
>>>>>> from each of the registers and drop the ks8851_rdreg32() altogether.
>>>>>>
>>>>>> If this has noticeable performance impact on the SPI variant of KS8851,
>>>>>> then we should consider using regmap to abstract the SPI and parallel
>>>>>> bus options and in case of SPI, permit regmap to merge register reads
>>>>>> of neighboring registers into single, longer, read.
>>>>>
>>>>> Bisection has shown this patch to be the biggest cause of the performance
>>>>> regression introduced by this series:  Latency increases by about 9 usec.
>>>>
>>>> Just for completeness, did you perform this bisect on current linux-next
>>>> without any patches except this series OR your patched rpi downstream
>>>> vendor tree Linux 4.19 with preempt-rt patch applied ?
>>>
>>> The latter because latency without CONFIG_PREEMPT_RT_FULL=y is too imprecise
>>> to really see the difference and that's the configuration we care about.
>>
>> Why am I not able to see the same on the RPi3 then ?
>> How can I replicate this observation ?
> 
> Compile this branch with CONFIG_PREEMPT_RT_FULL=y:
> 
> https://github.com/l1k/linux/commits/revpi-4.19-marek-v4
> 
> Alternatively, download this file:
> 
> http://wunner.de/ks8851-marekv4.tar
> 
> Install the "raspberrypi-kernel" deb-package included in the tarball on a
> stock Raspbian image and copy one of the included ks8851.ko to:
> /lib/modules/4.19.95-rt38-v7+/kernel/drivers/net/ethernet/micrel

Why don't you rather try to replicate this problem in linux-next?
