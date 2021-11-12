Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4AC44E0AA
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 04:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhKLDMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:12:52 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:56568 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234543AbhKLDMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 22:12:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Uw7Lai4_1636686599;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Uw7Lai4_1636686599)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Nov 2021 11:10:00 +0800
Subject: Re: [RFC PATCH 0/2] Two RFC patches for the same SMC socket wait
 queue mismatch issue
To:     Karsten Graul <kgraul@linux.ibm.com>, tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com
References: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
 <369755c0-8b3e-cf69-d7f2-8993700efc4a@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <d3b7969f-4bc5-5834-0a03-d361854d909e@linux.alibaba.com>
Date:   Fri, 12 Nov 2021 11:09:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <369755c0-8b3e-cf69-d7f2-8993700efc4a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/11 10:21 pm, Karsten Graul wrote:
> On 10/11/2021 13:50, Wen Gu wrote:
>> Hi, Karsten
>>
>> Thanks for your reply. The previous discussion about the issue of socket
>> wait queue mismatch in SMC fallback can be referred from:
>> https://lore.kernel.org/all/db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com/
>>
>> This set of patches includes two RFC patches, they are both aimed to fix
>> the same issue, the mismatch of socket wait queue in SMC fallback.
>>
>> In your last reply, I am suggested to add the complete description about
>> the intention of initial patch in order that readers can understand the
>> idea behind it. This has been done in "[RFC PATCH net v2 0/2] net/smc: Fix
>> socket wait queue mismatch issue caused by fallback" of this mail.
>>
>> Unfortunately, I found a defect later in the solution of the initial patch
>> or the v2 patch mentioned above. The defect is about fasync_list and related
>> to 67f562e3e14 ("net/smc: transfer fasync_list in case of fallback").
>>
>> When user applications use sock_fasync() to insert entries into fasync_list,
>> the wait queue they operate is smc socket->wq. But in initial patch or
>> the v2 patch, I swapped sk->sk_wq of smc socket and clcsocket in smc_create(),
>> thus the sk_data_ready / sk_write_space.. of smc will wake up clcsocket->wq
>> finally. So the entries added into smc socket->wq.fasync_list won't be woken
>> up at all before fallback.
>>
>> So the solution in initial patch or the v2 patch of this mail by swapping
>> sk->sk_wq of smc socket and clcsocket seems a bad way to fix this issue.
>>
>> Therefore, I tried another solution by removing the wait queue entries from
>> smc socket->wq to clcsocket->wq during the fallback, which is described in the
>> "[RFC PATCH net 2/2] net/smc: Transfer remaining wait queue entries" of this
>> mail. In our test environment, this patch can fix the fallback issue well.
> 
> Still running final tests but overall its working well here, too.
> Until we maybe find a 'cleaner' solution if this I would like to go with your
> current fixes. But I would like to improve the wording of the commit message and
> the comments a little bit if you are okay with that.
> 
> If you send a new series with the 2 patches then I would take them and post them
> to the list again with my changes.

Seems just the second patch alone will fix the issue.

> 
> What do you think?
> 

Thanks for your reply. I am glad that the second patch works well.

To avoid there being any misunderstanding between us, I want to explain 
that just the second patch "[RFC PATCH net 2/2] net/smc: Transfer 
remaining wait queue entries" alone will fix the issue well.

Because it transfers the remaining entries in smc socket->wq to 
clcsocket->wq during the fallback, so that the entries added into smc 
socket->wq before fallback will still works after fallback, even though 
user applications start to use clcsocket.


The first patch "[RFC PATCH net v2 0/2] net/smc: Fix socket wait queue 
mismatch issue caused by fallback" should be abandoned.

I sent it only to better explain the defect I found in my initial patch 
or this v2 patch. Hope it didn't bother you. Swapping the sk->sk_wq 
seems a bad way to fix the issue because it can not handle the 
fasync_list well. Unfortunately I found this defect until I almost 
finished it :(

So, I think maybe it is fine that just send the second patch "[RFC PATCH 
net 2/2] net/smc: Transfer remaining wait queue entries" again. I will 
send it later.

And, it is okay for me if you want to improve the commit messages or 
comments.

Thank you.

Cheers,
Wen Gu
