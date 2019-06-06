Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5817836C17
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 08:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfFFGOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 02:14:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36354 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 02:14:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYlfi-0006IW-UG; Thu, 06 Jun 2019 14:14:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYlfa-0003iA-FC; Thu, 06 Jun 2019 14:14:38 +0800
Date:   Thu, 6 Jun 2019 14:14:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
 <20190606060511.GA28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606060511.GA28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:05:11PM -0700, Paul E. McKenney wrote:
>
> In case you were wondering, the reason that I was giving you such
> a hard time was that from what I could see, you were pushing for no
> {READ,WRITE}_ONCE() at all.  ;-)

Hmm, that's exactly what it should be in net/ipv4/inet_fragment.c.
We don't need the READ_ONCE/WRITE_ONCE (or volatile marking) at
all.  Even if the compiler dices and slices the reads/writes of
"a" into a thousand pieces, it should still work if the RCU
primitives are worth their salt.

But I do concede that in the general RCU case you must have the
READ_ONCE/WRITE_ONCE calls for rcu_dereference/rcu_assign_pointer.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
