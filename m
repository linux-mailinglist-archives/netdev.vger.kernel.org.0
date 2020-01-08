Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2F133FAE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgAHKv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:51:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35100 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgAHKv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UqJ+/pT3izXu8kjYbbiezAa/YocSHtlN1XVLHEFRKJs=; b=h1hY+k92RryrIdTBhr5FexAw8
        O11fOafKK2pe28cad9xN3w5YC34MHOc8hOWB8aSF5ZjC4dagLW4Ma/0kLVb7woD8LikhFaOmCggkJ
        tGj6ZF/m8LSvTqTKZyMP0PiFTtEWolCan0If+IvY/U+RhWEd59XTazjWez3mvFGUqz2I2uaQnIthm
        xWGbmTwjpUTQg2ojRszkMLE7I3h5arSfW5f/vsqoPHTlTF8hBF73JlvH3LaJ8cmVuHmk/ZkvZDPlJ
        6rlLIighU6yX4hf5dztz9In1qHEMM4u/Z2M90C6vdcHgH9EOOe687bUXiPyWnDC+dNrkWrcOJJgAm
        fc6jza4hg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ip8uo-00019z-P9; Wed, 08 Jan 2020 10:50:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DE995300693;
        Wed,  8 Jan 2020 11:48:38 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AF2B320B79C98; Wed,  8 Jan 2020 11:50:11 +0100 (CET)
Date:   Wed, 8 Jan 2020 11:50:11 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        dwmw@amazon.co.uk, fllinden@amaozn.com
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200108105011.GY2827@hirez.programming.kicks-ass.net>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 11:45:26PM +0000, Anchal Agarwal wrote:
> From: Eduardo Valentin <eduval@amazon.com>
> 
> System instability are seen during resume from hibernation when system
> is under heavy CPU load. This is due to the lack of update of sched
> clock data, and the scheduler would then think that heavy CPU hog
> tasks need more time in CPU, causing the system to freeze
> during the unfreezing of tasks. For example, threaded irqs,
> and kernel processes servicing network interface may be delayed
> for several tens of seconds, causing the system to be unreachable.

> The fix for this situation is to mark the sched clock as unstable
> as early as possible in the resume path, leaving it unstable
> for the duration of the resume process. This will force the
> scheduler to attempt to align the sched clock across CPUs using
> the delta with time of day, updating sched clock data. In a post
> hibernation event, we can then mark the sched clock as stable
> again, avoiding unnecessary syncs with time of day on systems
> in which TSC is reliable.

This makes no frigging sense what so bloody ever. If the clock is
stable, we don't care about sched_clock_data. When it is stable you get
a linear function of the TSC without complicated bits on.

When it is unstable, only then do we care about the sched_clock_data.

> Reviewed-by: Erik Quanstrom <quanstro@amazon.com>
> Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> Reviewed-by: Balbir Singh <sblbir@amazon.com>
> Reviewed-by: Munehisa Kamata <kamatam@amazon.com>
> Tested-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Eduardo Valentin <eduval@amazon.com>
> ---

NAK, the code very much relies on never getting marked stable again
after it gets set to unstable.

> diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
> index 1152259a4ca0..374d40e5b1a2 100644
> --- a/kernel/sched/clock.c
> +++ b/kernel/sched/clock.c
> @@ -116,7 +116,7 @@ static void __scd_stamp(struct sched_clock_data *scd)
>  	scd->tick_raw = sched_clock();
>  }
>  
> -static void __set_sched_clock_stable(void)
> +void set_sched_clock_stable(void)
>  {
>  	struct sched_clock_data *scd;
>  
> @@ -236,7 +236,7 @@ static int __init sched_clock_init_late(void)
>  	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
>  
>  	if (__sched_clock_stable_early)
> -		__set_sched_clock_stable();
> +		set_sched_clock_stable();
>  
>  	return 0;
>  }
> -- 
> 2.15.3.AMZN
> 
