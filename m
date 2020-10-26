Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C234D29965A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1791376AbgJZTAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:00:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41806 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407524AbgJZTAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 15:00:42 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603738839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QvUMf5PqeNQlMPTahrZW6OrL4d+7Sf7dM1LOD6g9Y8=;
        b=sABnPwPQKFh6X9EOykr/dujf0/BDYdGvouZaj0zKCcdjFh8cxYhWlV7ouzHx/9AuiAOkeG
        W+nnFVlZuj9S6fziXQWunzPixauZqnZQ9nLrh0JuKn4b6GiiYM8MGZ/Hp12D/qpqd9gEzP
        slpm4V3s9owptbHMS5+4tv4aJ9WAaMh2weKt7qrAKu8qPdMl5trskBHj5yfxBb40QBrKGe
        /ySnUN5ZPONi+9PPcb8jktC0ZuQCfW5Crt2M7PWUjDfFZ7bcbb7tkpCg1/yeBTjfJrVvDM
        1P2ToGRRopEgY3n7+DLY+WNFdQpiTNbQ74qPaf9Rj6gCNlFiOI7v2XszgBH7ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603738839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QvUMf5PqeNQlMPTahrZW6OrL4d+7Sf7dM1LOD6g9Y8=;
        b=gNKSesjquFk4p1+yIEyYQTEdbXn5nw5BA42TTDi3QdQl6il8MyloLrDdzKgZxPyLpDN/6W
        iJvGWftarXbD6IBw==
To:     Marcelo Tosatti <mtosatti@redhat.com>
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
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <20201026173012.GA377978@fuller.cnet>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet>
Date:   Mon, 26 Oct 2020 20:00:39 +0100
Message-ID: <875z6w4xt4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 14:30, Marcelo Tosatti wrote:
> On Fri, Oct 23, 2020 at 11:00:52PM +0200, Thomas Gleixner wrote:
>> So without information from the driver which tells what the best number
>> of interrupts is with a reduced number of CPUs, this cutoff will cause
>> more problems than it solves. Regressions guaranteed.
>
> One might want to move from one interrupt per isolated app core
> to zero, or vice versa. It seems that "best number of interrupts 
> is with reduced number of CPUs" information, is therefore in userspace, 
> not in driver...

How does userspace know about the driver internals? Number of management
interrupts, optimal number of interrupts per queue?

>> Managed interrupts base their interrupt allocation and spreading on
>> information which is handed in by the individual driver and not on crude
>> assumptions. They are not imposing restrictions on the use case.
>> 
>> It's perfectly fine for isolated work to save a data set to disk after
>> computation has finished and that just works with the per-cpu I/O queue
>> which is otherwise completely silent. 
>
> Userspace could only change the mask of interrupts which are not 
> triggered by requests from the local CPU (admin, error, mgmt, etc),
> to avoid the vector exhaustion problem.
>
> However, there is no explicit way for userspace to know that, as far as
> i know.
>
>  130:      34845          0          0          0          0          0          0          0  IR-PCI-MSI 33554433-edge      nvme0q1
>  131:          0      27062          0          0          0          0          0          0  IR-PCI-MSI 33554434-edge      nvme0q2
>  132:          0          0      24393          0          0          0          0          0  IR-PCI-MSI 33554435-edge      nvme0q3
>  133:          0          0          0      24313          0          0          0          0  IR-PCI-MSI 33554436-edge      nvme0q4
>  134:          0          0          0          0      20608          0          0          0  IR-PCI-MSI 33554437-edge      nvme0q5
>  135:          0          0          0          0          0      22163          0          0  IR-PCI-MSI 33554438-edge      nvme0q6
>  136:          0          0          0          0          0          0      23020          0  IR-PCI-MSI 33554439-edge      nvme0q7
>  137:          0          0          0          0          0          0          0      24285  IR-PCI-MSI 33554440-edge      nvme0q8
>
> Can that be retrieved from PCI-MSI information, or drivers
> have to inform this?

The driver should use a different name for the admin queues.

Thanks,

        tglx
