Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B4468B50
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfGONkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:40:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46682 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731357AbfGONkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ytg6+i9e5dgoe6MR6Oj4fa2L/XJB0F+/mAmTtnaWIkM=; b=wdPz0nFWIu3gfQDcxJ1flt2cp
        Wn9EY0AsoO+Mhr4gfSyrIsO5aCd1zAktfoLbKwIt045y9e6UverXIHkQNTAO6BKlYhmnih1gtCyC+
        JLVSiuIAIP4GReedDVtgun+I0UIkZqGqbfJ7wUWr4rz9eDsnSnZF2RQan8SaxAl4EZmpHjgyZTlw+
        rRYPNYw+KQQ4GiCt7jsNmfdYdD/TJwd42xSNLp+OQC/dk52V9L/lZG/73A3YrmPQ9YZRhcPE9gy/H
        V3+HvSstjFGLjre3GSqY5FbQtbr0IL5Ff6oIzob/U0oToHK+59TbkzWQ9MZ4mwbBapu5SC4sl2/o2
        We/xY4X3w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hn1Cg-0002wX-5K; Mon, 15 Jul 2019 13:39:42 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DEB4C2013A7F3; Mon, 15 Jul 2019 15:39:38 +0200 (CEST)
Date:   Mon, 15 Jul 2019 15:39:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
Message-ID: <20190715133938.GH3419@hirez.programming.kicks-ass.net>
References: <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714190522.GA24049@mit.edu>
 <20190714192951.GM26519@linux.ibm.com>
 <20190715031027.GA3336@linux.ibm.com>
 <20190715130101.GA5527@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715130101.GA5527@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 06:01:01AM -0700, Paul E. McKenney wrote:
> Title: Making SCHED_DEADLINE safe for kernel kthreads
> 
> Abstract:
> 
> Dmitry Vyukov's testing work identified some (ab)uses of sched_setattr()
> that can result in SCHED_DEADLINE tasks starving RCU's kthreads for
> extended time periods, not millisecond, not seconds, not minutes, not even
> hours, but days. Given that RCU CPU stall warnings are issued whenever
> an RCU grace period fails to complete within a few tens of seconds,
> the system did not suffer silently. Although one could argue that people
> should avoid abusing sched_setattr(), people are human and humans make
> mistakes. Responding to simple mistakes with RCU CPU stall warnings is
> all well and good, but a more severe case could OOM the system, which
> is a particularly unhelpful error message.
> 
> It would be better if the system were capable of operating reasonably
> despite such abuse. Several approaches have been suggested.
> 
> First, sched_setattr() could recognize parameter settings that put
> kthreads at risk and refuse to honor those settings. This approach
> of course requires that we identify precisely what combinations of
> sched_setattr() parameters settings are risky, especially given that there
> are likely to be parameter settings that are both risky and highly useful.

So we (the people poking at the DEADLINE code) are all aware of this,
and on the TODO list for making DEADLINE available for !priv users is
the item:

  - put limits on deadline/period

And note that that is both an upper and lower limit. The upper limit
you've just found why we need it, the lower limit is required because
you can DoS the hardware by causing deadlines/periods that are equal (or
shorter) than the time it takes to program the hardware.

There might have even been some patches that do some of this, but I've
held off because we have bigger problems and they would've established
an ABI while it wasn't clear it was sufficient or the right form.


