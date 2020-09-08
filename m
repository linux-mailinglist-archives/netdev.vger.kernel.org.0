Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D0F2608AC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 04:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgIHCcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 22:32:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728188AbgIHCco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 22:32:44 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AE010DC4C4B66C34BA9E;
        Tue,  8 Sep 2020 10:32:41 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 8 Sep 2020
 10:32:35 +0800
Subject: Re: [PATCH net-next 0/2] net: two updates related to UDP GSO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
 <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com>
 <126e5424-2453-eef4-d5b6-adeaedbb6eca@huawei.com>
 <CA+FuTSecsVRsOt7asv7aHGvAXCacHGYwbG1a1X9ynL83dqP8Bw@mail.gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <6cb146b5-8e0d-ed22-a0c1-b54c59685aa5@huawei.com>
Date:   Tue, 8 Sep 2020 10:32:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSecsVRsOt7asv7aHGvAXCacHGYwbG1a1X9ynL83dqP8Bw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/9/7 23:35, Willem de Bruijn wrote:
> On Mon, Sep 7, 2020 at 3:38 PM tanhuazhong <tanhuazhong@huawei.com> wrote:
>>
>>
>>
>> On 2020/9/7 17:22, Willem de Bruijn wrote:
>>> On Sun, Sep 6, 2020 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Sat, 5 Sep 2020 14:11:11 +0800 Huazhong Tan wrote:
>>>>> There are two updates relates to UDP GSO.
>>>>> #1 adds a new GSO type for UDPv6
>>>>> #2 adds check for UDP GSO when csum is disable in netdev_fix_features().
>>>>>
>>>>> Changes since RFC V2:
>>>>> - modifies the timing of setting UDP GSO type when doing UDP GRO in #1.
>>>>>
>>>>> Changes since RFC V1:
>>>>> - updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
>>>>>     and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
>>>>>     - add #2 who needs #1.
>>>>
>>>> Please CC people who gave you feedback (Willem).
>>>>
>>>> I don't feel good about this series. IPv6 is not optional any more.
>>>> AFAIU you have some issues with csum support in your device? Can you
>>>> use .ndo_features_check() to handle this?
>>>>
>>>> The change in semantics of NETIF_F_GSO_UDP_L4 from "v4 and v6" to
>>>> "just v4" can trip people over; this is not a new feature people
>>>> may be depending on the current semantics.
>>>>
>>>> Willem, what are your thoughts on this?
>>>
>>> If that is the only reason, +1 on fixing it up in the driver's
>>> ndo_features_check.
>>>
>>
>> Hi, Willem & Jakub.
>>
>> This series mainly fixes the feature dependency between hardware
>> checksum and UDP GSO.
>> When turn off hardware checksum offload, run 'ethtool -k [devname]'
>> we can see TSO is off as well, but udp gso still is on.
> 
> I see. That does not entirely require separate IPv4 and IPv6 flags. It
> can be disabled if either checksum offload is disabled. I'm not aware
> of any hardware that only supports checksum offload for one of the two
> network protocols.
> 

below patch is acceptable? i have sent this patch before
(https://patchwork.ozlabs.org/project/netdev/patch/1594180136-15912-3-git-send-email-tanhuazhong@huawei.com/)

diff --git a/net/core/dev.c b/net/core/dev.c
index c02bae9..dcb6b35 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9095,6 +9095,12 @@ static netdev_features_t 
netdev_fix_features(struct net_device *dev,
  		features &= ~NETIF_F_TSO6;
  	}

+	if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
+	    (!(features & NETIF_F_IP_CSUM) || !(features & NETIF_F_IPV6_CSUM))) {
+		netdev_dbg(dev, "Dropping UDP GSO features since no CSUM feature.\n");
+		features &= ~NETIF_F_GSO_UDP_L4;
+	}
+
  	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
  	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
  		features &= ~NETIF_F_TSO_MANGLEID;

As Eric Dumazet commented "This would prevent a device providing IPv4
checksum only (no IPv6 csum support) from sending IPv4 UDP GSO packets ?",
so i send this series to decouple them. Is there any good ways to
shuttle this issue? Or as you said there is not device only support
checksum offload for one of the two network protocols.

> Alternatively, the real value of splitting the type is in advertising
> the features separately through ethtool. That requires additional
> changes.
> 


> .
> 

