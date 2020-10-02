Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D03280DE5
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJBHKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBHKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:10:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF3C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 00:10:30 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so629820pfb.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 00:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hh+UjpMuoEkMCzof4yqOEg+ce/h7177eCjrN8vxLBuI=;
        b=JuCwa6DdTOUISQq56UZJ0wNyILQIpIeFri+jlB6nwH+hNraNTRPLC11IFUWRy31M59
         InZmjAqwP/27AXV3iFhqwFOrGEguSj8tv5lVf14A0gV3sk8cvBdwJoH/mU7ap7A1K7o5
         1lmZIgsBUD4Ok9eN7Lurcdcfh35UFbIl2TD0c8lLZk4KyczBE0riLauj54ZKk7ERQ9TT
         YLgYhyn/jyR4xaW0s/YhTmnM3OGFtn8PNt6GBlpQEGLL0prokKCOSZrXDumTPoD13VmY
         sp2KDpzvr5SFTPw2VRWd/hiHEbOOIgc7DKuT/qqYRy5Em9i97qJZXtNcTWvPIA1i+3tT
         kmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Hh+UjpMuoEkMCzof4yqOEg+ce/h7177eCjrN8vxLBuI=;
        b=M5fhMcNKI2pefrGvKlVC1yOa8SrZcCZwugpTzNQhCzg70VRShylgCjANQib3WmMvlV
         xzQtE3Ny4EGoYb5rUM0nbXfim+lS7rdoJOoQcVqz+meJd38/xS+AFvP10X5nuazSfPwe
         GnnssBFiKdRzvrVsNqidiDIFpPuFFBKMu5xfSGnMMRnLT+ia4lhEmk8pA/j3P+kYWYZE
         HPZ1MsyQBvw/MCgQXiiaYGMJC3/+8GreryL47Aojj5zci/xrKAnA5oQ/qahaimnX+fL/
         qRKu3ojcqTZO0ht/uCmECBtKuQTHHfbJLIo0purNSa230vD7Ab8iqWmnTLNiLBXdUgqk
         hPBA==
X-Gm-Message-State: AOAM5330gANICxkOsTZfUz5ULTmImf/SgmgqqjyTbn4pdHccKX8Lhr8/
        M9ENk6LrH76kt6zDqu43ajKx
X-Google-Smtp-Source: ABdhPJzzRX5cbWPcJxmivjIoCoL7Nl5Ez9dPUlfhLVwTFLNl1pbWqlSzVsl6uWdK8l74JNGxk26MVg==
X-Received: by 2002:a63:2209:: with SMTP id i9mr822888pgi.130.1601622629395;
        Fri, 02 Oct 2020 00:10:29 -0700 (PDT)
Received: from linux ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id j26sm725609pfa.160.2020.10.02.00.10.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Oct 2020 00:10:28 -0700 (PDT)
Date:   Fri, 2 Oct 2020 12:40:22 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH] net: qrtr: ns: Protect radix_tree_deref_slot() using rcu
 read locks
Message-ID: <20201002071022.GA5379@linux>
References: <20200926165625.11660-1-manivannan.sadhasivam@linaro.org>
 <20200928.155603.134441435973191115.davem@davemloft.net>
 <CAD=FV=VZ8QEP7MU8M9G5odLs+A0RAHfKR5bUJh2n6my7JRtaVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=VZ8QEP7MU8M9G5odLs+A0RAHfKR5bUJh2n6my7JRtaVg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

On Thu, Oct 01, 2020 at 03:53:12PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Sep 28, 2020 at 4:15 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > Date: Sat, 26 Sep 2020 22:26:25 +0530
> >
> > > The rcu read locks are needed to avoid potential race condition while
> > > dereferencing radix tree from multiple threads. The issue was identified
> > > by syzbot. Below is the crash report:
> >  ...
> > > Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> > > Reported-and-tested-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> >
> > Applied and queued up for -stable, thank you.
> 
> The cure is worse than the disease.  I tested by picking back to a
> 5.4-based kernel and got this crash.  I expect the crash would also be
> present on mainline:
>

Thanks for the report! I intended to fix the issue reported by syzbot but
failed to notice the lock_sock() in qrtr_sendmsg() function. This function is
not supposed to be called while holding a lock as it might sleep.

I'll submit a patch to fix this issue asap.

Thanks,
Mani
 
