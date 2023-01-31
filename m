Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76368395C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjAaWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaWcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:32:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8978D13D41;
        Tue, 31 Jan 2023 14:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32021B81F60;
        Tue, 31 Jan 2023 22:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A01C433D2;
        Tue, 31 Jan 2023 22:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675204331;
        bh=nISL5kjNCgP43LJXfM+XyseAAuvP6VCcytBCYGeG2nE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MEV6Kwx6I4qxD67+dkN9w7/zm8VVgIjAMwHLY43Pd9+n4rMcyUd3Goe2msaD0phOM
         d7GGAVNk2ug4EQA5wmZPP+HWM/f2oprjE3nh6EJo5vjpSogDE3JVV3cSud5GwvhS1L
         Ztk18TYRKbnTGIpY9G+qH8TG9f47LoGsv55B+3k4mNOAvUNxuUKIiPZh+loAlLEJ1m
         AWD9Pw9xDK7GiYi6o411W/emXvQp0FEziyxyQSvJO7/WQVtC5V/C9DaZXhrtAA+m5U
         NasJ+DJg6FJAtDB9u3/SNLQf3Y6LKJO1VFIdN8PW986eUGD0u+PP344+Lf9/XkCvyP
         rhrZhhH4V57fw==
Date:   Tue, 31 Jan 2023 14:32:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     peterz@infradead.org, tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to
 need_resched()
Message-ID: <20230131143210.288223c5@kernel.org>
In-Reply-To: <20221222221244.1290833-3-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
        <20221222221244.1290833-3-kuba@kernel.org>
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

On Thu, 22 Dec 2022 14:12:43 -0800 Jakub Kicinski wrote:
> need_resched() added in commit c10d73671ad3 ("softirq: reduce latencies")
> does improve latency for real workloads (for example memcache).
> Unfortunately it triggers quite often even for non-network-heavy apps
> (~900 times a second on a loaded webserver), and in small fraction of
> cases whatever the scheduler decided to run will hold onto the CPU
> for the entire time slice.
> 
> 10ms+ stalls on a machine which is not actually under overload cause
> erratic network behavior and spurious TCP retransmits. Typical end-to-end
> latency in a datacenter is < 200us so its common to set TCP timeout
> to 10ms or less.
> 
> The intent of the need_resched() is to let a low latency application
> respond quickly and yield (to ksoftirqd). Put a time limit on this dance.
> Ignore the fact that ksoftirqd is RUNNING if we were trying to be nice
> and the application did not yield quickly.
> 
> On a webserver loaded at 90% CPU this change reduces the numer of 8ms+
> stalls the network softirq processing sees by around 10x (2/sec -> 0.2/sec).
> It also seems to reduce retransmissions by ~10% but the data is quite
> noisy.

Peter, is there a chance you could fold this patch into your ongoing
softirq rework? We can't both work on softirq in parallel, unfortunately
and this improvement is really key to counter balance whatever
heuristics CFS accumulated between 5.12 and 5.19 :(
Not to use the "r-word".

I can spin a version of this on top of your core/softirq branch, would
that work?
