Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F7D2999D6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394676AbgJZWqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:46:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43108 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394668AbgJZWqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:46:36 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603752394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EMtaedWvWnlr8FoOiOT3OcNE6XEhbc2X12bxau6EyFI=;
        b=hEPCG2un8FH9qImCrJqicTU+VJY6N/dn8Vx214yYX5jTIIQO7JoERJ1eR3Jkhj9V4/Ti/R
        SG7as2v78lmp83DCYPgalSSV8hv90SSVnyRs71ktVW1GDHLbBgWoimuqaP+0LbfLZtPaZm
        GZcRqTA+v8cOCm1Fna4Vj5eAdy3BQOKDSRHu0faEku/nIgNErV57rBf7FKhxn8vJFITvtV
        ZI4L4fobzqX25UN2isZHvaNPI8/SvShskRbcvRyNurbf+OA5gbU02GN3XO4NZhIeUn+zjM
        dR+/CAl/QmdJ/Tc8p8/16dRiok0JXoUztki/dlYYg9SmRfnHP6EPYkUF1qoNSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603752394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EMtaedWvWnlr8FoOiOT3OcNE6XEhbc2X12bxau6EyFI=;
        b=/0MZUIzr/yPzfalGB8dky2AgJXYoZCXz552/jb8OMkHDcMOCA4OXvbG8ORFq2uO0pVJiLx
        3TDr0Q1bRzyGSmAw==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <20201026151306.4af991a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet> <875z6w4xt4.fsf@nanos.tec.linutronix.de> <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com> <87v9ew3fzd.fsf@nanos.tec.linutronix.de> <85b5f53e-5be2-beea-269a-f70029bea298@intel.com> <87lffs3bd6.fsf@nanos.tec.linutronix.de> <20201026151306.4af991a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Mon, 26 Oct 2020 23:46:34 +0100
Message-ID: <878sbs38s5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 15:13, Jakub Kicinski wrote:
> On Mon, 26 Oct 2020 22:50:45 +0100 Thomas Gleixner wrote:
>> But I still think that for curing that isolation stuff we want at least
>> some information from the driver. Alternative solution would be to grant
>> the allocation of interrupts and queues and have some sysfs knob to shut
>> down queues at runtime. If that shutdown results in releasing the queue
>> interrupt (via free_irq()) then the vector exhaustion problem goes away.
>> 
>> Needs more thought and information (for network oblivious folks like
>> me).
>
> One piece of information that may be useful is that even tho the RX
> packets may be spread semi-randomly the user space can still control
> which queues are included in the mechanism. There is an indirection
> table in the HW which allows to weigh queues differently, or exclude
> selected queues from the spreading. Other mechanisms exist to filter
> flows onto specific queues.
>
> IOW just because a core has an queue/interrupt does not mean that
> interrupt will ever fire, provided its excluded from RSS.
>
> Another piece is that by default we suggest drivers allocate 8 RX
> queues, and online_cpus TX queues. The number of queues can be
> independently controlled via ethtool -L. Drivers which can't support
> separate queues will default to online_cpus queue pairs, and let
> ethtool -L only set the "combined" parameter.
>
> There are drivers which always allocate online_cpus interrupts, 
> and then some of them will go unused if #qs < #cpus.

Thanks for the enlightment.

> My unpopular opinion is that for networking devices all the heuristics
> we may come up with are going to be a dead end.

I agree. Heuristics suck.

> We need an explicit API to allow users placing queues on cores, and
> use managed IRQs for data queues. (I'm assuming that managed IRQs will
> let us reliably map a MSI-X vector to a core :))

Yes, they allow you to do that. That will need some tweaks to theway
they work today (coming from the strict block mq semantics). You also
need to be aware that managed irqs have also strict semantics vs. CPU
hotplug. If the last CPU in the managed affinity set goes down then the
interrupt is shut down by the irq core which means that you need to
quiesce the associated queue before that happens. When the first CPU
comes online again the interrupt is reenabled, so the queue should be
able to handle it or has ensured that the device does not raise one
before it is able to do so.

Thanks,

        tglx
