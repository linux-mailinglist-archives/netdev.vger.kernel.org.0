Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAAF219658
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgGICtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:49:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7824 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbgGICtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 22:49:40 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3EA51B8F388F849AE330;
        Thu,  9 Jul 2020 10:49:37 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Jul 2020
 10:49:29 +0800
Subject: Re: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to
 NETIF_F_SOFTWARE_GSO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>, Jakub Kicinski <kuba@kernel.org>
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
 <CA+FuTScYPDhP0NigDgcu+Gpz5GUxttX2htS1NT__pqQOvtsKqw@mail.gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <aee519de-c793-a2a7-34d1-c18c90080ca6@huawei.com>
Date:   Thu, 9 Jul 2020 10:49:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTScYPDhP0NigDgcu+Gpz5GUxttX2htS1NT__pqQOvtsKqw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/8 20:11, Willem de Bruijn wrote:
> On Tue, Jul 7, 2020 at 11:50 PM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>>
>> Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
>> a software fallback.  This allows UDP GSO to be used even if
>> the hardware does not support it,
> 
> That is already the case if just calling UDP_SEGMENT.
> 
> It seems the specific goal here is to postpone segmentation when
> going through a vxlan device?
> 

yes. without this patch, the segmentation is handled before calling
virtual device's .ndo_start_xmit.
Like TSO, UDP GSO also should be handle as later as possible?

>> and for virtual device such
>> as VxLAN device, this UDP segmentation will be postponed to
>> physical device.
> 
> See previous commits
> 
> commit 83aa025f535f76733e334e3d2a4d8577c8441a7e
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Thu Apr 26 13:42:21 2018 -0400
> 
>      udp: add gso support to virtual devices
> 
>      Virtual devices such as tunnels and bonding can handle large packets.
>      Only segment packets when reaching a physical or loopback device.
> 
>      Signed-off-by: Willem de Bruijn <willemb@google.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> and
> 
> commit 8eea1ca82be90a7e7a4624ab9cb323574a5f71df
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Tue May 22 11:34:40 2018 -0400
> 
>      gso: limit udp gso to egress-only virtual devices
> 
>      Until the udp receive stack supports large packets (UDP GRO), GSO
>      packets must not loop from the egress to the ingress path.
> 
>      Revert the change that added NETIF_F_GSO_UDP_L4 to various virtual
>      devices through NETIF_F_GSO_ENCAP_ALL as this included devices that
>      may loop packets, such as veth and macvlan.
> 
>      Instead add it to specific devices that forward to another device's
>      egress path, bonding and team.
> 
>      Fixes: 83aa025f535f ("udp: add gso support to virtual devices")
>      CC: Alexander Duyck <alexander.duyck@gmail.com>
>      Signed-off-by: Willem de Bruijn <willemb@google.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Though with UDP_GRO this specific loop concern is addressed.
> 
> 
> 
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
>>                                   NETIF_F_FSO)
>>
>>   /* List of features with software fallbacks. */
>> -#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | \
>> +#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | NETIF_F_GSO_UDP_L4 | \
>>                                   NETIF_F_GSO_SCTP)
>>
>>   /*
>> --
>> 2.7.4
>>
> 
> .
> 

