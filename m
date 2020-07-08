Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755B3219305
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGHWBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:01:55 -0400
Received: from out0-146.mail.aliyun.com ([140.205.0.146]:51018 "EHLO
        out0-146.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHWBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594245712; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=XvRo02wDFlzPEG88nxWAZF4+GqQdOYUmE3inFW3eyKI=;
        b=Dp9KpxUR5t0DnRzdUBpTtntCAxDGNNHYcgDJiKr1ekGlA6uZBE5woes9Pc0I1/pkEQMuGhP51tjsYiifh01c3zoz2u0CfBit/zFCsdVtVtMZk73dTKqbx2Z5yeMkn16Q8Z0R1rndO60jgVSMeVd0eiqAHemgYSn8Mw18L/VPIAE=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01a16378;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I-OFJQ3_1594245710;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-OFJQ3_1594245710)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 06:01:51 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <f7b8e306-5169-ad5c-0a5e-7ec6333e24bf@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <f59a74bb-a097-acb2-5d4b-d2230022197f@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 06:01:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f7b8e306-5169-ad5c-0a5e-7ec6333e24bf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 2:37 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 9:38 AM, YU, Xiangning wrote:
>> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
>> use of outbound bandwidth on a shared link. With the help of lockless
>> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
>> designed to scale in the cloud data centers.
>>
> 
> ...
> 
> This ltb_class struct has a size of 1579584 bytes :/
> 
>> +struct ltb_class {
>> +	struct Qdisc_class_common common;
>> +	struct psched_ratecfg ratecfg;
>> +	struct psched_ratecfg ceilcfg;
>> +	u32 prio;
>> +	struct ltb_class *parent;
>> +	struct Qdisc *qdisc;
>> +	struct Qdisc *root_qdisc;
>> +	u32 classid;
>> +	struct list_head pnode;
>> +	unsigned long state; ____cacheline_aligned_in_smp
>> +
>> +	/* Aggr/drain context only */
>> +	s64 next_timestamp; ____cacheline_aligned_in_smp
>> +	int num_cpus;
>> +	int last_cpu;
>> +	s64 bw_used;
>> +	s64 last_bytes;
>> +	s64 last_timestamp;
>> +	s64 stat_bytes;
>> +	s64 stat_packets;
>> +	atomic64_t stat_drops;
>> +
>> +	/* Balance delayed work only */
>> +	s64 rate; ____cacheline_aligned_in_smp
>> +	s64 ceil;
>> +	s64 high_water;
>> +	int drop_delay;
>> +	s64 bw_allocated;
>> +	bool want_more;
>> +
>> +	/* Shared b/w aggr/drain thread and balancer */
>> +	unsigned long curr_interval; ____cacheline_aligned_in_smp
>> +	s64 bw_measured;	/* Measured actual bandwidth */
>> +	s64 maxbw;	/* Calculated bandwidth */
>> +
>> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) aggr_queues[MAX_CPU_COUNT];
>> +	____cacheline_aligned_in_smp
>> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN * MAX_CPU_COUNT) drain_queue;
>> +	____cacheline_aligned_in_smp
>> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) fanout_queues[MAX_CPU_COUNT];
>> +	____cacheline_aligned_in_smp
>> +
>> +	struct tasklet_struct aggr_tasklet;
>> +	struct hrtimer aggr_timer;
>> +};
>> +
>>
> 
>> +
>> +static struct ltb_class *ltb_alloc_class(struct Qdisc *sch,
>> +					 struct ltb_class *parent, u32 classid,
>> +					 struct psched_ratecfg *ratecfg,
>> +					 struct psched_ratecfg *ceilcfg,
>> +					 u32 prio)
>> +{
>> +	struct ltb_sched *ltb  = qdisc_priv(sch);
>> +	struct ltb_class *cl;
>> +	int i;
>> +
>> +	if (ratecfg->rate_bytes_ps > ceilcfg->rate_bytes_ps ||
>> +	    prio < 0 || prio >= TC_LTB_NUMPRIO)
>> +		return NULL;
>> +
>> +	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
> 
> This is going to fail, 2MB chunks of physically contiguous memory is unreasonable.
> 
> 2MB per class makes this qdisc very particular, especially with 1000 classes ?
> 
> In comparison, HTB class consumes less than 1 KB
> 

The main memory consumption comes from the kfifo queues. We use far more less classes than 1000 so we didn't really care that.

If supporting 1000 classes is a goal, we should be able to aggressively reduce the queue length. Currently it is set to 512 per-CPU which is a waste. Also we can dynamically allocate the kfifo queues according to CPU numbers.

Thanks,
- Xiangning
