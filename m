Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B951214D22
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgGEOb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:31:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55379 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgGEOb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:31:57 -0400
Received: from [192.168.1.8] (unknown [116.237.151.97])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DBA0E40F4E;
        Sun,  5 Jul 2020 22:31:32 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
 <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
 <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
 <20200702173228.GH74252@localhost.localdomain>
 <CAM_iQpUrRzOi-S+49jMhDQCS0jqOmwObY3ZNa6n9qJGbPTXM-A@mail.gmail.com>
 <20200703004727.GU2491@localhost.localdomain>
 <349bb25a-7651-2664-25bc-3f613297fb5c@ucloud.cn>
 <20200703175057.GV2491@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7b7495bd-7d24-c30a-d0de-72bff6301506@ucloud.cn>
Date:   Sun, 5 Jul 2020 22:31:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200703175057.GV2491@localhost.localdomain>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLS0hJT0lPQkhZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXIjULOBw4SEgdIT5OOj0dDh43MjocVlZVQkhDTihJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PS46FQw5Sj5NAk0#AT80LRoX
        OiIaCyFVSlVKTkJIQk5CT0JISkpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk5KVUJMWVdZCAFZQU1KQ0o3Bg++
X-HM-Tid: 0a731f63ad892086kuqydba0e40f4e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/7/4 1:50, Marcelo Ricardo Leitner Ð´µÀ:
> On Fri, Jul 03, 2020 at 06:19:51PM +0800, wenxu wrote:
>> On 7/3/2020 8:47 AM, Marcelo Ricardo Leitner wrote:
>>> On Thu, Jul 02, 2020 at 02:39:07PM -0700, Cong Wang wrote:
>>>> On Thu, Jul 2, 2020 at 10:32 AM Marcelo Ricardo Leitner
>>>> <marcelo.leitner@gmail.com> wrote:
>>>>> On Thu, Jul 02, 2020 at 05:36:38PM +0800, wenxu wrote:
>>>>>> On 7/2/2020 1:33 AM, Cong Wang wrote:
>>>>>>> On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
>>>>>>>> On 7/1/2020 2:21 PM, wenxu wrote:
>>>>>>>>> On 7/1/2020 2:12 PM, Cong Wang wrote:
>>>>>>>>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
>>>>>>>>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
>>>>>>>>>> Same question: why act_mirred? You have to explain why act_mirred
>>>>>>>>>> has the responsibility to do this job.
>>>>>>>>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
>>>>>>>>>
>>>>>>>>> the act_mirred can decides whether do the fragment or not.
>>>>>>>> Hi cong,
>>>>>>>>
>>>>>>>>
>>>>>>>> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
>>>>>>>>
>>>>>>>> Did you have some other suggestion to solve this problem?
>>>>>>> Like I said, why not introduce a new action to handle fragment/defragment?
>>>>>>>
>>>>>>> With that, you can still pipe it to act_ct and act_mirred to achieve
>>>>>>> the same goal.
>>>>>> Thanks.  Consider about the act_fagment, There are two problem for this.
>>>>>>
>>>>>>
>>>>>> The frag action will put the ressemble skb to more than one packets. How these packets
>>>>>>
>>>>>> go through the following tc filter or chain?
>>>>> One idea is to listificate it, but I don't see how it can work. For
>>>>> example, it can be quite an issue when jumping chains, as the match
>>>>> would have to work on the list as well.
>>>> Why is this an issue? We already use goto action for use cases like
>>>> vlan pop/push. The header can be changed all the time, reclassification
>>>> is necessary.
>>> Hmm I'm not sure you got what I meant. That's operating on the very
>>> same skb... I meant that the pipe would handle a list of skbs (like in
>>> netif_receive_skb_list). So when we have a goto action with such skb,
>>> it would have to either break this list and reclassify each skb
>>> individually, or the classification would have to do it. Either way,
>>> it adds more complexity not just to the code but to the user as well
>>> and ends up doing more processing (in case of fragments or not) than
>>> if it knew how to output such packets properly. Or am I just
>>> over-complicating it?
>>>
>>> Or, instead of the explicit "frag" action, make act_ct re-fragment it.
>>> It would need to, somehow, push multiple skbs down the remaining
>>> action pipe. It boils down to the above as well.
>>>
>>>>>> When should use the act_fragament the action,  always before the act_mirred?
>>>>> Which can be messy if you consider chains like: "mirred, push vlan,
>>>>> mirred" or so. "frag, mirred, defrag, push vlan, frag, mirred".
>>>> So you mean we should have a giant act_do_everything?
>>> Not at all, but
>>>
>>>> "Do one thing do it well" is exactly the philosophy of designing tc
>>>> actions, if you are against this, you are too late in the game.
>>> in this case a act_output_it_well could do it. ;-)
>> agree, Maybe a act_output_ct action is better?
> Ahm, sorry, that wasn't really my intention here. I meant that I don't
> see an issue with mirred learning how to fragment it and, with that,
> do its action "well" (as subjective as the term can be).
Thanks£¬ I also think It is ok do fragment in the mirred output.
>
>>> Thanks,
>>>   Marcelo
>>>
