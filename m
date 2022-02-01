Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3D4A64B4
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 20:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiBATMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 14:12:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239989AbiBATMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 14:12:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3AC061628
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 19:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD35BC340EB;
        Tue,  1 Feb 2022 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643742752;
        bh=pUWFJ0BWJcaCBjuF2MPEedAC1RRfF9STO3jpqTWpsRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l9BTnSnJR0Zkh8i66xwOlsTWco7QQX4+W9a/9ND10Nsy2Vs8FqosYSah5Ct8khSwt
         VPF9KQdJNBCSFKIQ05U87bJ0itL/B7NYfoDWtNapZvsiJkM+bSCdnmtEjvpudmylvt
         72IMKdOxqTJutCYUpSBQl70pMRPYlfzHO/nDF0t9Z7CnrozEVB98qrchzS/Ig0sauQ
         3RD7Z6g4oEPfafY+CpVh0XpYW9w3YGj8wxrN++ORUt94kAX2Je4M/YpRuzd1SrM9j1
         3Bkl+vdrWKSqiGtEOalRY6s/Lm5p8TWYv9R8NPvq3iRV1xj6cwuJiFnCZcuaH8WujY
         J5oZt1VOtTEOA==
Date:   Tue, 1 Feb 2022 11:12:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next] net: stmmac: optimize locking around PTP clock
 reads
Message-ID: <20220201111230.7141ee8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8da4d928-d7a1-9239-4c11-957b108b0184@oss.nxp.com>
References: <20220128170257.42094-1-yannick.vignon@oss.nxp.com>
        <20220131214200.168f3c60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8da4d928-d7a1-9239-4c11-957b108b0184@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Feb 2022 18:54:15 +0100 Yannick Vignon wrote:
> On 2/1/2022 6:42 AM, Jakub Kicinski wrote:
> > On Fri, 28 Jan 2022 18:02:57 +0100 Yannick Vignon wrote:  
> >> Reading the PTP clock is a simple operation requiring only 2 register
> >> reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
> >> counter-productive:
> >>   * if the task is preempted in-between the 2 reads, the return time value
> >> could become inconsistent,
> >>   * if the 2nd task preempting the 1st has a higher prio but needs to
> >> read time as well, it will require 2 context switches, which will pretty
> >> much always be more costly than just disabling preemption for the duration
> >> of the 2 reads.
> >>
> >> Improve the above situation by:
> >> * replacing the PTP spinlock by a rwlock, and using read_lock for PTP
> >> clock reads so simultaneous reads do not block each other,  
> > 
> > Are you sure the reads don't latch the other register? Otherwise this
> > code is buggy, it should check for wrap around. (e.g. during 1.99 ->
> > 2.00 transition driver can read .99, then 2, resulting in 2.99).
> 
> Well, we did observe the issue on another device (micro-controller, not 
> running Linux) using the same IP, and we were wondering how the Linux 
> driver could work and why we didn't observe the issue... I experimented 
> again today, and I did observe the problem, so I guess we didn't try 
> hard enough before. (this time I bypassed the kernel by doing tight read 
> loops from user-space after mmap'ing the registers).
> Going to add another commit to this patch-queue to fix that.

That's a fix tho, it needs to be a separate change containing a Fixes
tag and targeted at the netdev/net tree. We'd first apply that, and
then the optimizations on top of it into the net-next tree.
