Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267852767E8
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIXEgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:36:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48908 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXEgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:36:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLIz6-000260-1l; Thu, 24 Sep 2020 14:35:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:35:55 +1000
Date:   Thu, 24 Sep 2020 14:35:55 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: Re: possible deadlock in xfrm_policy_delete
Message-ID: <20200924043554.GA9443@gondor.apana.org.au>
References: <00000000000056c1dc05afc47ddb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000056c1dc05afc47ddb@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 01:22:14PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    5fa35f24 Add linux-next specific files for 20200916
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1122e2d9900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6bdb7e39caf48f53
> dashboard link: https://syzkaller.appspot.com/bug?extid=c32502fd255cb3a44048
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com
> 
> =====================================================
> WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
> 5.9.0-rc5-next-20200916-syzkaller #0 Not tainted
> -----------------------------------------------------
> syz-executor.1/13775 [HC0[0]:SC0[4]:HE1:SE0] is trying to acquire:
> ffff88805ee15a58 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
> ffff88805ee15a58 (&net->xfrm.xfrm_policy_lock){+...}-{2:2}, at: xfrm_policy_delete+0x3a/0x90 net/xfrm/xfrm_policy.c:2236
> 
> and this task is already holding:
> ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> ffff8880a811b1e0 (k-slock-AF_INET6){+.-.}-{2:2}, at: tcp_close+0x6e3/0x1200 net/ipv4/tcp.c:2503
> which would create a new lock dependency:
>  (k-slock-AF_INET6){+.-.}-{2:2} -> (&net->xfrm.xfrm_policy_lock){+...}-{2:2}
> 
> but this new dependency connects a SOFTIRQ-irq-safe lock:
>  (k-slock-AF_INET6){+.-.}-{2:2}
> 
> ... which became SOFTIRQ-irq-safe at:
>   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   spin_lock include/linux/spinlock.h:354 [inline]
>   sctp_rcv+0xd96/0x2d50 net/sctp/input.c:231

What's going on with all these bogus lockdep reports?

These are two completely different locks, one is for TCP and the
other is for SCTP.  Why is lockdep suddenly beoming confused about
this?

FWIW this flood of bogus reports started on 16/Sep.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
