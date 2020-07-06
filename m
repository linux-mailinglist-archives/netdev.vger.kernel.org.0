Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F506216149
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGFWIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:08:50 -0400
Received: from out0-151.mail.aliyun.com ([140.205.0.151]:44321 "EHLO
        out0-151.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgGFWIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 18:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594073327; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=ATazYhvYzv3jhOFKnt5LCr1B5qIhZAGnMloK2P5ODhs=;
        b=Zp/HxvwcNH/23aSsOa1TcweD9xBgMpZajqlO/wGrNWAawet0KJb37C0LXNcd1RZaa75VjN9z5meQl02s7itC6QC1OnSpZ9Rv6jQ26ek0wW85CSXTGlpiB+4OMQkNDtsns84r1EsSUVXWyYPLqr5Lp5vkPRrB1HQcVPGFUzgIsd4=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01l07447;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.Hz2M.-8_1594073325;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.Hz2M.-8_1594073325)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Jul 2020 06:08:46 +0800
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <20200706.132947.1139798465163322137.davem@davemloft.net>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <26fa9e62-22c7-649e-f7f8-a5b7e678fd99@alibaba-inc.com>
Date:   Tue, 07 Jul 2020 06:08:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200706.132947.1139798465163322137.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/20 1:29 PM, David Miller wrote:
> From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
> Date: Tue, 07 Jul 2020 02:08:13 +0800
> 
>> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
>> use of outbound bandwidth on a shared link. With the help of lockless
>> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
>> designed to scale in the cloud data centers.
>>
>> Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
> 
> I'm very skeptical about having a kthread for each qdisc, that doesn't
> sound like a good idea at all.
> 
> Also:
> 

Hi David,

I can change the kthread to a timer, like what sfq does for perturbation. Hope that would be OK. 

Will take care of the other comments too.

Thanks,
- Xiangning

>> +static inline struct ltb_skb_cb *ltb_skb_cb(const struct sk_buff *skb)
> 
> No inline functions in foo.c files please.
> 
>> +static inline s64 get_linkspeed(struct net_device *dev)
> 
> Likewise.
> 
>> +static inline int ltb_drain(struct ltb_class *cl)
>> +{
>> +	typeof(&cl->drain_queue) queue;
> 
> Use the actual type not typeof().
> 
>> +	struct sk_buff *skb;
>> +	int npkts, bytes;
>> +	unsigned long now = NOW();
>> +	int cpu;
>> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
>> +	struct ltb_pcpu_sched *pcpu_q;
>> +	s64 timestamp;
>> +	bool need_watchdog = false;
>> +	struct cpumask cpumask;
> 
> Please order local variables in reverse christmas tree order.
> 
>> +static void ltb_aggregate(struct ltb_class *cl)
>> +{
>> +	s64 timestamp = ktime_get_ns();
>> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
>> +	int num_cpus = ltb->num_cpus;
>> +	int i;
> 
> Likewise.
> 
>> +static inline void ltb_fanout(struct ltb_sched *ltb)
>> +{
> 
> No inline please.
> 
>> +/* How many classes within the same group want more bandwidth */
>> +static inline int bw_class_want_more_count(struct list_head *head)
>> +{
>> +	int n = 0;
>> +	struct ltb_class *cl;
> 
> No inline, and reverse christmas tree ordering for local variables.
> 
>> +/* Redistribute bandwidth among classes with the same priority */
>> +static int bw_redistribute_prio(struct list_head *lhead, int bw_available,
>> +				int n, bool *all_reached_ceil)
>> +{
>> +	struct ltb_class *cl;
>> +	int avg = 0;
>> +	int orig_bw_allocated;
>> +	int safe_loop = 0;
>> +
> 
> Likewise.
> 
>> +static int bw_redistribute(struct ltb_sched *ltb, int bw_available)
>> +{
>> +	int prio = 0;
>> +	int n;
>> +	int highest_non_saturated_prio = TC_LTB_NUMPRIO;
>> +	bool all_reached_ceil;
> 
> Likewise.
> 
>> +static void bw_balance(struct ltb_sched *ltb)
>> +{
>> +	struct ltb_class *cl;
>> +	s64 link_speed = ltb->link_speed;
>> +	int bw_available = link_speed;
>> +	s64 total = 0;
>> +	int high = TC_LTB_NUMPRIO;
>> +	int is_light_traffic = 1;
>> +	int i;
> 
> Likewise.
> 
> And so on and so forth.  This code needs a lot of style fixes
> and removal of the per-qdisc kthread design.
> 
> Thank you.
> 
