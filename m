Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF41A67E862
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbjA0Oh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjA0OhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:37:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7DD10AAF;
        Fri, 27 Jan 2023 06:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE0A9CE28AC;
        Fri, 27 Jan 2023 14:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7965C433EF;
        Fri, 27 Jan 2023 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674830240;
        bh=v3eOORH1vFxbJCkfdVsgU0KrCMcitEhhfRmKBwsxS6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUahZpFruDh9RgQbVMAl/z0yOthFs9IuubkzkoFzqh2JtXsihrUSSqAP3WjEyLQSL
         zEJ4XMmkuGDxyy3nm73pS1IsXj/Yaj/qq/FX5oK9g6qH9foZ38E2H1k+cNPEQCgMVU
         IBcj8y4zWQE8sh64U9wsm/IctIAoghhpq+nD6ItkTloxWaLZhb7lCr+VpBgWlakFT4
         xWGpj6iJOOTpg/jFvHDkjYqeeH3utcLTpuqlw6ORVViKKXNlJvx7dj3gn8hWKL+abR
         D5wrd0WrNvg+4vIlu11AbIDSklLixg3RCcYwKrv+zIy0zLWqhdFGc1556Yz7sLcocg
         pEFXc/lgyzoOA==
Date:   Fri, 27 Jan 2023 08:37:19 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9Phn27nrVO/oOi+@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <Y9O+3jzH0PiG1qlJ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9O+3jzH0PiG1qlJ@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 01:09:02PM +0100, Petr Mladek wrote:
> There might actually be two possibilities why the transition fails
> too often:
> 
> 1. The task might be in the running state most of the time. Therefore
>    the backtrace is not reliable most of the time.
> 
>    In this case, some cooperation with the scheduler would really
>    help. We would need to stop the task and check the stack
>    when it is stopped. Something like the patch you proposed.

This is the situation we are encountering.

> 2. The task might be sleeping but almost always in a livepatched
>    function. Therefore it could not be transitioned.
> 
>    It might be the case with vhost_worker(). The main loop is "tiny".
>    The kthread probaly spends most of the time with processing
>    a vhost_work. And if the "works" are livepatched...
> 
>    In this case, it would help to call klp_try_switch_task(current)
>    in the main loop in vhost_worker(). It would always succeed
>    when vhost_worker() is not livepatched on its own.
> 
>    Note that even this would not help with kPatch when a single
>    vhost_work might need more than the 1 minute timout to get proceed.
> 
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > index f1b25ec581e0..06746095a724 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/cpu.h>
> >  #include <linux/stacktrace.h>
> > +#include <linux/stop_machine.h>
> >  #include "core.h"
> >  #include "patch.h"
> >  #include "transition.h"
> > @@ -334,6 +335,16 @@ static bool klp_try_switch_task(struct task_struct *task)
> >  	return !ret;
> >  }
> >  
> > +static int __stop_try_switch(void *arg)
> > +{
> > +	return klp_try_switch_task(arg) ? 0 : -EBUSY;
> > +}
> > +
> > +static bool klp_try_switch_task_harder(struct task_struct *task)
> > +{
> > +	return !stop_one_cpu(task_cpu(task), __stop_try_switch, task);
> > +}
> > +
> >  /*
> >   * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
> >   * Kthreads with TIF_PATCH_PENDING set are woken up.
> 
> Nice. I am surprised that it can be implemented so easily.

Yes, that's a neat solution. I will give it a try.

AIUI this still doesn't help for architectures without a reliable
stacktrace though, right? So we probably should only try this for
architectures which do have relaible stacktraces.

Thanks,
Seth
