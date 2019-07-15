Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDFE68A8A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbfGON3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:29:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbfGON3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 09:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r9X1nghjzop7IMmkkwDPTymZ4Xv+LpVt5mTtmfKekm0=; b=k1xsuzrcvlM122V0VW+E05XLJ
        Hm/L5W6LUxvgcgX6TcmXyGijEZNpEM/3PgekuPyDDle5gwFPy//job23ju2uNdle250U9ifNCoO1B
        p7XI2084yU9OgvD7hpefvV2oiiRp4U5P4YhWaZzZ3Tr6RhLKlT5FnorNsfHw+4UxKWHqSlpSJZ+mv
        QHNd8mKPcXCjbOZ+0MPWwLZZcCQohwYm7tIYGyLqF6G2dSuu6WbPUfmxRRRw75Fsfq+XiRn5Iz/i+
        r+FoSfbmuOYq1TOAcuEe4d6WvrTfQHIFWNCEG7o4TKLh4JJqL9RqDzaGBtrw21BPU2UgzIs15i7Pr
        97Adxeyiw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hn12X-0008Q5-3p; Mon, 15 Jul 2019 13:29:13 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 80E272013A7F2; Mon, 15 Jul 2019 15:29:11 +0200 (CEST)
Date:   Mon, 15 Jul 2019 15:29:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>, Theodore Ts'o <tytso@mit.edu>,
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
Message-ID: <20190715132911.GG3419@hirez.programming.kicks-ass.net>
References: <20190705151658.GP26519@linux.ibm.com>
 <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
 <20190705191055.GT26519@linux.ibm.com>
 <20190706042801.GD11665@mit.edu>
 <20190706061631.GV26519@linux.ibm.com>
 <20190706150226.GG11665@mit.edu>
 <20190706180311.GW26519@linux.ibm.com>
 <20190707011655.GA22081@linux.ibm.com>
 <CACT4Y+asYe-uH9OV5R0Nkb-JKP4erYUZ68S9gYNnGg6v+fD20w@mail.gmail.com>
 <20190714184915.GK26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714184915.GK26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 11:49:15AM -0700, Paul E. McKenney wrote:
> On Sun, Jul 14, 2019 at 05:48:00PM +0300, Dmitry Vyukov wrote:
> > But short term I don't see any other solution than stop testing
> > sched_setattr because it does not check arguments enough to prevent
> > system misbehavior. Which is a pity because syzkaller has found some
> > bad misconfigurations that were oversight on checking side.
> > Any other suggestions?
> 
> Keep the times down to a few seconds?  Of course, that might also
> fail to find interesting bugs.

Right, if syzcaller can put a limit on the period/deadline parameters
(and make sure to not write "-1" to
/proc/sys/kernel/sched_rt_runtime_us) then per the in-kernel
access-control should not allow these things to happen.
