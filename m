Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492AC29676C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 00:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372992AbgJVWja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 18:39:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50106 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372971AbgJVWj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 18:39:29 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603406366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SrnDQ4pBHMGHEMhYZ0N79a51WfK6iJHdrjE3kDgVDiI=;
        b=iy4bIK/ZpYUnzYJlhG1X4xFIb08cTGDBQ+HlR6v5IxdhK7umkvHwCM+mPE40K9vypjbHfE
        io4BMQy2A5SBBcVjsI76MvcSWRoHDgIWZpVprt99G0b31BAZFCe/eZc03927hcTrVhy2zj
        ka0HpBxBsB3+1Ctwmx4ULj3/xBVV3wVakTbKJdu8z7y12AMtI30/PTVK71CE6RIrfI9zgM
        yoK17mBSmBj6XQHXYYO9QBqtuHVlXg5CRwNXh/MbYPuEbZn2oMPyK5ihBSBLpGARixsoBQ
        04jNkCIjrFrEr9bGMYI6+7ZmQ7G9zSkUr3ghrmkeXOxZ0L34xwJz3qETxpIQhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603406366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SrnDQ4pBHMGHEMhYZ0N79a51WfK6iJHdrjE3kDgVDiI=;
        b=4oNDdQ0Jz1ulYn3D+b0WK6DPec8o3QKBDso61BYhMIyNImFm1hDcbSdyP0ulQOGdcTp7p7
        1WzNdwrla364OSDw==
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <20201022122849.GA148426@fuller.cnet>
References: <20200928183529.471328-1-nitesh@redhat.com> <20200928183529.471328-5-nitesh@redhat.com> <87v9f57zjf.fsf@nanos.tec.linutronix.de> <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com> <87lfg093fo.fsf@nanos.tec.linutronix.de> <877drj72cz.fsf@nanos.tec.linutronix.de> <20201022122849.GA148426@fuller.cnet>
Date:   Fri, 23 Oct 2020 00:39:25 +0200
Message-ID: <87pn596g2q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22 2020 at 09:28, Marcelo Tosatti wrote:
> On Wed, Oct 21, 2020 at 10:25:48PM +0200, Thomas Gleixner wrote:
>> The right answer to this is to utilize managed interrupts and have
>> according logic in your network driver to handle CPU hotplug. When a CPU
>> goes down, then the queue which is associated to that CPU is quiesced
>> and the interrupt core shuts down the relevant interrupt instead of
>> moving it to an online CPU (which causes the whole vector exhaustion
>> problem on x86). When the CPU comes online again, then the interrupt is
>> reenabled in the core and the driver reactivates the queue.
>
> Aha... But it would be necessary to do that from userspace (for runtime
> isolate/unisolate).

For anything which uses managed interrupts this is a non-problem and
userspace has absolutely no business with it.

Isolation does not shut down queues, at least not the block multi-queue
ones which are only active when I/O is issued from that isolated CPU.

So transitioning out of isolation requires no action at all.

Transitioning in or changing the housekeeping mask needs some trivial
tweak to handle the case where there is an overlap in the cpuset of a
queue (housekeeping and isolated). This is handled already for setup and
affinity changes, but of course not for runtime isolation mask changes,
but that's a trivial thing to do.

What's more interesting is how to deal with the network problem where
there is no guarantee that the "response" ends up on the same queue as
the "request" which is what the block people rely on. And that problem
is not really an interrupt affinity problem in the first place.

Thanks,

        tglx
