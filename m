Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F39D10E967
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 12:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLBLPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 06:15:31 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54292 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfLBLPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 06:15:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TjiHOwD_1575285323;
Received: from jingxuanljxdeMacBook-Pro.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjiHOwD_1575285323)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Dec 2019 19:15:23 +0800
Subject: Re: [PATCH] net: sched: keep __gnet_stats_copy_xxx() same semantics
 for percpu stats
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20191128063048.90282-1-dust.li@linux.alibaba.com>
 <CAM_iQpVYS9Am6G46iiNhg_OAft_=CLd5ziAFsMKt8sLmhuMCnQ@mail.gmail.com>
From:   Dust Li <dust.li@linux.alibaba.com>
Message-ID: <8a7dd222-33bd-1045-e72b-f7ec2ae05381@linux.alibaba.com>
Date:   Mon, 2 Dec 2019 19:15:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVYS9Am6G46iiNhg_OAft_=CLd5ziAFsMKt8sLmhuMCnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/19 1:44 PM, Cong Wang wrote:
> On Wed, Nov 27, 2019 at 10:31 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>> __gnet_stats_copy_basic/queue() support both percpu stat and
>> non-percpu stat, but they are handle in a different manner:
>> 1. For percpu stat, percpu stats are added to the return value;
>> 2. For non-percpu stat, non-percpu stats will overwrite the
>>     return value;
>> We should keep the same semantics for both type.
>>
>> This patch makes percpu stats follow non-percpu's manner by
>> reset the return bstats before add the percpu bstats to it.
>> Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
>> they dump the right statistics for percpu qdisc.
>>
>> One more thing, the sch->q.qlen is not set with nonlock child
>> qdisc in mq_dump()/mqprio_dump(), add that.
>>
>> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
>> ---
>>   net/core/gen_stats.c   |  2 ++
>>   net/sched/sch_mq.c     | 34 ++++++++++++++++------------------
>>   net/sched/sch_mqprio.c | 35 +++++++++++++++++------------------
>>   3 files changed, 35 insertions(+), 36 deletions(-)
>>
>> diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
>> index 1d653fbfcf52..d71af69196c9 100644
>> --- a/net/core/gen_stats.c
>> +++ b/net/core/gen_stats.c
>> @@ -120,6 +120,7 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
>>   {
>>          int i;
>>
>> +       memset(bstats, 0, sizeof(*bstats));
>>          for_each_possible_cpu(i) {
>>                  struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
>>                  unsigned int start;
>> @@ -288,6 +289,7 @@ __gnet_stats_copy_queue_cpu(struct gnet_stats_queue *qstats,
>>   {
>>          int i;
>>
>> +       memset(qstats, 0, sizeof(*qstats));
>
> I think its caller is responsible to clear the stats, so you don't need to
> clear them here? It looks like you do memset() twice.

Yes, I should do this in its caller. I will change it, thanks.

The memset() is in two different functions, one for xxx_basic_cpu(), and the

other for xxx_queue_cpu().

> Does this patch fix any bug? It looks more like a clean up to me, if so
> please mark it for net-next.

It only fixes the 'sch->q.qlen' not set for NOLOCK child qdisc. But as 
Dave said,

I should split that into an individual patch. So I will change this and 
mark it

for net-next.


Thanks

Dust Li

