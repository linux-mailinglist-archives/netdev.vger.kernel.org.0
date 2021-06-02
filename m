Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4E1398B39
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFBOAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhFBOAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 10:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B1D60FE3;
        Wed,  2 Jun 2021 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622642287;
        bh=dHpSABRDz/ACjiNwYplGY79xrERr0Xgmy3y4+S1hSB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DyLYFBMg9k5l89eFjJpIxjBnu2FGj82B4XdXYxhPkhiK5M5yuGrI9d91r/PWv2LiV
         K/2h7mAR3azlB6I5M5ciHb74VYjP7zKuJQjACzKPP/OA2ba9LiDUk+xvlBhBE/gp12
         vi5CNlvHSLUJYVKuxJf36nLKhtJxH/zOZTChLuKQ=
Date:   Wed, 2 Jun 2021 15:58:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Unbreak wakeups
Message-ID: <YLeObHTKKDGd3pdA@kroah.com>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.271625424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602133040.271625424@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:12:26PM +0200, Peter Zijlstra wrote:
> Remove broken task->state references and let wake_up_process() DTRT.
> 
> The anti-pattern in these patches breaks the ordering of ->state vs
> COND as described in the comment near set_current_state() and can lead
> to missed wakeups:
> 
> 	(OoO load, observes RUNNING)<-.
> 	for (;;) {                    |
> 	  t->state = UNINTERRUPTIBLE; |
> 	  smp_mb();          ,-----> ,' (OoO load, observed !COND)
>                              |       |
> 	                     |       |	COND = 1;
> 			     |	     `- if (t->state != RUNNING)
>                              |		  wake_up_process(t); // not done
> 	  if (COND) ---------'
> 	    break;
> 	  schedule(); // forever waiting
> 	}
> 	t->state = TASK_RUNNING;
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  drivers/net/ethernet/qualcomm/qca_spi.c |    6 ++----
>  drivers/usb/gadget/udc/max3420_udc.c    |   15 +++++----------
>  drivers/usb/host/max3421-hcd.c          |    3 +--
>  kernel/softirq.c                        |    2 +-
>  4 files changed, 9 insertions(+), 17 deletions(-)

For USB stuff:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
