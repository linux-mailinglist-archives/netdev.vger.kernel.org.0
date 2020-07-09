Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2232F219615
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGICQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:16:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbgGICQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 22:16:24 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 42DA6B01DDC9842EE8C0;
        Thu,  9 Jul 2020 10:16:22 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Jul 2020
 10:16:14 +0800
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to
 NETIF_F_SOFTWARE_GSO
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
 <96a4cb06-c4d2-2aec-2d63-dfcd6691e05a@gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <8af4dce7-f2a0-286a-bb5b-36c66d05c0f3@huawei.com>
Date:   Thu, 9 Jul 2020 10:16:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <96a4cb06-c4d2-2aec-2d63-dfcd6691e05a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/8 13:26, Eric Dumazet wrote:
> 
> 
> On 7/7/20 8:48 PM, Huazhong Tan wrote:
>> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
> 
> 
> s/NETIF_F_SOFTWARE_GSO/NETIF_F_GSO_UDP_L4/
> 

yes, thanks.

>> a software fallback.  This allows UDP GSO to be used even if
>> the hardware does not support it, and for virtual device such
>> as VxLAN device, this UDP segmentation will be postponed to
>> physical device.
> 
> Is GSO stack or hardware USO able to perform this segmentation,
> with vxlan (or other) added encapsulation ?
> 

I have tested this patch with vxlan and vlan in i40e, the driver
of vxlan and vlan uses  NETIF_F_SOFTWARE_GSO.
case 1:
tx-udp-segmentation of virtual device and i40e is on, then the
UDP GSO is handled by hardware.
case 2:
tx-udp-segmentation of virual device is on, i40e is off, then
the UDP GSO is handled between xmit of virtual device and physical device.
case 3:
tx-udp-segmentation of virtual device and i40e is off, then
the UDP GSO is handled before calling virtual device's xmit.

the packet captured on receiver is same for the above cases.
so the behavior of UDP is similar to TCP (which has already been supported)?

> What about code in net/core/tso.c (in net-next tree) ?
> 

by reading the code, i can not find anything related to the
tunnel header. Is there any way to verify it?

Thanks for reviewing:)

>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   include/linux/netdev_features.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>> index 2cc3cf8..c7eef16 100644
>> --- a/include/linux/netdev_features.h
>> +++ b/include/linux/netdev_features.h
>> @@ -207,7 +207,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>>   				 NETIF_F_FSO)
>>   
>>   /* List of features with software fallbacks. */
>> -#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | \
>> +#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | NETIF_F_GSO_UDP_L4 | \
>>   				 NETIF_F_GSO_SCTP)
>>   
>>   /*
>>
> 
> 

