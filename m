Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F5D3993C0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFBTqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 15:46:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56082 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhFBTqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:46:02 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 11B1A219C9;
        Wed,  2 Jun 2021 19:44:17 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E98D2118DD;
        Wed,  2 Jun 2021 19:44:04 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 2jzcLITft2B5CwAALh3uQQ
        (envelope-from <dave@stgolabs.net>); Wed, 02 Jun 2021 19:44:04 +0000
Date:   Wed, 2 Jun 2021 12:43:59 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20210602194359.pxujd4rx4lxv2ldm@offworld>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cgroups@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
References: <20210602131225.336600299@infradead.org>
 <20210602133040.271625424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210602133040.271625424@infradead.org>
User-Agent: NeoMutt/20201120
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Jun 2021, Peter Zijlstra wrote:

>Remove broken task->state references and let wake_up_process() DTRT.
>
>The anti-pattern in these patches breaks the ordering of ->state vs
>COND as described in the comment near set_current_state() and can lead
>to missed wakeups:
>
>	(OoO load, observes RUNNING)<-.
>	for (;;) {                    |
>	  t->state = UNINTERRUPTIBLE; |
>	  smp_mb();          ,-----> ,' (OoO load, observed !COND)
>                             |       |
>	                     |       |	COND = 1;
>			     |	     `- if (t->state != RUNNING)
>                             |		  wake_up_process(t); // not done
>	  if (COND) ---------'
>	    break;
>	  schedule(); // forever waiting
>	}
>	t->state = TASK_RUNNING;
>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
