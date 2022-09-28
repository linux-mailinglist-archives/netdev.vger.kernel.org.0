Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA35EDBB0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiI1LYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiI1LXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:23:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E951ADE0F8;
        Wed, 28 Sep 2022 04:23:50 -0700 (PDT)
Date:   Wed, 28 Sep 2022 13:23:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664364228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=REudWInBpEtfjdkNeuRtJ+UL8500dLn0lBWb1EI1Pw4=;
        b=mFo6u/Yx0bn9as+0Q1OBsmZeWPueNxnO6whIjZrCrT6YH+T2Fg7MRsbAMAZ/1ssmTJsMlD
        EFngt21T8HRdRjXIZbFQAZeQslwA2dl3VbHbRrattfDJNKD4D19Ra//1ZCyxkj9FiX8WES
        42iH5smuaDGLczJwlIB8KELzBCjWdJ6+j8OZSMdr9K0+AwhB/k3Z4hBmAUy0DFP8/NwrE2
        OIczwisN/LkJng8dhbbClr+UV6He3ui8HxdpZFCKlcK9R8QzCDxMc1X5O7p0MrjO5AZti/
        s2cSX/Zcq4ikfm1EJrq5EKTrvooxyk1AW9bfmEYAhDH6bBa4Xa4IvAec2H4Xiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664364228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=REudWInBpEtfjdkNeuRtJ+UL8500dLn0lBWb1EI1Pw4=;
        b=gCcJCtmxh83q9cXaviSprTL2ldRLO6s5J8QYZX0D3KjHNdPfWjIYSKGFthNqwALGMQP6Oo
        huuEdZ7dh6bCIFDQ==
From:   Sebastian Siewior <bigeasy@linutronix.de>
To:     Tejun Heo <tj@kernel.org>, Sherry Yang <sherry.yang@oracle.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: 10% regression in qperf tcp latency after introducing commit
 "4a61bf7f9b18 random: defer fast pool mixing to worker"
Message-ID: <YzQuwlc3CIlGWa4u@linutronix.de>
References: <B1BC4DB8-8F40-4975-B8E7-9ED9BFF1D50E@oracle.com>
 <CAHmME9rUn0b5FKNFYkxyrn5cLiuW_nOxUZi3mRpPaBkUo9JWEQ@mail.gmail.com>
 <04044E39-B150-4147-A090-3D942AF643DF@oracle.com>
 <CAHmME9oKcqceoFpKkooCp5wriLLptpN=+WrrG0KcDWjBahM0bQ@mail.gmail.com>
 <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
 <YyuREcGAXV9828w5@zx2c4.com>
 <YyukQ/oU/jkp0OXA@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YyukQ/oU/jkp0OXA@slm.duckdns.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-21 13:54:43 [-1000], Tejun Heo wrote:
> Hello,
Hi,

> On Thu, Sep 22, 2022 at 12:32:49AM +0200, Jason A. Donenfeld wrote:
> > What are our options? Investigate queue_work_on() bottlenecks? Move back
> > to the original pattern, but use raw spinlocks? Some thing else?
> 
> I doubt it's queue_work_on() itself if it's called at very high frequency as
> the duplicate calls would just fail to claim the PENDING bit and return but
> if it's being called at a high frequency, it'd be waking up a kthread over
> and over again, which can get pretty expensive. Maybe that ends competing
> with softirqd which is handling net rx or sth?

There is this (simplified):
|         if (new_count & MIX_INFLIGHT)
|                 return;
| 
|         if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
|                 return;
| 
|         fast_pool->count |= MIX_INFLIGHT;
|         queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);

at least 1k interrupts are needed and a second must pass before a worker
will be scheduled. Oh wait. We need only one of both. So how many
interrupts do we get per second?
Is the regression coming from more than 1k interrupts in less then a
second or a context switch each second? Because if it is a context
switch every second then I am surprised to see a 10% performance drop in
this case since should happen for other reasons, too unless the CPU is
isolated.

[ There isn't a massive claims of the PENDING bit or wakeups because
fast_pool is per-CPU and due to the MIX_INFLIGHT bit. ]

> So, yeah, I'd try something which doesn't always involve scheduling and a
> context switch whether that's softirq, tasklet, or irq work. I probably am
> mistaken but I thought RT kernel pushes irq handling to threads so that
> these things can be handled sanely. Is this some special case?

As Jason explained this part is invoked in the non-threaded part.

> Thanks.

Sebastian
