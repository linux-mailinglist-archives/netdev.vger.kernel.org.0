Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ABC383B61
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhEQRf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbhEQRfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:35:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8685DC061760
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 10:34:22 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 33C6D22205;
        Mon, 17 May 2021 19:34:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1621272860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VCX9LfxFzceVJMVQg6xQDwi351T8kdgVTdzoA8+N6A=;
        b=laWsyLEP48tBINVvTCcmSvlnIjp5l8VRXKMpyiz3ZmUBHlgIXrVXMz3OAhp5jN+LfD2j9H
        ohGspeXVq+kUzIMDWB2hpPxmSgB2WSqKY/887Xd7/X3NRNX3iw+UIvm67C0HXLAQpFdDyd
        Al3Ymff//bFp8Hwri7IwVAXmdfDl/7Q=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 17 May 2021 19:34:18 +0200
From:   Michael Walle <michael@walle.cc>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: Re: [PATCH net v1] net: taprio offload: enforce qdisc to netdev queue
 mapping
In-Reply-To: <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
References: <20210511171829.17181-1-yannick.vignon@oss.nxp.com>
 <20210514083226.6d3912c4@kicinski-fedora-PC1C0HJN>
 <87y2ch121x.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210514140154.475e7f3b@kicinski-fedora-PC1C0HJN>
 <87sg2o2809.fsf@vcostago-mobl2.amr.corp.intel.com>
 <4359e11a-5f72-cc01-0c2f-13ca1583f6ef@oss.nxp.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <94d68f6301c085fbdd1940cd0f6f7def@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-05-17 19:06, schrieb Yannick Vignon:
> On 5/15/2021 1:47 AM, Vinicius Costa Gomes wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>>> On Fri, 14 May 2021 13:40:58 -0700 Vinicius Costa Gomes wrote:
>>>> Jakub Kicinski <kuba@kernel.org> writes:
>>>>> You haven't CCed anyone who worked on this Qdisc in the last 2 
>>>>> years :/
>>>>> CCing them now. Comments, anyone?
>>>> 
>>>> I guess I should suggest myself as maintainer, to reduce chances of 
>>>> this
>>>> happening again.
>>> 
>>> Yes, please.
>>> 
>>>>> This looks like a very drastic change. Are you expecting the qdisc 
>>>>> will
>>>>> always be bypassed?
>>>> 
>>>> Only when running in full offload mode it will be bypassed.
>>>> 
>>>> And it's kind of by design, in offload mode, the idea was: configure 
>>>> the
>>>> netdev traffic class to queue mapping, send the schedule to the 
>>>> hardware
>>>> and stay out of the way.
>>>> 
>>>> But as per Yannick's report, it seems that taprio doesn't stay 
>>>> enough
>>>> out of the yay.
>>>> 
>>>>> After a 1 minute looks it seems like taprio is using device queues 
>>>>> in
>>>>> strict priority fashion. Maybe a different model is needed, but a 
>>>>> qdisc
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
> enqueue/dequeue callbacks, but instead define an attach callback to
> map the child qdiscs to the HW queues. However, for taprio all those
> callbacks are already defined by the time we choose between software
> and full-offload, so the WARN_ONCE was more out of extra caution in
> case I missed something. If my understanding is correct however, it
> would probably make sense to put a BUG() instead, since those code
> paths should never trigger with this patch.
> 
> OTOH what did bother me a bit is that because I needed an attach
> callback for the full-offload case, I ended up duplicating some code
> from qdisc_graft in the attach callback, so that the software case
> would continue behaving as is.
> 
> Those complexities could be removed by pulling out the full-offload
> case into its own qdisc, but as I said it has other drawbacks.
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
>> this: taprio only has enough knowledge about TXTIME to drop packets 
>> that
>> would be transmitted outside their "transmission window" (e.g. for
>> traffic class 0 the transmission window is only for 10 to 50, the 
>> TXTIME
>> for a packet is 60, this packet is "invalid" and is dropped). And then
>> when the packet is enqueued to the "child" ETF, it's re-ordered and 
>> then
>> sent to the driver.
>> 
>> And this is something that this patch breaks, the ability of dropping
>> those invalid packets (I really wouldn't like to do this verification
>> inside our drivers). Thanks for noticing this.

Is this really how the taprio should behave? I mean, should the frame
really be dropped by taprio if TXTIME is outside of the window? Why
would taprio bother with TXTIME at all?

> Hmm, indeed, I missed that check (we don't use ETF currently). I'm not
> sure of the best way forward, but here are a few thoughts:
> . The problem only arises for full-offload taprio, not for the
> software or TxTime-assisted cases.
> . I'm not sure mixing taprio(full-offload) with etf(no-offload) is
> very useful, at least with small gate intervals: it's likely you will
> miss your window when trying to send a packet at exactly the right
> time in software (I am usually testing taprio with a 2ms period and a
> 4µs interval for the RT stream).
> . That leaves the case of taprio(full-offload) with etf(offload).
> Right now with the current stmmac driver config, a packet whose tstamp
> is outside its gate interval will be sent on the next interval (and
> block the queue).

If both are offloaded, are the h/w queues reordered if there is a
new frame with an earlier TXTIME? Or will the queue be blocked by a
frame with a later transmission time?

TBH I've never understood why the ETF qdisc will drop frames with
TXTIME in the past. I mean it makes sense with hardware offloading. But
without it, how can you make sure the kernel will wake up the queue
at just the right time to be able to send it. You can juggle the delta
parameter but on you don't want to send to too early, but on the other
hand the frame will likely be dropped if delta is too small. What am
I misssing here?

> . The stmmac hardware supports an expiryTime, currently unsupported in
> the stmmac driver, which I think could be used to drop packets whose
> tstamps are wrong (the packet would be dropped once the tstamp
> "expires"). We'd need to add an API for configuration though, and it
> should be noted that the stmmac config for this is global to the MAC,
> not per-queue (so a config through sch-etf would affect all queues).
> . In general using taprio(full-offload) with etf(offload) will incur a
> small latency penalty: you need to post the packet before the ETF
> qdisc wakes up (plus some margin), and the ETF qdisc must wake up
> before the tx stamp (plus some margin). If possible (number of
> streams/apps < number of hw queues), it would be better to just use
> taprio(full-offload) alone, since the app will need to post the packet
> before the gate opens (so plus one margin, not 2).
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
>>>> I am now thinking if this idea locks us out of anything.
>>>> 
>>>> Anyway, a nicer alternative would exist if we had a way to tell the 
>>>> core
>>>> "this qdisc should be bypassed" (i.e. don't call 
>>>> enqueue()/dequeue())
>>>> after init() runs.
>>> 
> 
> Again, I don't think enqueue/dequeue are called unless the HW queues
> point to the root qdisc. But this does raise an interesting point: the
> "scheduling" issue I observed was on the dequeue side, when all the
> queues were dequeued within the RT process context. If we could point
> the enqueue side to the taprio qdisc and the dequeue side to the child
> qdiscs, that would probably work (but I fear that would be a
> significant change in the way the qdisc code works).
> 
>>> I don't think calling enqueue() and dequeue() is a problem. The 
>>> problem
>>> is that RT process does unrelated work.
>> 
>> That is true. But this seems like a much bigger (or at least more
>> "core") issue.
>> 
>> 
>> Cheers,
>> 

-- 
-michael
