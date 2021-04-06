Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC18355AF1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhDFSCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236951AbhDFSCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 14:02:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF439613D4;
        Tue,  6 Apr 2021 18:02:39 +0000 (UTC)
Date:   Tue, 6 Apr 2021 14:02:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: bug report: WARNING in bonding
Message-ID: <20210406140237.2df98a98@gandalf.local.home>
In-Reply-To: <d2979424-bb3e-3e1f-d53c-2b3580811533@gmail.com>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
        <20201112154627.GA2138135@shredder>
        <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
        <20201112163307.GA2140537@shredder>
        <67b689d8-419b-78ec-0286-0983337ca3c1@gmail.com>
        <d2979424-bb3e-3e1f-d53c-2b3580811533@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 17:24:48 +0200
Tariq Toukan <ttoukan.linux@gmail.com> wrote:

> > Hi,
> > 
> > Issue still reproduces. Even in GA kernel.
> > It is always preceded by some other lockdep warning.
> > 
> > So to get the reproduction:
> > - First, have any lockdep issue.
> > - Then, open bond interface.
> > 
> > Any idea what could it be?
> > 
> > We'll share any new info as soon as we have it.

Looks like you are triggering:

int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
{
	struct bond_up_slave *usable_slaves = NULL, *all_slaves = NULL;
	struct slave *slave;
	struct list_head *iter;
	int agg_id = 0;
	int ret = 0;

#ifdef CONFIG_LOCKDEP
	WARN_ON(lockdep_is_held(&bond->mode_lock));
#endif

And the below commit made lockdep_is_held() always return true if lockdep
has been previously triggered. That is, if you had a lockdep splat earlier,
then lockdep_is_held() will always return true, and this WARN_ON() will
always trigger.

Peter,

Perhaps we should not have this part of your patch:

@@ -5056,13 +5081,13 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
        unsigned long flags;
        int ret = 0;
 
-       if (unlikely(current->lockdep_recursion))
+       if (unlikely(!lockdep_enabled()))
                return 1; /* avoid false negative lockdep_assert_held() */
 
        raw_local_irq_save(flags);
        check_flags(flags);
 

Because that changes how lock_is_held_type() behaves, and it will return
true if there's been an earlier lockdep splat, and any code that has
something like the above is going to fail.

Although, checking if a lot is not held seems rather strange. If anything,
the above should be changed to WARN_ON_ONCE() so that it doesn't constantly
trigger when a lockdep trigger happens.

-- Steve


> > 
> > Regards,
> > Tariq  
> 
> 
> Bisect shows this is the offending commit:
> 
> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 2 11:04:21 2020 +0200
> 
>      lockdep: Fix lockdep recursion
> 
>      Steve reported that lockdep_assert*irq*(), when nested inside lockdep
>      itself, will trigger a false-positive.
> 
>      One example is the stack-trace code, as called from inside lockdep,
>      triggering tracing, which in turn calls RCU, which then uses
>     lockdep_assert_irqs_disabled().
> 
>      Fixes: a21ee6055c30 ("lockdep: Change hardirq{s_enabled,_context} 
> to per-cpu variables")
>      Reported-by: Steven Rostedt <rostedt@goodmis.org>
>      Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>      Signed-off-by: Ingo Molnar <mingo@kernel.org>

