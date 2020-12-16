Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4D72DBFB7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgLPLsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:48:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14087 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLPLsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:48:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd9f3fb0001>; Wed, 16 Dec 2020 03:48:11 -0800
Received: from [172.27.12.181] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 11:47:56 +0000
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
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <5f4f0785-54cb-debc-1f16-b817b83fbd96@nvidia.com>
Date:   Wed, 16 Dec 2020 13:47:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <845d2678-b679-b2a8-cf00-d4c7791cd540@mojatatu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608119291; bh=PTuxcHRYE4T4772/D15oKN32MG5of89BDvCf58NgRMU=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ECzWhnEuyE6svP76j8ds9AvZG0hezKAC43azWMjoYcNiMmsXXKifYButqWwTliO/D
         yW9MaGW+8g75JI89wM+E3fpGOgVslfxpG1qyj82fXpBSvALUiyNZAJKFnRFFf1sqOu
         +4vIX0dgWGyDiM68maF+p2MlE7Mdw/QAhXVudHFlafrm+m9RsHsxcgfbQ6tZZlBU22
         nckt1C6+VSiD80DNUTps9m5419SxP7MJqZ0d7zqQX19G42Twf8q22LkDTUpioavxcd
         ZwNlXPanTl41L4KTZAN04gqamwZ56aAA2q3CdZtftwqcX0sa9l+X0SNz52mWZJXgPU
         OQTHtwN4CIihg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-15 18:37, Jamal Hadi Salim wrote:
> On 2020-12-14 3:30 p.m., Maxim Mikityanskiy wrote:
>> On 2020-12-14 21:35, Cong Wang wrote:
>>> On Mon, Dec 14, 2020 at 7:13 AM Maxim Mikityanskiy 
>>> <maximmi@nvidia.com> wrote:
>>>>
>>>> On 2020-12-11 21:16, Cong Wang wrote:
>>>>> On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy 
>>>>> <maximmi@mellanox.com> wrote:
>>>>>>
> 
> 
>>>
>>> Interesting, please explain how your HTB offload still has a global rate
>>> limit and borrowing across queues?
>>
>> Sure, I will explain that.
>>
>>> I simply can't see it, all I can see
>>> is you offload HTB into each queue in ->attach(),
>>
>> In the non-offload mode, the same HTB instance would be attached to 
>> all queues. In the offload mode, HTB behaves like MQ: there is a root 
>> instance of HTB, but each queue gets a separate simple qdisc (pfifo). 
>> Only the root qdisc (HTB) gets offloaded, and when that happens, the 
>> NIC creates an object for the QoS root.
>>
>> Then all configuration changes are sent to the driver, and it issues 
>> the corresponding firmware commands to replicate the whole hierarchy 
>> in the NIC. Leaf classes correspond to queue groups (in this 
>> implementation queue groups contain only one queue, but it can be 
>> extended),
> 
> 
> FWIW, it is very valuable to be able to abstract HTB if the hardware
> can emulate it (users dont have to learn about new abstracts).

Yes, that's the reason for using an existing interface (HTB) to 
configure the feature.

> Since you are expressing a limitation above:
> How does the user discover if they over-provisioned i.e single
> queue example above?

It comes to the CPU usage. If the core that serves the queue is busy 
with sending packets 100% of time, you need more queues. Also, if the 
user runs more than one application belonging to the same class, and 
pins them to different cores, it makes sense to create more than one queue.

I'd like to emphasize that this is not a hard limitation. Our hardware 
and firmware supports multiple queues per class. What's needed is the 
support from the driver side and probably an additional parameter to tc 
class add to specify the number of queues to reserve.

> If there are too many corner cases it may
> make sense to just create a new qdisc.
> 
>> and inner classes correspond to entities called TSARs.
>>
>> The information about rate limits is stored inside TSARs and queue 
>> groups. Queues know what groups they belong to, and groups and TSARs 
>> know what TSAR is their parent. A queue is picked in ndo_select_queue 
>> by looking at the classification result of clsact. So, when a packet 
>> is put onto a queue, the NIC can track the whole hierarchy and do the 
>> HTB algorithm.
>>
> 
> Same question above:
> Is there a limit to the number of classes that can be created?

Yes, the commit message of the mlx5 patch lists the limitations of our 
NICs. Basically, it's 256 leaf classes and 3 levels of hierarchy.

> IOW, if someone just created an arbitrary number of queues do they
> get errored-out if it doesnt make sense for the hardware?

The current implementation starts failing gracefully if the limits are 
exceeded. The tc command won't succeed, and everything will roll back to 
the stable state, which was just before the tc command.

> If such limits exist, it may make sense to provide a knob to query
> (maybe ethtool)

Sounds legit, but I'm not sure what would be the best interface for 
that. Ethtool is not involved at all in this implementation, and AFAIK 
it doesn't contain any existing command for similar stuff. We could hook 
into set-channels and add new type of channels for HTB, but the 
semantics isn't very clear, because HTB queues != HTB leaf classes, and 
I don't know if it's allowed to extend this interface (if so, I have 
more thoughts of extending it for other purposes).

> and if such limits can be adjusted it may be worth
> looking at providing interfaces via devlink.

Not really. At the moment, there isn't a good reason to decrease the 
maximum limits. It would make sense if it could free up some resources 
for something else, but AFAIK it's not the case now.

Thanks,
Max

> cheers,
> jamal
> 
> 
> cheers,
> jamal

