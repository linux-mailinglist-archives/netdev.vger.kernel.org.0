Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC129AB1C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750200AbgJ0LsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750192AbgJ0LsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 07:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603799298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/AgwzcCTvrWgzyfiV85FVL0zRQS/mR6Y//U0UAucMk=;
        b=W0yewt5xkDLTu3Rl/gE1HKeA6rTIW6gVJ9TGIDWHF56cMzKMxaF0rJ8resMEwdT+ZpJs5J
        VVGclMPtEAEa9xrbVbMoab3egFpk+BBl8aZOn5R9HPP0/M9zegiGYXOFXQNfKUQJfCN8Bl
        bFsnr8qwhqKcuIi8GBA466m81o/VnyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-i2czznU2M7Ou11EETDUbFw-1; Tue, 27 Oct 2020 07:48:15 -0400
X-MC-Unique: i2czznU2M7Ou11EETDUbFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C121186DD41;
        Tue, 27 Oct 2020 11:48:12 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D65D55C1BB;
        Tue, 27 Oct 2020 11:48:04 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 59ADC416C894; Tue, 27 Oct 2020 08:47:39 -0300 (-03)
Date:   Tue, 27 Oct 2020 08:47:39 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        jeffrey.t.kirsher@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201027114739.GA11336@fuller.cnet>
References: <20201023085826.GP2611@hirez.programming.kicks-ass.net>
 <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
 <87ft6464jf.fsf@nanos.tec.linutronix.de>
 <20201026173012.GA377978@fuller.cnet>
 <875z6w4xt4.fsf@nanos.tec.linutronix.de>
 <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com>
 <87v9ew3fzd.fsf@nanos.tec.linutronix.de>
 <85b5f53e-5be2-beea-269a-f70029bea298@intel.com>
 <87lffs3bd6.fsf@nanos.tec.linutronix.de>
 <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 06:22:29PM -0400, Nitesh Narayan Lal wrote:
> 
> On 10/26/20 5:50 PM, Thomas Gleixner wrote:
> > On Mon, Oct 26 2020 at 14:11, Jacob Keller wrote:
> >> On 10/26/2020 1:11 PM, Thomas Gleixner wrote:
> >>> On Mon, Oct 26 2020 at 12:21, Jacob Keller wrote:
> >>>> Are there drivers which use more than one interrupt per queue? I know
> >>>> drivers have multiple management interrupts.. and I guess some drivers
> >>>> do combined 1 interrupt per pair of Tx/Rx..  It's also plausible to to
> >>>> have multiple queues for one interrupt .. I'm not sure how a single
> >>>> queue with multiple interrupts would work though.
> >>> For block there is always one interrupt per queue. Some Network drivers
> >>> seem to have seperate RX and TX interrupts per queue.
> >> That's true when thinking of Tx and Rx as a single queue. Another way to
> >> think about it is "one rx queue" and "one tx queue" each with their own
> >> interrupt...
> >>
> >> Even if there are devices which force there to be exactly queue pairs,
> >> you could still think of them as separate entities?
> > Interesting thought.
> >
> > But as Jakub explained networking queues are fundamentally different
> > from block queues on the RX side. For block the request issued on queue
> > X will raise the complete interrupt on queue X.
> >
> > For networking the TX side will raise the TX interrupt on the queue on
> > which the packet was queued obviously or should I say hopefully. :)
> 
> This is my impression as well.
> 
> > But incoming packets will be directed to some receive queue based on a
> > hash or whatever crystallball logic the firmware decided to implement.
> >
> > Which makes this not really suitable for the managed interrupt and
> > spreading approach which is used by block-mq. Hrm...
> >
> > But I still think that for curing that isolation stuff we want at least
> > some information from the driver. Alternative solution would be to grant
> > the allocation of interrupts and queues and have some sysfs knob to shut
> > down queues at runtime. If that shutdown results in releasing the queue
> > interrupt (via free_irq()) then the vector exhaustion problem goes away.
> 
> I think this is close to what I and Marcelo were discussing earlier today
> privately.
> 
> I don't think there is currently a way to control the enablement/disablement of
> interrupts from the userspace.

As long as the interrupt obeys the "trigger when request has been
performed by local CPU" rule (#1) (for MSI type interrupts, where driver allocates
one I/O interrupt per CPU), don't see a need for the interface.

For other types of interrupts, interrupt controller should be programmed
to not include the isolated CPU on its "destination CPU list".

About the block VS network discussion, what we are trying to do at skb
level (Paolo Abeni CC'ed, author of the suggestion) is to use RPS to
avoid skbs from being queued to a CPU (on RX), and to queue skbs
on housekeeping CPUs for processing (TX).

However, if per-CPU interrupts are not disabled, then the (for example)
network device is free to include the CPU in its list of destinations.
Which would require one to say, configure RPS (or whatever mechanism
is distributing interrupts).

Hum, it would feel safer (rather than trust the #1 rule to be valid
in all cases) to ask the driver to disable the interrupt (after shutting
down queue) for that particular CPU.

BTW, Thomas, software is free to configure a particular MSI-X interrupt
to point to any CPU:

10.11 MESSAGE SIGNALLED INTERRUPTS
The PCI Local Bus Specification, Rev 2.2 (www.pcisig.com) introduces the concept of message signalled interrupts.
As the specification indicates:
“Message signalled interrupts (MSI) is an optional feature that enables PCI devices to request
service by writing a system-specified message to a system-specified address (PCI DWORD memory
write transaction). The transaction address specifies the message destination while the transaction
data specifies the message. System software is expected to initialize the message destination and
message during device configuration, allocating one or more non-shared messages to each MSI
capable function.”

Fields in the Message Address Register are as follows:
1. Bits 31-20 — These bits contain a fixed value for interrupt messages (0FEEH). This value locates interrupts at
the 1-MByte area with a base address of 4G – 18M. All accesses to this region are directed as interrupt
messages. Care must to be taken to ensure that no other device claims the region as I/O space.
2. Destination ID — This field contains an 8-bit destination ID. It identifies the message’s target processor(s).
The destination ID corresponds to bits 63:56 of the I/O APIC Redirection Table Entry if the IOAPIC is used to
dispatch the interrupt to the processor(s).

---

So taking the example where computation happens while isolated and later
stored via block interface, aren't we restricting the usage scenarios
by enforcing the "per-CPU queue has interrupt pointing to owner CPU" rule?

> I think in terms of the idea we need something similar to what i40e does,
> that is shutdown all IRQs when CPU is suspended and restores the interrupt
> schema when the CPU is back online.
> 
> The two key difference will be that this API needs to be generic and also
> needs to be exposed to the userspace through something like sysfs as you
> have mentioned.


> 
> -- 
> Thanks
> Nitesh
> 



