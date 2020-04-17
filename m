Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE241ADBCE
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 13:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgDQLCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 07:02:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55870 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729558AbgDQLCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 07:02:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD378619751386BAEFC1;
        Fri, 17 Apr 2020 19:01:58 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Apr 2020
 19:01:53 +0800
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
To:     Steffen Klassert <steffen.klassert@secunet.com>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
 <20200328112302.GA13121@gauss3.secunet.de>
 <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
 <20200406090327.GF13121@gauss3.secunet.de>
 <ff4b3d2c-e6b3-33d6-141b-b093db084a18@huawei.com>
 <20200415071443.GV13121@gauss3.secunet.de>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <f8c7d907-b6f4-c95f-b1f1-57131d19715c@huawei.com>
Date:   Fri, 17 Apr 2020 19:01:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200415071443.GV13121@gauss3.secunet.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/15 15:14, Steffen Klassert wrote:
> On Thu, Apr 09, 2020 at 04:19:37PM +0800, Yuehaibing wrote:
>>
>>
>> On 2020/4/6 17:03, Steffen Klassert wrote:
>>> On Mon, Mar 30, 2020 at 10:05:32PM +0800, Yuehaibing wrote:
>>>> On 2020/3/28 19:23, Steffen Klassert wrote:
>>>>> On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
>>>>>> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
>>>>>> mark and different priorities"), we allow duplicate policies with
>>>>>> different priority, this WARN is not needed any more.
>>>>>
>>>>> Can you please describe a bit more detailed why this warning
>>>>> can't trigger anymore?
>>>>
>>>> No, this warning is triggered while detect a duplicate entry in the policy list
>>>>
>>>> regardless of the priority. If we insert policy like this:
>>>>
>>>> policy A (mark.v = 3475289, mark.m = 0, priority = 1)	//A is inserted
>>>> policy B (mark.v = 0, mark.m = 0, priority = 0) 	//B is inserted
>>>> policy C (mark.v = 3475289, mark.m = 0, priority = 0)	//C is inserted and B is deleted
>>>
>>> The codepath that replaces a policy by another should just trigger
>>> on policy updates (XFRM_MSG_UPDPOLICY). Is that the case in your
>>> test?
>>
>> Yes, this is triggered by XFRM_MSG_UPDPOLICY
>>
>>>
>>> It should not be possible to add policy C with XFRM_MSG_NEWPOLICY
>>> as long as you have policy B inserted.
>>>
>>> The update replaces an old policy by a new one, the lookup keys of
>>> the old policy must match the lookup keys of the new one. But policy
>>> B has not the same lookup keys as C, the mark is different. So B should
>>> not be replaced with C.
>>
>> 1436 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
>> 1437                                    struct xfrm_policy *pol)
>> 1438 {
>> 1439         u32 mark = policy->mark.v & policy->mark.m;
>> 1440
>> 1441         if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
>> 1442                 return true;
>> 1443
>> 1444         if ((mark & pol->mark.m) == pol->mark.v &&    //policy is C, pol is B, so mark is 0, pol->mark.m is 0, pol->mark.v is 0
>> 1445             policy->priority == pol->priority)	   //priority is same zero, so return true, B is replaced with C
>> 1446                 return true;
>> 1447
>> 1448         return false;
>> 1449 }
>>
>> Should xfrm_policy_mark_match be fixed？
> 
> Yes, xfrm_policy_mark_match should only replace if the found
> policy has the same lookup keys.

I'm wonder that lookup keys means association of mark.v and mark.m, or the mark (mark.v & mark.m).

In above my case, policy B and C has the same mark (that is 0), if the lookup keys is mark, replacement is permitted.

If lookup keys is association of mark.v and mark.m, then:

policy E (mark.v = 0x1, mark.m = 0x3, priority = 1)
policy F (mark.v = 0x1, mark.m = 0x5, priority = 1)

E should not be replaced by F, but this is permitted now.

> 
> .
> 

