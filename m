Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F010194FA7
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0D1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:27:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58054 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0D1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:27:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0591D15CE962A;
        Thu, 26 Mar 2020 20:27:14 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:27:14 -0700 (PDT)
Message-Id: <20200326.202714.1221436401038064762.davem@davemloft.net>
To:     cai@lca.pw
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipv4: fix a RCU-list lock in fib_triestat_seq_show
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325220100.7863-1-cai@lca.pw>
References: <20200325220100.7863-1-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:27:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Wed, 25 Mar 2020 18:01:00 -0400

> fib_triestat_seq_show() calls hlist_for_each_entry_rcu(tb, head,
> tb_hlist) without rcu_read_lock() will trigger a warning,
> 
>  net/ipv4/fib_trie.c:2579 RCU-list traversed in non-reader section!!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 2, debug_locks = 1
>  1 lock held by proc01/115277:
>   #0: c0000014507acf00 (&p->lock){+.+.}-{3:3}, at: seq_read+0x58/0x670
> 
>  Call Trace:
>   dump_stack+0xf4/0x164 (unreliable)
>   lockdep_rcu_suspicious+0x140/0x164
>   fib_triestat_seq_show+0x750/0x880
>   seq_read+0x1a0/0x670
>   proc_reg_read+0x10c/0x1b0
>   __vfs_read+0x3c/0x70
>   vfs_read+0xac/0x170
>   ksys_read+0x7c/0x140
>   system_call+0x5c/0x68
> 
> Fix it by adding a pair of rcu_read_lock/unlock() and use
> cond_resched_rcu() to avoid the situation where walking of a large
> number of items  may prevent scheduling for a long time.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>

Eric, please review.
