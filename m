Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F2444635F
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 13:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhKEMcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 08:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhKEMcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 08:32:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3509C061714;
        Fri,  5 Nov 2021 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vXc9xImRQ/KDkkHk4g+JcSkINfTuLboOHaBtk+xiDzw=; b=FQRbEB7ny3G8U9AwvltZtZhLEX
        0kfmOUeihahFCmo/kDIQZ+QMPx5O/MJcNMxAaCbhywbvyJxJwJ92eFpbcS9fMx3XHEJzqwFyz+vq9
        OkT9cv8TPQDgMcGVbn8fAE7QWDvOGqAAFsgJpNs9bPWdAFWRypzygVDJmPrf0wdlHckkAd03qXLGl
        wczk53eRD3hxyxE7KngGJO4D3Wuw9KgO8UUEtHr7CBz3yxcm+Tn5IGjIBitxgynwhwm/hEdBnNW23
        ZDCHTvA3rgXZEQr7ChtMIu2O/CdRsqneWNRZwLgmgJ7YTu4YFCueeKM4iShoRpWBx/txq41hKR2Ig
        ukOxJ2sA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miyGL-006XrD-Av; Fri, 05 Nov 2021 12:24:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AE0EF3000D5;
        Fri,  5 Nov 2021 13:24:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8BC9420D9F97F; Fri,  5 Nov 2021 13:24:02 +0100 (CET)
Date:   Fri, 5 Nov 2021 13:24:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Barry Song <21cnbao@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, guodong.xu@linaro.org, yangyicong@huawei.com,
        shenyang39@huawei.com, tangchengchang@huawei.com,
        Barry Song <song.bao.hua@hisilicon.com>,
        Libo Chen <libo.chen@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC PATCH] sched&net: avoid over-pulling tasks due to network
 interrupts
Message-ID: <YYUiYrXMOQGap4+5@hirez.programming.kicks-ass.net>
References: <20211105105136.12137-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105105136.12137-1-21cnbao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 06:51:36PM +0800, Barry Song wrote:
> From: Barry Song <song.bao.hua@hisilicon.com>
> 
> In LPC2021, both Libo Chen and Tim Chen have reported the overpull
> of network interrupts[1]. For example, while running one database,
> ethernet is located in numa0, numa1 might be almost idle due to
> interrupts are pulling tasks to numa0 because of wake_up affine.
> I have seen the same problem. One way to solve this problem is
> moving to a normal wakeup in network rather than using a sync
> wakeup which will be more aggressively pulling tasks in scheduler
> core.
> 
> On kunpeng920 with 4numa, ethernet is located at numa0, storage
> disk is located at numa2. While using sysbench to connect this
> mysql machine, I am seeing numa1 is idle though numa0,2 and 3
> are quite busy.
> 

> I am not saying this patch is exactly the right approach, But I'd
> like to use this RFC to connect the people of net and scheduler,
> and start the discussion in this wider range.

Well the normal way would be to use multi-queue crud and/or receive
packet steering to get the interrupt/wakeup back to the cpu that data
came from.
