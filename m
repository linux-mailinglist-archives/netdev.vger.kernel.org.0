Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B445E5646
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiIUWdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIUWdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:33:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739839A6BB;
        Wed, 21 Sep 2022 15:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EA88B83335;
        Wed, 21 Sep 2022 22:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3FCC433D6;
        Wed, 21 Sep 2022 22:32:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Z9tHNzdK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663799573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCLdxIJDdgK5TMm1FGBh4DcV2twQXChhVg3rbR78gBI=;
        b=Z9tHNzdK3zxH3AP9r927EPZZleSQ4XQZaqI+CQPnqtNuOqunt8OteDYIBRJI+m8lh9xuuS
        J+gTe+n2pZLYBJbDdCQKrnQCDmG9VCSCFrEf2XqMAGmLaU3om2+zG9DNW5j1Gmuuguc2UO
        qKgbwt1wOTtvrG6xHaKIzEgJvWGZsV4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a6eb7b2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 21 Sep 2022 22:32:53 +0000 (UTC)
Date:   Thu, 22 Sep 2022 00:32:49 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sherry Yang <sherry.yang@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sebastian Siewior <bigeasy@linutronix.de>
Cc:     Sebastian Siewior <bigeasy@linutronix.de>,
        Jack Vogel <jack.vogel@oracle.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: 10% regression in qperf tcp latency after introducing commit
 "4a61bf7f9b18 random: defer fast pool mixing to worker"
Message-ID: <YyuREcGAXV9828w5@zx2c4.com>
References: <B1BC4DB8-8F40-4975-B8E7-9ED9BFF1D50E@oracle.com>
 <CAHmME9rUn0b5FKNFYkxyrn5cLiuW_nOxUZi3mRpPaBkUo9JWEQ@mail.gmail.com>
 <04044E39-B150-4147-A090-3D942AF643DF@oracle.com>
 <CAHmME9oKcqceoFpKkooCp5wriLLptpN=+WrrG0KcDWjBahM0bQ@mail.gmail.com>
 <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BD03BFF6-C369-4D34-A38B-49653F1CBC53@oracle.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sherry (and Sebastian and Netdev and Tejun and whomever),

I'm top-replying so that I can provide an overview of what's up to other
readers, and then I'll leave your email below for additional context.

random.c used to have a hard IRQ handler that did something like this:

    do_some_stuff()
    spin_lock()
    do_some_other_stuff()
    spin_lock()

That worked fine, but Sebastian pointed out that having spinlocks in a
hard IRQ handler was a big no-no for RT. Not wanting to make those into
raw spinlocks, he suggested we hoist things into a workqueue. So that's
what we did together, and now that function reads:

    do_some_stuff()
    queue_work_on(raw_smp_processor_id(), other_stuff_worker);

That seemed reasonable to me -- it's a pattern practiced a million times
all over the kernel -- and is currently how random.c's
add_interrupt_randomness() functions.

Sherry, however, has reported a ~10% performance regression using qperf
with TCP over some heavy duty infiniband cards. According to Sherry's
tests, removing the call to queue_work_on() makes the performance
regression go away.

That leads me to suspect that queue_work_on() might actually not be as
cheap as I assumed? If so, is that surprising to anybody else? And what
should we do about this?

Unfortunately, as you'll see from reading below, I'm hopeless in trying
to recreate Sherry's test rig, and even Sherry was unable to reproduce
it on different hardware. Nonetheless, a 10% regression on fancy 40gbps
hardware seems like something worthy of wider concern.

What are our options? Investigate queue_work_on() bottlenecks? Move back
to the original pattern, but use raw spinlocks? Some thing else?

Sherry -- are you able to do a bit of profiling to see which
instructions or which area of a function is the hottest or creating that
bottleneck? I think we probably need more information to do something
with this.

Also, because I still have no idea how I can reproduce this myself, you
might need to take the reigns with helping to develop and test a patch,
since I'm kind of stabbing in the dark here.

Anyway, because this might be rather involved, I figure it's best to
move this conversation on list in case other folks have insights.

Regards,
Jason

On Wed, Sep 21, 2022 at 06:09:27PM +0000, Sherry Yang wrote:
> > On Sep 20, 2022, at 7:44 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > 
> > Anyway, a few questions:
> > 1) Does the regression disappear if you change this line:
> > - queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
> > + schedule_work_on(raw_smp_processor_id(), &fast_pool->mix);
> 
> After applying this change, we still see performance regression there on linux-stable v5.15
> 
> > 
> > 2) Does the regression disappear if you remove this line:
> > - queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
> > + //queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
> 
> After applying this change, we see performance get recovered on linux-stable v5.15.
> 
> > 
> >> We could see performance regression there.
> > 
> > Can you give me some detailed instructions on how I can reproduce
> > this? Can it be reproduced inside of a single VM using network
> > namespaces, for example? Something like that would greatly help me
> > nail this down. For example, if you can give me a bash script that
> > does everything entirely on a single host?
> We are dong qperf tcp latency test there. All test results above are collected from X7 server with Mellanox Technologies 
> MT27500 Family [ConnectX-3] cards: 
> Infiniband device 'mlx4_0' port 1 status: 
> default gid: fe80:0000:0000:0000:0010:e000:0178:9eb1 
> base lid: 0x6 
> sm lid: 0x1 
> state: 4: ACTIVE 
> phys state: 5: LinkUp 
> rate: 40 Gb/sec (4X QDR) 
> link_layer: InfiniBand 
> 
> Cards are configured with IP addresses on private subnet for IPoIB 
> performance testing. 
> Regression identified in this bug is in TCP latency in this stack as reported 
> by qperf tcp_lat metric: 
> 
> We have one system listen as a qperf server:
> [root@yourQperfServer ~]# qperf
> 
> Have the other system connect to qperf server as a client (in this case, it’s X7 server with Mellanox card):
> [root@yourQperfClient ~]# numactl -m0 -N0 qperf 20.20.20.101 -v -uu -ub --time 60 --wait_server 20 -oo msg_size:4K:1024K:*2 tcp_lat
> 
> However, our test team ran other experiments yesterday.
> * Ran benchmark on X5-2 system over ixgbe interface 
> * Ran 8 processes of the benchmark on the original system over the Mellanox card 
> Both these experiments failed to reproduce the regression. This highlights that the regression is not seen over ethernet network devices 
> and is only seen when running a single instance of the qperf benchmark.
