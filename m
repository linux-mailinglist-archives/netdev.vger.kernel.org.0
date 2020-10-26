Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A222999E0
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394727AbgJZWti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:49:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43162 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390414AbgJZWti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:49:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603752576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksDYXJPDBGDtncgmMUcP9mg1mza2LJA00t5oGzxZJYk=;
        b=m7vXXWXXxHdnndNtWQzlF5Od36id+ZmbnGgo3O8KuZgIQt8AscK7UpGXMljlrFEHLNBaxA
        YFgMa2sXy/Z8smqW8pTKT3fR27aNV9g1YXjR0uSFbgUiAyNFq7qZVyTPe+MmEYZIPU7JeY
        CZJPzsqK7IBdoJNDIZkkZEavoNHE1En/gpdaMaVi5G7CRSXFK/awLeOWDP6FMz5fSM7lrl
        qYHeVFPmmcBO/oIvuCQ6mLAn46sp74MiQkRAi4SPsaIWjn7MJDMCwDCCLHRtB78P/5y4jB
        er8LHo0C+LGGSmAolm/yXPk75p7DEBvjeRLowmPokxh6NBAtwJ480e622yAp7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603752576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksDYXJPDBGDtncgmMUcP9mg1mza2LJA00t5oGzxZJYk=;
        b=nsEuqJwgK8MU3fHK1KrFTAEeMjqWozGRv//N4pHuy/v6G6hN3DNpuuLWxfRIk3N7f1F1Mp
        ykp4Anes+d/b9tAg==
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, helgaas@kernel.org,
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
Subject: Re: [PATCH v4 4/4] PCI: Limit pci_alloc_irq_vectors() to housekeeping CPUs
In-Reply-To: <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com>
References: <20201019111137.GL2628@hirez.programming.kicks-ass.net> <20201019140005.GB17287@fuller.cnet> <20201020073055.GY2611@hirez.programming.kicks-ass.net> <078e659e-d151-5bc2-a7dd-fe0070267cb3@redhat.com> <20201020134128.GT2628@hirez.programming.kicks-ass.net> <6736e643-d4ae-9919-9ae1-a73d5f31463e@redhat.com> <260f4191-5b9f-6dc1-9f11-085533ac4f55@redhat.com> <20201023085826.GP2611@hirez.programming.kicks-ass.net> <9ee77056-ef02-8696-5b96-46007e35ab00@redhat.com> <87ft6464jf.fsf@nanos.tec.linutronix.de> <20201026173012.GA377978@fuller.cnet> <875z6w4xt4.fsf@nanos.tec.linutronix.de> <86f8f667-bda6-59c4-91b7-6ba2ef55e3db@intel.com> <87v9ew3fzd.fsf@nanos.tec.linutronix.de> <85b5f53e-5be2-beea-269a-f70029bea298@intel.com> <87lffs3bd6.fsf@nanos.tec.linutronix.de> <959997ee-f393-bab0-45c0-4144c37b9185@redhat.com>
Date:   Mon, 26 Oct 2020 23:49:35 +0100
Message-ID: <875z6w38n4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26 2020 at 18:22, Nitesh Narayan Lal wrote:
> On 10/26/20 5:50 PM, Thomas Gleixner wrote:
>> But I still think that for curing that isolation stuff we want at least
>> some information from the driver. Alternative solution would be to grant
>> the allocation of interrupts and queues and have some sysfs knob to shut
>> down queues at runtime. If that shutdown results in releasing the queue
>> interrupt (via free_irq()) then the vector exhaustion problem goes away.
>
> I think this is close to what I and Marcelo were discussing earlier today
> privately.
>
> I don't think there is currently a way to control the enablement/disablement of
> interrupts from the userspace.

You cannot just disable the interrupt. You need to make sure that the
associated queue is shutdown or quiesced _before_ the interrupt is shut
down.

Thanks,

        tglx
