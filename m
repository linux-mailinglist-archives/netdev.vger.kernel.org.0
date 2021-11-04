Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75894444DFA
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 05:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDEm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 00:42:27 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37077 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhKDEm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 00:42:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uv-SO4G_1636000786;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Uv-SO4G_1636000786)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Nov 2021 12:39:47 +0800
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
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <c26da743-36fb-e1c3-c13f-460b3d2dbb4c@linux.alibaba.com>
Date:   Thu, 4 Nov 2021 12:39:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/2 5:25 pm, Karsten Graul wrote:
> On 01/11/2021 07:15, Wen Gu wrote:
>> Before explaining my intentions, I thought it would be better to describe the issue I encountered first：
>>
>> In nginx/wrk tests, when nginx uses TCP and wrk uses SMC to replace TCP, wrk should fall back to TCP and get correct results theoretically, But in fact it only got all zeros.
> 
> Thank you for the very detailed description, I now understand the situation.
> 
> The fix is not obvious and not easy to understand for the reader of the code,
> did you think about a fix that uses own sk_data_ready / sk_write_space
> implementations on the SMC socket to forward the call to the clcsock in the
> fallback situation?
> 
> I.e. we already have smc_tx_write_space(), and there is smc_clcsock_data_ready()
> which is right now only used for the listening socket case.
> 
> If this works this would be a much cleaner and more understandable way to fix this issue.
> 

Thanks for your suggestions about implementing SMC own sk_data_ready / 
sk_write_space and forwarding call to clcsock. It's a great idea. But I 
found some difficulties here in implementation process:

In my humble opinion, SMC own sk_write_space implementation should be 
called by clcsk->sk_write_space and complete the following steps:

1) Get smc_sock through clcsk->sk_user_data, like what did in 
smc_clcsock_data_ready().

2) Forward call to original clcsk->sk_write_space, it MIGHT wake up 
clcsk->sk_wq, depending on whether certain conditions are met.

3) Wake up smc sk->sk_wq to nodify application if clcsk->sk_write_space 
acctually wakes up clcsk->sk_wq.

In step 3), it seems a bit troublesome for SMC to know whether 
clcsk->sk_write_space acctually wake up clcsk->sk_wq, which is a black 
box to SMC.

There might be a feasible way that add a wait_queue_head_t to 
clcsk->sk_wq and report to SMC when clcsk->sk_wq is waked up. Then SMC 
can report to application by waking up smc sk->sk_wq. But that seems to 
be complex and redundancy.

I'm looking forward to hear your opinion about it. Thank you!


cheers,
Wen Gu
