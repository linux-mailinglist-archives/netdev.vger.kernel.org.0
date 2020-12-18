Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F208C2DE17C
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbgLRKs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:48:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18047 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733211AbgLRKs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 05:48:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdc88f20000>; Fri, 18 Dec 2020 02:48:18 -0800
Received: from [172.27.0.216] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 10:48:06 +0000
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware
 offload
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
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
 <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
 <CAM_iQpVrQAT2frpiVYj4eevSO4jFPY8v2moJdorCe3apF7p6mA@mail.gmail.com>
 <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
 <845d2678-b679-b2a8-cf00-d4c7791cd540@mojatatu.com>
 <5f4f0785-54cb-debc-1f16-b817b83fbd96@nvidia.com>
 <f15342fb-714b-32d9-ef95-07b2e13bbc9b@mojatatu.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <35ace422-b5d7-3b16-95c3-457d3736a2d6@nvidia.com>
Date:   Fri, 18 Dec 2020 12:48:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <f15342fb-714b-32d9-ef95-07b2e13bbc9b@mojatatu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-17 17:09, Jamal Hadi Salim wrote:
> On 2020-12-16 6:47 a.m., Maxim Mikityanskiy wrote:
>> On 2020-12-15 18:37, Jamal Hadi Salim wrote:
> 
> [..]
> 
>>>
>>> Same question above:
>>> Is there a limit to the number of classes that can be created?
>>
>> Yes, the commit message of the mlx5 patch lists the limitations of our 
>> NICs. Basically, it's 256 leaf classes and 3 levels of hierarchy.
>>
> 
> Ok, thats what i was looking for.
> 
> 
>>> IOW, if someone just created an arbitrary number of queues do they
>>> get errored-out if it doesnt make sense for the hardware?
>>
>> The current implementation starts failing gracefully if the limits are 
>> exceeded. The tc command won't succeed, and everything will roll back 
>> to the stable state, which was just before the tc command.
>>
> 
> Does the user gets notified somehow or it fails silently?
> An extack message would help.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
	t=1608288498; bh=RMhOdIb4utXHB89dvxKO9kM+jQNSV+kIKsJ0O6KNJWs=;
	h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
	 MIME-Version:In-Reply-To:Content-Type:Content-Language:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	b=pThe8Bqxykn4jFcf5ZYZMSgEPZZBiId+lReLZZ9KFCdbROoDwWPTGDWFNhOADAvRA
	 7bjihDOFAvu2+MXP1m9/IS0lQgKXa2iOKAk5S1QwZj+aF5m9bZ1ya7uRSZiK7k32Tp
	 cPyfic9k+SXTN0zyJovtWc5i4QlwnHWCQ7zPvMYwB4Kmvmk/YiRwIQvEooMDQaq92Z
	 7+scnlRaNVAEd8ZERye9Fxa7htaGiUArPQR3aS7ol1QmrCXaN1hZA84lySCaLcJ6JA
	 6qFKvjj0XWP0TsYJqpZzkS+F0yfGOAphtaIMWq/o8m5Julk0e90Yj6maRvGG3kFOaY
	 c4zEilz1uAHKA==

The current implementation doesn't use extack, just returns an error 
code, because many callbacks to the qdisc don't get extack as a 
parameter. However, I agree with you, these messages would be helpful 
for the user when an operation fails due to hardware limitations - it 
will be easier than guessing what caused a EINVAL, so I'll add them. I 
will review which callbacks lacked an extack, and I might add it if it's 
meaningful for them.

> 
>>> If such limits exist, it may make sense to provide a knob to query
>>> (maybe ethtool)
>>
>> Sounds legit, but I'm not sure what would be the best interface for 
>> that. Ethtool is not involved at all in this implementation, and AFAIK 
>> it doesn't contain any existing command for similar stuff. We could 
>> hook into set-channels and add new type of channels for HTB, but the 
>> semantics isn't very clear, because HTB queues != HTB leaf classes, 
>> and I don't know if it's allowed to extend this interface (if so, I 
>> have more thoughts of extending it for other purposes).
>>
> 
> More looking to make sure no suprise to the user. Either the user can
> discover what the constraints are or when they provision they get a
> a message like "cannot offload more than 3 hierarchies" or "use devlink
> if you want to use more than 256 classes", etc.

Yes, it makes perfect sense. Messages are even more user-friendly, as 
for me. So, I'll add such messages to extack, and as the limitations are 
driver-specific, I'll pass extack to the driver.

I will respin when net-next reopens, in the meanwhile comments are welcome.

Thanks,
Max

> 
> cheers,
> jamal

