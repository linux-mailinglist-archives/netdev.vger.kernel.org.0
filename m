Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A891B4449
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgDVMSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:18:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2872 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729017AbgDVMSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:18:10 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6D3479F84AA3A02A7E97;
        Wed, 22 Apr 2020 20:18:05 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Apr 2020
 20:18:03 +0800
Subject: Re: [PATCH] xfrm: policy: Only use mark as policy lookup key
To:     Steffen Klassert <steffen.klassert@secunet.com>
References: <20200421143149.45108-1-yuehaibing@huawei.com>
 <20200422093344.GY13121@gauss3.secunet.de>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lucien.xin@gmail.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <1650fd55-dd70-f687-88b6-d32a04245915@huawei.com>
Date:   Wed, 22 Apr 2020 20:18:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200422093344.GY13121@gauss3.secunet.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/22 17:33, Steffen Klassert wrote:
> On Tue, Apr 21, 2020 at 10:31:49PM +0800, YueHaibing wrote:
>> While update xfrm policy as follow:
>>
>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>>  priority 1 mark 0 mask 0x10
>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>>  priority 2 mark 0 mask 0x00
>> ip -6 xfrm policy update src fd00::1/128 dst fd00::2/128 dir in \
>>  priority 2 mark 0 mask 0x10
>>
>> We get this warning:
>>
>> WARNING: CPU: 0 PID: 4808 at net/xfrm/xfrm_policy.c:1548
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 0 PID: 4808 Comm: ip Not tainted 5.7.0-rc1+ #151
>> Call Trace:
>> RIP: 0010:xfrm_policy_insert_list+0x153/0x1e0
>>  xfrm_policy_inexact_insert+0x70/0x330
>>  xfrm_policy_insert+0x1df/0x250
>>  xfrm_add_policy+0xcc/0x190 [xfrm_user]
>>  xfrm_user_rcv_msg+0x1d1/0x1f0 [xfrm_user]
>>  netlink_rcv_skb+0x4c/0x120
>>  xfrm_netlink_rcv+0x32/0x40 [xfrm_user]
>>  netlink_unicast+0x1b3/0x270
>>  netlink_sendmsg+0x350/0x470
>>  sock_sendmsg+0x4f/0x60
>>
>> Policy C and policy A has the same mark.v and mark.m, so policy A is
>> matched in first round lookup while updating C. However policy C and
>> policy B has same mark and priority, which also leads to matched. So
>> the WARN_ON is triggered.
>>
>> xfrm policy lookup should only be matched when the found policy has the
>> same lookup keys (mark.v & mark.m) no matter priority.
>>
>> Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/xfrm/xfrm_policy.c | 16 +++++-----------
>>  1 file changed, 5 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
>> index 297b2fd..67d0469 100644
>> --- a/net/xfrm/xfrm_policy.c
>> +++ b/net/xfrm/xfrm_policy.c
>> @@ -1436,13 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
>>  				   struct xfrm_policy *pol)
>>  {
>> -	u32 mark = policy->mark.v & policy->mark.m;
>> -
>> -	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
>> -		return true;
>> -
>> -	if ((mark & pol->mark.m) == pol->mark.v &&
>> -	    policy->priority == pol->priority)
> 
> If you remove the priority check, you can't insert policies with matching
> mark and different priorities anymore. This brings us back the old bug.

Yes, this is true.

> 
> I plan to apply the patch from Xin Long, this seems to be the right way
> to address this problem.

That still brings an issue, update like this:

policy A (mark.v = 1, mark.m = 0, priority = 1)
policy B (mark.v = 1, mark.m = 0, priority = 1)

A and B will all in the list.

So should do this:

 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
                                   struct xfrm_policy *pol)
 {
-       u32 mark = policy->mark.v & policy->mark.m;
-
-       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-               return true;
-
-       if ((mark & pol->mark.m) == pol->mark.v &&
+       if ((policy->mark.v & policy->mark.m) == (pol->mark.v & pol->mark.m) &&
            policy->priority == pol->priority)
                return true;



> 
> .
> 

