Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10191332818
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhCIOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhCIOFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 09:05:16 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDB3C06174A;
        Tue,  9 Mar 2021 06:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GcUxj6HFoWjzVTh/rDGRj8aF2cC9l7zvlZxwy+rkPI8=; b=WKOLA8/oY3iIlag8Wx/BiQQ9UT
        ZruJNnfDEZMEZlbHheQzFjCycn70TM2oUT68KgBQ/oxdjk5uO6Z5r4eHEVSyFbvJTCceGYgDth5sk
        Vl251UGOZrvZr7A7GV/nmQLUywZiRrbhkA8qlDFZnqEHNL26VX2XIoXXCFxBrj+2DvEQSxuMWfLdL
        +CIInWw8wLp9puRevh/gHTL42vgb6KT1OjTQOYxsbh8lRTothq+WsSQpmKRhx/y0weQQMcyJG4BDv
        gQl+L7vLS6m3qsVD65+FHddewi5To/GKuAJAeebO0Cj+Et8CjpgeSygrChST+/sMG8t9Y9kPsXNHu
        BrmOgZEQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJcyi-004nvb-EB; Tue, 09 Mar 2021 14:04:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 047E9304BAE;
        Tue,  9 Mar 2021 15:04:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E2FFC22B8D9BA; Tue,  9 Mar 2021 15:04:50 +0100 (CET)
Date:   Tue, 9 Mar 2021 15:04:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [patch 00/14] tasklets: Replace the spin wait loops and make it
 RT safe
Message-ID: <YEeAghrP8cOk1zL9@hirez.programming.kicks-ass.net>
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309084203.995862150@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 09:42:03AM +0100, Thomas Gleixner wrote:
> This is a follow up to the review comments of the series which makes
> softirq processing PREEMPT_RT safe:
> 
>  https://lore.kernel.org/r/20201207114743.GK3040@hirez.programming.kicks-ass.net
> 
> Peter suggested to replace the spin waiting in tasklet_disable() and
> tasklet_kill() with wait_event(). This also gets rid of the ill defined
> sched_yield() in tasklet_kill().
> 
> Analyzing all usage sites of tasklet_disable() and tasklet_unlock_wait() we
> found that most of them are safe to be converted to a sleeping wait.
> 
> Only a few instances invoke tasklet_disable() from atomic context. A few
> bugs which have been found in course of this analysis have been already
> addressed seperately.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
