Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB35A2D0549
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgLFNid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:38:33 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18958 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbgLFNic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 08:38:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fccdeb00000>; Sun, 06 Dec 2020 05:37:52 -0800
Received: from [172.27.13.141] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 6 Dec
 2020 13:37:50 +0000
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
 <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
Date:   Sun, 6 Dec 2020 15:37:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607261872; bh=bRV/tVtQ+rYibP8o6NCCddWB4q07Daf1ty57TYVgzhA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=pvrE1nioWVdHeF/y8jjgMU3L77uRcPi057o97ltMTeWiN/aPMoP7M17PAiA+GRk/4
         04QgUFmuDrgKhHgN7aSlPu074irpN6d/iFEGQDfUy6T9Z5CFBy/4cgRZFiY+/s5XFk
         y+/fSPIPaZwRVeaBCSyEQihnv0+UBNeA0fIelW+6Tru4j3rsCk2rv0SHRbXzCR6CK9
         QNETOo5r/wH9s7UUO9npvKRcwSyw7517a2KfcBuGyPIjdzE7J1VF5exkR2Jl3sZXhJ
         syGpAVm52UEoYIe+tBM7SAjuNHZT95aD3zD7EyqRZsw530pOLBm7mshzOKP4MndDq/
         Z+0ZmKy//Iq8g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2020 2:24 AM, Jakub Kicinski wrote:
> On Fri, 04 Dec 2020 15:57:36 -0800 Saeed Mahameed wrote:
>> On Fri, 2020-12-04 at 15:17 -0800, Jakub Kicinski wrote:
>>> On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:
>>>>>> option 2) route PTP traffic to a special SQs per ring, this SQ
>>>>>> will
>>>>>> be
>>>>>> PTP port accurate, Normal traffic will continue through regular
>>>>>> SQs
>>>>>>
>>>>>> Pros: Regular non PTP traffic not affected.
>>>>>> Cons: High memory footprint for creating special SQs
>>>>>>
>>>>>> So we prefer (2) + private flag to avoid the performance hit
>>>>>> and
>>>>>> the
>>>>>> redundant memory usage out of the box.
>>>>>
>>>>> Option 3 - have only one special PTP queue in the system. PTP
>>>>> traffic
>>>>> is rather low rate, queue per core doesn't seem necessary.
>>>>
>>>> We only forward ptp traffic to the new special queue but we create
>>>> more
>>>> than one to avoid internal locking as we will utilize the tx
>>>> softirq
>>>> percpu.
>>>
>>> In other words to make the driver implementation simpler we'll have
>>> a pretty basic feature hidden behind a ethtool priv knob and a number
>>> of queues which doesn't match reality reported to user space. Hm.
>>
>> I look at these queues as a special HW objects to allow the accurate
>> PTP stamping, they piggyback on the reported txqs, so they are
>> transparent,
> 
> But they are visible to the stack, via sysfs, netlink. Any check
> in the kernel that tries to help the driver by validating user input
> against real_num_tx_queues will be moot for mlx5e.

Re-writing it here,  we report them in real num of TX queues.

> 
> mlx5e hides the AF_XDP queues behind normal RSS queues, but it would
> have extra visible queues for TX PTP.
> 
>> they just increase the memory footprint of each ring.
> 
> For every ring or for every TC? (which is hopefully 1 in any non-DCB
> deployment?)

For every TC, not for every ring.

> 
>> for the priv flags, one of the floating ideas was to
>> use hwtstamp_rx_filters flags:
>>   
>> https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/net_tstamp.h#L107
>>
>> Our hardware timestamps all packets for free whether you request it or
>> not, Currently there is no option to setup "ALL_PTP" traffic in ethtool
>> -T, but we can add this flag as it make sense to be in ethtool -T, thus
>> we could use it in mlx5 to determine if user selected ALL_PTP, then ptp
>> packets will go through this accurate special path.
>>
>> This is not a W/A or an abuse to the new flag, it just means if you
>> select ALL_PTP then a side effect will be our HW will be more accurate
>> for PTP traffic.
>>
>> What do you think ?
> 
> That sounds much better than the priv flag, yes.

Our Hardware can provide a better accurate time stamp under few 
limitations. It requires higher memory consumption ({SQ, 2 x CQ, 
internal HW LB RQ} per TC), and also has performance impact (more CQEs 
to consume for example).
Some customers are happy with the accuracy they get today and don't want 
the extra penalty, so they don't want to be automatically shifted to the 
new TS logic.

Adding new enum to the ioctl means we have add 
(HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY for example) all the way - drivers, 
kernel ptp, user space ptp, ethtool.

My concerns are:
1. Timestamp applications (like ptp4l or similar) will have to add 
support for configuring the driver to use 
HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY if supported via ioctl prior to 
packets transmit. From application point of view, the dual-modes 
(HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY , HWTSTAMP_TX_ON) support is 
redundant, as it offers nothing new.
2. Other vendors will have to support it as well, when not sure what is 
the expectation from them if they cannot improve accuracy between them.

This feature is just an internal enhancement, and as such it should be 
added only as a vendor private configuration flag. We are not offering 
here about any standard for others to follow.

If we did not have the limitation above, it could have been added as the 
default silently.

I suggest we reconsider the ethtool private-flag, the ioctl change might 
be a long journey in a wrong direction.

> 
>> Regarding reducing to a single special queue, i will discuss with Eran
>> and the Team on Sunday.
> 
> Okay, thanks.
> 
