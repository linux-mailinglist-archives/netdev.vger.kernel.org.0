Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1600C48B247
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350043AbiAKQee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:34:34 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:7763 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349819AbiAKQea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:34:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1aSp7J_1641918856;
Received: from 30.39.146.113(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1aSp7J_1641918856)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jan 2022 00:34:17 +0800
Message-ID: <719f264e-a70d-7bed-0873-ffbba8381841@linux.alibaba.com>
Date:   Wed, 12 Jan 2022 00:34:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Avoid setting clcsock options after clcsock
 released
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641807505-54454-1-git-send-email-guwen@linux.alibaba.com>
 <ac977743-9696-9723-5682-97ebbcca6828@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <ac977743-9696-9723-5682-97ebbcca6828@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2022/1/11 6:03 pm, Karsten Graul wrote:
> On 10/01/2022 10:38, Wen Gu wrote:
>> We encountered a crash in smc_setsockopt() and it is caused by
>> accessing smc->clcsock after clcsock was released.
>>
> 
> In the switch() the function smc_switch_to_fallback() might be called which also
> accesses smc->clcsock without further checking. This should also be protected then?
> Also from all callers of smc_switch_to_fallback() ?
> 
> There are more uses of smc->clcsock (e.g. smc_bind(), ...), so why does this problem
> happen in setsockopt() for you only? I suspect it depends on the test case.
> 

Yes, it depends on the test case. The crash described here only happens one time when
I run a stress test of nginx/wrk, accompanied with frequent RNIC up/down operations.

Considering accessing smc->clcsock after its release is an uncommon, low probability
issue and only happens in setsockopt() in my test, I choce an simple way to fix it, using
the existing clcsock_release_lock, and only check in smc_setsockopt() and smc_getsockopt().

> I wonder if it makes sense to check and protect smc->clcsock at all places in the code where
> it is used... as of now we had no such races like you encountered. But I see that in theory
> this problem could also happen in other code areas.
> 

But inspired by your questions, I think maybe we should treat the race as a general problem?
Do you think it is necessary to find all the potential race related to the clcsock release and
fix them in a unified approach? like define smc->clcsock as RCU pointer, hold rcu read lock
before accessing smc->clcsock and call synchronize_rcu() before resetting smc->clcsock? just a rough idea :)

Or we should decide it later, do some more tests to see the probability of recurrence of this problem?

Thanks,
Wen Gu
