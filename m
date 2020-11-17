Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97ADB2B72C5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgKQX7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:59:23 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:11475 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgKQX7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:59:23 -0500
Received: from [192.168.1.8] (unknown [116.234.4.84])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2332A5C15FD;
        Wed, 18 Nov 2020 07:21:09 +0800 (CST)
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
 <459a1453-8026-cca1-fb7c-ded0890992cf@ucloud.cn>
 <CAM_iQpXDzKEEVic5SOiWsc30ipppYMHL4q0-J6mP6u0Brr1KGw@mail.gmail.com>
 <2fe1ec73-eeeb-f32e-b006-afd135e03433@ucloud.cn>
 <CAM_iQpXtw4YLWjoSGwxhZMnG8Kismiu-nmqgFJpsZ6AuzX82tg@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7f897550-119f-e149-3c9d-cf2eb8964d63@ucloud.cn>
Date:   Wed, 18 Nov 2020 07:21:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXtw4YLWjoSGwxhZMnG8Kismiu-nmqgFJpsZ6AuzX82tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZS0lCT0xNQx5DHhhPVkpNS05NTk5JTUJOQ0tVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OE06KDo*MD05HD0cTRMqIUgK
        TAlPChpVSlVKTUtOTU5OSU1CTEhPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VT1VDT1lXWQgBWUFIQkJMNwY+
X-HM-Tid: 0a75d88310102087kuqy2332a5c15fd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/11/18 6:43, Cong Wang 写道:
> On Mon, Nov 16, 2020 at 8:06 PM wenxu <wenxu@ucloud.cn> wrote:
>>
>> On 11/17/2020 3:01 AM, Cong Wang wrote:
>>> On Sun, Nov 15, 2020 at 5:06 AM wenxu <wenxu@ucloud.cn> wrote:
>>>> 在 2020/11/15 2:05, Cong Wang 写道:
>>>>> On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
>>>>>> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
>>>>>> new file mode 100644
>>>>>> index 0000000..3a7ab92
>>>>>> --- /dev/null
>>>>>> +++ b/net/sched/act_frag.c
>>>>> It is kinda confusing to see this is a module. It provides some
>>>>> wrappers and hooks the dev_xmit_queue(), it belongs more to
>>>>> the core tc code than any modularized code. How about putting
>>>>> this into net/sched/sch_generic.c?
>>>>>
>>>>> Thanks.
>>>> All the operations in the act_frag  are single L3 action.
>>>>
>>>> So we put in a single module. to keep it as isolated/contained as possible
>>> Yeah, but you hook dev_queue_xmit() which is L2.
>>>
>>>> Maybe put this in a single file is better than a module? Buildin in the tc core code or not.
>>>>
>>>> Enable this feature in Kconifg with NET_ACT_FRAG?
>>> Sort of... If this is not an optional feature, that is a must-have
>>> feature for act_ct,
>>> we should just get rid of this Kconfig.
>>>
>>> Also, you need to depend on CONFIG_INET somewhere to use the IP
>>> fragment, no?
>>>
>>> Thanks.
>> Maybe the act_frag should rename to sch_frag and buildin kernel.
> sch_frag still sounds like a module. ;) This is why I proposed putting
> it into sch_generic.c.
>
>> This fcuntion can be used for all tc subsystem. There is no need for
>>
>> CONFIG_INET. The sched system depends on NET.
> CONFIG_INET is different from CONFIG_NET, right?

you are right. ip_do_fragment depends on this!

>
> Thanks.
>
