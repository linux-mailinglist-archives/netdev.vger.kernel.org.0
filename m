Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2102941E4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437249AbgJTSHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387755AbgJTSHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:07:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E4CC0613CE;
        Tue, 20 Oct 2020 11:07:25 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603217243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LeMXYg7iCMItsZtXLmmRK9fkfNd0wXBuje5zWxjuqWQ=;
        b=qDHag5jUtcYY1ospfAJ+zlutOQbY3+C0bC9EPi1EZMpn+II8KgaYDpV1LAVI8GtoyzAz6J
        0Ds6sLaCTexJ078RLsCQxHKLok/8wlwLzz4KqDEVDWN37BqpL8cHOin3Vc2lrbvKhnk9fU
        gTtCZ9OIDpyIrU0KF0Ri4iTj3PX6nCApRbwgEoELwTGCqc2e7AGW9/iyDB1qKEi+56dCCz
        pCGsFGG8IS/h6Jc+Kh+h9BZUwe79z9lfowsxuyYixjtt4jcsb8SAUm1cXvAIUnIXt6g0CW
        GokjEdpt/RccHcAqCUC59MCkh0mKevqzmZTL7RGJRdmm6fEF5rqg9H7QDIC5Gw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603217243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LeMXYg7iCMItsZtXLmmRK9fkfNd0wXBuje5zWxjuqWQ=;
        b=1iCD6Fdka9UkLf2kiE9clDl7+fPycl4tRaJS8aQELf+C9KC9wIeAZui9dMdNqM+0kS1mxw
        uyB16tsCz17uoMBQ==
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
References: <20200928183529.471328-1-nitesh@redhat.com> <20200928183529.471328-5-nitesh@redhat.com> <87v9f57zjf.fsf@nanos.tec.linutronix.de> <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
Date:   Tue, 20 Oct 2020 20:07:23 +0200
Message-ID: <87lfg093fo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20 2020 at 12:18, Nitesh Narayan Lal wrote:
> On 10/20/20 10:16 AM, Thomas Gleixner wrote:
>> With the above change this will result
>>
>>    1  general interrupt which is free movable by user space
>>    1  managed interrupts (possible affinity to all 16 CPUs, but routed
>>       to housekeeping CPU as long as there is one online)
>>
>> So the device is now limited to a single queue which also affects the
>> housekeeping CPUs because now they have to share a single queue.
>>
>> With larger machines this gets even worse.
>
> Yes, the change can impact the performance, however, if we don't do that we
> may have a latency impact instead. Specifically, on larger systems where
> most of the CPUs are isolated as we will definitely fail in moving all of the
> IRQs away from the isolated CPUs to the housekeeping.

For non managed interrupts I agree.

>> So no. This needs way more thought for managed interrupts and you cannot
>> do that at the PCI layer.
>
> Maybe we should not be doing anything in the case of managed IRQs as they
> are anyways pinned to the housekeeping CPUs as long as we have the
> 'managed_irq' option included in the kernel cmdline.

Exactly. For the PCI side this vector limiting has to be restricted to
the non managed case.

>>  Only the affinity spreading mechanism can do
>> the right thing here.
>
> I can definitely explore this further.
>
> However, IMHO we would still need a logic to prevent the devices from
> creating excess vectors.

Managed interrupts are preventing exactly that by pinning the interrupts
and queues to one or a set of CPUs, which prevents vector exhaustion on
CPU hotplug.

Non-managed, yes that is and always was a problem. One of the reasons
why managed interrupts exist.

Thanks,

        tglx
