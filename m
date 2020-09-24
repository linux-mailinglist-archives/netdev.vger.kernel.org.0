Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9DF2767F3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgIXElU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:41:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48938 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXElT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:41:19 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLJ4A-00028T-RJ; Thu, 24 Sep 2020 14:41:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:41:10 +1000
Date:   Thu, 24 Sep 2020 14:41:10 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+f4d0f0f7c860608404c4@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: Re: inconsistent lock state in xfrm_policy_lookup_inexact_addr
Message-ID: <20200924044110.GA9534@gondor.apana.org.au>
References: <000000000000c59e2c05af6a5e7e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c59e2c05af6a5e7e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 01:51:14AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6b02addb Add linux-next specific files for 20200915
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15888efd900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7086d0e9e44d4a14
> dashboard link: https://syzkaller.appspot.com/bug?extid=f4d0f0f7c860608404c4
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f4d0f0f7c860608404c4@syzkaller.appspotmail.com
> 
> ================================
> WARNING: inconsistent lock state
> 5.9.0-rc5-next-20200915-syzkaller #0 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-R} usage.
> kworker/1:1/23 [HC0[0]:SC1[1]:HE0:SE0] takes:
> ffff8880a6ff5f28 (&s->seqcount#12){+.+-}-{0:0}, at: xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
>   write_seqcount_t_begin_nested include/linux/seqlock.h:509 [inline]
>   write_seqcount_t_begin include/linux/seqlock.h:535 [inline]
>   write_seqlock include/linux/seqlock.h:883 [inline]
>   xfrm_set_spdinfo+0x302/0x660 net/xfrm/xfrm_user.c:1185

This is &net->xfrm.policy_hthresh.lock.

...

> stack backtrace:
> CPU: 1 PID: 23 Comm: kworker/1:1 Not tainted 5.9.0-rc5-next-20200915-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: wg-crypt-wg0 wg_packet_tx_worker
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fb lib/dump_stack.c:118
>  print_usage_bug kernel/locking/lockdep.c:3694 [inline]
>  valid_state kernel/locking/lockdep.c:3705 [inline]
>  mark_lock_irq kernel/locking/lockdep.c:3908 [inline]
>  mark_lock.cold+0x13/0x10d kernel/locking/lockdep.c:4375
>  mark_usage kernel/locking/lockdep.c:4252 [inline]
>  __lock_acquire+0x1402/0x55d0 kernel/locking/lockdep.c:4750
>  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
>  seqcount_lockdep_reader_access+0x139/0x1a0 include/linux/seqlock.h:103
>  xfrm_policy_lookup_inexact_addr+0x57/0x200 net/xfrm/xfrm_policy.c:1909

And this is a completely different seqlock.

Again lockdep is creating a bogus report by lumping two unrelated
locks (but of the same type, in this case seqlock) together.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
