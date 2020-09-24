Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDD276B09
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgIXHmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:42:19 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49582 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgIXHmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 03:42:18 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLLtE-0004nh-JJ; Thu, 24 Sep 2020 17:42:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 17:42:04 +1000
Date:   Thu, 24 Sep 2020 17:42:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     peterz@infradead.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+c32502fd255cb3a44048@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Subject: Re: possible deadlock in xfrm_policy_delete
Message-ID: <20200924074204.GA9879@gondor.apana.org.au>
References: <00000000000056c1dc05afc47ddb@google.com>
 <20200924043554.GA9443@gondor.apana.org.au>
 <CACT4Y+aw+Z_7JwDiu65hL7K99f1oBfRFavZz4Pr4o8Us5peH4g@mail.gmail.com>
 <20200924073003.GZ1362448@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924073003.GZ1362448@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 09:30:03AM +0200, peterz@infradead.org wrote:
> On Thu, Sep 24, 2020 at 06:44:12AM +0200, Dmitry Vyukov wrote:
> > On Thu, Sep 24, 2020 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > >  (k-slock-AF_INET6){+.-.}-{2:2}
> 
> That's a seqlock.

Are you sure? Line 2503 in net/ipv4/tcp.c says

	bh_lock_sock(sk);

> Did that tree you're testing include 267580db047e ("seqlock: Unbreak
> lockdep") ?

According to

https://syzkaller.appspot.com/bug?extid=c32502fd255cb3a44048

the git tree used was

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/include?id=5fa35f247b563a7893f3f68f19d00ace2ccf3dff

so no it doesn't contain that patch.

Hopefully this would address those seqlock backtraces.  But what
about this particular one which is caused by the socket lock?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
