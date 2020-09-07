Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675F525FB88
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgIGNhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 09:37:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40020 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729585AbgIGNek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 09:34:40 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1AD2C804481131BD0AD1;
        Mon,  7 Sep 2020 21:32:33 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 21:32:23 +0800
Subject: Re: [PATCH net-next 0/2] net: two updates related to UDP GSO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
 <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <126e5424-2453-eef4-d5b6-adeaedbb6eca@huawei.com>
Date:   Mon, 7 Sep 2020 21:32:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/9/7 17:22, Willem de Bruijn wrote:
> On Sun, Sep 6, 2020 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Sat, 5 Sep 2020 14:11:11 +0800 Huazhong Tan wrote:
>>> There are two updates relates to UDP GSO.
>>> #1 adds a new GSO type for UDPv6
>>> #2 adds check for UDP GSO when csum is disable in netdev_fix_features().
>>>
>>> Changes since RFC V2:
>>> - modifies the timing of setting UDP GSO type when doing UDP GRO in #1.
>>>
>>> Changes since RFC V1:
>>> - updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
>>>    and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
>>>    - add #2 who needs #1.
>>
>> Please CC people who gave you feedback (Willem).
>>
>> I don't feel good about this series. IPv6 is not optional any more.
>> AFAIU you have some issues with csum support in your device? Can you
>> use .ndo_features_check() to handle this?
>>
>> The change in semantics of NETIF_F_GSO_UDP_L4 from "v4 and v6" to
>> "just v4" can trip people over; this is not a new feature people
>> may be depending on the current semantics.
>>
>> Willem, what are your thoughts on this?
> 
> If that is the only reason, +1 on fixing it up in the driver's
> ndo_features_check.
> 

Hi, Willem & Jakub.

This series mainly fixes the feature dependency between hardware 
checksum and UDP GSO.
When turn off hardware checksum offload, run 'ethtool -k [devname]'
we can see TSO is off as well, but udp gso still is on.

[root@localhost ~]# ethtool -K eth0 tx off
Actual changes:
tx-checksumming: off
	tx-checksum-ipv4: off
	tx-checksum-ipv6: off
	tx-checksum-sctp: off
tcp-segmentation-offload: off
	tx-tcp-segmentation: off [requested on]
	tx-tcp-ecn-segmentation: off [requested on]
	tx-tcp6-segmentation: off [requested on]
[root@localhost ~]# ethtool -k eth0
Features for eth0:
rx-checksumming: on
tx-checksumming: off
	tx-checksum-ipv4: off
	tx-checksum-ip-generic: off [fixed]
	tx-checksum-ipv6: off
	tx-checksum-fcoe-crc: off [fixed]
	tx-checksum-sctp: off
...
tcp-segmentation-offload: off
	tx-tcp-segmentation: off [requested on]
	tx-tcp-ecn-segmentation: off [requested on]
	tx-tcp-mangleid-segmentation: off
	tx-tcp6-segmentation: off [requested on]
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: on
...
tx-udp-segmentation: on
...

.ndo_feature_check seems unnecessary.
Because the stack has already do this check.
in __ip_append_data() below if branch will not run if hardware checksum 
offload is off.
         if (transhdrlen &&
             length + fragheaderlen <= mtu &&
             rt->dst.dev->features & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM) &&
             (!(flags & MSG_MORE) || cork->gso_size) &&
             (!exthdrlen || (rt->dst.dev->features & 
NETIF_F_HW_ESP_TX_CSUM)))
                 csummode = CHECKSUM_PARTIAL;
...
so skb->ip_summed set as CHECKSUM_NONE,
then in udp_send_skb()
         if (cork->gso_size) {
		...
                 if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
                     dst_xfrm(skb_dst(skb))) {
                         kfree_skb(skb); 
 

                         return -EIO;
                 }
the packet who needs udp gso will return ERROR.

For this kind of problem how could we fix it?

Thanks.
Huazhong.

> .
> 

