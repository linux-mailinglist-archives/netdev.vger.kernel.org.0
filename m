Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947EE3B0499
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhFVMff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:35:35 -0400
Received: from foss.arm.com ([217.140.110.172]:48474 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231404AbhFVMfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:35:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DDE8ED1;
        Tue, 22 Jun 2021 05:33:18 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.10.229])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78E0C3F694;
        Tue, 22 Jun 2021 05:33:15 -0700 (PDT)
Date:   Tue, 22 Jun 2021 13:32:21 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, catalin.marinas@arm.com, maz@kernel.org,
        dbrazdil@google.com, qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com, peterz@infradead.org
Subject: Re: [PATCH net-next 1/3] arm64: barrier: add DGH macros to control
 memory accesses merging
Message-ID: <20210622123221.GA71782@C02TD0UTHF1T.local>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-2-git-send-email-huangguangbin2@huawei.com>
 <20210622121630.GC30757@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622121630.GC30757@willie-the-truck>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 01:16:31PM +0100, Will Deacon wrote:
> On Tue, Jun 22, 2021 at 07:11:09PM +0800, Guangbin Huang wrote:
> > From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> > 
> > DGH prohibits merging memory accesses with Normal-NC or Device-GRE
> > attributes before the hint instruction with any memory accesses
> > appearing after the hint instruction. Provide macros to expose it to the
> > arch code.
> 
> Hmm.
> 
> The architecture states:
> 
>   | DGH is a hint instruction. A DGH instruction is not expected to be
>   | performance optimal to merge memory accesses with Normal Non-cacheable
>   | or Device-GRE attributes appearing in program order before the hint
>   | instruction with any memory accesses appearing after the hint instruction
>   | into a single memory transaction on an interconnect.
> 
> which doesn't make a whole lot of sense to me, in all honesty.

I think there are some missing words, and this was supposed to say
something like:

| DGH is a hint instruction. A DGH instruction *indicates that it* is
| not expected to be performance optimal to merge memory accesses with
| Normal Non-cacheable or Device-GRE attributes appearing in program
| order before the hint instruction with any memory accesses appearing
| after the hint instruction into a single memory transaction on an
| interconnect.

... i.e. it's a hint to the CPU to avoid merging accesses which are
either side of the DGH, so that the prior accesses don't get
indefinitely delayed waiting to be merged.

I'll try to get the documentation fixed, since as-is the wording does
not make sense.

Thanks,
Mark.
