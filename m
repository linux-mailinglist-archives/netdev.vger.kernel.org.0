Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA2470618
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240630AbhLJQuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:50:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47664 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240235AbhLJQuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:50:11 -0500
Date:   Fri, 10 Dec 2021 17:46:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639154794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsDW2WXc3YGMSMrB77PgpEwdVvQaSLQKheq9pxgtsQY=;
        b=y4Qe87qQdtddvViSG3e7gnZFwOse/OleVys50baCUYsavZkATjWywExy8oD+2J3qH8XHlQ
        bTqeZgryUrXXF62/GPy91yodmj1E/nNZvpMFxr/CSnyeJRaFyul/EQlr9IDB+bMUskB/1d
        M6Wzq6DJstsvMI/NpLsUCiEr5gAmNOu08TT1ZrIwXal8u4rrbj5JLGSUq7Jkew88lq8teE
        JIpFrL+vVlxom0ohyyKmQ7DKT0AKFM8k0ahBoM0exkJ11rYl6siaTFpA5JTwFjKcCUcVmk
        CMiKv0ELSYaraozHcOmwmK6ndQD7tyCEqFEriM2MhnVk2n+frO4wmZa+LN93XQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639154794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rsDW2WXc3YGMSMrB77PgpEwdVvQaSLQKheq9pxgtsQY=;
        b=cqbLXI9s9XLU86SiIr/7hG1PDtAcmcIjQ/oitcUxsidME3io+op/1HIL9Ghsh/x+ikiRIe
        KGyv3LGTA7ebTIAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbOEaSQW+LtWjuzI@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-10 17:35:21 [+0100], Paolo Abeni wrote:
> On Fri, 2021-12-10 at 16:41 +0100, Sebastian Andrzej Siewior wrote:
> > The root-lock is dropped before dev_hard_start_xmit() is invoked and after
> > setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
> > by another sender/task with a higher priority then this new sender won't
> > be able to submit packets to the NIC directly instead they will be
> > enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
> > is scheduled again and finishes the job.
> > 
> > By serializing every task on the ->busylock then the task will be
> > preempted by a sender only after the Qdisc has no owner.
> > 
> > Always serialize on the busylock on PREEMPT_RT.
> 
> Not sure how much is relevant in the RT context, but this should impact
> the xmit tput in a relevant, negative way.

Negative because everyone blocks on lock and transmits packets directly
instead of adding it to the queue and leaving for more?

> If I read correctly, you use the busylock to trigger priority ceiling
> on each sender. I'm wondering if there are other alternative ways (no
> contended lock, just some RT specific annotation) to mark a whole
> section of code for priority ceiling ?!?

priority ceiling as you call it, happens always with the help of a lock.
The root_lock is dropped in sch_direct_xmit().
qdisc_run_begin() sets only a bit with no owner association.
If I know why the busy-lock bad than I could add another one. The
important part is force the sende out of the section so the task with
the higher priority can send packets instead of queueing them only.

> Thanks!
> 
> Paolo

Sebastian
