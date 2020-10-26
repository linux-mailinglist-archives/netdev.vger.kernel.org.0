Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE8D2993DD
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787858AbgJZRbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:31:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1738349AbgJZRbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 13:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603733479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fS08d8MBtu1ip55QD9RREObehqTj3BnkBGdOU4nJc8o=;
        b=VOanpcLnuvd1yoT3rp46bd5uD5Gqc1ZeMqHOz498cLRCwj/J0YR7H01u2acFrwp8HN+Fz1
        2l5ZFZAQ7qY5iPglAPObmfFrjTrNsJebdSIsO759lRUC1jVJptQvhlH2N8C5IjuQLr3919
        3EeatD2pCrdnPJddi+U5dF2MmQ4PC88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-6NgAv3PkPCycQ-VxP7BvvA-1; Mon, 26 Oct 2020 13:31:17 -0400
X-MC-Unique: 6NgAv3PkPCycQ-VxP7BvvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEEE0809DC0;
        Mon, 26 Oct 2020 17:31:10 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 230DA19D6C;
        Mon, 26 Oct 2020 17:31:03 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 2B9B0417F242; Mon, 26 Oct 2020 14:30:12 -0300 (-03)
Date:   Mon, 26 Oct 2020 14:30:12 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
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
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201026173012.GA377978@fuller.cnet>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net>
 <20201019140005.GB17287@fuller.cnet>
 <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
 <20201023085826.GP2611@hirez.programming.kicks-ass.net>
 <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
 <87ft6464jf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ft6464jf.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 11:00:52PM +0200, Thomas Gleixner wrote:
> On Fri, Oct 23 2020 at 09:10, Nitesh Narayan Lal wrote:
> > On 10/23/20 4:58 AM, Peter Zijlstra wrote:
> >> On Thu, Oct 22, 2020 at 01:47:14PM -0400, Nitesh Narayan Lal wrote:
> >> So shouldn't we then fix the drivers / interface first, to get rid of
> >> this inconsistency?
> >>
> > Considering we agree that excess vector is a problem that needs to be
> > solved across all the drivers and that you are comfortable with the other
> > three patches in the set. If I may suggest the following:
> >
> > - We can pick those three patches for now, as that will atleast fix a
> >   driver that is currently impacting RT workloads. Is that a fair
> >   expectation?
> 
> No. Blindly reducing the maximum vectors to the number of housekeeping
> CPUs is patently wrong. The PCI core _cannot_ just nilly willy decide
> what the right number of interrupts for this situation is.
> 
> Many of these drivers need more than queue interrupts, admin, error
> interrupt and some operate best with seperate RX/TX interrupts per
> queue. They all can "work" with a single PCI interrupt of course, but
> the price you pay is performance.
> 
> An isolated setup, which I'm familiar with, has two housekeeping
> CPUs. So far I restricted the number of network queues with a module
> argument to two, which allocates two management interrupts for the
> device and two interrupts (RX/TX) per queue, i.e. a total of six.
> 
> Now I reduced the number of available interrupts to two according to
> your hack, which makes it use one queue RX/TX combined and one
> management interrupt. Guess what happens? Network performance tanks to
> the points that it breaks a carefully crafted setup.
> 
> The same applies to a device which is application specific and wants one
> channel including an interrupt per isolated application core. Today I
> can isolate 8 out of 12 CPUs and let the device create 8 channels and
> set one interrupt and channel affine to each isolated CPU. With your
> hack, I get only 4 interrupts and channels. Fail!

Good point.

> You cannot declare that all this is perfectly fine, just because it does
> not matter for your particular use case.
> 
> So without information from the driver which tells what the best number
> of interrupts is with a reduced number of CPUs, this cutoff will cause
> more problems than it solves. Regressions guaranteed.

One might want to move from one interrupt per isolated app core
to zero, or vice versa. It seems that "best number of interrupts 
is with reduced number of CPUs" information, is therefore in userspace, 
not in driver...

No?

> Managed interrupts base their interrupt allocation and spreading on
> information which is handed in by the individual driver and not on crude
> assumptions. They are not imposing restrictions on the use case.
> 
> It's perfectly fine for isolated work to save a data set to disk after
> computation has finished and that just works with the per-cpu I/O queue
> which is otherwise completely silent. 

Userspace could only change the mask of interrupts which are not 
triggered by requests from the local CPU (admin, error, mgmt, etc),
to avoid the vector exhaustion problem.

However, there is no explicit way for userspace to know that, as far as
i know.

 130:      34845          0          0          0          0          0          0          0  IR-PCI-MSI 33554433-edge      nvme0q1
 131:          0      27062          0          0          0          0          0          0  IR-PCI-MSI 33554434-edge      nvme0q2
 132:          0          0      24393          0          0          0          0          0  IR-PCI-MSI 33554435-edge      nvme0q3
 133:          0          0          0      24313          0          0          0          0  IR-PCI-MSI 33554436-edge      nvme0q4
 134:          0          0          0          0      20608          0          0          0  IR-PCI-MSI 33554437-edge      nvme0q5
 135:          0          0          0          0          0      22163          0          0  IR-PCI-MSI 33554438-edge      nvme0q6
 136:          0          0          0          0          0          0      23020          0  IR-PCI-MSI 33554439-edge      nvme0q7
 137:          0          0          0          0          0          0          0      24285  IR-PCI-MSI 33554440-edge      nvme0q8


Can that be retrieved from PCI-MSI information, or drivers
have to inform this? 

> All isolated workers can do the
> same in parallel without trampling on each other toes by competing for a
> reduced number of queues which are affine to the housekeeper CPUs.
> 
> Unfortunately network multi-queue is substantially different from block
> multi-queue (as I learned in this conversation), so the concept cannot
> be applied one-to-one to networking as is. But there are certainly part
> of it which can be reused.
> 
> This needs a lot more thought than just these crude hacks.
> 
> Especially under the aspect that there are talks about making isolation
> runtime switchable. Are you going to rmmod/insmod the i40e network
> driver to do so? That's going to work fine if you do that
> reconfiguration over network...
> 
> Thanks,
> 
>         tglx


