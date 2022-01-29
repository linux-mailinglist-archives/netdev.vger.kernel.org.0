Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C98A4A2B7E
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 04:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352315AbiA2Dn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 22:43:27 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40744 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241747AbiA2Dn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 22:43:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V34uYIR_1643427803;
Received: from 30.15.211.55(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0V34uYIR_1643427803)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 29 Jan 2022 11:43:24 +0800
Message-ID: <a297c8cf-384c-2184-aabb-49ee32476d99@linux.alibaba.com>
Date:   Sat, 29 Jan 2022 11:43:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Content-Language: en-US
To:     Stefan Raspl <raspl@linux.ibm.com>, kgraul@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
 <1f13f001-e4d7-fdcd-6575-caa1be1526e1@linux.ibm.com>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <1f13f001-e4d7-fdcd-6575-caa1be1526e1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/1/25 17:42, Stefan Raspl wrote:
> 
> That's some truly substantial improvements!
> But we need to be careful with protocol-level changes: There are other operating systems like z/OS and AIX which have compatible implementations of SMC, too. Changes like a reduction of connections per link group or usage of reserved fields would need to be coordinated, and likely would have unwanted side-effects even when used with older Linux kernel versions.
> Changing the protocol is "expensive" insofar as it requires time to thoroughly discuss the changes, perform compatibility tests, and so on.
> So I would like to urge you to investigate alternative ways that do not require protocol-level changes to address this scenario, e.g. by modifying the number of completion queue elements, to see if this could yield similar results.
> 
> Thx!
> 

Yes, there are alternative ways, as RNR caused by the missmatch of send rate and receive rate, which means sending too fast
or receiving too slow. What I have done in this patch is to backpressure the sending side when sending too fast.

Another solution is to process and refill the receive queue as quickly as posibble, which requires no protocol-level change. 
The fllowing modifications are needed:
- Enqueue cdc msgs to backlog queues instead of processing in rx tasklet. llc msgs remain unchanged.
- A mempool is needed as cdc msgs are processed asynchronously. Allocate new receive buffers from mempool when refill receive queue.
- Schedule backlog queues to other cpus, which are calculated by 4-tuple or 5-tuple hash of the connections, to process the cdc msgs,
  in order to reduce the usage of the cpu where rx tasklet runs on.

the pseudocode shows below:
rx_tasklet
    if cdc_msgs
        enqueue to backlog;
	maybe smp_call_function_single_async is needed to wakeup the corresponding cpu to process backlog;
        allocate new buffer and modify the sge in rq_wr;
    else
        process remains unchanged;
    endif

    post_recv rq_wr;
end rx_tasklet

smp_backlog_process in corresponding cpu, called by smp_call_function_single_async
    for connections hashed to this cpu
        for cdc_msgs in backlog
            process cdc msgs;
        end cdc_msgs
    end connections
end smp_backlog_process

I‘d like to hear your suggestions of this solution.
Thank you.
