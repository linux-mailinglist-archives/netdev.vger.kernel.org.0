Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E812767F9
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgIXEsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:48:15 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48958 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXEsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 00:48:15 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLJAp-0002Eu-Ii; Thu, 24 Sep 2020 14:48:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 14:48:03 +1000
Date:   Thu, 24 Sep 2020 14:48:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: Re: possible deadlock in xfrm_policy_delete
Message-ID: <20200924044803.GA9585@gondor.apana.org.au>
References: <00000000000056c1dc05afc47ddb@google.com>
 <20200924043554.GA9443@gondor.apana.org.au>
 <CACT4Y+aw+Z_7JwDiu65hL7K99f1oBfRFavZz4Pr4o8Us5peH4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+aw+Z_7JwDiu65hL7K99f1oBfRFavZz4Pr4o8Us5peH4g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 06:44:12AM +0200, Dmitry Vyukov wrote:
>
> FWIW one of the dups of this issue was bisected to:
> 
> commit 1909760f5fc3f123e47b4e24e0ccdc0fc8f3f106
> Author: Ahmed S. Darwish <a.darwish@linutronix.de>
> Date:   Fri Sep 4 15:32:31 2020 +0000
> 
>     seqlock: PREEMPT_RT: Do not starve seqlock_t writers
> 
> Can it be related?

Whether there is a genuine problem or not, the lockdep report
that I quoted is simply non-sensical because it's considering
two distinct seqlocks to be the same lock.

I don't think the lockdep issue has anything to do with the commit
question because this commit is specific to seqlocks.  There is
another syzbot report in this pile that mixed the SCTP socket lock
with the TCP socket lock and those are not seqlocks.

It's almost as if when a spinlock is freed and reallocated lockdep
is not clearing the existing state.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
