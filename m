Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013F929A881
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896525AbgJ0J4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2410305AbgJ0J43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603792587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JVIROt4xscPTv2bl+9dBZkGi/KmAAnHZ43ndwfcAS4s=;
        b=bB+jRXhLlnKQCuJbpeOwsBh7oh+8kwGSocAoOAouv7s/xncBsWSuDeg7MNl8euVHHqFMRh
        fUeHc8Jc2hNRpxJp6LIdOPdzTe20C8wxhRg4DFd7qt7qNoqNvqXiHIDWwBBfTfiREdxWae
        4Owm2sYh7m97ZKtNum85/toKt2lax90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-HcgxRTMQP4aCMXK2g1pL6A-1; Tue, 27 Oct 2020 05:56:23 -0400
X-MC-Unique: HcgxRTMQP4aCMXK2g1pL6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 883E2100CCFD;
        Tue, 27 Oct 2020 09:56:20 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B3EC7367E;
        Tue, 27 Oct 2020 09:55:56 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 00636417F242; Mon, 26 Oct 2020 16:11:07 -0300 (-03)
Date:   Mon, 26 Oct 2020 16:11:07 -0300
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
Message-ID: <20201026191107.GA407524@fuller.cnet>
References: <20201020073055.GY2611@hirez.programming.kicks-ass.net>
 <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com>
 <20201020134128.GT2628@hirez.programming.kicks-ass.net>
 <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com>
 <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com>
 <20201023085826.GP2611@hirez.programming.kicks-ass.net>
 <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com>
 <87ft6464jf.fsf@nanos.tec.linutronix.de>
 <20201026173012.GA377978@fuller.cnet>
 <875z6w4xt4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z6w4xt4.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 08:00:39PM +0100, Thomas Gleixner wrote:
> On Mon, Oct 26 2020 at 14:30, Marcelo Tosatti wrote:
> > On Fri, Oct 23, 2020 at 11:00:52PM +0200, Thomas Gleixner wrote:
> >> So without information from the driver which tells what the best number
> >> of interrupts is with a reduced number of CPUs, this cutoff will cause
> >> more problems than it solves. Regressions guaranteed.
> >
> > One might want to move from one interrupt per isolated app core
> > to zero, or vice versa. It seems that "best number of interrupts 
> > is with reduced number of CPUs" information, is therefore in userspace, 
> > not in driver...
> 
> How does userspace know about the driver internals? Number of management
> interrupts, optimal number of interrupts per queue?
> 
> >> Managed interrupts base their interrupt allocation and spreading on
> >> information which is handed in by the individual driver and not on crude
> >> assumptions. They are not imposing restrictions on the use case.
> >> 
> >> It's perfectly fine for isolated work to save a data set to disk after
> >> computation has finished and that just works with the per-cpu I/O queue
> >> which is otherwise completely silent. 
> >
> > Userspace could only change the mask of interrupts which are not 
> > triggered by requests from the local CPU (admin, error, mgmt, etc),
> > to avoid the vector exhaustion problem.
> >
> > However, there is no explicit way for userspace to know that, as far as
> > i know.
> >
> >  130:      34845          0          0          0          0          0          0          0  IR-PCI-MSI 33554433-edge      nvme0q1
> >  131:          0      27062          0          0          0          0          0          0  IR-PCI-MSI 33554434-edge      nvme0q2
> >  132:          0          0      24393          0          0          0          0          0  IR-PCI-MSI 33554435-edge      nvme0q3
> >  133:          0          0          0      24313          0          0          0          0  IR-PCI-MSI 33554436-edge      nvme0q4
> >  134:          0          0          0          0      20608          0          0          0  IR-PCI-MSI 33554437-edge      nvme0q5
> >  135:          0          0          0          0          0      22163          0          0  IR-PCI-MSI 33554438-edge      nvme0q6
> >  136:          0          0          0          0          0          0      23020          0  IR-PCI-MSI 33554439-edge      nvme0q7
> >  137:          0          0          0          0          0          0          0      24285  IR-PCI-MSI 33554440-edge      nvme0q8
> >
> > Can that be retrieved from PCI-MSI information, or drivers
> > have to inform this?
> 
> The driver should use a different name for the admin queues.

Works for me.

Sounds more like a heuristic which can break, so documenting this 
as an "interface" seems appropriate.

