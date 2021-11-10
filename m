Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60B744C18F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhKJMxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:53:08 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41807 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhKJMxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:53:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uvw.k.b_1636548616;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Uvw.k.b_1636548616)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Nov 2021 20:50:17 +0800
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com,
        davem@davemloft.net, kuba@kernel.org, guwen@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
 <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
 <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
 <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
 <c26da743-36fb-e1c3-c13f-460b3d2dbb4c@linux.alibaba.com>
 <db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <a23d2e8c-0611-da1f-d575-3cf8295f8aaf@linux.alibaba.com>
Date:   Wed, 10 Nov 2021 20:50:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/6 8:51 pm, Karsten Graul wrote:
> On 04/11/2021 05:39, Wen Gu wrote:
>> Thanks for your suggestions about implementing SMC own sk_data_ready / sk_write_space and forwarding call to clcsock. It's a great idea. But I found some difficulties here in implementation process:
>>
>> In my humble opinion, SMC own sk_write_space implementation should be called by clcsk->sk_write_space and complete the following steps:
>>
>> 1) Get smc_sock through clcsk->sk_user_data, like what did in smc_clcsock_data_ready().
>>
>> 2) Forward call to original clcsk->sk_write_space, it MIGHT wake up clcsk->sk_wq, depending on whether certain conditions are met.
>>
>> 3) Wake up smc sk->sk_wq to nodify application if clcsk->sk_write_space acctually wakes up clcsk->sk_wq.
>>
>> In step 3), it seems a bit troublesome for SMC to know whether clcsk->sk_write_space acctually wake up clcsk->sk_wq, which is a black box to SMC.
>>
>> There might be a feasible way that add a wait_queue_head_t to clcsk->sk_wq and report to SMC when clcsk->sk_wq is waked up. Then SMC can report to application by waking up smc sk->sk_wq. But that seems to be complex and redundancy.
> 
> Hmm so when more certain conditions have to be met in (2) to
> actually wake up clcsk->sk_wq then this might not be the right
> way to go...
> So when there are no better ways I would vote for your initial patch.
> But please add the complete description about how this is intended to
> work to this patch to allow readers to understand the idea behind it.
> 
> Thank you.
> 

Thanks for your suggestions.

Unfortunately, I found a defect about fasync_list in my initial patch. 
Swapping sk->sk_wq of smc socket and clcsocket seems also an imperfect 
way to fix the issue. I will describe this in the next new mail.

In addition, I will provide another RFC patch which is aimed to fix the 
same issue. It will be also included in the next new mail.

Thank you.

Cheers,
Wen Gu
