Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF123CF88D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhGTKUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237949AbhGTKRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B18F600D4;
        Tue, 20 Jul 2021 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626778648;
        bh=bdf2hozCtuEnUqdMt6xaxcdfnjHriJn7RXww2E+/On4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=baWqsIyGT5V+m7oB/FnRFSDTAAXKSNw++0r/WdXfyfYRvIFT/6dyYSNmTmjKCh36K
         /ddI3a9+S5yiNai4CFsMlrrcPLR0BVIml6H6tzPIrxDTYSiQCyX45dwrM6xGcjXWo0
         zZK4GnLqAVACej9JZ27JM0oyMJjwFOu9YwwEO4cV7Hn88/3E0IybTVfiX6leFUlZSo
         21L9a6H3CBo3JBWllXxZyLHTaaqPyTOP0OgndmFAjpmkdkamH2zmacjnAuMAsJRIgS
         hglf0VIX7+Ias8+nX1j2knvYpTHsBa96RAAcIFR0s1J0A8KIXDuoAWXyvMf7jEjEys
         6T1Gk3fetpLPA==
Date:   Tue, 20 Jul 2021 12:57:02 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        _govind@gmx.com, ley.foon.tan@intel.com, kabel@kernel.org,
        viresh.kumar@linaro.org, Tushar.Khandelwal@arm.com,
        luobin9@huawei.com
Subject: Re: [PATCH v4 01/14] genirq: Provide new interfaces for affinity
 hints
Message-ID: <20210720125702.28053dd6@cakuba>
In-Reply-To: <20210719180746.1008665-2-nitesh@redhat.com>
References: <20210719180746.1008665-1-nitesh@redhat.com>
        <20210719180746.1008665-2-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 14:07:33 -0400, Nitesh Narayan Lal wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The discussion about removing the side effect of irq_set_affinity_hint() of
> actually applying the cpumask (if not NULL) as affinity to the interrupt,
> unearthed a few unpleasantries:
> 
>   1) The modular perf drivers rely on the current behaviour for the very
>      wrong reasons.
> 
>   2) While none of the other drivers prevents user space from changing
>      the affinity, a cursorily inspection shows that there are at least
>      expectations in some drivers.
> 
> #1 needs to be cleaned up anyway, so that's not a problem
> 
> #2 might result in subtle regressions especially when irqbalanced (which
>    nowadays ignores the affinity hint) is disabled.
> 
> Provide new interfaces:
> 
>   irq_update_affinity_hint()  - Only sets the affinity hint pointer
>   irq_set_affinity_and_hint() - Set the pointer and apply the affinity to
>                                 the interrupt
> 
> Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
> document it to be phased out.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com

include/linux/interrupt.h:343: warning: Function parameter or member 'm' not described in 'irq_update_affinity_hint'
include/linux/interrupt.h:343: warning: Excess function parameter 'cpumask' description in 'irq_update_affinity_hint'
include/linux/interrupt.h:358: warning: Function parameter or member 'm' not described in 'irq_set_affinity_and_hint'
include/linux/interrupt.h:358: warning: Excess function parameter 'cpumask' description in 'irq_set_affinity_and_hint'
