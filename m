Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7D295563
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 02:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507388AbgJVAC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 20:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507379AbgJVAC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 20:02:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8C42068E;
        Thu, 22 Oct 2020 00:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603324947;
        bh=3UPSINPAND/lqccE62eGQN/0o8y3xZbQAeiWy+GF/To=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xi7ym5utmWSTIoAwg6r9dGp4x6QleovpXhk6RRUPw8uIK2epUTOTLeZqLsOBoTZ19
         ELd7dNL9gY8j3J05Mxzer4ue+0NTsCSAEGuGanmBsKvABq5hoi8LfnAGOujo9faeNV
         noUD3Q1gU/QxClDHx7T+3JvxvIM24UHqI5n5p3vc=
Date:   Wed, 21 Oct 2020 17:02:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
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
        lgoncalv@redhat.com, Dave Miller <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201021170224.55aea948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <877drj72cz.fsf@nanos.tec.linutronix.de>
References: <20200928183529.471328-1-nitesh@redhat.com>
        <20200928183529.471328-5-nitesh@redhat.com>
        <87v9f57zjf.fsf@nanos.tec.linutronix.de>
        <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
        <87lfg093fo.fsf@nanos.tec.linutronix.de>
        <877drj72cz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 22:25:48 +0200 Thomas Gleixner wrote:
> On Tue, Oct 20 2020 at 20:07, Thomas Gleixner wrote:
> > On Tue, Oct 20 2020 at 12:18, Nitesh Narayan Lal wrote:  
> >> However, IMHO we would still need a logic to prevent the devices from
> >> creating excess vectors.  
> >
> > Managed interrupts are preventing exactly that by pinning the interrupts
> > and queues to one or a set of CPUs, which prevents vector exhaustion on
> > CPU hotplug.
> >
> > Non-managed, yes that is and always was a problem. One of the reasons
> > why managed interrupts exist.  
> 
> But why is this only a problem for isolation? The very same problem
> exists vs. CPU hotplug and therefore hibernation.
> 
> On x86 we have at max. 204 vectors available for device interrupts per
> CPU. So assumed the only device interrupt in use is networking then any
> machine which has more than 204 network interrupts (queues, aux ...)
> active will prevent the machine from hibernation.
> 
> Aside of that it's silly to have multiple queues targeted at a single
> CPU in case of hotplug. And that's not a theoretical problem.  Some
> power management schemes shut down sockets when the utilization of a
> system is low enough, e.g. outside of working hours.
> 
> The whole point of multi-queue is to have locality so that traffic from
> a CPU goes through the CPU local queue. What's the point of having two
> or more queues on a CPU in case of hotplug?
> 
> The right answer to this is to utilize managed interrupts and have
> according logic in your network driver to handle CPU hotplug. When a CPU
> goes down, then the queue which is associated to that CPU is quiesced
> and the interrupt core shuts down the relevant interrupt instead of
> moving it to an online CPU (which causes the whole vector exhaustion
> problem on x86). When the CPU comes online again, then the interrupt is
> reenabled in the core and the driver reactivates the queue.

I think Mellanox folks made some forays into managed irqs, but I don't
remember/can't find the details now.

For networking the locality / queue per core does not always work,
since the incoming traffic is usually spread based on a hash. Many
applications perform better when network processing is done on a small
subset of CPUs, and application doesn't get interrupted every 100us. 
So we do need extra user control here.

We have a bit of a uAPI problem since people had grown to depend on
IRQ == queue == NAPI to configure their systems. "The right way" out
would be a proper API which allows associating queues with CPUs rather
than IRQs, then we can use managed IRQs and solve many other problems.

Such new API has been in the works / discussions for a while now.

(Magnus keep me honest here, if you disagree the queue API solves this.)
