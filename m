Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607B8295A4E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507639AbgJVI2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502102AbgJVI2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:28:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2AEC0613CE;
        Thu, 22 Oct 2020 01:28:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603355282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDhoWshQhIJouOHjZSfLuoOEJxu0EfOG35UztahVv2w=;
        b=xO76q4yJbm65fuck7iz3vwSLDh5wOZfcG351wfUx99gofOUvgSSC6IgTYprLS4gBLnRyJq
        VSjjIjZzrxdbDYcfv+h9PF1thMOBsoqAlwyz7r+lDyYa55Oo28Veei4LYZhRTmwN7vGhoE
        U+JXgOEEC2pTJ6dW5sXTWIQ7RIbRrt+sTIEfVZI83ff4jjnMM1ZAG1sFDppIyLBO4FGM/b
        j2N6SIj4Q2yQfTQ1B+LiKvfArtu0eOrSe7ZetBALhboJnxbE9LvBCb26SpMILSxBUVVNAL
        34a2qwD6nsafD8YWroyYBBt5fGeUAbfpoVs93x1D+dTgYHg1DmOAtKm0jOrZNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603355282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDhoWshQhIJouOHjZSfLuoOEJxu0EfOG35UztahVv2w=;
        b=XH5DF74AogSgwXx150G9wVhi90K5iIu3AqOkToxAoXmKjngRwt+o/wTS+4gj88tkTv5K0C
        Aec6QzsbbzCWQhCw==
To:     Jakub Kicinski <kuba@kernel.org>
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
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <20201021170224.55aea948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200928183529.471328-1-nitesh@redhat.com> <20200928183529.471328-5-nitesh@redhat.com> <87v9f57zjf.fsf@nanos.tec.linutronix.de> <3bca9eb1-a318-1fc6-9eee-aacc0293a193@redhat.com> <87lfg093fo.fsf@nanos.tec.linutronix.de> <877drj72cz.fsf@nanos.tec.linutronix.de> <20201021170224.55aea948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 22 Oct 2020 10:28:02 +0200
Message-ID: <874kmm7jhp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21 2020 at 17:02, Jakub Kicinski wrote:
> On Wed, 21 Oct 2020 22:25:48 +0200 Thomas Gleixner wrote:
>> The right answer to this is to utilize managed interrupts and have
>> according logic in your network driver to handle CPU hotplug. When a CPU
>> goes down, then the queue which is associated to that CPU is quiesced
>> and the interrupt core shuts down the relevant interrupt instead of
>> moving it to an online CPU (which causes the whole vector exhaustion
>> problem on x86). When the CPU comes online again, then the interrupt is
>> reenabled in the core and the driver reactivates the queue.
>
> I think Mellanox folks made some forays into managed irqs, but I don't
> remember/can't find the details now.
>
> For networking the locality / queue per core does not always work,
> since the incoming traffic is usually spread based on a hash. Many

That makes it problematic and is fundamentally different from block I/O.

> applications perform better when network processing is done on a small
> subset of CPUs, and application doesn't get interrupted every 100us. 
> So we do need extra user control here.

Ok.

> We have a bit of a uAPI problem since people had grown to depend on
> IRQ == queue == NAPI to configure their systems. "The right way" out
> would be a proper API which allows associating queues with CPUs rather
> than IRQs, then we can use managed IRQs and solve many other problems.
>
> Such new API has been in the works / discussions for a while now.

If there is anything which needs to be done/extended on the irq side
please let me know.

Thanks

        tglx
