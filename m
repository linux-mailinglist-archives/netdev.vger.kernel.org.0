Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7217A6BDF96
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCQD1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCQD1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B3362B56;
        Thu, 16 Mar 2023 20:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98EA62123;
        Fri, 17 Mar 2023 03:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B994C433D2;
        Fri, 17 Mar 2023 03:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679023610;
        bh=CxdQYn7r5li7ZhcwLAavPETe1WSXXkBuy5qiVH1WQJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NJ/OCd0Lj8mIYaxC0/bIixFMqfx0SSXsUzGjIybDj1V24ya39REb3CeILgjV/vGmv
         rsYGqR7O7gfMu6aJLKY3J0wB+AJuObY1zIUIb4TZORUNPgCKQasBGm1KPrREAn4U4p
         s0/YkXf4CRn1g9SpfB2kayWIspK5PpIMNL++2qGJyUx8HPE/4yaiYG/GyD3iKzX2iR
         8/IRmfCSwbp0jAedxCrlBuK/GOaaTaM20+0xYKj9a4lM0UtOFN+K/ziNgg6sq4+URE
         Sfv/2kwIcsqYtMvXrtZuMXU4k5qM3qeIARLv+sU50vSk9hrRqDxGXzQ1uH6fYECvd4
         MW46mjhpcAlPg==
Date:   Thu, 16 Mar 2023 20:26:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230316202648.1f8c2f80@kernel.org>
In-Reply-To: <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
        <20230316172020.5af40fe8@kernel.org>
        <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 10:27:11 +0800 Jason Xing wrote:
> > That is the common case, and can be understood from the napi trace  
> 
> Thanks for your reply. It is commonly happening every day on many servers.

Right but the common issue is the time squeeze, not budget squeeze,
and either way the budget squeeze doesn't really matter because 
the softirq loop will call us again soon, if softirq itself is 
not scheduled out.

So if you want to monitor a meaningful event in your fleet, I think 
a better event to monitor is the number of times ksoftirqd was woken 
up and latency of it getting onto the CPU.

Did you try to measure that?

(Please do *not* send patches to touch softirq code right now, just
measure first. We are trying to improve the situation but the core
kernel maintainers are weary of changes:
https://lwn.net/Articles/925540/
so if both of us start sending code they will probably take neither
patches :()

> > point and probing the kernel with bpftrace. We should only add  
> 
> We probably can deduce (or guess) which one causes the latency because
> trace_napi_poll() only counts the budget consumed per poll.
> 
> Besides, tracing napi poll is totally ok with the testbed but not ok
> with those servers with heavy load which bpftrace related tools
> capturing the data from the hot path may cause some bad impact,
> especially with special cards equipped, say, 100G nic card. Resorting
> to legacy file softnet_stat is relatively feasible based on my limited
> knowledge.

Right, but we're still measuring something relatively irrelevant.
As I said the softirq loop will call us again. In my experience
network queues get long when ksoftirqd is woken up but not scheduled
for a long time. That is the source of latency. You may have the same
problem (high latency) without consuming the entire budget.

I think if we wanna make new stats we should try to come up with a way
of capturing the problem rather than one of the symptoms.

> Paolo also added backlog queues into this file in 2020 (see commit:
> 7d58e6555870d). I believe that after this patch, there are few or no
> more new data that is needed to print for the next few years.
> 
> > uAPI for statistics which must be maintained contiguously. For  
> 
> In this patch, I didn't touch the old data as suggested in the
> previous emails and only separated the old way of counting
> @time_squeeze into two parts (time_squeeze and budget_squeeze). Using
> budget_squeeze can help us profile the server and tune it more
> usefully.
> 
> > investigations tracing will always be orders of magnitude more
> > powerful :(  
> 
> > On the time squeeze BTW, have you found out what the problem was?
> > In workloads I've seen the time problems are often because of noise
> > in how jiffies are accounted (cgroup code disables interrupts
> > for long periods of time, for example, making jiffies increment
> > by 2, 3 or 4 rather than by 1).  
> 
> Yes ! The issue of jiffies increment troubles those servers more often
> than not. For a small group of servers, budget limit is also a
> problem. Sometimes we might treat guest OS differently.
