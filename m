Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CB636F19F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhD2VP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:15:58 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:53573 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhD2VP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 17:15:57 -0400
Received: from [192.168.1.23] (ip-78-45-89-65.net.upcbroadband.cz [78.45.89.65])
        (Authenticated sender: i.maximets@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id BABC3240007;
        Thu, 29 Apr 2021 21:15:06 +0000 (UTC)
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size
 calculation
To:     Ilya Maximets <i.maximets@ovn.org>, jean.tourrilhes@hpe.com
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, William Tu <u9012063@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
References: <20210421135747.312095-1-i.maximets@ovn.org>
 <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
 <20210428064553.GA19023@labs.hpe.com>
 <04bd0073-6eb7-6747-a0b1-3c25cca7873a@ovn.org>
 <20210428163124.GA28950@labs.hpe.com>
 <22e48984-e0f3-b7d7-9f65-68e93c846c73@ovn.org>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <94576ef8-76b3-67bc-7b55-c1d9513ec31c@ovn.org>
Date:   Thu, 29 Apr 2021 23:15:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <22e48984-e0f3-b7d7-9f65-68e93c846c73@ovn.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 8:59 PM, Ilya Maximets wrote:
> On 4/28/21 6:31 PM, Jean Tourrilhes wrote:
>> On Wed, Apr 28, 2021 at 01:22:12PM +0200, Ilya Maximets wrote:
>>>
>>> I didn't test it, but I looked at the implementation in
>>> net/sched/act_police.c and net/sched/sch_tbf.c, and they should work
>>> in a same way as this patch, i.e. it's a classic token bucket where
>>> burst is a burst and nothing else.
>>
>> 	Actually, act_police.c and sch_tbf.c will behave completely
>> differently, even if they are both based on the token bucket
>> algorithm.
>> 	The reason is that sch_tbf.c is applied to a queue, and the
>> queue will smooth out traffic and avoid drops. The token bucket is
>> used to dequeue the queue, this is sometime called leaky bucket. I've
>> personally used sch_tbf.c with burst size barely bigger than the MTU,
>> and it works fine.
> 
> Makes sense.  Thanks for the clarification!
> 
>> 	This is why I was suggesting to compare to act_police.c, which
>> does not have a queue to smooth out traffic and can only drop
>> packets.
> 
> I see.  Unfortunately, due to the fact that act_police.c uses time
> instead of bytes as a measure for tokens, we will still see a difference
> in behavior.  Probably, not so big, but it will be there and it will
> depend on a line rate.

I found my mistake in calculations (see another reply).  So, there
should not be significant difference with OVS meters, indeed.

> 
>> 	I believe OVS meters are similar to policers, so that's why
>> they are suprising for people used to queues such as TBF and HTB.
>>
>> 	Regards,
>>
>> 	Jean
>>

