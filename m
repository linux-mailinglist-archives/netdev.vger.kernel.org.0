Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA04474E2
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 19:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhKGSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhKGSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:11:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0D0C061570;
        Sun,  7 Nov 2021 10:08:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id f8so53639234edy.4;
        Sun, 07 Nov 2021 10:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4kIZsRDm8rxhr02Tgc4l3Zw6ev1GuI6KgvJet+nCQSI=;
        b=PN0kglOFSxYGrMihnffAFbvbsZmvquumWw4BXLnxtjDMQ/QPChvVn8E4R6JdhtZ2pb
         L3nRyC99Gb0yEzIaQ1PU6UC7iy/gSsb9PYIh5fBfK/exd17nX7+mHdp/WPVqZj25fMPB
         SQOMFjU+xzcRCaxAfUFrPSgUhWhiZkT5dzFDARG4AHojKWEU4BGYZ1sLuLv81CcNBdtj
         8u694lQy/O0uDqmRYmwPDA21TbFuMaO3JafSCM4IyKWvXu+vJvW1H2DWCZEEzNbiwPH8
         1W7VrVu25SNm1rXDqhRD2tYJ84xOvBfT0N+42tbHOW+ac2FrKfrrPiCm10a1n2F8hvUe
         LaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4kIZsRDm8rxhr02Tgc4l3Zw6ev1GuI6KgvJet+nCQSI=;
        b=ZBeX0LV2PNdh6XYZP1P4fKAMQF3UQBrxRdXjza4WWTL/awGnE9Vti0K9cWMeI5R1z+
         9/diIKPucIsCO+F2u4P/iy0A3C4Q9CHitj1LHCfUEWI886YzKATli/Eo3i/1RnFYzgiK
         cgjanXBO9UYk1N70iRqkZ1sX0qaXbWvSvcZEkh5YLcnPqOxedT+vYkt4EjenU9fE/Yh3
         /CiS7YpR98npvib4uxUhlUzZGTtOw+L6zKd1PbsbP0Xbj4ELpWANNre1btElWhSR+XVz
         nb/iMrjS/+UjStJt/75Z4v0wo/fzdDC5adOMsTR/pOvVlFQMyeFxGFFi0XV/lyexctfc
         mqeg==
X-Gm-Message-State: AOAM5336C8Q9DJe6I9GtbM8KJVNafYkMkdq6ZcGmce8zLh/h+pxGMPjg
        Gaf5Wd/KI8E1vA4ezOqqLJC2ATTp5zjjSRWw28c=
X-Google-Smtp-Source: ABdhPJxf+utXpAg3ToWxjhhW1f7ib4RQkvxSYvdBHbh3Sls/aOdw76nY1M7JKKgphAC8leiVhfiuiBoOLCpDdvAELK4=
X-Received: by 2002:a17:906:d0c3:: with SMTP id bq3mr88882067ejb.277.1636308502800;
 Sun, 07 Nov 2021 10:08:22 -0800 (PST)
MIME-Version: 1.0
References: <20211105105136.12137-1-21cnbao@gmail.com> <YYUiYrXMOQGap4+5@hirez.programming.kicks-ass.net>
In-Reply-To: <YYUiYrXMOQGap4+5@hirez.programming.kicks-ass.net>
From:   Barry Song <21cnbao@gmail.com>
Date:   Mon, 8 Nov 2021 07:08:09 +1300
Message-ID: <CAGsJ_4wofduvT2BJipJppJza_ZyL2pU3Ni-B3R+A3_Zqv2v_4g@mail.gmail.com>
Subject: Re: [RFC PATCH] sched&net: avoid over-pulling tasks due to network interrupts
To:     Peter Zijlstra <peterz@infradead.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 6, 2021 at 1:25 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Nov 05, 2021 at 06:51:36PM +0800, Barry Song wrote:
> > From: Barry Song <song.bao.hua@hisilicon.com>
> >
> > In LPC2021, both Libo Chen and Tim Chen have reported the overpull
> > of network interrupts[1]. For example, while running one database,
> > ethernet is located in numa0, numa1 might be almost idle due to
> > interrupts are pulling tasks to numa0 because of wake_up affine.
> > I have seen the same problem. One way to solve this problem is
> > moving to a normal wakeup in network rather than using a sync
> > wakeup which will be more aggressively pulling tasks in scheduler
> > core.
> >
> > On kunpeng920 with 4numa, ethernet is located at numa0, storage
> > disk is located at numa2. While using sysbench to connect this
> > mysql machine, I am seeing numa1 is idle though numa0,2 and 3
> > are quite busy.
> >
>
> > I am not saying this patch is exactly the right approach, But I'd
> > like to use this RFC to connect the people of net and scheduler,
> > and start the discussion in this wider range.
>
> Well the normal way would be to use multi-queue crud and/or receive
> packet steering to get the interrupt/wakeup back to the cpu that data
> came from.

The test case has been a multi-queue ethernet and irqs are balanced
to NUMA0 by irqbalanced or pinned to NUMA0 where the card is located
by the script like:
#!/bin/bash
irq_list=(`cat /proc/interrupts | grep network_name| awk -F: '{print $1}'`)
cpunum=0
for irq in ${irq_list[@]}
do
echo $cpunum > /proc/irq/$irq/smp_affinity_list
echo `cat /proc/irq/$irq/smp_affinity_list`
(( cpunum+=1 ))
done

I have heard some people are working around this issue  by pinning
multi-queue IRQs to multiple NUMAs which can spread interrupts and
avoid over-pulling tasks to one NUMA only, but lose ethernet locality?
Hi, @Tim, it seems in LPC2021 you mentioned you are using this
solution?

And some other people are pinning ethernet IRQs to a couple of
CPUs within the NUMA ethernet belongs to, and then isolate these
CPUs from tasks and use those CPUs for interrupts only. This can
avoid wake-up pulling at all.

I think we need some generic way to resolve this problem. Hi,
@Libo , what is your solution to work around this issue?

Thanks
Barry
