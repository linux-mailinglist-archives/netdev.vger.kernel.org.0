Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B828D295371
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 22:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440877AbgJUUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 16:25:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42750 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408285AbgJUUZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 16:25:51 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603311949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ErBlktAm/VDZfe11k5xiz2G5eeFjMBryMubxpLgI90=;
        b=lAs4GHqKsxFj2ehxfTNtvW6HA/OFk73TgWU9NNny0xClUy9lV3pa0W2oLtGILx/5+6IOaj
        kiP+OrcbeSZswKH0PNvs6kl+cZ0yljZA20keIiuAoOoLHbuecNCk8Rk7WG952LfmSVCq5Z
        Kkgn0blrKnDKJ0DGDhdgUUZT6JSwy1B/BeEfXU+3zCGjCO3nkdjSO4BZcPPh3twnJ3kdLz
        vih60WESW5odQfOVoD1IRz2ZqSOjovNza8g9gJZQEB8ZfYnFLyHc3WZ0IgVDfqSAPygZyd
        8jx0pYbfQ9rwtnwciHVhkCutMekhR4bTANCWeuz3KyofRgJNMLsMNNPZ2JOoDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603311949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ErBlktAm/VDZfe11k5xiz2G5eeFjMBryMubxpLgI90=;
        b=CKysLuROojLRHKTKNJPL+SuMqZe5T2j0BnTXahqjamQZMuEe9GG6lsjkfBNsx0nVCUNULw
        mVjXQAOmVi6sOoCg==
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
        lgoncalv@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <87lfg093fo.fsf@nanos.tec.linutronix.de>
References: <20200928183529.471328-1-nitesh@redhat.com> <20200928183529.471328-5-nitesh@redhat.com> <87v9f57zjf.fsf@nanos.tec.linutronix.de> <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com> <87lfg093fo.fsf@nanos.tec.linutronix.de>
Date:   Wed, 21 Oct 2020 22:25:48 +0200
Message-ID: <877drj72cz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20 2020 at 20:07, Thomas Gleixner wrote:
> On Tue, Oct 20 2020 at 12:18, Nitesh Narayan Lal wrote:
>> However, IMHO we would still need a logic to prevent the devices from
>> creating excess vectors.
>
> Managed interrupts are preventing exactly that by pinning the interrupts
> and queues to one or a set of CPUs, which prevents vector exhaustion on
> CPU hotplug.
>
> Non-managed, yes that is and always was a problem. One of the reasons
> why managed interrupts exist.

But why is this only a problem for isolation? The very same problem
exists vs. CPU hotplug and therefore hibernation.

On x86 we have at max. 204 vectors available for device interrupts per
CPU. So assumed the only device interrupt in use is networking then any
machine which has more than 204 network interrupts (queues, aux ...)
active will prevent the machine from hibernation.

Aside of that it's silly to have multiple queues targeted at a single
CPU in case of hotplug. And that's not a theoretical problem.  Some
power management schemes shut down sockets when the utilization of a
system is low enough, e.g. outside of working hours.

The whole point of multi-queue is to have locality so that traffic from
a CPU goes through the CPU local queue. What's the point of having two
or more queues on a CPU in case of hotplug?

The right answer to this is to utilize managed interrupts and have
according logic in your network driver to handle CPU hotplug. When a CPU
goes down, then the queue which is associated to that CPU is quiesced
and the interrupt core shuts down the relevant interrupt instead of
moving it to an online CPU (which causes the whole vector exhaustion
problem on x86). When the CPU comes online again, then the interrupt is
reenabled in the core and the driver reactivates the queue.

Thanks,

        tglx



