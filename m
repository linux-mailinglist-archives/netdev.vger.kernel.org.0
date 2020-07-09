Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24075219661
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGIC6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:58:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgGIC6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 22:58:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1E8B23301EE5F05BAE69;
        Thu,  9 Jul 2020 10:55:37 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Jul 2020
 10:55:27 +0800
Subject: Re: [RFC net-next 2/2] net: disable UDP GSO feature when CSUM is
 disabled
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-3-git-send-email-tanhuazhong@huawei.com>
 <7d7ed503-3d23-29f6-0fbe-b240064d4eea@gmail.com>
 <7529a39a-de9a-0ea9-152c-e1fca64be157@huawei.com>
 <a8bde657-7285-86f9-4d44-54b52d8d3f36@gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <513e8605-2687-132b-f967-4c33538adc34@huawei.com>
Date:   Thu, 9 Jul 2020 10:55:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <a8bde657-7285-86f9-4d44-54b52d8d3f36@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/9 10:47, Eric Dumazet wrote:
> 
> 
> On 7/8/20 7:30 PM, tanhuazhong wrote:
>>
>>
>> On 2020/7/8 13:36, Eric Dumazet wrote:
>>>
>>>
>>> On 7/7/20 8:48 PM, Huazhong Tan wrote:
>>>> Since UDP GSO feature is depended on checksum offload, so disable
>>>> UDP GSO feature when CSUM is disabled, then from user-space also
>>>> can see UDP GSO feature is disabled.
>>>>
>>>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>>>> ---
>>>>    net/core/dev.c | 6 ++++++
>>>>    1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>> index c02bae9..dcb6b35 100644
>>>> --- a/net/core/dev.c
>>>> +++ b/net/core/dev.c
>>>> @@ -9095,6 +9095,12 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>>>>            features &= ~NETIF_F_TSO6;
>>>>        }
>>>>    +    if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
>>>> +        (!(features & NETIF_F_IP_CSUM) || !(features & NETIF_F_IPV6_CSUM))) {
>>>
>>> This would prevent a device providing IPv4 checksum only (no IPv6 csum support) from sending IPv4 UDP GSO packets ?
>>>
>>
>> Yes, not like TCP (who uses NETIF_F_TSO for IPv4 and NETIF_F_TSO6 for IPv6),
>> UDP only has a NETIF_F_GSO_UDP_L4 for both IPv4 and IPv6.
>> I cannot find a better way to do it with combined IPv4 and IPv6 csum together.
>> For this issue, is there any good idea to fix it?
> 
> This could be done in an ndo_fix_features(), or ndo_features_check()
> 
> Or maybe we do not care, but this should probably be documented.
> 

Thanks for your suggestion.
If only check NETIF_F_HW_CSUM here is more acceptable?

> 
> 

