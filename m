Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04B10B663
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfK0TGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:06:21 -0500
Received: from foss.arm.com ([217.140.110.172]:52062 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfK0TGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 14:06:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04C6F31B;
        Wed, 27 Nov 2019 11:06:20 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3B673F6C4;
        Wed, 27 Nov 2019 11:06:14 -0800 (PST)
Subject: Re: [PATCH v3 1/7] linux/log2.h: Add roundup/rounddown_pow_two64()
 family of functions
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Leon Romanovsky <leon@kernel.org>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
References: <20191126091946.7970-1-nsaenzjulienne@suse.de>
 <20191126091946.7970-2-nsaenzjulienne@suse.de>
 <20191126125137.GA10331@unreal>
 <6e0b9079-9efd-2884-26d1-3db2d622079d@arm.com>
 <b30002d48c9d010a1ee81c16cd29beee914c3b1d.camel@suse.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <c08863a7-49c6-962e-e968-92adb8ee2cc9@arm.com>
Date:   Wed, 27 Nov 2019 19:06:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b30002d48c9d010a1ee81c16cd29beee914c3b1d.camel@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/11/2019 6:24 pm, Nicolas Saenz Julienne wrote:
> On Wed, 2019-11-27 at 18:06 +0000, Robin Murphy wrote:
>> On 26/11/2019 12:51 pm, Leon Romanovsky wrote:
>>> On Tue, Nov 26, 2019 at 10:19:39AM +0100, Nicolas Saenz Julienne wrote:
>>>> Some users need to make sure their rounding function accepts and returns
>>>> 64bit long variables regardless of the architecture. Sadly
>>>> roundup/rounddown_pow_two() takes and returns unsigned longs. Create a
>>>> new generic 64bit variant of the function and cleanup rougue custom
>>>> implementations.
>>>
>>> Is it possible to create general roundup/rounddown_pow_two() which will
>>> work correctly for any type of variables, instead of creating special
>>> variant for every type?
>>
>> In fact, that is sort of the case already - roundup_pow_of_two() itself
>> wraps ilog2() such that the constant case *is* type-independent. And
>> since ilog2() handles non-constant values anyway, might it be reasonable
>> to just take the strongly-typed __roundup_pow_of_two() helper out of the
>> loop as below?
>>
>> Robin
>>
> 
> That looks way better that's for sure. Some questions.
> 
>> ----->8-----
>> diff --git a/include/linux/log2.h b/include/linux/log2.h
>> index 83a4a3ca3e8a..e825f8a6e8b5 100644
>> --- a/include/linux/log2.h
>> +++ b/include/linux/log2.h
>> @@ -172,11 +172,8 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>>     */
>>    #define roundup_pow_of_two(n)			\
>>    (						\
>> -	__builtin_constant_p(n) ? (		\
>> -		(n == 1) ? 1 :			\
>> -		(1UL << (ilog2((n) - 1) + 1))	\
>> -				   ) :		\
>> -	__roundup_pow_of_two(n)			\
>> +	(__builtin_constant_p(n) && (n == 1)) ?	\
>> +	1 : (1UL << (ilog2((n) - 1) + 1))	\
> 
> Then here you'd have to use ULL instead of UL, right? I want my 64bit value
> everywhere regardless of the CPU arch. The downside is that would affect
> performance to some extent (i.e. returning a 64bit value where you used to have
> a 32bit one)?

True, although it's possible that 1ULL might result in the same codegen 
if the compiler can see that the result is immediately truncated back to 
long anyway. Or at worst, I suppose "(typeof(n))1" could suffice, 
however ugly. Either way, this diff was only an illustration rather than 
a concrete proposal, but it might be an interesting diversion to 
investigate.

On that note, though, you should probably be using ULL in your current 
patch too.

> Also, what about callers to this function on platforms with 32bit 'unsigned
> longs' that happen to input a 64bit value into this. IIUC we'd have a change of
> behaviour.

Indeed, although the change in such a case would be "start getting the 
expected value instead of nonsense", so it might very well be welcome ;)

Robin.
