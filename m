Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0015243841
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 12:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHMKLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 06:11:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57594 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgHMKLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 06:11:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597313495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zt7T8B80Wzzn5EaRMNRRGT8rmn9Iua7ORS/7xToxj6A=;
        b=l5AbyYj6UEG/LFRXmeb4lns4UZyb+zM5h1OSxoIRbdb643Nus4DzDfMC230BU3Yu8njADB
        65Di6ehekqWR51FzApTqSbXYVr2AYbLztEv6yOMLJ2aOXetUwm8hiaoHC0lYHm+888lzlL
        N0xCwpSrICer4U6mFyYN4A6tqSj/urnIMIig/5rwW+Pkdwd5URNTypVn7I1vKQkjQ+W270
        xL93chWxDIP3sM5Ac87CvH9ilnLCss/tZKjCSFgHLYu1A4yhXrHHZWRUD7hWzGy4VoZJhp
        24WuQjAMvS5PanfWnsEZFy6x4auYRYBISbuU+Bni92ECnJFDrP8wQ1YAAb3Hvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597313495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zt7T8B80Wzzn5EaRMNRRGT8rmn9Iua7ORS/7xToxj6A=;
        b=UjZfb0hO5ibmSxHP4Zm0BPUJiWMT7lgw3ymYW16ppTslnHZnm2ShBEVKRQMQbdeuwEdNi4
        GfjRNxsNVXQBEXCA==
To:     Jonathan Adams <jwadams@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq information through metricfs
In-Reply-To: <20200807212916.2883031-7-jwadams@google.com>
References: <20200807212916.2883031-1-jwadams@google.com> <20200807212916.2883031-7-jwadams@google.com>
Date:   Thu, 13 Aug 2020 12:11:35 +0200
Message-ID: <87mu2yluso.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Adams <jwadams@google.com> writes:

How is that related to core? The x86 subsys prefix is 'x86' and for this
particular thing it's 'x86/irq:'. That applies to the rest of the series
as well. 

> Add metricfs support for displaying percpu irq counters for x86.
> The top directory is /sys/kernel/debug/metricfs/irq_x86.
> Then there is a subdirectory for each x86-specific irq counter.
> For example:
>
>    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values

What is 'TLB'? I'm not aware of any vector which is named TLB.

The changelog is pretty useless in providing any form of rationale for
this. It tells the WHAT, but not the WHY.

Also what is does this file contain? Aggregates, one line per CPU or the
value of the random CPU of the day? I'm not going to dive into the macro
zoo to figure that out.

> jwadams@google.com: rebased to 5.8-pre6
> 	This is work originally done by another engineer at
> 	google, who would rather not have their name associated with
> 	this patchset. They're okay with me sending it under my name.

I can understand why they wont have their name associated with this.

> +#ifdef CONFIG_METRICFS
> +METRICFS_ITEM(NMI, __nmi_count, "Non-maskable interrupts");
> +#ifdef CONFIG_X86_LOCAL_APIC
> +METRICFS_ITEM(LOC, apic_timer_irqs, "Local timer interrupts");
> +METRICFS_ITEM(SPU, irq_spurious_count, "Spurious interrupts");
> +METRICFS_ITEM(PMI, apic_perf_irqs, "Performance monitoring interrupts");
> +METRICFS_ITEM(IWI, apic_irq_work_irqs, "IRQ work interrupts");
> +METRICFS_ITEM(RTR, icr_read_retry_count, "APIC ICR read retries");
> +#endif
....

So you are adding NR_CPUS * NR_DIRECT_VECTORS debugfs files which show
exactly the same information as /proc/interrupts, right? 

Aside of that _all_ of this information is available via tracepoints as
well.

That's NR_CPUS * 15 and incomplete because x86 has 23 of those directly
handled vectors which do not go through the irq core. So with just 15
and 256 CPUs that's 3840 files.

Impressive number especially without any information why this is useful
and provides value over the existing mechanisms to retrieve exactly the
same information.

The cover letter talks a lot about who Google finds this useful, but
that's not really a convincing argument for this metric failsystem
addon.

Thanks,

        tglx



