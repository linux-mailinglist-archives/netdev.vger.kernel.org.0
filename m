Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E985F1ED226
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgFCOeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCOeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:34:13 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC207C08C5C0;
        Wed,  3 Jun 2020 07:34:13 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jgUSu-0001eH-D8; Wed, 03 Jun 2020 16:34:00 +0200
Date:   Wed, 3 Jun 2020 16:33:58 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200603143358.GA1121436@debian-buster-darwi.lab.linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200519214547.352050-2-a.darwish@linutronix.de>
 <33cec6a9-2f6e-3d3c-99ac-9b2a3304ec26@gmail.com>
 <20200520064246.GA353513@debian-buster-darwi.lab.linutronix.de>
 <1498089b-08bd-d776-1570-d8b34463c702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498089b-08bd-d776-1570-d8b34463c702@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 05:51:27AM -0700, Eric Dumazet wrote:
>
> On 5/19/20 11:42 PM, Ahmed S. Darwish wrote:
> > Hello Eric,
> >
> > On Tue, May 19, 2020 at 07:01:38PM -0700, Eric Dumazet wrote:
> >>
> >> On 5/19/20 2:45 PM, Ahmed S. Darwish wrote:
> >>> Sequence counters write paths are critical sections that must never be
> >>> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
> >>>
> >>> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
> >>> netdev name retrieval.") handled a deadlock, observed with
> >>> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
> >>> infinitely spinning: it got scheduled after the seqcount write side
> >>> blocked inside its own critical section.
> >>>
> >>> To fix that deadlock, among other issues, the commit added a
> >>> cond_resched() inside the read side section. While this will get the
> >>> non-preemptible kernel eventually unstuck, the seqcount reader is fully
> >>> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
> >>>
> >>> The fix is also still broken: if the seqcount reader belongs to a
> >>> real-time scheduling policy, it can spin forever and the kernel will
> >>> livelock.
> >>>
> >>> Disabling preemption over the seqcount write side critical section will
> >>> not work: inside it are a number of GFP_KERNEL allocations and mutex
> >>> locking through the drivers/base/ :: device_rename() call chain.
> >>>
> >>> From all the above, replace the seqcount with a rwsem.
> >>>
> >>> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
> >>> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
> >>> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> >>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >>> ---
> >>>  net/core/dev.c | 30 ++++++++++++------------------
> >>>  1 file changed, 12 insertions(+), 18 deletions(-)
> >>>
> >>
> >> Seems fine to me, assuming rwsem prevent starvation of the writer.
> >>
> >
> > Thanks for the review.
> >
> > AFAIK, due to 5cfd92e12e13 ("locking/rwsem: Adaptive disabling of reader
> > optimistic spinning"), using a rwsem shouldn't lead to writer starvation
> > in the contended case.
>
> Hmm this was in linux-5.3, so very recent stuff.
>
> Has this patch been backported to stable releases ?
>
> With all the Fixes: tags you added, stable teams will backport this
> networking patch to all stable versions.
>
> Do we have a way to tune a dedicare rwsem to 'give preference to the
> (unique in this case) writer" over a myriad of potential readers ?
>

I was wrong in referencing the commit 5cfd92e12e13 above.

Before and after that commit, once a rwsem writer is blocking, all
subsequent readers will block until that writer makes progress.

Given that behavior, and that the read section is already quite short, I
don't think there's any danger incurred on writers here.

(a v2 will be sent shortly, fixing the error found Dan/kbuild-bot.)

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
