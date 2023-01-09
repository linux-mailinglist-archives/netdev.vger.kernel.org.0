Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45B66300C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbjAITN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbjAITNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:13:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4991838B8;
        Mon,  9 Jan 2023 11:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6E98B80E00;
        Mon,  9 Jan 2023 19:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416A1C433EF;
        Mon,  9 Jan 2023 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673291562;
        bh=wTIj3y5/T8S2ncQd4XUCVx1Z1E5mTxiUfX6LIHH3wGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W1yu7yBWp9tihRsSUgU5MySlpp9oOCoYEbYN6WheuNO8mi0y/CCC5HHACp3L4c7FF
         8odzoADtE2xhhfCbqif5Pc/6TD7Kd9z71ZqM/CDkOQoN15dQ14I+AaR5WG+aX8OS7R
         rg7ILZkDEZzjsb8OyORz0+exxtn5oHd9Bn2o4d7P0q1d6lKYUDZ8+q9HYS3zRVAGJm
         rd4hGEFAllrvZHc8tXS4/3a8PmsKGokEDIeH7g/wQYMnwadRYZcFr+5G8VLjpA13CA
         nUVzgQTyA1vXzhcPBZ+CVBQFOp8l2Gau6vocdHojrnPhRe6+AlJ6qiiQQIfz+jL66j
         Rrl06mQgc3K1A==
Date:   Mon, 9 Jan 2023 11:12:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, jstultz@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] softirq: don't yield if only expedited handlers are
 pending
Message-ID: <20230109111241.6ed3a64a@kernel.org>
In-Reply-To: <CANn89iK2NTz_M-OtcN5iATUacMaseNLi42QipuxDF3MMQCEVHg@mail.gmail.com>
References: <20221222221244.1290833-1-kuba@kernel.org>
        <20221222221244.1290833-4-kuba@kernel.org>
        <Y7viEa4BC3yJRXIS@hirez.programming.kicks-ass.net>
        <CANn89iK2NTz_M-OtcN5iATUacMaseNLi42QipuxDF3MMQCEVHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Jan 2023 11:16:45 +0100 Eric Dumazet wrote:
> > On Thu, Dec 22, 2022 at 02:12:44PM -0800, Jakub Kicinski wrote:  
> > > In networking we try to keep Tx packet queues small, so we limit
> > > how many bytes a socket may packetize and queue up. Tx completions
> > > (from NAPI) notify the sockets when packets have left the system
> > > (NIC Tx completion) and the socket schedules a tasklet to queue
> > > the next batch of frames.
> > >
> > > This leads to a situation where we go thru the softirq loop twice.
> > > First round we have pending = NET (from the NIC IRQ/NAPI), and
> > > the second iteration has pending = TASKLET (the socket tasklet).  
> >
> > So to me that sounds like you want to fix the network code to not do
> > this then. Why can't the NAPI thing directly queue the next batch; why
> > do you have to do a softirq roundtrip like this?  
> 
> I think Jakub refers to tcp_wfree() code, which can be called from
> arbitrary contexts,
> including non NAPI ones, and with the socket locked (by this thread or
> another) or not locked at all
> (say if skb is freed from a TX completion handler or a qdisc drop)

Yes, fwiw.

> > > On two web workloads I looked at this condition accounts for 10%
> > > and 23% of all ksoftirqd wake ups respectively. We run NAPI
> > > which wakes some process up, we hit need_resched() and wake up
> > > ksoftirqd just to run the TSQ (TCP small queues) tasklet.
> > >
> > > Tweak the need_resched() condition to be ignored if all pending
> > > softIRQs are "non-deferred". The tasklet would run relatively
> > > soon, anyway, but once ksoftirqd is woken we're risking stalls.
> > >
> > > I did not see any negative impact on the latency in an RR test
> > > on a loaded machine with this change applied.  
> >
> > Ignoring need_resched() will get you in trouble with RT people real
> > fast.  

Ah, you're right :/ Is it good enough if we throw || force_irqthreads()
into the condition?

Otherwise we can just postpone this optimization, the overload 
time horizon / limit patch is much more important.