>  BUG: sleeping function called from invalid context at net/core/sock.c:3000
>  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 7, name: kworker/u16:0
>  3 locks held by kworker/u16:0/7:
>   #0: ffffff81b65a7b28 ((wq_completion)qrtr_ns_handler){+.+.}, at:
> process_one_work+0x1bc/0x614
>   #1: ffffff81b6edfd58 ((work_completion)(&qrtr_ns.work)){+.+.}, at:
> process_one_work+0x1e4/0x614
>   #2: ffffffd01144c328 (rcu_read_lock){....}, at: rcu_lock_acquire+0x8/0x38
>  CPU: 6 PID: 7 Comm: kworker/u16:0 Not tainted 5.4.68 #33
>  Hardware name: Google Lazor (rev0) with LTE (DT)
>  Workqueue: qrtr_ns_handler qrtr_ns_worker
>  Call trace:
>   dump_backtrace+0x0/0x158
>   show_stack+0x20/0x2c
>   dump_stack+0xdc/0x180
>   ___might_sleep+0x1c0/0x1d0
>   __might_sleep+0x50/0x88
>   lock_sock_nested+0x34/0x94
>   qrtr_sendmsg+0x7c/0x260
>   sock_sendmsg+0x44/0x5c
>   kernel_sendmsg+0x50/0x64
>   lookup_notify+0xa8/0x118
>   qrtr_ns_worker+0x8d8/0x1050
>   process_one_work+0x338/0x614
>   worker_thread+0x29c/0x46c
>   kthread+0x150/0x160
>   ret_from_fork+0x10/0x18
> 
> I'll give the stack crawl from kgdb too since inlining makes things
> less obvious with the above...
> 
> (gdb) bt
> #0  arch_kgdb_breakpoint ()
>     at .../arch/arm64/include/asm/kgdb.h:21
> #1  kgdb_breakpoint ()
>     at .../kernel/debug/debug_core.c:1183
> #2  0xffffffd010131058 in ___might_sleep (
>     file=file@entry=0xffffffd010efec42 "net/core/sock.c",
>     line=line@entry=3000, preempt_offset=preempt_offset@entry=0)
>     at .../kernel/sched/core.c:7994
> #3  0xffffffd010130ee0 in __might_sleep (
>     file=0xffffffd010efec42 "net/core/sock.c", line=3000,
>     preempt_offset=0)
>     at .../kernel/sched/core.c:7965
> #4  0xffffffd01094d1c8 in lock_sock_nested (
>     sk=sk@entry=0xffffff8147e457c0, subclass=0)
>     at .../net/core/sock.c:3000
> #5  0xffffffd010b26028 in lock_sock (sk=0xffffff8147e457c0)
>     at .../include/net/sock.h:1536
> #6  qrtr_sendmsg (sock=0xffffff8148c4b240, msg=0xffffff81422afab8,
>     len=20)
>     at .../net/qrtr/qrtr.c:891
> #7  0xffffffd01093f8f4 in sock_sendmsg_nosec (
>     sock=0xffffff8148c4b240, msg=0xffffff81422afab8)
>     at .../net/socket.c:638
> #8  sock_sendmsg (sock=sock@entry=0xffffff8148c4b240,
>     msg=msg@entry=0xffffff81422afab8)
>     at .../net/socket.c:658
> #9  0xffffffd01093f95c in kernel_sendmsg (sock=0x1,
>     msg=msg@entry=0xffffff81422afab8, vec=<optimized out>,
>     vec@entry=0xffffff81422afaa8, num=<optimized out>, num@entry=1,
>     size=<optimized out>, size@entry=20)
>     at .../net/socket.c:678
> #10 0xffffffd010b28be0 in service_announce_new (
>     dest=dest@entry=0xffffff81422afc20,
>     srv=srv@entry=0xffffff81370f6380)
>     at .../net/qrtr/ns.c:127
> #11 0xffffffd010b279f4 in announce_servers (sq=0xffffff81422afc20)
>     at .../net/qrtr/ns.c:207
> #12 ctrl_cmd_hello (sq=0xffffff81422afc20)
>     at .../net/qrtr/ns.c:328
> #13 qrtr_ns_worker (work=<optimized out>)
>     at .../net/qrtr/ns.c:661
> #14 0xffffffd010119a94 in process_one_work (
>     worker=worker@entry=0xffffff8142267900,
>     work=0xffffffd0128ddaf8 <qrtr_ns+48>)
>     at .../kernel/workqueue.c:2272
> #15 0xffffffd01011a16c in worker_thread (
>     __worker=__worker@entry=0xffffff8142267900)
>     at .../kernel/workqueue.c:2418
> #16 0xffffffd01011fb78 in kthread (_create=0xffffff8142269200)
>     at .../kernel/kthread.c:268
> #17 0xffffffd01008645c in ret_from_fork ()
>     at .../arch/arm64/kernel/entry.S:1169
> 
> 
> -Doug
