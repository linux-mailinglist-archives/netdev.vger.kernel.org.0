Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20D9722F6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfGWXZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfGWXZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 19:25:05 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1AB2253D;
        Tue, 23 Jul 2019 23:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563924304;
        bh=FGNG2bsI180IX9yfVVejxvvKc6LPkLx7d3W+nSaEtYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MmKZKEj9rYYuSx5IhPuVqW3yDLIXTJo+2Pjo8kn2rXJQRI0BajWjrOke5jXiV/Myq
         KkhnD1MWfZQbxAaTDQvQWLNNBmhF1dZIuAcp4Ha09rkCKnFHgdoOJB121myzkHrs7P
         Yd0vHiCvZb0zZO+CZbS9JAzOgO2NtIXCSPxE+R/o=
Date:   Tue, 23 Jul 2019 16:25:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>,
        catalin.marinas@arm.com, davem@davemloft.net, dvyukov@google.com,
        jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, neilb@suse.de, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, ross.zwisler@linux.intel.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, willy@linux.intel.com
Subject: Re: memory leak in rds_send_probe
Message-ID: <20190723232500.GA71043@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
        syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>,
        catalin.marinas@arm.com, davem@davemloft.net, dvyukov@google.com,
        jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, neilb@suse.de, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, ross.zwisler@linux.intel.com,
        santosh.shilimkar@oracle.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, willy@linux.intel.com
References: <000000000000ad1dfe058e5b89ab@google.com>
 <00000000000034c84a058e608d45@google.com>
 <20190723152336.29ed51551d8c9600bb316b52@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723152336.29ed51551d8c9600bb316b52@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 03:23:36PM -0700, Andrew Morton wrote:
> On Tue, 23 Jul 2019 15:17:00 -0700 syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com> wrote:
> 
> > syzbot has bisected this bug to:
> > 
> > commit af49a63e101eb62376cc1d6bd25b97eb8c691d54
> > Author: Matthew Wilcox <willy@linux.intel.com>
> > Date:   Sat May 21 00:03:33 2016 +0000
> > 
> >      radix-tree: change naming conventions in radix_tree_shrink
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176528c8600000
> > start commit:   c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=14e528c8600000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10e528c8600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8de7d700ea5ac607
> > dashboard link: https://syzkaller.appspot.com/bug?extid=5134cdf021c4ed5aaa5f
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145df0c8600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170001f4600000
> > 
> > Reported-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
> > Fixes: af49a63e101e ("radix-tree: change naming conventions in  
> > radix_tree_shrink")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> That's rather hard to believe.  af49a63e101eb6237 simply renames a
> couple of local variables.
> 

It's been known for months (basically ever since bisection was added) that about
50% of syzbot bisection results are obviously incorrect, often a commit selected
at random.  Unfortunately, the people actually funded to work on syzbot
apparently don't consider fixing this to be high priority issue, so we have to
live with it for now.  Or until someone volunteers to fix it themselves; source
is at https://github.com/google/syzkaller.

So for now, please don't waste much time on bisection results that look wonky.

But please do pay attention to any bisection results in reminders I've been
sending like "Reminder: 10 open syzbot bugs in foo subsystem", since I've
manually reviewed those to exclude the obviously wrong results...

- Eric
