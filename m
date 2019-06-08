Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A3F3A095
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 17:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfFHP4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 11:56:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33987 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727148AbfFHP4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 11:56:05 -0400
Received: (qmail 11733 invoked by uid 500); 8 Jun 2019 11:56:04 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 8 Jun 2019 11:56:04 -0400
Date:   Sat, 8 Jun 2019 11:56:04 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
cc:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
In-Reply-To: <20190608151943.GD28207@linux.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1906081153140.11124-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jun 2019, Paul E. McKenney wrote:

> On Thu, Jun 06, 2019 at 10:19:43AM -0400, Alan Stern wrote:
> > On Thu, 6 Jun 2019, Andrea Parri wrote:
> > 
> > > This seems a sensible change to me: looking forward to seeing a patch,
> > > on top of -rcu/dev, for further review and testing!
> > > 
> > > We could also add (to LKMM) the barrier() for rcu_read_{lock,unlock}()
> > > discussed in this thread (maybe once the RCU code and the informal doc
> > > will have settled in such direction).
> > 
> > Yes.  Also for SRCU.  That point had not escaped me.
> 
> And it does seem pretty settled.  There are quite a few examples where
> there are normal accesses at either end of the RCU read-side critical
> sections, for example, the one in the requirements diffs below.
> 
> For SRCU, srcu_read_lock() and srcu_read_unlock() have implied compiler
> barriers since 2006.  ;-)
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> diff --git a/Documentation/RCU/Design/Requirements/Requirements.html b/Documentation/RCU/Design/Requirements/Requirements.html
> index 5a9238a2883c..080b39cc1dbb 100644
> --- a/Documentation/RCU/Design/Requirements/Requirements.html
> +++ b/Documentation/RCU/Design/Requirements/Requirements.html
> @@ -2129,6 +2129,8 @@ Some of the relevant points of interest are as follows:
>  <li>	<a href="#Hotplug CPU">Hotplug CPU</a>.
>  <li>	<a href="#Scheduler and RCU">Scheduler and RCU</a>.
>  <li>	<a href="#Tracing and RCU">Tracing and RCU</a>.
> +<li>	<a href="#Accesses to User Mamory and RCU">
------------------------------------^
> +Accesses to User Mamory and RCU</a>.
---------------------^
>  <li>	<a href="#Energy Efficiency">Energy Efficiency</a>.
>  <li>	<a href="#Scheduling-Clock Interrupts and RCU">
>  	Scheduling-Clock Interrupts and RCU</a>.
> @@ -2521,6 +2523,75 @@ cannot be used.
>  The tracing folks both located the requirement and provided the
>  needed fix, so this surprise requirement was relatively painless.
>  
> +<h3><a name="Accesses to User Mamory and RCU">
----------------------------------^
> +Accesses to User Mamory and RCU</a></h3>
---------------------^

Are these issues especially notable for female programmers?  :-)

Alan

