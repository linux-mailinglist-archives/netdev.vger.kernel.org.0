Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C331A30C4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDIITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:19:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41934 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbgDIITw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 04:19:52 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8225558B6D2409B32471;
        Thu,  9 Apr 2020 16:19:43 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 9 Apr 2020
 16:19:38 +0800
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
To:     Steffen Klassert <steffen.klassert@secunet.com>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
 <20200328112302.GA13121@gauss3.secunet.de>
 <1d3596fb-c7e3-16c9-f48f-fe58e9a2569a@huawei.com>
 <20200406090327.GF13121@gauss3.secunet.de>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <ff4b3d2c-e6b3-33d6-141b-b093db084a18@huawei.com>
Date:   Thu, 9 Apr 2020 16:19:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200406090327.GF13121@gauss3.secunet.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/4/6 17:03, Steffen Klassert wrote:
> On Mon, Mar 30, 2020 at 10:05:32PM +0800, Yuehaibing wrote:
>> On 2020/3/28 19:23, Steffen Klassert wrote:
>>> On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
>>>> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
>>>> mark and different priorities"), we allow duplicate policies with
>>>> different priority, this WARN is not needed any more.
>>>
>>> Can you please describe a bit more detailed why this warning
>>> can't trigger anymore?
>>
>> No, this warning is triggered while detect a duplicate entry in the policy list
>>
>> regardless of the priority. If we insert policy like this:
>>
>> policy A (mark.v = 3475289, mark.m = 0, priority = 1)	//A is inserted
>> policy B (mark.v = 0, mark.m = 0, priority = 0) 	//B is inserted
>> policy C (mark.v = 3475289, mark.m = 0, priority = 0)	//C is inserted and B is deleted
> 
> The codepath that replaces a policy by another should just trigger
> on policy updates (XFRM_MSG_UPDPOLICY). Is that the case in your
> test?

Yes, this is triggered by XFRM_MSG_UPDPOLICY

> 
> It should not be possible to add policy C with XFRM_MSG_NEWPOLICY
> as long as you have policy B inserted.
> 
> The update replaces an old policy by a new one, the lookup keys of
> the old policy must match the lookup keys of the new one. But policy
> B has not the same lookup keys as C, the mark is different. So B should
> not be replaced with C.

1436 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
1437                                    struct xfrm_policy *pol)
1438 {
1439         u32 mark = policy->mark.v & policy->mark.m;
1440
1441         if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
1442                 return true;
1443
1444         if ((mark & pol->mark.m) == pol->mark.v &&    //policy is C, pol is B, so mark is 0, pol->mark.m is 0, pol->mark.v is 0
1445             policy->priority == pol->priority)	   //priority is same zero, so return true, B is replaced with C
1446                 return true;
1447
1448         return false;
1449 }

Should xfrm_policy_mark_match be fixed？

> 
>> policy D (mark.v = 3475289, mark.m = 0, priority = 1)	
>>
>> while finding delpol in xfrm_policy_insert_list,
>> first round delpol is matched C, whose priority is less than D, so contiue the loop,
>> then A is matched， WARN_ON is triggered.  It seems the WARN is useless.
> 
> Looks like the warning is usefull, it found a bug.
> 
> 
> .
> 

