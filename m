Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186202D9AA1
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgLNPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:13:46 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3603 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLNPNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:13:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd781010001>; Mon, 14 Dec 2020 07:13:05 -0800
Received: from [172.27.14.196] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Dec
 2020 15:12:53 +0000
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware
 offload
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
References: <20201211152649.12123-1-maximmi@mellanox.com>
 <20201211152649.12123-3-maximmi@mellanox.com>
 <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
Date:   Mon, 14 Dec 2020 17:12:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607958785; bh=CDexvt2RlSeO15HANFwxMcMbVeOWcnN+/8cwZq1bkQg=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=NSdQ+PZmPLJHZmBJ7ViC230/ybltLRlgvYhnwqSn2LQo7VFcdeDKYiZ8RvzMKHfZe
         KNOiOBpgNeNGOS04C9VWjKM3Ji+7jmA4H92Z53RE/j2VINRleV4+SwQKnRUs8E7Bmg
         uQwJ8y/uKQ8L/+3iV3IXIlMuGHaocXEqF9/bAZxz2Ij1uiQB2zRKgXFinD/HwvJrYK
         Umd+rDYl91IXbdAFPhffBDUSk36zanchAsoA5rxhBoSJV0pmbVW3yxlZtwkq4SghS5
         YI1N+g0Prk//OFV8whMdSeVw6qR35A2GWveJOYzjcrNVOPMBC3duFFRW6Q9eGjqpUV
         IlTqJI9zaE2NQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-11 21:16, Cong Wang wrote:
> On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>
>> HTB doesn't scale well because of contention on a single lock, and it
>> also consumes CPU. This patch adds support for offloading HTB to
>> hardware that supports hierarchical rate limiting.
>>
>> This solution addresses two main problems of scaling HTB:
>>
>> 1. Contention by flow classification. Currently the filters are attached
>> to the HTB instance as follows:
> 
> I do not think this is the reason, tcf_classify() has been called with RCU
> only on the ingress side for a rather long time. What contentions are you
> talking about here?

When one attaches filters to HTB, tcf_classify is called from 
htb_classify, which is called from htb_enqueue, which is called with the 
root spinlock of the qdisc taken.

>>
>>      # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
>>      classid 1:10
>>
>> It's possible to move classification to clsact egress hook, which is
>> thread-safe and lock-free:
>>
>>      # tc filter add dev eth0 egress protocol ip flower dst_port 80
>>      action skbedit priority 1:10
>>
>> This way classification still happens in software, but the lock
>> contention is eliminated, and it happens before selecting the TX queue,
>> allowing the driver to translate the class to the corresponding hardware
>> queue.
> 
> Sure, you can use clsact with HTB, or any combinations you like, but you
> can't assume your HTB only works with clsact, can you?

The goal is to eliminate the root lock from the datapath, and the 
traditional filters attached to the HTB itself are handled under that 
lock. I believe it's a sane limitation, given that the offloaded mode is 
a new mode of operation, it's opt-in, and it may also have additional 
hardware-imposed limitations.

> 
>>
>> Note that this is already compatible with non-offloaded HTB and doesn't
>> require changes to the kernel nor iproute2.
>>
>> 2. Contention by handling packets. HTB is not multi-queue, it attaches
>> to a whole net device, and handling of all packets takes the same lock.
>> When HTB is offloaded, its algorithm is done in hardware. HTB registers
>> itself as a multi-queue qdisc, similarly to mq: HTB is attached to the
>> netdev, and each queue has its own qdisc. The control flow is still done
>> by HTB: it calls the driver via ndo_setup_tc to replicate the hierarchy
>> of classes in the NIC. Leaf classes are presented by hardware queues.
>> The data path works as follows: a packet is classified by clsact, the
>> driver selects a hardware queue according to its class, and the packet
>> is enqueued into this queue's qdisc.
> 
> I do _not_ read your code, from what you describe here, it sounds like
> you just want a per-queue rate limit, instead of a global one. So why
> bothering HTB whose goal is a global rate limit?

I would disagree. HTB's goal is hierarchical rate limits with borrowing. 
Sure, it can be used just to set a global limit, but it's main purpose 
is creating a hierarchy of classes.

And yes, we are talking about the whole netdevice here, not about 
per-queue limits (we already support per-queue rate limits with the 
means of tx_maxrate, so we wouldn't need any new code for that). The 
tree of classes is global for the whole netdevice, with hierarchy and 
borrowing supported. These additional send queues can be considered as 
hardware objects that represent offloaded leaf traffic classes (which 
can be extended to multiple queues per class).

So, we are really offloading HTB functionality here, not just using HTB 
interface for something else (something simpler). I hope it sounds 
better for you now.

> And doesn't TBF already work with mq? I mean you can attach it as
> a leaf to each mq so that the tree lock will not be shared either, but you'd
> lose the benefits of a global rate limit too.

Yes, I'd lose not only the global rate limit, but also multi-level 
hierarchical limits, which are all provided by this HTB offload - that's 
why TBF is not really a replacement for this feature.

> EDT does basically the same,
> but it never claims to completely replace HTB. ;)
> 
> Thanks.
> 

