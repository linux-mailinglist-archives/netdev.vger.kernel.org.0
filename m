Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20A737561
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfFFNil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:38:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40800 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfFFNik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:38:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYsbB-0006rm-BN; Thu, 06 Jun 2019 21:38:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYsb2-0007Ot-8l; Thu, 06 Jun 2019 21:38:24 +0800
Date:   Thu, 6 Jun 2019 21:38:24 +0800
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
Message-ID: <20190606133824.aibysezb5qdo3x27@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
 <20190606060511.GA28207@linux.ibm.com>
 <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
 <20190606090619.GC28207@linux.ibm.com>
 <20190606092855.dfeuvyk5lbvm4zbf@gondor.apana.org.au>
 <20190606105817.GE28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606105817.GE28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 03:58:17AM -0700, Paul E. McKenney wrote:
>
> I cannot immediately think of a way that the compiler could get this
> wrong even in theory, but similar code sequences can be messed up.
> The reason for this is that in theory, the compiler could use the
> stored-to location as temporary storage, like this:
> 
> 	a = whatever;	// Compiler uses "a" as a temporary
> 	do_something();
> 	whatever = a;
> 	a = 1;		// Intended store

Well if the compiler is going to do this then surely it would
continue to do this even if you used WRITE_ONCE.  Remember a is
not volatile, only the access of a through WRITE_ONCE is volatile.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
