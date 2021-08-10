Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE53E5CA4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbhHJONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbhHJONS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:13:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEBFC0613C1;
        Tue, 10 Aug 2021 07:12:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628604774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TiJmA3POi9FctASNMfUPbhLh0CEUmHRjBKpCXOyY61A=;
        b=xw6VoRMG1YZcz3aozL3rahY9dAgQCn2l2vSKWQ7AJbhWgF1WEQElAieDb5A4aNl7402Qsz
        18wBjGzofgKkIqVGF+Am6JDlxKcY14fJ3VnQ7kCgJ/LW5gmusLivzK/5hG4ULV1FCkbt32
        ASnzYiElDNcoKLgD5q2H3d3Ikg1jC2+5R0TKlTcc1vHHCD1QCr/MduHydq3d01zGmQP+ml
        UprbxgVqN/3BuDNKcJNe3ICWt4W27vwS1AJ7rptufqF+2dXIm5bfE0QsnPIXt/os19v67K
        FSFbIsYZDqDc6z8mH42Q/O0UpznkQmgwfK66EF8aptdUuausjNFyFXHySKiPXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628604774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TiJmA3POi9FctASNMfUPbhLh0CEUmHRjBKpCXOyY61A=;
        b=GQvIEL30+f0CmUBjLBwLCPb4AcR0xsmoX9poarHYh0pPPFV7tZGOlFa5JPgHk3z0qSKufX
        HAUHoYCIkXRo0NDA==
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Nitesh Lal <nilal@redhat.com>
Subject: Re: [RFC] genirq: Add effective CPU index retrieving interface
In-Reply-To: <YL3LrgAzMNI2hp5i@syu-laptop>
References: <YL3LrgAzMNI2hp5i@syu-laptop>
Date:   Tue, 10 Aug 2021 16:12:53 +0200
Message-ID: <874kbxs80q.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07 2021 at 15:33, Shung-Hsi Yu wrote:
> Most driver's IRQ spreading scheme is naive compared to the IRQ spreading
> scheme introduced since IRQ subsystem rework, so it better to rely
> request_irq() to spread IRQ out.
>
> However, drivers that care about performance enough also tends to try
> allocating memory on the same NUMA node on which the IRQ handler will run.
> For such driver to rely on request_irq() for IRQ spreading, we also need to
> provide an interface to retrieve the CPU index after calling
> request_irq().

So if you are interested in the resulting NUMA node, then why exposing a
random CPU out of the affinity mask instead of exposing a function to
retrieve the NUMA node?
  
> +/**
> + * irq_get_effective_cpu - Retrieve the effective CPU index
> + * @irq:	Target interrupt to retrieve effective CPU index
> + *
> + * When the effective affinity cpumask has multiple CPU toggled, it just
> + * returns the first CPU in the cpumask.
> + */
> +int irq_get_effective_cpu(unsigned int irq)
> +{
> +	struct irq_data *data = irq_get_irq_data(irq);

This can be NULL.

> +	struct cpumask *m;
> +
> +	m = irq_data_get_effective_affinity_mask(data);
> +	return cpumask_first(m);
> +}

Thanks,

        tglx
