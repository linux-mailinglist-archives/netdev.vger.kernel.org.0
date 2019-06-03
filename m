Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C987C3272C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFCERp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:17:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48338 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbfFCERp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 00:17:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hXePg-0000Ph-O8; Mon, 03 Jun 2019 12:17:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hXePb-00028Y-Ix; Mon, 03 Jun 2019 12:17:31 +0800
Date:   Mon, 3 Jun 2019 12:17:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190603041731.m6rvcaivgeh4iw4g@gondor.apana.org.au>
References: <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603040114.st646bujtgyu7adn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603040114.st646bujtgyu7adn@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 12:01:14PM +0800, Herbert Xu wrote:
> On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> >
> > 	CPU2:         if (b != 1)
> > 	CPU2:                 b = 1;
> 
> Stop right there.  The kernel is full of code that assumes that
> assignment to an int/long is atomic.  If your compiler breaks this
> assumption that we can kiss the kernel good-bye.

The slippery slope apparently started here:

: commit ea435467500612636f8f4fb639ff6e76b2496e4b
: Author: Matthew Wilcox <matthew@wil.cx>
: Date:   Tue Jan 6 14:40:39 2009 -0800
: 
:     atomic_t: unify all arch definitions
:
: diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
: index ad5b9f6ecddf..85b46fba4229 100644
: --- a/arch/x86/include/asm/atomic_32.h
: +++ b/arch/x86/include/asm/atomic_32.h
: ...
: @@ -10,15 +11,6 @@
:   * resource counting etc..
:   */
:
: -/*
: - * Make sure gcc doesn't try to be clever and move things around
: - * on us. We need to use _exactly_ the address the user gave us,
: - * not some alias that contains the same information.
: - */
: -typedef struct {
: -       int counter;
: -} atomic_t;
:
: diff --git a/include/linux/types.h b/include/linux/types.h
: index 121f349cb7ec..3b864f2d9560 100644
: --- a/include/linux/types.h
: +++ b/include/linux/types.h
: @@ -195,6 +195,16 @@ typedef u32 phys_addr_t;
:  
:  typedef phys_addr_t resource_size_t;
:
: +typedef struct {
: +       volatile int counter;
: +} atomic_t;
: +

Before evolving into the READ_ONCE/WRITE_ONCE that we have now.

Linus, are we now really supporting a compiler where an assignment
(or a read) from an int/long/pointer can be non-atomic without the
volatile marker? Because if that's the case then we have a lot of
code to audit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
