Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386982DC2FE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgLPPVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:21:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:40192 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgLPPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:21:55 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608132072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GTATY7NfTNnLB+jCOVoePIyG5NvZnyMl6xNti/B0Az0=;
        b=KNDFLwwJL+L9blG/tETlfh3SEsC1Wa17vtApRdv5y17dyQEYnHYUpRVNIGO+UWlJKBA8mL
        XaROVdQvQB7YBnwNJMsK++1ZDL7zxWpxz2dmlz5u5hE6+Ext4332WJMp80DKdid47YmnIU
        mpFB2P92Q0cUbFEYOr+zrVbnQpCxeTdekbHK3dVYERcQUMydFSRyUiCegGKK8J+wyn5yC8
        HpeybTFqXGRRHfoKazEbj2oa8craYy0s5Oy60aTTs1hDqSKHnuIl+zk8F1s2biz/wn1+47
        IUmJcMIX5LQ5cTuagidAYxyx98kvNwY5D+YDz1WRLS5E5WOtGWHA5KzCQHiXfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608132072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GTATY7NfTNnLB+jCOVoePIyG5NvZnyMl6xNti/B0Az0=;
        b=hYwWTetIOgAECtmXuQ4ewDg/0LQvyFbAVK1+XGpmJ0rBa5F9ZupK59lsFFqebmUfsntzrB
        mRh/YPNSMxEjCFAg==
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>, rcu@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [stabe-rc 5.9 ] sched: core.c:7270 Illegal context switch in RCU-bh read-side critical section!
In-Reply-To: <CA+G9fYt_zxDSN5Qkx=rBE_ZkjirOBQ3QpFRy-gkqbjbJ=n1Z4Q@mail.gmail.com>
References: <CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com> <20201215144531.GZ2657@paulmck-ThinkPad-P72> <20201215102246.4bdca3d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+G9fYt_zxDSN5Qkx=rBE_ZkjirOBQ3QpFRy-gkqbjbJ=n1Z4Q@mail.gmail.com>
Date:   Wed, 16 Dec 2020 16:21:12 +0100
Message-ID: <87lfdxsro7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16 2020 at 15:55, Naresh Kamboju wrote:
> On Tue, 15 Dec 2020 at 23:52, Jakub Kicinski <kuba@kernel.org> wrote:
>> > Or you could place checks for being in a BH-disable further up in
>> > the code.  Or build with CONFIG_DEBUG_INFO=y to allow more precise
>> > interpretation of this stack trace.
>
> I will try to reproduce this warning with DEBUG_INFO=y enabled kernel and
> get back to you with a better crash log.
>
>>
>> My money would be on the option that whatever run on this workqueue
>> before forgot to re-enable BH, but we already have a check for that...
>> Naresh, do you have the full log? Is there nothing like "BUG: workqueue
>> leaked lock" above the splat?

No, because it's in the middle of the work. The workqueue bug triggers
when the work has finished.

So cleanup_up() net does

   ....
   synchronize_rcu();   <- might sleep. So up to here it should be fine.

   list_for_each_entry_continue_reverse(ops, &pernet_list, list)
   	ops_exit_list(ops, &net_exit_list);

ops_exit_list() is called for each ops which then either invokes
ops->exit() or ops->exit_batch().

So one of those callbacks fails to reenable BH, so adding a check after
each invocation of ops->exit() and ops->exit_batch() for
!local_bh_disabled() should be able to identify the buggy callback.

Thanks,

        tglx
