Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FEE1293D9
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLWJzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:55:49 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36202 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbfLWJzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 04:55:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tli.qQa_1577094938;
Received: from jingxuanljxdeMacBook-Pro.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0Tli.qQa_1577094938)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 23 Dec 2019 17:55:39 +0800
Subject: Re: [PATCH net-next 0/2] net: sched: unify __gnet_stats_copy_xxx()
 for percpu and non-percpu
To:     David Miller <davem@davemloft.net>
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        john.fastabend@gmail.com, jiri@resnulli.us,
        tonylu@linux.alibaba.com, netdev@vger.kernel.org
References: <20191217084718.52098-1-dust.li@linux.alibaba.com>
 <20191220.165446.1167328110197614173.davem@davemloft.net>
From:   Dust Li <dust.li@linux.alibaba.com>
Message-ID: <f082962e-282f-f0dc-8773-b9107d39e482@linux.alibaba.com>
Date:   Mon, 23 Dec 2019 17:55:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191220.165446.1167328110197614173.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/21/19 8:54 AM, David Miller wrote:
> From: Dust Li <dust.li@linux.alibaba.com>
> Date: Tue, 17 Dec 2019 16:47:16 +0800
>
>> Currently, __gnet_stats_copy_xxx() will overwrite the return value when
>> percpu stats are not enabled. But when percpu stats are enabled, it will
>> add the percpu stats to the result. This inconsistency brings confusion to
>> its callers.
>>
>> This patch series unify the behaviour of __gnet_stats_copy_basic() and
>> __gnet_stats_copy_queue() for percpu and non-percpu stats and fix an
>> incorrect statistic for mqprio class.
>>
>> - Patch 1 unified __gnet_stats_copy_xxx() for both percpu and non-percpu
>> - Patch 2 depending on Patch 1, fixes the problem that 'tc class show'
>>    for mqprio class is always 0.
> I think this is going to break the estimator.
>
> The callers of est_fetch_counters() expect continually incrementing
> statistics.  It does relative subtractions from previous values each
> time, so if we just reset on the next statistics fetch it won't work.
>
> Sorry I can't apply this.


Hi David,

Thanks for your reply.


I checked the callers of est_fetch_counters(). I think there is a little
misunderstanding here.We memset() the 'gnet_stats_basic_packed *b'which
is not the original data of the estimator,but just the return value.
Actually, it has been already memseted in est_fetch_counters() now. So it
shouldnot break the estimator.

static void est_fetch_counters(struct net_rate_estimator *e,
                                struct gnet_stats_basic_packed *b)
{
/        memset(b, 0, sizeof(*b));     // <<--- Here b is already memseted/
         if (e->stats_lock)
                 spin_lock(e->stats_lock);

         __gnet_stats_copy_basic(e->running, b, e->cpu_bstats, e->bstats);

         if (e->stats_lock)
                 spin_unlock(e->stats_lock);

}


The purpose of this memset() is to maintain a consistent semantics for both
percpu and non-percpu statisticsin __gnet_stats_copy_basic().


Thanks

Dust

