Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA25386D11
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343991AbhEQWnp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 May 2021 18:43:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:2067 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhEQWno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:43:44 -0400
IronPort-SDR: fglZEgIESuhQe3S8iGVwADMJe8FDNfpKJtut4po3mvP4PJoTcYBOKpuEFV9qaWzCxxY9A2eU6q
 PRUDy3fC156g==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="187703395"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="187703395"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 15:42:26 -0700
IronPort-SDR: PYgUB98/plcyAXG5v62/zTWK/BW5GW4K2Sz1UIj6VYd8MM53EjNDt0IX6lz+Tb2QVBqB9DKX00
 ItdjWLJbdG5A==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="438381614"
Received: from mchicks-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.132.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 15:42:25 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev
 queue mapping
In-Reply-To: <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
 <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
 <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
Date:   Mon, 17 May 2021 15:42:23 -0700
Message-ID: <87zgwtyoc0.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yannick Vignon <yannick.vignon@oss.nxp.com> writes:

> On 5/15/2021 1:47 AM, Vinicius Costa Gomes wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>>> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>> You haven't CCed anyone who worked on this Qdisc in the last 2 years :/
>>>>> CCing them now. Comments, anyone?
>>>>
>>>> I guess I should suggest myself as maintainer, to reduce chances of this
>>>> happening again.
>>>
>>> Yes, please.
>>>
>>>>> This looks like a very drastic change. Are you expecting the qdisc will
>>>>> always be bypassed?
>>>>
>>>> Only when running in full offload mode it will be bypassed.
>>>>
>>>> And it's kind of by design, in offload mode, the idea was: configure the
>>>> netdev traffic class to queue mapping, send the schedule to the hardware
>>>> and stay out of the way.
>>>>
>>>> But as per Yannick's report, it seems that taprio doesn't stay enough
>>>> out of the yay.
>>>>
>>>>> After a 1 minute looks it seems like taprio is using device queues in
>>>>> strict priority fashion. Maybe a different model is needed, but a qdisc
>>>>> with:
>>>>>
>>>>> enqueue()
>>>>> {
>>>>> 	WARN_ONCE(1)
>>>>> }
>>>>>
>>>>> really doesn't look right to me.
>>>>
>
> My idea was to follow the logic of the other qdiscs dealing with 
> hardware multiqueue, namely mq and mqprio. Those do not have any 
> enqueue/dequeue callbacks, but instead define an attach callback to map 
> the child qdiscs to the HW queues. However, for taprio all those 
> callbacks are already defined by the time we choose between software and 
> full-offload, so the WARN_ONCE was more out of extra caution in case I 
> missed something. If my understanding is correct however, it would 
> probably make sense to put a BUG() instead, since those code paths 
> should never trigger with this patch.
>
> OTOH what did bother me a bit is that because I needed an attach 
> callback for the full-offload case, I ended up duplicating some code 
> from qdisc_graft in the attach callback, so that the software case would 
> continue behaving as is.
>
> Those complexities could be removed by pulling out the full-offload case 
> into its own qdisc, but as I said it has other drawbacks.
>
>>>> This patch takes the "stay out of the way" to the extreme, I kind of
>>>> like it/I am not opposed to it, if I had this idea a couple of years
>>>> ago, perhaps I would have used this same approach.
>>>
>>> Sorry for my ignorance, but for TXTIME is the hardware capable of
>>> reordering or the user is supposed to know how to send packets?
>> 
>> At least the hardware that I am familiar with doesn't reorder packets.
>> 
>> For TXTIME, we have ETF (the qdisc) that re-order packets. The way
>> things work when taprio and ETF are used together is something like
>> this: taprio only has enough knowledge about TXTIME to drop packets that
>> would be transmitted outside their "transmission window" (e.g. for
>> traffic class 0 the transmission window is only for 10 to 50, the TXTIME
>> for a packet is 60, this packet is "invalid" and is dropped). And then
>> when the packet is enqueued to the "child" ETF, it's re-ordered and then
>> sent to the driver.
>> 
>> And this is something that this patch breaks, the ability of dropping
>> those invalid packets (I really wouldn't like to do this verification
>> inside our drivers). Thanks for noticing this.
>> 
>
> Hmm, indeed, I missed that check (we don't use ETF currently). I'm not 
> sure of the best way forward, but here are a few thoughts:
> . The problem only arises for full-offload taprio, not for the software 
> or TxTime-assisted cases.
> . I'm not sure mixing taprio(full-offload) with etf(no-offload) is very 
> useful, at least with small gate intervals: it's likely you will miss 
> your window when trying to send a packet at exactly the right time in 
> software (I am usually testing taprio with a 2ms period and a 4µs 
> interval for the RT stream).
> . That leaves the case of taprio(full-offload) with etf(offload). Right 
> now with the current stmmac driver config, a packet whose tstamp is 
> outside its gate interval will be sent on the next interval (and block 
> the queue).

This is the case that is a bit problematic with our hardware. (full taprio
offload + ETF offload).

> . The stmmac hardware supports an expiryTime, currently unsupported in 
> the stmmac driver, which I think could be used to drop packets whose 
> tstamps are wrong (the packet would be dropped once the tstamp 
> "expires"). We'd need to add an API for configuration though, and it 
> should be noted that the stmmac config for this is global to the MAC, 
> not per-queue (so a config through sch-etf would affect all queues).
> . In general using taprio(full-offload) with etf(offload) will incur a 
> small latency penalty: you need to post the packet before the ETF qdisc 
> wakes up (plus some margin), and the ETF qdisc must wake up before the 
> tx stamp (plus some margin). If possible (number of streams/apps < 
> number of hw queues), it would be better to just use 
> taprio(full-offload) alone, since the app will need to post the packet 
> before the gate opens (so plus one margin, not 2).

It really depends on the workload, and how the schedule is organized,
but yeah, that might be possible (for some cases :-)).

