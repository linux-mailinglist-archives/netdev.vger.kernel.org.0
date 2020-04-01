Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B515F19B516
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbgDASHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:07:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732121AbgDASHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:07:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C785A11955704;
        Wed,  1 Apr 2020 11:07:11 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:07:10 -0700 (PDT)
Message-Id: <20200401.110710.446461527815245401.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com,
        tglx@linutronix.de, paulmck@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct
 tcindex_data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:07:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sat, 28 Mar 2020 12:12:59 -0700

> Although we intentionally use an ordered workqueue for all tc
> filter works, the ordering is not guaranteed by RCU work,
> given that tcf_queue_work() is esstenially a call_rcu().
> 
> This problem is demostrated by Thomas:
> 
>   CPU 0:
>     tcf_queue_work()
>       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> 
>   -> Migration to CPU 1
> 
>   CPU 1:
>      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> 
> so the 2nd work could be queued before the 1st one, which leads
> to a free-after-free.
> 
> Enforcing this order in RCU work is hard as it requires to change
> RCU code too. Fortunately we can workaround this problem in tcindex
> filter by taking a temporary refcnt, we only refcnt it right before
> we begin to destroy it. This simplifies the code a lot as a full
> refcnt requires much more changes in tcindex_set_parms().
> 
> Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
