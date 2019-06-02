Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E219C32242
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 07:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfFBF41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 01:56:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35354 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfFBF41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 01:56:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hXJTf-0004RN-KW; Sun, 02 Jun 2019 13:56:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hXJTT-00010X-DZ; Sun, 02 Jun 2019 13:56:07 +0800
Date:   Sun, 2 Jun 2019 13:56:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc:     Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: rcu_read_lock lost its compiler barrier
Message-ID: <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150921204327.GH4029@linux.vnet.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Digging up an old email because I was not aware of this previously
but Paul pointed me to it during another discussion.

On Mon, Sep 21, 2015 at 01:43:27PM -0700, Paul E. McKenney wrote:
> On Mon, Sep 21, 2015 at 09:30:49PM +0200, Frederic Weisbecker wrote:
>
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index d63bb77..6c3cece 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -297,12 +297,14 @@ void synchronize_rcu(void);
> > >  
> > >  static inline void __rcu_read_lock(void)
> > >  {
> > > -	preempt_disable();
> > > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
> > > +		preempt_disable();
> > 
> > preempt_disable() is a no-op when !CONFIG_PREEMPT_COUNT, right?
> > Or rather it's a barrier(), which is anyway implied by rcu_read_lock().
> > 
> > So perhaps we can get rid of the IS_ENABLED() check?
> 
> Actually, barrier() is not intended to be implied by rcu_read_lock().
> In a non-preemptible RCU implementation, it doesn't help anything
> to have the compiler flush its temporaries upon rcu_read_lock()
> and rcu_read_unlock().

This is seriously broken.  RCU has been around for years and is
used throughout the kernel while the compiler barrier existed.

You can't then go and decide to remove the compiler barrier!  To do
that you'd need to audit every single use of rcu_read_lock in the
kernel to ensure that they're not depending on the compiler barrier.

This is also contrary to the definition of almost every other
*_lock primitive in the kernel where the compiler barrier is
included.

So please revert this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
