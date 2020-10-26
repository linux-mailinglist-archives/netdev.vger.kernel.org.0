Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B18298EA8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780829AbgJZN5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:57:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40180 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780822AbgJZN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:57:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603720670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/OHUc3ZTxOnSdMTpC8YgapP1SujhOMZOgiAI8wwc4U=;
        b=sXwkSST6XFQnFqHxHusBURIJifh54p6cswdp4kZT9Au+dIQKZwf+Cl6lOu99Ku1z4waAbv
        S7Yba9KIEFyjoX1tdM2UUKI0YDPkMmXDWoJ0UzB/LlxfvMfoqtbvpHRM346XPxG4M4Q0h4
        CMxYrvM/JwMDEV7BAzVgqefIjEclU/HcY4SsBT+26NUXk/txXB+Agqw6C5N7ekHZ4wVm6P
        ozkzEVZ3FUkJ+iTf9A1TAFqiDPxYvcbOe14glk14VzbgFwTShw9/nL/UadaoxV+SRhvfDH
        zYz4ZeM4HBkWUP5LO/4y3uq1bVf/wl1eqXDSoD1a2T197SIOCUzjA6toKVn1Hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603720670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/OHUc3ZTxOnSdMTpC8YgapP1SujhOMZOgiAI8wwc4U=;
        b=YTD8pQVsZ/dvyFc0Ulx/a2JJ55MggdrwnYcIhkaJljDxKZJg9ScYPatGMDvfkoFxN1XCdn
        MU+dolBlFXph34DA==
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jiri@nvidia.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <9529ddd0-28f7-fa74-e56f-39de84321a22@redhat.com>
References: <20200928183529.471328-5-nitesh@redhat.com> <20201016122046.GP2611@hirez.programming.kicks-ass.net> <79f382a7-883d-ff42-394d-ec4ce81fed6a@redhat.com> <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <9529ddd0-28f7-fa74-e56f-39de84321a22@redhat.com>
Date:   Mon, 26 Oct 2020 14:57:50 +0100
Message-ID: <878sbt3x9d.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 09:35, Nitesh Narayan Lal wrote:
> On 10/23/20 5:00 PM, Thomas Gleixner wrote:
>> An isolated setup, which I'm familiar with, has two housekeeping
>> CPUs. So far I restricted the number of network queues with a module
>> argument to two, which allocates two management interrupts for the
>> device and two interrupts (RX/TX) per queue, i.e. a total of six.
>
> Does it somehow take num_online_cpus() into consideration while deciding
> the number of interrupts to create?

No, I just tell it to create two queues :)

>> So without information from the driver which tells what the best number
>> of interrupts is with a reduced number of CPUs, this cutoff will cause
>> more problems than it solves. Regressions guaranteed.
>
> Indeed.
> I think one commonality among the drivers at the moment is the usage of
> num_online_cpus() to determine the vectors to create.
>
> So, maybe instead of doing this kind of restrictions in a generic level
> API, it will make more sense to do this on a per-device basis by replacing
> the number of online CPUs with the housekeeping CPUs?
>
> This is what I have done in the i40e patch.
> But that still sounds hackish and will impact the performance.

You want an interface which allows the driver to say:

  I need N interrupts for general management and ideally M interrupts
  per queue.

This is similar to the way drivers tell the core code about their
requirements for managed interrupts for the spreading calculation.

>> Managed interrupts base their interrupt allocation and spreading on
>> information which is handed in by the individual driver and not on crude
>> assumptions. They are not imposing restrictions on the use case.
>
> Right, FWIU it is irq_do_set_affinity that prevents the spreading of
> managed interrupts to isolated CPUs if HK_FLAG_MANAGED_IRQ is enabled,
> isn't?

No. Spreading takes possible CPUs into account. HK_FLAG_MANAGED_IRQ does
not influence spreading at all.

It only handles the case that an interrupt is affine to more than one
CPUs and the resulting affinity mask spawns both housekeeping and
isolated CPUs. It then steers the interrupt to the housekeeping CPUs (as
long as there is one online).

Thanks,

        tglx
