Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2871859C8
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgCODmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:42:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgCODmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:42:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27D1E15B75121;
        Sat, 14 Mar 2020 20:42:06 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:42:03 -0700 (PDT)
Message-Id: <20200314.204203.716262950775446891.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+653090db2562495901dc@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: hold rtnl lock in
 tcindex_partial_destroy_work()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
References: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:42:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 11 Mar 2020 22:42:27 -0700

> syzbot reported a use-after-free in tcindex_dump(). This is due to
> the lack of RTNL in the deferred rcu work. We queue this work with
> RTNL in tcindex_change(), later, tcindex_dump() is called:
> 
>         fh = tp->ops->get(tp, t->tcm_handle);
> 	...
>         err = tp->ops->change(..., &fh, ...);
>         tfilter_notify(..., fh, ...);
> 
> but there is nothing to serialize the pending
> tcindex_partial_destroy_work() with tcindex_dump().
> 
> Fix this by simply holding RTNL in tcindex_partial_destroy_work(),
> so that it won't be called until RTNL is released after
> tc_new_tfilter() is completed.
> 
> Reported-and-tested-by: syzbot+653090db2562495901dc@syzkaller.appspotmail.com
> Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks Cong.
