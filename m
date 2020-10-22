Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817F295E60
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898203AbgJVM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2898189AbgJVM3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 08:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603369763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LckgkZ6IVJMsEiwSkmcuHngu8LJFXLEySIsMLY2OYag=;
        b=Af8J0dSO+MiY4UiHqEpRyDG+8wPSTjdAevd2rj56aE88BJaSzaxDahCAvplabfZeRb0mt3
        K7XlFcgixoDN8U44BHV+4u/3w4rsyXkWyVC1d5VY7x4JrlLot6O0ekBaICOnSi3Bw5XLff
        LLl19eksS33PB1nTd5bIgnhYm1lCQrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131--71cejwHNtG7emFfUNsmQQ-1; Thu, 22 Oct 2020 08:29:21 -0400
X-MC-Unique: -71cejwHNtG7emFfUNsmQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 708DE186DD3D;
        Thu, 22 Oct 2020 12:29:18 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A4A05C1C7;
        Thu, 22 Oct 2020 12:29:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 7F7BB41853FB; Thu, 22 Oct 2020 09:28:49 -0300 (-03)
Date:   Thu, 22 Oct 2020 09:28:49 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to
 housekeeping CPUs
Message-ID: <20201022122849.GA148426@fuller.cnet>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-5-nitesh@redhat.com>
 <87v9f57zjf.fsf@nanos.tec.linutronix.de>
 <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com>
 <87lfg093fo.fsf@nanos.tec.linutronix.de>
 <877drj72cz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877drj72cz.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 10:25:48PM +0200, Thomas Gleixner wrote:
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

Exactly. It seems the proper way to do handle this is to disable
individual vectors rather than moving them. And that is needed for 
dynamic isolate / unisolate anyway...

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

Aha... But it would be necessary to do that from userspace (for runtime
isolate/unisolate).

