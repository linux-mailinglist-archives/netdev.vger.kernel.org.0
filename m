Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0676B134611
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgAHPYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 10:24:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50383 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHPYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 10:24:14 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ipDB8-0001aV-Vt; Wed, 08 Jan 2020 16:23:27 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C48DA1060B2; Wed,  8 Jan 2020 16:23:25 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anchal Agarwal <anchalag@amazon.com>, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        anchalag@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        fllinden@amaozn.com
Cc:     anchalag@amazon.com
Subject: Re: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during shutdown PIRQs
In-Reply-To: <20200107234420.GA18738@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107234420.GA18738@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Date:   Wed, 08 Jan 2020 16:23:25 +0100
Message-ID: <877e22ezv6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anchal Agarwal <anchalag@amazon.com> writes:

> shutdown_pirq is invoked during hibernation path and hence
> PIRQs should be restarted during resume.
> Before this commit'020db9d3c1dc0a' xen/events: Fix interrupt lost
> during irq_disable and irq_enable startup_pirq was automatically
> called during irq_enable however, after this commit pirq's did not
> get explicitly started once resumed from hibernation.
>
> chip->irq_startup is called only if IRQD_IRQ_STARTED is unset during
> irq_startup on resume. This flag gets cleared by free_irq->irq_shutdown
> during suspend. free_irq() never gets explicitly called for ioapic-edge
> and ioapic-level interrupts as respective drivers do nothing during
> suspend/resume. So we shut them down explicitly in the first place in
> syscore_suspend path to clear IRQ<>event channel mapping. shutdown_pirq
> being called explicitly during suspend does not clear this flags, hence
> .irq_enable is called in irq_startup during resume instead and pirq's
> never start up.

What? 

> +void irq_state_clr_started(struct irq_desc *desc)
>  {
>  	irqd_clear(&desc->irq_data, IRQD_IRQ_STARTED);
>  }
> +EXPORT_SYMBOL_GPL(irq_state_clr_started);

This is core internal state and not supposed to be fiddled with by
drivers.

irq_chip has irq_suspend/resume/pm_shutdown callbacks for a reason.

Thanks,

       tglx
