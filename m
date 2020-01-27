Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4F14A134
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgA0JwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:52:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgA0JwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:52:19 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CD8F1502D65A;
        Mon, 27 Jan 2020 01:52:17 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:52:15 +0100 (CET)
Message-Id: <20200127.105215.1264835920548133703.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com,
        syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: fix ops->bind_class() implementations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124002618.21518-1-xiyou.wangcong@gmail.com>
References: <20200124002618.21518-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:52:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 23 Jan 2020 16:26:18 -0800

> The current implementations of ops->bind_class() are merely
> searching for classid and updating class in the struct tcf_result,
> without invoking either of cl_ops->bind_tcf() or
> cl_ops->unbind_tcf(). This breaks the design of them as qdisc's
> like cbq use them to count filters too. This is why syzbot triggered
> the warning in cbq_destroy_class().
> 
> In order to fix this, we have to call cl_ops->bind_tcf() and
> cl_ops->unbind_tcf() like the filter binding path. This patch does
> so by refactoring out two helper functions __tcf_bind_filter()
> and __tcf_unbind_filter(), which are lockless and accept a Qdisc
> pointer, then teaching each implementation to call them correctly.
> 
> Note, we merely pass the Qdisc pointer as an opaque pointer to
> each filter, they only need to pass it down to the helper
> functions without understanding it at all.
> 
> Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
> Reported-and-tested-by: syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
