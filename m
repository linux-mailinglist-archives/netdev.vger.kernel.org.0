Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC967EB9D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjA0Qxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjA0Qxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:53:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1589C761C6;
        Fri, 27 Jan 2023 08:53:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81771CE0A36;
        Fri, 27 Jan 2023 16:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A53C433D2;
        Fri, 27 Jan 2023 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674838358;
        bh=4PEOSgaSNZcRyv2+4Vf4N0LKGu/uE0t/eNTGrTjQCE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tDh7dRFiEDjTkn4QUY9DLfEhv4hvKDWOhuQFr/co53t+6RPG8/mbbd5IK3vfgBt4u
         M15ZbDdGsTTvA/8kqxutPALB+tbijKfZqnH4ZLBndUu/BFDLGqFuw28pcR52cr1hyG
         MbjAq0l6vdbGGWV2GbQzFQRwGqw6NXabRaExO2g01wSKMkkrL4muK4RfzJI6rCAjG3
         3Z8kQ4YNkKGSOx6j7VjdfP682dkniDgwBbYkhjFA1OhOGJ0qRssXq8m4B0h/uFgKa9
         EPR2bCInKU59FsqGVXDYnl3T98HdVXsie8++FxlNWSZvS1Z0QiHmX5CMik5q8CPozA
         5Q07DNmxQ4H8Q==
Date:   Fri, 27 Jan 2023 08:52:36 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230127165236.rjcp6jm6csdta6z3@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:37:02AM +0100, Peter Zijlstra wrote:
> On Thu, Jan 26, 2023 at 08:43:55PM -0800, Josh Poimboeuf wrote:
> > Here's another idea, have we considered this?  Have livepatch set
> > TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
> > have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
> > set.
> > 
> > Not sure how scheduler folks would feel about that ;-)

Hmmmm, with preemption I guess the above doesn't work for kthreads
calling cond_resched() instead of what vhost_worker() does (explicit
need_resched/schedule).

> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f1b25ec581e0..06746095a724 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/stacktrace.h>
> +#include <linux/stop_machine.h>
>  #include "core.h"
>  #include "patch.h"
>  #include "transition.h"
> @@ -334,6 +335,16 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	return !ret;
>  }
>  
> +static int __stop_try_switch(void *arg)
> +{
> +	return klp_try_switch_task(arg) ? 0 : -EBUSY;
> +}
> +
> +static bool klp_try_switch_task_harder(struct task_struct *task)
> +{
> +	return !stop_one_cpu(task_cpu(task), __stop_try_switch, task);
> +}
> +
>  /*
>   * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
>   * Kthreads with TIF_PATCH_PENDING set are woken up.

Doesn't work for PREEMPT+!ORC.  Non-ORC reliable unwinders will detect
preemption on the stack and automatically report unreliable.

-- 
Josh