>
>
>>>
>>> My biggest problem with this patch is that unless the application is
>>> very careful that WARN_ON_ONCE(1) will trigger. E.g. if softirq is
>>> servicing the queue when the application sends - the qdisc will not
>>> be bypassed, right?
>
> See above, unless I'm mistaken the "root" qdisc is never 
> enqueued/dequeued for multi-queue aware qdiscs.
>

That's true, mq and mqprio don't have enqueue()/dequeue(), but I think
that's more a detail of their implementation than a rule (that no
multiqueue-aware root qdisc should implement enqueue()/dequeue()).

That is, from my point of view, there's nothing wrong in having a root
qdisc that's also a shaper/scheduler.

>>>> I am now thinking if this idea locks us out of anything.
>>>>
>>>> Anyway, a nicer alternative would exist if we had a way to tell the core
>>>> "this qdisc should be bypassed" (i.e. don't call enqueue()/dequeue())
>>>> after init() runs.
>>>
>
> Again, I don't think enqueue/dequeue are called unless the HW queues 
> point to the root qdisc. But this does raise an interesting point: the 
> "scheduling" issue I observed was on the dequeue side, when all the 
> queues were dequeued within the RT process context. If we could point 
> the enqueue side to the taprio qdisc and the dequeue side to the child 
> qdiscs, that would probably work (but I fear that would be a significant 
> change in the way the qdisc code works).

I am wondering if there's a simpler solution, right now (as you pointed
out) taprio traverses all queues during dequeue(), that's the problem.

What I am thinking is if doing something like:

     sch->dev_queue - netdev_get_tx_queue(dev, 0);

To get the queue "index" and then only dequeuing packets for that queue,
would solve the issue. (A bit ugly, I know).

I just wanted to write the idea down to see if any one else could find
any big issues with it. I will try to play with it a bit, if no-one
beats me to it.

>
>>> I don't think calling enqueue() and dequeue() is a problem. The problem
>>> is that RT process does unrelated work.
>> 
>> That is true. But this seems like a much bigger (or at least more
>> "core") issue.
>> 
>> 
>> Cheers,
>> 
>


Cheers,
-- 
Vinicius
