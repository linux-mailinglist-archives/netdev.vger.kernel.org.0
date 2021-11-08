Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E780C447CC7
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 10:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhKHJbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 04:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhKHJbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 04:31:11 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5173FC061570;
        Mon,  8 Nov 2021 01:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yvOuI8LHQCnzD0XXjEMcYafm6IRvktnS6XgGtbq1JxQ=; b=RVVkSYrnWnWvMTbCtDk+8k1/fS
        JyqSipGwP6DN1MYSc1xg2BIYd0UpmsGUEmgBUTeJAUFdD1P9MD2EikRsXmSU/nL8eMigjlihITgXZ
        lsRpRQuQn0tCDuVSjK/YwIdONWVzBfyiS79hW2/dxJFRSPt3Bvs4EGMltG3EZchOn6nFvdkLXB+jU
        DEuBBL9EQtL+kDGDTmI9OHvpqzJL4DI07zjULDn7wI3j2u3H+nBEW+8qsYbD4MF5NLwP3pvXFpK+C
        F5OWVJKE1k3gw1JKKlDDYnDhZs/Zz1cQEqDprDFzSPcbVVcD1vbl4kHwVDO2u1jpjClR+9wSdFQuP
        iHwaIkkw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mk0wE-00ErJv-FE; Mon, 08 Nov 2021 09:27:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id ADA673000A3;
        Mon,  8 Nov 2021 10:27:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 66E4B2CD0FE89; Mon,  8 Nov 2021 10:27:33 +0100 (CET)
Date:   Mon, 8 Nov 2021 10:27:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Barry Song <21cnbao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        fw@strlen.de, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        Guodong Xu <guodong.xu@linaro.org>,
        yangyicong <yangyicong@huawei.com>, shenyang39@huawei.com,
        tangchengchang@huawei.com, Barry Song <song.bao.hua@hisilicon.com>,
        Libo Chen <libo.chen@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC PATCH] sched&net: avoid over-pulling tasks due to network
 interrupts
Message-ID: <YYjthV9W09H5Err8@hirez.programming.kicks-ass.net>
References: <20211105105136.12137-1-21cnbao@gmail.com>
 <YYUiYrXMOQGap4+5@hirez.programming.kicks-ass.net>
 <CAGsJ_4wofduvT2BJipJppJza_ZyL2pU3Ni-B3R+A3_Zqv2v_4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wofduvT2BJipJppJza_ZyL2pU3Ni-B3R+A3_Zqv2v_4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:08:09AM +1300, Barry Song wrote:
> On Sat, Nov 6, 2021 at 1:25 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Nov 05, 2021 at 06:51:36PM +0800, Barry Song wrote:
> > > From: Barry Song <song.bao.hua@hisilicon.com>
> > >
> > > In LPC2021, both Libo Chen and Tim Chen have reported the overpull
> > > of network interrupts[1]. For example, while running one database,
> > > ethernet is located in numa0, numa1 might be almost idle due to
> > > interrupts are pulling tasks to numa0 because of wake_up affine.
> > > I have seen the same problem. One way to solve this problem is
> > > moving to a normal wakeup in network rather than using a sync
> > > wakeup which will be more aggressively pulling tasks in scheduler
> > > core.
> > >
> > > On kunpeng920 with 4numa, ethernet is located at numa0, storage
> > > disk is located at numa2. While using sysbench to connect this
> > > mysql machine, I am seeing numa1 is idle though numa0,2 and 3
> > > are quite busy.
> > >
> >
> > > I am not saying this patch is exactly the right approach, But I'd
> > > like to use this RFC to connect the people of net and scheduler,
> > > and start the discussion in this wider range.
> >
> > Well the normal way would be to use multi-queue crud and/or receive
> > packet steering to get the interrupt/wakeup back to the cpu that data
> > came from.
> 
> The test case has been a multi-queue ethernet and irqs are balanced
> to NUMA0 by irqbalanced or pinned to NUMA0 where the card is located
> by the script like:
> #!/bin/bash
> irq_list=(`cat /proc/interrupts | grep network_name| awk -F: '{print $1}'`)
> cpunum=0
> for irq in ${irq_list[@]}
> do
> echo $cpunum > /proc/irq/$irq/smp_affinity_list
> echo `cat /proc/irq/$irq/smp_affinity_list`
> (( cpunum+=1 ))
> done
> 
> I have heard some people are working around this issue  by pinning
> multi-queue IRQs to multiple NUMAs which can spread interrupts and
> avoid over-pulling tasks to one NUMA only, but lose ethernet locality?

So you're doing explicitly the wrong thing with your script above and
then complain the scheduler follows that and destroys your data
locality?

The network folks made RPS/RFS specifically to spread the processing of
the packets back to the CPUs/Nodes the TX happened on to increase data
locality. Why not use that?

