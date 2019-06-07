Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D2F38F22
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfFGPcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:32:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44212 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbfFGPcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:32:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hZGr6-0000Wb-T4; Fri, 07 Jun 2019 23:32:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hZGqw-0007N0-7k; Fri, 07 Jun 2019 23:32:26 +0800
Date:   Fri, 7 Jun 2019 23:32:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: inet: frags: Turn fqdir->dead into an int for old Alphas
Message-ID: <20190607153226.gzt4yeq5c5i6bpqd@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
 <20190607140949.tzwyprrhmqdx33iu@gondor.apana.org.au>
 <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da5eedfe-92f9-6c50-b9e7-68886047dd25@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 08:26:12AM -0700, Eric Dumazet wrote:
>
> There is common knowledge among us programmers that bit fields
> (or bool) sharing a common 'word' need to be protected
> with a common lock.
> 
> Converting all bit fields to plain int/long would be quite a waste of memory.
> 
> In this case, fqdir_exit() is called right before the whole
> struct fqdir is dismantled, and the only cpu that could possibly
> change the thing is ourself, and we are going to start an RCU grace period.
> 
> Note that first cache line in 'struct fqdir' is read-only.
> Only ->dead field is flipped to one at exit time.
> 
> Your patch would send a strong signal to programmers to not even try using
> bit fields.
> 
> Do we really want that ?

If this were a bitfield then I'd think it would be safer because
anybody adding a new bitfield is unlikely to try modifying both
fields without locking or atomic ops.

However, because this is a boolean, I can certainly see someone
else coming along and adding another bool right next to it and
expecting writes them to still be atomic.

As it stands, my patch has zero impact on memory usage because
it's simply using existing padding.  Should this become an issue
in future, we can always revisit this and use a more appropriate
method of addressing it.

But the point is to alert future developers that this field is
not an ordinary boolean.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
